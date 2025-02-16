#!/usr/bin/env nu

def main [] {
    
    ^rustup default nightly

    ^curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
    ^tar xvf cachyos-repo.tar.xz
    ^sudo bash cachyos-repo/cachyos-repo.sh

    ^sudo pacman -S paru-bin --noconfirm

    ^bash ./install

    sleep 5sec

    ^sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/dotfiles/etc/ /etc/

    ^sudo pacman -Syu

    nu ~/architect/architect/install_packages.nu

    ^sudo dosfslabel /dev/nvme0n1p1 BOOT
    ^sudo e2label /dev/nvme0n1p2 ROOT

    ^sudo mount -a

    ^chsh -s /usr/bin/nu

    ^bat cache --build

    ^paru -Scc

    ^sudo journalctl --vacuum-size=1M

    ^sudo usermod -aG video,audio,network,sys,git,wheel,input wasd

    ^nu ~/architect/architect/service_manager.nu

    ^bash ~/architect/architect/usb.nu

    ^zoxide init nushell | save -f ~/.cache/.zoxide.nu
    mkdir ~/.cache/starship
    ^starship init nu | save -f ~/.cache/starship/init.nu

    let orphaned = (^pacman -Qtdq | lines)
    if not ($orphaned | is-empty) {
        ^sudo pacman -Rns ...$orphaned
    }
}
