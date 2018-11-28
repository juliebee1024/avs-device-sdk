
# Smart Mirror

[![License](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)

# Introduction

Alexa is ran in the background of the Smart Mirror.

- alexa-client-sdk v1.10

## Getting Started
### Create Smart Mirror Profile on Amazon Developer
1. Follow https://developer.amazon.com/docs/alexa-voice-service/register-a-product.html to create your product profile on Amazon Developer

### Required Hardware 
- Raspberry Pi 3B+ Kit
- USB Microphone
- 3.5mm Audio Cable
- Monitor
- Keyboard
- Mouse

*Referenced from: https://developer.amazon.com/docs/alexa-voice-service/required-hardware.html*

1. Follow https://developer.amazon.com/docs/alexa-voice-service/set-up-raspberry-pi.html to setup Raspbian OS and the Raspberry Pi

### Required Software
- AVS Device SDK
1. Run ` sudo apt-get upgrade ` to get the necessary updates on terminal in the Raspberry Pi
2. Get necessary files:
```bash
wget https://raw.githubusercontent.com/juliebee1024/smart-mirror-alexa/master/pi.sh \
wget https://raw.githubusercontent.com/juliebee1024/smart-mirror-alexa/master/setup.sh
```
3. Create a config file:
```bash
sudo nano config.txt
```
4. Copy and paste into the config file:
```
#NOTE: The Device Serial Number can be any unique number
DEVICE_SERIAL_NUMBER=""
CLIENT_ID=""
PRODUCT_ID=""
```
5. Open a web browser and login to Amazon Developer (https://developer.amazon.com/avs/home.html#/avs/home) and click on your product
6. Scroll down and copy & paste the **Product ID** into config.txt
7. Click on "**Security Profile**" under the "Product Details" tab
8. Scroll down and click on "**Other devices and platforms**"
9. Copy & paste the **Client ID** into config.txt
10. Enter any number (i.e. 123456) as the **Device Serial Number**
11. Ctrl-o and enter to save
12. Ctrl-x to exit
13. Follow https://developer.amazon.com/docs/alexa-voice-service/input-avs-credentials.html starting at "**Download your credentials**" to get the config.json file
14. In terminal, run the install script
```bash
cd /home/pi
sudo bash setup.sh config.txt
```
15. Follow https://developer.amazon.com/docs/alexa-voice-service/build-the-avs-device-sdk.html for the rest of the installation process


## To Run Alexa
### If you do not have the Refresh token yet:
1. Follow https://developer.amazon.com/docs/alexa-voice-service/get-a-refresh-token.html to get your refresh token and start the Alexa application

### If you already have the Refresh token:
1. Run the Alexa application by:
```bash
sudo bash /home/pi/startsample.sh
```

*Reference https://developer.amazon.com/docs/alexa-voice-service/talk-with-alexa.html should you have any issues communicating with Alexa.*

## To Add Wake Sound
1. For wake sound, follow https://developer.amazon.com/docs/alexa-voice-service/indicate-device-state-with-sounds.html

## To Add Notification of Boot Up
1. Stop Alexa if it is running with Ctrl-c and download sound file from terminal:
```bash
wget https://raw.githubusercontent.com/juliebee1024/smart-mirror-alexa/master/hello.wav
```
2. Open File Manager and move **hello.wav** from ``/home/pi/Downloads`` folder to ``/home/pi/sounds`` folder
3. If you do not have permission to move files into the sounds folder, enter in terminal ``sudo chown -R pi:pi /home/pi`` and try step 2 again
4. Navigate to ``cd /home/pi/avs-device-sdk/SampleApp/src/`` and ``nano UIManager.cpp``
5. Double check to make sure ``#include <cstdlib>`` is included in the beginning of **UIManager.cpp** -- if not, add it in
6. Scroll down to ``void UIManager::printState()`` function
7. Find
```cpp
} else if (m_connectionStatus == avsCommon::sdkInterfaces::ConnectionStatusObserverInterface::Status::PENDING) {
ConsolePrinter::prettyPrint("Connecting...");
```
and add in ``system("play /home/pi/sounds/hello.wav");`` such that it looks like this:
```cpp
} else if (m_connectionStatus == avsCommon::sdkInterfaces::ConnectionStatusObserverInterface::Status::PENDING) {
ConsolePrinter::prettyPrint("Connecting...");
system("play /home/pi/sounds/hello.wav"); //sound file for notification of bootup
```
8. Save the file (Ctrl-o) and close (Ctrl-x)
9. Rebuild the Sample App for changes to take effect:
```cpp
cd /home/pi/build/SampleApp
sudo make
``` 
10. Once the Sample App rebuilds, restart Alexa: ``sudo bash /home/pi/startsample.sh``

## To Autoboot Alexa
1. Stop Alexa if it is running with Ctrl-c and make a copy of the original .bashrc just in case: ``cp /home/pi.bashrc /home/pi/.bashrc-original``
2. Edit the .bashrc file with ``sudo nano /home/pi/.bashrc``
3. Scroll all the way to the bottom of the file and add in ``sudo bash /home/pi/startsample.sh`` on a new line after the final ``fi``
4. Save (Ctrl-o) and exit (Ctrl-x)
5. Enter ``sudo raspi-config`` in terminal -> select ``3 Boot Options`` -> select ``B1 Desktop/ CLI`` -> select ``B2 Console Autologin``
6. ``<Finish>`` and select ``<yes>`` to reboot the Raspberry Pi

## Customizing Alexa
1. To set your location for weather and traffic data, follow https://developer.amazon.com/docs/alexa-voice-service/set-device-location.html
2. To adjust sound sensitivity of the mic, type ``alsamixer`` in terminal
3. To force sound through 3.5mm audio jack or HDMI, type ``sudo raspi-config`` in terminal -> select ``7 Advanced Options`` -> select ``A4 Audio`` -> choose either ``1`` or ``2`` depending on what you want
4. To train Alexa to your voice for a better sensitivity say "Learn my voice" and follow Alexa's instructions to create your voice profile (more information found: https://www.amazon.com/gp/help/customer/display.html/ref=hp_bc_nav?ie=UTF8&nodeId=202199440)
