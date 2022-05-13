mv ~/.aliases ~/.aliases.backup
cp .aliases ~/.aliases
echo $'if [ -f .aliases ]; then . ~/.aliases; fi' >> ~/.zshrc
