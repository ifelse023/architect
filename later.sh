#!/bin/bash

paru -Syu wlroots-git wayland-protocols-git wayland-git
paru -Syu sway-git swaybg-git neovim-git kitty-git fuzzel-git

bash ./ssh.sh
