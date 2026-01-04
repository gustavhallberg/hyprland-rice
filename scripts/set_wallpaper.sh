#!/usr/bin/env bash

# 1. Define the default wallpaper path
# This ensures the script works even if you don't provide an argument
DEFAULT_WALL="$HOME/projects/hyprland-rice/assets/wallpapers/default.png"

# 2. Assign the wallpaper variable
# Uses the first argument ($1) if provided; otherwise, falls back to DEFAULT_WALL
WALLPAPER=${1:-$DEFAULT_WALL}

# 3. Safety Check: Verify the file exists
if [ ! -f "$WALLPAPER" ]; then
    echo "Error: Wallpaper file not found at $WALLPAPER"
    echo "Usage: ./set_wallpaper.sh /path/to/image.jpg"
    exit 1
fi

# 4. Initialize swww-daemon if not already running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 0.5 # Give it a moment to initialize
fi

# 5. Execute the transition
# Transition settings optimized for high-density, smooth visuals
swww img "$WALLPAPER" \
    --transition-type center \
    --transition-step 90 \
    --transition-fps 60

# 6. Future-proofing: Placeholder for Matugen color generation
# When we implement Matugen, we will uncomment the line below:
# matugen image "$WALLPAPER"

echo "Wallpaper applied: $WALLPAPER"