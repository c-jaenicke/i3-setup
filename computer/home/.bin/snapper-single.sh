#!/bin/bash
# Create single snapshot

if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run as root."
    exit 1
fi

DESCRIPTION=""

if [ -z "$1" ]; then
    TEMP_DESCRIPTION="Single Snapshot $(date --iso-8601="minutes")"

    read -p "##### No description set, will use \"$TEMP_DESCRIPTION\" Do you want to continue? [y/N]: " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        DESCRIPTION="$TEMP_DESCRIPTION"
    else
        echo "##### No description, exiting!"
        echo "##### Usage: sudo ./snapper_single.sh \"DESCRIPTION\""
        exit 1
    fi
else
    DESCRIPTION="$1"
fi

echo "##### Creating single snapshot..."
sudo snapper create --type single --description "$DESCRIPTION"

echo "##### Snapshot created successfully. Current snapshots:"
sudo snapper list | tail -n 5

