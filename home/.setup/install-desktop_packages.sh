#!/usr/bin/env bash
# get path to folder, to return to for copying configs
current_directory="$(pwd)"

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
    printf "##### Install arch packages\n"
    bash install_yay.sh
    yay -Syu \
    vim \
    neovim \
    tmux \
    zsh \
    firefox \
    openssh \
    keepassxc \
    i3-wm \
    picom \
    rofi \
    dunst \
    polybar \
    alacritty \
    ttf-ibm-plex \
    flameshot
    
    printf "##### Installed arch packages\n"
}

# DEBIAN, install packages
install_debian_packages () {
    printf "##### Install debian packages\n"
    sudo apt update && sudo apt upgrade
    sudo apt install \
    git \
    base-devel \
    wget \
    curl \
    vim \
    neovim \
    tmux \
    zsh \
    firefox \
    openssh \
    keepassxc \
    picom \
    rxvt-unicode \
    ttf-ibm-plex
    
    printf "##### Installed debian packages\n"
}

printf "##### Starting install of packages for system: %s" $1
confirm_action "##### Are you sure you want to continue?"
case $1 in
    arch)
        install_arch_packages
    ;;
    
    debian)
        install_debian_packages
    ;;
    
    *)
        printf "Call script using \n\tbash desktop <debian | arch>\n"
        exit
    ;;
esac

printf "##### AFTER SETUP TASKS\n
\t - run install-plug-vim.sh in .config/nvim/autoload to install vim plugin manager\n
\t - run PlugInstall in neovim to install plugins afterwards\n
\t - optionally install starship for a better shell\n
\t - check .zshrc Source Plugins section to see which plugins to install\n
\t - change shell using chsh\n"
