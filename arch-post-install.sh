#!/bin/sh

echo "Starting Post-Install"
echo "Updating system"
sudo pacman -Syu

echo "Installing essential packages$"
sudo pacman -S p7zip nwg-look gvfs-mtp cliphist waylock pavucontrol wlsunset tllist zsh git htop curl wget neovim neofetch dunst brightnessctl wob ttf-hack ttf-jetbrains-mono ttf-roboto ttf-dejavu noto-fonts noto-fonts-extra noto-fonts-cjk wlroots wayland-protocols pixman tllist fcft foot lf chafa libsixel thunar file-roller thunar-archive-plugin swww feh mpv zathura zathura-pdf-poppler bluez bluez-utils xorg-xwayland ufw

echo "Post-instal setup complete!"
