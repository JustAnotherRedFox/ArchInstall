#!/usr/bin/env bashs

# Update System
Sudo pacman -Syu

# Fonts
sudo pacman -S noto-fonts ttf-ubuntu-font-family ttf-fira-code ttf-font-awesome --needed --noconfirm

# Environment
sudo pacman -S  alsa-plugins pulseaudio pulseaudio-alsa pavucontrol alsa-utils xf86-video-intel  xorg-server xorg-xinit i3-wm  polybar  dmenu  mesa  --needed --noconfirm
	
# Applications
sudo pacman -S alacritty picom git neofetch htop wget feh xclip neovim zsh p7zip brave-bin --needed --noconfirm

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


