#!/bin/sh

# Function to display a message using dialog
show_message() {
    dialog --title "$1" --msgbox "$2" 10 50
}

# Function to display a progress bar using dialog
show_progress() {
    ( 
        echo "Starting Post-Install"
        sleep 1
        
        echo "Updating system"
        sleep 1
        sudo pacman -Syu
        
        echo "Installing essential packages"
        sleep 1
        sudo pacman -S --noconfirm p7zip nwg-look man gvfs-mtp cliphist waylock wlsunset tllist zsh git htop curl wget neovim dunst neofetch pavucontrol brightnessctl wob ttf-hack ttf-jetbrains-mono ttf-roboto ttf-dejavu ttf-nerd-fonts-symbols noto-fonts noto-fonts-extra noto-fonts-cjk wlroots wayland-protocols pixman fcft foot lf chafa libsixel thunar file-roller thunar-archive-plugin swww gimp obsidian keepassxc libreoffice-fresh feh mpv zathura zathura-pdf-poppler papirus-icon-theme bluez bluez-utils xorg-xwayland
        
        echo "Installing yay (AUR helper)"
        mkdir ~/yay
        git clone https://aur.archlinux.org/yay-bin.git ~/yay 
        cd ~/yay
        makepkg -si
        cd 
        rm -rf yay
        
        sudo pacman -Rns yay-bin-debug
        
        echo "Installing AUR packages"
        yay -Sy --noconfirm --needed brave-bin
        
        echo "Changing default shell to zsh"
        chsh -s $(which zsh)
        
        mkdir ~/.temp
        mkdir ~/.temp/.config
        mkdir ~/.temp/SucklessWayland
        mkdir ~/.temp/.scripts
        
        git clone https://github.com/realsuryanshu/.config.git ~/.temp/.config && git clone https://github.com/realsuryanshu/SucklessWayland.git ~/.temp/SucklessWayland && git clone https://github.com/realsuryanshu/.scripts.git ~/.temp/.scripts
        
        mkdir ~/.cfg
        mkdir ~/.etc
        mkdir ~/.etc/suckless
        
        mv ~/.temp/.config/* ~/.cfg/
        mv ~/.temp/SucklessWayland/* ~/.etc/suckless/
        mv ~/.temp/.scripts ~/
        
        sudo ln -s ~/.scripts/* /usr/local/bin
        sudo rm -rf /usr/local/bin/statusbar
        sudo rm /usr/local/bin/arch-post-install.sh
        
        ln -s ~/.cfg/dunst ~/.config/
        ln -s ~/.cfg/foot ~/.config/
        ln -s ~/.cfg/lf ~/.config/
        ln -s ~/.cfg/wob ~/.config/
        ln -s ~/.cfg/zsh/.* ~/
        
        cd ~/.etc/suckless/dwl
        sudo make clean install
        cd ~/.etc/suckless/mew
        sudo make clean install
        
        rm -rf ~/.temp

    ) | dialog --title "Post-Install Progress" --progressbox "Please wait while the installation completes..." 20 70
    
    show_message "Post-install setup complete!" "Your system has been successfully set up!"
}

# Start the process with a welcome message
show_message "Welcome" "This script will set up your Arch Linux environment. Press OK to continue."
show_progress

# End of script

