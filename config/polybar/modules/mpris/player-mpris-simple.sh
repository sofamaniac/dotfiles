#!/usr/bin/env sh
# From https://github.com/polybar/polybar-scripts/blob/master/polybar-scripts/player-mpris-simple/player-mpris-simple.sh

player_status=$(~/.config/polybar/modules/mpris/player-status.sh)

if [ "$player_status" = "Playing" ]; then
	echo ""
elif [ "$player_status" = "Paused" ]; then
	echo ""
else
    echo ""
fi
