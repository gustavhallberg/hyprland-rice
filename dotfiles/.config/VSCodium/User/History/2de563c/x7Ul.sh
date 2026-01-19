#!/usr/bin/env bash

# CONFIG
DIR="$HOME/Pictures/Wallpapers"
CACHE="$HOME/.cache/wofi-wallpaper-picker"
SYM_LINK="$HOME/.config/current_wallpaper"

# Create cache dir if it doesn't exist
if [ ! -d "$CACHE" ]; then
    mkdir -p "$CACHE"
fi

# Function to generate thumbnails and list them for wofi
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

# Run Wofi
# --allow-images is required to see thumbnails
# --insensitive for easier searching
SELECTED=$(list_wallpapers | wofi --dmenu --allow-images --insensitive --prompt "Select Wallpaper" --width 600 --height 500)

# Exit if no selection
if [ -z "$SELECTED" ]; then
    exit 0
fi

# Extract the filename from the colon-separated output
FILENAME=$(echo "$SELECTED" | awk -F: '{print $4}')

# 1. Update symlink for boot persistence
ln -sf "$DIR/$FILENAME" "$SYM_LINK"

# 2. Trigger Matugen (Updates Hyprland, Waybar, Foot, and SWWW)
matugen image "$SYM_LINK"

notify-send "Wallpaper Updated" "Applied $FILENAME"