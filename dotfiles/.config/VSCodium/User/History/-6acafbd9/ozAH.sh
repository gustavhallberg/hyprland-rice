#!/bin/bash

# Configuration
LIB_DIR="/home/gustav/projects/hyprland-rice/waybar-library"
DOT_DIR="/home/gustav/projects/hyprland-rice/dotfiles/.config/waybar"
WOFI_STYLE="/home/gustav/.config/wofi/style.css"

# 1. Selection (Removed --name, added --dmenu)
# We use --dmenu to force the list-picker mode
choice=$(ls "$LIB_DIR" | wofi --dmenu --style "$WOFI_STYLE" --prompt "Select Waybar Style")

# Exit if no choice made
if [ -z "$choice" ]; then
    exit 0
fi

# 2. Atomic Symlink Update
ln -sf "$LIB_DIR/$choice/config.jsonc" "$DOT_DIR/config.jsonc"
ln -sf "$LIB_DIR/$choice/style.css" "$DOT_DIR/style.css"
ln -sf "$LIB_DIR/$choice/colors.css" "$DOT_DIR/colors.css"

# 3. Refresh Waybar
pkill waybar
sleep 0.2
waybar > /dev/null 2>&1 &