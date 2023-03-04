#!/bin/bash

# installing packages available directly
PACKAGES=(
	"picom"
	"neofetch"
	"dunst"
	"kitty"
	"zsh"
	"neovim"
	"lf"
	"polybar"
	"light"
	"networkmanager"
	"network-manager-applet"
	"playerctl"
	"feh"
	"nextcloud-client"
	"syncthing"
	"discord"
	"element-desktop"
	"thunderbird"
	"aerc"
	"firefox"
	"noto-fonts"
	"zathura-pdf-mupdf"
	"pavucontrol"
	"arandr"
	"unclutter"

	# packages needed for neovim
	"nodejs"
	"npm"
	"python-pip"
)
LAPTOP_PACKAGES=(
	# laptop specific
	"iio-sensor-proxy"
	"onboard"
	"acpi"
	"tlp"
)
AUR_PACKAGES=(
	"i3-gaps-rounded-git"
	"pistol-git"
	"ttf-hack"
	"nerd-fonts-hack"
	"cava"
)

LAPTOP_AUR_PACKAGES=(
	# laptop specific
	"i3-battery-popup-git"
	"screenrotator-git"
	"touchegg"
	"detect-tablet-mode-git"
)
LAPTOP=0

prompt_laptop () {
	echo "Run script for :"
	echo "\t1) desktop"
	echo "\t2) laptop"
	read LAPTOP
}

install_packages () {
	TMP="${PACKAGES[@]}"
	if [ $LAPTOP == 2 ]; then
		TMP="$TMP ${LAPTOP_PACKAGES[@]}"
	fi
	sudo bash -c "
	pacman-mirrors --continent
	pacman -Syu
	pacman -S $TMP
	pacman -S --needed git base-devel
	"
	# installing yay
	git clone https://aur.archlinux.org/yay.git ~/yay && cd ~/yay && makepkg -si

	TMP="${AUR_PACKAGES[@]}"
	if [ $LAPTOP == 2 ]; then
		TMP="$TMP ${LAPTOP_AUR_PACKAGES[@]}"
	fi
	yay -Sy $TMP

	python3 -m pip install --user --upgrade pynvim

	# installing i3bgwin which allows to display windows behind all other windows
	git clone https://github.com/quantum5/i3bgwin.git ~/Downloads/i3bgwin
	cd ~/Downloads/i3bgwin
	make
	mkdir ~/bin
	mv i3bgwin ~/bin
	cd ~
}

configure_zsh () {
	# installing oh-my-zsh
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	# install spaceship prompt
	git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
	ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
}

move_config_files () {

	# moving config folders
	BASEDIR=$(dirname "$0")
	if [[ $BASEDIR == "." ]]; then
		BASEDIR=$(pwd)
	fi
	FOLDERS=(
		"i3"
		"polybar"
		"dunst"
		"nvim"
		"kitty"
		"lf"
		"picom"
		"pistol"
		"redshift"
		"rofi"
		"zathura"
	)
	for f in "${FOLDERS[@]}"
	do
		rm -rf $HOME/.config/$f
		ln -s $HOME/dotfiles/$f $HOME/.config/$f
	done

	rm -f ~/.zshrc ; ln -s ~/dotfiles/.zshrc ~/.zshrc
	rm -f ~/.zsh_aliases ; ln -s ~/dotfiles/.zsh_aliases ~/.zsh_aliases
}

main () {
	install_packages
	configure_zsh
	move_config_files

	echo "Remember to move userChrome.css to appropriate foler"
	echo "and to enable toolkit.legacyUserProfileCustomizations.stylesheets"
	echo "in about:config"
}

main
