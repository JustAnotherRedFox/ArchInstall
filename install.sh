#!/usr/bin/env bash

# update system clock
timedatectl set-ntp true

# list disk and partitions
fdisk -l

# get name of the device
echo -n "enter device name:"
read -r DEVICE

# format efi partition
mkfs.fat -F32 "${DEVICE}1"

# format linux partition
mkfs.ext4 "${DEVICE}2"

# mount linux partition
mount "${DEVICE}2" /mnt

# create boot directory
mkdir -p /mnt/boot

# mount efi partition
mount "${DEVICE}1" /mnt/boot

# install necessary package
pacstrap /mnt base base-devel linux linux-firmware grub efibootmgr sudo os-prober

# Generate an fstab config
genfstab -U /mnt >> /mnt/etc/fstab

# change root into new system
arch-chroot /mnt



# uncomment locale setting
sed -i -e 's|#en_US.UTF-8 UTF-8|en_US.UTF-8 UTF-8|' /etc/locale.gen 

# generate locale conf
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# set local zone
ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime
hwclock --systohc

# set host name
echo "JustAFox" > /etc/hostname

echo "127.0.0.1     localhost" > /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1     JustAFox.localdomain   JustAFox" >> /etc/hosts

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
