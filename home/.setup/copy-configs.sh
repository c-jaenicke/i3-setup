#!/usr/bin/env bash
printf "##### Copying config files\n"
#cd "$current_directory" || printf "##### Failed to cd into repo dir" && exit
mkdir "$HOME/.config"
cp -r "../.config/*" "$HOME/.config/"
printf "##### Copied config files\n"