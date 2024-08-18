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

Set by [Stow](#stow)


## TODO:

### All systems
- Add zsh config
- Add tmux config
- Add nvim config (as submodule)
- Add direnv
- Add gitconfig

### Mac only
- Add Brewfile
- Add aerospace config
- Add borders config

### Fedora only
- TBD

### NixOS only
- TBD
