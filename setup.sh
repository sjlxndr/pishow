#!/bin/bash

# --- Check for root permissions ---
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo." >&2
    exit 1
fi

# --- 1. Install Dependencies ---
echo "Updating packages and installing required software..."
apt update
apt upgrade -y
apt install -y xserver-xorg x11-xserver-utils unclutter feh xinit

# --- 2. Create Mount Point and Copy Template Files ---
echo "Creating mount point and copying template files..."
mkdir -p /mnt/slideshow
# The following cp commands assume the script is run from the project root directory
cp templates/nophotodriveattached.jpg /home/pi/nophotodriveattached.jpg
cp templates/nophotosindrive.jpg /home/pi/nophotosindrive.jpg
cp templates/settings.txt /home/pi/settings.txt

# --- 3. Copy Scripts and Set Permissions ---
echo "Copying and configuring autostart scripts..."
chmod +x autostart.sh
chmod +x run_slideshow.sh
cp autostart.sh /home/pi/autostart.sh
cp run_slideshow.sh /home/pi/run_slideshow.sh
chown pi:pi /home/pi/autostart.sh
chown pi:pi /home/pi/run_slideshow.sh

# --- 4. Configure Auto-Login ---
echo "Configuring automatic console login for 'pi' user."
raspi-config nonint do_boot_behaviour B2

# --- 5. Add Script to User Startup ---
# This ensures the autostart.sh script is run at login
echo "Adding autostart script to .bash_profile..."
echo "/home/pi/autostart.sh" >> /home/pi/.bash_profile

echo "Setup complete. Please reboot the Raspberry Pi to start the slideshow."
