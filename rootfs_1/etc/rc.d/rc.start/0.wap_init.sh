#!/bin/sh

#时间整改，平台修改系统启动时间
echo "enter 0.wap_init.sh................"
echo -n "IAS WAP Ver:"
cat /etc/wap/wap_version
echo -n "IAS WAP Timestamp:"
cat /etc/wap/wap_timestamp

# 修复用户态非对齐的指令问题
echo 2 > /proc/cpu/alignment

function load_baisc_modules()
{
    #加载基础相关的ko
    insmod /lib/modules/linux/securec/ksecurec.ko
    insmod /lib/modules/wap/hw_ssp_gpl.ko
    insmod /lib/modules/wap/hw_module_random.ko
    insmod /lib/modules/wap/hw_ssp_basic.ko
    insmod /lib/modules/wap/hw_module_crypto.ko

    return 0
}

function load_crypto_modules()
{
    #加载加解密相关的module
    insmod /lib/modules/linux/kernel/crypto/jitterentropy_rng.ko
    insmod /lib/modules/linux/kernel/crypto/ctr.ko
    insmod /lib/modules/linux/kernel/crypto/gf128mul.ko
    insmod /lib/modules/linux/kernel/crypto/ghash-generic.ko
    insmod /lib/modules/linux/kernel/crypto/gcm.ko
    insmod /lib/modules/linux/kernel/crypto/libsha256.ko
    insmod /lib/modules/linux/kernel/crypto/sha256_generic.ko

    return 0
}

load_crypto_modules &
load_baisc_modules

dlwIndex=0;
while true;
    do sleep 10;
    dlwIndex=$(($dlwIndex+1))
    dlw > /var/init_dlw$dlwIndex
    if [ $dlwIndex -ge 12 ]; then
        if [ ! -f /var/init_complete ]; then
            cp /var/init_debug.tgz /mnt/jffs2/init_debug.txt  # 内部使用，避免多生成一个文件，不改文件名
        fi
        rm /var/init_dlw*
        break;
    fi
done&

# 启动kmsgreader读取打印信息
kmsgread &

# 初始化串口打印跟踪记录，120秒以后关闭记录
echo !path "/var/init_debug.txt" > /proc/wap_proc/tty;
echo !start > /proc/wap_proc/tty;
while true;
    do sleep 120;
    echo !stop > /proc/wap_proc/tty;
    echo !path "/var/console.log" > /proc/wap_proc/tty;
    sed -i 's/WAP(Dopra Linux) #//g' /var/init_debug.txt;
    sed -i 's/root@easy98020:~#//g' /var/init_debug.txt;
    tar zcf /var/init_debug.tgz /var/init_debug.txt;
    rm /var/init_debug.txt
    chown -h mgt_ssmp:service /var/init_debug.tgz;
    break;
done &

# 动态创建部分用户，避免出现冗余账户，注意有部分单板使用扩展分区extrootfs，此时执行文件为软连接
if [ -e /bin/wifi ] || [ -h /bin/wifi ]; then
    AddSysUser lsv_wifi 3024 1200;
    AddSysUser cfg_wifi 3025 1200;
fi

# 指定用户创建iptables锁文件，避免在启动过程中自动创建为root用户文件
if [ -f /sbin/iptables ]; then
    touch /var/xtables.lock
    touch /var/iptable_lock
    # 待其他领域整改掉iptables命令后，去掉权限的同时删除这里的处理
    chmod 644 /var/xtables.lock /var/iptable_lock
fi

echo "out 0.wap_init.sh................"
