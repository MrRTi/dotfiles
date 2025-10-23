# use dotbot to setup dotfiles
install: install-brew
  ./install

# install brew using curl
install-brew:
  type brew 2>/dev/null 1>&2 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# save current installed brews to Brewfile
dump-brew:
   brew bundle dump --describe --file=./brew/Brewfile --force

# install all from Brewfile
rebrew:
  brew bundle install --file=./brew/Brewfile

# setup git config files per folder in ~/Developer input format "folder1:email1;folder2:email2"
build-git-includes ARGS:
  ./git.sh "{{ARGS}}"
