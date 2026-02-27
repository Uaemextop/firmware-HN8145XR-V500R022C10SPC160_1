#!/bin/sh

function insmod_usb_ko()
{
    echo "insmod usb ko"

    insmod /lib/modules/linux/kernel/fs/fat/fat.ko
    insmod /lib/modules/linux/kernel/fs/fat/vfat.ko

    if [ -f /lib/modules/linux/kernel/fs/fuse/fuse.ko ]; then
        insmod /lib/modules/linux/kernel/fs/fuse/fuse.ko
    fi
    if [ -f /lib/modules/linux/kernel/fs/overlayfs/overlayfs.ko ]; then
        insmod /lib/modules/linux/kernel/fs/overlayfs/overlayfs.ko
    fi
    if [ -f /lib/modules/linux/kernel/drivers/scsi/scsi_wait_scan.ko ]; then
        insmod /lib/modules/linux/kernel/drivers/scsi/scsi_wait_scan.ko
    fi
}

function rmmod_usb_ko()
{
    rmmod fuse
    rmmod overlayfs
    rmmod scsi_wait_scan
}

if [ $ACTION = "add" ]; then
    insmod_usb_ko
else
    rmmod_usb_ko
fi
