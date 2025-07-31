# use dotbot to setup dotfiles
install: install-brew
  ./install

# install brew using curl
install-brew:
  type brew 2>/dev/null 1>&2 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# setup git config files per folder in ~/Developer input format "folder1:email1;folder2:email2"
build-git-includes ARGS:
  ./git.sh "{{ARGS}}"
