#!/bin/bash

sketchybar --add item media e \
           --set media label.color=$LABEL_COLOR \
                       label.max_chars=40 \
                       icon.padding_left=0 \
                       scroll_texts=on \
                       updates=on \
                       icon=􀑪             \
                       icon.color=$ICON_COLOR \
                       background.drawing=off \
                       script="$PLUGIN_DIR/media.sh" \
                       position="center" \
           --subscribe media media_change
