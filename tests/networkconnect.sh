# When connected via USB run this script in order to
# grab a shared internet connection (could/should automate)
/sbin/route add default gw 192.168.7.1
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
# Create come enviromental variables to enable cross compiling using distcc
export DISTCC_HOSTS=192.168.7.1/4
export DISTCC_BACKOFF_PERIOD=0
export DISTCC_IO_TIMEOUT=3000
export DISTCC_SKIP_LOCAL_RETRY=1
export CC=/usr/local/bin/gcc
 
