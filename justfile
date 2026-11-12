# Dump current Homebrew state into ~/Brewfile
brew-dump:
    barista receipt

# Pull ~/Brewfile changes back into chezmoi source
brew-sync:
    barista sync

# Dump brew state to ~/Brewfile, then sync it into chezmoi
brew-update: brew-dump brew-sync

# Lint shell scripts, Lua, fish config and Markdown
lint:
    shellcheck -x --severity=warning dot_local/bin/executable_*
    stylua --check dot_config/nvim/
    fish --no-execute dot_config/fish/*.fish dot_config/fish/*/*.fish
    markdownlint-cli2 "**/*.md" "#tmp" "#node_modules" "#.superpowers"

# Upgrade everything in the Brewfile (chezmoi apply only installs missing)
brew-upgrade:
    brew bundle install --upgrade --file="$HOME/Brewfile"

# Upgrade Homebrew and mise itself, bump every mise pin to its newest release,
# refresh the Brewfile.
# re-add pulls the bumped mise config and lock back into this repo. The npm/pipx
# dependency locks get new per-version dirs; `chezmoi add` alone keeps the old
# ones mise deleted, so the source copy is replaced whole. It's moved aside
# first and put back if the add fails, or boxes lose locks they need.
update:
    #!/usr/bin/env bash
    set -euo pipefail
    brew update
    brew upgrade
    mise self-update -y
    mise upgrade --bump
    chezmoi re-add ~/.config/mise
    old=$(mktemp -d)
    mv dot_config/mise/locks "$old/"
    if ! chezmoi add ~/.config/mise/locks; then
        mv "$old/locks" dot_config/mise/
        echo "update: kept the old dot_config/mise/locks" >&2
        exit 1
    fi
    rm -rf "$old"
    just brew-update

# List dotfiles in ~ that aren't expected: new clutter, or leftovers to delete
home-check:
    #!/usr/bin/env bash
    set -euo pipefail
    # NOTE: everything here either can't move (the app hardcodes the path) or
    # is managed on purpose. Add to it only with the reason beside the entry.
    allow=(
        .config .local .cache          # XDG base dirs
        .CFUserTextEncoding .DS_Store .Trash  # macOS
        .ssh .gnupg                    # moving them breaks too much
        .1password                     # 1Password SSH agent socket
        .claude .claude.json .claude.json.backup .codex .gemini  # agent CLIs
        .orbstack .docker              # OrbStack writes contexts and CLI plugins
        .sbx                           # Docker Sandboxes
        .homebrew                      # brew trust store, written by brew bundle
        .inputrc                       # managed by chezmoi
        .bootdev.yaml                  # boot.dev CLI
        .obsidian-cli.sock             # Obsidian CLI socket
        .mongodb                       # mongosh, no setting to move it
        .vault-token                   # vault's default token helper
        .usql_history                  # usql, no setting found to move it
        .yarnrc                        # yarn v1 rewrites it on every run
    )
    for path in "$HOME"/.[!.]*; do
        name=$(basename "$path")
        [[ "$name" == .claude.json.tmp.* ]] && continue
        [[ " ${allow[*]} " == *" $name "* ]] || echo "$path"
    done

# Build the sbx template from the dotfiles on GitHub and load it into sbx.
# The remote HEAD is a build arg, so a push invalidates the cached dotfiles layer.
sbx-template:
    #!/usr/bin/env bash
    set -euo pipefail
    rev=$(git ls-remote https://github.com/MrRTi/dotfiles.git HEAD | cut -f1)
    docker build --build-arg DOTFILES_REV="$rev" -t sbx-dotfiles:latest sbx
    dir=$(mktemp -d)
    trap 'rm -rf "$dir"' EXIT
    docker save sbx-dotfiles:latest -o "$dir/sbx-dotfiles.tar"
    sbx template load "$dir/sbx-dotfiles.tar"
