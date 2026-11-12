# Write installed Homebrew state into this repo's Brewfile (mise owns Go, Cargo and uv tools)
brew-dump:
    brew bundle dump --file=Brewfile --force --no-go --no-cargo --no-uv

# Lint shell scripts, Lua, fish config and Markdown
lint:
    shellcheck -x --severity=warning dot_local/bin/executable_*
    stylua --check dot_config/nvim/
    fish --no-execute dot_config/fish/*.fish dot_config/fish/*/*.fish
    markdownlint-cli2 "**/*.md" "#tmp" "#node_modules" "#.superpowers"

# Upgrade Homebrew, mise and every mise pin; pull the new pins and Brewfile into this repo
update:
    brew update
    brew upgrade
    mise self-update -y
    mise upgrade --bump
    chezmoi re-add ~/.config/mise
    just brew-dump

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

# Per-folder git email and signing key under ~/Developer: "folder:email;..."
[positional-arguments]
git-dev-folders spec:
    #!/usr/bin/env bash
    # NOTE: input format "folder1:email1;folder2:email2". Each folder gets a
    # .gitconfig, included via ~/.config/git/includes.gitconfig.

    parts=$(echo "$1" | tr ";" "\n")

    for line in $parts; do
        folder="$(cut -d ':' -f1 <<<"$line")"
        email="$(cut -d ':' -f2 <<<"$line")"

        if [[ -z "$folder" || -z "$email" ]]; then
            echo "Error: Missing folder or email" >&2
            exit 1
        fi

        path="$HOME/Developer/$folder"
        gitconfig_path="$path/.gitconfig"
        include_folder="$HOME/.config/git/"

        mkdir -pv "$path"
        touch "$gitconfig_path"

        mkdir -pv "$include_folder"
        touch "$include_folder/includes.gitconfig"

        if ! grep -qF "gitdir:$path/**" "$include_folder/includes.gitconfig"; then
            echo -e "[includeIf \"gitdir:$path/**\"]\n  path = \"$gitconfig_path\"" >>"$include_folder/includes.gitconfig"
        fi
        git config --file "$gitconfig_path" user.email "$email"
        key=$(ssh-add -L | grep "$email" | head -n 1)
        if [ -z "$key" ]; then
            echo "Warning: No SSH key found for $email, skipping signing key setup" >&2
        else
            git config --file "$gitconfig_path" user.signingkey "$key"
        fi

        echo "Set git config values for repos at $path"
        echo -e "\t- email=$email"
        echo -e "\t- signingkey=$key"
    done
