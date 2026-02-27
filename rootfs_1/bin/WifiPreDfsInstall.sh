#!/bin/sh

hisi_sdk_ko_filelist_path=/lib/modules/wap
hisi_sdk_cfg_filelist_dir=/etc/wap
hisi_sdk_debug_path=/mnt/jffs2
hisi_sdk_cali_path=/mnt/jffs2
hisi_sdk_run_dir=/var
hisi_sdk_ko_install_path=$hisi_sdk_ko_filelist_path
hisi_sdk_cfg_install_dir=$hisi_sdk_cfg_filelist_dir
hisi_replace_ko_file=/mnt/jffs2/replace_ko
hisi_custom_power_ini_file=/etc/wap/common_power_custom.ini
hisi_wifi_log=/var/wifidebug

# ko文件的名称
hisi_plat_ko_file_name=HWWIFI2_PLAT.ko
hisi_wifi_ko_file_name=HWWIFI2_WIFI.ko

# hisi ko提前加载KO开始标志/var/wifi_start_hisi_install，需要放到脚本外面提前生成

# hisi ko无需加载标准
hisi_wifi_no_need_install=/var/wifi_no_need_hisi_install

# hisi ko提前加载KO完成标志
hisi_wifi_finish_install=/var/wifi_finish_hisi_install

# 配置文件hisi_5g_cac_start_flag中指示的内容，注意最后带个分号
# is_dfs_channel=true;vap_name=vap4;vap_enable=true;country=CN;ssid=name;mode=8;channel=36;bandwidth=3;vap_mac=xx:xx:xx:xx:xx:xx
# 固定顺序:
# 第1列is_dfs_channel,
# 第2列vap_name
# 第3列vap_enable
# 第4列country
# 第5列ssid
# 第6列mode
# 第7列channel
# 第8列bandwidth
# 第9列为vap_mac
# vap_enable写真实状态使能，频段使能，ssid使能，总开关。
# mode需要做转换成对应的字符串，参考g_modeInfo5G，根据模式和频宽查找对应的字符串
# channel配置为0为自动信道选择
hisi_5g_cac_start_data=/mnt/jffs2/wifi_5g_cac_data

# 需要提前静默标志
hisi_5g_cac_need_flag=/var/wifi_5g_cac_need_flag

# 不需要提前静默标志
hisi_5g_cac_no_need_flag=/var/wifi_5g_cac_no_need_flag

# 进入提前静默标志阶段
hisi_5g_cac_start_flag=/var/wifi_5g_cac_start_flag

function hisi_is_support_board()
{
    # 5G静默优化不支持，数据库文件不存在
    if [ ! -f $hisi_5g_cac_start_data ]; then
        return 0;
    fi

    return 1
}

# 判断是否为装备模式
function hisi_is_equip_mode()
{
    if [ -f "/mnt/jffs2/Equip.sh" ]; then
        return 1
    fi

    # 对应独立装备软件hardequip_v5
    if [ -f "/etc/wap/equip_new" ]; then
        return 1
    fi

    return 0
}

#判断是否为需要提前加载KO的单板类型
function hisi_is_support_board_type()
{
    board_name=`cat /proc/wap_proc/pd_static_attr | grep proc_name | awk '{print $4}' | tr -d '"'`

    if [ $board_name == "V173-30" ] || [ $board_name == "V173" ]; then
        return 1;
    fi

    return 0;
}

