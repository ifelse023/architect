set -g fish_greeting
if not set -q ZELLIJ; and pgrep -x sway >/dev/null; and not pgrep -x zellij >/dev/null
    if set -q ZELLIJ_AUTO_ATTACH; and test "$ZELLIJ_AUTO_ATTACH" = true
        zellij attach -c
    else
        zellij
    end

    # Auto exit the shell session when Zellij exits
    set -q ZELLIJ_AUTO_EXIT; and test "$ZELLIJ_AUTO_EXIT" = true; and exit
end


starship init fish | source
if status is-interactive
    atuin init fish | source
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
alias za='zellij attach'
alias rmf='rm -rf'
alias sc='sudo systemctl'
alias jc='sudo journalctl -b -p err'
alias diff='diff --color=auto'
alias cat='bat --theme="Dracula" --style=plain'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
