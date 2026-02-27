#!/bin/ash

DBUS_SEND="dbus-send --system --print-reply --dest=com.ctc.appframework1 /com/ctc/appframework1"
APPAGENT="com.ctc.appframework1.AppAgent"

usage1="Usage: ctc-app.sh Install/Upgrade ABSOLUTE_PATH_TO_IPK ...\n
                 \t\t\tUninstall/Run/Stop/Reload/Restore/Reinstall APP_NAME ...\n
                 \t\t\tList\n
                 \t\t\tStatus [INDEX]\n
                 \t\t\tgmo\n
                 \t\t\terror [NO]"

if [ $# -lt 1 ]; then echo -e $usage1 >&2;    exit 1; fi

if [ $# -lt 2 -a x$1 != xList -a x$1 != xStatus  -a x$1 != xerror -a $1 != gmo ]; then
    echo -e $usage1 >&2
    exit 1
fi

if [ x$1 == xStatus ]; then
if [ $# -eq 2 ]; then
	gdbus call -y -d com.ctc.appframework1 -o /com/ctc/appframework1/apps/$2 -m com.ctc.igd1.Properties.GetAll "com.ctc.appframework1.AppStatus"
elif [ $# -eq 1 ]; then	
    for num in `dbus-send --system --print-reply --dest=com.ctc.appframework1 /com/ctc/appframework1/apps org.freedesktop.DBus.Introspectable.Introspect  | grep "node name"| cut -d\" -f2`
    do
#	gdbus call -y -d com.ctc.appframework1 -o /com/ctc/appframework1/apps -m com.ctc.igd1.ObjectManager.GetManagedObjects 
       echo -e "---" $num "---"
       gdbus call -y -d com.ctc.appframework1 -o /com/ctc/appframework1/apps/$num -m com.ctc.igd1.Properties.GetAll "com.ctc.appframework1.AppStatus"
    done
fi
    exit 1
fi

if [ x$1 == xerror ]; then
	appmgr $1 $2
    exit 1
fi

if [ x$1 == xgmo ]; then 
	$DBUS_SEND/apps com.ctc.igd1.ObjectManager.GetManagedObjects
#	gdbus call -y -d com.ctc.appframework1 -o /com/ctc/appframework1/apps -m com.ctc.igd1.ObjectManager.GetManagedObjects 
	exit 1
fi

if [ x$1 == xList ]; then
	$DBUS_SEND $APPAGENT.List
    exit 1
fi

if [ x$1 == xRun -o x$1 == xStop -o x$1 == xReload -o x$1 == xRestore -o x$1 == xInstall -o x$1 == xReinstall -o x$1 == xUninstall -o x$1 == xUpgrade ]; then
for i in $@; do
	if [ x$1 != x$i ]; then
		echo $1 $i	
		$DBUS_SEND $APPAGENT.$1 string:$i
fi
done
fi

