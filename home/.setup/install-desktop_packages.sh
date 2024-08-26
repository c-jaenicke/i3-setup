#!/usr/bin/env bash
# script for installing packages needed for simple desktop setup

# ask user to confirm, continue if yes, exit if no
confirm_action () {
    read -p "$1 [y/n] " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        return
    else
        exit
    fi
}

# ARCH, install packages
install_arch_packages () {
    printf "##### Installing arch packages\n"
    bash install-yay.sh
    yay -Syu \
    alacritty \
    base-devel \
    curl \
    dunst \
    feh \
    flameshot \
    git \
    i3lock \
    i3-wm \
    light \
    neovim \
    picom \
    polybar \
    rofi \
    starship \
    ttf-ibm-plex \
    wget \
    xautolock \
    zsh
 
    printf "##### DONE\n"
}

printf "########## Starting script to install desktop packages!\n########## This might install a lot of packages!\n"
confirm_action "########## Are you sure you want to continue?"
install_arch_packages

printf "########## Script done\n"
