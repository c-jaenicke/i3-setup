#!/usr/bin/env bash
# script for starting polybar (system bar) at i3 start
# Terminate already running bar instances
killall -q polybar

# launch on all monitors found
for i in $(polybar -m | cut -d":" -f1); do
  MONITOR=$i polybar --reload bar1 &
done

# launch on single monitor
# polybar bar1 &
