#!/usr/bin/env bash

# install rust before running
if ! command -v cargo >/dev/null 2>&1; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# use chache to speed up compilation
if ! cargo install --list | grep -q sccache; then
	cargo install sccache
fi
export RUSTC_WRAPPER=sccache

# install packages
packages=(
		cargo-info
		coreutils
		du-dust
		jnv
		mprocs
		wiki-tui
)

cargo install ${packages[@]}

