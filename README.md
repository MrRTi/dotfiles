# Dotfiles

Personal macOS dotfiles managed by [chezmoi](https://www.chezmoi.io/).

## Install

Requires macOS. Homebrew will be installed automatically if missing.

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply MrRTi
```

## Package Management

Packages (brews, casks, and Mac App Store apps) are declared in `Brewfile`. Changes trigger automatic reinstallation via `brew bundle`. Managed day-to-day with `barista` and `just brew-dump`/`brew-sync`.

## Custom Scripts

- `tmux-sessionizer` — FZF-based tmux session creator
- `notes-switcher` — Interactive note selector/creator
- `tmux-popup` — Wrapper for running CLI tools in tmux popups
- `tmux-git-info` — Outputs git branch/remote info for tmux pane borders
- `db-create` / `db-connect` — Multi-engine DB creator/connector (postgres, mysql, mongo) via FZF + usql
- `barista` — Homebrew Brewfile sync/cleanup helper
- `llm-serve` / `llm-serve-code` — Starts a local MLX OpenAI-compatible LLM server
- `enc` — Password-based file encryption via openssl

See `dot_local/bin/` for the full list.

## Common Commands

```bash
chezmoi apply              # Apply changes to home directory
chezmoi diff               # Preview what would change
chezmoi edit <target>      # Edit a managed file (applies on save)
chezmoi add <file>         # Add a new file to chezmoi management
```

## Docs

[chezmoi documentation](https://www.chezmoi.io/user-guide/command-overview/)
