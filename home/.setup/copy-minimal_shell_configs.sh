#!/usr/bin/env bash
# script for copying minminal shell configs, should work on any system

printf "##### Copying minimal shell config files\n"
cp ".zshrc" "$HOME"
cp ".bashrc" "$HOME"
cp ".vimrc" "$HOME"
printf "##### DONE copying full shell configs\n"
