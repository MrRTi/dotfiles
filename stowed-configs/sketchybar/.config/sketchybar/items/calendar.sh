#!/bin/sh

sketchybar --add item calendar right \
                --set calendar icon=􀧞 \
                update_freq=3- \
                script="$PLUGIN_DIR/calendar.sh" \
                padding_right=-6

