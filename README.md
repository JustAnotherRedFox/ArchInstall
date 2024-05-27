# Pre-Install
- update the mirrorlist
> pacman -Sy

- download git
> pacman -S git

- clone arch install.sh
> git clone https://github.com/JustAnotherRedFox/ArchInstall.git

## Checking Disk and Creating Partitions
- First Get the name of the disk and see if has any data on it
> fdisk -l

- initiate 'cfdisk' on disk (it could be: sda, sdb, nvml01, etc)
> cfdisk /dev/sda

- Create partitions using cfdisk
partition type: gpt
Partition   |  Size  |  Format
  Boot      | 512M   | EFI System
  Swap      | 2x ram | Linux Swap (optional)
  /         | all    | Linux Filesystem
- Write disk modifications and quit
  
# Manual Format Partition 
> mkfs.fat -F32 /dev/sda1
> mkfs.ext4 /dev/sda2

- if using swap
> mkswap /dev/sda3
> swapon /dev/sda3

## Update Mirror List
- Open the mirror list and uncomment only the server of your country/region
> vim /etc/pacman.d/mirrorlist

- make a backup of the mirror list
> sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

- take the server data from the backup mirrorlist, rank them, then copy the data to the original mirrorlist file
> rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
