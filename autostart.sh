#!/bin/bash

# Define the mount point
MOUNT_POINT="/mnt/slideshow"

# Find the device to mount
PART_NAME=$(lsblk --pairs -no NAME,TYPE -I 8 | awk '/TYPE="part"/ { print $1 }' | sed 's/NAME="//;s/"$//')
DISK_NAME=$(lsblk --pairs -no NAME,TYPE -I 8 | awk '/TYPE="disk"/ { print $1 }' | sed 's/NAME="//;s/"$//')

if [ -n "$PART_NAME" ]; then
    DEVICE_TO_MOUNT="$PART_NAME"
elif [ -n "$DISK_NAME" ]; then
    DEVICE_TO_MOUNT="$DISK_NAME"
fi

# Check if a device was found and mount it
if [ -n "$DEVICE_TO_MOUNT" ]; then
    if [ ! -d "$MOUNT_POINT" ]; then
        sudo mkdir -p "$MOUNT_POINT"
    fi
    sudo mount "/dev/$DEVICE_TO_MOUNT" "$MOUNT_POINT"
fi

# The single command to start the graphical session and run the slideshow manager
startx /home/pi/slideshow_manager.sh
