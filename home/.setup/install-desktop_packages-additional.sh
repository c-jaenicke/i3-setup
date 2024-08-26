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

printf "########## Starting script to install additional desktop packages!\n########## This might install a lot of packages!\n"
confirm_action "########## Are you sure you want to continue?"
install_arch_packages

printf "########## Script done\n"
