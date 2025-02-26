#!/usr/bin/env bash
# Script for copying all config files into the users config directory

set -e
set -u
set -o pipefail

printf "##### Copying config files to home directory\n"

mkdir -p "$HOME/.config"

cp -r "$(pwd)/../.config/" "$HOME/"

printf "##### DONE copying config files\n"

