#!/usr/bin/env bash

title=(
  script="$PLUGIN_DIR/window_title.sh"
  icon.padding_left=15
  icon.font="sketchybar-app-font:regular:13.0" 
  icon.color="$YELLOW"
  background.padding_left=0
  padding_left=0
  label.padding_left=12
  label.padding_right=12
)

sketchybar      --add item title center \
                --set title "${title[@]}" \
                --subscribe title window_focus front_app front_app_switched space_change title_change

