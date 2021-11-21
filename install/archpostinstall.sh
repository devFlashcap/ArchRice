#!/bin/bash

cd "$(dirname "$0")"

read -p 'Timezone (Region/City): ' timezone
read -p 'Hostname: ' hostname
locale='en_US.UTF-8'

sed -e "s/#${locale}/${locale}/" /etc/locale.gen
locale.gen
echo "LANG=${locale}" > /etc/locale.conf
echo $hostname > /etc/hostname
passwd

pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

./ricepkg.sh
