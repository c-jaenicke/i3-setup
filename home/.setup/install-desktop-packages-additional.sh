#!/usr/bin/env bash
# Script for installing additional packages beyond a simple desktop setup

set -e
set -u
set -o pipefail

install_arch_packages() {
    printf "##### Installing Arch packages\n"

    local packages=(
        brlaser brother-dcp1610w brscan4 cups cups-pdf firefox gimp gnupg gvfs
        htop hunspell hunspell-de hunspell-en_us inkscape keepassxc kleopatra
        libreoffice-fresh libreoffice-fresh-de openssh qbittorrent qt6ct rxvt-unicode
        sane skanlite texstudio thunar thunar-archive-plugin thunar-volman
        thunderbird veracrypt yubico-authenticator-bin
    )

    yay -Syu --noconfirm "${packages[@]}"

    printf "##### Arch packages installed successfully\n"
}

install_debian_packages() {
    printf "##### Installing Debian packages\n"

    sudo apt update

    local packages=(
        cups cups-pdf firefox-esr gimp gnupg gvfs hunspell hunspell-de-de
        hunspell-en-us inkscape keepassxc kleopatra libreoffice openssh-server
        openssh-client qbittorrent rxvt-unicode sane skanlite texstudio thunar
        thunar-archive-plugin thunar-volman thunderbird
    )

    sudo apt install -y "${packages[@]}" || {
        printf "##### Package installation failed\n"
        exit 1
    }

    printf "##### Debian packages installed successfully\n"
}

printf "##### Starting script to install additional desktop packages\n"
printf "##### This might install a lot of packages\n"

if [[ $# -ne 1 ]]; then
    printf "##### Usage: install-desktop-packages-additional.sh [arch | debian]\n"
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
        printf "##### Usage: install-desktop-packages-additional.sh [arch | debian]\n"
        exit 1
        ;;
esac

