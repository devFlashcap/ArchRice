#!/bin/bash

read -p 'Device: ' partition_device
read -p 'EFI System partition size: ' partition_efi_size
read -p 'SWAP partition size: ' partition_swap_size

timedatectl set-ntp true
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << FDISK_CMDS | fdisk $partition_device
g			# create GPT table
n			# create new partition
1			# partition number
			# select default first sector
$partition_efi_size	# partition size
n			# create new partition
2			# partition number
			# select default first sector
$partition_swap_size	# partition size
n			# create new partition
3			# partition number
			# select default first sector
			# use remaining space
t			# change partition type
1			# select partition number 1
1			# select partition type EFI System
t			# select partition type
2			# select partition number 2
19			# select partition type Linux Swap
w			# write changes to disk
FDISK_CMDS

partition_efi="${partition_device}1"
partition_swap="${partition_device}2"
partition_root="${partition_device}3"

mkfs.fat -F32 $partition_efi
mkswap $partition_swap
swapon $partition_swap
mkfs.ext4 $partition_root

mount $partition_root /mnt
mkdir -p /mnt/boot/efi
mount $partition_efi /mnt/boot/efi

pacstrap /mnt base base-devel linux linux-firmware vim git
genfstab -U /mnt >> /mnt/etc/fstab
mkdir /mnt/archrice
mv . /mnt/archrice
arch-chroot /mnt /mnt/archrice/install/archpostinstall.sh
