#!/usr/bin/env bash

# Found at https://github.com/npmaile/PapeChanger/blob/master/papechanger.sh

#declare the root directory for the pape folders
walpaperdir="$HOME/wallpapers"

#the script starts here
folderpath="$walpaperdir/$(cat .papefolder)"

pick_wallpaper() {
  selectionfile="$(ls "$folderpath" | shuf -n 1)"
  selectionfullpath="$selectionfile"
  echo "$selectionfullpath"
  echo $selectionfullpath >>.papehistory
}

change_wallpaper() {
  numscreens="$(xrandr | grep " connected" | awk '{print $1}' | wc -l)"
  fehargs=("--bg-fill")
  while [ $numscreens -gt 0 ]; do
    newarg="$(pick_wallpaper)"
    fehargs+='" "'
    fehargs+="$newarg"
    numscreens=$(($numscreens - 1))
  done
  eval feh '"'$fehargs'"'
}

change_wallpaper_folder() {
  ls -d *
  options=$(ls -d "$walpaperdir"/* | sed "s:\($walpaperdir\)\(.*\)\/:\2:")
  echo "$options"
  selection=$(echo "$options" | rofi -theme $HOME/.config/rofi/config/launcher.rasi -dmenu)
  if [ $? -eq 0 ]; then
    echo $selection >.papefolder
    folderpath="$walpaperdir/$(cat .papefolder)"
    change_wallpaper
  else
    exit 1
  fi
}

###############################
#main body
###############################

if [ -z "$*" ]; then
  change_wallpaper
else
  change_wallpaper_folder
fi
