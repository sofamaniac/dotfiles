#!/usr/bin/env sh

player=$(cat /var/tmp/player_selector)
if [ "$player" = "default" ]; then
	playerctl $1
else
	playerctl -p $player $1
fi
