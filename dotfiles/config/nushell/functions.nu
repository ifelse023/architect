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
