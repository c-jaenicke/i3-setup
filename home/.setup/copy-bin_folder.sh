#!/usr/bin/env bash
printf "##### Copying bin folder\n"
mkdir -p "$HOME/.bin"
#cd "$current_directory" || printf "##### Failed to cd into repo dir" && exit
cp -r ../.bin ~
printf "##### Copied bin folder\n"
