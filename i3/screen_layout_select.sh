#!/bin/bash

# Found at https://github.com/npmaile/PapeChanger/blob/master/papechanger.sh

#declare the root directory for the pape folders
layoutdir="/home/sofamaniac/.screenlayout"

#the script starts here
folderpath="$layoutdir"
selection=""

changepape()
{
	eval $selection
	eval i3-msg restart
}

change_pape_folder()
{
	options=$(ls -d "$layoutdir"/* | sed "s:\($layoutdir\)\(.*\)\/:\2:")
	selection=$folderpath/$(echo "$options" | rofi -dmenu)	
	if [ $? -eq 0 ]; then
		changepape
	else
		exit 1
	fi
}

###############################
#main body
###############################

if [ -z "$*" ]; then
	changepape
else
	change_pape_folder
fi

