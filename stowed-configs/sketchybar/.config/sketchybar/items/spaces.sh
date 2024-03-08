#!/usr/bin/env bash

SPACE_SIDS=(1 2 3 4 5 6 7 8 9 10)

for sid in "${SPACE_SIDS[@]}"
do
  sketchybar --add space      space.$sid left                    \
             --set space.$sid space=$sid                         \
                              icon=$sid                          \
                              icon.padding_left=15               \
                              icon.padding_right=15              \
                              icon.highlight_color=$RED          \
                              background.padding_left=-8         \
                              background.padding_right=-8        \
                              background.corner_radius=9         \
                              label.drawing=off                  \
                              script="$PLUGIN_DIR/space.sh"      \
                              click_script="$SPACE_CLICK_SCRIPT"
done

