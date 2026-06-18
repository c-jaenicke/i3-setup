#!/usr/bin/env bash
# This script installs the necessary packages for a base desktop environment.

set -e
set -u
set -o pipefail

install_arch_packages() {
    if ! command -v yay &> /dev/null; then
        printf "##### install-desktop-packages.sh: Setup is missing yay. Installing yay.\n"
        bash "$(cd "$(dirname "$0")" && pwd)/install-yay.sh"
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
        network-manager-applet
        nextcloud-client
        openssh
        polkit-kde-agent
        ripgrep
        rofi-wayland
        rxvt-unicode
        starship
        sway
        swaybg
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
        wdisplays
        wget
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
        cups
        cups-pdf
        curl
        dunst
        feh
        firefox-esr
        flameshot
        gimp
        git
        gnupg
        gvfs
        hunspell
        hunspell-de-de
        hunspell-en-us
        i3-wm
        i3lock
        inkscape
        keepassxc
        kleopatra
        libreoffice
        light
        neovim
        openssh-client
        openssh-server
        picom
        polybar
        qbittorrent
        rofi
        rxvt-unicode
        sane
        skanlite
        starship
        texstudio
        thunar
        thunar-archive-plugin
        thunar-volman
        thunderbird
        wget
        xautolock
        zsh
    )

    confirm_install "${packages[@]}"

    sudo apt install -y "${packages[@]}" || {
        printf "##### install-desktop-packages.sh: Package installation failed\n"
        exit 1
    }

    printf "##### install-desktop-packages.sh: Debian packages installed successfully\n"
}

install_suse_packages() {
    if [[ -z "$(zypper --version)" ]]; then
        printf "##### install-desktop-packages.sh: Cant execute zypper, are you sure this is a suse/system that uses zypper?\n"
        exit 1
    fi

    printf "##### install-desktop-packages.sh: Installing suse packages\n"

    local packages=(
        NetworkManager-applet
        alacritty
        brightnessctl
        chromium
        curl
        dunst
        firefox
        firewall-config
        flatpak
        flatseal
        gimp
        git
        gpg2
        gvfs
        hack-fonts
        htop
        ibm-plex-fonts
        inkscape
        keepassxc
        kleopatra
        kwalletmanager
        libreoffice
        neovim
        nextcloud-desktop
        openssh
        polkit-kde-agent-6
        ripgrep
        rofi-wayland
        rxvt-unicode
        starship
        sway 
        swaybg
        swayidle
        swaylock
        symbols-only-nerd-fonts
        thunderbird
        tlp
        tlpui
        tmux
        tree-sitter
        waybar
        wayland-protocols-devel
        wayland-utils
        wdisplays
        wget
        wireguard-tools
        wl-clipboard
        xdg-desktop-portal
        xdg-desktop-portal-kde
        xdg-desktop-portal-wlr
        yubico-piv-tool
        zsh
    )

    confirm_install "${packages[@]}"

    sudo zypper in -y "${packages[@]}"

    # Install VSCode
    sudo zypper ar -cf https://download.opensuse.org/repositories/devel:/tools:/ide:/vscode/openSUSE_Tumbleweed devel_tools_ide_vscode
    sudo zypper in code

    printf "##### install-desktop-packages.sh: Suse packages installed successfully\n"
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
suse)
    install_suse_packages
    ;;

*)
    printf "##### install-desktop-packages.sh: Usage: install-desktop-packages.sh [arch | debian | suse]\n"
    exit 1
    ;;
esac
