#!/usr/bin/env bash
printf "##### Copying bin folder\n"
mkdir "$HOME/.bin"
#cd "$current_directory" || printf "##### Failed to cd into repo dir" && exit
cp ../.bin ~
printf "##### Copied bin folder\n"