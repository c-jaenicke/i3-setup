#!/usr/bin/env bash
printf "##### Copying full shell config files\n"
#cd "$current_directory" || printf "##### Failed to cd into repo dir" && exit
cp "../.zshrc" "$HOME"
cp "../.bashrc" "$HOME"
cp "../.shell_aliases.sh" "$HOME"
cp "../.shell_functions.sh" "$HOME"
printf "##### Copied full shell configs\n"