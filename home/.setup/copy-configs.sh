#!/usr/bin/env bash
printf "##### Copying config files\n"
#cd "$current_directory" || printf "##### Failed to cd into repo dir" && exit
mkdir -p "$HOME/.config"
cp -r "../.config/" "$HOME/"
printf "##### Copied config files\n"
