#!/usr/bin/env bash

# 1. DYNAMIC PATHS
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

# 2. FILENAME
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILE_PATH="$SAVE_DIR/screenshot_$TIMESTAMP.png"

# 3. CAPTURE LOGIC
case $1 in
    "area")
        # Direct capture of slurp output
        GEOMETRY=$(slurp)
        if [ -z "$GEOMETRY" ]; then
            exit 0
        fi
        ;;
    *)
        GEOMETRY=""
        ;;
esac

# 4. EXECUTION
if [ "$2" == "edit" ]; then
    if [ -n "$GEOMETRY" ]; then
        grim -g "$GEOMETRY" -t png - | swappy -f - -o "$FILE_PATH"
    else
        grim -t png - | swappy -f - -o "$FILE_PATH"
    fi
else
    if [ -n "$GEOMETRY" ]; then
        grim -g "$GEOMETRY" "$FILE_PATH"
    else
        grim "$FILE_PATH"
    fi
fi

# 5. CLIPBOARD & NOTIFY
if [ -f "$FILE_PATH" ]; then
    wl-copy < "$FILE_PATH"
    notify-send "Screenshot Captured" "Saved: $(basename "$FILE_PATH")" -i camera-photo
else
    notify-send "Screenshot Failed" "Could not save file" -u critical
fi