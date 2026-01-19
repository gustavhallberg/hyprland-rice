#!/usr/bin/env bash

# 1. DYNAMIC PATHS
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
REPO_ROOT=$(dirname "$SCRIPT_DIR")
SAVE_DIR="$HOME/Pictures/Screenshots"

# Ensure save directory exists
mkdir -p "$SAVE_DIR"

# 2. FILENAME
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILE_PATH="$SAVE_DIR/screenshot_$TIMESTAMP.png"

# 3. EXECUTION
# -g "$(slurp)": Select region
# -t png: Format
# -: Output to stdout
# swappy -f -: Read from stdin for editing
# -o: Save to file after closing swappy
grim -g "$(slurp)" -t png - | swappy -f - -o "$FILE_PATH"

# 4. CLIPBOARD SYNC
# If the file was saved, copy it to clipboard
if [ -f "$FILE_PATH" ]; then
    wl-copy < "$FILE_PATH"
    notify-send "Screenshot Captured" "Saved to $FILE_PATH and copied to clipboard"
fi