# 传递两个参数: type board_ini_path ce_ini_path
function hisi_combine_ini_by_name()
{
    file_type=$1
    board_ini_path=$2
    ce_ini_path=$3
    is_in_equip_mode=$4

    # CE认证ini不为空且非装备模式，那么用CE认证文件
    # 后续如果放开所有单板非装备模式加载，需要参考函数WIFI_HISI_InstallDrvEx实现逻辑
    if [ ! -z $ce_ini_path ] && [ $ce_ini_path != "NULL" ] && [ $is_in_equip_mode == 0 ]; then
        board_ini_path=$ce_ini_path
        echo "wifi use $file_type ce_ini:$board_ini_path"
    fi

    if [ -z $board_ini_path ]; then
        return 1
    fi

    # 生成ont使用的最终ini文件
    if [ -f $hisi_custom_power_ini_file ]; then
        cat $board_ini_path $hisi_custom_power_ini_file > /var/cfg_ont_hisi.ini
        echo "wifi custom power ini is exist"
    else
        cat $board_ini_path > /var/cfg_ont_hisi.ini
    fi

    echo "preload use $file_type ini $board_ini_path" >> $hisi_wifi_log

    return 0
}

# 生成功率ini文件
function hisi_build_ini_by_name()
{
    local is_equip_mode=$1

    # ini_name对应的属性ID
    attr_id=0x000000a1

    board_ini_path=`cat /proc/wap_proc/pd_static_attr | grep $attr_id | awk '{print $4}' | tr -d '"' | tr -d ','`
    ce_ini_path=`cat /proc/wap_proc/pd_static_attr | grep $attr_id | awk '{print $5}' | tr -d '"'`

    # 考虑到参数可能为空串，函数传递时，需要加引号，否则会认为没有参数，跳到下1个参数
    hisi_combine_ini_by_name "pd_attr" "$board_ini_path" "$ce_ini_path" "$is_equip_mode"
    ret_combine_ini=$?
    if [ $ret_combine_ini == 0 ]; then
        return 0
    fi

    board_name=`cat /proc/wap_proc/pd_static_attr | grep proc_name | awk '{print $4}' | tr -d '"'`
    board_id=`cat /var/board_cfg.txt | grep board_id |cut -d ';' -f 1|cut -d '=' -f 2`

    board_ini_path=`cat /etc/wap/hisi_pdt_maplist.conf | grep $board_name, | grep $board_id, | awk '{print $3}' | tr -d ','`
    ce_ini_path=`cat /etc/wap/hisi_pdt_maplist.conf | grep $board_name, | grep $board_id, | awk '{print $4}'`

    echo "board_name=$board_name,board_id=$board_id"
    echo "board_ini_path=$board_ini_path,ce_ini_path=$ce_ini_path"

    hisi_combine_ini_by_name "maplist" "$board_ini_path" "$ce_ini_path" "$is_equip_mode"
    ret_combine_ini=$?
    if [ $ret_combine_ini == 0 ]; then
        return 0
    fi

    # 参考WIFI进程的逻辑，找不到指定默认的配置文件，保证WIFI进程能起来
    local default_board_ini_path="/etc/wap/cfg_ont_hisi.ini"
    local default_ce_ini_path="NULL"
    hisi_combine_ini_by_name "default" "$default_board_ini_path" "$default_ce_ini_path" "$is_equip_mode"
    ret_combine_ini=$?
    if [ $ret_combine_ini == 0 ]; then
        return 0
    fi

    return 1
}

