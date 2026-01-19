#!/usr/bin/env bash

DIR="$HOME/Pictures/Wallpapers"
CACHE="$HOME/.cache/wofi-wallpaper-picker"
SYM_LINK="$HOME/.config/current_wallpaper"
WOFI_CONF="$HOME/.config/wofi/wallpaper.conf"

[[ ! -d "$CACHE" ]] && mkdir -p "$CACHE"

list_wallpapers() {
    for i in "$DIR"/*.{jpg,jpeg,png,webp}; do
        [[ -f "$i" ]] || continue
        fn=$(basename "$i")
        [[ -f "$CACHE/$fn" ]] || magick "$i" -strip -thumbnail 500x500^ -gravity center -extent 500x500 "$CACHE/$fn"
        echo "img:$CACHE/$fn:text:$fn"
    done
}

# Execute Wofi
SELECTED=$(list_wallpapers | wofi --conf "$WOFI_CONF")

# Exit if Escaped
[[ -z "$SELECTED" ]] && exit 0

# Extract filename
FILENAME=$(echo "$SELECTED" | awk -F: '{print $4}')
FULL_PATH="$DIR/$FILENAME"

# 1. Update Symlink
ln -sf "$FULL_PATH" "$SYM_LINK"

# 2. RUN MATUGEN (The critical step)
# Using 'image' on the full path triggers the post_hooks
matugen image "$FULL_PATH"

# 3. SET VISUALS
swww img "$FULL_PATH" --transition-type center

notify-send "Theme Applied" "$FILENAME"