#! /bin/bash

# To fix bad install
# Remove nix users
# if [[ $REMOVE_NIX_USERS -eq 1 ]]
# then
#   for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete "/Users/$u"; done
# fi

# Install nix package manager using nix installer
# https://nixos.org/download/

# 450 used for MacOS 15 bug
if ! command -v nix >/dev/null 2>&1; then
  NIX_FIRST_BUILD_UID=${NIX_FIRST_BUILD_UID:-450} sh <(curl -L https://nixos.org/nix/install)
fi
#
# https://github.com/LnL7/nix-darwin/tree/master

# RELOAD required

nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
nix-channel --update

cd "$HOME"
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
"$HOME/result/bin/darwin-installer"

# Apply config
darwin-rebuild switch
