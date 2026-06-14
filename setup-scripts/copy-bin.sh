#!/usr/bin/env bash
# This script copies all files in the .bin folder of this repo into the users home.

set -e
set -u
set -o pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

printf "##### copy-bin.sh: Copying .bin folder.\n"

cp -r "$SCRIPT_DIR/../computer/home/.bin" "$HOME/"

printf "##### copy-bin.sh: Done copying .bin folder!\n"
