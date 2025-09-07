#!/bin/bash

# Prevents screen blanking and power management
xset s off
xset -dpms
xset s noblank

# Hide the mouse cursor after a few seconds of inactivity
unclutter &

# Define the mount points and image paths
MOUNT_POINT="/mnt/slideshow"
NO_PHOTOS_IN_DRIVE_IMAGE="$HOME/nophotosindrive.jpg"
NO_DRIVE_ATTACHED_IMAGE="$HOME/nophotodriveattached.jpg"

# Main loop to manage the slideshow, restarts feh if it exits
while true; do
    # First, try to unmount the drive if it's stale. This is safe even if nothing is mounted.
    sudo umount -f "$MOUNT_POINT" 2>/dev/null

    # Find the first available USB partition or disk to mount
    DEVICE_TO_MOUNT=""
    USB_PARTITION=$(lsblk --pairs -no NAME,TYPE -I 8 | awk '/TYPE="part"/ { print $1 }' | sed 's/NAME="//;s/"$//')
    USB_DEVICE=$(lsblk --pairs -no NAME,TYPE -I 8 | awk '/TYPE="disk"/ { print $1 }' | sed 's/NAME="//;s/"$//')

    if [ -n "$USB_PARTITION" ]; then
        DEVICE_TO_MOUNT="$USB_PARTITION"
    elif [ -n "$USB_DEVICE" ]; then
        DEVICE_TO_MOUNT="$USB_DEVICE"
    fi

    # If a device is found, attempt to mount it.
    if [ -n "$DEVICE_TO_MOUNT" ]; then
        if [ ! -d "$MOUNT_POINT" ]; then
            sudo mkdir -p "$MOUNT_POINT"
        fi
        sudo mount "/dev/$DEVICE_TO_MOUNT" "$MOUNT_POINT" 2>/dev/null
    fi

    # Check if the mount point is now valid and the drive is healthy.
    if findmnt --mountpoint "$MOUNT_POINT" >/dev/null 2>&1; then
        # The drive is present. Now, check if it has photos.
        PHOTOS_DIR=$(find "$MOUNT_POINT" -maxdepth 1 -type d -iname "photos" | head -1)
        if [ -n "$PHOTOS_DIR" ]; then
            VALID_PHOTOS_STRING=""
            # Use find and a while loop with a named pipe for sh compatibility
            find "$PHOTOS_DIR" -maxdepth 1 -type f | while read -r file; do
                if file -b --mime-type "$file" | grep -q "^image/"; then
                    # Use printf to properly quote and append filenames to the string
                    printf '%s ' "'$file'" >> "/tmp/valid_photos_$$"
                fi
            done

            # Read the final string from the temporary file
            if [ -f "/tmp/valid_photos_$$" ]; then
                VALID_PHOTOS_STRING=$(cat "/tmp/valid_photos_$$")
                rm "/tmp/valid_photos_$$"
            fi

            if [ -n "$VALID_PHOTOS_STRING" ]; then
                # Drive is healthy and has photos.
                SETTINGS_FILE="$MOUNT_POINT/settings.txt"
                if [ -f "$SETTINGS_FILE" ]; then
                    slideshow_delay=$(grep 'slideshow_delay' "$SETTINGS_FILE" | cut -d'=' -f2)
                else
                    slideshow_delay=10
                fi

                # Start the slideshow in the foreground and wait for it to exit
                eval /usr/bin/feh --fullscreen --slideshow-delay "$slideshow_delay" $VALID_PHOTOS_STRING
            else
                # Drive is attached but has no valid photos.
                /usr/bin/feh --fullscreen "$NO_PHOTOS_IN_DRIVE_IMAGE"
            fi
        else
            # PHOTOS_DIR is not found or empty, display no photos in drive image
            /usr/bin/feh --fullscreen "$NO_PHOTOS_IN_DRIVE_IMAGE"
        fi
    else
        # No drive is attached or found, display the error image
        /usr/bin/feh --fullscreen "$NO_DRIVE_ATTACHED_IMAGE"
    fi

    # A brief delay to prevent a fast loop if feh exits immediately
    sleep 1
done