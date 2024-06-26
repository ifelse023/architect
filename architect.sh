#!/bin/bash
set -e
sudo pacman -S --needed --noconfirm wget curl base-devel mold sccache reflector python python-requests ccache lld rustup rsync
sudo usermod -a -G video,audio,network,sys,wheel wasd
rustup default nightly
sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/dotfiles/etc/ /etc/
rsync -avh ~/architect/dotfiles/home/ ~/
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh
cd ..

python architect/main.py
sudo dosfslabel /dev/nvme0n1p1 BOOT
sudo e2label /dev/nvme0n1p2 ROOT
sudo mount -a
sudo python architect/modify_files.py
rsync -avh ~/architect/dotfiles/config/ ~/.config
python ~/architect/architect/manage_directories.py
sudo pacman -Sc --noconfirm
