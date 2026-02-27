#/bin/sh

for i in `ls /var/pm_log/*`; do cat $i; done
ls -l /mnt/jffs2/*
for i in `ls /mnt/jffs2/pm_log/*`; do cat $i; done
