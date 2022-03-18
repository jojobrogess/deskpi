#!/bin/bash
####init library should be installed first prior to anything####
################################################################
daemonname="deskpi"
userlibrary=/storage/user/
################################################################

deskpi_create_file() {
	if [ -f $1 ]; then
        rm $1
    fi
	touch $1
	chmod 666 $1
}

############################
#### Create User Lib/Bin Directory
############################

if [ ! -d "/storage/user" ] ; then
	mkdir -p $userlibrary
	mkdir -p $userlibrary/lib
	mkdir -p $userlibrary/bin
fi

################################################################
################## Install Daemon and Service ##################
################################################################

daemonname="deskpi"
daemonconfig=/storage/user/bin/$daemonname-config
shutdaemonservice=/storage/.config/$daemonname-safeshut.service
daemonfanservice=/storage/.config/system.d/$daemonname.service
button=/storage/user/bin/$daemonname-safepower.py
pwmdriver=/storage/user/bin/$daemonname-FanControl.py
uninstall=/storage/user/bin/$daemonname-uninstall

################################################################

echo "DeskPi Fan control script installation Start." 
###Check for Previous install####


############################
######Check Boot Mode######
############################

echo "Check Boot Mode"

PIINFO=$(cat /flash/config.txt | grep 'otg_mode=1,dtoverlay=dwc2,dr_mode=host')
if [ -z "$PIINFO" ]
then
	mount -o remount,rw /flash
	echo "otg_mode=1,dtoverlay=dwc2,dr_mode=host" >> /flash/config.txt
	mount -o remount,ro /flash
fi

echo "Successfully Checked and Created the Boot Mode"

############################
####Create deskpi-config####
############################

echo "Create deskpi-config"

deskpi_create_file $daemonconfig

