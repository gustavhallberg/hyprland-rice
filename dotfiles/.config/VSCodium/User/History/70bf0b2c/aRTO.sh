#!/usr/bin/env bash

# 1. Paths & Defaults
DEFAULT_WALL="$HOME/projects/hyprland-rice/assets/wallpapers/default.png"
# Use provided argument or fallback to current symlink, or default
WALLPAPER="${1:-$(readlink -f "$HOME/.cache/current_wallpaper" || echo "$DEFAULT_WALL")}"

# 2. Safety Check
if [ ! -f "$WALLPAPER" ]; then
    notify-send "Wallpaper Error" "File not found: $WALLPAPER"
    exit 1
fi

# 3. Handle Persistence (Symlink)
# We use .cache/current_wallpaper as the global reference for templates
mkdir -p "$HOME/.cache"
ln -sf "$WALLPAPER" "$HOME/.cache/current_wallpaper"

# 4. SWWW Daemon Check
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 0.5 
fi

# 5. Visual Update (swww)
swww img "$WALLPAPER" \
    --transition-type center \
    --transition-step 90 \
    --transition-fps 60

# 6. Theme Update (matugen)
# Calling matugen image on the symlink ensures all relative templates update
matugen image "$HOME/.cache/current_wallpaper"

# Note: Matugen's post_hooks (hyprctl reload, swaync-client -rs, etc.) 
# will trigger automatically if configured in your config.toml.