#!/bin/sh

# Define mount points and image paths
MOUNT_POINT="/mnt/slideshow"
PHOTOS_DIR=$(find "$MOUNT_POINT" -maxdepth 1 -type d -iname "photos" | head -1)
NO_PHOTOS_IN_DRIVE_IMAGE="/home/pi/nophotosindrive.jpg"
NO_DRIVE_ATTACHED_IMAGE="/home/pi/nophotodriveattached.jpg"

# Prevents screen blanking and power management
xset s off
xset -dpms
xset s noblank

# Hide the mouse cursor after a few seconds of inactivity
unclutter &

# Check if the drive is attached
if findmnt -n -o SOURCE "$MOUNT_POINT" >/dev/null; then
    # Drive is attached. Now, validate the photos.
    VALID_PHOTOS_STRING=""
    
    # Use find and a while loop with a named pipe for sh compatibility
    find "$PHOTOS_DIR" -maxdepth 1 -type f | while read -r file; do
        if file -b --mime-type "$file" | grep -q "^image/"; then
            # Use printf to properly quote and append filenames to the string
            printf '%s ' "'$file'" >> /tmp/valid_photos_$$
        fi
    done

    # Read the final string from the temporary file
    if [ -f "/tmp/valid_photos_$$" ]; then
        VALID_PHOTOS_STRING=$(cat /tmp/valid_photos_$$)
        rm /tmp/valid_photos_$$
    fi

    # Check if we have valid photos to display
    if [ -n "$VALID_PHOTOS_STRING" ]; then
        # Read the slideshow delay
        SETTINGS_FILE="$MOUNT_POINT/settings.txt"
        if [ -f "$SETTINGS_FILE" ]; then
            slideshow_delay=$(grep 'slideshow_delay' "$SETTINGS_FILE" | cut -d'=' -f2)
        else
            slideshow_delay=10
        fi

        # Start the slideshow with only the valid photos
        # We need eval here to correctly handle the quoted filenames in the string
        eval /usr/bin/feh --fullscreen --slideshow-delay $slideshow_delay $VALID_PHOTOS_STRING
    else
        # No valid photos found in the directory
        /usr/bin/feh --fullscreen "$NO_PHOTOS_IN_DRIVE_IMAGE"
    fi
else
    # No drive is attached
    /usr/bin/feh --fullscreen "$NO_DRIVE_ATTACHED_IMAGE"
fi

exit 0
