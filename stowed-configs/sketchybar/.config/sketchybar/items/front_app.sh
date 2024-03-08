#!/usr/bin/env sh

sketchybar --add       item         front_app left                    \
           --set       front_app    script="$PLUGIN_DIR/front_app.sh" \
                                    icon.padding_left=15              \
                                    icon.font="sketchybar-app-font:Regular:13.0" \
                                    icon.color=$YELLOW                \
                                    background.padding_left=0         \
                                    label.color=$YELLOW               \
           --subscribe front_app    front_app_switched

