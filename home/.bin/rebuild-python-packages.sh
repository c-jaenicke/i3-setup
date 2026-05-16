#!/usr/bin/env bash
# Script to rebuild all Python packages after an update.

get_python_version () {
    yay -Q "python" | awk -F " " '{print $2}' | awk -F "." '{printf "%s.%s\n",$1,$2}'
}

yay -S $(yay -Qoq /usr/lib/python$(get_python_version)) --answerclean All
