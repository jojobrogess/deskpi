import serial
import time
import subprocess

ser=serial.Serial("/dev/ttyUSB0", 9600, timeout=30)

try: 
    while True:
        if ser.isOpen():
            cpu_temp=subprocess.getoutput('vcgencmd measure_temp|awk -F\'=\' \'{print $2\'}')
            cpu_temp=int(cpu_temp.split('.')[0])

            if cpu_temp < 35:
                ser.write(b'pwm_000')
            elif cpu_temp > 35 and cpu_temp < 40:
                ser.write(b'pwm_065')
            elif cpu_temp > 40 and cpu_temp < 45:
                ser.write(b'pwm_075')
            elif cpu_temp > 45 and cpu_temp < 50:
                ser.write(b'pwm_085')
            elif cpu_temp > 50:
                ser.write(b'pwm_100')

except KeyboardInterrupt:
    ser.write(b'pwm_000')
    ser.close()
