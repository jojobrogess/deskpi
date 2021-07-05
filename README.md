THIS IS A CUSTOM INSTALL SCRIPT, literally hobbled together.
FOR THE DESKPI PRO CASE and LIBRE ELEC.

**********************************************************************************************************************************************************************

# Please go check out the AuraMod skin being developed by SerpentDrago and others:
AuraMod is a Heavily Modified version of Aura by jurialmunkey. Combining parts and code of Aura, Artic Zephyr 2, Titan Bingie and many others!
https://github.com/SerpentDrago/skin.auramod/tree/Matrix

**********************************************************************************************************************************************************************

# !!!PREFACE!!!:
I have absolutely **NO** idea what I'm doing. 
Use all of this at **your own risk**!
I also for some reason can't seem to be able to uninstall it fully.
I do NOT know if the power button works, my device has the pins set to `always on`. The blue light _is_ on though.


I added in a lsb library from my own personal RPI 4 (found in: /lib/lsb/).
The Pyserial module and url was found by GOOGLE SEARCHING so idk if it's safe, but its hosted on a kodi mirror site soooo...

I do NOT (currently) use the Deskpi Pro case for Libreelec. 
I just got bored and was curious as to why this would be complicated in the first place.
(Simple answer there just isn't that much info on the OS) 
BUT if I get bored again, I might update, clean, and fix the installer. 
As well as create an addon so you don't have to ssh into your device everytime if you want to change the temp ranges. 
I already have some code sketched out, I just need to learn a little more about how to create an addon and then how to get that addon to operate less like an addon and more like simple bash/python. Oh yeah plus everything else in-between.
But I digress...

************************************************************************************************************************************

## How to install DeskPi Pro script for Power Button and Fan Control:

************************************************************************************************************************************
### REQUIREMENTS:

You MUST be on at least `LibreELEC-RPi4.arm-9.95.4`
extra computer or at least ssh terminal
extra usb

You will need to download a matrix ready version of pyserial on a USB and install it as an addon. 
`https://mirrors.kodi.tv/addons/matrix/script.module.pyserial/` 
MAKE SURE you choose the latest(as of right now it's):
Script.module.pyserial-3.4.0+matrix.2.zip | 100.0 KiB | 2020-May-01 14:30

**IF you're `ADVANCED` GO TO BOTTOM**

************************************************************************************************************************************

### After you do that, then follow these instructions:

************************************************************************************************************************************

Connect LibreElec to the internet.
        This can be done with either ethernet or WiFi
        To check if the Ethernet or WiFi adapters are enabled, go to Settings>LibreElec>Network 

Enable SSH. You need another computer to access the terminal of LibreElec
        This can be done upon installation during wiki. Default Username= `root` Password=`libreelec`
        To check if SSH is enabled, go to
        Settings>LibreElec> Services 

You might also want to make sure to allow addons/updates from any source. 
        Settings> System> Addons

Install Raspberry Pi Tools and System Tools
        These can be installed by going to Addons>Install from Repository>LibreElec Addons>Program Addons 

Plug the USB device you loaded with pyserial into your device.
Install Pyserial from usb
         Go to Addons>Install from a zip file>Navigate to usb drive>pyserial.zip (should install like an addon) but it's just a library.(AFAIK)

Connect via SSH. The default username for LibreElec is `root` while the default password is `libreelec`
        For Windows users, the best way to use SSH is through Putty using the IP address of the Pi and port 22.
        Linux users `ssh root@[ip address of device]`.
            If connecting to the device for the first time, you will be asked if you're sure you want to connect to the device. 
Confirm by typing `yes` FULLY, typing `y` will **NOT** suffice. 

************************************************************************************************************************************ 
   
### After you've installed the required libraries, Connect into Libreelec through SSH:

************************************************************************************************************************************
`ssh root@IP.TO.YOUR.LIBREELEC`

Type this:

`wget https://github.com/jojobrogess/deskpi/archive/refs/heads/Libreelecinstaller.zip`

`unzip Libreelecinstaller.zip`

`chmod +x deskpi-Libreelecinstaller/lib/lsb/init-functions && chmod +x deskpi-Libreelecinstaller/install-libreelec.sh`

`./deskpi-Libreelecinstaller/install-libreelec.sh`


************************************************************************************************************************************ 
   
### After the device reboots:

************************************************************************************************************************************

Reconnect through SSH and run this:
`./Libreelecinstaller/Deskpi-config`

Use the config menu normally. 
At this moment, idk what happens if you try to set custom values or if the options would even be persistent after reboot.

************************************************************************************************************************************

## FOR ADVANCED:

************************************************************************************************************************************

1. Download `https://mirrors.kodi.tv/addons/matrix/script.module.pyserial/` put on USB.
2. Install .zip through addons page.
3. Install `Raspberry Pi Tools` and `System Tools` from Kodi repo>Programs.
4. ssh into device
5. `wget https://github.com/jojobrogess/deskpi/archive/refs/heads/Libreelecinstaller.zip`
6. `unzip Libreelecinstaller.zip`
7. `chmod +x deskpi-Libreelecinstaller/lib/lsb/init-functions && chmod +x deskpi-Libreelecinstaller/install-libreelec.sh`
8. `./deskpi-Libreelecinstaller/install-libreelec.sh`
9. Wait for reboot. Reconnect ssh.
10. `./Libreelecinstaller/Deskpi-config`
11. Adjust speed and temps.



Note (as of right now): I have not been able to make an addon to be able to adjust the deskpi-config files so you can change the temperature ranges without having to SSH into your libreelec every time. If I can build one, I will either post in this thread or make a new one.
