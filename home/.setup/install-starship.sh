#!/usr/bin/env bash
# Script for installing starship
# ONLY REQUIRED FOR DEBIAN AND DEBIAN-BASED

set -e
set -u
set -o pipefail

install_starship() {
    printf "##### Installing Starship\n"
    
    curl -sS https://starship.rs/install.sh | sh || {
        printf "##### Failed to install Starship\n"
        exit 1
    }
    
        printf "##### Starship Installed Successfully\n"
}

install_starship

