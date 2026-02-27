#/bin/sh
wlancmd show log
sleep 0.5
wlancmd show xlinkerrlog
sleep 0.5
wlancmd debug ap log
wlancmd debug scn show sta
wlancmd debug scn show ap
wlancmd debug scn show friend_sta
wlancmd debug scn show friend_rule
wlancmd debug scn show log
sleep 0.5