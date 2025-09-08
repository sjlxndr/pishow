# "PiShow" Raspberry Pi Kiosk Slideshow

This project provides a simple, robust, and self-contained solution for turning a Raspberry Pi into an auto-playing photo slideshow. It's designed for a headless setup on a fresh installation of Raspberry Pi OS Lite, requiring minimal user interaction after the initial setup.

## Dedication

This project was created for The Hub: Teen & Community Center of Bradford, VT, and is dedicated to community organizations everywhere working to connect with and serve their neighborhoods. If this project helps your organization better connect with your community, consider supporting The Hub's mission at https://www.bradfordteencenter.org/

## Features

  * **Non-Interactive**: Boots directly to the slideshow without a keyboard, mouse, or manual login.
  * **USB Drive Support**: Automatically detects, mounts, and reads photos and settings from any attached USB mass storage device.
  * **Image Filtering**: Automatically filters for valid image files within the `photos` directory.
  * **Robust**: Handles common user errors like corrupt files or a missing `photos` directory by displaying an informative on-screen message.
  * **Automated Deployment**: A single `setup.sh` script automates the entire installation and configuration process, making it easy to replicate.

## Requirements

  * Raspberri Pi (3B+ or newer recommended)
  * Raspberry Pi OS Lite (latest version recommended)
  * A USB flash drive with a `photos` directory and an optional `settings.txt` file

## Project Structure

```
.
├── setup.sh                 # The main deployment script
├── autostart.sh             # Starts the X server and then runs the slideshow_manager.sh
├── run_slideshow.sh         # The script that runs the slideshow
├── slideshow_manager.sh     # Manages USB drive mounting, photo validation, and continuously runs the slideshow.
└── templates/
    ├── settings.txt         # Template for slideshow duration
    ├── nophotodriveattached.jpg   # Displayed when no USB drive is found
    └── nophotosindrive.jpg        # Displayed when a drive has no valid photos
```

## Deployment

1.  **Flash the OS**: Use the Raspberry Pi Imager to flash **Raspberry Pi OS Lite (64-bit)** to your SD card.
2.  **Install Git**:
   
    ```
    sudo apt update
    sudo apt install git
    ```

3.  **Clone the Repository**: On the Raspberry Pi, clone this repository:

    ```bash
    git clone https://github.com/sjlxndr/pishow
    cd pishow
    ```

4.  **Run the Setup Script**: This script will install all necessary packages and configure the system.

    ```bash
    sudo bash setup.sh
    ```

5.  **Reboot**: After the setup is complete, reboot the Pi.

## Usage

  * **With a USB Drive**: Plug in a USB flash drive containing a folder named `photos` (case-insensitive) with your image files. The slideshow will start automatically.

  * **Without a USB Drive**: The system will display the "no photos drive attached" message.

### Customizing the Slideshow

You can customize the slideshow's behavior by creating a `settings.txt` file in the root directory of your USB drive. This file contains a single key-value pair to control the duration of each slide.

`settings.txt` example:
```
slideshow_delay=10
```

*   **slideshow_delay**: Set this to the number of seconds you want each photo to display. If this file or the `slideshow_delay` entry is missing, the slideshow will default to a 10-second delay.




