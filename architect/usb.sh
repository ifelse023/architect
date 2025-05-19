#!/bin/bash
set -e
# Define variables
MOUNT_POINT="/mnt/usb"
USB="/dev/disk/by-label/linux-usb"

# Create mount point if it doesn't exist
if [ ! -d "$MOUNT_POINT" ]; then
  sudo mkdir "$MOUNT_POINT"
fi

# Check if USB device exists
if [ -e "$USB" ]; then
  # Check if device is already mounted
  if ! mount | grep -q "$USB"; then
    sudo mount "$USB" "$MOUNT_POINT"
  else
    echo "$USB is already mounted."
  fi
else
  echo "$USB does not exist."
  exit 1
fi

# Define ssh paths
SSH_SOURCE="$MOUNT_POINT/.ssh"
SSH_DEST="$HOME/.ssh"

# Copy SSH keys if they exist
if [ -d "$SSH_SOURCE" ]; then
  rsync -avz --delete "$SSH_SOURCE" "$HOME"

  sudo chown -R "$USER:users" "$SSH_DEST"

  chmod 600 "$SSH_DEST/id_ed25519"
  chmod 644 "$SSH_DEST/id_ed25519.pub"
else
  echo "No .ssh directory found on the USB drive."
fi

# Copy misc files
MISC_DEST="$HOME/misc"
if [ ! -d "$MISC_DEST" ]; then
  mkdir "$MISC_DEST"
fi

cp -r "$MOUNT_POINT/books" "$MISC_DEST"
cp -r "$MOUNT_POINT/git.sh" "$MISC_DEST"
mkdir ~/semester

git clone git@github.com:ifelse023/SoSe25.git ~/semester/SoSe25
git clone git@github.com:ifelse023/se-project.git ~/semester/se-project
git clone git@github.com:ifelse023/lazyvim-config.git ~/.config/nvim
git clone git@github.com:ifelse023/dev-templates.git ~/misc/dev-templates
sudo umount /mnt/usb
