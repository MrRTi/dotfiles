#! /bin/sh

lsla() {
  FOLDER=${1:-$(pwd)}
  lsd -la "$FOLDER" || ls -la "$FOLDER"
}

alias ll='lsla'
