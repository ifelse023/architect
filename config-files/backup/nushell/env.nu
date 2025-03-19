$env.PATH = ($env.PATH | uniq)
$env.PATH = ($env.PATH | split row (char esep) | append "/home/wasd/architect/scripts")
$env.GOPATH = "/home/wasd/.go"
$env.RIPGREP_CONFIG_PATH = "/home/wasd/.config/ripgrep/config"
$env.LS_COLORS = "~/.config/nushell/theme/ls_colors"
$env.MOAR = "--no-linenumbers"
$env.PAGER = "/usr/bin/moar"
$env.FZF_DEFAULT_COMMAND = "fd --type file --follow --hidden"
$env.FZF_DEFAULT_OPTS = "
--highlight-line --info=inline-right --ansi --layout=reverse --border=none
--color=bg+:#283457,bg:#16161e,border:#27a1b9,fg:#c0caf5,gutter:#16161e,header:#ff9e64,hl+:#2ac3de,hl:#2ac3de,info:#545c7e,marker:#ff007c,pointer:#ff007c,prompt:#2ac3de,query:#c0caf5:regular,scrollbar:#27a1b9,separator:#ff9e64,spinner:#ff007c
"
