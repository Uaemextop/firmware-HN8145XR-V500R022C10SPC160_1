#/bin/sh
cat /var/wifipmlog
sleep 0.5
cat /var/hilink/topodebug*
sleep 1
if [ -d /var/easymesh/ ]; 
	then cat /var/easymesh/controller*; cat /var/easymesh/agent*; 
	sleep 0.5;
fi;