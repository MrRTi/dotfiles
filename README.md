# Dotfiles

Personal macOS dotfiles managed by [chezmoi](https://www.chezmoi.io/).

## Install

Requires macOS. Homebrew will be installed automatically if missing.

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply MrRTi
```

## Package Management

Packages are declared in `.chezmoidata/packages.yaml`. Changes trigger automatic reinstallation via `brew bundle`.

## Custom Scripts

- `tmux-sessionizer` — FZF-based tmux session creator
- `notes-switcher` — Interactive note selector/creator
- `tmux-popup` — Wrapper for running CLI tools in tmux popups

## Common Commands

```bash
chezmoi apply              # Apply changes to home directory
chezmoi diff               # Preview what would change
chezmoi edit <target>      # Edit a managed file (applies on save)
chezmoi add <file>         # Add a new file to chezmoi management
```

## Docs

[chezmoi documentation](https://www.chezmoi.io/user-guide/command-overview/)
