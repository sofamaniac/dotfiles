#!/bin/sh

player_status=$($POLYBAR_BASE/modules/mpris/player-status.sh)

if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ] ; then
	polybar-msg action "#player-prev.module_show"
	polybar-msg action "#player-next.module_show"
	polybar-msg action "#player-info.module_show"
	polybar-msg action "#player-pause.module_show"
else
	polybar-msg action "#player-prev.module_hide"
	polybar-msg action "#player-next.module_hide"
	polybar-msg action "#player-info.module_hide"
	polybar-msg action "#player-pause.module_hide"
fi
