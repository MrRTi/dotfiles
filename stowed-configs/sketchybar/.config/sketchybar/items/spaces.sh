#!/usr/bin/env bash

SPACE_SIDS=(1 2 3 4 5 6 7 8 9 10)

for sid in "${SPACE_SIDS[@]}"
do
    space=(
        space="$sid"
        icon="$sid"
        icon.padding_left=8
        icon.padding_right=8
        padding_left=2
        padding_right=2
        label.drawing=off
        script="$PLUGIN_DIR/space.sh"
        # click_script="yabai -m space --focus $sid"
    )
    sketchybar --add space space."$sid" left --set space."$sid" "${space[@]}"
done

sketchybar --set space.1 padding_left=-8
