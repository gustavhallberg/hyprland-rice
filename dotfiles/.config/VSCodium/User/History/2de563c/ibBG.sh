#!/usr/bin/env bash

# 1. PATHS
DIR="$HOME/Pictures/Wallpapers"
CACHE="$HOME/.cache/wofi-wallpaper-picker"
SYM_LINK="$HOME/.config/current_wallpaper"
WOFI_CONF="$HOME/.config/wofi/wallpaper.conf"

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

# Extract the filename (the 4th field)
FILENAME=$(echo "$SELECTED" | awk -F: '{print $4}')
FULL_PATH="$DIR/$FILENAME"

# 6. APPLY THEME DIRECTLY
# Update symlink for persistence
ln -sf "$FULL_PATH" "$SYM_LINK"

# Trigger Matugen on the specific file
# This is what fires your post_hooks (swaync, waybar, hyprland)
matugen image "$FULL_PATH"

# 7. VISUAL TRANSITION (Directly via swww)
swww img "$FULL_PATH" --transition-type center --transition-step 90 --transition-fps 60

notify-send "Wallpaper Updated" "Applied $FILENAME"