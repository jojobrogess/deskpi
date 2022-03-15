#!/bin/bash
####init library should be installed first prior to anything####
daemonname="deskpi"
installationfolder=$HOME/$daemonname

deskpi_create_file() {
	if [ -f $1 ]; then
        rm $1
    fi
	touch $1
	chmod 666 $1
}

#if [ -e "/storage/user/lib/lsb" ] ; then
#	rm -r /storage/user/lib/lsb
#fi
#
#if [ ! -d "/storage/user" ] ; then
#	mkdir -p /storage/user
#	mkdir -p /storage/user/lib
#	mkdir -p /storage/user/bin
#fi
#
# Install init library.
#cp -rf $installationfolder/lib/lsb /storage/user/lib/
#chmod +x $installationfolder/lib/lsb/init-functions
#
################################################################
####Set functions and values####
. /storage/user/lib/lsb/init-functions
daemonname="deskpi"
powerbuttonscript=/storage/.config/$daemonname.py
shutdaemonscript=/storage/.config/$daemonname-safeshut.service
tempmonscript=/storage/user/bin/pmwFanControl.py
shutdaemonscript=/storage/.config/$daemonname-safeshut.service
deskpidaemon=/storage/.config/system.d/$daemonname.service

# daemonname="deskpi"
# powerbuttonscript=/storage/.config/$daemonname.py
# shutdownscript="/storage/.config/"$daemonname"-poweroff.py"
# daemonconfigfile=/storage/$daemonname.conf
# configscript=/storage/deskpi-config
# removescript=/storage/deskpi-uninstall
# daemonfanservice=/storage/.config/system.d/$daemonname.service

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

####Start Deskpi Install####
# Check and enable otg_mode
PIINFO=$(cat /flash/config.txt | grep 'CONFIG_USB_DWC2=y,dtoverlay=dwc2,dr_mode=host')
if [ -z "$PIINFO" ]
then
	mount -o remount,rw /flash
	echo "CONFIG_USB_DWC2=y,dtoverlay=dwc2,dr_mode=host" >> /flash/config.txt
	mount -o remount,ro /flash
fi

#Install config files.
cp -rf $installationfolder/deskpi-config /storage/user/bin/
cp -rf $installationfolder/Deskpi-uninstall /storage/user/bin/
chmod 755 /storage/user/bin/deskpi-config
chmod 755 /storage/user/bin/Deskpi-uninstall

# Install "C" PWM fan control daemon.
log_action_msg "DeskPi main control service loaded."
cd $installationfolder/drivers/c/ 
cp -rf $installationfolder/drivers/pwmFanControl /storage/user/bin/
cp -rf $installationfolder/drivers/fanStop  /storage/user/bin/
chmod 755 /storage/user/bin/pwmFanControl
chmod 755 /storage/user/bin/fanStop

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
reboot
