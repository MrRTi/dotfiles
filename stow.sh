#!/usr/bin/env bash

COMMON_PACKAGES=(
  bash
  bat
  fish
  git
  mise
  nvim
  starship
  tmux
)

MACOS_PACKAGES=(
  1Password
  ghostty
)

PACKAGES=("${COMMON_PACKAGES[@]}")

if [[ "$(uname -s)" == "Darwin" ]]; then
  PACKAGES+=("${MACOS_PACKAGES[@]}")
fi

stow -v -R --target="$HOME" "${PACKAGES[@]}"
