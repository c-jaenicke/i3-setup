#!/usr/bin/env bash
# This script sets some apps as default apps using xdg-mime

set -e
set -u
set -o pipefail

printf "##### set-default-apps.sh: Attempting to set thunar as default file browser\n"
if [[ -z "$(which thunar)" ]]; then
    printf "##### set-default-apps.sh: Cant find thunar executable, are you sure its installed?\n"
    exit 1
else
    xdg-mime default thunar.desktop inode/directory
    printf "##### set-default-apps.sh: Thunar successfully set as default file browser\n"
fi


printf "##### set-default-apps.sh: Attempting to set zen browser as default browser\n"
if [[ -z "$(which thunar)" ]]; then
    printf "##### set-default-apps.sh: Cant find thunar executable, are you sure its installed?\n"
    exit 1
else
    xdg-mime default app.zen_browser.zen.desktop x-scheme-handler/http x-scheme-handler/https text/html
    printf "##### set-default-apps.sh: Zen browser successfully set as default browser\n"
fi
