#!/usr/bin/env bash

# set the system clock
timedatectl set-ntp true

# Mount the / partition in /mnt
mount /dev/sda3 /mnt

# edit the pacman.conf file to enable multilib repository(used to run 32-bits software and libraries)
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# Install Essential Packages
pacstrap /mnt base base-devel linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

# Change Root into new system
arch-chroot /mnt # The Comand Stop The Execution Of THe Script
ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime

# Date and locale Setup
hwclock --systohc
sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "JustAFox" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1   localhost" >> /etc/hosts
echo "127.0.1.1 JustAFox.localdomain  JustAFox" >> /etc/hosts

# Set Root Password
passwd

# Bootloader Setup
pacman -S grub efibootmgr os-prober --needed --noconfirm
mkdir -p /boot/efi
mount /dev/sda1 /boot/efi

grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S \
    dialog \                    # Enables shell scripts to trigger dialog boxex 
    networkmanager \            # Netword Connection Manager
    network-manager-applet \    # System tray icon/utility for network connectivity 
    mtools \ 
    sudo  
# enable Netword
systemctl enable NetworkManager

# User Setup
useradd -m -g users -G wheel JustAFox
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
passwd JustAFox

cp ./ArchPostinstall.sh /mnt/root/

# Exiting and Rebooting System
exit
umount -R /mnt
reboot
