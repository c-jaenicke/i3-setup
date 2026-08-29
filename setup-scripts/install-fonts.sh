#!/usr/bin/env bash
# Installs just the fonts used by this setup (see the fontconfig at
# computer/home/.config/fontconfig/fonts.conf), for systems that already
# exist and don't need the full install-desktop-packages.sh run.

set -e
set -u
set -o pipefail

confirm_install() {
    local packages=("$@")

    printf "##### install-fonts.sh: The following %d packages are queued for installation:\n" "${#packages[@]}"
    printf "%s, " "${packages[@]}"
    printf "\n"

    read -p "##### install-fonts.sh: Do you want to continue? [y/N]: " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        printf "##### install-fonts.sh: Continuing with installation of packages.\n"
    else
        printf "##### install-fonts.sh: Aborting!\n"
        exit 1
    fi
}

install_arch_fonts() {
    if ! command -v yay &> /dev/null; then
        printf "##### install-fonts.sh: Setup is missing yay. Installing yay.\n"
        bash "$(cd "$(dirname "$0")" && pwd)/install-yay.sh"
    fi

    printf "##### install-fonts.sh: Installing fonts for Arch linux.\n"

    local packages=(
        ttf-hack-nerd
        ttf-ibm-plex
    )

    confirm_install "${packages[@]}"

    yay -Syu --noconfirm "${packages[@]}"

    printf "##### install-fonts.sh: Arch fonts installed successfully.\n"
}

install_debian_fonts() {
    if [[ -z "$(apt --version)" ]]; then
        printf "##### install-fonts.sh: Cant execute apt, are you sure this is a debian/ubuntu system that uses apt?\n"
        exit 1
    fi

    printf "##### install-fonts.sh: Installing fonts for Debian.\n"

    sudo apt update

    local packages=(
        fonts-hack
        fonts-ibm-plex
    )

    confirm_install "${packages[@]}"

    sudo apt install -y "${packages[@]}" || {
        printf "##### install-fonts.sh: Package installation failed\n"
        exit 1
    }

    printf "##### install-fonts.sh: Debian fonts installed successfully.\n"
    printf "##### install-fonts.sh: Note: Debian's fonts-hack is not Nerd Font patched. Get the patched glyphs manually from https://www.nerdfonts.com/ if icons are missing.\n"
}

install_suse_fonts() {
    if [[ -z "$(zypper --version)" ]]; then
        printf "##### install-fonts.sh: Cant execute zypper, are you sure this is a suse system that uses zypper?\n"
        exit 1
    fi

    printf "##### install-fonts.sh: Installing fonts for openSUSE.\n"

    local packages=(
        hack-fonts
        ibm-plex-fonts
        symbols-only-nerd-fonts
    )

    confirm_install "${packages[@]}"

    sudo zypper in -y "${packages[@]}"

    printf "##### install-fonts.sh: Suse fonts installed successfully.\n"
}

if [[ $# -ne 1 ]]; then
    printf "##### install-fonts.sh: Usage: install-fonts.sh [arch | debian | suse]\n"
    exit 1
fi

case "$1" in
arch)
    install_arch_fonts
    ;;
debian)
    install_debian_fonts
    ;;
suse)
    install_suse_fonts
    ;;
*)
    printf "##### install-fonts.sh: Usage: install-fonts.sh [arch | debian | suse]\n"
    exit 1
    ;;
esac

printf "##### install-fonts.sh: Note: 'MonoLisaCode Trial' referenced in fonts.conf is a commercial font and is not installed by this script. Install it manually if you use it.\n"
