# ===== INTERACTIVE SESSION SETTINGS =====
if status is-interactive
    # Disable fish greeting
    set fish_greeting

    starship init fish | source
end

# ===== PATH CONFIGURATION =====
fish_add_path /home/wasd/architect/scripts

# ===== ENVIRONMENT VARIABLES =====
set -gx GOPATH "/home/wasd/.go"

# Tool configurations
set -gx RIPGREP_CONFIG_PATH "/home/wasd/.config/ripgrep/config"

# Pager settings
set -gx MOAR --no-linenumbers
set -gx PAGER /usr/bin/moar

# FZF settings
set -gx FZF_DEFAULT_COMMAND "fd --type file --follow --hidden"
set -gx FZF_DEFAULT_OPTS "
--highlight-line 
--info=inline-right 
--ansi 
--layout=reverse 
--border=none
--color=bg+:#283457,bg:#16161e,border:#27a1b9,fg:#c0caf5,gutter:#16161e,header:#ff9e64,hl+:#2ac3de,hl:#2ac3de,info:#545c7e,marker:#ff007c,pointer:#ff007c,prompt:#2ac3de,query:#c0caf5:regular,scrollbar:#27a1b9,separator:#ff9e64,spinner:#ff007c
"

# ===== EDITOR ALIASES =====
alias vim="uwsm app -- neovide"
alias vi="uwsm app -- neovide"
alias vimdiff="nvim -d"
alias se="sudoedit"

# ===== FILE OPERATION ALIASES =====
alias open-task="floorp --new-tab (open aufgabe.txt)"
alias xx="fzf --bind 'enter:become(nvim {})'"
alias cp="cp --recursive --verbose --progress"
alias cat="bat --theme='Dracula' --style=plain --no-pager"
alias diff="diff --color=auto"
