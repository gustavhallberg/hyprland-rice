#!/bin/bash

# 1. DYNAMIC PATHS (Relative to this script)
# $0 is the script path; dirname gets the directory; /.. goes up one level to project root
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
REPO_ROOT=$(dirname "$SCRIPT_DIR")

LIB_DIR="$REPO_ROOT/waybar-library"
DOT_DIR="$REPO_ROOT/dotfiles/.config/waybar"
WOFI_DIR="$REPO_ROOT/dotfiles/.config/wofi/wofi-waybar"

# 2. SELECTION
# Navigate to WOFI_DIR so wofi finds 'style.css' via 'config'
choice=$(
    cd "$WOFI_DIR" || exit
    ls "$LIB_DIR" | wofi --dmenu --conf "config" --prompt "Select Waybar Style"
)

# Exit if no choice made
if [ -z "$choice" ]; then
    exit 0
fi

# 3. ATOMIC SYMLINK UPDATE (Internal Relative Paths)
# We keep the ../../../../ logic here because the SYMLINK lives in dotfiles/.config/waybar
# and needs to find waybar-library relative to that specific location.
ln -sf "../../../../waybar-library/$choice/config.jsonc" "$DOT_DIR/config.jsonc"
ln -sf "../../../../waybar-library/$choice/style.css" "$DOT_DIR/style.css"
ln -sf "../../../../waybar-library/$choice/colors.css" "$DOT_DIR/colors.css"

# 4. REFRESH
pkill waybar
sleep 0.2
waybar > /dev/null 2>&1 &