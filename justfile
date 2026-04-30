# Dump current Homebrew state into ~/Brewfile
brew-dump:
    barista receipt

# Pull ~/Brewfile changes back into chezmoi source
brew-sync:
    barista sync
