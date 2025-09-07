# Raspberry Pi Kiosk Slideshow

This project provides a simple, robust, and self-contained solution for turning a Raspberry Pi into an auto-playing photo slideshow. It's designed for a headless setup on a fresh installation of Raspberry Pi OS Lite, requiring minimal user interaction after the initial setup.

## Features

  * **Non-Interactive**: Boots directly to the slideshow without a keyboard, mouse, or manual login.
  * **USB Drive Support**: Automatically mounts and reads photos and settings from any attached USB mass storage device.
  * **Robust**: Handles common user errors like corrupt files or a missing `photos` directory by displaying an informative on-screen message.
  * **Automated Deployment**: A single `setup.sh` script automates the entire installation and configuration process, making it easy to replicate.

## Requirements

  * Raspberry Pi 3B+ or newer
  * Raspberry Pi OS Lite (latest version recommended)
  * A stable 5.1V, 2.5A power supply for the Raspberry Pi
  * A USB flash drive with a `photos` directory and an optional `settings.txt` file

## Project Structure

```
.
├── setup.sh                 # The main deployment script
├── autostart.sh             # Handles mounting and starting the graphical session
├── run_slideshow.sh         # The script that runs the slideshow
└── templates/
    ├── settings.txt         # Template for slideshow duration
    ├── nophotodriveattached.jpg   # Displayed when no USB drive is found
    └── nophotosindrive.jpg        # Displayed when a drive has no valid photos
```

## Deployment

1.  **Flash the OS**: Use the Raspberry Pi Imager to flash **Raspberry Pi OS Lite (64-bit)** to your SD card.

2.  **Clone the Repository**: On the Raspberry Pi, clone this repository:

    ```bash
    git clone [your-repo-url]
    cd [your-repo-name]
    ```

3.  **Run the Setup Script**: This script will install all necessary packages and configure the system.

    ```bash
    sudo bash setup.sh
    ```

4.  **Reboot**: After the setup is complete, reboot the Pi.

## Usage

  * **With a USB Drive**: Plug in a USB flash drive containing a folder named `photos` (case-insensitive) with your image files. The slideshow will start automatically.

  * **Without a USB Drive**: The system will display the "no photos drive attached" message.
