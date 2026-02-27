#/bin/sh

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    exit 1;
fi

CLI_MODE=$(cat /var/collectshflag)

if [ "$CLI_MODE" = "1" ]
then
    echo "Now ClientType Is TRANSCHNL, collect.sh can not be used in this ClientType."
    exit 1
fi

if [ -f /var/diacollectisrunning ]
then
    echo "diagnose collection process is existed now!"
    exit 1
fi

if [ "$LOCAL_TELNET" == "1" ]; then
    diag_src="com";
else
    diag_src="telnet";
fi

echo "local telnet flag is $LOCAL_TELNET, diag source is $diag_src"

echo 1 > /var/collect_ctrl_fifo;

echo  "Begin to collect the data"
collect_exe /etc/wap/collect/amp_collect $diag_src
collect_exe /etc/wap/collect/amp_pdt_collect $diag_src

echo 2 > /var/collect_ctrl_fifo;

if [ "$LOCAL_TELNET" != "1" ]; then
	cat /var/console.log 
fi

echo  "End to collect the data"

exit 0;
