#! bin/bash

function lsla() {
  lsd -la $1 || ls -la $1
}
