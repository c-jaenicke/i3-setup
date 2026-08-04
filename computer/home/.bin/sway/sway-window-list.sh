#!/usr/bin/env bash
# Script to list all currently running windows in a readable table, showing
# workspace, app_id/class, instance, title and pid -- useful for figuring out
# window criteria when writing sway "for_window" rules.

if ! command -v "jq" >/dev/null 2>&1; then
    echo "The jq command could not be found! Please install the jq package."
    exit 1
fi

JQ_WALK='
def walk(ws):
  ((.nodes // []) + (.floating_nodes // [])) as $children
  | (if .type == "workspace" then .name else ws end) as $ws
  | (if .pid then
      [{ws: $ws, class: (.window_properties.class // .app_id), instance: .window_properties.instance, app_id: .app_id, title: .name, pid: .pid}]
    else [] end)
    + ($children | map(walk($ws)) | add // [])
;
walk(null)[]
'

case $1 in
rules)
    swaymsg -t get_tree | jq -r "$JQ_WALK"' |
        "for_window [app_id=\"" + (.app_id // .class // "") + "\"] move to workspace " + .ws + "  # " + .title'
    ;;
*)
    {
        printf "WORKSPACE\tAPP_ID/CLASS\tINSTANCE\tTITLE\tPID\n"
        swaymsg -t get_tree | jq -r "$JQ_WALK"' | [.ws, (.app_id // .class // ""), (.instance // ""), .title, (.pid|tostring)] | @tsv'
    } | column -t -s $'\t'
    ;;
esac