echo '#!/bin/bash' >> $daemonconfig
echo '# This is a fan speed control utility tool for user to customize fan speed.' >> $daemonconfig
echo '# Priciple: send speed argument to the MCU' >> $daemonconfig
echo '# Technical Part' >> $daemonconfig
echo '# There are four arguments:' >> $daemonconfig
echo '# pwm_025 means sending 25% PWM signal to MCU. The fan will run at 25% speed level.' >> $daemonconfig
echo '# pwm_050 means sending 50% PWM signal to MCU. The fan will run at 50% speed level.' >> $daemonconfig
echo '# pwm_075 means sending 75% PWM signal to MCU. The fan will run at 75% speed level.' >> $daemonconfig
echo '# pwm_100 means sending 100% PWM signal to MCU.The fan will run at 100% speed level.' >> $daemonconfig
echo '#' >> $daemonconfig
echo '# This is the serial port that connect to deskPi mainboard and it will' >> $daemonconfig
echo '# communicate with Raspberry Pi and get the signal for fan speed adjusting.' >> $daemonconfig
echo '#. /storage/user/lib/lsb/init-functions' >> $daemonconfig
echo 'sys=/storage/.kodi/addons/virtual.rpi.tools/lib' >> $daemonconfig
echo 'serial=/storage/.kodi/addons/script.module.pyserial/lib/' >> $daemonconfig
echo 'serial_port=/dev/ttyUSB0' >> $daemonconfig
echo '' >> $daemonconfig
echo '# Stop deskpi.service so that user can define the speed level.' >> $daemonconfig
echo 'systemctl stop deskpi.service' >> $daemonconfig
echo '' >> $daemonconfig
echo '# Define the function of set_config' >> $daemonconfig
echo 'function set_config() {' >> $daemonconfig
echo '	if [ -e /storage/user/bin/deskpi.conf ]; then' >> $daemonconfig
echo '		sh -c "rm -f /storage/user/bin/deskpi.conf"' >> $daemonconfig
echo '	fi' >> $daemonconfig
echo '	touch /storage/user/bin/deskpi.conf' >> $daemonconfig
echo '	chmod 777 /storage/user/bin/deskpi.conf' >> $daemonconfig
echo '	echo "Under normal circumstances, we recommend four gears. The' >> $daemonconfig
echo '	following requires you to control the fans operating status according to' >> $daemonconfig
echo '	the temperature and speed defined by yourself, and you need to input 4' >> $daemonconfig
echo '	different temperature thresholds (for example: 42, 50, 60, 70) , And 4 PWM' >> $daemonconfig
echo '	values of different speeds parameters(for example 25, 50, 75, 100, this is the default' >> $daemonconfig
echo '	value),you can define the speed level during 0-100."' >> $daemonconfig
echo '	for i in `seq 1 4`;' >> $daemonconfig
echo '	do' >> $daemonconfig
echo '	echo -e "\e[32;40mCurrent CPU Temperature:\e[0m \e[31;40m`vcgencmd measure_temp`\e[0m\n"' >> $daemonconfig
echo '	read -p  "Temperature_threshold_$i:" temp' >> $daemonconfig
echo '        read -p  "Fan_Speed level_$i:" fan_speed_level' >> $daemonconfig
echo '	sh -c "echo $temp" >> /storage/user/bin/deskpi.conf' >> $daemonconfig
echo '	sh -c "echo $fan_speed_level" >> /storage/user/bin/deskpi.conf' >> $daemonconfig
echo '	done ' >> $daemonconfig
echo '	echo "Configuration file has been created on /storage/user/bin/deskpi.conf"' >> $daemonconfig
echo '}' >> $daemonconfig
echo '' >> $daemonconfig
echo '# Greetings and information for user.' >> $daemonconfig
echo 'echo "Welcome to Use DeskPi-Teams Product"' >> $daemonconfig
echo 'echo "Please select speed level that you want: "' >> $daemonconfig
echo 'echo "It will always run at the speed level that you choosed."' >> $daemonconfig
echo 'echo "---------------------------------------------------------------"' >> $daemonconfig
echo 'echo "1 - set fan speed level to 25%"' >> $daemonconfig
echo 'echo "2 - set fan speed level to 50%"' >> $daemonconfig
echo 'echo "3 - set fan speed level to 75%"' >> $daemonconfig
echo 'echo "4 - set fan speed level to 100%"' >> $daemonconfig
echo 'echo "5 - Turn off Fan"' >> $daemonconfig
echo 'echo "6 - Adjust the start speed level according to the temperature"' >> $daemonconfig
echo 'echo "7 - Cancel manual control and enable automatical fan control"' >> $daemonconfig
echo 'echo "---------------------------------------------------------------"' >> $daemonconfig
echo 'echo "Just input the number and press enter."' >> $daemonconfig
echo 'read -p "Your choice:" levelNumber' >> $daemonconfig
echo 'case $levelNumber in' >> $daemonconfig
echo '	1) ' >> $daemonconfig
echo '	   echo "Youve select 25% speed level"' >> $daemonconfig
echo '	   sh -c "echo pwm_025 > $serial_port"' >> $daemonconfig
echo '	   echo "Fan speed level has been change to 25%"' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	2) ' >> $daemonconfig
echo '	   echo "Youve select 50% speed level"' >> $daemonconfig
echo '	   sh -c "echo pwm_050 > $serial_port"' >> $daemonconfig
echo '	   echo "Fan speed level has been change to 50%"' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	3) ' >> $daemonconfig
echo '	   echo "Youve select 75% speed level"' >> $daemonconfig
echo '	   sh -c "echo pwm_075 > $serial_port"' >> $daemonconfig
echo '	   echo "Fan speed level has been change to 75%"' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	4) ' >> $daemonconfig
echo '	   echo "Youve select 100% speed level"' >> $daemonconfig
echo '	   sh -c "echo pwm_100 > $serial_port"' >> $daemonconfig
echo '	   echo "Fan speed level has been change to 100%"' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	5) ' >> $daemonconfig
echo '	   echo "Turn off fan"' >> $daemonconfig
echo '	   sh -c "echo pwm_000 > $serial_port"' >> $daemonconfig
echo '	   echo "Fan speed level has been turned off."' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	6) ' >> $daemonconfig
echo '	   echo "Customizing the start speed level according the temperature"' >> $daemonconfig
echo '	   systemctl stop deskpi.service & ' >> $daemonconfig
echo '	   set_config' >> $daemonconfig
echo '	   systemctl start deskpi.service & ' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	7) ' >> $daemonconfig
echo '	   echo "Cancel manual control and enable automatical fan control"' >> $daemonconfig
echo '	   systemctl start deskpi.service &' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	*) ' >> $daemonconfig
echo '	   echo "You typed the wrong selection, please try again!"' >> $daemonconfig
echo '	   . /storage/user/bin/deskpi-config' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo 'esac' >> $daemonconfig

chmod 755 $daemonconfig

echo "Successfully Created deskpi-config"

############################
##Create Uninstall Script###
############################

