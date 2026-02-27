#! /bin/sh
cudbus_support=`GetFeature FEATURE_CU_DBUS`
if [ $cudbus_support = 0 ]; then
    export LD_LIBRARY_PATH=/opt/upt/framework/saf/rootfs/lib:/opt/upt/framework/saf/rootfs/usr/lib:$LD_LIBRARY_PATH
    /opt/upt/framework/saf/rootfs/sbin/logread | sed -e 's/"key":"[^"]*"/"key":"-"/g' -e "s/'key.\{0,3\}': <'[^']*'>/'keyxx': <'-'>/g"
else
    echo "cat /var/log/ufw_lxc.log"
    cat /var/log/ufw_lxc.log

    echo "cat /var/ufwmg.log"
    cat /var/ufwmg.log

    echo "cat /opt/cu/apps/apps/var/log/ufw/ufw.log.old"
    cat /opt/cu/apps/apps/var/log/ufw/ufw.log.old | sed -e 's/"*Password":"[^"]*"/"Password":"-"/g' -e "s/'*Password.\{0,3\}': <'[^']*'>/'Passwordxx': <'-'>/g"

    echo "cat /opt/cu/apps/apps/var/log/ufw/ufw.log"
    cat /opt/cu/apps/apps/var/log/ufw/ufw.log | sed -e 's/"*Password":"[^"]*"/"Password":"-"/g' -e "s/'*Password.\{0,3\}': <'[^']*'>/'Passwordxx': <'-'>/g"

    echo "cat /tmp/ufwsrv.log"
    cat /tmp/ufwsrv.log

    echo "cat /opt/cu/apps/apps/var/log/plugin/cuinform.log"
    cat /opt/cu/apps/apps/var/log/plugin/cuinform.log

    echo "cat /opt/cu/apps/apps/var/log/app_lxc.log"
    cat /opt/cu/apps/apps/var/log/app_lxc.log
fi