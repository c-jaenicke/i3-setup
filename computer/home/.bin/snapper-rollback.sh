#!/bin/bash
# Script to list snapshots and roll back to one of them

if [ "$EUID" -ne 0 ]; then
    echo "##### Error: Please run as root."
    exit 1
fi

case $1 in
list)
    snapper list
    ;;
rollback)
    if [ -z "$2" ]; then
        echo "##### Error: No snapshot number given."
        echo "##### Usage: sudo ./snapper-rollback.sh rollback NUMBER"
        echo "##### Available snapshots:"
        snapper list
        exit 1
    fi

    echo "##### About to roll back to snapshot $2:"
    snapper list | grep -E "^ *#|^$2 " || true
    read -p "##### This will create a rollback snapshot and requires a REBOOT to take effect. Continue? [y/N]: " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "##### Aborted."
        exit 1
    fi

    snapper rollback "$2"

    echo "##### Rollback snapshot created. Reboot now to boot into it."
    ;;
*)
    printf "snapper-rollback.sh list | rollback NUMBER\n"
    ;;
esac
