#!/bin/sh
set -eu

FIREFOX_DIR="$HOME/.mozilla/firefox"
USB_LABEL_DEV="/dev/disk/by-label/linux-usb"
USB_MOUNT="/mnt/usb"

# Check USB mount
if ! mountpoint -q "$USB_MOUNT"; then
  echo "$USB_MOUNT is not mounted. Attempting to mount $USB_LABEL_DEV..."
  if ! mount "$USB_LABEL_DEV" "$USB_MOUNT"; then
    echo "Failed to mount $USB_LABEL_DEV at $USB_MOUNT"
    exit 1
  fi
fi

# Find profile - handle both directories and symlinks
profile=$(find "$FIREFOX_DIR" -maxdepth 1 \( -type d -o -type l \) -name "*.hey" | head -n 1 || true)

if [ -z "$profile" ]; then
  echo "No .hey profile folder found in $FIREFOX_DIR"
  echo "Available profiles:"
  ls -la "$FIREFOX_DIR"
  exit 1
fi

basename=$(basename "$profile")
echo "Found profile: $basename"

# Check if it's a symlink and show the target
if [ -L "$profile" ]; then
  target=$(readlink "$profile")
  echo "Profile is a symlink pointing to: $target"
  # Use the symlink target for rsync to get the actual data
  profile="$target"
fi

echo "Copying $basename to $USB_MOUNT using rsync..."
rsync -a --delete "$profile/" "$USB_MOUNT/$basename/"
echo "Done."
