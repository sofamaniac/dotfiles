#!/bin/bash
PLAYER_LOCATION="~/dotfiles/polybar/modules/mpris/player"
players=$(playerctl -l 2> /dev/null)
i=0
menu="Default,echo default > $PLAYER_LOCATION\\n"
for s in $players; do
	menu="$menu$s,echo $s > $PLAYER_LOCATION\\n"
done
printf "$menu" | jgmenu --simple --at-pointer
