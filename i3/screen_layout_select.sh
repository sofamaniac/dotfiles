#!/bin/bash

# Found at https://github.com/npmaile/PapeChanger/blob/master/papechanger.sh

#declare the root directory for the pape folders
layoutdir="/home/sofamaniac/.screenlayout"

change_screen_layout()
{
	options=$(ls -d "$layoutdir"/* | sed "s:\($layoutdir\)\(.*\)\/:\2:")
	selection=$layoutdir/$(echo "$options" | rofi -dmenu)	
	if [ $? -eq 0 ]; then
		eval $selection
	else
		exit 1
	fi
}

change_screen_layout
