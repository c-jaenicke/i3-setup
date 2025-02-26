#!/usr/bin/env bash
# Script for copying full shell config files, including plugins

set -e
set -u
set -o pipefail

printf "##### Copying full shell config files\n"

cp "$(pwd)/../.zshrc" "$HOME/"
cp "$(pwd)/../.bashrc" "$HOME/"
cp "$(pwd)/../.shell_aliases.sh" "$HOME/"
cp "$(pwd)/../.shell_functions.sh" "$HOME/"

printf "##### DONE copying full shell configs\n"

