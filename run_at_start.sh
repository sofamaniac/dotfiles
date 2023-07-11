playerctld daemon
xkbcomp -w 0 ~/dotfiles/keymaps/azerty $DISPLAY
~/.config/i3/bg_setter.sh
xsettingsd &
~/.config/polybar/launch_polybar.sh &
picom -b --config ~/.config/picom/picom.conf
nextcloud &
nm-applet &
dunst -config ~/.config/dunst/dunstrc &
kdeconnect-indicator &
unclutter &
