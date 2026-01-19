#!/bin/bash

# 1. DYNAMIC PATHS
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
REPO_ROOT=$(dirname "$SCRIPT_DIR")

LIB_DIR="$REPO_ROOT/waybar-library"
DOT_DIR="$REPO_ROOT/dotfiles/.config/waybar"
WOFI_DIR="$REPO_ROOT/dotfiles/.config/wofi/wofi-waybar"

# 2. SELECTION
choice=$(
    cd "$WOFI_DIR" || exit
    ls "$LIB_DIR" | wofi --dmenu --conf "config" --prompt "Select Waybar Style"
)

if [ -z "$choice" ]; then
    exit 0
fi

# 3. ATOMIC SYMLINK UPDATE
# Standardized to config.jsonc based on your terminal output
ln -sf "$LIB_DIR/$choice/config.jsonc" "$DOT_DIR/config.jsonc"
ln -sf "$LIB_DIR/$choice/style.css" "$DOT_DIR/style.css"
ln -sf "$LIB_DIR/$choice/colors.css" "$DOT_DIR/colors.css"

# 4. REFRESH
pkill -x waybar
sleep 0.5
# Use nohup or setsid to ensure waybar survives the script closing
nohup waybar > /dev/null 2>&1 &