# NOTE: mise is the standalone install in ~/.local/bin (host and sbx boxes),
# which config.fish adds to PATH too late for conf.d.
if test "$MISE_FISH_AUTO_ACTIVATE" != 0
    set -l mise (path filter -x $HOME/.local/bin/mise; or command -s mise)
    if test -n "$mise"
        $mise activate fish | source
    end
end
