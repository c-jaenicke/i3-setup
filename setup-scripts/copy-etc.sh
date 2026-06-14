#!/usr/bin/env bash
# This script copies the system configuration files from the repo to /etc/
# This script must be run with sudo/root privileges.

set -e
set -u
set -o pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ETC_SRC="$SCRIPT_DIR/../computer/etc"

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   printf "##### copy-etc.sh: This script must be run as root (sudo).\n"
   exit 1
fi

printf "##### copy-etc.sh: This will overwrite system configurations in /etc/.\n"
read -p "##### copy-etc.sh: Do you want to continue? [y/N]: " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    printf "##### copy-etc.sh: Aborting!\n"
    exit 1
fi

printf "##### copy-etc.sh: Copying configurations to /etc/...\n"

# Copy directories recursively
# Using -v to show progress
cp -rv "$ETC_SRC/audit" /etc/
cp -rv "$ETC_SRC/NetworkManager" /etc/
cp -rv "$ETC_SRC/sddm.conf.d" /etc/
cp -rv "$ETC_SRC/sysctl.d" /etc/
cp -rv "$ETC_SRC/systemd" /etc/
cp -rv "$ETC_SRC/udisks2" /etc/

# Copy individual files
cp -v "$ETC_SRC/tlp.conf" /etc/

printf "##### copy-etc.sh: Done copying etc files!\n"
printf "##### copy-etc.sh: Remember to reload/restart relevant services (e.g., systemctl restart systemd-resolved).\n"
