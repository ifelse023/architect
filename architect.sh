#!/bin/bash
set -e
mkdir -p log
mkdir -p ~/.scripts
sudo pacman -S --needed --noconfirm wget curl base-devel mold sccache reflector python python-requests ccache lld rsync rustup clang libc++
rustup default stable
rsync -avh ~/architect/dotfiles/home/ ~/
sudo pacman -S paru-bin
sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/dotfiles/etc/ /etc/
rsync -avh ~/architect/dotfiles/config/ ~/.config
sudo pacman -Syu
python ./architect/install_packages.py
sudo dosfslabel /dev/nvme0n1p1 BOOT
sudo e2label /dev/nvme0n1p2 ROOT
sudo mount -a
sudo python ./architect/modify_files.py
chsh -s /usr/bin/nu
python ./architect/manage_directories.py
bat cache --build
paru -Scc
sudo journalctl --vacuum-size=1M
sudo usermod -aG video,audio,network,sys,git,wheel,input wasd
python ./architect/service_manager.py
sudo python ./architect/create_symlinks.py
sudo pacman -Rns $(pacman -Qtdq)
