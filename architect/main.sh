#!/bin/bash

main() {

  sudo pacman -S openssh rsync python curl wget mold --noconfirm --needed
  curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
  tar xvf cachyos-repo.tar.xz
  cd cachyos-repo
  sudo bash cachyos-repo.sh
  cd ..
  rm -rf ~/architect/cachyos-repo
  rm ~/architect/cachyos-repo.tar.xz

  sudo pacman -S paru-bin chezmoi sccache ccache libc++ clang --noconfirm --needed
  chsh -s /usr/bin/fish

  bash ~/architect/architect/usb.sh
  chezmoi init --apply --ssh git@github.com:ifelse023/dotfiles.git

  sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/config-files/etc/ /etc/

  sudo pacman -Syu

  python ~/architect/architect/install_packages.py

  sudo dosfslabel /dev/nvme0n1p1 BOOT
  sudo e2label /dev/nvme0n1p2 ROOT

  sudo mount -a

  paru -Scc

  sudo journalctl --vacuum-size=1M

  sudo usermod -aG video,audio,network,git,wheel,input wasd
  python ~/architect/architect/service_manager.py --enable

  sudo cp ./config-files/limine.conf /boot

  ORPHANED=$(pacman -Qtdq)
  if [ -n "$ORPHANED" ]; then
    sudo pacman -Rns $ORPHANED
  fi
}

main
