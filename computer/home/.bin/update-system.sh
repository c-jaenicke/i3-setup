#!/usr/bin/env bash
# Update packages using whichever package managers are installed on this
# system. Runs each one found, so it works unmodified on Arch, Debian,
# openSUSE, or any mix with Flatpak on top.

status=0

update_yay() {
    printf "##### update-system.sh: Updating packages with yay...\n"
    nice -n 19 yay -Syu --devel --sudoloop
}

update_pacman() {
    printf "##### update-system.sh: Updating packages with pacman...\n"
    sudo pacman -Syu
}

update_apt() {
    printf "##### update-system.sh: Updating packages with apt...\n"
    sudo apt update && sudo apt upgrade
}

update_zypper() {
    printf "##### update-system.sh: Updating packages with zypper...\n"
    sudo zypper dup
}

update_flatpak() {
    printf "##### update-system.sh: Updating packages with flatpak...\n"
    flatpak update
}

run_step() {
    local name="$1"
    if ! "update_$name"; then
        printf "##### update-system.sh: %s update failed.\n" "$name"
        status=1
    fi
    ran_any=1
}

ran_any=0

# Prefer yay over plain pacman, it also covers official repo packages.
if command -v yay >/dev/null 2>&1; then
    run_step yay
elif command -v pacman >/dev/null 2>&1; then
    run_step pacman
fi

if command -v apt >/dev/null 2>&1; then
    run_step apt
fi

if command -v zypper >/dev/null 2>&1; then
    run_step zypper
fi

if command -v flatpak >/dev/null 2>&1; then
    run_step flatpak
fi

if [ "$ran_any" -eq 0 ]; then
    printf "##### update-system.sh: No supported package manager found (looked for yay, pacman, apt, zypper, flatpak).\n"
    exit 1
fi

if [ "$status" -eq 0 ]; then
    printf "##### update-system.sh: All updates finished successfully.\n"
else
    printf "##### update-system.sh: Finished with errors, see above.\n"
fi

exit "$status"
