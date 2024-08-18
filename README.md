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

## Shell

Set of shell agnostic aliases

### Configuration

Set by using [Stow](#stow)

Zsh configurations will be auto-sourced into zsh if zsh configuration applied

## Zsh

### Requirements

- [Zsh](https://www.zsh.org/)

### Configuration

Set by using [Stow](#stow)

## Fzf

### Requirements

- [fzf](https://github.com/junegunn/fzf) 

### Configuration

Set by using [Stow](#stow)

Zsh configurations will be auto-sourced into zsh if zsh configuration applied

## Bat

### Requirements

- [bat](https://github.com/sharkdp/bat) 

### Configuration

Set by using [Stow](#stow)

Zsh configurations will be auto-sourced into zsh if zsh configuration applied

## TLDR

### Requirements

- [tldr](https://github.com/tldr-pages/tldr)

### Configuration

Set by using [Stow](#stow)

Zsh configurations will be auto-sourced into zsh if zsh configuration applied

## Git

### Requirements

- [git](https://git-scm.com/)
- [delta](https://github.com/dandavison/delta)

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


## WIP: K9S

### Requirements

- [k9s](https://github.com/derailed/k9s)

### Configuration

k9s configuration - WIP

Set by using [Stow](#stow)

Shell updates will be auto-sourced into zsh if zsh configuration applied






## TODO:

### All systems
- Add nvim config (as submodule)
- Add direnv
- Add gitconfig
- Add k9s config

### Mac only
- Add Brewfile
- Add aerospace config
- Add borders config

### Fedora only
- TBD

### NixOS only
- TBD
