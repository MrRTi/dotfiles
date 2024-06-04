#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

if [ "$SELECTED" = "true" ]; then
    sketchybar --animate sin 15 --set "$NAME" background.color=$YELLOW icon.color=$BLACK
else
    sketchybar --animate sin 15 --set "$NAME" background.color=$BAR_COLOR icon.color=$ICON_COLOR
fi
