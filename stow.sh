#! /bin/sh

mkdir -p ~/.config

stow_package() {
  stow -v -R --dir ./stowed-configs -t $HOME $1
}

if [ -n "$1" ]; then
  stow_package $1
else
  packages=$(
    find ./stowed-configs -mindepth 1 -maxdepth 1 -type d  \( ! -iname ".*" \) | 
    sed 's|stowed-configs\/||g' | 
    sed 's|^\./||g' |
    sort
  )

  echo "Could be stowed: $(echo "$packages" | tr '\n' ' ')"

  for package in $packages; do
    echo "Link $package configs y/[n]?"
    read answer 
    [ "$answer" = 'y' ] && stow_package $package
  done
fi

