#!/usr/bin/env bash
# This script copies all config files of this repo into the users home.

set -e
set -u
set -o pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

printf "##### copy-configs.sh: Copying config files to home directory.\n"

cp -r "$SCRIPT_DIR/../computer/home/.bashrc" "$HOME/"
cp -r "$SCRIPT_DIR/../computer/home/.shell_aliases.sh" "$HOME/"
cp -r "$SCRIPT_DIR/../computer/home/.shell_functions.sh" "$HOME/"
cp -r "$SCRIPT_DIR/../computer/home/.vimrc" "$HOME/"
cp -r "$SCRIPT_DIR/../computer/home/.Xdefaults" "$HOME/"
cp -r "$SCRIPT_DIR/../computer/home/.Xresources" "$HOME/"
cp -r "$SCRIPT_DIR/../computer/home/.zprofile" "$HOME/"
cp -r "$SCRIPT_DIR/../computer/home/.zshrc" "$HOME/"

cp -r "$SCRIPT_DIR/../computer/home/.config" "$HOME/"

printf "##### copy-configs.sh: Done copying config files!\n"
