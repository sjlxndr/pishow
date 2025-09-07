#!/bin/bash

if [ "$SSH_CONNECTION" != "" ]; then exit; fi

# The single command to start the graphical session and run the slideshow manager
startx /home/pi/slideshow_manager.sh
