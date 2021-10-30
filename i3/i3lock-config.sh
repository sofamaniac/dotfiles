#!/bin/bash


# PICTURE=/tmp/i3lock.png
# PICTURE=~/lock.png
# SCREENSHOT="scrot $PICTURE"

# BLUR="16x8"

# $SCREENSHOT
# convert $PICTURE -blur $BLUR $PICTURE
# i3lock -i $PICTURE
# rm $PICTURE

#!/bin/bash
ICON=$HOME/lock_icon.png
TMPBG=/tmp/screen.png
scrot $TMPBG
convert $TMPBG -scale 10% -scale 1000% $TMPBG
convert $TMPBG $ICON -gravity center -composite -matte $TMPBG
i3lock -u -i $TMPBG
rm $TMPBG
