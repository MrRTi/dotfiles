function venv_init
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test $status -ne 0
        echo "error: not a git repo" >&2
        return 1
    end

    if not test -d $root/.venv
        echo "→ creating .venv"
        python3 -m venv $root/.venv
    end

    source $root/.venv/bin/activate.fish
    echo "✓ activated $root/.venv"

    if test -f $root/requirements.txt
        echo "→ installing requirements.txt"
        pip install -q -r $root/requirements.txt
        echo "✓ done"
    end
end
