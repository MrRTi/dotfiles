#!/usr/bin/env bash

# install rust before running
if ! command -v cargo >/dev/null 2>&1; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# use chache to speed up compilation
cargo install sccache
export RUSTC_WRAPPER=sccache

# install packages
packages=(
		bat
		cargo-info
		eza
		git-delta
		fd-find
		jnv
		mice
		mprocs
		ripgrep
		wiki-tui
)

cargo install $packages[@]

