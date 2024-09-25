#!/bin/env bash
mouseid=$(xinput | awk '/Glorious Model O [^K]/ { print $6 }' | sed 's/id=//g')
printf "setting mouse id %s speed\n" "$mouseid"
xinput set-prop "$mouseid" 316 0.7
