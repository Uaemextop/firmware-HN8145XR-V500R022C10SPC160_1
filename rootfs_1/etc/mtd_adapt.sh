#! /bin/sh

mtd_name=mtd${MDEV#*mtdblock}
part_name=$(cat /proc/mtd | grep $mtd_name: | cut -d' ' -f 4 | sed 's/\"//g')

case $part_name in
    "wifi_paramA"|"wifi_paramB")
        chown 0:7 /dev/$MDEV
        chown 0:7 /dev/$mtd_name
    ;;
    "frameworkA"|"frameworkB")
        chown 0:12 /dev/$MDEV
        chown 0:12 /dev/$mtd_name
    ;;
    "flash_configA"|"flash_configB")
        chown 0:8 /dev/$MDEV
        chown 0:8 /dev/$mtd_name
    ;;
    "bootcode")
        chown 0:14 /dev/$MDEV
        chown 0:14 /dev/$mtd_name
    ;;
esac
