#!/usr/bin/env bash

# 1. DYNAMIC PATHS
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
REPO_ROOT=$(dirname "$SCRIPT_DIR")
SAVE_DIR="$HOME/Pictures/Screenshots"

mkdir -p "$SAVE_DIR"

# 2. FILENAME
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILE_PATH="$SAVE_DIR/screenshot_$TIMESTAMP.png"

# 3. CAPTURE LOGIC
# $1 = area/full | $2 = edit (optional)

case $1 in
    "area")
        GEOMETRY=$(slurp)
        [ -z "$GEOMETRY" ] && exit 0 # Exit if user cancels selection
        TARGET_GEOM="-g $GEOMETRY"
        ;;
    *)
        TARGET_GEOM=""
        ;;
esac

# 4. EXECUTION (Direct or Edit)
if [ "$2" == "edit" ]; then
    # Capture -> Swappy -> Save via Swappy's -o flag
    grim $TARGET_GEOM -t png - | swappy -f - -o "$FILE_PATH"
else
    # Capture -> Direct Save
    grim $TARGET_GEOM "$FILE_PATH"
fi

# 5. CLIPBOARD & NOTIFY
if [ -f "$FILE_PATH" ]; then
    wl-copy < "$FILE_PATH"
    notify-send "Screenshot Captured" "Saved: $(basename "$FILE_PATH")" -i camera-photo
fi