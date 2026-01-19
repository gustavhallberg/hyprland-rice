#!/usr/bin/env bash

# CONFIG
DIR="$HOME/Pictures/Wallpapers"
CACHE="$HOME/.cache/wofi-wallpaper-picker"
SYM_LINK="$HOME/.config/current_wallpaper"

# Specific Wofi configs to avoid clashing with app launcher
WOFI_CONF="$HOME/.config/wofi/wallpaper.conf"
WOFI_STYLE="$HOME/.config/wofi/wallpaper.css"

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

# Run Wofi with explicit config and style flags
SELECTED=$(list_wallpapers | wofi --dmenu --conf "$WOFI_CONF" --style "$WOFI_STYLE")

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