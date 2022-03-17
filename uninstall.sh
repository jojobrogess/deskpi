#!/bin/bash
# uninstall deskpi script 
daemonname='deskpi'
daemonconfig=/storage/user/bin/deskpi-config
deskpidaemon='/storage/.config/$daemonname.service'
#safeshutdaemon='/storage/.config/$daemonname-safeshut.service'

echo "Uninstalling DeskPi PWM Fan Control and Safeshut Service."
sleep 1
echo "Remove otg_mode=1 configure from /flash/config.txt file"

PIINFO=$(cat /flash/config.txt | grep 'otg_mode=1')
if [ -n "$PIINFO" ]
then
	mount -o remount,rw /flash
	    sed -i 'otg_mode=1,dtoverlay=dwc2,dr_mode=host' /flash/config.txt # Probably not a good idea to just delete the last line rather than find and delete.
	mount -o remount,ro /flash
fi
echo "Removed otg_mode=1 configure from /flash/config.txt file"

echo "Diable DeskPi PWM Fan Control and Safeshut Service."

systemctl disable $daemonname.service 2&>/dev/null  
systemctl stop $daemonname.service  2&>/dev/null
#systemctl disable $daemonname-safeshut.service 2&>/dev/null
#systemctl stop $daemonname-safeshut.service 2&>/dev/null

echo "Remove DeskPi PWM Fan Control and Safeshut Service."
rm -f  $deskpidaemon  2&>/dev/null 
#rm -f  $safeshutdaemon 2&>/dev/null 
#rm -f /storage/user/bin/fanStop 2&>/dev/null
rm -f /storage/user/bin/pwmFanControl 2&>/dev/null 
rm -f /storage/user/bin/deskpi-config 2&>/dev/null 
echo "Uninstall DeskPi Driver Successfully." 

echo "Remove userfiles"
rm -f $daemonconfig
rm -f /storage/user/bin/deskpi.conf
sleep 5
echo "Going to attempt to kill myself now..."
sleep 2
echo "wish me luck"
sleep 2
echo "?"
rm -- "$0"
