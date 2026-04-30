# Dump current Homebrew state into ~/Brewfile
brew-dump:
    brew bundle dump --file=~/Brewfile --force

# Pull ~/Brewfile changes back into chezmoi source
brew-sync:
    chezmoi add --force ~/Brewfile
