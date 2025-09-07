#!/bin/bash

# Prevents screen blanking and power management
xset s off
xset -dpms
xset s noblank

# Hide the mouse cursor after a few seconds of inactivity
unclutter &

# Define the mount points and image paths
MOUNT_POINT="/mnt/slideshow"
NO_PHOTOS_IN_DRIVE_IMAGE="/home/pi/nophotosindrive.jpg"
NO_DRIVE_ATTACHED_IMAGE="/home/pi/nophotodriveattached.jpg"

# Main loop to manage the slideshow, restarts feh if it exits
while true; do
    # Check if the mount point is valid
    if findmnt -n -o SOURCE "$MOUNT_POINT" >/dev/null; then
        # Check if the photos directory exists and has files in it
        PHOTOS_DIR=$(find "$MOUNT_POINT" -maxdepth 1 -type d -iname "photos" | head -1)
        if [ -n "$PHOTOS_DIR" ] && [ "$(ls -A "$PHOTOS_DIR")" ]; then
            # Read the slideshow delay
            SETTINGS_FILE="$MOUNT_POINT/settings.txt"
            if [ -f "$SETTINGS_FILE" ]; then
                slideshow_delay=$(grep 'slideshow_delay' "$SETTINGS_FILE" | cut -d'=' -f2)
            else
                slideshow_delay=10
            fi

            # Start the slideshow in the foreground and wait for it to exit
            /usr/bin/feh --fullscreen --slideshow-delay "$slideshow_delay" "$PHOTOS_DIR"
        else
            # Drive is attached but has no valid photos
            /usr/bin/feh --fullscreen "$NO_PHOTOS_IN_DRIVE_IMAGE"
        fi
    else
        # No drive is attached
        /usr/bin/feh --fullscreen "$NO_DRIVE_ATTACHED_IMAGE"
    fi
    
    # A brief delay to prevent a fast loop if feh exits immediately
    sleep 1
done
