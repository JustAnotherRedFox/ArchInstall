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
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

#-------------------------------------------------
# Setting User
#--------------------------------------------------

# setting Root Password
passwd

# Create user account
useradd -m -g users -G wheel JustAFox

# setting password for user
passwd JustAFox

# adding users to list of sudo
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
