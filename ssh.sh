#!/bin/bash

mount_point="/mnt/usb"

if [ -b /dev/sda1 ]; then
	if ! mount | grep -q /dev/sda1; then
		sudo mkdir -p $mount_point
		sudo mount /dev/sda1 $mount_point
	else
		echo "/dev/sda1 is already mounted."
		exit 1
	fi
else
	echo "/dev/sda1 does not exist as a block device."
	exit 1
fi

if [ -d "$mount_point/.ssh" ]; then
	eval home=~$USER
	sudo cp -rp $mount_point/.ssh "$home"
	sudo chown -R $USER:$USER "$home/.ssh"
	chmod 700 ~/.ssh
	chmod 600 ~/.ssh/id_ed25519
	chmod 644 ~/.ssh/id_ed25519.pub
	echo ".ssh folder copied successfully."
else
	echo "No .ssh directory found on the USB drive."
fi

sudo umount $mount_point
echo "USB drive unmounted."
