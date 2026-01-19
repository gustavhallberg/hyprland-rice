#!/bin/bash

# Configuration
LIB_DIR="$HOME/projects/hyprland-rice/waybar-library"
DOT_DIR="$HOME/projects/hyprland-rice/dotfiles/.config/waybar"
WOFI_STYLE="$HOME/.config/wofi/style.css"

# 1. Select Variant from Library
choice=$(ls "$LIB_DIR" | wofi --show dmenu --name waybar_switcher --style "$WOFI_STYLE" --prompt "Select Waybar Style")

# Exit if no choice made
if [ -z "$choice" ]; then
    exit 0
fi

# 2. Atomic Symlink Update (Updating the 'Truth' in your repo)
# We use -sf to overwrite the existing links
ln -sf "$LIB_DIR/$choice/config.jsonc" "$DOT_DIR/config.jsonc"
ln -sf "$LIB_DIR/$choice/style.css" "$DOT_DIR/style.css"
ln -sf "$LIB_DIR/$choice/colors.css" "$DOT_DIR/colors.css"

# 3. Refresh Waybar
pkill waybar
sleep 0.1
waybar &