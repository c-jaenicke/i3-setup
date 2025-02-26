#!/usr/bin/env bash
# Script to install yay AUR helper
# ONLY ARCH LINUX AND ARCH-BASED

set -e
set -u
set -o pipefail

install_yay() {
    printf "##### Installing yay AUR helper \n"

    # Install dependencies
    sudo pacman -Sy --needed --noconfirm git base-devel

    temp_dir=$(mktemp -d)
    cd "$temp_dir"

    git clone https://aur.archlinux.org/yay-bin.git || {
        printf "##### Failed to clone yay repository\n"
        exit 1
    }

    cd yay-bin
    makepkg -si --noconfirm || {
        printf "##### Failed to build and install yay\n"
        exit 1
    }

    cd ~
    rm -rf "$temp_dir"

    printf "##### yay installed successfully\n"
}

install_yay

