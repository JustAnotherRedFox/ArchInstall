#!/usr/bin/env bash

# clear TTY
clear

# User Account Username
username="JustAnotherRedFox"
userpass=""
rootpass=""

# Select Kernel To be Used/Installed
# linux) stable, Vanilla Linux kernel with a few specific Arch Linux patches applied
# linux-lts) longterm, Long-term support (LTS) Linux kernel
kernel="linux"

# Select Internet Connection Handler
# networkmanager) NetworkManager, Universal network utility (both WiFi and Ethernet, highly recommended)
# wpa) wpa_supplicant: Utility with support for WEP and WPA/WPA2 (WiFi-only, DHCPCD will be automatically installed)
# dhcpcd) dhcpcd: Basic DHCP client (Ethernet connections or VMs)
network_choise="networkmanager"

# Select a Hostname
# Default = JustArch
hostname="JustArch"

# Select a Locale
# Default = en_US.UTF-8"
locale="en_US.UTF-8"

# Select the Keyboard Layout
# Default = us
kblayout="us"

# Select target disk
# nvme*, vd*, sd*
# default = sda
DISK="/dev/sda"

# Setting up a password for the user account (function).
userpass_selector() {
  if [[ -z "$userpass" ]]; then
    echo "You need to enter a password for $username, please set a password."
    exit 1
  fi
}

# Setting up a password for the root account (function).
rootpass_selector () {
    if [[ -z "$rootpass" ]]; then
        echo "You need to enter a password for the root user, please set a password."
        exit 1
    fi
}

# Virtualization Check (Function)
virt_check() {
  hypervisor=$(systemd-detect-virt)
  case $hypervisor in
    kvm) echo "KVM has been detected, setting up guest tools."
          pacstrap /mnt qemu-guest-agent &>/dev/null
          systemctl enable qemu-guest-agent --root=/mnt &>/dev/null
          ;;
    vmware)  echo "VMWare Workstation/ESXi has been detected, setting up guest tools."
              pacstrap /mnt open-vm-tools >/dev/null
              systemctl enable vmtoolsd --root=/mnt &>/dev/null
              systemctl enable vmware-vmblock-fuse --root=/mnt &>/dev/null
              ;;
    oracle)  echo "VirtualBox has been detected, setting up guest tools."
              pacstrap /mnt virtualbox-guest-utils &>/dev/null
              systemctl enable vboxservice --root=/mnt &>/dev/null
              ;;
    microsoft) echo "Hyper-V has been detected, setting up guest tools."
                pacstrap /mnt hyperv &>/dev/null
                systemctl enable hv_fcopy_daemon --root=/mnt &>/dev/null
                systemctl enable hv_kvp_daemon --root=/mnt &>/dev/null
                systemctl enable hv_vss_daemon --root=/mnt &>/dev/null
                ;;
    esac
}

# Installing the chosen networking method to the system (function)
network_installer () {
  case $network_choice in
    networkmanager) echo "Installing and enabling NetworkManager."
        pacstrap /mnt networkmanager >/dev/null
        systemctl enable NetworkManager --root=/mnt &>/dev/null
        ;;
    wpa) echo "Installing and enabling wpa_supplicant and dhcpcd."
        pacstrap /mnt wpa_supplicant dhcpcd >/dev/null
        systemctl enable wpa_supplicant --root=/mnt &>/dev/null
        systemctl enable dhcpcd --root=/mnt &>/dev/null
        ;;
    dhcpcd) echo "Installing dhcpcd."
        pacstrap /mnt dhcpcd >/dev/null
        systemctl enable dhcpcd --root=/mnt &>/dev/null
    esac
}

# Microcode detector (function).
microcode_detector () {
  CPU=$(grep vendor_id /proc/cpuinfo)
  if [[ "$CPU" == *"AuthenticAMD"* ]]; then
    echo "An AMD CPU has been detected, the AMD microcode will be installed."
    microcode="amd-ucode"
  else
    echo "An Intel CPU has been detected, the Intel microcode will be installed."
    microcode="intel-ucode"
  fi
}

echo
echo "Starting Arch Installation"
echo 

loadkeys "$kblayout"

