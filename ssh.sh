#!/bin/bash

mount_point="/mnt/usb"
sudo mkdir -p "$mount_point"

if [ -b /dev/sda1 ]; then
  if ! mount | grep -q /dev/sda1; then
    sudo mount /dev/sda1 "$mount_point"
  else
    echo "/dev/sda1 is already mounted."
    exit 1
  fi
else
  echo "/dev/sda1 does not exist."
  exit 1
fi

if [ -d "$mount_point/.ssh" ]; then
  rsync -avz --delete "$mount_point/.ssh" "$HOME"
  chown -R "$USER:$USER" "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  chmod 600 "$HOME/.ssh/id_ed25519"
  chmod 644 "$HOME/.ssh/id_ed25519.pub"
else
  echo "No .ssh directory found on the USB drive."
fi

cp -r "$mount_point"/* ~/misc/
