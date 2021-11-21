#!/bin/bash

while IFS=; read -r package service autostart; do
	pacman -S $package
	if [ $autostart == "true" ]
	then
		systemctl enable $service
	fi
done < ./ricepkgs
