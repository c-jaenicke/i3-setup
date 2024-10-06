#!/usr/bin/env bash
# Update spotify https://aur.archlinux.org/packages/spotify
cd "$HOME/GitHub/spotify"
pkgctl build
sudo pacman -U "$(ls -t *.tar.zst | head -1)"
