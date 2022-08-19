#!/bin/bash

player=$(cat ~/dotfiles/polybar/modules/mpris/player)
if [ "$player" = "default" ]; then
	playerctl $1
else
	playerctl -p $player $1
fi
