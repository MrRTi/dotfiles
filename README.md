# Dotfiles

This config based on usage of the [Stow](#stow) to link config files to the needed places.

[Nix package manager and darwin-modules](#nix-packages) mostly used as package manager.

## How to clone

```sh
git clone --recurse-submodules https://github.com/MrRTi/dotfiles.git
cd dotfiles
```

```sh
git clone --recurse-submodules git@github.com:MrRTi/dotfiles.git
cd dotfiles
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

## Nix Packages

### Requirements

- [Nix package manager](https://nixos.org/download/)
- [Nix darwin modules](https://github.com/LnL7/nix-darwin/tree/master)

See `install-nix-with-darvin-modules.sh` for install sequence

### Configuration

Set by:
- placing `nix-pkgs/.nixpkgs/darwin-configuration.nix` at `~/.nixpkgs/darwin-configuration.nix`
- using [Stow](#stow)

## Required packages for configuration

### Installed by [nix package manager](#nix-packages)

The packages listed below are used in config files.
To check all packages instaled by nix package manager check `nix-pkgs/.nixpkgs/darwin-configuration.nix`

- [GNU Stow](https://www.gnu.org/software/stow/)
- [bat](https://github.com/sharkdp/bat)
- [delta](https://github.com/dandavison/delta)
- [direnv](https://direnv.net/)
- [eza](https://github.com/eza-community/eza)
- [fd](https://github.com/sharkdp/fd)
- [fzf](https://github.com/junegunn/fzf)
- [git](https://git-scm.com/)
- [lorri](https://github.com/nix-community/lorri)
- [marksman](https://github.com/artempyanykh/marksman)
- [neovim](https://github.com/neovim/neovim)
- [nerdfonts](https://www.nerdfonts.com/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [tldr](https://github.com/tldr-pages/tldr)
- [tmux](https://github.com/tmux/tmux/wiki)
- [zsh](https://www.zsh.org/)

### Install these as you like

- [WezTerm](https://wezfurlong.org/wezterm/index.html)
- [aerospace (macos only)](https://nikitabobko.github.io/AeroSpace/guide#installation)
- [JankyBorders (macos only)](https://github.com/FelixKratz/JankyBorders)

## TODO

### All systems

- Add nvim config (as submodule)
- Add k9s config
