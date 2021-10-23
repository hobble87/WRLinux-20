# WRLinux-20
This repo if for adding RPI support to WRLinux 20 

For this project i used a raspberry pi 3 and intention was to use as an AP combined with BTLogin Script
to use on board wifi to connect to BTOpenzone hotspot and the use iptables to MASQUERADE 

--------------         -----------------     ---------------         ---------------------------------------
| BTOpenzone  |  --->  | wlan0 (RPI)   |     | wlan1 (usb) |      <--| tv, phone, laptop, ETC              |
| Hotspot     |        -----------------     ---------------         ---------------------------------------
--------------         


i wanted to achive this by using systemd-networkd 
so packages ifupdown, dhcpcd, dhcpcd5, isc-dhcp-client, isc-dhcp-common, rsyslog was removed 


i have also decided to use u-boot for my image as looking into a OTA update 
## Usage

please also make sure you have added meta-raspberrypi to bblayers (google will identify repo)
this is build for using ubuntu 20.04

add this folder your bblayers
add the required .bb to your local.conf (will be doing templates later)

now you can run 

    bitbake wrlinux-image-std


TODO:
    use templates for build 
    tidy repo
    rewrite BTLogin to suit systemd way (atm keeps sending login)
