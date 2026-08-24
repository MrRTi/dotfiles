# Dump current Homebrew state into ~/Brewfile
brew-dump:
    barista receipt

# Pull ~/Brewfile changes back into chezmoi source
brew-sync:
    barista sync

# Dump brew state to ~/Brewfile, then sync it into chezmoi
brew-update: brew-dump brew-sync
