#!/usr/bin/env bash
# script for running lock screen, using i3lock

case $1 in
  lock)
      swaylock -c 666666
    ;;
  suspend)
      swaylock  -c 666666 && systemctl suspend
    ;;
  *)
    printf "lock | suspend\n"
    ;;
esac
