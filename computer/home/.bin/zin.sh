#!/usr/bin/env bash
# Wrapper around `zypper install` that records what was actually installed
# (including pulled-in dependencies) and why, since zypper itself only keeps
# an undifferentiated transaction log at /var/log/zypp/history.
#
# Usage:
#   zin -r "reason for installing" <package> [<package> ...]
#
# Log:
#   ~/.local/share/zin/log  (one entry per install, newest last)

set -euo pipefail

LOG_DIR="$HOME/.local/share/zin"
LOG_FILE="$LOG_DIR/log"

reason=""
while getopts ":r:" opt; do
    case "$opt" in
        r) reason="$OPTARG" ;;
        *) echo "Usage: zin -r \"reason\" <package> [<package> ...]" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

if [ "$#" -eq 0 ]; then
    echo "Usage: zin -r \"reason\" <package> [<package> ...]" >&2
    exit 1
fi

if [ -z "$reason" ]; then
    read -rp "Reason for installing $*: " reason
fi

mkdir -p "$LOG_DIR"

before="$(mktemp)"
after="$(mktemp)"
trap 'rm -f "$before" "$after"' EXIT

rpm -qa --qf '%{NAME}\n' | sort >"$before"

sudo zypper install "$@"

rpm -qa --qf '%{NAME}\n' | sort >"$after"

new_packages="$(comm -13 "$before" "$after")"

{
    printf '## %s\n' "$(date -Iseconds)"
    printf 'requested: %s\n' "$*"
    printf 'reason: %s\n' "$reason"
    if [ -n "$new_packages" ]; then
        printf 'installed:\n'
        printf '  %s\n' $new_packages
    else
        printf 'installed: (none -- already present or install failed)\n'
    fi
    printf '\n'
} >>"$LOG_FILE"

echo "Logged to $LOG_FILE"
