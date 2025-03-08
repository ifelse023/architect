#!/bin/bash

main() {
  curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
  tar xvf cachyos-repo.tar.xz
  cd cachyos-repo
  sudo bash cachyos-repo.sh
  cd ..

  sudo pacman -S paru-bin openssh chezmoi --noconfirm
  chsh -s /usr/bin/fish

  bash ~/architect/architect/usb.sh

  chezmoi init --apply --verbose --ssh git@github.com:ifelse023/dotfiles.git
  sleep 3

  sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/config-files/etc/ /etc/

  sudo pacman -Syu

  python ~/architect/architect/install_packages.py

  sudo dosfslabel /dev/nvme0n1p1 BOOT
  sudo e2label /dev/nvme0n1p2 ROOT

  sudo mount -a

  paru -Scc

  sudo journalctl --vacuum-size=1M

  sudo usermod -aG video,audio,network,git,wheel,input,mysql wasd
  python ~/architect/architect/service_manager.py

  sudo cp ./config-files/limine.conf /boot

  ORPHANED=$(pacman -Qtdq)
  if [ -n "$ORPHANED" ]; then
    sudo pacman -Rns $ORPHANED
  fi
}

main
