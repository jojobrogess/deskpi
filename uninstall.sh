#!/bin/bash
# uninstall deskpi script 
. /lib/lsb/init-functions

daemonname="deskpi"
deskpidaemon=/storage/.config/system.d/$daemonname.service
safeshutdaemon=/storage/.config/system.d/$daemonname-safeshut.service

log_action_msg "Uninstalling DeskPi PWM Fan Control and Safeshut Service."
sleep 1
log_action_msg "Diable DeskPi PWM Fan Control and Safeshut Service."
log_action_msg "Remove otg_mode=1 configure from /flash/config.txt file"
	mount -o remount,rw /flash
	echo "otg_mode=1" >> /flash/config.txt
	mount -o remount,ro /flash
log_action_msg "Stop and disable DeskPi services"
systemctl disable $daemonname.service 2&>/dev/null  
systemctl stop $daemonname.service  2&>/dev/null
systemctl disable $daemonname-safeshut.service 2&>/dev/null
systemctl stop $daemonname-safeshut.service 2&>/dev/null
log_action_msg "Remove DeskPi PWM Fan Control and Safeshut Service."
rm -f  $deskpidaemon  2&>/dev/null 
rm -f  $safeshutdaemon 2&>/dev/null 
rm -f /storage/bin/fanStop 2&>/dev/null
rm -f /storage/bin/pwmFanControl 2&>/dev/null 
rm -f /storage/bin/deskpi-config 2&>/dev/null 
rm -f /storage/bin/Deskpi-uninstall 2&>/dev/null 
log_success_msg "Uninstall DeskPi Driver Successfully." 
