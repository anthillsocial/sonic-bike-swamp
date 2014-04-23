#!python
# A quick test to see if the GPS dongle is working
# Check to see if the red LED (by the USB cord) is flashing  
import gps, os, time
session = gps.gps(host="localhost", port="3000")
session.read()
session.stream()
while 1:
    os.system("clear")
    session.read()
    # a = altitude, d = date/time, m=mode,
    # o=postion/fix, s=status, y=satellites
    print
    print "GPS reading"
    print "---------------------"
    print "latitude " , session.fix.latitude
    print "longitude " , session.fix.longitude
    print "time GPS " ,  session.fix.time
    print 'time ticks' , time.time()
    print 'time GMT ' , time.gmtime()
    print "Satellites (total of", len(session.satellites) , " in view)"
    time.sleep(1)
    for i in session.satellites:
        print "t", i
        time.sleep(10)
