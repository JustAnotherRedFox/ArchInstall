#!/usr/bin/env bash

# update system clock
timedatectl set-ntp true

# list disk and partitions
fdisk -l

# get name of the device
echo -n "enter device name:"
read -r DEVICE

# format efi partition
#mkfs.fat -F32 "${DEVICE}1"

# format linux partition
#mkfs.ext4 "${DEVICE}2"

# mount linux partition
mount "${DEVICE}2" /mnt

# create boot directory
mkdir -p /mnt/boot

# mount efi partition
mount "${DEVICE}1" /mnt/boot/efi

#-----------------------------
# Updating Mirror List
#----------------------------
reflector \
	--country Canada,Brazil \
	--age 12 \
	--protocol https \
	--fastest 5 \
	--latest 20 \
	--sort rate \
	--save /etc/pacman.d/mirrorlist

 pacman -Syy

#-----------------------------------
# Packages and FStab
#-----------------------------------

# install necessary package
pacstrap /mnt base linux linux-lts linux-firmware intel-ucode

# Generate an fstab config
genfstab -U /mnt >> /mnt/etc/fstab

# move sh to root
cp -a *.sh /mnt/root/


