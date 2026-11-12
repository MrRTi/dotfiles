# XDG base dirs and per-tool overrides, so tools write config, data, state and
# caches under ~/.config, ~/.local/share, ~/.local/state and ~/.cache instead of
# new dotdirs in ~. `just home-check` lists anything that still lands in ~.
# 00- prefix: conf.d runs alphabetically, and mise-activate.fish needs these.
#
# NOTE: setting XDG_* explicitly on macOS moves tools that otherwise use
# ~/Library: helm (Preferences/helm, ~/Library/helm, Caches/helm), k9s and
# lazygit (Application Support), mise's cache (Caches/mise). All tested.
# Tools already on ~/.config (git, fish, nvim, tmux, bat, tealdeer, rclone)
# don't move. Go ignores XDG on macOS (os.UserConfigDir), so GOENV stays put.
# GUI apps started by launchd never see these.

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_CACHE_HOME $HOME/.cache

# Languages and package managers
set -gx GOPATH $XDG_DATA_HOME/go
set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
set -gx BUNDLE_USER_CONFIG $XDG_CONFIG_HOME/bundle/config
set -gx BUNDLE_USER_CACHE $XDG_CACHE_HOME/bundle
set -gx BUNDLE_USER_PLUGIN $XDG_DATA_HOME/bundle
set -gx GEM_SPEC_CACHE $XDG_CACHE_HOME/gem
set -gx npm_config_cache $XDG_CACHE_HOME/npm
set -gx YARN_CACHE_FOLDER $XDG_CACHE_HOME/yarn

# Kubernetes (KUBECONFIG itself is built in kubeconfig.fish)
set -gx KUBECACHEDIR $XDG_CACHE_HOME/kube

# Histories and rc files
set -gx HISTFILE $XDG_STATE_HOME/bash_history
set -gx LESSHISTFILE $XDG_STATE_HOME/lesshst
set -gx MYSQL_HISTFILE $XDG_STATE_HOME/mysql_history
set -gx PYTHON_HISTORY $XDG_STATE_HOME/python_history
set -gx IRBRC $XDG_CONFIG_HOME/irb/irbrc
set -gx WGETRC $XDG_CONFIG_HOME/wget/wgetrc
