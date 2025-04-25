#!/bin/bash

main() {

  python ~/architect/architect/install_packages.py

  sudo dosfslabel /dev/nvme0n1p1 BOOT
  sudo e2label /dev/nvme0n1p2 ROOT

  sudo mount -a

  paru -Scc

  sudo journalctl --vacuum-size=1M

  sudo usermod -aG video,audio,network,git,wheel,input,mysql wasd
  python ~/architect/architect/service_manager.py --enable

  sudo cp ./config-files/limine.conf /boot

  bash ~/misc/git.sh

  pactl set-default-sink alsa_output.usb-HP__Inc_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo

  ORPHANED=$(pacman -Qtdq)
  if [ -n "$ORPHANED" ]; then
    sudo pacman -Rns $ORPHANED
  fi
}

main
