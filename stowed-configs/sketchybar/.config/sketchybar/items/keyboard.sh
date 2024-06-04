#!/bin/bash

keyboard=(
    icon.drawing=off
    label.padding_left=7
    label.padding_right=8
    script="$PLUGIN_DIR/keyboard.sh"
)

sketchybar --add item keyboard right        \
           --set keyboard "${keyboard[@]}"  \
           --add event keyboard_change "AppleSelectedInputSourcesChangedNotification" \
           --subscribe keyboard keyboard_change
