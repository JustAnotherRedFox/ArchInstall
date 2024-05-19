# Pre-Install
## Checking Disk and Creating Partitions
- First Get the name of the disk and see if has any data on it
> fdisk -l

- initiate 'parted' on disk (it could be: sda, sdb, nvml01, etc)
> parted /dev/sda

- Create partitions using parted, set volume as gpt
> (parted) mklabel gpt
> (parted) mkpart primary 1MiB 512MiB name 1 boot
> (parted) set 1 boot on
> (parted) mkpart primary 512MiB 100% name 2 root
> (parted) quit

## Update Mirror List
- Open the mirror list and uncomment only the server of your country/region
> vim /etc/pacman.d/mirrorlist

- make a backup of the mirror list
> sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

- take the server data from the backup mirrorlist, rank them, then copy the data to the original mirrorlist file
> rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
