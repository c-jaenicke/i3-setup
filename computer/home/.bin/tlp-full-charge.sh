#!/usr/bin/env bash
# Script to temporarily charge the battery to 100% (e.g. before a long day)
# Thresholds configured in /etc/tlp.conf are restored automatically on the
# next boot, or immediately via the "reset" command below.

if ! command -v "tlp" >/dev/null 2>&1; then
    echo "The tlp command could not be found! Please install the tlp package."
    exit 1
fi

case $1 in
reset)
    printf "##### Restoring configured charge thresholds:\n"
    sudo tlp setcharge
    ;;
*)
    printf "##### Temporarily charging battery to 100%%:\n"
    sudo tlp fullcharge
    ;;
esac
