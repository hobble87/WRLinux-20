#!/bin/bash 
DEVICE=""

#################################################################
#### EDIT THESE TO YOUR LOGIN DETAILS                        ####
#################################################################
Uname=""
Password=""
##################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# indentify wireless device 
IDENTIFY () {
    DEVICE="$(iw dev | awk '$1=="Interface"{print $2}')"
	echo "[$GREEN OK $NC] Wireless device is $DEVICE"
}

# look for a bt network
SCAN_FOR_BT () {
	SCAN=$(sudo iw dev $DEVICE scan | grep -i BTWi-fi | head -n 1 | cut -d ":" -f2 )
	if [ "$SCAN" != " BTWi-fi" ]; then
		echo "No BT Network Found"
		echo "No Point To Continue"
	else 
		echo "[$GREEN OK $NC] Network Found $SCAN"
	fi
}

CONNECT_TO_AP () {
    CONNECTEDESSID=$(iwgetid -r)
    if [ $CONNECTEDESSID = "BTWi-fi" ]; then
        echo "[$GREEN OK $NC] Already Connected to AP"
    else
        echo "Connecting to AP"
        sudo iwconfig $DEVICE essid BTWi-fi
    fi
}

# this needs to be updated for a loop
CHECKING_IP () {
    IPADDRESS="$(ifconfig $DEVICE | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')"
    if [ -z "$IPADDRESS" ]; then
	echo "Running Dhcp"
	sudo dhcpcd wlan0
    else
	echo "[$GREEN OK $NC] ip address = $IPADDRESS"
    fi
}

TEST_CONNECTION () {
	ping 8.8.8.8 -c 1 2>&1 >/dev/null
	if [ $? != 0 ];then
		echo "Ping Failed"
		CONNECT_TO_INTERNET
	else 
		echo "[$GREEN OK $NC] Ping 8.8.8.8 Sucessful"
	fi 
}

CONNECT_TO_INTERNET () {
	Login=$(wget -qO - --no-check-certificate --no-cache --post-data "username=$Uname&password=$Password&provider=tbb" "https://www.btwifi.com:8443/tbbLogon")
	ONLINE=$(echo $Login | grep "now logged on" )
 		if [ "$ONLINE" ]; then
    			echo "[$GREEN OK $NC] Your Online !"
   			exit 0
   		else
   			echo "Could not login"
   			exit 1
   		fi
}

# need to add loop checking connection to reconnect or to send keep alive 
# either way these are not features i require

IDENTIFY
SCAN_FOR_BT
CONNECT_TO_AP
CHECKING_IP
TEST_CONNECTION
CONNECT_TO_INTERNET
