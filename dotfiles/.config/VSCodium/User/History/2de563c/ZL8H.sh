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
# We only pass --conf; the conf file handles the --dmenu mode and the --style path.
SELECTED=$(list_wallpapers | wofi --conf "$WOFI_CONF")

# 5. HANDLING SELECTION
if [ -z "$SELECTED" ]; then
    exit 0
fi

FILENAME=$(echo "$SELECTED" | awk -F: '{print $4}')

# 6. APPLY THEME
ln -sf "$DIR/$FILENAME" "$SYM_LINK"
matugen image "$SYM_LINK"

notify-send "Wallpaper Updated" "Applied $FILENAME"