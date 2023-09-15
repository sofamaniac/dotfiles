#!/bin/bash
# return the status of the currently selected player

player=$(cat /var/tmp/player_selector)
player_status=""
if [ "$player" = "default" ]; then
	player_status=$(playerctl status 2> /dev/null)
else
	player_status=$(playerctl -p $player status 2> /dev/null)
fi

echo $player_status
