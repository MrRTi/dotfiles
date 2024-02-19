#! /bin/sh

mkdir -p ~/.config

unstow_package() {
  stow -Dv --dir ./stowed-configs -t $HOME $1
}

if [ -n "$1" ]; then
  unstow_package $1
else
  packages=$(
    find ./stowed-configs -mindepth 1 -maxdepth 1 -type d  \( ! -iname ".*" \) | 
    sed 's|stowed-configs\/||g' | 
    sed 's|^\./||g' |
    sort
  )

  echo "Could be unstowed: $(echo "$packages" | tr '\n' ' ')"

  for package in $packages; do
    echo "Unlink $package configs y/[n]?"
    read answer 
    [ "$answer" = 'y' ] && unstow_package $package
  done
fi
