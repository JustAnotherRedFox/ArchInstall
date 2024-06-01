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

- Create partitions using cfdisk:
- partition type: gpt
- Partition   |  Size  |  Format
- Boot        | 512M   | EFI System
- Swap        | 2x ram | Linux Swap (optional)
- /           | all    | Linux Filesystem
- Write disk modifications and quit
  
# Manual Format Partition 
> mkfs.fat -F32 /dev/sda1
> mkswap /dev/sda2
> swapon /dev/sda2
> mkfs.ext4 /dev/sda3

## Execute Install script
sh ArchInstall/ArchInstall.sh

- restart the computer
- login as User

- execute final steps script
> sudo cp /root/ArchPostinstall.sh ~/
> sh ~/ArchPostinstall.sh
> xinit
> startx
