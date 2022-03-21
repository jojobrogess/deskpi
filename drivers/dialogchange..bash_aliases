# Config Script
#!/bin/bash' >> $configscript
echo 'daemonconfigfile='$daemonconfigfile >> $configscript
echo "--------------------------------------" >> $configscript
echo "Fan Speed Configuration Tool" >> $configscript
echo "--------------------------------------" >> $configscript
echo "WARNING: This will remove existing configuration." >> $configscript
echo '-n "Press Y to continue:"' >> $configscript
echo 'read -n 1 confirm' >> $configscript
echo '' >> $configscript
echo 'if [ "$confirm" = "y" ]' >> $configscript
echo 'then' >> $configscript
echo '	confirm="Y"' >> $configscript
echo 'fi' >> $configscript
echo '' >> $configscript
echo 'if [ "$confirm" != "Y" ]' >> $configscript
echo 'then' >> $configscript
echo 'echo "Cancelled"' >> $configscript
echo '	exit' >> $configscript
echo 'fi' >> $configscript
echo 'echo "Thank you."' >> $configscript

echo '-n "Press Y if you want the fan to be always on:"' >> $configscript
echo 'read -n 1 confirm' >> $configscript
echo '' >> $configscript
echo 'if [ "$confirm" = "y" ]' >> $configscript
echo 'then' >> $configscript
echo '	confirm="Y"' >> $configscript
echo 'fi' >> $configscript
echo '' >> $configscript
echo 'echo "#" > $daemonconfigfile' >> $configscript
echo 'echo "# Argon One Fan Speed Configuration" >> $daemonconfigfile' >> $configscript
echo 'echo "#" >> $daemonconfigfile' >> $configscript
echo 'echo "# Min Temp=Fan Speed" >> $daemonconfigfile' >> $configscript

echo 'if [ "$confirm" != "Y" ]' >> $configscript
echo 'then' >> $configscript
echo 90"="100 >> $daemonconfigfile
echo '	echo "Fan off."' >> $configscript
echo 'else' >> $configscript
echo '	echo 1"="100 >> $daemonconfigfile' >> $configscript
echo '	echo "Fan always on."' >>
echo 'fi' >> $configscript
echo 'systemctl restart '$daemonname'.service' >> $configscript'