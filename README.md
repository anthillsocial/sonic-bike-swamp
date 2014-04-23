SONIC BIKE SETUP
===================


#### Setting up the beaglebone
**The software is currently working within this environment:**
The OS: $ lsb_release -a
No LSB modules are available.
Distributor ID:	Debian
Description:	Debian GNU/Linux 7.4 (wheezy)
Release:	7.4
Codename:wheezy
Linux version: $ uname -a
Linux beaglebone 3.8.13-bone47 #1 SMP Fri Apr 11 01:36:09 UTC 2014 armv7l GNU/Linux
**Setup a user called sonic**
Add user: $ adduser sonic
Add to the sudo goup: $ group usermod -a -G sudo sonic

#### Setup the GPS dongle
Plugin the GPS dongle and and see if the BBB can see it:
$ lsusb
You should see an output that includes something like:
 Bus 001 Device 004: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
Where Prolific Technology is the GPS device.
Assuming it gets installed at /dev/ttyUSB0 you should see output from:
$ stty -F /dev/ttyUSB0 ispeed 4800 && cat < /dev/ttyUSB0

#### Installing the audio Cape
Instruction found at: <http://elinux.org/BBB_Audio_Cape_RevB_Getting_Started>
Its particularly worth reading the sections on alsamixer controls.
To install:
$ wget <http://elinux.org/images/1/10/BB-BONE-AUDI-02-00A0.zip>
$ unzip BB-BONE-AUDI-02-00A0.zip
	
$ dtc -O dtb -o BB-BONE-AUDI-02-00A0.dtbo -b 0 -@ BB-BONE-AUDI-02-00A0.dts
$ mv BB-BONE-AUDI-02-00A0.dtbo /lib/firmware
# Add the following line to the end of the "/boot/uboot/uEnv.txt" file: 
optargs=capemgr.disable_partno=BB-BONELT-HDMI
# Reboot your BBB. Log in and check the capemgr:
$ reboot
cat /sys/devices/bone_capemgr*/slots
# Load the cape
$ echo BB-BONE-AUDI-02 > /sys/devices/bone_capemgr*/slots
# To make it load every time add the following line to "/etc/default/capemgr":
CAPE=BB-BONE-AUDI-02
wget <https://raw.githubusercontent.com/CircuitCo/BeagleBone-Audio/files/asound.state>
mv asound.state /var/lib/alsa/asound.state 
# Plug headphones into the green connector and play a file:
aplay sample.wav

#### Setup the code:
First install all prerequisites:
$ apt-get install git git-core lua5.1 lua-posix lua-socket
Then login as sonic and navigate to sonics home directory:
$ su sonic
$ cd ~
Now clone the latest versions of the software:
$ git clone <https://bitbucket.org/jyros/sonic-bike.git>
And some example sounds and maps:
$ cd sonic-bike
$ git clone <https://gitorious.org/swamp-bikeopera/maps.git>
$ git clone <https://gitorious.org/swamp-bikeopera/sound.git>
Check sounds are playing:
$ aplay sound/1.ogg
Add a .config file:
$ cp ../config/swamp_example.conf ../config/swamp.conf

#### Installing proAudioRt (proteaAudioRt)
The version available from <http://viremo.eludi.net/proteaAudio/proteaAud[[http://viremo.eludi.net/proteaAudio/proteaAudi|i]][[http://viremo.eludi.net/proteaAudio/proteaAudio|o]]> has a few mistakes so a corrected version needs to be downloaded:
$ cd ~
$ wget <https://www.dropbox.com/s/s1qa7bqdh613g1i/proteaAudio_src_140921.tar.gz?dl=0> --no-check
Uncompress the downloaded file with:
$ tar -xavf proteaAudio_src_140921.tar.gz\?dl\=0
Install some prerequisites:
$ apt-get install librtaudio4 liblua5.1-0-dev
Then copy the proAudioRt.so to the ~/sonic-bike/src/:
 cp proAudioRt.so ~/sonic-bike/src/


#### Set date and time
$ date --set 2014-08-24
$ date --set 14:21:39
$ hwclock --systohc --utc

#### Disable unwanted services
$ systemctl disable cloud9.service
$ systemctl disable cloud9.socket
$ systemctl disable bonescript.service
$ systemctl disable bonescript.socket
$ systemctl disable bonescript-autorun.service
$ systemctl disable gdm.service # graphical login
$ systemctl disable mpd.service # music player daemon
$ update-rc.d lightdm disable
$ apt-get remove apache2*

#### Create a sonic-bike service
Create the file /etc/systemd/system/sonic-bike.service with the following content:
[Unit]
Description=Sonic Bike
[Service]
ExecStart=/root/sonic-bike/code/src/swamp
ExecStop=/root/sonic-bike/code/src/stop

[Install]
WantedBy=multi-user.target
Then enable and start the service so it automatically starts on boot:
$ systemctl enable sonic-bike.service

####To start/stop the service at anytime####
$ systemctl start sonic-bike.service
$ systemctl stop


##### Some usefull links
<https://gitorious.org/swamp-bikeopera>
<http://sonicmapper.borrowed-scenery.com/>
<https://bitbucket.org/jyros/sonic-bike/>
<https://www.dropbox.com/s/ig4knawe4w7b6hr/beaglebone-notes.md?dl=0>
<https://www.dropbox.com/s/s1qa7bqdh613g1i/proteaAudio_src_140921.tar.gz?dl=0>
<https://www.dropbox.com/s/jvorzygy318s1bq/ProteaAudio_Lua_binding.md?dl=0>


