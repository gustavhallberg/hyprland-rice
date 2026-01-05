#!/usr/bin/env bash

# Paths
WALL_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper_thumbs"
SYM_LINK="$HOME/.config/current_wallpaper"

mkdir -p "$CACHE_DIR"

# Generate thumbnails and output Wofi format
# img:path:text:display_name
list_walls() {
    for wall in "$WALL_DIR"/*.{jpg,jpeg,png,webp}; do
        [ -e "$wall" ] || continue
        filename=$(basename "$wall")
        thumb="$CACHE_DIR/$filename"
        
        # Create thumbnail if missing
        if [ ! -f "$thumb" ]; then
            magick "$wall" -strip -thumbnail 500x500^ -gravity center -extent 500x500 "$thumb"
        fi
        
        echo "img:$thumb:text:$filename"
    done
}

# Run Wofi
# --allow-images is the key flag here
SELECTED_LINE=$(list_walls | wofi --dmenu --allow-images --prompt "Select Wallpaper" --width 800 --height 600 --cache-file /dev/null)

# Exit if no selection
[[ -z "$SELECTED_LINE" ]] && exit 0

# Extract filename (the 4th field in our colon-separated string)
SELECTED_FILE=$(echo "$SELECTED_LINE" | awk -F: '{print $4}')

# Update symlink
ln -sf "$WALL_DIR/$SELECTED_FILE" "$SYM_LINK"

# Trigger Matugen
# This updates all apps and triggers swww transition
matugen image "$SYM_LINK"

notify-send "Theme Applied" "Wallpaper: $SELECTED_FILE"