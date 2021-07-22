# WRLinux-20
WRLinux-20 build hardknott
rpi3b folder is the BSP copied base from https://github.com/rdanter/wrl-rpi-bsp 
updated kernel to use linux-raspberrypi_5.10

**this script will download all repos for all types of processor they support **
i have the intention to use the template schema for each different hardware i will use 

i.e a temple for rpi 3 b+
			  imx6
			  imx8
			  rpi 4

project will build but remains untested at this moment 
i will keep this up to date as much as i can 


## Usage
this is build for using ubuntu 20.04
please check script before running this is set for my personal builds
run command

    . ./setup_env.sh

the go to folder WRLinux
open terminal

    . ./environment-setup-x86_64-wrlinuxsdk-linux
    . ./oe-init-build-env

edit bblayers.conf to add WRLinux-20/rpi3b/wrl-rpi-bsp
add lines to local.conf 

> MACHINE = "rpi3-64"
> PREFERRED_PROVIDER_virtual/kernel = "linux-raspberrypi"
> PNWHITELIST_raspberrypi += 'pi-bluetooth'
> PNWHITELIST_raspberrypi += 'udev-rules-rpi'
> BB_NO_NETWORK = '0'

these settings will eventually be all set in the provided setup script

now you can run 

    bitbake wrlinux-image-std




