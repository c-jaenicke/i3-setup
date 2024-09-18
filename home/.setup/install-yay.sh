#!/usr/bin/env bash
# script for automatic installation of yay AUR helper
# https://github.com/Jguer/yay

printf "##### Installing yay\n"
# install dependencies

printf "## Installing dependencies for yay installation (git, base-devel, wget, curl)\n"
sudo pacman -S --needed git base-devel wget curl
printf "## DONE installing yay dependencies\n"

# create and download into temporary directory
mkdir -p /tmp/yay
cd "/tmp/yay" || printf "Failed to cd into /tmp/yay"
git clone https://aur.archlinux.org/yay.git
cd "yay" || printf "Failed to cd into /tmp/yay/yay"

# install yay
makepkg -si

# cleanup
rm -drf /tmp/yay

printf "##### DONE installing yay \n"
