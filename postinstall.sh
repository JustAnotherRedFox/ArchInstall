#!/usr/bin/env bash

# Update System
Sudo pacman -Syu

#=============================================
#   XORG COMPONENTS
#=============================================
echo
echo "installing xorg"
echo 

PKGS=(
    'xorg-server'                 # XOrg server
    'xorg-apps'                   # XOrg apps group
    'xorg-xinit'                  # XOrg init
    'xf86-video-intel'            # Intel video driver
    'mesa'                        # Open source version of OpenGL
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed &>/dev/null
done

echo
echo "Xorg Installed!"
echo

#=============================================
# DESKTOP ENVIRONMENT
#=============================================
echo
echo "INSTALLING I3WM"
echo

PKGS=(
        'i3-wm'                 # I3 Tilling Manager
        'polybar'               # status bar
        'dmenu'                 # app selector
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed &>/dev/null
done

echo
echo "DE Installed!"
echo

#===========================================
# AUDIO COMPONENTS
#============================================
echo
echo "INSTALLING AUDIO COMPONENTS"
echo

PKGS=(
            'alsa-utils'        # Advanced Linux Sound Architecture (ALSA) Components https://alsa.opensrc.org/
            'alsa-plugins'      # ALSA plugins
            'pulseaudio'        # Pulse Audio sound components
            'pulseaudio-alsa'   # ALSA configuration for pulse audio
            'pavucontrol'       # Pulse Audio volume control
            #'volumeicon'       # System tray volume control
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed &>/dev/null
done

echo
echo "Audio Installed!"
echo

#===============================================
# SOFTWARES
#==============================================
echo
echo "INSTALLING SOFTWARE"
echo

PKGS=(

    # SYSTEM --------------------------------------------------------------
    'ttf-fira-code'         # system font fira code
    'ttf-font-awesome'      # system font awesome
    'noto-fonts'            # system font noto-sams
    'ttf-ubuntu-font-family'# system font ubunto-family

    # TERMINAL UTILITIES --------------------------------------------------

    'curl'                  # Remote content retrieval
    'wget'                  # Remote content retrieval
    'feh'                   # Terminal-based image viewer/manipulator
    'htop'                  # System monitoring via terminal
    'neofetch'              # Shows system info when you launch terminal
    #'ntp'                   # Network Time Protocol to set time via network.
    #'numlockx'              # Turns on numlock in X11
    'openssh'               # SSH connectivity tools
    #'terminus-font'         # Font package with some bigger fonts for login terminal
    'xclip'                 # clipboard manager
    'p7zip'                 # Zip compression program
    'alacritty '            # Terminal emulator
    'picom'                 # compositor
    'zsh'                   # ZSH shell
    'zsh-completions'       # Tab completion for ZSH
    'neovim'                # text editor



    # DEVELOPMENT ---------------------------------------------------------

    #'apache'                # Apache web server
    #'clang'                 # C Lang compiler
    'cmake'                 # Cross-platform open-source make system
    'git'                   # Version control system
    'gcc'                   # C/C++ compiler
    'glibc'                 # C libraries
    #'nodejs'                # Javascript runtime environment
    #'npm'                   # Node package manager
    #'php'                   # Web application scripting language
    #'php-apache'            # Apache PHP driver
    'python'                # Scripting language
    #'yarn'                  # Dependency management (Hyper needs this)
    #'visual-studio-code-bin'# Visual Studio Code

    # WEB TOOLS -----------------------------------------------------------

    'firefox'              # Web browser

    # MEDIA ---------------------------------------------------------------

    #'lollypop'              # Music player

    # GRAPHICS AND DESIGN -------------------------------------------------

    #'imagemagick'           # Command line image manipulation tool
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed &>/dev/null
done

echo
echo "Software Installed!"
echo

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

echo "You may now reboot the machine"
