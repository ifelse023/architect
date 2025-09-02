#!/bin/bash
set -e
main() {

  if pacman -Qq linux-firmware >/dev/null 2>&1; then
    sudo pacman -Rns linux-firmware --noconfirm
  fi
  sudo pacman -S linux-firmware-intel linux-firmware-whence rsync python curl wget --noconfirm --needed

  sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key F3B607488DB35A47

  sudo pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-20240331-1-any.pkg.tar.zst' \
    'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-mirrorlist-22-1-any.pkg.tar.zst' \
    'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v3-mirrorlist-22-1-any.pkg.tar.zst' \
    'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v4-mirrorlist-22-1-any.pkg.tar.zst' \
    'https://mirror.cachyos.org/repo/x86_64/cachyos/pacman-7.0.0.r7.g1f38429-1-x86_64.pkg.tar.zst'

  sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/config-files/etc/ /etc/
  sudo pacman -Scc
  sudo pacman -Syyu --noconfirm

  sudo pacman -S paru-bin chezmoi sccache ccache libc++ clang dosfstools e2fsprogs mold --noconfirm --needed
  chsh -s /usr/bin/fish

  sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/config-files/etc/ /etc/
  chezmoi init --apply --ssh git@github.com:ifelse023/dotfiles.git

  python ~/architect/architect/install_packages.py

  sudo dosfslabel /dev/nvme0n1p1 BOOT
  sudo e2label /dev/nvme0n1p2 ROOT

  sudo mount -a

  sudo usermod -aG video,audio,network,git,wheel,input wasd
  python ~/architect/architect/service_manager.py --enable
  sudo cp ./config-files/limine.conf /boot

  sudo udevadm control --reload
  sudo udevadm trigger

  sudo pacman -Sc --noconfirm
  paru -Sc --noconfirm
  sudo journalctl --vacuum-size=1M
  sudo pacman -R $(pacman -Qtdq)
}

main
