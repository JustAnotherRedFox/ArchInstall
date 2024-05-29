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
> mkfs.ext4 /dev/sda2

- if using swap
> mkswap /dev/sda3
> swapon /dev/sda3

## Execute Install script
sh ArchInstall/install.sh

- initiate the second part - the post install
- change to chroot
> arch-chroot /mnt

- as chroot execute the postinstall script
> sh /root/postinstall.sh

- copy finalsteps script to users home dir.
> cp /root/finalsteps.sh /home/**/

- exit and umnount chroot
> exit
> umount -R /mnt

- restart the computer

- login as User
- execute final steps script
sh ~/finalsteps.sh
