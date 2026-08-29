#!/usr/bin/env bash
# Parses ~/.config/sway/config for bindsym lines and shows them in rofi as a
# quick cheat-sheet, with $mod / $ws* variables resolved to their values.

set -euo pipefail

CONFIG="${1:-$HOME/.config/sway/config}"

if [ ! -f "$CONFIG" ]; then
    echo "Sway config not found: $CONFIG" >&2
    exit 1
fi

awk '
    # Record `set $name value` variables so bindsym lines can be resolved.
    /^[[:space:]]*set[[:space:]]+\$[A-Za-z0-9_]+/ {
        line = $0
        sub(/^[[:space:]]*set[[:space:]]+/, "", line)
        split(line, parts, /[[:space:]]+/)
        name = parts[1]
        value = line
        sub(/^\$[A-Za-z0-9_]+[[:space:]]+/, "", value)
        gsub(/"/, "", value)
        vars[name] = value
        next
    }

    # Only real (uncommented) bindsym lines.
    /^[[:space:]]*bindsym[[:space:]]+/ {
        line = $0
        sub(/^[[:space:]]*bindsym[[:space:]]+/, "", line)
        keys = line
        sub(/[[:space:]].*/, "", keys)
        cmd = line
        sub(/^[^[:space:]]+[[:space:]]+/, "", cmd)

        for (v in vars) {
            gsub("\\$" v, vars[v], keys)
            gsub("\\$" v, vars[v], cmd)
        }

        printf "%-30s %s\n", keys, cmd
    }
' "$CONFIG" | rofi -dmenu -i -p "Sway keybindings" -no-custom -theme-str 'listview { columns: 1; }'
