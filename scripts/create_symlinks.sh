#!/bin/bash

SCRIPT_DIR="/home/wasd/.scripts"

LINK_DIR="/usr/local/bin"

mkdir -p "$LINK_DIR"

create_symlinks() {
  local file
  find "$SCRIPT_DIR" -type f -executable -print0 | while IFS= read -r -d '' file; do
    local filename
    filename=$(basename "$file")
    local target_link="$LINK_DIR/$filename"

    if [[ ! -e "$target_link" ]]; then
      ln -s "$file" "$target_link" &&
        printf "Symlink created for %s -> %s\n" "$file" "$target_link" ||
        printf "Failed to create symlink for %s\n" "$file" >&2
    else
      printf "Symlink for %s already exists. Skipping...\n" "$filename"
    fi
  done
}

main() {
  create_symlinks
}

main "$@"
