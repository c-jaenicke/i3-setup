#!/usr/bin/env bash
# Script for installing packages needed for a desktop setup

set -e
set -u
set -o pipefail

install_arch_packages() {
    printf "##### Running install-yay.sh\n"
    bash "$(pwd)/install-yay.sh"

    printf "##### Installing Arch packages\n"

    local packages=(
        alacritty base-devel curl dunst feh flameshot git neovim wget zsh
        wayland wayland-protocols wayland-utils sway swaybg swayidle swaylock
        waybar brightnessctl rofi-wayland kanshi apparmor bubblewrap wl-clipboard
    )

    yay -Syu --noconfirm "${packages[@]}"

    printf "##### Arch packages installed successfully\n"
}

install_debian_packages() {
    printf "##### Installing Debian packages\n"

    sudo apt update

    local packages=(
        alacritty curl dunst feh flameshot git i3lock i3-wm light neovim
        picom polybar rofi wget xautolock zsh
    )

    sudo apt install -y "${packages[@]}" || {
        printf "##### Package installation failed\n"
        exit 1
    }

    printf "##### Debian packages installed successfully\n"
}

printf "##### Starting script to install desktop packages\n"
printf "##### This might install a lot of packages\n"

if [[ $# -ne 1 ]]; then
    printf "##### Usage: install-desktop-packages.sh [arch | debian]\n"
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
        printf "##### Usage: install-desktop-packages.sh [arch | debian]\n"
        exit 1
        ;;
esac

