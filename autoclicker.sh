#!/bin/bash

# simple autoclicker
# calling the script the first time, the killall fails, but not the second time
killall xdotool || while xdotool click --repeat 10 --delay 100 1; do :; done
