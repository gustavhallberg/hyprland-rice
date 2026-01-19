#!/usr/bin/env bash

# 1. PATHS
DIR="$HOME/Pictures/Wallpapers"
CACHE="$HOME/.cache/wofi-wallpaper-picker"
WOFI_CONF="$HOME/.config/wofi/wallpaper.conf"
SET_WALL_SCRIPT="$HOME/projects/hyprland-rice/scripts/set_wallpaper.sh"

# 2. PREPARE CACHE
if [ ! -d "$CACHE" ]; then
    mkdir -p "$CACHE"
fi

# 3. GENERATE LIST
list_wallpapers() {
    for i in "$DIR"/*.{jpg,jpeg,png,webp}; do
        if [ -f "$i" ]; then
            filename=$(basename "$i")
            # Create thumbnail if not present
            if [ ! -f "$CACHE/$filename" ]; then
                magick "$i" -strip -thumbnail 500x500^ -gravity center -extent 500x500 "$CACHE/$filename"
            fi
            # Format: img:path:text:display_name
            echo "img:$CACHE/$filename:text:$filename"
        fi
    done
}

# 4. EXECUTE WOFI
SELECTED=$(list_wallpapers | wofi --conf "$WOFI_CONF")

# 5. HANDLING SELECTION
if [ -z "$SELECTED" ]; then
    exit 0
fi

# Extract the filename (the 4th field in the img:path:text:label string)
FILENAME=$(echo "$SELECTED" | awk -F: '{print $4}')

# 6. APPLY THEME VIA MASTER SCRIPT
# This ensures swww transitions, symlinking, and matugen all happen in sync
bash "$SET_WALL_SCRIPT" "$DIR/$FILENAME"