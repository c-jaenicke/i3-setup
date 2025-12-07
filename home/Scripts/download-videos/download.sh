#!/usr/bin/env bash

YTDL_PATH="/home/chrisj/Projekte/yt-dlp/yt-dlp.sh"

OUTPUT_FORMAT='%(channel|creator|uploader)s - %(title)s - %(id)s.%(ext)s'

FORMAT_ARGS=(
    "-f" "bestvideo*+bestaudio/best"
    "--embed-thumbnail"
    "--add-metadata"
)

AUDIO_ONLY_ARGS=(
    "-f" "bestaudio[ext=m4a]/bestaudio" 
    "--extract-audio" 
    "--audio-format" "m4a" 
    "--audio-quality" "0"
    "--embed-thumbnail"
    "--add-metadata"
)

INPUT_FILE=""
INPUT_URL=""
AUDIO_ONLY=false

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOWNLOADS_DIR="$SCRIPT_DIR/downloads"
mkdir -p "$DOWNLOADS_DIR"

if [[ ! -x "$YTDL_PATH" ]]; then
    echo "Error: yt-dlp executable not found at '$YTDL_PATH'"
    echo "Please check the path in the script"
    exit 1
fi

while getopts "f:u:a" opt; do
    case $opt in
        f)
            INPUT_FILE="$OPTARG"
            ;;
        u)
            INPUT_URL="$OPTARG"
            ;;
        a)
            AUDIO_ONLY=true
            FORMAT_ARGS=("${AUDIO_ONLY_ARGS[@]}")
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [[ -z "$INPUT_FILE" && -z "$INPUT_URL" ]]; then
    echo "Error: No input specified."
    echo "Usage: $0 [-f videos.txt] [-u https://example.com/video] [-a (audio only)]"
    exit 1
fi

CMD=("$YTDL_PATH" "${FORMAT_ARGS[@]}" -P "$DOWNLOADS_DIR" --output "$OUTPUT_FORMAT")

if [[ -n "$INPUT_FILE" ]]; then
    if [[ ! -f "$INPUT_FILE" ]]; then
        echo "Error: File '$INPUT_FILE' not found"
        exit 1
    fi
    
    echo "Downloading videos from file: $INPUT_FILE"
    echo "Output directory: $DOWNLOADS_DIR"
    
    "${CMD[@]}" -a "$INPUT_FILE"
    
elif [[ -n "$INPUT_URL" ]]; then
    echo "Downloading from URL: $INPUT_URL"
    echo "Output directory: $DOWNLOADS_DIR"
    
    "${CMD[@]}" "$INPUT_URL"
fi

echo "Download completed! Files saved in: $DOWNLOADS_DIR"

