#!/bin/bash

# Configuration
VARIANTS_DIR="$HOME/projects/hyprland-rice/waybar-variants"
WOFI_STYLE="$HOME/.config/wofi/style.css"

# Get list of folders (variants) 
# --name waybar_switcher allows for unique Hyprland window rules
choice=$(ls "$VARIANTS_DIR" | wofi --show dmenu \
    --name waybar_switcher \
    --prompt "Select Waybar Theme" \
    --style "$WOFI_STYLE" \
    --width 700 \
    --lines 8 \
    --layer overlay \
    --cache-file /dev/null)

# Exit if nothing selected
if [ -z "$choice" ]; then
    exit 0
fi

# Paths to selected config
CONF_PATH="$VARIANTS_DIR/$choice/config"
STYLE_PATH="$VARIANTS_DIR/$choice/style.css"

# Restart Waybar with selected profile
pkill waybar
waybar -c "$CONF_PATH" -s "$STYLE_PATH" &