echo "Create Uninstall Script"

deskpi_create_file $uninstall

echo '#!/bin/bash' >>$uninstall
echo '# uninstall deskpi script ' >>$uninstall
echo 'daemonname='deskpi'' >>$uninstall
echo 'daemonconfig=/storage/user/bin/deskpi-config' >>$uninstall
echo 'daemonfanservice="/storage/.config/system.d/$daemonname.service"' >>$uninstall
echo '#safeshutdaemon="/storage/.config/system.d/$daemonname-safeshut.service"' >>$uninstall

echo 'echo "Uninstalling DeskPi PWM Fan Control and Safeshut Service."' >>$uninstall
echo 'sleep 1' >>$uninstall
echo 'echo "Remove otg_mode=1 configure from /flash/config.txt file"' >>$uninstall

echo 'PIINFO=$(cat /flash/config.txt | grep 'otg_mode=1')' >>$uninstall
echo 'if [ -n "$PIINFO" ]' >>$uninstall
echo 'then' >>$uninstall
echo '	mount -o remount,rw /flash' >>$uninstall
echo '	    sed -i 'otg_mode=1,dtoverlay=dwc2,dr_mode=host' /flash/config.txt # Probably not a good idea to just delete the last line rather than find and delete.' >>$uninstall
echo '	mount -o remount,ro /flash' >>$uninstall
echo 'echo "fi"' >>$uninstall
echo 'echo "Removed otg_mode=1 configure from /flash/config.txt file"' >>$uninstall

echo 'echo "Diable DeskPi PWM Fan Control and Safeshut Service."' >>$uninstall

echo 'systemctl disable $daemonname.service 2&>/dev/null' >>$uninstall
echo 'systemctl stop $daemonname.service  2&>/dev/null' >>$uninstall
echo '#systemctl disable $daemonname-safeshut.service 2&>/dev/null' >>$uninstall
echo '#systemctl stop $daemonname-safeshut.service 2&>/dev/null' >>$uninstall

echo 'echo "Remove DeskPi PWM Fan Control and Safeshut Service."' >>$uninstall
echo 'rm -f  $daemonfanservice  2&>/dev/null' >>$uninstall
echo '#rm -f  $safeshutdaemon 2&>/dev/null' >>$uninstall
echo '#rm -f /storage/user/bin/fanStop 2&>/dev/null' >>$uninstall
echo 'rm -f /storage/user/bin/pwmFanControl 2&>/dev/null' >>$uninstall
echo 'rm -f /storage/user/bin/deskpi-config 2&>/dev/null' >>$uninstall
echo 'echo "Uninstall DeskPi Driver Successfully."' >>$uninstall

echo 'echo "Remove userfiles"' >>$uninstall
echo 'rm -f $daemonconfig' >>$uninstall
echo 'rm -f /storage/user/bin/deskpi.conf' >>$uninstall
echo 'sleep 5' >>$uninstall
echo 'echo "Going to attempt to kill myself now..."' >>$uninstall
echo 'sleep 2' >>$uninstall
echo 'echo "wish me luck"' >>$uninstall
echo 'sleep 2' >>$uninstall
echo 'echo "?"' >>$uninstall
echo 'rm -- "$0"' >>$uninstall

chmod 755 $uninstall

echo "Successfully Creating Uninstall Script"

############################
####Create Driver Daemon####
############################

echo "Create Fan Driver Daemon"

deskpi_create_file $pwmdriver

echo '# Before you import the library, you need to install pyserial library.' >> $pwmdriver
echo 'import serial' >> $pwmdriver
echo 'import time' >> $pwmdriver
echo 'import subprocess' >> $pwmdriver

echo 'ser=serial.Serial("/dev/ttyUSB0", 9600, timeout=30)' >> $pwmdriver

echo 'try: ' >> $pwmdriver
echo '    while True:' >> $pwmdriver
echo '        if ser.isOpen():' >> $pwmdriver
echo '            cpu_temp=subprocess.getoutput('vcgencmd measure_temp|awk -F\'=\' \'{print $2\'}')' >> $pwmdriver
echo '            cpu_temp=int(cpu_temp.split('.')[0])' >> $pwmdriver

