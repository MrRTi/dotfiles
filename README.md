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

### Usage

1. Install nix.

Source: [Nix package manager](https://nixos.org/download/)

```sh
sh <(curl -L https://nixos.org/nix/install)
```
2. Install nix-darwin and apply configuration.

Source: [Install nix-darwin (with flake)](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#step-2-installing-nix-darwin)

```sh
nix run nix-darwin -- switch --flake path_to/nix/nix-darwin#air
```

3. To apply `air` configuration after change.

Source: [Apply flale](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#step-3-using-nix-darwin)

```sh
darwin-rebuild switch --flake path_to/nix/nix-darwin#air
```

### Possible issues

#### Remove nix users

```sh
for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete "/Users/$u"; done
```
