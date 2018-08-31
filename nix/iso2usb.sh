#!/bin/bash

# usage example: sudo ./iso2usb.sh Woe10_1808_Finnish_x64 /dev/sdb
# requires parted, mkfs.fat and root

if [ "$EUID" -ne 0 ]; then
	echo "This script needs to be run as root."
	exit 420
fi

# exit on fail or unser variable
set -e
set -u

# your iso file
woeiso="$1"
# your usb stick, ie. /dev/sdb
woeusb="$2"
# tmpdir for mounting the iso
isotmp="/mnt/iso/"
# tmpdir for mounting the stick
usbtmp="/mnt/usb/"

# create GPT table
parted "$woeusb" mktable GPT

# format as fat32
mkfs.fat -F 32 "$woeusb"

# create tmpdirs for mounting
mkdir -p "$isotmp"
mkdir -p "$usbtmp"

# mount iso & stick
mount "$woeiso" "$isotmp"
mount "$woeusb" "$usbtmp"

# copy stuff over
cp -r "$isotmp"/* "$usbtmp"

# unmount
umount "$isotmp"
umount "$usbtmp"

# remove tmpdirs
rmdir "$isotmp" "$usbtmp"

# we're done here, time to make our exit
exit 0
