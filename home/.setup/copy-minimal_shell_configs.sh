#!/usr/bin/env bash
printf "##### Copying minimal shell config files\n"
#cd "$current_directory" || printf "##### Failed to cd into repo dir" && exit
cp ".zshrc" "$HOME"
cp ".bashrc" "$HOME"
cp ".vimrc" "$HOME"
printf "##### Copied full shell configs\n"