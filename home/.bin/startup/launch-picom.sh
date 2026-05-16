#!/usr/bin/env bash
# script for starting picom (compositor) at i3 start
# terminate running picom
killall -q picom

# relaunch picom
picom &
