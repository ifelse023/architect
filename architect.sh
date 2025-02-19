#!/bin/bash
set -e
rustup default nightly
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
sudo bash cachyos-repo/cachyos-repo.sh
sudo pacman -S paru-bin --noconfirm
bash ./install
sleep 5
sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/dotfiles/etc/ /etc/
sudo pacman -Syu
nu ./architect/install_packages.nu
sudo dosfslabel /dev/nvme0n1p1 BOOT
sudo e2label /dev/nvme0n1p2 ROOT
sudo mount -a
chsh -s /usr/bin/nu
bat cache --build
paru -Scc
sudo journalctl --vacuum-size=1M
sudo usermod -aG video,audio,network,sys,git,wheel,input wasd
python ./architect/service_manager.py
bash ./ssh.sh
nu ./nu-settings.nu
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/99-input.rules
sudo pacman -Rns $(pacman -Qtdq)
