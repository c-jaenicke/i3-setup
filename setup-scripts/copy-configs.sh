#!/usr/bin/env bash
# This script copies all config files of this repo into the users home.

set -e
set -u
set -o pipefail

printf "##### copy-configs.sh: Copying config files to home directory.\n"

cp -r "$(pwd)/../home/.bashrc" "$HOME/"
cp -r "$(pwd)/../home/.shell_aliases.sh" "$HOME/"
cp -r "$(pwd)/../home/.shell_functions.sh" "$HOME/"
cp -r "$(pwd)/../home/.vimrc" "$HOME/"
cp -r "$(pwd)/../home/.Xdefaults" "$HOME/"
cp -r "$(pwd)/../home/.Xresources" "$HOME/"
cp -r "$(pwd)/../home/.zprofile" "$HOME/"
cp -r "$(pwd)/../home/.zshrc" "$HOME/"

cp -r "$(pwd)/../home/.config" "$HOME/"

printf "##### copy-configs.sh: Done copying config files!\n"
