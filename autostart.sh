#!/bin/bash

if [ "$SSH_CONNECTION" != "" ]; then exit; fi

XDG_VTNR=1
DISPLAY=:0

# The single command to start the graphical session and run the slideshow manager
xinit /home/pi/slideshow_manager.sh
