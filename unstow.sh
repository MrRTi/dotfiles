#! /bin/sh

mkdir -p ~/.config

PACKAGES=$(
  find ./stowed-configs -mindepth 1 -maxdepth 1 -type d  \( ! -iname ".*" \) | 
  sed 's|stowed-configs\/||g' | 
  sed 's|^\./||g'
)

for package in $PACKAGES; do
  echo "Unlink $package configs y/[n]?"
  read answer 
  [ "$answer" = 'y' ] && stow -Dv --dir ./stowed-configs -t $HOME $package
done
