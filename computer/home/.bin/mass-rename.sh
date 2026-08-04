#!/usr/bin/env bash
# Script to mass-rename files in a folder by adding a prefix or suffix

usage() {
    printf "Usage: %s [-p PATTERN] [-P PREFIX] [-S SUFFIX] [-n] [DIR]\n" "$(basename "$0")"
    printf "  -p PATTERN   glob pattern to match files (default: *)\n"
    printf "  -P PREFIX    text to prepend to matched filenames\n"
    printf "  -S SUFFIX    text to append to matched filenames (before extension)\n"
    printf "  -n           dry run, only print what would be renamed\n"
    printf "  DIR          folder to operate in (default: .)\n"
    printf "Example: %s -p '*.jpg' -P vacation_ ~/Pictures\n" "$(basename "$0")"
}

PATTERN="*"
PREFIX=""
SUFFIX=""
DRY_RUN=0

while getopts "p:P:S:nh" opt; do
    case $opt in
    p) PATTERN="$OPTARG" ;;
    P) PREFIX="$OPTARG" ;;
    S) SUFFIX="$OPTARG" ;;
    n) DRY_RUN=1 ;;
    h)
        usage
        exit 0
        ;;
    *)
        usage
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

DIR="${1:-.}"

if [ -z "$PREFIX" ] && [ -z "$SUFFIX" ]; then
    echo "##### Error: Provide at least a prefix (-P) or suffix (-S)."
    usage
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "##### Error: '$DIR' is not a directory."
    exit 1
fi

cd "$DIR" || exit 1

for file in $PATTERN; do
    [ -f "$file" ] || continue

    name="${file%.*}"
    ext="${file##*.}"

    if [ "$name" = "$ext" ]; then
        # File has no extension
        newname="${PREFIX}${file}${SUFFIX}"
    else
        newname="${PREFIX}${name}${SUFFIX}.${ext}"
    fi

    [ "$file" = "$newname" ] && continue

    if [ -e "$newname" ]; then
        echo "##### Skipping '$file': target '$newname' already exists."
        continue
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        echo "$file -> $newname"
    else
        mv -- "$file" "$newname"
        echo "$file -> $newname"
    fi
done
