#!/usr/bin/env bash
# Script to copy all files and folders in .bin to the users home .bin directory

set -e
set -u
set -o pipefail

printf "##### Copying .bin folder \n"

mkdir -p "$HOME/.bin"

cp -r "$(pwd)/../.bin" "$HOME/"

printf "##### DONE copying .bin folder\n"

