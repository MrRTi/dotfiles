#! /bin/sh

cat() {
  bat -pp $@ || cat $@
}

less() {
  bat -p $1 || less $1
}

alias lessl='bat -pl'

