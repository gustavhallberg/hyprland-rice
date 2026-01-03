#!/usr/bin/env bash

# Use the first argument as the wallpaper path
WALLPAPER=$1

if [ -z "$WALLPAPER" ]; then
    echo "Usage: ./set_wallpaper.sh /home/gustav/projects/assets/wallpapers/nordic-wallpapers/ign_mountains.jpg"
    exit 1
fi

# Set the wallpaper with a smooth transition
swww img "$WALLPAPER" --transition-type center --transition-step 90
