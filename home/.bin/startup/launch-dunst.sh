#!/usr/bin/env bash
# script for starting dunst (notifications)
# terminate running dunst
killall -q dunst

# relaunch dunst
dunst &
