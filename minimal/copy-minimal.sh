#!/usr/bin/env bash
# Copy minimal shell and config files to user home
MINIMAL_DIR="$(pwd)"
USER_HOME="$HOME"

echo "##### This script will replace the existing files in your home directory!"
ls -A | grep -v 'copy-minimal.sh'
read -p "##### Are you sure? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cp "$MINIMAL_DIR/*" "$USER_HOME/"
fi

