#!/bin/bash

sketchybar --animate sin 8 --set title y_offset=20

sleep 0.15

# WINDOW_TITLE=$(/opt/homebrew/bin/yabai -m query --windows --window | jq -r '.title')
#
# if [[ $WINDOW_TITLE = "" ]]; then
#   WINDOW_TITLE=$(/opt/homebrew/bin/yabai -m query --windows --window | jq -r '.app')
# fi

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting
#
if [ "$SENDER" = "front_app_switched" ]; then
  # sketchybar --set $NAME label="$INFO" icon="$($CONFIG_DIR/plugins/icon_map_fn.sh "$INFO")"
  sketchybar --set $NAME label="$INFO" icon="$($CONFIG_DIR/plugins/icon_map_fn.sh "$INFO")"
fi

if [[ $INFO = "" ]]; then
  exit 0
else
  sketchybar --animate sin 8 --set title y_offset=0
fi
