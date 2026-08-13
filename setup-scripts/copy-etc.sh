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

# openSUSE's own zramswap.service hardcodes zram to 100%% of RAM and
# conflicts with our zram-generator.conf sizing; disable it in favor of
# the generator-managed dev-zram0.swap unit.
if systemctl list-unit-files zramswap.service &>/dev/null; then
    printf "##### copy-etc.sh: Disabling openSUSE's built-in zramswap.service in favor of zram-generator...\n"
    systemctl disable --now zramswap.service || true
    systemctl daemon-reload
    systemctl start systemd-zram-setup@zram0.service || true
fi

printf "##### copy-etc.sh: Remember to reload/restart relevant services (e.g., systemctl restart systemd-resolved).\n"
printf "##### copy-etc.sh: Applying updated sysctl settings...\n"
sysctl --system
