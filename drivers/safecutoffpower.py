import serial
import time 

ser=serial.Serial("/dev/ttyUSB0", 9600, timeout=30)

try: 
    while True:
        if ser.isOpen():
            ser.write(b'power_off')
            ser.close()

except KeyboardInterrupt:
    ser.write(b'power_off')
    ser.close()
    