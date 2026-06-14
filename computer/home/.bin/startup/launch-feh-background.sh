#!/usr/bin/env bash
# script for setting the backgroudn using feh
# if feh exists, and image exists, set image
# else set background to basic gray
if command -v feh &> /dev/null; then
    image="$HOME/Bilder/Hintergrund/Widescreen/7.jpg"
    if [[ -e $image ]]; then
        feh --bg-center "$image" &
    else
        feh --bg-tile "$HOME/.bin/startup/green.png" &
    fi
else
    xsetroot -solid "#424b55" &
fi
