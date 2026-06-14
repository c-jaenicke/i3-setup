#!/usr/bin/env bash
# Use reflector to update mirrors
# Needs to be run with root to update mirrors
reflector --latest 200 --age 12 --sort rate --save /etc/pacman.d/mirrorlist
