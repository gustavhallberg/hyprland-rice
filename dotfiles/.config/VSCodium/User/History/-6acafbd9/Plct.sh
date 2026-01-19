#!/bin/bash

# 1. PATHS
USER_NAME="gustav"
LIB_DIR="/home/$USER_NAME/projects/hyprland-rice/waybar-library"
DOT_DIR="/home/$USER_NAME/projects/hyprland-rice/dotfiles/.config/waybar"
# Updated to nested wofi directory within the project structure
WOFI_DIR="/home/$USER_NAME/projects/hyprland-rice/dotfiles/.config/wofi/waybar-switcher"

# 2. SELECTION
# Move into the config directory so relative paths in 'config' resolve
choice=$(
    cd "$WOFI_DIR" || exit
    ls "$LIB_DIR" | wofi --dmenu --conf "config" --prompt "Select Waybar Style"
)

# Exit if no choice made
if [ -z "$choice" ]; then
    exit 0
fi

# 3. ATOMIC SYMLINK UPDATE (Internal Relative Paths)
# Points from the dotfiles folder back to the library folder
ln -sf "../../../../waybar-library/$choice/config.jsonc" "$DOT_DIR/config.jsonc"
ln -sf "../../../../waybar-library/$choice/style.css" "$DOT_DIR/style.css"
ln -sf "../../../../waybar-library/$choice/colors.css" "$DOT_DIR/colors.css"

# 4. REFRESH
pkill waybar
sleep 0.2
waybar > /dev/null 2>&1 &