# sets up user/root account
userpass_selector
rootpass_selector

# Warn user about deletion of old partition scheme.
echo "This will delete the current partition table on $DISK once installation starts. Do you agree [y/N]?: "
read -r disk_response
if ! [[ "${disk_response,,}" =~ ^(yes|y)$ ]]; then
  echo "Quitting."
  exit
fi

echo "Wiping $DISK."

#===========================================================
# ============= Method 2 for formating partition ===========

wipefs -af ${DISK} # recommended if you want to swap partition table types

echo "label: gpt
device: ${DISK}
unit: sectors

# Efi partition 512MB
${DISK}1: size=512MiB,type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B

# Swap Partition 4GB
${DISK}2 : size=4096MiB,type=0657FD6D-A4AB-43C4-84E5-0933C84B4F4F

# Root Partition, rest of the space
${DISK}3 : type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
" | sfdisk ${DISK}

# Format FIle systems
mkfs.fat -F32 ${DISK}1
mkswap ${DISK}2
mkfs.ext4 ${DISK}3

# Mounting Partitions
mount ${DISK}3 /mnt            # Mount root(/)
mkdir -p /mnt/boot/efi         # Making efi folder
mount ${DISK}1 /mnt/boot/efi   # Mounting boot
swapon ${DISK}2                # activating swap
#===========================================================

# checking microcode to install
microcode_detector

# Pacstrap (setting up a base sytem onto the new root)
echo "Installing base system (It may take a while)"
pacstrap -K /mnt base "$kernel" "$microcode" linux-firmware "$kernel"-headers grub efibootmgr sudo &>/dev/null

# setting up hostname
echo "$hostname" > /mnt/etc/hostname

# Generating fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Configure selected locale
sed -i "/^#$locale/s/^#//" /mnt/etc/locale.gen
echo "LANG=$locale" > /mnt/etc/locale.conf
echo "KEYMAP=$kblayout" > /mnt/etc/vconsole.conf

# Setting hosts file.
echo "Setting hosts file."
cat > /mnt/etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain   $hostname
EOF

# Virtualization check.
virt_check

# Setting up the network.
network_installer

#===========================================================
# Configuring the system.
echo "Configuring the system (timezone, system clock, GRUB)."
arch-chroot /mnt /bin/bash -e <<EOF

    # Setting up timezone.
    ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime &>/dev/null

    # Setting up clock.
    hwclock --systohc

    # Generating locales.
    locale-gen &>/dev/null

    # Generating a new initramfs.
    # mkinitcpio -P &>/dev/null

    # Installing GRUB.
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB &>/dev/null

    # Creating grub config file.
    grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null

EOF

# Setting root password.
echo "Setting root password."
echo "root:$rootpass" | arch-chroot /mnt chpasswd

# Setting user password.
if [[ -n "$username" ]]; then
    echo "%wheel ALL=(ALL:ALL) ALL" > /mnt/etc/sudoers.d/wheel
    echo "Adding the user $username to the system with root privilege."
    arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$username"
    echo "Setting user password for $username."
    echo "$username:$userpass" | arch-chroot /mnt chpasswd
fi

# Boot backup hook.
echo "Configuring /boot backup when pacman transactions are made."
mkdir /mnt/etc/pacman.d/hooks
cat > /mnt/etc/pacman.d/hooks/50-bootbackup.hook <<EOF
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Path
Target = usr/lib/modules/*/vmlinuz

[Action]
Depends = rsync
Description = Backing up /boot...
When = PostTransaction
Exec = /usr/bin/rsync -a --delete /boot /.bootbackup
EOF

# ZRAM configuration.
echo "Configuring ZRAM."
cat > /mnt/etc/systemd/zram-generator.conf <<EOF
[zram0]
zram-size = min(ram, 8192)
EOF

# Pacman eye-candy features.
echo "Enabling colours, animations, and parallel downloads for pacman."
sed -Ei 's/^#(Color)$/\1\nILoveCandy/;s/^#(ParallelDownloads).*/\1 = 10/' /mnt/etc/pacman.conf

# Finishing up.
echo "Done, please 'umount -R /mnt' and then reboot (further changes can be done by chrooting into /mnt)."
exit
