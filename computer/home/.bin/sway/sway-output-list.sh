#!/usr/bin/env bash
# Script to list all connected outputs/monitors in a readable table, showing
# name, resolution, position, scale, active state, current workspace, make
# and model -- useful for figuring out names/positions when writing sway
# "output" rules.

if ! command -v "jq" >/dev/null 2>&1; then
    echo "The jq command could not be found! Please install the jq package."
    exit 1
fi

JQ_ROW='[
    .name,
    ((.current_mode.width|tostring) + "x" + (.current_mode.height|tostring) + "@" + ((.current_mode.refresh/1000)|tostring) + "Hz"),
    ((.rect.x|tostring) + "," + (.rect.y|tostring)),
    (.scale|tostring),
    (.active|tostring),
    (.current_workspace // "-"),
    (.make + " " + .model)
]'

case $1 in
rules)
    swaymsg -t get_outputs | jq -r '.[] |
        "output \"" + .name + "\" resolution " + (.current_mode.width|tostring) + "x" + (.current_mode.height|tostring)
        + " position " + (.rect.x|tostring) + "," + (.rect.y|tostring)
        + " scale " + (.scale|tostring)
        + "  # " + .make + " " + .model'
    ;;
*)
    {
        printf "NAME\tRESOLUTION\tPOSITION\tSCALE\tACTIVE\tWORKSPACE\tMAKE/MODEL\n"
        swaymsg -t get_outputs | jq -r ".[] | $JQ_ROW | @tsv"
    } | column -t -s $'\t'
    ;;
esac
