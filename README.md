# Dotfiles

This repos is setup for use with MacOS and nix-darwin.

Previous version of dotfiles using stow is here -> [v.2.1.1](https://github.com/MrRTi/dotfiles/tree/v.2.1.1)

## Requirements

- [Nix package manager](https://nixos.org/download/)

## Usage

1. Install nix.

Source: [Nix package manager](https://nixos.org/download/)

```sh
sh <(curl -L https://nixos.org/nix/install)
```
2. Install nix-darwin and apply configuration.

Source: [Install nix-darwin (with flake)](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#step-2-installing-nix-darwin)

```sh
nix run nix-darwin -- switch --flake path_to_folder#air
```

3. To apply `air` configuration after change.

Source: [Apply flale](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#step-3-using-nix-darwin)

```sh
darwin-rebuild switch --flake path_to_folder#air
```

## Possible issues

### Remove nix users

```sh
for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete "/Users/$u"; done
```
