#!/bin/bash
set -e
sudo pacman -S --needed --noconfirm wget curl base-devel mold sccache reflector python python-requests ccache lld rustup
sudo usermod -a -G video,audio,network,sys,wheel wasd
rustup default nightly
sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/dotfiles/etc/ /etc/
rsync -avh ~/architect/dotfiles/home/ ~/
python architect/main.py
sudo python architect/files.py
rsync -avh ~/architect/dotfiles/config/ ~/.config
sudo mount -a
sudo systemctl disable bluetooth
sudo systemctl mask bluetooth
sudo keyd reload
bash ./ssh.sh
chsh -s "$(which fish)"