echo '            if cpu_temp < 40:' >> $pwmdriver
echo '                ser.write(b'pwm_000')' >> $pwmdriver
echo '            elif cpu_temp > 40 and cpu_temp < 50:' >> $pwmdriver
echo '                ser.write(b'pwm_025')' >> $pwmdriver
echo '            elif cpu_temp > 50 and cpu_temp < 65:' >> $pwmdriver
echo '                ser.write(b'pwm_050')' >> $pwmdriver
echo '            elif cpu_temp > 65 and cpu_temp < 75:' >> $pwmdriver
echo '                ser.write(b'pwm_075')' >> $pwmdriver
echo '            elif cpu_temp > 75:' >> $pwmdriver
echo '                ser.write(b'pwm_100')' >> $pwmdriver

echo 'except KeyboardInterrupt:' >> $pwmdriver
echo '    ser.write(b'pwm_000')' >> $pwmdriver
echo '    ser.close()' >> $pwmdriver
echo '' >> $pwmdriver

chmod 755 $pwmdriver

echo "Successfully Created Driver Daemon"


############################
#####Build Fan Service######
############################

echo "Building Fan Service"

deskpi_create_file $daemonfanservice

echo '[Unit]' >> $daemonfanservice
echo 'Description=DeskPi PWM Control Fan Service' >> $daemonfanservice
echo 'After=multi-user.target' >> $daemonfanservice
echo '[Service]' >> $daemonfanservice
echo 'Type=simple' >> $daemonfanservice
echo 'RemainAfterExit=no' >> $daemonfanservice
echo 'ExecStart=/storage/user/bin/pwmFanControl' >> $daemonfanservice
echo '[Install]' >> $daemonfanservice
echo 'WantedBy=multi-user.target' >> $daemonfanservice

chmod 644 $daemonfanservice

echo "Successfully Built Fan Service"

############################
###Create Safe ShutService##
############################

echo "Create Safe Shutoff Driver"

deskpi_create_file $pwmdriver

echo 'import serial' >> $button
echo 'import time' >> $button
echo '' >> $button
echo 'ser=serial.Serial("/dev/ttyUSB0", 9600, timeout=30)' >> $button
echo '' >> $button
echo 'try: ' >> $button
echo '    while True:' >> $button
echo '        if ser.isOpen():' >> $button
echo '            ser.write(b'power_off')' >> $button
echo '            ser.close()' >> $button
echo '' >> $button
echo 'except KeyboardInterrupt:' >> $button
echo '    ser.write(b'power_off')' >> $button
echo '    ser.close()' >> $button
echo '    ' >> $button

chmod 755 $button

echo "Successfully Created Safe Shutoff Driver"

############################
#####Build Power Service####
############################

echo "Building Power Daemon"

deskpi_create_file $shutdaemonservice

echo '[Unit]' >> $shutdaemonservice
echo 'Description=DeskPi Safeshutdown Service' >> $shutdaemonservice
echo 'Conflicts=reboot.target' >> $shutdaemonservice
echo 'Before=halt.target shutdown.target poweroff.target' >> $shutdaemonservice
echo 'DefaultDependencies=no' >> $shutdaemonservice
echo '[Service]' >> $shutdaemonservice
echo 'Type=oneshot' >> $shutdaemonservice
echo 'ExecStart=/storage/user/bin/safecutoffpower' >> $shutdaemonservice
echo 'RemainAfterExit=yes' >> $shutdaemonservice
echo 'TimeoutSec=1' >> $shutdaemonservice
echo '[Install]' >> $shutdaemonservice
echo 'WantedBy=halt.target shutdown.target poweroff.target' >> $shutdaemonservice

chmod 644 $daemonfanservice

echo "Successfully Built Power Service"

################################################################
################ Daemon & Service Installation ################
################################################################

echo "DeskPi Service Configuration finished." 
echo "Deskpi Daemon Configuration Successfully finished"

############################
#######Stop Services########
############################

echo "DeskPi Service Load module." 

systemctl daemon-reload
systemctl enable $daemonname.service
systemctl start $daemonname.service &
systemctl enable $daemonname-safeshut.service
systemctl start $daemonname-safeshut.service

echo "Deskpi Service Loaded Modules Correctly"

############################
#########Exit Code##########
############################

echo "DeskPi PWM Fan Control and Safeshut Service installed Successfully." 
echo "System requires rebooting system to take effect."
sleep 5
#echo "System will reboot in 5 seconds to take effect." 
sync
# to be tested later once addon gets working
#(its a self deleting script )
#if [ $needsshutdownedit -gt 0 ]
#then
#	nano $deskpishutdownscript
#fi