#!/usr/bin/env bash
# Script for copying minimal shell config files

set -e
set -u
set -o pipefail

printf "##### Copying minimal shell config files\n"

cp "$(pwd)/.zshrc" "$HOME/"
cp "$(pwd)/.bashrc" "$HOME/"
cp "$(pwd)/.vimrc" "$HOME/"

printf "##### DONE copying minimal shell configs\n"

