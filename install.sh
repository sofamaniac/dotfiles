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
	"noto-fonts-emoji"
	"noto-fonts-extra"
	"noto-fonts-cjk"
	"zathura-pdf-mupdf"
	"pavucontrol"
	"arandr"
	"unclutter"
	"kdeconnect"
	"texlive-most"
	"ocaml"
	"opam"
	"spotify-launcher"
	"jgmenu"

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
)

LAPTOP_AUR_PACKAGES=(
	# laptop specific
	"i3-battery-popup-git"
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

	yay -S --noconfirm zsh-theme-powerlevel10k-git
	echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
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
	rm -f ~/.config/picom.config
}

main () {
	install_packages
	move_config_files
	configure_zsh

	echo "Remember to move userChrome.css to appropriate foler"
	echo "and to enable toolkit.legacyUserProfileCustomizations.stylesheets"
	echo "in about:config"
}

main
