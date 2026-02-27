#!/bin/ash

if [ $# -gt 1 ]; then ip netns exec $@; exit 1; fi

mkdir -p /var/run/netns

for app in `opkg listapp| awk '{print $1}'`
    do	
		pid=`pidof $app | awk '{print $1}'` 

		if [ /proc/$pid/ns/net -ef /proc/self/ns/net ]; then echo "--- app:" $app", pid:" $pid "same netns ---";  continue; fi

		if [ ! -f /var/run/netns/$app ]; then
			touch /var/run/netns/$app
		fi	

		if [ ! -z $pid ]; then echo -e "---" mount netns, app: $app, pid: $pid "---"; umount /var/run/netns/$app 2>/dev/null; mount --bind /proc/$pid/ns/net /var/run/netns/$app; \
		else echo "--- app:" $app "is not running ---"; fi
    done