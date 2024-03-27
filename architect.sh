#!/bin/bash
set -e
sudo pacman -S --needed --noconfirm wget curl base-devel mold sccache reflector python python-requests ccache lld paru rustup
sudo usermod -a -G video,audio,network,sys,wheel wasd
rustup default nightly
sudo rsync -avh -av ~/architect/dotfiles/etc/ /etc/
rsync -avh ~/architect/dotfiles/home/ ~/
python architect/main.py
sudo python architect/files.py
rsync -avh ~/architect/dotfiles/config/ ~/.config
sudo mount -a
sudo systemctl --user enable psd
sudo systemctl disable bluetooth
sudo systemctl mask bluetooth
sudo keyd reload
bash ./ssh.sh
chsh -s "$(which fish)"
