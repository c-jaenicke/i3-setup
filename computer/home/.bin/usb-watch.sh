#!/usr/bin/env bash
# Diffs currently connected USB devices against a saved baseline to spot
# devices plugged in (or removed) since. Bus/device numbers are stripped
# before comparing since those get reassigned on reconnect/reboot even for
# the same physical device.

set -euo pipefail

STATE_DIR="$HOME/.cache/usb-watch"
STATE_FILE="$STATE_DIR/baseline"

mkdir -p "$STATE_DIR"

current_devices() {
    lsusb | sed -E 's/^Bus [0-9]+ Device [0-9]+: //' | sort
}

save_baseline() {
    current_devices >"$STATE_FILE"
    printf "Baseline saved (%d devices).\n" "$(wc -l <"$STATE_FILE")"
}

check_once() {
    if [ ! -f "$STATE_FILE" ]; then
        printf "No baseline yet, run '%s baseline' first.\n" "$(basename "$0")" >&2
        exit 1
    fi

    local current added removed
    current="$(current_devices)"
    added="$(comm -13 "$STATE_FILE" <(printf "%s\n" "$current"))"
    removed="$(comm -23 "$STATE_FILE" <(printf "%s\n" "$current"))"

    if [ -n "$added" ]; then
        printf "##### New USB devices:\n%s\n" "$added"
    fi
    if [ -n "$removed" ]; then
        printf "##### Removed USB devices:\n%s\n" "$removed"
    fi
    if [ -z "$added" ] && [ -z "$removed" ]; then
        printf "No changes since baseline.\n"
    fi
}

watch_loop() {
    local interval="${1:-5}"
    [ -f "$STATE_FILE" ] || save_baseline
    printf "Watching for USB changes every %ss (Ctrl+C to stop)...\n" "$interval"

    while true; do
        sleep "$interval"
        local current added removed
        current="$(current_devices)"
        added="$(comm -13 "$STATE_FILE" <(printf "%s\n" "$current"))"
        removed="$(comm -23 "$STATE_FILE" <(printf "%s\n" "$current"))"

        if [ -n "$added" ]; then
            while IFS= read -r dev; do
                printf "##### Plugged in: %s\n" "$dev"
                command -v notify-send >/dev/null 2>&1 && notify-send "USB device connected" "$dev"
            done <<<"$added"
        fi
        if [ -n "$removed" ]; then
            while IFS= read -r dev; do
                printf "##### Removed: %s\n" "$dev"
                command -v notify-send >/dev/null 2>&1 && notify-send "USB device removed" "$dev"
            done <<<"$removed"
        fi

        printf "%s\n" "$current" >"$STATE_FILE"
    done
}

case "${1:-check}" in
baseline)
    save_baseline
    ;;
check)
    check_once
    ;;
watch)
    watch_loop "${2:-5}"
    ;;
*)
    printf "Usage: %s {baseline|check|watch [interval_seconds]}\n" "$(basename "$0")"
    exit 1
    ;;
esac
