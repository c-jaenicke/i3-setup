#!/usr/bin/env bash
# Native Sway screenshot script using grim and slurp

date_folder=$(date +%Y-%m-%d)
timestamp=$(date +%H-%M-%S)
save_dir="$HOME/Bilder/Screenshots/$date_folder"
filename="Screenshot_${date_folder}_${timestamp}.png"
filepath="$save_dir/$filename"

mkdir -p "$save_dir"

case $1 in
    region)
        geometry=$(slurp)
        
        if [ -n "$geometry" ]; then
            grim -g "$geometry" - | tee "$filepath" | wl-copy
            notify-send "Screenshot Taken" "Region copied to clipboard and saved to $date_folder"
        fi
        ;;

    full)
        grim - | tee "$filepath" | wl-copy
        notify-send "Screenshot Taken" "Full screen copied to clipboard and saved to $date_folder"
        ;;

    *)
        printf "Usage: grim-screenshot [region | full]\n"
        ;;
esac
