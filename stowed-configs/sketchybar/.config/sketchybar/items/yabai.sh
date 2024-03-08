#!/usr/bin/env sh

sketchybar --add       event        window_focus                      \
           --add       item         system.yabai left                 \
           --set       system.yabai script="$PLUGIN_DIR/yabai.sh"     \
                                    icon.font="$FONT:Bold:16.0"       \
                                    label.drawing=off                 \
                                    icon.width=30                     \
                                    icon=$YABAI_GRID                  \
                                    icon.color=$GREEN                 \
                                    updates=on                        \
           --subscribe system.yabai window_focus mouse.clicked
