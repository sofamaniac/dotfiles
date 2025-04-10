#!/usr/bin/env sh

player_status=$(~/.config/polybar/modules/mpris/player-status.sh)
last_status=$(</tmp/player_status)

if [[ $last_status = $player_status ]]; then
  exit 0
fi

echo $player_status >/tmp/player_status

if [[ "$player_status" = "Playing" ]] || [[ "$player_status" = "Paused" ]]; then
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
