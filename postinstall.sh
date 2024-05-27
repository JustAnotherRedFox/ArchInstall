#!/usr/bin/env bash

#-----------------------------------
# Local Time and Hosts
#---------------------------------

# set local zone
ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime
hwclock --systohc

# generate locale conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen 
locale-gen
cat >> /etc/locale.conf << EOF
LANG=en_US.UTF-8
EOF

# set host name
echo "JustAFox" > /etc/hostname

cat >> /etc/hosts << EOF
127.0.0.1	localhost
::1		localhost
127.0.1.1	JustAFox.localdomain	JustAFox
EOF

#---------------------------------------------------
# GRUB/Bootloader
#---------------------------------------------------

pacman -S --noconfirm --needed grub efibootmgr base-devel linux-lts-headers networkmanager network-manager-applet




grub-install --target=x86_64-efi --bootloader-id=Arch --efi-directory=/boot/efi
 
grub-mkconfig -o /boot/grub/grub.cfg









# set root password
passwd


# nvim /etc/pacman.conf

# adding to mirror list to allow use of 32bit app on 64bit app
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# add mirrorlist for Arch User Repositories(AUR)
echo "[archlinuxfr]" >> /etc/pacman.conf
echo "SigLevel = Never" >> /etc/pacman.conf
echo "Server = http://repo.archlinux.fr/$arch" >> /etc/pacman.conf

# update all packeges
pacman -Syu



# install and configure grub
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg



# Create user account
useradd -m -g users -G wheel JustAFox

# setting password for user
passwd JustAFox

# adding users to list of sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# unmount partitions
umount /mnt/boot /mnt

echo "Please reboot the device and execute postinstall.sh"
































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
    'xf86-video-intel'            # 2D/3D video driver
    'mesa'                        # Open source version of OpenGL
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo
echo "Done!"
echo

#=============================================
# DESKTOP ENVIRONMENT
#=============================================
echo
echo "INSTALLING I3WM"
echo

PKGS=(
        'i3-wm'                 # I3 Tilling Manager
        'polybar'         # status bar
        'dmenu'              # app selector
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo
echo "Done!"
echo

#==============================================
# NETWORK COMPONENTS
#==============================================
echo
echo "INSTALLING NETWORK COMPONENTS"
echo

PKGS=(
        'dialog'                    # Enables shell scripts to trigger dialog boxex
        'networkmanager'            # Network connection manager
        'network-manager-applet'    # System tray icon/utility for network connectivity
        'dhclient'                  # DHCP client
        'libsecret'                 # Library for storing passwords
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

# enable NetworkManager systemd service
systemctl enable NetworkManager
echo
echo "Done!"
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
            'volumeicon'        # System tray volume control
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo
echo "Done!"
echo

#===============================================
# SOFTWARES
#==============================================
echo
echo "INSTALLING SOFTWARE"
echo

PKGS=(

    # SYSTEM --------------------------------------------------------------

    'linux-lts'             # Long term support kernel
    'ttf-fira-code'         # system font 
    'ttf-font-awesome'      # system fonts

    # TERMINAL UTILITIES --------------------------------------------------

    'curl'                  # Remote content retrieval
    'feh'                   # Terminal-based image viewer/manipulator
    'htop'                  # System monitoring via terminal
    'neofetch'              # Shows system info when you launch terminal
    'ntp'                   # Network Time Protocol to set time via network.
    'numlockx'              # Turns on numlock in X11
    'openssh'               # SSH connectivity tools
    'terminus-font'         # Font package with some bigger fonts for login terminal
    'xclip'                 # clipboard manager
    'p7zip'                 # Zip compression program
    'wget'                  # Remote content retrieval
    'alacritty '            # Terminal emulator
    'picom'                 # compositor
    'zsh'                   # ZSH shell
    'zsh-completions'       # Tab completion for ZSH



    # DEVELOPMENT ---------------------------------------------------------

    'apache'                # Apache web server
    'clang'                 # C Lang compiler
    'cmake'                 # Cross-platform open-source make system
    'git'                   # Version control system
    'gcc'                   # C/C++ compiler
    'glibc'                 # C libraries
    'nodejs'                # Javascript runtime environment
    'npm'                   # Node package manager
    'php'                   # Web application scripting language
    'php-apache'            # Apache PHP driver
    'python'                # Scripting language
    'yarn'                  # Dependency management (Hyper needs this)
    'visual-studio-code-bin'

    # WEB TOOLS -----------------------------------------------------------

    'brave-bin'              # Web browser

    # MEDIA ---------------------------------------------------------------

    'lollypop'              # Music player

    # GRAPHICS AND DESIGN -------------------------------------------------

    'imagemagick'           # Command line image manipulation tool
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo
echo "Done!"
echo

# move to /Home and cloning git repository with Dotfiles
cd ~/
git clone https://github.com/JustAnotherRedFox/.config.git

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
