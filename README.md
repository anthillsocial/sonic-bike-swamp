SONIC BIKE SETUP
===================
A Bricrophonic Research Institute (BRI) Project: www.sonicbikes.net

Find further information on building sonic bike here:
http://wiki.sonicbikes.net/index.php?title=Hardware

##The Hardware
- Beagle Bone Black.
- Beaglebone audio cape.
- G-Star IV USB GPS Dongle.
- USB hub.

##Setting up the beaglebone
The software is currently working within the following environment:<br />

    $ lsb_release -a
    No LSB modules are available. 
    Distributor ID:	Debian 
    Description:	Debian GNU/Linux 7.4 (wheezy) 
    Release:	7.4 
    Codename: wheezy

    $ uname -a   
    Linux beaglebone 3.8.13-bone47 #1 SMP Fri Apr 11 01:36:09 UTC 2014 armv7l GNU/Linux

Setup a user called sonic and add to the sudo group: <br />
 
    $ adduser sonic
    $ group usermod -a -G sudo sonic

## Setup the GPS dongle
Plugin the GPS dongle and and see if the BBB can see it, you see an output that includes "Prolific Technology":

    $ lsusb
    Bus 001 Device 004: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port


Assuming it gets installed at /dev/ttyUSB0 you should see output from:

    $ stty -F /dev/ttyUSB0 ispeed 4800 && cat < /dev/ttyUSB0

## Installing the audio Cape
These instructions can found at: <http://elinux.org/BBB_Audio_Cape_RevB_Getting_Started>
its worth reading the sections on alsamixer controls.
To install:

    $ wget <http://elinux.org/images/1/10/BB-BONE-AUDI-02-00A0.zip>
    $ unzip BB-BONE-AUDI-02-00A0.zip	
    $ dtc -O dtb -o BB-BONE-AUDI-02-00A0.dtbo -b 0 -@ BB-BONE-AUDI-02-00A0.dts
    $ mv BB-BONE-AUDI-02-00A0.dtbo /lib/firmware

Add the following line to the end of the "/boot/uboot/uEnv.txt" file: 

    optargs=capemgr.disable_partno=BB-BONELT-HDMI

Reboot your BBB. Log in and check the cape manager:

    $ reboot
    $ cat /sys/devices/bone_capemgr*/slots

Load the cape:

    $ echo BB-BONE-AUDI-02 > /sys/devices/bone_capemgr*/slots

To make the cape load every time add the following line to "/etc/default/capemgr":

    CAPE=BB-BONE-AUDI-02
 
Then download some settings:

    $ wget <https://raw.githubusercontent.com/CircuitCo/BeagleBone-Audio/files/asound.state>
    $ mv asound.state /var/lib/alsa/asound.state 

Finally plug headphones into the green connector and play a file:

    $ aplay atestfile.wav

## Setup the code:
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

And add a .config file:

    $ cp ../config/swamp_example.conf ../config/swamp.conf

## Installing proAudioRt (proteaAudioRt)
The version available from <http://viremo.eludi.net/proteaAudio/proteaAud[[http://viremo.eludi.net/proteaAudio/proteaAudi|i]][[http://viremo.eludi.net/proteaAudio/proteaAudio|o]]> has a few mistakes so a corrected version needs to be downloaded:

    $ cd ~
    $ wget <https://www.dropbox.com/s/s1qa7bqdh613g1i/proteaAudio_src_140921.tar.gz?dl=0> --no-

Uncompress the downloaded file with:

    $ tar -xavf proteaAudio_src_140921.tar.gz\?dl\=0

And Install some prerequisites:

    $ apt-get install librtaudio4 liblua5.1-0-dev

Then copy the proAudioRt.so to the ~/sonic-bike/src/:
    
    $cp proAudioRt.so ~/sonic-bike/src/

## Set date and time

    $ date --set 2014-08-24
    $ date --set 14:21:39
    $ hwclock --systohc --utc

# Configure unwanted services and setup auto-start
Disable unwanted services
    
    $ systemctl disable cloud9.service
    $ systemctl disable cloud9.socket
    $ systemctl disable bonescript.service
    $ systemctl disable bonescript.socket
    $ systemctl disable bonescript-autorun.service
    $ systemctl disable gdm.service # graphical login
    $ systemctl disable mpd.service # music player daemon
    $ update-rc.d lightdm disable
    $ apt-get remove apache2*

Create a sonic-bike service
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

To start/stop the service at anytime####

    $ systemctl start sonic-bike.service
    $ systemctl stop sonic-bike.service

## Some usefull links
<https://gitorious.org/swamp-bikeopera>
<http://sonicmapper.borrowed-scenery.com/>
<https://bitbucket.org/jyros/sonic-bike/>
<https://www.dropbox.com/s/ig4knawe4w7b6hr/beaglebone-notes.md?dl=0>
<https://www.dropbox.com/s/s1qa7bqdh613g1i/proteaAudio_src_140921.tar.gz?dl=0>
<https://www.dropbox.com/s/jvorzygy318s1bq/ProteaAudio_Lua_binding.md?dl=0>

License
------------------
Swamp Bike Opera embedded system for Kaffe Matthews <br>
Copyright (C) 2012 Wolfgang Hauptfleisch, Dave Griffiths<br>
Later additions made by Tom Keene & Jairo Sanchez<br>

This program is free software: you can redistribute it and/or modify<br>
it under the terms of the GNU General Public License as published by<br>
the Free Software Foundation, either version 3 of the License, or<br>
(at your option) any later version.<br>

This program is distributed in the hope that it will be useful,<br>
but WITHOUT ANY WARRANTY; without even the implied warranty of<br>
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the<br>
GNU General Public License for more details.<br>

You should have received a copy of the GNU General Public License<br>
along with this program.  If not, see <http://www.gnu.org/licenses/>.
