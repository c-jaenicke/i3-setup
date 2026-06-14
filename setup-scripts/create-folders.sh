#!/usr/bin/env bash
# This script creates a number of base folders in the users home.

set -e
set -u
set -o pipefail

printf "##### create-folders.sh: Creating folders in home directory.\n"

folders=(
    ".bin"
    ".config"
    ".ssh"
    "Backups"
    "Containers"
    "GitHub"
    "Nextcloud"
    "NextcloudU"
    "Projekte"
    "Scan"
    "Scratch-Files"
    "Scripts"
    "VMs"
    "VMs/ISOs"
    "VMs/SHARE"
)

for folder in "${folders[@]}"; do
    printf "##### create-folders.sh: Creating folder: %s\n" "$folder"
    mkdir -p "$HOME/$folder"
done

printf "##### create-folders.sh: Folder creation completed!\n"
