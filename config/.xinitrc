#!/bin/sh

# load default xinitrc
[ -f /etc/X11/xinit/xinitrc ] && . /etc/X11/xinit/xinitrc
# start custom programs
[ -f ~/.xprofile ] && . ~/.xprofile
