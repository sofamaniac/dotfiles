#!/bin/bash

# directory with keymaps
layoutdir="$HOME/dotfiles/keymaps"

change_keymap()
{
	options=$(ls -d "$layoutdir"/* | sed "s:\($layoutdir\)\(.*\)\/:\2:")
	selection=$layoutdir/$(echo "$options" | rofi -dmenu)
	if [ $? -eq 0 ]; then
		xkbcomp -w 0 $selection $DISPLAY
	else
		exit 1
	fi
}

change_keymap

