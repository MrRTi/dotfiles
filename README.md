# Dotfiles

macOS dotfiles managed by [chezmoi](https://www.chezmoi.io/).

## Install

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply MrRTi
```

Installs chezmoi, clones this repo to `~/.local/share/chezmoi`, and applies it: writes the dotfiles to `~`, installs Homebrew, runs `brew bundle`.

Then run `:TSInstallParsers` in Neovim once.

## Commands

```sh
chezmoi diff        # Preview changes
chezmoi apply       # Apply source to ~
chezmoi add <file>  # Start managing a file
just lint           # shellcheck, stylua, fish syntax, markdownlint
just brew-update    # Dump installed Homebrew state into the Brewfile
just brew-upgrade   # Upgrade everything in the Brewfile
```

Lint tools are pinned in `mise.toml`.

## Layout

- `dot_` prefix: target starts with `.`
- `private_` prefix: restricted permissions
- `executable_` prefix: executable bit
- `run_before_` / `run_onchange_` prefix: lifecycle scripts
- `.tmpl` suffix: Go template
- `.chezmoiignore`: repo-only files, never deployed

## Packages

- `Brewfile`: taps, formulae, casks, Mac App Store apps. A change re-runs `brew bundle` on apply. Apply installs missing entries only; `just brew-upgrade` upgrades.
- `dot_config/mise/config.toml`: dev tool versions (languages, linters, formatters, language servers).

## Shell

- Fish only.
- `config.fish`: PATH, environment, abbreviations. mise and direnv are activated by Homebrew's `vendor_conf.d`.
- `functions/`: prompt and wrappers that must run in-shell (`cd`, `source`).
- `dot_local/bin/`: shell-agnostic scripts.

## Scripts

- `tmux-sessionizer`: fzf picker, one tmux session per project
- `git_worktree_*`, `git_clone_to_worktree`: worktree layout (`<repo>/main` + one directory per branch)
- `tmux-popup`: tool in a persistent tmux popup
- `notes-switcher`: fzf note picker and creator
- `db-create`, `db-connect`: databases in the local stack via usql
- `barista`: Brewfile dump, sync, cleanup
- `enc`: password-based file encryption (OpenSSL)
- `llm-serve`: local MLX OpenAI-compatible server

## Neovim

- `dot_config/nvim/init.lua`, lazy.nvim, `lazy-lock.json` committed
- LSP: native `vim.lsp`, server definitions from nvim-lspconfig
- Formatting: conform.nvim. YAML formats on save only with a yamlfmt config in the project; JSON never. `<leader>lf` formats anywhere.
- Linting: nvim-lint
- Files: oil.nvim

## Theme

- Nightfox (dark) / Dayfox (light), following macOS appearance
- Same hex values in Ghostty, Neovim, tmux
- Exceptions: lazygit uses ANSI color names; k9s uses a transparent skin

## Local databases

- `Developer/databases/`: Postgres, MySQL, MongoDB, Redis in Docker
- Credentials: 1Password `op://` references in `dot_env`, resolved by `op run`

## Claude Code

- `dot_claude/`: global settings and status line script for `~/.claude/`
