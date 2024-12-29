#!/bin/bash

paru -Syu wlroots-git wayland-protocols-git wayland-git
paru -Syu sway-git swaybg-git fuzzel-git ghostty-git
bash ./ssh.sh

zoxide init nushell | save -f ~/.cache/.zoxide.nu
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
