#!/usr/bin/env bash
# script for copying all config files into user config directory

printf "##### Copying config files\n"
mkdir -p "$HOME/.config"
cp -r "../.config/" "$HOME/"
printf "##### DONE copying config files\n"
