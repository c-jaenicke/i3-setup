#!/usr/bin/env bash
# script for installing packages needed for simple server setup

# ask user to confirm, continue if yes, exit if no
confirm_action () {
    read -p "$1 [y/N] " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        return
    else
        exit
    fi
}

# ALL, copy minimal shell configs
copy_minimal_shell_configs () {
    confirm_action
    bash ./copy-minimal_shell_configs.sh
}

# ARCH, install packages
install_arch_packages () {
    printf "##### Installing arch packages\n"
    confirm_action "##### Are you sure you want to continue?"
    sudo pacman -Syu \
    base-devel \
    curl \
    git \
    neovim \
    tmux \
    wget \
    zsh
 
    printf "##### DONE\n"
}

# DEBIAN, install packages
install_debian_packages () {
    printf "##### Installing debian packages\n"
    confirm_action "##### Are you sure you want to continue?"
    sudo apt update
    sudo apt install \
    build-essential \
    curl \
    git \
    neovim \
    tmux \
    wget \
    zsh
 
    printf "##### DONE\n"
}

printf "########## Starting script setup server environment for system type %s!\n########## This might install a lot of packages!\n" "$1"

case $1 in
    arch)
        install_arch_packages
        ;;

    debian)
        install_debian_packages
        ;;

    *)
        printf "\$ install-server_packages.sh [arch | debian]\n"
        ;;
esac

copy_minimal_shell_configs

printf "########## Script done\n"
