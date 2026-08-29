#!/usr/bin/env bash
# Helper for managing multiple WireGuard tunnels (wg-quick@<name>.service)
# without having to remember interface names. Configs are discovered from
# /etc/wireguard/*.conf.

set -euo pipefail

WG_DIR="/etc/wireguard"

list_configs() {
    local f
    for f in "$WG_DIR"/*.conf; do
        [ -e "$f" ] || continue
        basename "$f" .conf
    done
}

active_configs() {
    sudo wg show interfaces 2>/dev/null
}

is_active() {
    local name="$1" active
    active="$(active_configs)"
    [[ " $active " == *" $name "* ]]
}

# Shows a picker: fzf in a terminal, rofi otherwise (e.g. launched from a
# sway keybinding with no tty attached). Prints the chosen config name.
pick_config() {
    local configs annotated name active

    configs="$(list_configs)"
    if [ -z "$configs" ]; then
        echo "No WireGuard configs found in $WG_DIR" >&2
        exit 1
    fi

    active="$(active_configs)"
    annotated=$(while IFS= read -r name; do
        if [[ " $active " == *" $name "* ]]; then
            printf "%s (active)\n" "$name"
        else
            printf "%s\n" "$name"
        fi
    done <<<"$configs")

    if [ -t 0 ]; then
        printf "%s\n" "$annotated" | fzf --prompt="WireGuard> " --height=~40% | awk '{print $1}'
    else
        printf "%s\n" "$annotated" | rofi -dmenu -i -p "WireGuard" | awk '{print $1}'
    fi
}

ALLOWED_COMMANDS="select switch start stop status list"
cmd="${1:-select}"
if [[ ! $ALLOWED_COMMANDS =~ (^|[[:space:]])"$cmd"($|[[:space:]]) ]]; then
    printf "Error: Invalid command '%s'. Use: select, switch, start, stop, status, or list.\n" "$cmd"
    exit 1
fi

case "$cmd" in
list)
    list_configs
    ;;
status)
    sudo wg show
    ;;
start)
    name="${2:-$(pick_config)}"
    [ -n "$name" ] || exit 1
    sudo systemctl start "wg-quick@${name}.service"
    ;;
stop)
    name="${2:-$(pick_config)}"
    [ -n "$name" ] || exit 1
    sudo systemctl stop "wg-quick@${name}.service"
    ;;
switch | select)
    name="${2:-$(pick_config)}"
    [ -n "$name" ] || exit 1
    for active in $(active_configs); do
        [ "$active" = "$name" ] && continue
        sudo systemctl stop "wg-quick@${active}.service"
    done
    is_active "$name" || sudo systemctl start "wg-quick@${name}.service"
    ;;
esac
