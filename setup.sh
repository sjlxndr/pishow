#!/bin/bash

# A simple counter for failures
FAILURES=0

# A function to check the last command's exit status
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: The last command failed." >&2
        FAILURES=$((FAILURES + 1))
    fi
}

# --- Check for root permissions ---
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo." >&2
    exit 1
fi

# --- 1. Install Dependencies ---
echo "Updating packages and installing required software..."
apt update
check_status
DEBIAN_FRONTEND=noninteractive apt upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
check_status
apt install -y xserver-xorg x11-xserver-utils unclutter feh xinit
check_status

# --- 2. Create Mount Point and Copy Template Files ---
echo "Creating mount point and copying template files..."
mkdir -p /mnt/slideshow
check_status
cp templates/nophotodriveattached.jpg /home/pi/nophotodriveattached.jpg
check_status
cp templates/nophotosindrive.jpg /home/pi/nophotosindrive.jpg
check_status


# --- 3. Copy Scripts and Set Permissions ---
echo "Copying and configuring autostart scripts..."
chmod +x autostart.sh
check_status
chmod +x run_slideshow.sh
check_status
cp autostart.sh /home/pi/autostart.sh
check_status
cp run_slideshow.sh /home/pi/run_slideshow.sh
check_status
chown pi:pi /home/pi/autostart.sh
check_status
chown pi:pi /home/pi/run_slideshow.sh
check_status

# --- 4. Add Script to User Startup ---
# This ensures the autostart.sh script is run at login
echo "Adding autostart script to .bash_profile..."
echo "/home/pi/autostart.sh" >> /home/pi/.bash_profile
check_status

# --- Final Check and Reboot ---
if [ $FAILURES -eq 0 ]; then
    echo "Setup succeeded. Rebooting in 5 seconds."
    sleep 5
    sudo reboot
else
    echo "Setup failed. Please check the errors above." >&2
    exit 1
fi
