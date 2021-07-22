#!/bin/bash
DEPS=("python2" "binutils-multiarch")
DEPSNOT=("")

# !! IMPORTANT !! 
# CHANGE THESE VARIBLES 
INSTALLLOCATION="/media/"$USER"/DATA/wrlinux-x"
BUILDLOCATION="/media/"$USER"/DATA/WRLinux"
#download wrlinux repo

cat <<EOF 

This was Wriiten On Ubuntu 20.04 and using WindRiver linux 10_21

this script will be use for setup a base image for a raspberry pi 3b+ 


EOF

echo "Begin Setup ..."

for d in "${DEPS[@]}"
do
if [ "$( dpkg-query -W --showformat='${Status}\n' "$d" 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
    echo "Adding to Failed List $d"
    DEPSNOT+=("$d")
fi
done
if  [ -n "${DEPSNOT[*]}" ]; then
    echo "installing failed deps"
    sudo apt install "${DEPSNOT[@]}" -y
else
    echo "All Deps Found for 20.04"
fi

# this part of the setup is just for my pc setup 
# this section will need to be changed if script is run on a diffrent system

echo "Checking for Windriver Setup folder"
if [ -d "$INSTALLLOCATION" ]; then
    echo "WRLinux Setup Directory exists"
else
    echo "WRLinux Directory NOT Found"
    echo "WRLinux is Cloning ..."
    git clone --branch WRLINUX_10_21_BASE https://github.com/WindRiver-Labs/wrlinux-x.git
fi

echo "creating setup folders" 
if [ -d "$BUILDLOCATION" ]; then
    echo "WRLinux Directory Exists"
else
    echo " Setting Up Directory Structure"
    mkdir "$BUILDLOCATION"
    cd "$BUILDLOCATION" || exit
    ../wrlinux-x/setup.sh --all-layers
fi
