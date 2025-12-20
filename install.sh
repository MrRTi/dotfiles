#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Ensure stow exists
if ! command -v stow >/dev/null; then
  if command -v apt >/dev/null; then
    sudo apt-get update && sudo apt-get install -y stow
  elif command -v pacman >/dev/null; then
    sudo pacman -Sy --noconfirm stow
  fi
fi

./stow.sh
