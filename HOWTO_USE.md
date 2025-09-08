# PiShow: Your Easy Photo Slideshow Guide

Welcome to your new PiShow device! This guide will help you set up your PiShow to display your favorite photos on any TV or monitor. It's designed to be super simple, so you don't need any special computer skills.

## What is PiShow?

PiShow is a small computer (a Raspberry Pi) that automatically turns your photos into a slideshow on your TV. Just plug it in, add your photos, and it does the rest.

## What You'll Need

You should have received:

*   **Your PiShow Device:** This is the small computer (Raspberry Pi) with the PiShow software already installed.
*   **Power Supply:** The cable and adapter to power your PiShow.

You will need to provide:

*   **A USB Flash Drive:** This is where you'll put your photos. Any standard USB drive will work.
*   **An HDMI Cable:** To connect your PiShow to your TV or monitor.
*   **A TV or Monitor:** With an HDMI input.

## Step 1: Prepare Your USB Drive with Photos

This is where you tell PiShow which photos to display.

1.  **Get Your USB Drive Ready:**
    *   Plug your USB flash drive into a regular computer (Windows, Mac, or Linux).
    *   Make sure the USB drive is empty, or move any important files off it first.

2.  **Create a "photos" Folder:**
    *   On your USB drive, create a new folder.
    *   Name this folder `photos` (not case-sensitive, but the name is important).

3.  **Add Your Photos:**
    *   Copy all the pictures you want to see in your slideshow into the `photos` folder you created on your USB drive.
    *   PiShow will display common image formats like JPG, PNG, etc.

4.  **(Optional) Customize Slideshow Speed:**
    *   If you want to change how long each photo stays on screen, you can create a settings file.
    *   Inside the main part of your USB drive (not inside the `photos` folder, but next to it), create a new text file.
    *   Name this file exactly `settings.txt` (not case-sensitive, but the name is important).
    *   Open `settings.txt` with a simple text editor (like Notepad on Windows, TextEdit on Mac, or any plain text editor).
    *   Type the following line into the file:
        ```
        slideshow_delay=10
        ```
    *   You can change the number `10` to any number of seconds you want each photo to display. For example, `slideshow_delay=5` for 5 seconds, or `slideshow_delay=20` for 20 seconds.
    *   Save and close the `settings.txt` file.
    *   If you don't create this file, each photo will display for 10 seconds by default.

5.  **Safely Remove USB Drive:**
    *   Once your photos are copied and `settings.txt` (if you made it) is saved, safely eject or unmount the USB drive from your computer.

## Step 2: Connect PiShow to Your TV

Now, let's get your PiShow connected.

1.  **Connect HDMI:**
    *   Plug one end of your HDMI cable into the HDMI port on your PiShow device.
    *   Plug the other end of the HDMI cable into an available HDMI input on your TV or monitor.
    *   Take note of which HDMI input you used (e.g., HDMI 1, HDMI 2).

2.  **Connect Power:**
    *   Plug the power supply cable into the power port on your PiShow device.
    *   Plug the power adapter into a wall outlet.
    *   Note: the device has no power switch, so it will power on automatically.

3.  **Turn on Your TV:**
    *   Turn on your TV or monitor.
    *   Using your TV remote or the onscreen display of your monitor, select the correct HDMI input that your PiShow is connected to (e.g., switch to HDMI 1 if you plugged it into HDMI 1).

## Step 3: Start the Slideshow!

Your PiShow should now be powered on and connected to your TV.

1.  **Insert Your USB Drive:**
    *   Carefully plug your prepared USB flash drive (with the `photos` folder) into one of the USB ports on your PiShow device.

2.  **Watch the Magic Happen:**
    *   PiShow will automatically detect your USB drive and start the slideshow. It might take a few moments for the first photo to appear.
    *   There's nothing else you need to do! The slideshow will run continuously.

## Troubleshooting

*   **"No Photo Drive Attached" Message:**
    *   If you see a message on your screen saying "No Photo Drive Attached," it means PiShow can't find your USB drive.
    *   Make sure the USB drive is fully plugged into the PiShow.
    *   Try unplugging and re-plugging the USB drive.
    *   Ensure your USB drive is properly formatted and has the `photos` folder in the correct location.

*   **"No Photos in Drive" Message:**
    *   If you see a message saying "No Photos in Drive," it means PiShow found your USB drive but couldn't find any valid photos inside the `photos` folder.
    *   Double-check that you created a folder named `photos` (case-insensitive) on your USB drive.
    *   Make sure you copied actual image files (like JPGs) into that `photos` folder.

*   **Blank Screen or No Signal:**
    *   Ensure your TV is on and you've selected the correct HDMI input.
    *   Check that the HDMI cable is securely plugged into both the PiShow and your TV.
    *   Make sure the PiShow power supply is plugged in and the PiShow device has a light on (usually a red or green LED).

---

Enjoy your PiShow!
