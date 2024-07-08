#!/usr/bin/env sh


exlcude_list=()

for dir in $(ls -d */); do
	dir_path=$(realpath -s "$dir")
	dir_no_slash="${path_1%/}"
	if test -f ~/.config/$dir_no_slash; then 
		echo "~/.config/$dir already exists. Skipping"
	else
		ln -s $dir_path  ~/.config/$dir_no_slash
	fi
done
