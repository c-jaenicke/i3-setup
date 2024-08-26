#!/usr/bin/env bash
# script to copy all files and folders in home/.bin to user bin

printf "##### Copying bin folder\n"
mkdir -p "$HOME/.bin"
cp -r ../.bin ~
printf "##### DONE copying bin folder\n"
