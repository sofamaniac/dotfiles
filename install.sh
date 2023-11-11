#!/bin/bash

# installing packages available directly
PACKAGES=(
	"light"
	"element-desktop"
)
LAPTOP_PACKAGES=(
	# laptop specific
	"iio-sensor-proxy"
	"onboard"
	"acpi"
	"tlp"
)
AUR_PACKAGES=(
	"pistol-git"
)

LAPTOP_AUR_PACKAGES=(
	# laptop specific
	"i3-battery-popup-git"
)
LAPTOP=0

install_packages () {

	# order mirrors based on speed,
	# update and install ansible
	sudo bash -c "
	pacman-mirrors --continent
	pacman -Syu
	pacman -S --needed git base-devel
	pacman -S ansible-core ansible
	"

	cd ansible
	# ansible-galaxy install -r requirements.yml
	ansible-playbook --ask-become-pass playbook.yml
	cd ~/dotfiles
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
		"pistol"
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

	echo "Remember to move userChrome.css to appropriate foler (see about:support)"
	echo "and to enable toolkit.legacyUserProfileCustomizations.stylesheets"
	echo "in about:config"
}

main
