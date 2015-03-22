#!/bin/bash
# Simple script for preparing your card for beaglebone
set -x
#Clean Previous images on card if any
BOOT_PART="BOOT"
ROOTFS_PART="ROOT"

DEV=${1:-mmcblk0}
# DELETE_PARTS=$((echo d; echo 1; echo d; echo w) | sudo fdisk /dev/${DEV})
# CREATE_PART1=$((echo n; echo ; echo ; echo ; echo +32M; echo w) | sudo fdisk /dev/${DEV})
# CREATE_PART2=$((echo n; echo ; echo ; echo ; echo ; echo w) | sudo fdisk /dev/${DEV})
# MARK_BOOTFL=$((echo a; echo 1; echo w) | sudo fdisk /dev/${DEV})

#echo "### Deleting old partitions ###"
#(echo d; echo 1; echo d; echo w) | sudo fdisk /dev/${DEV} > /dev/null 2>&1
sudo umount /dev/${DEV}p1
sudo umount /dev/${DEV}p2
echo "### Creating partition One: BOOT ###"
(echo n; echo ; echo ; echo ; echo +32M; echo w) | sudo fdisk /dev/${DEV} > /dev/null 2>&1
echo "### Creating partition Two: ROOT ###"
(echo n; echo ; echo ; echo ; echo ; echo w) | sudo fdisk /dev/${DEV} > /dev/null 2>&1
echo "### Setting bootlfag of BOOT partition ###"
(echo a; echo 1; echo t; echo 1; echo w) | sudo fdisk /dev/${DEV} > /dev/null 2>&1
echo "### Formating BOOT partition to FAT32 ###"
sudo mkfs.vfat -n ${BOOT_PART} /dev/${DEV}p1 > /dev/null 2>&1
echo "### Formating ROOT partition to EXT4 ###"
sudo mkfs.ext4 -L ${ROOTFS_PART} /dev/${DEV}p2 > /dev/null 2>&1