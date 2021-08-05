mv ~/.aliases ~/.aliases.backup
mv .aliases ~/.aliases
echo $'if [ -f .aliases ]; then . ~/.aliases; fi' >> ~/.zshrc
