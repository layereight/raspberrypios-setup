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

$ ~/bin/raspberrypios-setup.sh /data/software/raspberrypios/2025-12-04-raspios-trixie-armhf-lite.img.xz homecenter pi raspberry 
Zipped image: /data/software/raspberrypios/2025-12-04-raspios-trixie-armhf-lite.img.xz
Working directory: /data/software/raspberrypios
Unzipping...
/data/software/raspberrypios/2025-12-04-raspios-trixie-armhf-lite.img.xz (1/1)
  100 %     497.0 MiB / 2,568.0 MiB = 0.194   408 MiB/s       0:06             
Unzipped image file: /data/software/raspberrypios/2025-12-04-raspios-trixie-armhf-lite.img
Image sector size: 512 bytes
Boot partition start at: 8388608 bytes
Root partition start at: 545259520 bytes
Temp image mounting directory: /tmp/tmp.GlFKMt2VoT
[sudo] password for user: 
Create /ssh in boot partition
Create /userconf in boot partition
pi:$6$jNO9r.GzBAHHEVy.$SBEZqc6.n80TBCeED1uRFOaGNxPtKGTPXPqPWgc5GQpHDRi37IpZfiMdxIaJI0f7xHeBy7BFbRctRwfc1HPkz1

Contents of /etc/hostname in root partition:
homecenter

Contents of /etc/hosts in root partition:
127.0.0.1	localhost
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters

127.0.1.1		homecenter

DONE. Your prepared image file is in /data/software/raspberrypios/2025-12-04-raspios-trixie-armhf-lite.img
```

## Copy the resulting image

* in a separate step
```shell
#
# typical target devices (use lsblk to find out)
# /dev/mmcblk0 for sdcard reader
# /dev/sdX for USB sticks
#
sudo dd if=/data/software/raspberrypios/2025-12-04-raspios-trixie-armhf-lite.img of=/dev/mmcblk0 status=progress
```
