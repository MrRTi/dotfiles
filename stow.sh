#! /bin/sh

help() {
  echo "This script help stow and unstow configs from this repository"
  echo
  echo "SYNOPSIS:"
  echo
  echo -e "\t./stow.sh <-a|-d>[-n|-y] [-p PACKAGE]"
  echo -e "\t./stow.sh <-h>"
  echo
  echo "OPTIONS:"
  echo -e "\t-a \t Stow (uses stow --restow)"
  echo -e "\t-d \t Unstow"
  echo -e "\t-n \t Do dry-run (no changes applied)"
  echo -e "\t-y \t When -p not used - apply all configs without asking"
  echo -e "\t-p \t Specify package name. If not specified script will run for all configs"
  echo -e "\t-h \t This help"
}

STOW_ARGS=()

add_delete_arg() {
  STOW_ARGS+=("--delete")
}

add_add_arg() {
  STOW_ARGS+=("--restow")
}

add_dry_run_arg() {
  STOW_ARGS+=("--simulate")
}

AUTO_CONFIRM=false

add_auto_confim() {
  AUTO_CONFIRM=true
}

stow_one_config() {
  mkdir -p ~/.config

  stow --verbose ${STOW_ARGS[@]} --dir $(dirname "$1") --target $HOME "${1##*/}"
}

stow_all_configs() {
  configs=$(
    find ./* -mindepth 0 -maxdepth 0 -type d  \( ! -iname ".*" \) | 
    sort
  )

  echo "Config list: "
  for config in ${configs[@]}; do
    echo -e "\t - ${config##*/}"
  done

  for config in ${configs[@]}; do
    if $AUTO_CONFIRM; then
      answer='y'
    else
      echo "$VERB \"${config##*/}\" config?: y/[n]"
      read answer 
    fi
    [ "$answer" = 'y' ] && stow_one_config $config
  done
}

while getopts "hadnyp:" option; do
  case $option in
    h)
      help
      exit;;
    a)
      VERB='Link'
      add_add_arg;;
    d)
      VERB='Unlink'
      add_delete_arg;;
    n)
      add_dry_run_arg;;
    y)
      add_auto_confim;;
    p)
      PACKAGE=$OPTARG;;
    \?)
      echo "Invalid option"
      exit 1;;
  esac
done

if [ ${#STOW_ARGS[@]} = 0 ]; then
  echo "No options provided"
  echo
  help
  exit 1
fi

if [ -n "$PACKAGE" ]; then
  stow_one_config $PACKAGE
else
  stow_all_configs  
fi

