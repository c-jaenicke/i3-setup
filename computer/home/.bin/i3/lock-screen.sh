#!/usr/bin/env bash
# script for running lock screen, using i3lock

case $1 in
  lock)
     i3lock -c 666666
    ;;

  suspend)
  i3lock  -c 666666 && systemctl suspend
    ;;
  *)
    printf "lock | suspend\n"
    ;;
esac
