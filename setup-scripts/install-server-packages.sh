#!/usr/bin/env bash
# This script installs the necessary packages for a base server environment.

set -e
set -u
set -o pipefail

install_arch_packages() {
    printf "##### Installing Arch packages\n"
    
    local packages=(
        base-devel curl git neovim tmux wget zsh
    )
    
    sudo pacman -Syu --noconfirm "${packages[@]}"
    
    printf "##### Arch packages installed successfully\n"
}

install_debian_packages() {
    printf "##### Installing Debian packages\n"
    
    sudo apt update
    
    local packages=(
        build-essential curl git neovim tmux wget zsh
    )
    
    sudo apt install -y "${packages[@]}" || {
        printf "##### Package installation failed\n"
        exit 1
    }
    
    printf "##### Debian packages installed successfully\n"
}

printf "##### Starting script to set up server environment\n"
printf "##### This might install a lot of packages #####\n"

if [[ $# -ne 1 ]]; then
    printf "##### Usage: install-server-packages.sh [arch | debian]\n"
    exit 1
fi

case "$1" in
    arch)
        install_arch_packages
    ;;
    debian)
        install_debian_packages
    ;;
    *)
        printf "##### Usage: install-server-packages.sh [arch | debian]\n"
        exit 1
    ;;
esac