# 创建wifi只读文件
function hisi_create_wifi_only_read_file()
{
    if [ $# -eq 0 ]; then
        return 0
    fi

    touch $1
    chmod ug=r,o= $1
    chown -h lsv_wifi:lansrv $1

    return 0
}

# 创建wifi可写文件
function hisi_create_wifi_write_file()
{
    if [ $# -eq 0 ]; then
        return 0
    fi

    touch $1
    chmod u=rw,g=r,o= $1
    chown -h lsv_wifi:lansrv $1

    return 0
}

function hisi_copy_cfg()
{
    cp /etc/wap/wifi_cfg $hisi_sdk_run_dir
    cp $hisi_sdk_cfg_install_dir/cfg_device_hisi.ini $hisi_sdk_run_dir
    cp $hisi_sdk_cfg_install_dir/FIRMWARE.bin $hisi_sdk_run_dir

    chown -h lsv_wifi:lansrv $hisi_sdk_run_dir/cfg_ont_hisi.ini
    chown -h lsv_wifi:lansrv $hisi_sdk_run_dir/wifi_cfg
    chown -h lsv_wifi:lansrv $hisi_sdk_run_dir/cfg_device_hisi.ini
    chown -h lsv_wifi:lansrv $hisi_sdk_run_dir/FIRMWARE.bin

    chmod u=rw,g=r,o= $hisi_sdk_run_dir/cfg_ont_hisi.ini
    chmod ug=r,o= $hisi_sdk_run_dir/wifi_cfg
    chmod ug=r,o= $hisi_sdk_run_dir/cfg_device_hisi.ini
    chmod ug=r,o= $hisi_sdk_run_dir/FIRMWARE.bin

    # 装备模式下，此文件不存在
    if [ -f $hisi_sdk_cali_path/wifi_cali_data_2g.kv ]; then
        cp $hisi_sdk_cali_path/wifi_cali_data_2g.kv $hisi_sdk_run_dir
        chown -h lsv_wifi:lansrv $hisi_sdk_run_dir/wifi_cali_data_2g.kv
        chmod u=rw,g=r,o= $hisi_sdk_run_dir/wifi_cali_data_2g.kv
    fi

    if [ -f $hisi_sdk_cali_path/wifi_cali_data.kv ]; then
        cp $hisi_sdk_cali_path/wifi_cali_data.kv $hisi_sdk_run_dir
        chown -h lsv_wifi:lansrv $hisi_sdk_run_dir/wifi_cali_data.kv
        chmod u=rw,g=r,o= $hisi_sdk_run_dir/wifi_cali_data.kv
    fi

    return 0
}

function hisi_install_ko()
{
    local is_equip_mode=$1

    insmod $hisi_sdk_ko_install_path/$hisi_plat_ko_file_name

    if [ $is_equip_mode == 0 ]; then
        insmod $hisi_sdk_ko_install_path/$hisi_wifi_ko_file_name
    else
        #装备模式下，加载WIFI KO需要指定发包长度
        insmod $hisi_sdk_ko_install_path/$hisi_wifi_ko_file_name g_en_rx_packet_4096_length=1
    fi

    insmod $hisi_sdk_ko_install_path/wifi_diag.ko

    return 0
}

function hisi_is_need_start_main_5g()
{
    is_dfs_channel=`cat $hisi_5g_cac_start_data | cut -d ';' -f 1 | cut -d '=' -f 2`
    if [ $is_dfs_channel != "true" ]; then
        echo "wifi not start fisrt 5g for is_dfs_channel=$is_dfs_channel" >> $hisi_wifi_log
        return 0
    fi

    vap_enable=`cat $hisi_5g_cac_start_data | cut -d ';' -f 3 | cut -d '=' -f 2`
    if [ $vap_enable != "true" ]; then
        echo "wifi not start fisrt 5g for vap_enable=$vap_enable" >> $hisi_wifi_log
        return 0
    fi

    return 1
}

function hisi_load_debug_ini()
{
    echo "preload use /mnt/jffs2/cfg_ont_hisi.ini" >> $hisi_wifi_log

    if [ -f $hisi_custom_power_ini_file ]; then
        cat $hisi_sdk_debug_path/cfg_ont_hisi.ini $hisi_custom_power_ini_file > /var/cfg_ont_hisi.ini
        echo "wifi custom power ini is exist"
    else
        cp $hisi_sdk_debug_path/cfg_ont_hisi.ini > /var/cfg_ont_hisi.ini
    fi
}

# 转换方法，参考g_modeInfo5G定义
function hisi_set_main_5g_mode()
{
    local vap_name=$1
    local mode=$2
    local bandwidth=$3

    local wireless_11a=2
    local wireless_11a_n=8
    local wireless_11n_5g_band=11
    local wireless_11ac_n_a=12
    local wireless_11ac=13
    local wireless_11a_n_ac_ax=15

    local bandwidth_ht20=0
    local bandwidth_ht20_ht40=1
    local bandwidth_ht40=2
    local bandwidth_ht20_ht40_vht80=3
    local bandwidth_vht160=4

    local main_5g_mode=

    if [ $mode == $wireless_11a ] && [ $bandwidth == $bandwidth_ht20 ]; then
        main_5g_mode=11a
    elif [ $mode == $wireless_11a_n ]; then
        if [ $bandwidth == $bandwidth_ht20 ]; then
            main_5g_mode=11na20
        elif [ $bandwidth == $bandwidth_ht40 ]; then
            main_5g_mode=11na40
        elif [ $bandwidth == $bandwidth_ht20_ht40 ]; then
            main_5g_mode=11na40
        fi
    elif [ $mode == $wireless_11n_5g_band ]; then
        if [ $bandwidth == $bandwidth_ht20 ]; then
            main_5g_mode=11nonly5g
        elif [ $bandwidth == $bandwidth_ht20_ht40 ]; then
            main_5g_mode=11na40
        elif [ $bandwidth == $bandwidth_ht40 ]; then
            main_5g_mode=11na40
        fi
    elif [ $mode == $wireless_11ac_n_a ]; then
        if [ $bandwidth == $bandwidth_ht20 ]; then
            main_5g_mode=11ac20
        elif [ $bandwidth == $bandwidth_ht40 ]; then
            main_5g_mode=11ac40
        elif [ $bandwidth == $bandwidth_ht20_ht40 ]; then
            main_5g_mode=11ac40
        elif [ $bandwidth == $bandwidth_ht20_ht40_vht80 ]; then
            main_5g_mode=11ac80
        elif [ $bandwidth == $bandwidth_vht160 ]; then
            main_5g_mode=11ac160
        fi
    elif [ $mode == $wireless_11ac ]; then
        if [ $bandwidth == $bandwidth_ht20 ]; then
            main_5g_mode=11aconly
        elif [ $bandwidth == $bandwidth_ht40 ]; then
            main_5g_mode=11ac40
        elif [ $bandwidth == $bandwidth_ht20_ht40 ]; then
            main_5g_mode=11ac40
        elif [ $bandwidth == $bandwidth_ht20_ht40_vht80 ]; then
            main_5g_mode=11ac80
        elif [ $bandwidth == $bandwidth_vht160 ]; then
            main_5g_mode=11ac160
        fi
    elif [ $mode == $wireless_11a_n_ac_ax ]; then
        if [ $bandwidth == $bandwidth_ht20 ]; then
            main_5g_mode=11ax20
        elif [ $bandwidth == $bandwidth_ht40 ]; then
            main_5g_mode=11ax40
        elif [ $bandwidth == $bandwidth_ht20_ht40 ]; then
            main_5g_mode=11ax40
        elif [ $bandwidth == $bandwidth_ht20_ht40_vht80 ]; then
            main_5g_mode=11ax80
        elif [ $bandwidth == $bandwidth_vht160 ]; then
            main_5g_mode=11ax160
        fi
    fi

    if [ -z $main_5g_mode ]; then
        echo "wifi not support mode=$mode,bandwidth=$bandwidth"
        return 1
    fi

    iwpriv $vap_name mode $main_5g_mode
    ret_mode=$?
    echo "preCAC run cmd iwpriv $vap_name mode $main_5g_mode", Ret=$ret_mode >> $hisi_wifi_log
    if [ ${ret_mode} != 0 ]; then
        return 1
    fi

    return 0
}

function hisi_start_main_5g()
{
    local main_5g_vap_name=`cat $hisi_5g_cac_start_data | cut -d ';' -f 2 | cut -d '=' -f 2 | tr -d ';'`
    local main_5g_country=`cat $hisi_5g_cac_start_data | cut -d ';' -f 4 | cut -d '=' -f 2 | tr -d ';'`
    local main_5g_vap_ssid=WirelessNet_$main_5g_vap_name
    local main_5g_mode=`cat $hisi_5g_cac_start_data | cut -d ';' -f 6 | cut -d '=' -f 2 | tr -d ';'`
    local main_5g_channel=`cat $hisi_5g_cac_start_data | cut -d ';' -f 7 | cut -d '=' -f 2 | tr -d ';'`
    local main_5g_bandwidth=`cat $hisi_5g_cac_start_data | cut -d ';' -f 8 | cut -d '=' -f 2 | tr -d ';'`
    local main_5g_vap_mac=`cat $hisi_5g_cac_start_data | cut -d ';' -f 9 | cut -d '=' -f 2 | tr -d ';'`

    # 创建第一个5G VAP AP设备
    hipriv.sh "Hisilicon0 create $main_5g_vap_name ap 5g"
    ret_start_5g=$?
    echo "preCAC run cmd hipriv.sh \"Hisilicon0 create $main_5g_vap_name ap 5g\"", Ret=$ret_start_5g >> $hisi_wifi_log
    if [ ${ret_start_5g} != 0 ]; then
        return 1
    fi

    # 配置VAP MAC地址
    busybox ifconfig $main_5g_vap_name hw ether $main_5g_vap_mac
    ret_start_5g=$?
    echo "preCAC run cmd busybox ifconfig $main_5g_vap_name hw ether $main_5g_vap_mac", Ret=$ret_start_5g >> $hisi_wifi_log
    if [ ${ret_start_5g} != 0 ]; then
        hipriv.sh "Hisilicon0 $main_5g_vap_name destroy"
        return 1
    fi

    # 设置SSID名称
    iwpriv $main_5g_vap_name setessid "$main_5g_vap_ssid"
    ret_start_5g=$?
    echo "preCAC run cmd iwpriv $main_5g_vap_name setessid \"$main_5g_vap_ssid\"", Ret=$ret_start_5g >> $hisi_wifi_log
    if [ ${ret_start_5g} != 0 ]; then
        hipriv.sh "Hisilicon0 $main_5g_vap_name destroy"
        return 1
    fi

    # 设置国家码
    iwpriv $main_5g_vap_name setcountry $main_5g_country
    ret_start_5g=$?
    echo "preCAC run cmd iwpriv $main_5g_vap_name setcountry $main_5g_country", Ret=$ret_start_5g >> $hisi_wifi_log
    if [ ${ret_start_5g} != 0 ]; then
        hipriv.sh "Hisilicon0 $main_5g_vap_name destroy"
        return 1
    fi

    # 设置信道
    if [ $main_5g_channel == 0 ]; then
        # 自动信道选择时，脚本里面无法触发ACS扫描。当前默认取第一个信道。可能会和ACS选择的最优信道不同。
        main_5g_channel=36
    fi

    iwpriv $main_5g_vap_name channel $main_5g_channel
    ret_start_5g=$?
    echo "preCAC run cmd iwpriv $main_5g_vap_name channel $main_5g_channel", Ret=$ret_start_5g >> $hisi_wifi_log
    if [ ${ret_start_5g} != 0 ]; then
        hipriv.sh "Hisilicon0 $main_5g_vap_name destroy"
        return 1
    fi

    # 设置模式
    hisi_set_main_5g_mode $main_5g_vap_name $main_5g_mode $main_5g_bandwidth
    ret_start_5g=$?
    if [ ${ret_start_5g} != 0 ]; then
        hipriv.sh "Hisilicon0 $main_5g_vap_name destroy"
        return 1
    fi

    # 设置为私有配置设备
    iwpriv $main_5g_vap_name privflag 1
    ret_start_5g=$?
    echo "preCAC run cmd iwpriv $main_5g_vap_name privflag 1", Ret=$ret_start_5g >> $hisi_wifi_log
    if [ ${ret_start_5g} != 0 ]; then
        hipriv.sh "Hisilicon0 $main_5g_vap_name destroy"
        return 1
    fi

    # VAP运行
    busybox ifconfig $main_5g_vap_name up
    echo "preCAC run cmd busybox ifconfig $main_5g_vap_name up", Ret=$ret_start_5g >> $hisi_wifi_log
    ret_start_5g=$?
    if [ ${ret_start_5g} != 0 ]; then
        hipriv.sh "Hisilicon0 $main_5g_vap_name destroy"
        return 1
    fi

    return 0
}

# 海思KO加载流程从这开始
# 装备模式直接走原有流程
# 装备模式没有校准文件，需要修改依赖的配置文件的流程
# 注意装备模式下使用的INI文件
hisi_is_equip_mode
ret_is_equip_mode=$?

hisi_is_support_board
ret_5g_cac_support=$?

hisi_is_support_board_type
ret_is_support_board_type=$?

# 除需要提前加载的单板外，未支持5G静默的单板，且非装备模式，走原来的老流程
if [ ${ret_5g_cac_support} == 0 ] && [ ${ret_is_equip_mode} == 0 ] && [ ${ret_is_support_board_type} == 0 ] ; then
    hisi_create_wifi_only_read_file $hisi_wifi_no_need_install
    echo "running normal wifi loading"
    exit
fi

# 下面是装备模式，或者需提前静默流程。都需要提前加载KO
echo "wifi loading ko"

# 提前创建wifi log临时文件
hisi_create_wifi_write_file $hisi_wifi_log

# 支持5G静默的单板，走新的流程

if [ -f /etc/wap/DebugVersionFlag ] && [ -f $hisi_replace_ko_file ]; then
    echo "Loading replace wifi ko..."
    hisi_sdk_ko_install_path=$hisi_sdk_debug_path
    hisi_sdk_cfg_install_dir=$hisi_sdk_debug_path
    hisi_plat_ko_file_name=hi1152_plat.ko
    hisi_wifi_ko_file_name=hi1152_wifi.ko
    hisi_load_debug_ini
else
    # 准备SDK KO依赖的ini文件
    hisi_build_ini_by_name $ret_is_equip_mode
    ret_build_ini=$?
    if [ ${ret_build_ini} != 0 ]; then
        hisi_create_wifi_only_read_file $hisi_wifi_no_need_install
        echo "preload build ini fail" >> $hisi_wifi_log
        exit
    fi
fi

if [ -d /var/WiFisdk ]; then
    echo "Loading wifi ko... wifisdk"
    hisi_sdk_ko_install_path=/var/WiFisdk/lib/modules/wap
    hisi_sdk_cfg_install_dir=/var/WiFisdk/etc/wap
fi

ret_need_start_main_5g=0
if [ ${ret_5g_cac_support} == 1 ]; then
    hisi_is_need_start_main_5g
    ret_need_start_main_5g=$?
fi

# 非装备模式，满足需要提前静默，提前创建静默标志;不满足提前静默，需要创建不需要提前静默标志，用于WIFI进程识别
# 需要放到hisi sdk加载前创建，顺序不能改变
if [ ${ret_is_equip_mode} == 0 ] && [ ${ret_need_start_main_5g} != 0 ]; then
    hisi_create_wifi_only_read_file $hisi_5g_cac_need_flag
else
    hisi_create_wifi_only_read_file $hisi_5g_cac_no_need_flag
fi

# 拷贝SDK配置文件
hisi_copy_cfg

# 加载SDK KO
hisi_install_ko $ret_is_equip_mode

# 指定KO加载成功文件，避免重复加载
hisi_create_wifi_only_read_file $hisi_wifi_finish_install

echo "Loading the wifi ko...End"

# 不要提前静默，提前返回
if [ ${ret_need_start_main_5g} == 0 ] || [ ${ret_is_equip_mode} == 1 ]; then
    return 0
fi

# 5G接口提前静默初始化
hisi_start_main_5g
ret_start_main_5g=$?
if [ ${ret_start_main_5g} != 0 ]; then
    hisi_create_wifi_only_read_file $hisi_5g_cac_no_need_flag
    return 0
fi

# 5G第1个接口提前初始化成功标记
hisi_create_wifi_only_read_file $hisi_5g_cac_start_flag
