#!/bin/sh
#Usage: ./hipriv.sh "wlan0 create vap0"
user=$(id -u -n)
if [ "$user" == "cfg_wifi" ] || [ "$user" == "root" ]; then
    echo "$1 " > /sys/hisys/hipriv
else
    write_proc /sys/hisys/hipriv "$1 "
fi
