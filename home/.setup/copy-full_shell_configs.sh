#!/usr/bin/env bash
# script for copying full shell configs, meaning shells with plugins

printf "##### Copying full shell config files\n"
cp "../.zshrc" "$HOME"
cp "../.bashrc" "$HOME"
cp "../.shell_aliases.sh" "$HOME"
cp "../.shell_functions.sh" "$HOME"
printf "##### DONE copying full shell configs\n"
