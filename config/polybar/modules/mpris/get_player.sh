#!/usr/bin/env sh

if ! [[ -e /var/tmp/player_selector ]]; then
	echo "yama" > /var/tmp/player_selector
fi

echo `cat /var/tmp/player_selector`
