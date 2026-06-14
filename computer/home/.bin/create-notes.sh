#!/usr/bin/env bash
# script for creating files for notes, to be used in combination with github pages

date=$(date +%Y-%m-%d)
folder=$(basename "$(pwd)")

# if no type is given, exit
if [ -z "$1" ] && [ -z "$2" ]
then
    printf "hint: create-notes <TYP: PCÜ|SL> <TITLE: word-word-word>\n"
    exit 1
fi

# create file with type and title
name="$date-$1-${@:2}.md"
touch "$name"

# write header to file
echo "---
date: \"$date\"
title: $2
typ: $1
categories:
  - $folder
katex: True
---

## Heading" > "$name"
