#!/usr/bin/env bash
printf "##### Copying full shell config files\n"
#cd "$current_directory" || printf "##### Failed to cd into repo dir" && exit
cp "../.zshrc" "$HOME"
cp "../.bashrc" "$HOME"
printf "##### Copied full shell configs\n"