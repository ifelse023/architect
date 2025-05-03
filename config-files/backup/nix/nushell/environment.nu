$env.ENV_CONVERSIONS.PATH = {
  from_string: {|string|
    $string | split row (char esep) | path expand --no-symlink
  }
  to_string: {|value|
    $value | path expand --no-symlink | str join (char esep)
  }
}

$env.LS_COLORS = (open ~/.config/nushell/ls_colors.txt)

def --env mc [path: path] {
  mkdir $path
  cd $path
}

def --env mcg [path: path] {
  mkdir $path
  cd $path
  git init
}

def cpcat [file] {
  open --raw $file | wl-copy
  echo $"Copied contents of ($file) to clipboard."
}
def filter_rg [
    cmd: string,          # Nushell command to execute
    pattern: string,      # Search pattern for filtering
    ...rg_args: string    # Additional arguments for rg
] {
    # Capture both stdout and stderr from the command
    let command_result = (  bash -c $cmd  | complete)

    # Combine stdout/stderr into text and filter
    [
        ($command_result.stdout | to text), 
        $command_result.stderr
    ] | str join "\n" | rg $pattern ...$rg_args
}

def e [xyz: string] {
    fd $xyz -X nvim
}

def e-pattern [pattern]  {
    ^fd -g $pattern -X nvim
}
