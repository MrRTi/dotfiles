# Dotfiles

## How to clone

```sh
git clone --recurse-submodules https://github.com/MrRTi/dotfiles.git
cd dotfiles
git checkout dotfiles-v2
```

```sh
git clone --recurse-submodules git@github.com:MrRTi/dotfiles.git
cd dotfiles
git checkout dotfiles-v2
```

## Stow

### Requirements

- [GNU Stow](https://www.gnu.org/software/stow/)

### Usage

#### Add

For specific package

```sh
./stow.sh -a -p nvim
```

For all configs

```sh
./stow.sh -a
```

#### Delete

For specific package

```sh
./stow.sh -d -p nvim
```

For all configs

```sh
./stow.sh -d
```

#### Help

To see all possible options

```sh
./stow.sh -h
```

## WezTerm

### Requirements

- [WezTerm](https://wezfurlong.org/wezterm/index.html)
- Font "JetBrains Mono"

### Configuration

Set by using [Stow](#stow)

## Tmux

### Requirements

- [Tmux](https://github.com/tmux/tmux/wiki)

For tmux sessionizer

- [fzf](https://github.com/junegunn/fzf)
- [fd](https://github.com/sharkdp/fd) (Optional, find will be used if fd not found)

### Configuration

Set by using [Stow](#stow)

## Zsh

### Requirements

- [Zsh](https://www.zsh.org/)

#### Optional

- [bat](https://github.com/sharkdp/bat)
- [fzf](https://github.com/junegunn/fzf)
- [eza](https://github.com/eza-community/eza)
- [tldr](https://github.com/tldr-pages/tldr)

### Configuration

Set by using [Stow](#stow)

## Git

### Requirements

- [git](https://git-scm.com/)
- [delta](https://github.com/dandavison/delta)

### Configuration

Set by using [Stow](#stow)

Zsh configurations will be auto-sourced into zsh if zsh configuration applied

## Aerospace (macos only)

### Requirements

- [aerospace](https://nikitabobko.github.io/AeroSpace/guide#installation)

### Configuration

Set by using [Stow](#stow)

Zsh configurations will be auto-sourced into zsh if zsh configuration applied

## JunkyBorders (macos only)

### Requirements

- [JankyBorders](https://github.com/FelixKratz/JankyBorders)

### Configuration

Set by using [Stow](#stow)

Zsh configurations will be auto-sourced into zsh if zsh configuration applied

## WIP: Neovim (nvim)

### Requirements

- [neovim](https://github.com/neovim/neovim)
- TBD

### Configuration

Neovim configuration - WIP

Set by using [Stow](#stow)

Zsh configurations will be auto-sourced into zsh if zsh configuration applied

## TODO

### All systems
- Add nvim config (as submodule)
- Add direnv
- Add k9s config

### Mac only
- Add Brewfile

### Fedora only
- TBD

### NixOS only
- TBD
