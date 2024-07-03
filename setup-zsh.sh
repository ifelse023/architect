#!/bin/bash

set -euo pipefail

ZSH_CUSTOM=${ZSH_CUSTOM:~/.oh-my-zsh/custom}
OH_MY_ZSH_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

main() {
    install_oh_my_zsh
    clone_repos
    sync_dotfiles
}

install_oh_my_zsh() {
    if ! command -v zsh >/dev/null 2>&1; then
        printf "zsh is not installed. Please install zsh before running this script.\n" >&2
        return 1
    fi
    
    if ! sh -c "$(curl -fsSL ${OH_MY_ZSH_INSTALL_URL})"; then
        printf "Failed to install Oh My Zsh.\n" >&2
        return 1
    fi
}

clone_repos() {
    local repos=(
        "https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM}/plugins/fzf-tab"
        "https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
        "https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
        "https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM}/plugins/autoupdate"
    )

    for repo in "${repos[@]}"; do
        local url; url=$(echo "$repo" | awk '{print $1}')
        local dir; dir=$(echo "$repo" | awk '{print $2}')
        
        if ! git clone "$url" "$dir"; then
            printf "Failed to clone repository: %s\n" "$url" >&2
            return 1
        fi
    done
}

sync_dotfiles() {
    local src_dir="$HOME/architect/dotfiles"
    local dest_dir="$ZSH_CUSTOM"

    if ! [ -d "$src_dir" ]; then
        printf "Source directory %s does not exist.\n" "$src_dir" >&2
        return 1
    fi

    mkdir -p "$dest_dir"

    if ! rsync -avz "$src_dir/aliases.zsh" "$dest_dir/"; then
        printf "Failed to sync dotfiles.\n" >&2
        return 1
    fi
}

main "$@"
