#!/bin/bash
set -e
mkdir -p log
mkdir -p ~/.scripts
sudo pacman -S --needed --noconfirm wget curl base-devel mold sccache reflector python python-requests ccache lld rsync rustup clang libc++
rustup default nightly
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh
cd ..
sudo pacman -S paru-bin --noconfirm
chezmoi init --apply ifelse023
sleep 10
sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/dotfiles/etc/ /etc/
sudo pacman -Syu
python ./architect/install_packages.py
sudo dosfslabel /dev/nvme0n1p1 BOOT
sudo e2label /dev/nvme0n1p2 ROOT
sudo mount -a
# sudo python ./architect/modify_files.py
chsh -s /usr/bin/nu
python ./architect/manage_directories.py
bat cache --build
paru -Scc
sudo journalctl --vacuum-size=1M
sudo usermod -aG video,audio,network,sys,git,wheel,input wasd
python ./architect/service_manager.py
sudo python ./architect/create_symlinks.py
bash ./ssh.sh
nu ./nu-settings.nu
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/99-input.rules
sudo pacman -Rns $(pacman -Qtdq)
