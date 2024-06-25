set -g fish_greeting

starship init fish | source
if status is-interactive
end


set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

set -Ux CC clang
set -Ux CXX clang++
set -Ux fish_user_paths /usr/lib/ccache $fish_user_paths
set -U fish_user_paths ~/miniconda3/bin $fish_user_paths
set -Ux EDITOR nvim
set -gx RIPGREP_CONFIG_PATH /home/wasd/.config/.ripgreprc

function ip --description 'Alias for ip with color'
    command ip --color $argv
end

alias ls='eza --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | egrep '^\.'"

alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias rmf='rm -rf'
alias vim='neovide'
alias sc='sudo systemctl'
alias jc='sudo journalctl -b -p err'
alias diff='diff --color=auto'
alias cat='bat --theme="Dracula" --style=plain'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Created by `pipx` on 2024-05-19 13:18:18
set PATH $PATH /home/wasd/.local/bin