#!/bin/bash
# return the status of the currently selected player

player=$(cat /home/sofamaniac/dotfiles/polybar/modules/mpris/player)
player_status=""
if [ "$player" = "default" ]; then
	player_status=$(playerctl status 2> /dev/null)
else
	player_status=$(playerctl -p $player status 2> /dev/null)
fi

echo $player_status
