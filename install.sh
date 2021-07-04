#!/bin/bash
# 
daemonname="deskpi"
tempmonscript=/storage/bin/pmwFanControl
deskpidaemon=/storage/.config/system.d/$daemonname.service
safeshutdaemon=/storage/.config/system.d/$daemonname-safeshut.service
installationfolder=$HOME/$daemonname

# install wiringPi library.
log_action_msg "DeskPi Fan control script installation Start." 

# Create service file on system.
if [ -e $deskpidaemon ]; then
	rm -f $deskpidaemon
fi

PIINFO=$(cat /flash/config.txt | grep 'otg_mode=1')
if [ -z "$PIINFO" ]
then
	mount -o remount,rw /flash
	echo "otg_mode=1" >> /flash/config.txt
	mount -o remount,ro /flash
fi
# install PWM fan control daemon.
log_action_msg "DeskPi main control service loaded."
cd $installationfolder/drivers/c/ 
cp -rf $installationfolder/drivers/c/pwmFanControl /storage/bin/
cp -rf $installationfolder/drivers/c/fanStop  /storage/bin/
chmod 755 /storage/bin/pwmFanControl
chmod 755 /storage/bin/fanStop
cp -rf $installationfolder/deskpi-config /storage/bin/
cp -rf $installationfolder/Deskpi-uninstall /storage/bin/
chmod 755 /storage/bin/deskpi-config
chmod 755 /storage/bin/Deskpi-uninstall

# Build Fan Daemon
echo "[Unit]" > $deskpidaemon
echo "Description=DeskPi PWM Control Fan Service" >> $deskpidaemon
echo "After=multi-user.target" >> $deskpidaemon
echo "[Service]" >> $deskpidaemon
echo "Type=simple" >> $deskpidaemon
echo "RemainAfterExit=no" >> $deskpidaemon
echo "ExecStart=/storage/bin/pwmFanControl" >> $deskpidaemon
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
echo "ExecStart=/storage/bin/fanStop" >> $safeshutdaemon
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
