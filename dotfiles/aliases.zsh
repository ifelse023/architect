 alias ls="eza -h --git --icons --color=auto --group-directories-first -s extension"
 alias ldot="eza -ld .* --git --icons --color=auto --group-directories-first -s extension"
 alias la="eza -lah --git --icons --color=auto --group-directories-first -s extension"
 alias tree="eza --tree --icons=always"

alias cat="bat --style=plain"
alias grep="ripgrep --color=always --line-number --follow"
alias du="dust"
alias ps="procs"
alias mp="mkdir -p"
alias fcd='cd $(find . -type d | fzf)'
