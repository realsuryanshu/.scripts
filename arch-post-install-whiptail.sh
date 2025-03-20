#!/bin/sh

# Function to display a message using whiptail
show_message() {
    whiptail --title "$1" --msgbox "$2" 10 50
}

# Function to ask for confirmation using whiptail
ask_confirmation() {
    whiptail --title "$1" --yesno "$2" 10 50
    return $?
}

# Start Post-Install Process
show_message "Post-Install Script" "Welcome to the Arch Linux Post-Install Script. Press OK to continue."

# Ask for confirmation before updating the system
if ask_confirmation "System Update" "Do you want to update your system now?"; then
    echo "Updating system..."
    sudo pacman -Syu || show_message "Error" "System update failed!"
else
    show_message "Update Skipped" "System update has been skipped."
fi

# Ask for confirmation before installing essential packages
if ask_confirmation "Install Packages" "Do you want to install essential packages?"; then
    echo "Installing essential packages..."
    sudo pacman -S --noconfirm p7zip nwg-look man gvfs-mtp cliphist waylock wlsunset tllist zsh git htop curl wget neovim dunst neofetch pavucontrol brightnessctl wob ttf-hack ttf-jetbrains-mono ttf-roboto ttf-dejavu ttf-nerd-fonts-symbols noto-fonts noto-fonts-extra noto-fonts-cjk wlroots wayland-protocols pixman fcft foot lf chafa libsixel thunar file-roller thunar-archive-plugin swww gimp obsidian keepassxc libreoffice-fresh feh mpv zathura zathura-pdf-poppler papirus-icon-theme bluez bluez-utils xorg-xwayland || show_message "Error" "Package installation failed!"
else
    show_message "Installation Skipped" "Essential package installation has been skipped."
fi

# Install yay (AUR helper)
if ask_confirmation "Install yay (AUR Helper)" "Do you want to install yay (AUR helper)?"; then
    echo "Installing yay..."
    mkdir ~/yay
    git clone https://aur.archlinux.org/yay-bin.git ~/yay 
    cd ~/yay || exit
    makepkg -si || show_message "Error" "Failed to install yay!"
    cd || exit
    rm -rf yay

    # Remove debug version of yay if installed
    sudo pacman -Rns yay-bin-debug || show_message "Error" "Failed to remove yay-bin-debug!"
else
    show_message "Installation Skipped" "yay installation has been skipped."
fi

# Install AUR packages using yay
if ask_confirmation "Install AUR Packages" "Do you want to install AUR packages (e.g., Brave browser)?"; then
    echo "Installing AUR packages..."
    yay -Sy --noconfirm --needed brave-bin || show_message "Error" "Failed to install AUR packages!"
else
    show_message "Installation Skipped" "AUR package installation has been skipped."
fi

# Change default shell to zsh
if ask_confirmation "Change Default Shell" "Do you want to change the default shell to zsh?"; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)" || show_message "Error" "Failed to change default shell!"
else
    show_message "Shell Change Skipped" "Default shell change has been skipped."
fi

# Clone and set up configuration files and scripts
echo "Setting up configuration files and scripts..."
mkdir ~/.temp ~/.temp/.config ~/.temp/SucklessWayland ~/.temp/.scripts

git clone https://github.com/realsuryanshu/.config.git ~/.temp/.config && \
git clone https://github.com/realsuryanshu/SucklessWayland.git ~/.temp/SucklessWayland && \
git clone https://github.com/realsuryanshu/.scripts.git ~/.temp/.scripts || \
show_message "Error" "Failed to clone repositories!"

mkdir ~/.cfg ~/.etc ~/.etc/suckless

mv ~/.temp/.config/* ~/.cfg/
mv ~/.temp/SucklessWayland/* ~/.etc/suckless/
mv ~/.temp/.scripts ~/

sudo ln -s ~/.scripts/* /usr/local/bin || show_message "Error" "Failed to link scripts!"
sudo rm -rf /usr/local/bin/statusbar /usr/local/bin/arch-post-install.sh

ln -s ~/.cfg/dunst ~/.config/
ln -s ~/.cfg/foot ~/.config/
ln -s ~/.cfg/lf ~/.config/
ln -s ~/.cfg/wob ~/.config/
ln -s ~/.cfg/zsh/.* ~/

cd ~/.etc/suckless/dwl || exit
sudo make clean install || show_message "Error" "Failed to build dwl!"

cd ~/.etc/suckless/mew || exit
sudo make clean install || show_message "Error" "Failed to build mew!"

rm -rf ~/.temp

show_message "Post-Install Complete!" "Your system setup is complete!"

