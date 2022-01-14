# raspberrypios-setup

* prepare a Raspberry Pi OS image for a headless installation based on the original downloaded zipped image file 
* currently, the script does 2 things:
  * enable ssh for first boot (https://layereight.de/raspberry-pi/2017/02/28/ssh-headless-Raspberry-Pi.html)
  * change the hostname
* requires `sudo` permissions in order to mount an image partition in a loop device 

## usage

```shell
raspberrypios-setup.sh <ZIPPED_RASPBERRYPIOS_IMAGE> <HOSTNAME>
```
```shell
# typical run

$ ~/bin/raspberrypios-setup.sh /data/software/raspberrypios/2021-10-30-raspios-bullseye-armhf-lite.zip homepi2

Zipped image: /data/software/raspberrypios/2021-10-30-raspios-bullseye-armhf-lite.zip
Working directory: /data/software/raspberrypios
Unzipping...
Unzipped image file: /data/software/raspberrypios/2021-10-30-raspios-bullseye-armhf-lite.img
Image sector size: 512 bytes
Boot partition start at: 4194304 bytes
Root partition start at: 272629760 bytes
Temp image mounting directory: /tmp/tmp.nylmNVMNDa
Create /ssh in boot partition

Contents of /etc/hostname in root partition:
homepi2

Contents of /etc/hosts in root partition:
127.0.0.1	localhost
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters

127.0.1.1		homepi2

DONE. Your prepared image file is in /data/software/raspberrypios/2021-10-30-raspios-bullseye-armhf-lite.img
```

## copy image

* in a separate step
```shell
#
# typical target devices (use lsblk to find out)
# /dev/mmcblk0 for sdcard reader
# /dev/sdX for USB sticks
#
sudo dd if=/data/software/raspberrypios/2021-10-30-raspios-bullseye-armhf-lite.img of=/dev/mmcblk0 status=progress
```