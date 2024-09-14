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

## Required packages

- [GNU Stow](https://www.gnu.org/software/stow/)
- [JankyBorders (macos only)](https://github.com/FelixKratz/JankyBorders)
- [WezTerm](https://wezfurlong.org/wezterm/index.html)
- [aerospace (macos only)](https://nikitabobko.github.io/AeroSpace/guide#installation)
- [bat](https://github.com/sharkdp/bat)
- [delta](https://github.com/dandavison/delta)
- [emacs](https://www.gnu.org/software/emacs/)
- [eza](https://github.com/eza-community/eza)
- [fd](https://github.com/sharkdp/fd)
- [fzf](https://github.com/junegunn/fzf)
- [git](https://git-scm.com/)
- [marksman](https://github.com/artempyanykh/marksman)
- [mise](https://github.com/jdx/mise)
- [neovim](https://github.com/neovim/neovim)
- [nerdfonts](https://www.nerdfonts.com/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [tldr](https://github.com/tldr-pages/tldr)
- [tmux](https://github.com/tmux/tmux/wiki)
- [zsh](https://www.zsh.org/)

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

## Brew

### Requirements

- [brew](https://brew.sh/)

### Usage

#### Install brew (use command from original site)

```sh
./brew.sh -i
```

#### Install all packages listed in Brewfile (restore)

```sh
./brew.sh -r
```

#### Save list of installed packages in Brewfile

```sh
./brew.sh -d
```

#### Help

To see all possible options

```sh
./brew.sh -h
```

## TODO

### All systems

- Add k9s config
