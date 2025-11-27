#!/usr/bin/env bash
# This script installs the necessary packages for a base desktop environment.

set -e
set -u
set -o pipefail

install_arch_packages() {
    if [[ -z "$(yay --version)" ]]; then
        printf "##### install-desktop-packages.sh: Setup is missing yay. Installing yay.\n"
        bash "$(pwd)/install-yay.sh"
    fi
    
    printf "##### install-desktop-packages.sh: Installing packages for Arch linux desktop setup.\n"
    
    local packages=(
        alacritty
        apparmor
        base-devel
        brightnessctl
        curl
        dunst
        firefox
        flameshot
        gimp
        git
        gnupg
        google-chrome
        gvfs
        htop
        hunspell
        hunspell-de
        hunspell-en_us
        inkscape
        kanshi
        keepassxc
        kleopatra
        kwallet
        kwallet-pam
        kwalletmanager
        libreoffice-fresh
        libreoffice-fresh-de
        neovim
        nextcloud-client
        network-manager-applet
        openssh
        polkit-kde-agent
        rofi-wayland
        rxvt-unicode
        sway
        swaybg
        starship
        swayidle
        swaylock
        thunar
        thunar-archive-plugin
        thunar-volman
        thunderbird
        tlp
        tlpui
        tmux
        ttf-hack-nerd
        ttf-ibm-plex
        veracrypt
        waybar
        wayland
        wayland-protocols
        wayland-utils
        wget
        wireguard-tools
        wireshark-qt
        wl-clipboard
        xdg-desktop-portal
        xdg-desktop-portal-kde
        xdg-desktop-portal-wlr
        yubico-authenticator-bin
        zsh
    )
    
    confirm_install "${packages[@]}"
    
    yay -Syu --noconfirm "${packages[@]}"
    
    printf "##### install-desktop-packages.sh: Arch packages installed successfully.\n"
}

install_debian_packages() {
    if [[ -z "$(apt --version)" ]]; then
        printf "##### install-desktop-packages.sh: Cant execute apt, are you sure this is a debian/ubuntu/system that uses apt?\n"
        exit 1
    fi
    
    printf "##### install-desktop-packages.sh: Installing Debian packages\n"
    
    sudo apt update
    
    local packages=(
        alacritty
        curl
        dunst
        feh
        flameshot
        git
        i3lock
        i3-wm
        light
        neovim
        picom
        polybar
        rofi
        wget
        xautolock
        zsh
        cups
        cups-pdf
        firefox-esr
        gimp
        gnupg
        gvfs
        hunspell
        hunspell-de-de
        hunspell-en-us
        inkscape
        keepassxc
        kleopatra
        libreoffice
        openssh-server
        openssh-client
        qbittorrent
        rxvt-unicode
        starship
        sane
        skanlite
        texstudio
        thunar
        thunar-archive-plugin
        thunar-volman
        thunderbird
    )
    
    confirm_install "${packages[@]}"
    
    sudo apt install -y "${packages[@]}" || {
        printf "##### install-desktop-packages.sh: Package installation failed\n"
        exit 1
    }
    
    printf "##### install-desktop-packages.sh: Debian packages installed successfully\n"
}

confirm_install() {
    local packages=("$@")
    
    printf "##### install-desktop-packages.sh: The following %d packages are queued for installation:\n" "${#packages[@]}"
    printf "%s, " "${packages[@]}"
    printf "\n"
    
    read -p "##### install-desktop-packages.sh: Do you want to continue? [y/N]: " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        printf "##### install-desktop-packages.sh: Continuing with installation of packages.\n"
    else
        printf "##### install-desktop-packages.sh: Aborting!\n"
        exit 1
    fi
}

if [[ $# -ne 1 ]]; then
    printf "##### install-desktop-packages.sh: Usage: install-desktop-packages.sh [arch | debian]\n"
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
        printf "##### install-desktop-packages.sh: Usage: install-desktop-packages.sh [arch | debian]\n"
        exit 1
    ;;
esac
