#!/usr/bin/env bash
# This script installs the yay AUR helper.

set -e
set -u
set -o pipefail

install_yay() {
    printf "##### install-yay.sh: Installing yay AUR helper.\n"
    
    # Install dependencies
    sudo pacman -Sy --needed --noconfirm git base-devel
    
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    git clone https://aur.archlinux.org/yay-bin.git || {
        printf "##### install-yay.sh: Failed to clone yay repository!\n"
        exit 1
    }
    
    cd yay-bin
    makepkg -si --noconfirm || {
        printf "##### install-yay.sh: Failed to build and install!\n"
        exit 1
    }
    
    cd ~
    rm -rf "$temp_dir"
    
    printf "##### install-yay.sh: yay installed successfully!\n"
}

install_yay
