#!/bin/bash

# installing packages available directly
PACKAGES=(
	"i3"
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
	"nextcloud"
	"syncthing"
	"discord"
	"element-desktop"
	"thunderbird"
	"aerc"
	"firefox"
	"noto-fonts"
	# packages needed for neovim
	"nodejs"
	"npm"
	"python-pip"
)
AUR_PACKAGES=(
	"pistol-git"
	"ttf-hack"

sudo sh -c "
pacman-mirrors -f
pacman -Syu
pacman -S ${PACKAGES[@]}
pacman -S --needed git base-devel
"

python3 -m pip install --user --upgrade pynvim

# installing oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# installing yay
git clone https://aur.archlinux.org/yay.git ~/yay && cd ~/yay && makepkg -si

yay -Sy pistol-git
