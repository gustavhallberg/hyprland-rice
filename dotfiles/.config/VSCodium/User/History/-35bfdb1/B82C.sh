#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting Rice Installation: Replicable CachyOS Setup"

# 1. Install Base Development Tools & Git
sudo pacman -S --needed --noconfirm base-devel git

# 2. Bootstrap yay if missing
if ! command -v yay &> /dev/null; then
    echo "yay not found. Installing from AUR..."
    _tempdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$_tempdir"
    cd "$_tempdir"
    makepkg -si --noconfirm
    cd -
    rm -rf "$_tempdir"
fi

# 3. Update system
yay -Syu --noconfirm

# 4. Define Applications
APPS=(
    # Core Rice Infrastructure
    hyprland hyprlock hypridle swww 
    waybar wofi foot dolphin fish swaync
    fastfetch nwg-look qt6ct qt5ct kvantum
    
    # GTK Support & Engines
    gtk3 gtk4 libadwaita
    
    # Audio, Media & Theming
    wireplumber brightnessctl playerctl papirus-icon-theme
    
    # Portability Tools & Apps
    stow xsettingsd 
    
)

# 5. Define Fonts
FONTS=(
    ttf-cascadia-code-nerd ttf-cascadia-mono-nerd 
    ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd 
    ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd 
    ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
)

echo "Installing applications and fonts..."
yay -S --needed --noconfirm "${APPS[@]}" "${FONTS[@]}"

# 6. Directory Setup
# Standard directories for future theme/icon manual installs
mkdir -p ~/.config ~/.cache ~/.themes ~/.icons ~/projects

# 7. Failsafe: Backup Existing Configs to Prevent Stow Conflicts
# This identifies real files/folders that would block symlinks and moves them.
BACKUP_DIR="$HOME/dots_backup_$(date +%Y%m%d_%H%M%S)"

# Items to check based on your dotfiles structure
CONFIG_ITEMS=(
    ".config/hypr"
    ".config/fish"
    ".config/waybar"
    ".config/wofi"
    ".config/foot"
    ".config/fastfetch"
    ".config/qt6ct"
    ".config/kvantum"
    ".config/nwg-look"
    ".zshrc"
    ".gitconfig"
    ".gtkrc-2.0"
)

echo "Checking for existing config files to prevent Stow conflicts..."
for ITEM in "${CONFIG_ITEMS[@]}"; do
    if [ -e "$HOME/$ITEM" ] && [ ! -L "$HOME/$ITEM" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Conflict found: Moving existing $ITEM to $BACKUP_DIR"
        mv "$HOME/$ITEM" "$BACKUP_DIR/"
    fi
done

# 8. Deploy Dotfiles
# Links your managed configs from the dotfiles directory
echo "Deploying dotfiles via stow..."
if [ -f "scripts/stow.sh" ]; then
    chmod +x scripts/stow.sh
    ./scripts/stow.sh
else
    echo "Warning: scripts/stow.sh not found. Linking manually..."
    stow -d dotfiles -t ~ .
fi

# 9. Initial Wallpaper Setup
if [ -f "assets/wallpapers/default.png" ]; then
    echo "Initializing wallpaper..."
    swww-daemon & sleep 2 && ./scripts/set_wallpaper.sh assets/wallpapers/default.png
fi

echo "-------------------------------------------------------"
echo "Installation complete."
if [ -d "$BACKUP_DIR" ]; then
    echo "Safety Note: Existing files were moved to $BACKUP_DIR"
fi
echo "Apps, fonts, and dotfiles are ready."
echo "Manual theme configuration required for GTK/QT."
echo "-------------------------------------------------------"
