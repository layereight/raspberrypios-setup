# raspberrypios-setup

* prepare a Raspberry Pi OS image for a headless installation based on the original downloaded zipped image file 
* currently, the script does 3 things:
  * enable ssh for first boot (https://layereight.de/raspberry-pi/2017/02/28/ssh-headless-Raspberry-Pi.html)
  * precreate user for unattended setups (https://www.raspberrypi.com/news/raspberry-pi-bullseye-update-april-2022/)
  * change the hostname
* requires `sudo` permissions in order to mount an image partition in a loop device 

## Prerequisites

* installed software:
  * xz
  * fdisk
  * openssl

## Usage

```shell
raspberrypios-setup.sh <ZIPPED_RASPBERRYPIOS_IMAGE> <HOSTNAME> <USER> <PASSWORD>
```
```shell
# typical run

$ ~/bin/raspberrypios-setup.sh /data/software/raspberrypios/2022-09-22-raspios-bullseye-arm64-lite.img.xz homecenter pi raspberry
Zipped image: /data/software/raspberrypios/2022-09-22-raspios-bullseye-arm64-lite.img.xz
Working directory: /data/software/raspberrypios
Unzipping...
/data/software/raspberrypios/2022-09-22-raspios-bullseye-arm64-lite.img.xz (1/1)
  100 %     338.0 MiB / 1,788.0 MiB = 0.189    78 MiB/s       0:23             
Unzipped image file: /data/software/raspberrypios/2022-09-22-raspios-bullseye-arm64-lite.img
Image sector size: 512 bytes
Boot partition start at: 4194304 bytes
Root partition start at: 272629760 bytes
Temp image mounting directory: /tmp/tmp.qHXkAR9fLF
[sudo] password for user: 
Create /ssh in boot partition
Create /userconf in boot partition
pi:$6$KQ7rR/70lFxiM.tw$BYXIWBQlf6roie29WnvsIGR0VJ9y6dvRiG44lGFDBvkUvcVliQ2XOPChdtTd.4jO6XZm4iD.rB6TwCeY5GRSP.

Contents of /etc/hostname in root partition:
homecenter

Contents of /etc/hosts in root partition:
127.0.0.1	localhost
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters

127.0.1.1		homecenter

DONE. Your prepared image file is in /data/software/raspberrypios/2022-09-22-raspios-bullseye-arm64-lite.img
```

## Copy the resulting image

* in a separate step
```shell
#
# typical target devices (use lsblk to find out)
# /dev/mmcblk0 for sdcard reader
# /dev/sdX for USB sticks
#
sudo dd if=/data/software/raspberrypios/2022-09-22-raspios-bullseye-arm64-lite.img of=/dev/mmcblk0 status=progress
```
