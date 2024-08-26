#!/usr/bin/env bash
# script for creating folder structure in home dir

printf "##### Creating folders\n"
folders=("Backups" "Docker" "GitHub" "NextCloud" "NextCloudU" "Projekte" "Scan" "Scratch-Files" "Scripts" "VMs")
for folder in "${folders[@]}"; do
    printf "##### Creating folder $folder\n"
    mkdir -p "$HOME/$folder"
done
printf "##### DONE creating folders\n"
