#!/usr/bin/env bash
# script for taking screenshots using flameshot

date=$(date +%Y-%m-%d)
path="$HOME/Bilder/Screenshots/"

cd "$path" || exit

# create folder with current date if not exists
if ! [ -d "$date" ]; then
    mkdir "$date"
fi


case $1 in
    region)
        flameshot gui --clipboard --path "./$date"
        #notify-send -a "Flameshot-Script" "Screenshot taken: $1" "Saved under $path/$date"
        ;;

    full)
        flameshot full --clipboard --path "./$date"
        ;;

    *)
        printf "flameshot-script [region | full]\n"
        ;;
esac

