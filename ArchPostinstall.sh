#!/usr/bin/env bashs

# Update System
Sudo pacman -Syu

# Fonts
sudo pacman -S noto-fonts ttf-ubuntu-font-family ttf-fira-code ttf-font-awesome --needed --noconfirm

# Environment
sudo pacman -S \ 
    xf86-video-intel \      # Intel Video Driver
    xorg-server \           # XOrg Server 
    xorg-xinit \            # XOrg Init 
    i3-wm \                 # Windows Manager
    polybar \               # Status Bar
    dmenu \                 # App selector
    mesa \                  # Open Source Version of OpenGL
    --needed --noconfirm

# Audio
sudo pacman -S \ 
    alsa-utils \            # Advanced Linux Sound Architecture (ALSA) Components https://alsa.opensrc.org/
    alsa-plugins \          # ALSA plugins
    pulseaudio \            # Pulse Audio sound components
    pulseaudio-alsa \       # ALSA configuration for pulse audio
    pavucontrol             # Pulse Audio volume control --needed --noconfirm
	
# Applications
sudo pacman -S \ 
    alacritty \             # terminal emulator
    picom \                 # Compositor
    git \                   # Version Control System
    neofetch \              # System Info
    htop \                  # System monitoring via terminal
    wget \                  # Remote Content Retrival 
    feh \                   # Terminal-based image viewer/manipulator 
    xclip \                 # clipboard manager
    neovim \                # File Editor 
    zsh \                   # ZSH Shell
    p7zip \                 # Zip Conpression Program 
    brave-bin \             # Web Browser
    --needed

    # lollypop              # Music Player
    # imagemagick           # Command line image manipulation tool

# move to /Home and cloning git repository with Dotfiles
git clone https://github.com/JustAnotherRedFox/.config.git ~/.config

# MOVING ALL CONFIG FROM GIT REPO TO MACHINE
# [Creating Symbolic Links]
ln -s ~/.config/h_cfg/.fehbg ~/.fehbg
ln -s ~/.config/h_cfg/.fonts ~/.fonts
ln -s ~/.config/h_cfg/.gitconfig ~/.gitconfig
ln -s ~/.config/h_cfg/.oh-my-zsh ~/.oh-my-zsh
ln -s ~/.config/h_cfg/.ssh ~/.ssh
ln -s ~/.config/h_cfg/.xinitrc ~/.xinitrc
ln -s ~/.config/h_cfg/.Xresources ~/.Xresources
ln -s ~/.config/h_cfg/.zshrc ~/.zshrc

wait

# [Updating URxvt]
xrdb ~/.Xresources

# [Updating Fonts]
fc-cache -fv #fc-list to list all fonts

echo "please Reboot the Machine"


