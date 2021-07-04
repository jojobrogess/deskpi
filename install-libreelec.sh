#!/bin/bash
####init library should be installed first prior to anything####

if [ -e /storage/user/lib ]; then
	rm -f /storage/user/lib
    mkdir /storage/user/lib
fi

# Install init library.
cp -rf $installationfolder/lib/lsb /storage/user/lib/

################################################################
####Set functions and values####
. /storage/user/lib/lsb/init-functions
daemonname="deskpi"
tempmonscript=/storage/user/bin/pmwFanControl
deskpidaemon=/storage/.config/system.d/$daemonname.service
safeshutdaemon=/storage/.config/system.d/$daemonname-safeshut.service
installationfolder=$HOME/$daemonname

####Check for Previous install####
# install wiringPi library.
log_action_msg "DeskPi Fan control script installation Start." 

# Create fan service file on system.
if [ -e $deskpidaemon ]; then
	rm -f $deskpidaemon
	touch /storage/.config/system.d/$daemonname.service
fi

# Create safe shut off service file on system.
if [ -e $deskpidaemon-safeshut ]; then
	rm -f $deskpidaemon
	touch /storage/.config/system.d/$daemonname-safeshut.service
fi

# Create user sub-directories. 
if [ -e /storage/user/bin ]; then
	rm -f /storage/user/bin
	mkdir /storage/user/bin
fi

if [ -e /storage/user/lib ]; then
	rm -f /storage/user/lib
	mkdir /storage/user/lib
fi

####Start Deskpi Install####
# Check and enable otg_mode
PIINFO=$(cat /flash/config.txt | grep 'otg_mode=1')
if [ -z "$PIINFO" ]
then
	mount -o remount,rw /flash
	echo "otg_mode=1" >> /flash/config.txt
	mount -o remount,ro /flash
fi

# Install "C" PWM fan control daemon.
log_action_msg "DeskPi main control service loaded."
cd $installationfolder/drivers/c/ 
cp -rf $installationfolder/drivers/c/pwmFanControl /storage/user/bin/
cp -rf $installationfolder/drivers/c/fanStop  /storage/user/bin/
chmod 755 /storage/bin/pwmFanControl
chmod 755 /storage/bin/fanStop
cp -rf $installationfolder/deskpi-config /storage/user/bin/
cp -rf $installationfolder/Deskpi-uninstall /storage/user/bin/
chmod 755 /storage/user/bin/deskpi-config
chmod 755 /storage/user/bin/Deskpi-uninstall

# Install "Python" PWM Control Fan daemon 
cp -rf $installationfolder/drivers/python/pwmControlFan.py /storage/user/bin/

# Build Fan Daemon
echo "[Unit]" > $deskpidaemon
echo "Description=DeskPi PWM Control Fan Service" >> $deskpidaemon
echo "After=multi-user.target" >> $deskpidaemon
echo "[Service]" >> $deskpidaemon
echo "Type=simple" >> $deskpidaemon
echo "RemainAfterExit=no" >> $deskpidaemon
echo "ExecStart=/storage/user/bin/pwmFanControl" >> $deskpidaemon
echo "[Install]" >> $deskpidaemon
echo "WantedBy=multi-user.target" >> $deskpidaemon

# send signal to MCU before system shuting down.
echo "[Unit]" > $safeshutdaemon
echo "Description=DeskPi Safeshutdown Service" >> $safeshutdaemon
echo "Conflicts=reboot.target" >> $safeshutdaemon
echo "Before=halt.target shutdown.target poweroff.target" >> $safeshutdaemon
echo "DefaultDependencies=no" >> $safeshutdaemon
echo "[Service]" >> $safeshutdaemon
echo "Type=oneshot" >> $safeshutdaemon
echo "ExecStart=/storage/user/bin/fanStop" >> $safeshutdaemon
echo "RemainAfterExit=yes" >> $safeshutdaemon
echo "TimeoutSec=1" >> $safeshutdaemon
echo "[Install]" >> $safeshutdaemon
echo "WantedBy=halt.target shutdown.target poweroff.target" >> $safeshutdaemon

log_action_msg "DeskPi Service configuration finished." 


log_action_msg "DeskPi Service Load module." 
systemctl daemon-reload
systemctl enable $daemonname.service
systemctl start $daemonname.service &
systemctl enable $daemonname-safeshut.service

# Finished 
log_success_msg "DeskPi PWM Fan Control and Safeshut Service installed successfully." 
# greetings and require rebooting system to take effect.
log_action_msg "System will reboot in 5 seconds to take effect." 
sync
sleep 5 
#reboot
