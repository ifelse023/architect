starship init fish | source
if status is-interactive
    set fish_greeting
    zoxide init fish | source
end

set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

set -Ux EDITOR nvim
set -Ux fish_user_paths /usr/lib/ccache $fish_user_paths
set -gx RIPGREP_CONFIG_PATH /home/wasd/.config/.ripgreprc

alias ls='eza -h --git --icons --color=auto --group-directories-first -s extension' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | egrep '^\.'"
alias vim neovide
alias fcd 'cd $(fd -type d | fzf)'
alias py python
alias errors 'journalctl -p err..alert -b'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'
alias rmf='rm -rf'
alias sc='sudo systemctl'
alias jc='sudo journalctl -b -p err'
alias diff='diff --color=auto'
alias cat='bat --theme="Catppuccin Mocha" --style=plain'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
