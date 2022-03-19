# Download ... to ~/
cd /
cd /storage/
wget https://github.com/pyserial/pyserial/archive/refs/heads/master.zip -O pyserial.zip

# Create a temp dir to do the work in
export tmp_dir=~/install_temp/
mkdir $tmp_dir
cd $tmp_dir

# Extract and install pyserial
unzip ~/pyserial.zip
cd pyserial*
python setup.py install --user

# Clean-up
cd ~/
rm $tmp_dir/ -Rf