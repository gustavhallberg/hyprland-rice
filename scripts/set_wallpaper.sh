#!/usr/bin/env bash
SYM_LINK="$HOME/.config/current_wallpaper"

if [ -L "$SYM_LINK" ]; then
    # 1. Get the real path from the symlink
    WALLPAPER=$(readlink -f "$SYM_LINK")
    
    # 2. Set the wallpaper (using swww)
    swww-daemon & 
    sleep 0.5
    swww img "$WALLPAPER"
    
    # 3. Re-run matugen to generate the colors.css
    matugen image "$WALLPAPER"
else
    # Fallback if no symlink exists
    swww-daemon &
fi