#!/usr/bin/env bash
# Script for creating a folder structure in the home directory

set -e
set -u
set -o pipefail

printf "##### Creating folders\n"

folders=(
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
    printf "##### Creating folder: %s #####\n" "$folder"
    mkdir -p "$HOME/$folder"
done

printf "##### Folder creation completed\n"

