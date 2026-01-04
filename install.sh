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
    waybar wofi foot dolphin 
    fastfetch nwg-look qt6ct qt5ct kvantum
    
    # GTK Support & Engines
    gtk3 gtk4 libadwaita
    
    # Portability Tools & Apps
    stow xsettingsd layan-gtk-theme-git
    zen-browser-bin vscodium-bin
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
mkdir -p ~/.config ~/.cache ~/.themes ~/.icons

# 7. Deploy Dotfiles
# Links your managed configs from the dotfiles directory
echo "Deploying dotfiles via stow..."
if [ -f "scripts/stow.sh" ]; then
    chmod +x scripts/stow.sh
    ./scripts/stow.sh
else
    echo "Warning: scripts/stow.sh not found. Linking manually..."
    stow -d dotfiles -t ~ .
fi

# 8. Initial Wallpaper Setup
if [ -f "assets/wallpapers/default.png" ]; then
    echo "Initializing wallpaper..."
    swww-daemon & sleep 2 && ./scripts/set_wallpaper.sh assets/wallpapers/default.png
fi

echo "-------------------------------------------------------"
echo "Installation complete."
echo "Apps, fonts, and dotfiles are ready."
echo "Manual theme configuration required for GTK/QT."
echo "-------------------------------------------------------"