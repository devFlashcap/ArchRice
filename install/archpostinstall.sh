#!/bin/bash

cd "$(dirname "$0")"
echo "Setting the timezone -------------------------------------------------------"
read -p 'Timezone (Region/City): ' timezone
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc

echo "Generating locale ----------------------------------------------------------"
locale='en_US.UTF-8'
sed -i "s/#${locale}/${locale}/" /etc/locale.gen
locale-gen
echo "LANG=${locale}" > /etc/locale.conf

echo "Setting hostname -----------------------------------------------------------"
read -p 'Hostname: ' hostname
echo $hostname > /etc/hostname

echo "Setting up admin previlages for wheel group --------------------------------"
echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo

echo "Setting up users -----------------------------------------------------------"
passwd
read -p 'Username: ' username
useradd -m -g users -G audio,video,network,wheel,storage,rfkill -s /bin/bash $username
passwd $username

echo "Setting up GRUB -----------------------------------------------------------"
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

./ricepkg.sh
