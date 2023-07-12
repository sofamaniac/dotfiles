# screen setup
HOSTNAME=$(hostname)
FILE=~/dotfiles/screenlayout/$HOSTNAME.sh
if test -f "$FILE"; then
  $FILE
fi
playerctld daemon
xkbcomp -w 0 ~/dotfiles/keymaps/azerty $DISPLAY
picom -b --config ~/.config/picom/picom.conf
~/.config/i3/bg_setter.sh
xsettingsd &
~/.config/polybar/launch_polybar.sh &
nm-applet &
dunst -config ~/.config/dunst/dunstrc &
kdeconnect-indicator &
unclutter &

if [ "$name" = "astolfo" ]; then
  nextcloud &
fi


