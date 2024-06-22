#!/usr/bin/env bash
printf "##### Installing yay\n"
pacman -S --needed git base-devel wget curl
mkdir /tmp/yay
cd "/tmp/yay" || printf "Failed to cd into /tmp/yay" && exit
git clone https://aur.archlinux.org/yay.git
cd "yay" || printf "Failed to cd into /tmp/yay/yay" && exit
makepkg -si
rm -drf /tmp/yay
printf "##### Yay has been installed\n"