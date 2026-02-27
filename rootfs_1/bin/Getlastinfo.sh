#! /bin/sh

mkdir /var/lastsysinfo_tmp
if [ -f /mnt/jffs2/lastsysinfo.tar.gz ]; then
    tar -zxvf /mnt/jffs2/lastsysinfo.tar.gz -C /var/lastsysinfo_tmp > /dev/null
else
    if [ -f /var/lastsysinfo.tar.gz ]; then
        tar -zxvf /var/lastsysinfo.tar.gz -C /var/lastsysinfo_tmp > /dev/null
    fi
fi

if [ -f /var/lastsysinfo_tmp/lastsysinfo ]; then
    echo " dlw 1"
    cat /var/lastsysinfo_tmp/lastsysinfo
fi

if [ -f /mnt/jffs2/lastsysinfo_2.tar.gz ]; then
    mkdir /var/lastsysinfo_tmp/2
    tar -zxvf /mnt/jffs2/lastsysinfo_2.tar.gz -C /var/lastsysinfo_tmp/2 > /dev/null
fi

if [ -f /mnt/jffs2/lastsysinfo_3.tar.gz ]; then
    mkdir /var/lastsysinfo_tmp/3
    tar -zxvf /mnt/jffs2/lastsysinfo_3.tar.gz -C /var/lastsysinfo_tmp/3 > /dev/null
fi

if [ -f /var/lastsysinfo_tmp/2/lastsysinfo ]; then
    echo " lastsysinfo_2"
    cat /var/lastsysinfo_tmp/2/lastsysinfo
fi

if [ -f /var/lastsysinfo_tmp/3/lastsysinfo ]; then
    echo " lastsysinfo_3"
    cat /var/lastsysinfo_tmp/3/lastsysinfo
fi

rm -rf /var/lastsysinfo_tmp

exit 0
