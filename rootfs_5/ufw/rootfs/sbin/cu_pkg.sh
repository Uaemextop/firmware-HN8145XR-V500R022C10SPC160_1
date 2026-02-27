#!/bin/ash

GDBUS="gdbus call -y -d com.cuc.appframework1 -o /com/cuc/appframework1 -m com.cuc.appframework1.AppAgent"

usage11="Usage: $0 Install ipkFileName"  
usage12="       $0 Uninstall/Run/Stop pluginName"
usage2="Usage: $0 List"

if [ $# -ne 1 -a x$1 == xList ]
then
    echo -e $usage2  >&2
    exit 1
fi

if [ $# -ne 2 -a x$1 != xList ]
then
    echo -e "$usage11" >&2
    echo -e "$usage12" >&2
    exit 1
fi

if [ x$1 == xList ]
then
	$GDBUS.List
elif [ x$1 == xUninstall -o x$1 == xuninstall -o x$1 == xUn ]
then
	echo Uninstall $2 ...
	$GDBUS.Uninstall "$2"
elif [ x$1 == xInstall -o x$1 == xinstall -o x$1 == xin ]
then
	echo Install $2 ...
	if [ ${2:0:1} == "/" ]
	then
		$GDBUS.Install "$2"
	else
		fname=`pwd`/$2
		$GDBUS.Install "$fname"
	fi
elif [ x$1 == xstat ]
then
	echo GetStatus $2 ...
	$GDBUS.GetStatus "$2"
elif [ x$1 == xRun -o x$1 == xStop ]
then
	echo $1 $2 ...
	$GDBUS.$1 "$2"
else
    echo -e "$usage11" >&2
    echo -e "$usage12" >&2
    echo -e "$usage2"  >&2
fi
