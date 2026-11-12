# Dotfiles

macOS dotfiles managed by [chezmoi](https://www.chezmoi.io/), also applied inside Docker Sandboxes (sbx) boxes.

## Install

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply MrRTi
```

Installs chezmoi, clones this repo to `~/.local/share/chezmoi`, and applies it: writes the dotfiles to `~`, installs mise standalone to `~/.local/bin` and runs `mise install`, then installs Homebrew and runs `brew bundle`.

Then run `:TSInstallParsers` in Neovim once.

## Commands

```sh
chezmoi diff        # Preview changes
chezmoi apply       # Apply source to ~
chezmoi add <file>  # Start managing a file
just lint           # shellcheck, stylua, fish syntax, markdownlint
just brew-update    # Dump installed Homebrew state into the Brewfile
just brew-upgrade   # Upgrade everything in the Brewfile
just update         # brew upgrade + mise self-update + bump every mise pin + refresh the Brewfile
just home-check     # List unexpected dotfiles in ~
just git-dev-folders "personal:a@x.com;work:b@y.com"  # Per-folder git email and signing key under ~/Developer
just sbx-template   # Build the sbx box template from GitHub and load it
```

Lint tools are pinned in `mise.toml`.

## Layout

- `dot_` prefix: target starts with `.`
- `private_` prefix: restricted permissions
- `executable_` prefix: executable bit
- `run_before_` / `run_after_` / `run_onchange_` / `run_once_` prefix: lifecycle scripts
- `.tmpl` suffix: Go template
- `.chezmoiignore`: repo-only files, never deployed

## Packages

- `Brewfile`: bootstrap tools (chezmoi, fish, git), things mise can't build, macOS-only tools, casks, Mac App Store apps. A change re-runs `brew bundle` on apply. Apply installs missing entries only (`just brew-upgrade` upgrades) and uninstalls what isn't listed, so deleting a line removes the package. Run `just brew-update` first if you installed something by hand.
- `dot_config/mise/`: CLI and dev tool versions, split by where they're needed:
  - `config.toml`: CLIs used everywhere (host and boxes)
  - `conf.d/dev.toml`: languages, language servers, linters, formatters
  - `conf.d/host.toml`: host only (fnox/age secrets, backups, hledger)
  - `conf.d/infra.toml`: k8s, vault, tofu; host only for now
  - `mise.lock`: checksums for macOS and Linux, plus `locks/` with npm/pipx tools' dependency graphs (uv/aube lockfiles); a fresh `mise install` fails without them
- `dot_config/mise/rails-tasks.toml`: global `rails:*` tasks (`mise run rails:lint`) for any Ruby repo.

## Shell

- Fish only.
- `config.fish`: PATH, environment, abbreviations.
- `conf.d/00-xdg.fish`: XDG base dirs and per-tool overrides, so caches and state stay out of `~`.
- `conf.d/mise-activate.fish`: activates mise (from `~/.local/bin`, before `config.fish` puts it on PATH). Per-project env vars go in `mise.local.toml` `[env]`, secrets in `fnox.local.toml` (run with `fnox exec --`).
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
- Credentials: 1Password `op://` references in `fnox.toml`, resolved by `fnox exec`

## Claude Code

- `dot_claude/`: global settings and status line script for `~/.claude/`

## Files apps rewrite

Some deployed files are edited by their app: the mise config, `conf.d/*.toml` and `mise.lock` (`mise use -g`, `mise upgrade --bump`); `nvim/lazy-lock.json` (`:Lazy update`); `~/.claude/settings.json` (`/config`, plugin installs). They're plain copies, so pull the edits back with `chezmoi re-add <file or dir>`. `just update` does that for `~/.config/mise`. `chezmoi apply` asks before overwriting a file changed since its last write; check `chezmoi diff` first.

## Profiles

chezmoi data in `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
  profile = "host"   # default; "box" inside sbx
  devTools = false   # host only: stop deploying conf.d/dev.toml
```

Turning `devTools` off doesn't delete the deployed file: after apply, `rm ~/.config/mise/conf.d/dev.toml && mise prune`.

`box` skips the Brewfile, macOS apps' configs, `Developer/`, `~/.claude` (sbx owns it), git signing (1Password), and the host-only mise files.

## sbx boxes

- `sbx/Dockerfile`: Docker's `claude-code` sandbox image, apt packages mise can't provide, mise, then `chezmoi init --apply MrRTi` with `profile = "box"`, plugins and parsers prebuilt.
- `just sbx-template` builds it from what's pushed to GitHub and loads it into sbx. Run a box with `sbx run --pull never -t sbx-dotfiles:latest claude <dir>`.
- Agents run non-interactive bash, so tools come from mise shims on `PATH`.
