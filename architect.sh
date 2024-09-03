#!/bin/bash
set -e
mkdir -p log
sudo pacman -S --needed --noconfirm wget curl base-devel mold sccache reflector python python-requests ccache lld rsync rustup clang libc++
rustup default nightly
rsync -avh ~/architect/dotfiles/home/ ~/
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh
cd .
sudo pacman -S paru-bin
paru -S alhp-keyring alhp-mirrorlist
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
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/99-input.rules
paru -Scc
sudo journalctl --vacuum-size=1M
sudo usermod -aG video,audio,network,sys,git,wheel,input wasd
python ./architect/service_manager.py
sudo python ./architect/create_symlinks.py
sudo pacman -Rns $(pacman -Qtdq)
