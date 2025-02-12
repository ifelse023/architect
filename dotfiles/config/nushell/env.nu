$env.LS_COLORS = (open ~/.config/nushell/theme/catppuccin_mocha.nu)

$env.CARAPACE_BRIDGES = 'fish' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
$env.PATH = ($env.PATH | uniq)
