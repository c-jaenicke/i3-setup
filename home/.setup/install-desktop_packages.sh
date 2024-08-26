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
    confirm_action "##### Are you sure you want to continue?"
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
    wget \
    xautolock \
    zsh
 
    printf "##### DONE\n"
}

# DEBIAN, install starship
install_starship () {
    confirm_action "##### Are you sure you want to continue?"
    # https://starship.rs/guide/#%F0%9F%9A%80-installation
    printf "##### Installing starship packages\n"
    curl -sS https://starship.rs/install.sh | sh

    printf "##### DONE\n"
}

# DEBIAN, install packages
install_debian_packages () {
    printf "##### Installing debian packages\n"
    confirm_action "##### Are you sure you want to continue?"
    sudo apt update
    sudo apt install \
    alacritty \
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
    wget \
    xautolock \
    zsh
 
    printf "##### DONE\n"
}

printf "########## Starting script to install desktop packages for system %s!\n########## This might install a lot of packages!\n" "$1"

case $1 in
    arch)
        install_arch_packages
        ;;

    debian)
        install_debian_packages
        install_starship
        ;;

    *)
        printf "$ install-desktop_packages.sh [arch | debian]\n"
        ;;
esac

printf "########## Script done\n"
