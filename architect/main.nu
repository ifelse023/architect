#!/usr/bin/env nu

def main [] {
    
    ^sudo pacman -S paru-bin chezmoi nushell --noconfirm
    ^chsh -s /usr/bin/nu

    nu ~/architect/architect/usb.nu
    chezmoi init --apply --verbose --ssh git@github.com:ifelse023/dotfiles.git
    sleep 3sec

    ^sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/config-files/etc/ /etc/

    ^sudo pacman -Syu

    nu ~/architect/architect/install_packages.nu

    ^sudo dosfslabel /dev/nvme0n1p1 BOOT
    ^sudo e2label /dev/nvme0n1p2 ROOT

    ^sudo mount -a

    ^paru -Scc

    ^sudo journalctl --vacuum-size=1M

    ^sudo usermod -aG video,audio,network,sys,git,wheel,input wasd

    ^zoxide init nushell | save -f ~/.cache/.zoxide.nu
    mkdir ~/.cache/starship
    ^starship init nu | save -f ~/.cache/starship/init.nu
    mkdir ~/.cache/carapace
    carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
    
    let orphaned = (^pacman -Qtdq | lines)
    if not ($orphaned | is-empty) {
        ^sudo pacman -Rns ...$orphaned
    }

}
