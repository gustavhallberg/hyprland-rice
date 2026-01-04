#!/usr/bin/env bash

# 1. Define the default wallpaper path
DEFAULT_WALL="$HOME/projects/hyprland-rice/assets/wallpapers/default.png"

# 2. Assign the wallpaper variable
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
    sleep 0.5 
fi

# 5. Execute the transition
swww img "$WALLPAPER" \
    --transition-type center \
    --transition-step 90 \
    --transition-fps 60

# 6. Update the 'current' symlink for Hyprlock and other tools
# This creates a fixed reference point at ~/.cache/current_wallpaper
mkdir -p "$HOME/.cache"
ln -sf "$WALLPAPER" "$HOME/.cache/current_wallpaper"

# 7. Future-proofing: Placeholder for Matugen color generation
# matugen image "$WALLPAPER"

echo "Wallpaper applied: $WALLPAPER"
echo "Symlink updated: $HOME/.cache/current_wallpaper"