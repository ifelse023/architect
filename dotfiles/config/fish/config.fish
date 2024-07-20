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

function c
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

alias ls='eza --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | egrep '^\.'"

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
