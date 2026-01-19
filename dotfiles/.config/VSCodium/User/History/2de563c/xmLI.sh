#!/usr/bin/env bash

# 1. PATHS
DIR="$HOME/Pictures/Wallpapers"
CACHE="$HOME/.cache/wofi-wallpaper-picker"
SYM_LINK="$HOME/.config/current_wallpaper"
WOFI_DIR="$HOME/.config/wofi-picker"
WOFI_CONF="$WOFI_DIR/config"
SHUFFLE_ICON="$CACHE/shuffle_icon.png"

# 2. PREPARE CACHE
if [ ! -d "$CACHE" ]; then
    mkdir -p "$CACHE"
fi

# 3. GENERATE LIST
list_wallpapers() {
    if [ -f "$SHUFFLE_ICON" ]; then
        echo "img:$SHUFFLE_ICON:text:SHUFFLE_RANDOM"
    fi

    for i in "$DIR"/*.{jpg,jpeg,png,webp}; do
        if [ -f "$i" ]; then
            filename=$(basename "$i")
            if [ ! -f "$CACHE/$filename" ]; then
                magick "$i" -strip -thumbnail 600x600^ -gravity center -extent 600x600 "$CACHE/$filename"
            fi
            echo "img:$CACHE/$filename:text:$filename"
        fi
    done
}

# 4. EXECUTE WOFI
# Move into the config directory so relative paths in 'config' resolve
SELECTED=$(
    cd "$WOFI_DIR" || exit
    list_wallpapers | wofi --conf "config" --cache-file /dev/null
)

# 5. HANDLING SELECTION
if [ -z "$SELECTED" ]; then
    exit 0
fi

FILENAME=$(echo "$SELECTED" | awk -F: '{print $4}')

if [ "$FILENAME" == "SHUFFLE_RANDOM" ]; then
    FULL_PATH=$(find "$DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)
    FILENAME=$(basename "$FULL_PATH")
else
    FULL_PATH="$DIR/$FILENAME"
fi

# 6. APPLY THEME
if [ -f "$FULL_PATH" ]; then
    ln -sf "$FULL_PATH" "$SYM_LINK"
    matugen image "$FULL_PATH"
    swww img "$FULL_PATH" --transition-type center --transition-step 90 --transition-fps 60
    notify-send "Wallpaper Updated" "Applied $FILENAME"
else
    notify-send "Error" "Selection failed: $FULL_PATH"
fi