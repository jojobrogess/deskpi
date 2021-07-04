#!/bin/bash
# uninstall deskpi script 
. /storage/user/lib/lsb/init-functions

daemonname="deskpi"
deskpidaemon=/storage/.config/system.d/$daemonname.service
safeshutdaemon=/storage/.config/system.d/$daemonname-safeshut.service

log_action_msg "Uninstalling DeskPi PWM Fan Control and Safeshut Service."
sleep 1
log_action_msg "Diable DeskPi PWM Fan Control and Safeshut Service."
log_action_msg "Remove otg_mode=1 configure from /flash/config.txt file"

PIINFO=$(cat /flash/config.txt | grep 'otg_mode=1')
if [ -n "$PIINFO" ]
then
	mount -o remount,rw /flash
	    sed -i '$d' /flash/config.txt # Probably not a good idea to just delete the last line rather than find and delete.
	mount -o remount,ro /flash
fi

log_action_msg "Stop and disable DeskPi services"
systemctl disable $daemonname.service 2&>/dev/null  
systemctl stop $daemonname.service  2&>/dev/null
systemctl disable $daemonname-safeshut.service 2&>/dev/null
systemctl stop $daemonname-safeshut.service 2&>/dev/null
log_action_msg "Remove DeskPi PWM Fan Control and Safeshut Service."
rm -f  $deskpidaemon  2&>/dev/null 
rm -f  $safeshutdaemon 2&>/dev/null 
rm -f /storage/user/bin/fanStop 2&>/dev/null
rm -f /storage/user/bin/pwmFanControl 2&>/dev/null 
rm -f /storage/user/bin/deskpi-config 2&>/dev/null 
rm -f /storage/user/bin/Deskpi-uninstall 2&>/dev/null 
log_success_msg "Uninstall DeskPi Driver Successfully." 
