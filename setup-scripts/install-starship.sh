#!/usr/bin/env bash
# This script installs starship on the system.
# The script should be run with elevated privileges.
# This script should be used as a fallback if the starship package is not available on a platform.

set -e
set -u
set -o pipefail

install_starship() {
    printf "##### install-starship.sh: Installing starship.\n"
    
    curl -sS https://starship.rs/install.sh | sh || {
        printf "##### install-starship.sh: Failed to install starship!\n"
        exit 1
    }
    
    printf "##### install-starship.sh: Starship Installed Successfully!\n"
}

install_starship
