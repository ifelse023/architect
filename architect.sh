#!/bin/bash
set -e
sudo pacman -S --needed --noconfirm wget curl base-devel mold sccache reflector python python-requests ccache lld rsync rustup clang
rustup default nightly
sudo usermod -a -G video,audio,network,sys,wheel wasd
rsync -avh ~/architect/dotfiles/home/ ~/
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh
cd ..
sudo pacman -S paru-bin
paru -S alhp-keyring alhp-mirrorlist
sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/dotfiles/etc/ /etc/
sudo pacman -Syu
python architect/main.py
sleep 3
sudo dosfslabel /dev/nvme0n1p1 BOOT
sudo e2label /dev/nvme0n1p2 ROOT
sudo mount -a
sudo python architect/modify_files.py
rsync -avh ~/architect/dotfiles/config/ ~/.config
paru -Scc
sudo pacman -Rns $(pacman -Qtdq)
sudo journalctl --vacuum-size=1M
python ~/architect/architect/manage_directories.py
