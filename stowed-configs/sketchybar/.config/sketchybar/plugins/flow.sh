#!/bin/bash

TIME=$(osascript -e 'tell application "Flow" to getTime')
PHASE=$(osascript -e 'tell application "Flow" to getPhase') 
RED=0xffed8796
GREEN=0xffa6da95
B
if [ $PHASE = "Flow" ]; then
	COLOR=$GREEN
elif [ $PHASE = "Break" ]; then
	COLOR=$RED
fi

sketchybar --set $NAME label="$TIME $PHASE" icon="󰄉" icon.color=$COLOR
