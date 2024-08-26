#!/usr/bin/env bash
# script for installing additional packages, more than just simple desktop

# ask user for permission, continue if yes, exit if no
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
    # this assumes that yay is already installed! 
    yay -Syu \
    brlaser \
    brother-dcp1610w \
    brscan4 \
    cups \
    cups-pdf \
    firefox \
    gimp \
    gnupg \
    gvfs \
    hunspell \
    hunspell-de \
    hunspell-en_us \
    inkscape \
    keepassxc \
    kleopatra \
    libreoffice-fresh \
    libreoffice-fresh-de \
    openssh \
    qbittorrent \
    rxvt-unicode \
    sane \
    skanlite \
    texstudio \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    thunderbird \
    veracrypt \
    
    printf "##### DONE\n"
}

install_debian_packages () {
    printf "##### Installing arch packages\n"
    sudo apt update
    sudo apt install \
    cups \
    cups-pdf \
    firefox-esr \
    gimp \
    gnupg \
    gvfs \
    hunspell \
    hunspell-de-de \
    hunspell-en-us \
    inkscape \
    keepassxc \
    kleopatra \
    libreoffice \
    openssh-server \
    openssh-client \
    qbittorrent \
    rxvt-unicode \
    sane \
    skanlite \
    texstudio \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    thunderbird \
    
    printf "##### DONE\n"
}

printf "########## Starting script to install additional desktop packages!\n########## This might install a lot of packages!\n"

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
