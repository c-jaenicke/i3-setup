#!/usr/bin/env bash
# This script copies all files in the .bin folder of this repo into the users home.

set -e
set -u
set -o pipefail

printf "##### copy-bin.sh: Copying .bin folder.\n"

cp -r "$(pwd)/../home/.bin" "$HOME/"

printf "##### copy-bin.sh: Done copying .bin folder!\n"
