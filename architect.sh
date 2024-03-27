#!/bin/bash
set -e
sudo usermod -a -G video,audio,network,sys,wheel wasd
rustup default nightly
sudo rsync -avh -av ~/architect/dotfiles/etc/ /etc/
rsync -avh ~/architect/dotfiles/home/ ~/
python architect/main.py
sudo python architect/files.py
rsync -avh ~/architect/dotfiles/config/ ~/.config
sudo mount -a
sudo systemctl disable bluetooth
sudo systemctl mask bluetooth
sudo keyd reload
sudo systemctl --user enable psd
chsh -s "$(which fish)"
