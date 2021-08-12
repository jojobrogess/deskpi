# Warning 

This is a literally _hobbled together_ custom install script for the DeskPi Pro case and LibreELEC.

## !!! Preface !!!

1. I have absolutely **no idea** what I'm doing
2. Use all of this at **your own risk**!
3. I also for some reason can't seem to be able to uninstall it fully
4. I do NOT know if the power button works, my device has the pins set to `always on`. The blue light _is_ on though
5. I added in a lsb library from my own personal RPI 4 (found in: /lib/lsb/)
6. The Pyserial module and url was found by GOOGLE SEARCHING so idk if it's safe, but its hosted on a kodi mirror site soooo ...
7. I do NOT (currently) use the DeskPi Pro case with LibreELEC, just got bored and was curious as to why this would be complicated in the first place (simple answer:  there just isn't that much info on the OS) 

_But_, if I get bored again, I might update, clean and fix the installer as well as create an addon so you don't have to ssh into your device everytime if you want to change the temp ranges. 

I already have some code sketched out. I just need to learn a little more about how to create an addon and then how to get that addon to operate less like an addon and more like simple bash/python. Oh yeah plus everything else in-between.

But I digress...

## How to install DeskPi Pro script for Power Button and Fan Control:

### Requirements:

1. Minimum LibreELEC version is a beta version of LibreELEC 10: `LibreELEC-RPi4.arm-9.95.4` or newer
2. Familiarity with using SSH to connect to LibreELEC
3. Spare USB drive

You will need to download a Kodi Matrix-ready (uses Python 3 or above) version of pyserial to a USB drive and install it as an addon. 

https://mirrors.kodi.tv/addons/matrix/script.module.pyserial/

Ensure you choose the latest pyserial version which is, at least as of mid August 2021:

https://mirrors.kodi.tv/addons/matrix/script.module.pyserial/script.module.pyserial-3.4.0+matrix.2.zip

**IF you're `ADVANCED` GO TO BOTTOM**

### After you do that, then follow these instructions:

Connect LibreELEC to the internet.
        This can be done with either ethernet or WiFi
        To check if the Ethernet or WiFi adapters are enabled, go to `Settings` > `LibreElec` > `Network`

Enable SSH. You need another computer to access the terminal of LibreELEC
        This can be done upon installation during wiki. Default Username= `root` Password=`libreelec`
        To check if SSH is enabled, go to
        `Settings` > `LibreELEC` > `Services`

You might also want to make sure to allow addons/updates from any source. 
        `Settings` > `System` > `Addons`

Install Raspberry Pi Tools and System Tools
        These can be installed by going to `Addons` > `Install from Repository` > `LibreElec Addons` > `Program Addons`

Plug the USB device you loaded with pyserial into your device.
Install Pyserial from usb
         Go to `Addons` > `Install from a zip file` > Navigate to your USB drive > pyserial.zip (should install like an addon) but it's just a library.(AFAIK)

Connect via SSH. The default username for LibreELEC is `root` while the default password is `libreelec`
        For Windows users, the best way to use SSH is through PuTTY using the IP address of the Pi and port 22.
        Linux users `ssh root@[ip address of device]`.
            If connecting to the device for the first time, you will be asked if you're sure you want to connect to the device. 
Confirm by typing `yes` FULLY, typing `y` will **NOT** suffice. 
  
### After you've installed the required libraries, Connect into LibreELEC through SSH:

`ssh root@IP.TO.YOUR.LIBREELEC`

Type this:

`wget https://github.com/jojobrogess/deskpi/archive/refs/heads/Libreelecinstaller.zip`

`unzip Libreelecinstaller.zip`

`chmod +x deskpi-Libreelecinstaller/lib/lsb/init-functions && chmod +x deskpi-Libreelecinstaller/install-libreelec.sh`

`./deskpi-Libreelecinstaller/install-libreelec.sh`

#### Go to "After the device reboots"

## For Advanced Users:

1. Download `https://mirrors.kodi.tv/addons/matrix/script.module.pyserial/` put on USB.
2. Install .zip through addons page.
3. Install `Raspberry Pi Tools` and `System Tools` from Kodi repo > Programs.
4. ssh into device
5. `wget https://github.com/jojobrogess/deskpi/archive/refs/heads/Libreelecinstaller.zip`
6. `unzip Libreelecinstaller.zip`
7. `chmod +x deskpi-Libreelecinstaller/lib/lsb/init-functions && chmod +x deskpi-Libreelecinstaller/install-libreelec.sh`
8. `./deskpi-Libreelecinstaller/install-libreelec.sh`
9. Wait for reboot. Reconnect ssh.
10. `./Libreelecinstaller/Deskpi-config`
11. Adjust speed and temps.
 
### After the device reboots:

Reconnect through SSH and run this:

`./Libreelecinstaller/Deskpi-config`

Use the config menu normally. 

At this moment, IDK what happens if you try to set custom values or if the options would even be persistent after reboot.

**Note (as of right now)**: I have not been able to make an addon to enable adjusting temperature ranges (via `deskpi-config`) from the Kodi interface rather than SSH. If I can build one, I will either post in this thread or make a new one.
