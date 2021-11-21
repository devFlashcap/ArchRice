#!/bin/bash

echo "Updating mirrorlist -----------------------------------------------------"
pacman -S reflector
reflector --latest 20 --protocol https --country $country --verbose --sort rate --save /etc/pacman.d/mirrorlist

echo "Installing packages -----------------------------------------------------"
while IFS=; read -r package service autostart; do
	pacman -S $package
	if [ $autostart == "true" ]
	then
		systemctl enable $service
	fi
done < ./ricepkgs
