#! /bin/sh

lsla() {
  lsd -la "$1" || ls -la "$1"
}

alias ll='lsla'
