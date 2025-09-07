#!/bin/bash
skip=0
# Use a while loop to parse arguments
while [ "$1" != "" ]; do
    case "$1" in
        --skip-upgrade | -s )
            skip=1
            ;;
    esac
    shift
done

# Get the absolute path of the script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Change into the script's directory
cd "$SCRIPT_DIR"

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
[ $skip == 1 ] && echo "Updating packages..." || echo "Updating packages and installing required software..."
apt update
check_status
[ $skip == 1 ] || DEBIAN_FRONTEND=noninteractive apt upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
check_status
[ $skip == 1 ] || apt autopurge -y
check_status
apt install -y --no-install-recommends xserver-xorg x11-xserver-utils unclutter feh xinit
check_status

# --- 2. Create Mount Point and Copy Template Files ---
echo "Creating mount point and copying template files..."
mkdir -p /mnt/slideshow
check_status
cp templates/nophotodriveattached.jpg /home/$SUDO_USER/nophotodriveattached.jpg
check_status
cp templates/nophotosindrive.jpg /home/$SUDO_USER/nophotosindrive.jpg
check_status
cp templates/settings.txt /home/$SUDO_USER/settings.txt
check_status

# --- 3. Copy Scripts ---
echo "Copying autostart scripts..."
cp autostart.sh /home/$SUDO_USER/autostart.sh
check_status
cp slideshow_manager.sh /home/$SUDO_USER/slideshow_manager.sh
check_status

# --- 4. Configure Udev Rule ---
echo "Creating udev rule to handle USB hot-plugging..."
cat > /etc/udev/rules.d/99-slideshow.rules << EOF
ACTION=="add", SUBSYSTEM=="block", ENV{ID_BUS}=="usb", RUN+="/bin/sh -c 'pkill feh &'"
ACTION=="remove", SUBSYSTEM=="block", ENV{ID_BUS}=="usb", RUN+="/bin/sh -c 'pkill feh &'"
EOF
check_status
udevadm control --reload-rules
check_status

# --- 5. Fix ownership and permissions ---
echo "Setting file ownership and permissions for the pi user..."
chown -R "$SUDO_UID:$SUDO_GID" "/home/$SUDO_USER"
check_status
chmod +x "/home/$SUDO_USER"/*.sh
check_status

# --- 6. Enable automatic login ---
echo "Enabling automatic login..."
raspi-config nonint do_boot_behaviour B2
check_status

# --- 7. Add Script to User Startup (with idempotency check) ---
echo "Checking and adding autostart script to .bash_profile..."
if ! grep -q "/home/$SUDO_USER/autostart.sh" "/home/$SUDO_USER/.bash_profile"; then
    echo "/home/$SUDO_USER/autostart.sh" >> "/home/$SUDO_USER/.bash_profile"
    check_status
else
    echo "Autostart line already exists in .bash_profile."
fi

# --- Final Check and Reboot ---
if [ $FAILURES -eq 0 ]; then
    echo "Setup succeeded. Rebooting in 5 seconds."
    sleep 5
    sudo reboot
else
    echo "Setup failed. Please check the errors above." >&2
    exit 1
fi
