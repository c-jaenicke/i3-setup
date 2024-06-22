#!/usr/bin/env bash

# get distro
distro=$(cat /etc/*-release | awk '/ID_LIKE=/{split($0,string, "="); print string[2]}')

printf "##### STARTING #####\n\tDownloading for distro: $distro\n"

case $distro in
  arch)
      # optionally add "starship"
      # optionally add "neovim"
    sudo pacman -S git wget vim tmux zsh base-devel
    install_yay
    ;;
  debian)
      # optionally install starship using
      # curl -sS https://starship.rs/install.sh | sh
      # optionally add "neovim"
    sudo apt install git wget vim tmux zsh
    ;;
esac

printf "\tGetting configs\n"
get_shell_configs

printf "##### DONE #####"

# get bash and zsh config files
get_shell_configs() {
  wget -O ~/.bashrc https://raw.githubusercontent.com/c-jaenicke/i3-setup-laptop/main/home/.setup/.bashrc
  wget -O ~/.zshrc https://raw.githubusercontent.com/c-jaenicke/i3-setup-laptop/main/home/.setup/.zshrc
}

# install yay using a temporary directory
# only for arch systems
install_yay() {
  yay_temp_dir=$(mktemp -d)
  cd $yay_temp_dir
  printf "\t\t Installing yay, using temp directory $yay_temp_dir\n"
  git clone https://aur.archlinux.org/yay-bin.git $$ cd yay-bin
  makepage -si
  rm -drf $yay_temp_dir
  printf "\t\t Installing yay done\n"
}
