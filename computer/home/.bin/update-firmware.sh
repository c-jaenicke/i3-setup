#!/usr/bin/env bash
# Script to update firmware using fwupdmgr (fwupd)

if ! command -v "fwupdmgr" >/dev/null 2>&1; then
    echo "The fwupdmgr could not be found! Please install the fwupd package."
    exit 1
fi

printf "##### Following devices have been detected:\n"
fwupdmgr get-devices

printf "##### Updating local metadata:\n"
fwupdmgr refresh

printf "##### Getting available updates:\n"
fwupdmgr get-updates

printf "##### Update?\n"
fwupdmgr update

