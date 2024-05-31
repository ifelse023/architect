#!/bin/bash
set -e
sudo pacman -S --needed --noconfirm wget curl base-devel mold sccache reflector python python-requests ccache lld rustup rsync
sudo usermod -a -G video,audio,network,sys,wheel wasd
rustup default nightly
sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/dotfiles/etc/ /etc/
rsync -avh ~/architect/dotfiles/home/ ~/
wget https://mirror.cachyos.org/cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh
cd ..
chmod +x architect/rename_boot.sh
sudo ./rename_boot.sh /boot/loader/entries 00-linux.conf
python architect/main.py
sudo python architect/files.py
rsync -avh ~/architect/dotfiles/config/ ~/.config
chsh -s "$(which fish)"
python ~/architect/architect/manage_directories.py
