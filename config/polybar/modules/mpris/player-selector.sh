#!/bin/bash
PLAYER_LOCATION="/var/tmp/player_selector"
touch $PLAYER_LOCATION
selected_player=$(cat "$PLAYER_LOCATION")
players=$(playerctl -l 2> /dev/null)
players=("default" $players)
i=0
menu=""
for s in "${players[@]}"; do
	if [ "$s" = "$selected_player" ]; then
		menu="$menu$s,echo $s > $PLAYER_LOCATION,/usr/share/icons/breeze-dark/emblems/16/checkmark.svg\\n"
	else
		menu="$menu$s,echo $s > $PLAYER_LOCATION\\n"
	fi
done
printf "$menu" | jgmenu --simple --at-pointer
