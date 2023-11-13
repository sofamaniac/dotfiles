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

main () {
	# ensuring submodules are up to date
	git submodule update --init --recursive

	install_packages

	configure_zsh
	sudo bash -c " tailscale up "

	echo "Remember to move userChrome.css to appropriate foler (see about:support)"
	echo "and to enable toolkit.legacyUserProfileCustomizations.stylesheets"
	echo "in about:config"
}

main
