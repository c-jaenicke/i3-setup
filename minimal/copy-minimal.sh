#!/usr/bin/env bash
# Copy minimal shell and config files to user home
set -euo pipefail

# Resolve the folder of this script, so it works from any working directory
MINIMAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"

printf "##### This script will replace the existing files in your home directory!\n"
(cd "$MINIMAL_DIR" && find . -type f ! -name 'copy-minimal.sh' | sed 's|^\./||' | sort)
read -p "##### Are you sure? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Copy everything including dotfiles and subfolders, except this script
    (cd "$MINIMAL_DIR" && find . -type f ! -name 'copy-minimal.sh' -print0) |
        while IFS= read -r -d '' file; do
            install -D -m 644 "$MINIMAL_DIR/$file" "$USER_HOME/$file"
        done

    # ssh refuses configs that are readable by others
    chmod 700 "$USER_HOME/.ssh"
    chmod 600 "$USER_HOME/.ssh/config"

    printf "##### Done\n"
fi
