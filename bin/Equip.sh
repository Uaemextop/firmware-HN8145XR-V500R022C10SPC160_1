#!/bin/sh

# 重新以exec挂载jffs2
mount -o remount,exec /mnt/jffs2

var_equipment_file="/mnt/jffs2/equipment.tar.gz"
if [ -f $var_equipment_file ];then
	cd /mnt/jffs2
	tar -xzf $var_equipment_file 
	rm -f $var_equipment_file
    echo "<module>" > /mnt/jffs2/module_desc.xml
    echo '<moduleitem name="equipment" path="/mnt/jffs2/equipment"/>' >> /mnt/jffs2/module_desc.xml
    echo "</module>" >> /mnt/jffs2/module_desc.xml
    cp -a /mnt/jffs2/module_desc.xml /mnt/jffs2/module_desc_bak.xml
	cd /
fi

if [ -f /mnt/jffs2/replace_celeno_ko ]; then
export cl2400_root=/var/cl2400_host_pkg/cl2400
else
export cl2400_root=/usr/lib/cl2400_host_pkg/cl2400
fi
export clr_install_dir_cl2400=$cl2400_root
export clr_cfg_dir_cl2400_24g=/var/cl2400_24g
export clr_cfg_dir_cl2400=/var/cl2400
export PATH=$PATH:$cl2400_root/bin:$cl2400_root/scripts
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$cl2400_root/lib

echo "equipment modify"
if [ -f /lib/modules/wap/hw_wifi_diagnose_ct.ko ];then
    echo "modify hw_hardinfo_spec"
	if [ ! -f /mnt/jffs2/hw_hardinfo_spec ];then
		echo 'spec.name="AMP_SPEC_SSID_NUM_MAX_BAND" spec.type="uint" spec.value="4"'>>/mnt/jffs2/hw_hardinfo_spec
	fi
fi

cp /mnt/jffs2/equipment/sign/Equip.sh /var/Equip.sh 2>/dev/null 
[[ ! -f /mnt/jffs2/ProductLineMode ]] && echo "" > /mnt/jffs2/ProductLineMode
chown -h mgt_ssmp:mngt /mnt/jffs2/ProductLineMode

insmod /lib/modules/wap/hw_module_feature.ko

if [ ! -f /mnt/jffs2/equip_ip_enable ]
then
    echo "" > /mnt/jffs2/equip_ip_enable
fi

var_xpon_mode=`getboardinfo 0x00000001`
echo "xpon_mode:${var_xpon_mode}"

echo ${var_xpon_mode}>>/var/var_xpon_mode

# 挂载sdk到/var/目录下
function mount_sdk()
{
    ubi_dir=/sys/class/ubi
    for file in `ls $ubi_dir`
    do
        if [ -d $ubi_dir"/"$file ]; then
            if [ -f $ubi_dir"/"$file"/name" ]; then
                ubi_name=`cat $ubi_dir"/"$file"/name"`
                echo "ubi name is:$ubi_name"
                if [ $ubi_name == "apps" ] || [ $ubi_name == "app_system" ]; then
                    echo "sub_dir name:$file"
                    mkdir -p /mnt/jffs2/sdk_mnt
                    mount -t ubifs -o sync /dev/$file /mnt/jffs2/sdk_mnt
                    break;
                fi
            fi
        fi
    done
 
    # 挂载sdk到/var/目录下
    if [ -d /mnt/jffs2/sdk_mnt ]; then
        echo "load sdk start"
        loadsdkfs sdk
        echo "load sdk end"
    fi
}

echo "User init start......"
flashtype_v5=`cat /proc/mtd | grep "ubilayer" | wc -l`
echo "flashtype_v5 is $flashtype_v5"

# load sdk
mount_sdk

if [ ! -f /bin/telnet ]; then
    if [ ! -f /mnt/jffs2/temp/telnet ]; then
        mkdir /mnt/jffs2/temp
        ln -sf /bin/busybox /mnt/jffs2/temp/telnet
    fi
    export PATH=/mnt/jffs2/temp:$PATH
fi

if [ -d "/var/TsdkFs/lib/modules/hisi_sdk" ]; then
  sdk_path="/var/TsdkFs/lib/modules/hisi_sdk"
else 
  sdk_path="/lib/modules/hisi_sdk"
fi
if [ -d "/var/TsdkFs/etc/soc" ]; then
  phy_ponlink_path="/var/TsdkFs/etc/soc/"
else 
  phy_ponlink_path="/etc/soc/"
fi

# load hisi modules
cd $sdk_path
echo "Loading the HISI SD511X modules: "

if [ -f $sdk_path/hi_sal.ko ]; then
    insmod hi_sal.ko
fi
#如果有多芯片注册KO，则注册多芯片，否则注册单芯片
if [ -f /lib/modules/wap/hw_module_multichip.ko ]; then
    insmod hi_sysctl.ko g_chipnum=2
else
    insmod hi_sysctl.ko
fi

tempChipType1=`md 0x10100800 1`
tempChipType=`echo $tempChipType1 | sed 's/.*:: //' | sed 's/[0-9][0-9]00//' | cut -b 1-4`

#合并之后的ko只需要加载一个
if [ -f $sdk_path/hi_ecs.ko ]; then
    insmod hi_ecs.ko
else
    insmod hi_spi.ko
    insmod hi_mdio.ko
    insmod hi_gpio.ko
    insmod hi_dma.ko
    insmod hi_i2c.ko
    insmod hi_timer.ko
    insmod hi_uart.ko
fi
insmod hi_ponlink.ko
insmod hi_hilink.ko  #18v1v2的serdies

if [ $flashtype_v5 = 1 ]; then     
	insmod hi_crg.ko pPhyPatchPath=$phy_ponlink_path g_pSerdesFirmwarePath=$phy_ponlink_path
	insmod hi_gemac.ko
	insmod hi_xgemac.ko
	insmod hi_pcs.ko
	insmod hi_dp.ko gemport_expand=1
else
    if [ -f $sdk_path/hi_crg.ko ]; then
        insmod hi_crg.ko pPhyPatchPath=$phy_ponlink_path g_pSerdesFirmwarePath=$phy_ponlink_path
        insmod hi_gemac.ko
        insmod hi_xgemac.ko
        insmod hi_pcs.ko
    fi

	if [ $tempChipType -eq 5115 ]; then
		insmod hi_dp_5115.ko    
	else    
		insmod hi_dp.ko
	fi
fi
    insmod hi_bridge.ko

	
#加载多芯片注册KO
if [ -f /lib/modules/wap/hw_module_multichip.ko ]; then
    insmod /lib/modules/wap/hw_module_multichip.ko
fi
	
    insmod /lib/modules/hisi_sdk/hi_pie.ko tx_chk=0
    insmod hi_ponlp.ko
	
if [ ! -f /mnt/jffs2/xpon_mode ]; then
   if [ ${var_xpon_mode} == "4" ]; then
        echo '1' > /mnt/jffs2/xpon_mode
   elif [ ${var_xpon_mode} == "12" ] || [ ${var_xpon_mode} == "17" ]; then
        echo '5' > /mnt/jffs2/xpon_mode
    elif [ ${var_xpon_mode} == "15" ]; then
        echo '10' > /mnt/jffs2/xpon_mode
   else
        echo ${var_xpon_mode} > /mnt/jffs2/xpon_mode
   fi
fi

chown -h 3003:1000 /mnt/jffs2/xpon_mode && chmod 640 /mnt/jffs2/xpon_mode

if [ ${var_xpon_mode} == "4" ] || [ ${var_xpon_mode} == "12" ] || [ ${var_xpon_mode} == "15" ] || [ ${var_xpon_mode} == "17" ]; then
    pon_type_value=`cat /mnt/jffs2/xpon_mode`
else
    pon_type_value=${var_xpon_mode}
fi

#融合CPE需要同时启动gpon和xgpon，hw_module_ploam_proxy是否存在判断融合CPE
if [ -f /lib/modules/wap/hw_module_ploam_proxy.ko ]; then
    insmod hi_xgmac.ko
    insmod hi_gmac.ko
    insmod hi_gpon.ko
elif [ ${var_xpon_mode} == "5" ] || [ ${pon_type_value} == "5" ]; then	
    insmod hi_xgmac.ko
    insmod hi_xgpon.ko
    insmod hi_emac.ko
    insmod hi_epon.ko
    if [ $flashtype_v5 = 1 ]; then 	
        insmod hi_gpon.ko
    elif [ -f $sdk_path/hi_gpon.ko ]; then
        insmod hi_gpon.ko
    fi
elif [ ${var_xpon_mode} == "6" ] || [ ${pon_type_value} == "6" ]; then
	insmod hi_xemac.ko
	insmod hi_xepon.ko
    if [ $flashtype_v5 = 1 ]; then 	
	insmod hi_epon.ko
    elif [ -f $sdk_path/hi_epon.ko ]; then
         insmod hi_epon.ko
     fi
elif [ ${var_xpon_mode} == "7" ]; then
	insmod hi_xemac.ko
	insmod hi_xepon.ko	
    if [ $flashtype_v5 = 1 ]; then
        insmod hi_epon.ko
    elif [ -f $sdk_path/hi_epon.ko ]; then
        insmod hi_epon.ko
     fi
elif [ ${var_xpon_mode} == "10" ] || [ ${pon_type_value} == "10" ]; then
    insmod hi_xgmac.ko
    insmod hi_xgpon.ko
    insmod hi_emac.ko
    insmod hi_epon.ko
    if [ $flashtype_v5 = 1 ]; then
        insmod hi_gpon.ko
    elif [ -f $sdk_path/hi_gpon.ko ]; then
        insmod hi_gpon.ko
     fi
elif [ ${var_xpon_mode} == "1" ] || [ ${pon_type_value} == "1" ]; then
        insmod hi_gmac.ko
        insmod hi_gpon.ko
        insmod hi_emac.ko
        insmod hi_epon.ko
elif [ ${var_xpon_mode} == "2" ] || [ ${pon_type_value} == "2" ]; then
        insmod hi_emac.ko
	    insmod hi_epon.ko
        insmod hi_gmac.ko
        insmod hi_gpon.ko
else
    insmod hi_gmac.ko
    insmod hi_emac.ko
    insmod hi_gpon.ko
    insmod hi_epon.ko
fi

#特殊接口在此ko中初始化注册，仅限GPON产品加载
if [ ${var_xpon_mode} == "1" ] || [ ${var_xpon_mode} == "5" ] || [ ${var_xpon_mode} == "10" ] ||\
    [ ${pon_type_value} == "1" ] || [ ${pon_type_value} == "5" ] || [ ${pon_type_value} == "10" ]; then
    insmod /lib/modules/hisi_sdk/hi_gpon_api_regist.ko
fi

if [ $tempChipType -eq 5115 ]; then
    insmod hi_l3_5115.ko
else    	
    insmod hi_l3.ko
fi    
    insmod hi_oam.ko

cd /
if [ -f /var/TsdkFs/lib/modules/hisi_cdk/libhs_sd5182_sdk_rtos.ko ]; then
    insmod /var/TsdkFs/lib/modules/hisi_cdk/libhs_sd5182_sdk_rtos.ko
elif [ -f /lib/modules/hisi_cdk/libhs_sd5182_sdk_rtos.ko ]; then
    insmod /lib/modules/hisi_cdk/libhs_sd5182_sdk_rtos.ko
fi
if [ -f /var/TsdkFs/lib/modules/hisi_cdk/libhs_sd5182_nse_rtos.ko ]; then
    insmod /var/TsdkFs/lib/modules/hisi_cdk/libhs_sd5182_nse_rtos.ko
elif [ -f /lib/modules/hisi_cdk/libhs_sd5182_nse_rtos.ko ]; then
    insmod /lib/modules/hisi_cdk/libhs_sd5182_nse_rtos.ko
fi

if [ -f /mnt/jffs2/aging/request_mbist ] && [ ! -f /mnt/jffs2/aging/mbist_end ]; then
    echo " find request_mbist , no mbist_end , not imsmod np.ko "
else
if [ -f /var/TsdkFs/lib/modules/hisi_cdk/hal_np.ko ]; then
    insmod /var/TsdkFs/lib/modules/hisi_cdk/hal_np.ko
elif [ -f /lib/modules/hisi_cdk/hal_np.ko ]; then
    insmod /lib/modules/hisi_cdk/hal_np.ko
fi

if [ -f $sdk_path/hi_woe.ko ]; then
    insmod $sdk_path/hi_woe.ko
fi
fi

# set lanmac 
getlanmac $HW_LANMAC_TEMP
if [ 0  -eq  $? ]; then
    read HW_BOARD_LANMAC < $HW_LANMAC_TEMP
    echo "ifconfig eth0 hw ether $HW_BOARD_LANMAC"
    ifconfig eth0 hw ether $HW_BOARD_LANMAC
fi

# delete temp lanmac file
if [ -f $HW_LANMAC_TEMP ]; then
    rm -f $HW_LANMAC_TEMP
fi
unset HW_LANMAC_TEMP

mkdir /var/tmp

echo "Loading the EchoLife WAP modules: LDSP"


insmod /lib/modules/wap/hw_module_common.ko
insmod /lib/modules/wap/hw_module_bus.ko
insmod /lib/modules/wap/hw_module_dev.ko
if [ -f /lib/modules/wap/hw_module_extgpio.ko ];then
    insmod /lib/modules/wap/hw_module_extgpio.ko
fi

if [ -f /lib/modules/wap/hw_module_cdk.ko ];then
    dir_cdk_para=/var/amp_cdk_para
    mkdir -p $dir_cdk_para && ontchown 3003:2002 $dir_cdk_para && ontchmod 640 $dir_cdk_para
    insmod /lib/modules/wap/hw_module_cdk.ko
fi
if [ -f /mnt/jffs2/defaultGroup.bin ]; then
    rm /mnt/jffs2/defaultGroup.bin
fi

# activate ethernet drivers
ifconfig lo up
ifconfig eth0 192.168.100.1 up
ifconfig eth0 mtu 1500

chmod 640 /var/board_cfg.txt
#判断硬件能力集，按需加载
soc_type=`cat /var/board_cfg.txt | grep bob_type|cut -d ';' -f 3|cut -d '=' -f 2`
bob_type=`cat /var/board_cfg.txt | grep bob_type|cut -d ';' -f 6|cut -d '=' -f 2`
slic_type=`cat /var/board_cfg.txt | grep board_id|cut -d ';' -f 4|cut -d '=' -f 2` 
ext_phy_type=`cat /var/board_cfg.txt | grep ext_phy_type|cut -d ';' -f 5|cut -d '=' -f 2`
support_usb=`cat /var/board_cfg.txt | grep usb|cut -d ';' -f 8|cut -d '=' -f 2` 
support_sd=`cat /var/board_cfg.txt | grep sd|cut -d ';' -f 9|cut -d '=' -f 2` 
support_rf=`cat /var/board_cfg.txt | grep rf|cut -d ';' -f 10|cut -d '=' -f 2` 
support_battery=`cat /var/board_cfg.txt | grep battery|cut -d ';' -f 11|cut -d '=' -f 2` 
support_iot=`cat /var/board_cfg.txt | grep iot|cut -d ';' -f 12|cut -d '=' -f 2` 
support_nfc=`cat /var/board_cfg.txt | grep nfc|cut -d ';' -f 13|cut -d '=' -f 2` 
support_lte=`cat /var/board_cfg.txt | grep lte|cut -d ';' -f 14|cut -d '=' -f 2`
pse_type=`cat /var/board_cfg.txt | grep pse_type|cut -d ';' -f 15|cut -d '=' -f 2`
support_rs485=`cat /var/board_cfg.txt | grep rs485|cut -d ';' -f 16|cut -d '=' -f 2`
ext_lsw_type=`cat /var/board_cfg.txt | grep ext_lsw_type|cut -d ';' -f 17|cut -d '=' -f 2`
support_motor=`cat /var/board_cfg.txt | grep motor|cut -d ';' -f 18|cut -d '=' -f 2`
support_pll=`cat /var/board_cfg.txt | grep pll|cut -d ';' -f 19|cut -d '=' -f 2`

echo "soc_type= $soc_type, bob_type= $bob_type, ext_phy_type= $ext_phy_type, ext_lsw_type= $ext_lsw_type, support_motor= $support_motor, support_pll= $support_pll"
echo "support_usb= $support_usb, support_sd= $support_sd, support_rf= $support_rf, support_battery= $support_battery, support_iot= $support_iot, support_nfc= $support_nfc, support_lte= $support_lte, pse_type=$pse_type"

smoothTtreeDef -ttree /mnt/jffs2/ttree_spec_smooth.tar.gz 
smoothTtreeDef -spec /mnt/jffs2/encrypt_spec_key.tar.gz > /dev/null
insmod /lib/modules/wap/hw_dm_pdt.ko

reload_feature="/proc/wap_proc/feature"
if [ -f $reload_feature ];then
    echo "Reload" > $reload_feature
else
    insmod /lib/modules/wap/hw_module_feature.ko
fi

rm -rf /var/spec/
insmod /lib/modules/wap/hw_module_optic.ko
#关键文件校验log恢复
ProcDataWh -l

if [ $soc_type == HWSOC3 ] || [ $soc_type == HWSOC4 ] || [ $soc_type == HWSOC5 ] || [ $soc_type == SD5118V2 ] || [ $soc_type == HWSOC7 ] || [ $soc_type == HWSOC8 ] || [ $soc_type == HWSOC9 ]; then
    if [ -f $sdk_path/hi_ipsec.ko ]; then
        insmod $sdk_path/hi_ipsec.ko
        echo "insmod hi_ipsec.ko"
    fi
fi

if [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "6" ] || [ ${var_xpon_mode} == "7" ]; then
	insmod /lib/modules/wap/hw_ker_optic_chip_511x_epon.ko
elif [ ${var_xpon_mode} == "1" ] || [ ${var_xpon_mode} == "5" ] || [ ${var_xpon_mode} == "10" ]; then
	insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
elif [ ${var_xpon_mode} == "4" ]; then
    echo "adapt pon_mode : $pon_type_value"
    if [ ${pon_type_value} == "1" ]; then
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
    else
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_epon.ko
    fi
elif [ ${var_xpon_mode} == "12" ]; then
    echo "adapt pon_mode : $pon_type_value"
    if [ ${pon_type_value} == "5" ]; then
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
    else
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_epon.ko
    fi
elif [ ${var_xpon_mode} == "15" ] || [ ${var_xpon_mode} == "17" ]; then
    insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
else
    insmod /lib/modules/wap/hw_ker_optic_chip_511x_epon.ko
    insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
fi

insmod /lib/modules/wap/hw_ker_optic_chip_511x_equip.ko

#gpon xgpon 自适应 不开启bob探测
gpon_xgpon_auto_ft=`GetFeature FT_GPON_XGPON_AUTO_ADAPT`
if [ $gpon_xgpon_auto_ft -eq 1 ]; then
    rm -rf /mnt/jffs2/chip_auto_match/bob_chiptype
    rm -rf /mnt/jffs2/bob_up_type
fi

dir_chip_auto_match=/mnt/jffs2/chip_auto_match
bob_chiptype=`cat $dir_chip_auto_match/bob_chiptype`

#V5 版本只做以下光phy
echo " bob_type read from chip_auto_match is: "$bob_chiptype

#M2013 Gpon/Epon光phy
if [[ $(echo $bob_chiptype | grep "M02103")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_m02103.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_m02103.ko
#HN5176 Gpon/Epon光phy
elif [[ $(echo $bob_chiptype | grep "HN5176")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_hn5176.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_hn5176.ko
#HU5176 Gpon/Epon光phy
elif [[ $(echo $bob_chiptype | grep "UX5176")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_ux5176.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_ux5176.ko
elif [[ $(echo $bob_chiptype | grep "UX5176S")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_ux5176.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_ux5176.ko
elif [[ $(echo $bob_chiptype | grep "GNA4221")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_ux5176.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_ux5176.ko
#SD5175不带MCU版本 XGpon/XEpon
elif [[ $(echo $bob_chiptype | grep "SD5175v300")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_sd5175v300.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_sd5175v300.ko
#GN7355带MCU版本 XGpon/XEpon
elif [[ $(echo $bob_chiptype | grep "GN7355")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_sd5175.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_sd5175.ko
#HN5171/UX5171 XGSPON
#HN5170/UX5170 XGPON
elif [[ $(echo $bob_chiptype | grep "5171")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_517x.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_517x.ko
elif [[ $(echo $bob_chiptype | grep "5170")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_517x.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_517x.ko
else
    echo "borad cfg bob type is "$bob_type

    mkdir -p $dir_chip_auto_match && ontchown 3003:1200 $dir_chip_auto_match && ontchmod 640 $dir_chip_auto_match
    # 如果没有匹配到芯片类型，就把bob_chiptype删掉，走老流程
    rm -rf $dir_chip_auto_match/bob_chiptype

    if [ $bob_type == M02103 ] || [ $bob_type == HN5176 ] || [ $bob_type == UX5176 ] || [ $bob_type == UX5176S ] || [ $bob_type == GNA4221 ]; then
        echo "G/E pon bob group"
        #M2013 Gpon/Epon光phy
        if [ -f /lib/modules/wap/hw_ker_optic_m02103.ko ]; then
            insmod /lib/modules/wap/hw_ker_optic_m02103.ko
        fi
        #HN5176 Gpon/Epon光phy
        if [ -f /lib/modules/wap/hw_ker_optic_hn5176.ko ]; then
            insmod /lib/modules/wap/hw_ker_optic_hn5176.ko
        fi
        #HU5176 Gpon/Epon光phy
        if [ -f /lib/modules/wap/hw_ker_optic_ux5176.ko ]; then
            insmod /lib/modules/wap/hw_ker_optic_ux5176.ko
        fi
    elif [ $bob_type == SD5175v300 ] || [ $bob_type == GN7355 ] || [ $bob_type == HN517X ] || [ $bob_type == UX517X ]; then
        echo "XG/XE pon bob group"
        #SD5175不带MCU版本 XGpon/XEpon
        if [ -f /lib/modules/wap/hw_ker_optic_sd5175v300.ko ]; then
            insmod /lib/modules/wap/hw_ker_optic_sd5175v300.ko
        fi
        #GN7355带MCU版本 XGpon/XEpon
        if [ -f /lib/modules/wap/hw_ker_optic_sd5175.ko ]; then
            insmod /lib/modules/wap/hw_ker_optic_sd5175.ko
        fi

        #HN517X新芯片，这个必须要放在最后面，样片读不到chip，默认为HN5170!!!
        #HN5171/UX5171 XGSPON
        #HN5170/UX5170 XGPON
        if [ -f /lib/modules/wap/hw_ker_optic_517x.ko ]; then
            insmod /lib/modules/wap/hw_ker_optic_517x.ko
        fi
    elif [ $bob_type == UX517X_COMBO ]; then
        if [ -f /lib/modules/wap/hw_ker_optic_ux5176.ko ]; then
            insmod /lib/modules/wap/hw_ker_optic_ux5176.ko
        fi
        if [ -f /lib/modules/wap/hw_ker_optic_517x.ko ]; then
            insmod /lib/modules/wap/hw_ker_optic_517x.ko
        fi
    fi
fi

#下行光phy初始化
uni_bob_chiptype=`cat $dir_chip_auto_match/uni_bob_chiptype`
if [[ $(echo $uni_bob_chiptype | grep "GNA4215")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_gna4215.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_gna4215.ko
elif [[ $(echo $uni_bob_chiptype | grep "UX3326")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_ux3326.ko  ]; then
    insmod /lib/modules/wap/hw_ker_optic_ux3326.ko
else
    #配置失败，删除配置文件，按老流程加载
    rm -rf $dir_chip_auto_match/uni_bob_chiptype
    if [ -f /lib/modules/wap/hw_ker_optic_gna4215.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_gna4215.ko
    fi
    if [ -f /lib/modules/wap/hw_ker_optic_ux3326.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_ux3326.ko
    fi
fi

# slave chip
if [ -f /lib/modules/wap/hal_module_slave_chip.ko ]; then
    insmod /lib/modules/wap/hw_module_spi.ko
    insmod /lib/modules/wap/hal_module_slave_chip.ko
    insmod /lib/modules/wap/hal_slave_chip_sd511x.ko
fi

# poe ko
if [ -f /lib/modules/wap/hw_module_poe.ko ]; then
    insmod /lib/modules/wap/hw_module_poe.ko
    if [ $pse_type == rtk8238 ]; then
        insmod /lib/modules/wap/hw_module_spi.ko
        insmod /lib/modules/wap/hw_ker_poe_rtk8238.ko
    fi
fi

if [ -f /lib/modules/wap/hw_module_poe_monitor.ko ]; then
    insmod /lib/modules/wap/hw_module_poe_monitor.ko
fi

if [ $support_battery == Y ];then
	insmod /lib/modules/wap/hw_module_uart.ko
fi

if [ $support_rf == Y ];then
  insmod /lib/modules/wap/hw_module_rf.ko
fi

if [ $support_rs485 == Y ]; then
    insmod /lib/modules/wap/hw_module_uart.ko
fi

# motor ko
if [ $support_motor == Y ]; then
    insmod /lib/modules/wap/hw_module_motor.ko
fi

# pll ko
if [ $support_pll == Y ]; then
    insmod /lib/modules/wap/hw_module_pll.ko
    insmod /lib/modules/wap/hw_ker_pll_au53x5.ko
    insmod /lib/modules/wap/hw_ker_pll_sa77xx.ko
    insmod /lib/modules/wap/hw_ker_pll_si53xx.ko
fi

tianyi_cut_128=`cat /proc/mtd | grep "exrootfs" | wc -l`

flashtype_v5=`cat /proc/mtd | grep "ubilayer" | wc -l`

if [ $tianyi_cut_128 = 1 ] && [ $flashtype_v5 = 1 ]; then
	echo "start load tianyi_cut ex rootfs"
	touch /var/tianyi_cut_128
fi

if [ $soc_type == HWSOC3 ] || [ $soc_type == HWSOC4 ] || [ $soc_type == HWSOC5 ] || [ $soc_type == SD5118V2 ] || [ $soc_type == HWSOC7 ] || [ $soc_type == HWSOC8 ] || [ $soc_type == HWSOC9 ]; then
    if [ -f /lib/modules/wap/hw_module_sec.ko ];then
        insmod /lib/modules/wap/hw_module_sec.ko
    fi
fi

# V5系列，均起loadexfs。
# 此处需要添加上V3的HS8145C
if [ $flashtype_v5 = 1 ] || [ $tianyi_cut_128 = 1 ]; then
	echo "load ex rootfs"
	mkdir /var/image & chmod 770 /var/image
	loadexfs
fi

need_support_wifi=`GetFeature HW_AMP_FEATURE_WLAN`
if [ $need_support_wifi = 1 ]; then
    if [ -f /lib/modules/linux/extra/arch/arm/mach-hisi/pcie.ko ]; then
        insmod /lib/modules/linux/extra/arch/arm/mach-hisi/pcie.ko
        insmod /lib/modules/wap/hw_module_acp.ko
    fi
fi

if [ $support_nfc == Y ];then
    insmod /lib/modules/wap/hw_module_nfc_st.ko
    insmod /lib/modules/wap/hw_module_nfc.ko
    insmod /lib/modules/wap/hw_module_nfc_nta5332.ko
    insmod /lib/modules/wap/hw_module_nfc_fm11nc.ko
fi
 
###外置phy处理
if [[ $ext_phy_type != "NONE" ]] ; then
    insmod /lib/modules/wap/hw_module_mdio.ko
    insmod /lib/modules/wap/hw_module_phy.ko
fi

###按配置加载外置ext phy ko
exphy_chiptype=`cat /mnt/jffs2/chip_auto_match/extphy_chiptype`
echo " exphy_chiptype read from chip_auto_match is: "$exphy_chiptype
exphy_chip_auto_match_success=0
if [[ $(echo $exphy_chiptype | grep "BCM")"NOEXIST" != "NOEXIST" ]]; then
    insmod /lib/modules/wap/hw_ker_phy_bcm84881.ko
    exphy_chip_auto_match_success=1
fi
if [[ $(echo $exphy_chiptype | grep "RTL8211")"NOEXIST" != "NOEXIST" ]]; then
    insmod /lib/modules/wap/hal_extphy_rtl8211.ko
    exphy_chip_auto_match_success=1
fi
if [[ $(echo $exphy_chiptype | grep "RTL8226")"NOEXIST" != "NOEXIST" ]]; then
    insmod /lib/modules/wap/hw_ker_phy_rtl8266.ko
    exphy_chip_auto_match_success=1
fi
if [[ $(echo $exphy_chiptype | grep "RTL8261")"NOEXIST" != "NOEXIST" ]]; then
    insmod /lib/modules/wap/phy_sdk_rtl8261.ko
    insmod /lib/modules/wap/hal_extphy_rtl8261.ko
    exphy_chip_auto_match_success=1
fi
if [[ $(echo $exphy_chiptype | grep "YT8521")"NOEXIST" != "NOEXIST" ]]; then
    insmod /lib/modules/wap/hal_extphy_yt8521.ko
    exphy_chip_auto_match_success=1
fi
if [[ $(echo $exphy_chiptype | grep "QCA")"NOEXIST" != "NOEXIST" ]]; then
    insmod /lib/modules/wap/hal_extphy_qca8081.ko
    exphy_chip_auto_match_success=1
fi
if [[ $(echo $exphy_chiptype | grep "YT8821")"NOEXIST" != "NOEXIST" ]]; then
    insmod /lib/modules/wap/hal_extphy_yt8821.ko
    exphy_chip_auto_match_success=1
fi

if [ ${exphy_chip_auto_match_success} == "0" ] ; then
    mkdir -p $dir_chip_auto_match && ontchown 3003:1200 $dir_chip_auto_match && ontchmod 640 $dir_chip_auto_match
    rm -rf /mnt/jffs2/chip_auto_match/extphy_chiptype
    if [[ $(echo $ext_phy_type | grep "RTL8211")"NOEXIST" != "NOEXIST" ]] ; then
        insmod /lib/modules/wap/hal_extphy_rtl8211.ko
    fi
    if [[ $(echo $ext_phy_type | grep "YT8521")"NOEXIST" != "NOEXIST" ]] ; then
        insmod /lib/modules/wap/hal_extphy_yt8521.ko
    fi
    if [[ $(echo $ext_phy_type | grep "BCM84881")"NOEXIST" != "NOEXIST" ]] ; then
        insmod /lib/modules/wap/hw_ker_phy_bcm84881.ko
    fi
    if [[ $(echo $ext_phy_type | grep "RTL8226")"NOEXIST" != "NOEXIST" ]] ; then
        insmod /lib/modules/wap/hw_ker_phy_rtl8266.ko
    fi
    if [[ $(echo $ext_phy_type | grep "RTL8261")"NOEXIST" != "NOEXIST" ]] ; then
        insmod /lib/modules/wap/phy_sdk_rtl8261.ko
        insmod /lib/modules/wap/hal_extphy_rtl8261.ko
    fi
    if [[ $(echo $ext_phy_type | grep "QCA8081")"NOEXIST" != "NOEXIST" ]] ; then
        insmod /lib/modules/wap/hal_extphy_qca8081.ko
    fi
    if [[ $(echo $ext_phy_type | grep "YT8821")"NOEXIST" != "NOEXIST" ]] ; then
        insmod /lib/modules/wap/hal_extphy_yt8821.ko
    fi
fi

if [ $ext_lsw_type == RTL8366 ];then
    insmod /lib/modules/wap/hw_module_extlsw.ko
    insmod /lib/modules/wap/hw_ker_eth_rtl8366.ko
fi

insmod /lib/modules/wap/hw_module_amp.ko
insmod /lib/modules/wap/hw_module_l2qos.ko

#融合CPE需要同时启动gploam和xgploam，hw_module_ploam_proxy.ko只有两个协议栈同时启动才需要，因此用来判断gploam和xgploam同时启动
if [ -f /lib/modules/wap/hw_module_ploam_proxy.ko ]; then
        insmod /lib/modules/wap/hw_module_gmac.ko
        insmod /lib/modules/wap/hw_module_xgploam.ko
        insmod /lib/modules/wap/hw_module_ploam.ko
        insmod /lib/modules/wap/hw_module_ploam_proxy.ko
elif [ ${var_xpon_mode} == "4" ]; then
    if [ ${pon_type_value} == "1" ]; then
        insmod /lib/modules/wap/hw_module_gmac.ko
        insmod /lib/modules/wap/hw_module_ploam.ko
    else
        insmod /lib/modules/wap/hw_module_emac.ko
        insmod /lib/modules/wap/hw_module_mpcp.ko
    fi
elif [ ${var_xpon_mode} == "12" ]; then
    if [ ${pon_type_value} == "5" ]; then
        insmod /lib/modules/wap/hw_module_gmac.ko
        insmod /lib/modules/wap/hw_module_xgploam.ko
    else
        insmod /lib/modules/wap/hw_module_emac.ko
        insmod /lib/modules/wap/hw_module_mpcp.ko
    fi
elif [ ${var_xpon_mode} == "17" ]; then
    insmod /lib/modules/wap/hw_module_gmac.ko
    if [ ${pon_type_value} == "5" ]; then
        insmod /lib/modules/wap/hw_module_xgploam.ko
    else
        insmod /lib/modules/wap/hw_module_ploam.ko
    fi
elif [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "6" ] || [ ${var_xpon_mode} == "7" ]; then
	insmod /lib/modules/wap/hw_module_emac.ko
	insmod /lib/modules/wap/hw_module_mpcp.ko
else
	if [ -f /lib/modules/wap/hw_module_ppm.ko ];then
		insmod /lib/modules/wap/hw_module_ppm.ko
	fi
	
	insmod /lib/modules/wap/hw_module_gmac.ko
	if [ ${var_xpon_mode} == "5" ] || [ ${var_xpon_mode} == "10" ] || [ ${var_xpon_mode} == "15" ] ; then	
		insmod /lib/modules/wap/hw_module_xgploam.ko
	else
		insmod /lib/modules/wap/hw_module_ploam.ko
	fi
fi

[ -f /lib/modules/linux/kernel/drivers/block/loop.ko ] && insmod lib/modules/linux/kernel/drivers/block/loop.ko

#判断/mnt/jffs2/customize_xml.tar.gz文件是否存在，存在解压
if [ -e /mnt/jffs2/customize_xml.tar.gz ]
then
    #解析customize_relation.cfg
    tar -xzf /mnt/jffs2/customize_xml.tar.gz -C /mnt/jffs2/ customize_xml/customize_relation.cfg  
fi

#HN8145XR 三大T合一bin
function china_allbin_process()
{
    local osgi_block=$1
    mkdir -p /mnt/jffs2/plug
    mount -t ubifs -o sync /$osgi_block /mnt/jffs2/plug
    if [ ! -f "/mnt/jffs2/mount_apps_ok" ]; then
        echo "mount_apps_ok" > "/mnt/jffs2/mount_apps_ok"
        umount /mnt/jffs2/plug
        mount -t ubifs -o sync $osgi_block /mnt/jffs2/plug
        if [  $? != 0  ] || [ ! -f "/mnt/jffs2/mount_apps_ok" ]; then
                echo "Failed to mount apps, reboot system" | ls -l /mnt/jffs2
                reboot
        fi
    fi
    mkdir -p /mnt/jffs2/plug/app
    rm -rf /mnt/jffs2/app
    [ ! -L /mnt/jffs2/app ] && ln -s /mnt/jffs2/plug/app /mnt/jffs2/app
}

#老的移动联通单板
function old_osgibin_process()
{
    local osgi_block=$1
    #老流程
    if [ -c "$osgi_block" ]; then
        if [ ! -d "/mnt/jffs2/app" ]; then
            mkdir /mnt/jffs2/app
        fi
        mount -t ubifs -o sync $osgi_block /mnt/jffs2/app
        if [ ! -f "/mnt/jffs2/mount_osgi_ok" ]; then
            echo "mount_ok" > "/mnt/jffs2/mount_osgi_ok"
            umount /mnt/jffs2/app
            mount -t ubifs -o sync $osgi_block /mnt/jffs2/app
            if [  $? != 0  ] || [ ! -f "/mnt/jffs2/mount_osgi_ok" ]; then
                echo "Failed to mount app, reboot system" | ls -l /mnt/jffs2/app
                reboot
            fi
        fi
    fi
}

function mount_app_system()
{
#通过特性开关来挂载opt
    echo "@@@@@@ ctrg_support is $ctrg_support @@@ cuc_support is $cuc_support@@@@@@"
    if [ $tianyi_cut_128 = 0 ]; then 
        if [ $ctrg_support = 1 ] || [ $cuc_support = 1 ] ;then
            if [ $flashtype_v5 = 1 ];then
                apps_block=ubi0_12
            else
                apps_block=ubi0_16
            fi

            #挂载C系统网关要求的分区目录，framework1和framework2由中间件挂载，/opt/upt/apps
            mkdir -p /mnt/jffs2/plug
            mount -t ubifs -o sync /dev/$apps_block /mnt/jffs2/plug
            if [ ! -f "/mnt/jffs2/mount_apps_ok" ]; then
                echo "mount_apps_ok" > "/mnt/jffs2/mount_apps_ok"
                umount /mnt/jffs2/plug
                mount -t ubifs -o sync /dev/$apps_block /mnt/jffs2/plug
                if [  $? != 0  ] || [ ! -f "/mnt/jffs2/mount_apps_ok" ]; then
                    echo "Failed to mount apps, reboot system" | ls -l /mnt/jffs2
                    reboot
                fi
            fi
    
            mkdir -p /mnt/jffs2/plug/app
            mkdir -p /mnt/jffs2/plug/apps
            rm -rf /mnt/jffs2/app
            [ ! -L /mnt/jffs2/app ] && ln -s /mnt/jffs2/plug/app /mnt/jffs2/app

            #电信天翼网关挂载cgroup
            cgroot="/sys/fs/cgroup"
            subsys="blkio cpu cpuacct cpuset devices freezer memory"
            mount -t tmpfs cgroup_root "${cgroot}"
            for ss in $subsys; do
                mkdir -p "$cgroot/$ss"
                mount -t cgroup -o "$ss" "$ss" "$cgroot/$ss"
            done
            echo "ctrg cgroup mount done!"
     
            chmod 755 /mnt/jffs2/plug
            chmod 750 /mnt/jffs2/plug/app;chown -h osgi_proxy:osgi /mnt/jffs2/plug/app
            chmod 755 /mnt/jffs2/plug/apps
        else
            # 判断是否是UBI的单板
            broad_not_ubi=$(cat /proc/mtd | grep "bootpara" | wc -l)
            echo "broad_not_ubi is $broad_not_ubi"
            if [ $broad_not_ubi = 1 ];then
                osgi_block=/dev/ubi0_5
            else
                # 判断是128M还是256M，UBI单板128M无app分区，256M有app分区
                broad_ubi_256=$(cat /proc/mtd | grep "app_system" | wc -l)
                if [ $broad_ubi_256 = 1 ];then
                    osgi_block=/dev/ubi0_10
                fi
            fi
            #三大T合一单板存在framework分区,为ubi_12
            osgi_hasframe=$(cat /proc/mtd | grep "frameworkA" | wc -l)
            if [ $osgi_hasframe = 1 ]; then # HN8145XR  三大T合一bin，osgi_block需要挂载 到/dev/ubi0_12
                osgi_block=/dev/ubi0_12
                echo "osgi_block_ is: $osgi_block"
            fi
            osgi_hasframe=$(cat /proc/mtd | grep "frameworkA" | wc -l)
            echo "osgi_hasframe is $osgi_hasframe"
            if [ $osgi_hasframe = 1 ]; then # HN8145XR  三大T合一bin，osgi_block需要挂载 到/dev/ubi0_12
                echo "china_allbin_process"
                china_allbin_process $osgi_block
            else
                echo "old_osgibin_process"
                old_osgibin_process $osgi_block
            fi
        fi
    fi

    touch /var/app_mount_complete
    return 0
}

#mount app分区
while true; do
    sleep 1
    if [ -f /var/init_complete ]; then
        mount_app_system &
        break;
    fi
done &

loadsdkfs

. /usr/bin/init_topo_info.sh

ctrg_support=`GetFeature HW_SSMP_FEATURE_CTRG`
cuc_support=`GetFeature FEATURE_CU_DBUS`

if [ $cuc_support = 1 ]; then
	framework_dir=cu
else
	framework_dir=upt
fi

if [ $tianyi_cut_128 = 0 ]; then 
	if [ $ctrg_support = 1 ] || [ $cuc_support = 1 ] ;then
		echo "start load ex rootfs"
		mkdir -p /var/image & chmod 750 /var/image
		loadexfs
	fi
fi

if [ -f /mnt/jffs2/Equip_MU_UpGRD_Flag ]
then
    pots_num=0
    usb_num=0
    ssid_num=0
fi
echo "pots_num="$pots_num
echo " usb_num="$usb_num
echo "hw_route="$hw_route
echo "   l3_ex="$l3_ex
echo "    ipv6="$ipv6

mem_totalsize=`cat /proc/meminfo | grep MemTotal | cut -c11-22`
echo "Read MemInfo Des:"$mem_totalsize

# pots ko fpga依赖hw_ker_codec_pef31002.ko,后续要挪一下
if [ $pots_num -ne 0 ] || [ -f /lib/modules/wap/hw_module_fpga.ko ]
then
    insmod $sdk_path/hi_hw.ko
    insmod /lib/modules/wap/hw_module_highway.ko
    insmod /lib/modules/wap/hw_module_spi.ko
    insmod /lib/modules/wap/hw_module_codec.ko

    if [ $slic_type == SI32176 ]; then
        insmod /lib/modules/wap/codec_sdk_si3217x.ko
        insmod /lib/modules/wap/hw_ker_codec_si32176.ko
    elif [ $slic_type == PEF3201 ]; then
        insmod /lib/modules/wap/hw_ker_codec_pef3201.ko
    elif [ $slic_type == PEF3100x ]; then
        insmod /lib/modules/wap/hw_ker_codec_pef31002.ko
    elif [ $slic_type == LE964x ]; then
        insmod /lib/modules/wap/codec_sdk_le964x.ko
        insmod /lib/modules/wap/hw_ker_codec_le964x.ko
    elif [ $slic_type == N68x38x ]; then
        insmod /lib/modules/wap/hw_ker_codec_n68x38x.ko
    elif [ $slic_type == AUTO_MATCH ]; then
        slic_chiptype=`cat $dir_chip_auto_match/slic_chiptype`
        echo " slic_chiptype read from chip_auto_match is: "$slic_chiptype

        # 根据 chip_auto_match 中记录的芯片类型加载ko
        if [[ $(echo $slic_chiptype | grep "LE964x")"NOEXIST" != "NOEXIST" ]]; then
            insmod /lib/modules/wap/codec_sdk_le964x.ko
            insmod /lib/modules/wap/hw_ker_codec_le964x.ko
        elif [[ $(echo $slic_chiptype | grep "PEF3100x")"NOEXIST" != "NOEXIST" ]]; then
            insmod /lib/modules/wap/hw_ker_codec_pef31002.ko
        elif [[ $(echo $slic_chiptype | grep "N68x38x")"NOEXIST" != "NOEXIST" ]]; then
            insmod /lib/modules/wap/hw_ker_codec_n68x38x.ko
        else
            mkdir -p $dir_chip_auto_match && ontchown 3003:1200 $dir_chip_auto_match && ontchmod 640 $dir_chip_auto_match
            # 如果 chip_auto_match 中没有匹配到芯片类型，则删除该文件走原始流程
            rm -rf $dir_chip_auto_match/slic_chiptype
            # first le964x
            if [ -f /lib/modules/wap/hw_ker_codec_le964x.ko ]; then
                insmod /lib/modules/wap/codec_sdk_le964x.ko
                insmod /lib/modules/wap/hw_ker_codec_le964x.ko
            fi

            #second pef3100x
            if [ -f /lib/modules/wap/hw_ker_codec_pef31002.ko ]; then
                insmod /lib/modules/wap/hw_ker_codec_pef31002.ko
            fi

            #third coslic n68x38x
            if [ -f /lib/modules/wap/hw_ker_codec_n68x38x.ko ]; then
                insmod /lib/modules/wap/hw_ker_codec_n68x38x.ko
            fi
        fi
    else
        insmod /lib/modules/wap/hw_ker_codec_ve8910.ko
    fi
fi

# fpga ko
if [ -f /lib/modules/wap/hw_module_fpga.ko ]; then
    insmod $sdk_path/hi_tms.ko
    # hw_module_gmacdrv_olt 依赖hi_tms
    rm -f /var/fpga_load
    insmod /lib/modules/wap/hw_module_fpga.ko
    insmod /lib/modules/wap/hw_module_gmacdrv_olt.ko
    insmod /lib/modules/wap/hw_ker_fpga_xc7a100t.ko
fi

ker_ver=$(cat /proc/version | cut -c15-17)

function insmod_usb()
{
	if [ $usb_num -eq 0 ];then
		return 0
	fi

    if [ -f /lib/modules/linux/extra/drivers/usb/storage/usb-storage.ko ]; then
        cd /lib/modules/linux/
        if [ "$ker_ver" = "4.4" ] || [ "$ker_ver" = "5.1" ]; then
			insmod /lib/modules/linux/extra/drivers/scsi/scsi_mod.ko
			insmod ./kernel/drivers/scsi/scsi_wait_scan.ko	
			insmod /lib/modules/linux/extra/drivers/scsi/sd_mod.ko
			insmod /lib/modules/linux/extra/drivers/usb/common/usb-common.ko
        else
			insmod /lib/modules/linux/kernel/drivers/scsi/scsi_mod.ko
			insmod ./kernel/drivers/scsi/scsi_wait_scan.ko	
			insmod /lib/modules/linux/extra/drivers/scsi/sd_mod.ko
			insmod /lib/modules/linux/extra/drivers/usb/usb-common.ko
        fi
        insmod ./extra/drivers/usb/core/usbcore.ko
        insmod ./extra/drivers/usb/host/hiusb-sd511x.ko
        insmod ./extra/drivers/usb/host/ehci-hcd.ko
        insmod ./extra/drivers/usb/host/ehci-pci.ko
        insmod ./extra/drivers/usb/host/ohci-hcd.ko
        insmod ./extra/drivers/usb/host/xhci-hcd.ko    
	if [ "$ker_ver" = "4.4" ] || [ "$ker_ver" = "5.1" ]; then
	    insmod ./extra/drivers/usb/host/xhci-plat-hcd.ko
	fi
        insmod ./extra/drivers/usb/storage/usb-storage.ko
        insmod ./extra/drivers/usb/class/usblp.ko
        insmod ./extra/drivers/usb/class/cdc-acm.ko
        insmod ./extra/drivers/usb/serial/usbserial.ko
        insmod ./extra/drivers/usb/serial/pl2303.ko
        insmod ./extra/drivers/usb/serial/cp210x.ko
        insmod ./extra/drivers/usb/serial/ch341.ko
        insmod ./extra/drivers/usb/serial/ftdi_sio.ko
        insmod ./extra/drivers/input/input-core.ko
        insmod ./extra/drivers/hid/hid.ko
        insmod ./extra/drivers/hid/usbhid/usbhid.ko
        insmod ./extra/drivers/usb/serial/usbserial.ko
        insmod ./extra/drivers/usb/serial/option.ko

        cd /
        insmod /lib/modules/wap/hw_module_usb.ko
        insmod /lib/modules/wap/smp_usb.ko		    
    fi

	return 0
}

#后台加载usb的ko
insmod_usb &  > /dev/null 2>&1

if [ $support_sd == Y ];then
      cd /lib/modules/linux/
		    insmod ./extra/drivers/mmc/core/mmc_core.ko
		    insmod ./extra/drivers/mmc/card/mmc_block.ko
		    insmod ./extra/drivers/mmc/host/himciv100/himci.ko
		    insmod ./extra/drivers/mmc/host/dw_mmc.ko
		    insmod ./extra/drivers/mmc/host/dw_mmc-pltfm.ko
		    insmod ./extra/drivers/mmc/host/dw_mmc-hisi.ko	    
      cd /

      insmod /lib/modules/wap/hw_module_sd.ko
	    insmod /lib/modules/wap/smp_sd.ko
fi

if [ $support_lte == Y ];then
		cd /lib/modules/linux/
	  	insmod ./extra/drivers/net/usb/hw_cdc_driver.ko
	  	insmod ./extra/drivers/usb/serial/usb_wwan.ko
        insmod /lib/modules/linux/extra/drivers/net/usb/usbnet.ko
        insmod /lib/modules/linux/extra/drivers/usb/class/cdc-wdm.ko
        insmod /lib/modules/linux/extra/drivers/net/usb/cdc_ether.ko
        insmod /lib/modules/linux/extra/drivers/net/usb/cdc_ncm.ko
	  cd /
		  
    insmod /lib/modules/wap/hw_module_datacard.ko
    [ -f /lib/modules/wap/hw_module_datacard_chip_huawei.ko ] && insmod /lib/modules/wap/hw_module_datacard_chip_huawei.ko
fi

feature_dect=`GetFeature FT_LTE_SUPPORT`
if [ $feature_dect -eq 1 ] ;then
    if [ $usb_num -ne 0 ]
    then
        /etc/wap/usb/init_usb.sh
    fi
fi

# AMP_KO
insmod /lib/modules/wap/hw_amp.ko

if [ $support_iot == Y ];then
	insmod /lib/modules/wap/hw_module_uart.ko
	insmod /lib/modules/wap/hw_module_tty.ko
fi

# BBSP_l2_basic
echo "Loading BBSP L2 modules: "
insmod /lib/modules/linux/kernel/drivers/net/slip/slhc.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/ppp_generic.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/pppox.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/pppoe.ko
insmod /lib/modules/wap/commondata.ko
insmod /lib/modules/wap/sfwd.ko
insmod /lib/modules/wap/l2ffwd.ko
insmod /lib/modules/wap/btvfw.ko
insmod /lib/modules/wap/hw_bbsp_lswadp.ko
insmod /lib/modules/wap/hw_ptp.ko
insmod /lib/modules/wap/l2base.ko
insmod /lib/modules/wap/acl.ko
insmod /lib/modules/wap/cpu.ko
insmod /lib/modules/wap/hal_adpt_hisi.ko
insmod /lib/modules/wap/bbsp_l2_adpt.ko

# BBSP_l2_basic end


# BBSP_l2_extended
echo "Loading BBSP L2_extended modules: "
insmod /lib/modules/wap/l2ext.ko

# BBSP_l2_extended end
insmod /lib/modules/wap/qos_adpt.ko

# BBSP_l3_basic
echo "Loading BBSP L3_basic modules: "
insmod /lib/modules/wap/hw_ssp_gpl_ext.ko
[ -f /lib/modules/wap/hw_ssp_gpl_ext_add.ko ] && insmod /lib/modules/wap/hw_ssp_gpl_ext_add.ko

# 依赖hw_ssp_gpl_ext.ko
insmod /lib/modules/wap/hw_module_wifi_bsd.ko
insmod /lib/modules/wap/hw_module_wifi_drv.ko
insmod /lib/modules/wap/hw_module_wifi_log.ko
if [ -f /lib/modules/wap/hw_module_acs.ko ];then
    insmod /lib/modules/wap/hw_module_acs.ko
fi
insmod /lib/modules/wap/hw_module_wifi_gpl.ko

if [ ! -e /mnt/jffs2/wifi_kernel_debug ]; then
	if [ -e /lib/modules/wap/cfg80211.ko ]; then
		insmod /lib/modules/wap/cfg80211.ko
	fi

	if [ -e /lib/modules/wap/mhi_core.ko ]; then
		insmod /lib/modules/wap/mhi_core.ko
	fi

	if [ -e /lib/modules/wap/mhi_controllers.ko ]; then
		insmod /lib/modules/wap/mhi_controllers.ko
	fi

	if [ -e /lib/modules/wap/qrtr.ko ]; then
		insmod /lib/modules/wap/qrtr.ko
	fi

	if [ -e /bin/qrtr-cfg ]; then
		qrtr-cfg 1
	fi

	if [ -e /bin/qrtr-ns ]; then
		qrtr-ns &
	fi

	if [ -e /lib/modules/wap/qrtr-mhi.ko ]; then
		insmod /lib/modules/wap/qrtr-mhi.ko
	fi

	if [ -e /lib/modules/wap/qmi_helpers.ko ]; then
		insmod /lib/modules/wap/qmi_helpers.ko
	fi

	if [ -e /lib/modules/wap/qmi_interface.ko ]; then
		insmod /lib/modules/wap/qmi_interface.ko
	fi

	if [ -e /lib/modules/wap/qcom_kern.ko ]; then
		insmod /lib/modules/wap/qcom_kern.ko
	fi

	if [ -e /lib/modules/wap/smem.ko ]; then
		insmod /lib/modules/wap/smem.ko
	fi

	if [ -e /lib/modules/wap/cnss2.ko ]; then
		mix_board=$(GetFeature FT_1151_QCA_MIX_BOARD)
        if [ $mix_board = 1 ]; then
            insmod /lib/modules/wap/cnss2.ko bdf_pci0=0xA0 skip_radio_bmap=5
        else
            insmod /lib/modules/wap/cnss2.ko bdf_pci0=0xA1 bdf_pci1=0xA0 ramdump_enabled=Y
        fi
	fi
fi

#安装wifi ko
if [ $ssid_num -ne 0 ]; then
	wifi_dev=`cat /proc/bus/pci/devices | cut -f 2 | sed -n 1p`
	if [ "$wifi_dev" == "59e70003" ] && [ -e /bin/WifiDyChipInstallKo.sh ]; then
		echo "Loading DY ko: "
		WifiDyChipInstallKo.sh &
	elif [ "$wifi_dev" != "59e70003" ] && [ -e /bin/WifiQcaAxInstallKo.sh ]; then
		echo "Loading QCA AX ko: "
		WifiQcaAxInstallKo.sh&
	fi
fi

echo 16000 > /proc/sys/net/nf_conntrack_max 2>>/var/xcmdlog

echo 1 > proc/sys/net/netfilter/nf_conntrack_tcp_be_liberal 2>>/var/xcmdlog

iptables-restore -n < /etc/wap/sec_init

insmod /lib/modules/wap/hw_module_trigger.ko
insmod /lib/modules/wap/l3base.ko

#  load DSP modules
if [ $pots_num -ne 0 ]
then    
    echo "Loading DSP temporary modules: "
	feature_soft_dsp=`GetFeature VOICE_FT_SOFT_DSP`
    insmod /lib/modules/wap/hw_module_dopra.ko
	if [ $feature_soft_dsp = 1 ] ;then
		echo "Loading DSP 1 modules: "
		insmod /lib/modules/wap/hw_module_soft_dsp_sdk.ko
	else
	    echo "Loading DSP 2 modules: "
		insmod /lib/modules/wap/hw_module_dsp_sdk.ko
	fi
    insmod /lib/modules/wap/hw_module_dsp.ko
fi
#if file is existed ,don't excute

#add by zengwei for ip_forward and rp_filter nf_conntrack_tcp_be_liberal
#enable ip forward
echo 1 > /proc/sys/net/ipv4/ip_forward
#disable rp filter
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
#end of add by zengwei for ip_forward and rp_filter nf_conntrack_tcp_be_liberal
# BBSP_l3_basic end

# BBSP_l3_extended
if [ $l3_ex -eq 0 ]
then    
    echo "NO L3_extended!"
else 
    echo "Loading BBSP L3_extended modules: "
	insmod /lib/modules/linux/kernel/net/ipv4/ip_tunnel.ko
    insmod /lib/modules/linux/kernel/net/ipv4/gre.ko
    insmod /lib/modules/linux/kernel/net/ipv4/ip_gre.ko
    insmod /lib/modules/wap/l3ext.ko
    insmod /lib/modules/wap/hw_module_conenat.ko
    insmod /lib/modules/wap/ffwd_adpt.ko
    insmod /lib/modules/wap/napt.ko


fi
# BBSP_l3_extended end

if [ -f /lib/modules/wap/np_adpt.ko ];then
    insmod /lib/modules/wap/np_adpt.ko
fi

if [ -f /lib/modules/wap/hal_adpt_hisi_np.ko ];then
    insmod /lib/modules/wap/hal_adpt_hisi_np.ko
fi

if [ $soc_type == HWSOC4 ] || [ $soc_type == HWSOC7 ] || [ $soc_type == HWSOC8 ]; then
    insmod /lib/modules/wap/hal_eth_sd518x.ko
    insmod /lib/modules/wap/hal_qos_sd518x.ko
    echo "insmod hal_eth_sd518x!"
    if [ ${var_xpon_mode} == "12" ]; then
        if [ ${pon_type_value} == "5" ]; then
            insmod /lib/modules/wap/hw_module_gmac_sd518x.ko
            echo "insmod hw_module_gmac_sd518x!"
        else
            insmod /lib/modules/wap/hw_module_emac_sd518x.ko
            echo "insmod hw_module_emac_sd518x!"  
        fi
    elif [ ${var_xpon_mode} == "4" ]; then
        if [ ${pon_type_value} == "1" ]; then
            insmod /lib/modules/wap/hw_module_gmac_sd518x.ko
            echo "insmod hw_module_gmac_sd518x!"
        else
            insmod /lib/modules/wap/hw_module_emac_sd518x.ko
            echo "insmod hw_module_emac_sd518x!"  
        fi
    elif [ ${var_xpon_mode} == "17" ]; then
        insmod /lib/modules/wap/hw_module_gmac_sd518x.ko
        echo "insmod hw_module_gmac_sd518x!"
    elif [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "6" ] || [ ${var_xpon_mode} == "7" ]; then
        insmod /lib/modules/wap/hw_module_emac_sd518x.ko
        echo "insmod hw_module_emac_sd518x!"
    else
        insmod /lib/modules/wap/hw_module_gmac_sd518x.ko
        echo "insmod hw_module_gmac_sd518x!"
    fi
fi

cdk_info=`cat /var/amp_cdk_para/cdk_flow_size | awk '{print $1}'`
cdk_size=`echo $cdk_info | tr -cd "[0-9]"`
if [ -f /var/WiFisdk/lib/modules/wap/hi_np_wifi.ko ]; then
    if [[ $cdk_size -eq 128 ]]; then
        insmod /var/WiFisdk/lib/modules/wap/hi_np_wifi.ko g_rx_pkt_mode=1 g_np_addr_mode=4
    else
        insmod /var/WiFisdk/lib/modules/wap/hi_np_wifi.ko g_rx_pkt_mode=1
    fi
elif [ -f /lib/modules/wap/hi_np_wifi.ko ]; then
    if [[ $cdk_size -eq 128 ]]; then
        insmod /lib/modules/wap/hi_np_wifi.ko g_rx_pkt_mode=1 g_np_addr_mode=4
    else
        insmod /lib/modules/wap/hi_np_wifi.ko g_rx_pkt_mode=1
    fi
fi

# BBSP_hw_route
if [ $hw_route -eq 0 ]
then    
    echo "NO hw_rout!"
else 
    echo "Loading BBSP hw_rout modules: "
    insmod /lib/modules/wap/l3ext.ko
    insmod /lib/modules/wap/wap_ipv6.ko
fi

insmod /lib/modules/wap/bbsp_l3_adpt.ko
insmod /lib/modules/wap/ethoam.ko
insmod /lib/modules/wap/ethoam_adpt.ko
insmod /lib/modules/linux/kernel/net/llc/llc.ko
insmod /lib/modules/linux/kernel/net/802/stp.ko

# BBSP_hw_route end
if [ $ssid_num -ne 0 ]
then
    insmod /lib/modules/wap/wifi_fwd.ko
fi

#no need /mnt/jffs2/Cal.sh for calibrate, delete it	
[ -e /mnt/jffs2/Cal.sh ] && [ ! -e /bin/CalMode.sh ] && rm -rf /mnt/jffs2/Cal.sh
[ -d /mnt/jffs2/equipment/QCA ] && [ ! -e /bin/CalMode.sh ] && rm -rf /mnt/jffs2/equipment/QCA

#not savedata under equip mode
if [ $ssid_num -ne 0 ]
then
    echo > /var/notsavedata
fi

#add by zhaochao for ldsp_user
iLoop=0
echo -n "Start ldsp_user..."
if [ -e /bin/hw_ldsp_cfg ]
then
  hw_ldsp_cfg &
  while [ $iLoop -lt 50 ] && [ ! -e /var/hw_ldsp_tmp.txt ] 
  do
    echo $iLoop
    iLoop=$(( $iLoop + 1 ))
    sleep 0.1
  done
  
  if [ -e /var/hw_ldsp_tmp.txt ]
  then 
      rm -rf /var/hw_ldsp_tmp.txt
  fi
fi

iLoop=0
if [ -e /bin/hw_ldsp_cfg ]
then
  while [ $iLoop -lt 100 ] && [ ! -e /var/epon_up_mode.txt ] && [ ! -e /var/gpon_up_mode.txt ] && [ ! -e /var/ge_up_mode.txt ] && [ ! -e /var/wifi_up_mode.txt ] 
  do
    echo $iLoop
    iLoop=$(( $iLoop + 1 ))
    sleep 0.1
  done
fi

#mbist加载
insmod /lib/modules/wap/hw_module_mbist.ko

#打开3.10 R死锁检测softlockup，分配128K大小，OOM大小为64K
echo 128 > /proc/sys/kernel/softlockup_log_size
echo 1 > /proc/sys/kernel/watchdog
echo 2 500 > /proc/sys/kernel/watchdog_thresh

insmod /lib/modules/wap/hw_module_drv_event.ko

# install qtn wifi chip driver
cat /proc/bus/pci/devices | cut -f 2 | while read dev_id;
do
	if [ "$dev_id" == "1bb50008" ]; then
		echo "pci device id:$dev_id"
		insmod /lib/modules/wap/qdpc-host.ko
	fi
done

rm -f /mnt/jffs2/Equip_MU_UpGRD_Flag
if [ -f /mnt/jffs2/Equip_MU_UpGRD_Flag ]
then
	rm -f /mnt/jffs2/Equip_MU_UpGRD_Flag
	start ssmp comm lsvd bbsp amp cms &
	ssmp &
	cms &
	lsvd &
	comm -l ssmp bbsp cms & 
	bbsp equip & 
	amp equip &

	while true; do 
	    sleep 1
	    # 如果ssmploadconfig文件存在，表示消息服务启动成功，可以启动PM进程了
	    if [ -f /var/ssmploadconfig ]; then
		    procmonitor & break
		fi
	done &
	while true;
	do
		sleep 1

		if [ -f /var/ssmploaddata ] ; then
			echo -n "Start mu..."
			mu &
			echo "Start flash aging test..."
			/mnt/jffs2/equipment/bin/aging &
			break;
		fi
	done &
	exit 0
fi

var_proc_name="ssmp bbsp amp ldspcli igmp cms "
var_proc_comm="-l bbsp ssmp wifi cms igmp"

if [ -e /var/gpon_up_mode.txt ]
then
    var_proc_name=$var_proc_name" omci"
fi

if [ -e /var/epon_up_mode.txt ]
then
    var_proc_name=$var_proc_name" oam"
fi

if [ -f /bin/comm ]; then
	var_proc_name=$var_proc_name" comm lsvd"
fi

if [ -f /bin/clid ]; then
	var_proc_name=$var_proc_name" clid"
fi

usb_enble=`GetFeature HW_SSMP_FEATURE_USB`
usbsmart_enble=`GetFeature HW_SSMP_FEATURE_USBSMART`
if [ ! -f /lib/libhw_usb_mngt.so ];then
    usb_enble=0
	usbsmart_enble=0
fi 
if [ $usb_enble = 1 ] || [ $usbsmart_enble = 1 ];then
    var_proc_comm=$var_proc_comm" usb_mngt"
fi 

monitor_enble=`GetFeature FT_COLLECT_MONITOR_REPORT`
if [ -f /lib/libhw_cwmp_common.so ] && [ $monitor_enble = 1 ]; then
    var_proc_comm=$var_proc_comm" monitor"
fi

if [ -f /lib/libcli_userinfo.so ]; then
    var_proc_comm=$var_proc_comm" cliuserinfo"
fi

if [ -f /lib/libhw_smp_cmp.so ]; then
    var_proc_comm=$var_proc_comm" cmp"
fi

echo $var_proc_name

start $var_proc_name&

ssmp &
cms &
lsvd &

if [ -f /bin/comm ]; then
    echo "Start COMM..."
    comm $var_proc_comm &
fi

ldspcli equip &

bbsp equip &

amp equip &

if [ -e /var/gpon_up_mode.txt ]
then
    omci &
fi 

if [ -e /var/epon_up_mode.txt ]
then
    oam &
fi

echo -n "Start KMC..."
while true; do
        sleep 1
        if [ -f /var/ssmploaddata ]; then
                kmc &
                break;
        fi
done &

core_num=`cat /proc/cpuinfo  | grep process  | wc -l`
echo "core_num $core_num"

if [ $ssid_num -ne 0 ]
then
    echo -n " Start WIFI..."

    # 大于2核将WIFI进程绑定在1核上，海思驱动的在大于2核的系统上
    # 从0,1核以外发消息会出现无响应问题
    if [ $core_num -ge 2 ];then
        taskset 1 wifi -d 0 -n 60 &
    else
        wifi -d 0 -n 60 &
    fi
fi

igmp &

if [ -f /bin/clid ]; then
	echo "Starting CLID..."
	clid frame&
fi

#if file is existed ,don't excute
if [ $pots_num -eq 0 ]
then    
    echo -n "Do not start VOICE..."
else 
    echo -n "Start VOICE ..."
    while true; do
    sleep 0.1
        if [ -f /var/ssmploadconfig ]; then
            #Luna SDK use awk by default
            major=`grep voip /proc/devices| awk '{print $1}'`
            echo "major="$major
            mkdir -p /dev/voip

            /bin/mknod /dev/voip/dtmfdet0 c ${major} 76
            /bin/mknod /dev/voip/dtmfdet1 c ${major} 77
            /bin/mknod /dev/voip/ivr8k c ${major} 16
            /bin/mknod /dev/voip/mgr c ${major} 1
            /bin/mknod /dev/voip/pcmrx0 c ${major} 65
            /bin/mknod /dev/voip/pcmrx1 c ${major} 74
            /bin/mknod /dev/voip/pcmtx0 c ${major} 64
            /bin/mknod /dev/voip/pcmtx1 c ${major} 73
            /bin/mknod /dev/voip/ipc c ${major} 66
            /bin/mknod /dev/voip/log_ioctl c ${major} 40

            if [ -f /bin/aipc_util ]; then
                aipc_util -e
                aipc_util -w -d 0xb0000400 -i /bin/dsp.img
                aipc_util -b

                if [ -x "/bin/wait_dsp" ]; then
                    wait_dsp
                else
                    echo "no wait_dsp, so force to sleep 5 seconds..."
                    sleep 5
                fi                  
            fi
            [ -f /bin/voice_h248 ] && voice_h248 equip&
            [ -f /bin/voice_sip ] && voice_sip equip&
            [ -f /bin/voice_h248sip ] && voice_h248sip equip&
            break;
        fi
    done &
fi

while true; do
    sleep 3
    if [ -f /var/ssmploaddata ] ; then
	wificli & break;
    fi
done &

while true; do 
    sleep 1
    # 如果ssmploadconfig文件存在，表示消息服务启动成功，可以启动PM进程了
    if [ -f /var/ssmploadconfig ]; then
	    procmonitor ssmp & break
	fi
done &

#启动双机通信进程
feature_LTE_support=`GetFeature FT_LTE_SUPPORT`
if [ $feature_LTE_support = 1 ]; then
    echo -n "Start devscom..."
    while true; do
            sleep 1
            if [ -f /var/ssmploaddata ]; then
                devscom &
                break;
            fi
    done &
fi

ctrg_support=`GetFeature HW_SSMP_FEATURE_CTRG`
cuc_support=`GetFeature FEATURE_CU_DBUS`
#启动ctrg_m服务进程,仅组播升级时按需启动
if [ -e /bin/ctrg_m ] ;then
	while true; do sleep 20; 
		if [ -f /var/cleanmemflag ] && [ -f /var/app_mount_complete ]; then
			#天翼网关，增加dbus服务启动
			if [ $ctrg_support = 1 ] || [ $cuc_support = 1 ];then
				mkdir -p /var/lib/dbus/
				dbus-uuidgen>>/var/lib/dbus/machine-id
                # 目录/var/run/dbus里面总线创建的system_bus_socket和ubus.sock等文件，ctrg_m和dbus-send会使用，需要权限755
				mkdir -p /var/run/dbus/ && chmod 755 /var/run/dbus/

				#挂载后, 先确保 system.conf 存在，再启动dbus-daemon
				if [ ! -f /opt/$framework_dir/apps/etc/dbus-1/system.conf ]
				then
                    mkdir -p /opt/$framework_dir/apps/etc
                    cp -rf /etc/dbus/dbus-1 /opt/$framework_dir/apps/etc/
				fi

				if [ ! -f /etc/dbus-1/system.conf ]
				then
					echo "Error:not find system.conf"
				else
					dbus-daemon --system 
				fi

				#用saf-huawei 启动framework
				if [ -f /mnt/jffs2/saftime ];then
					sleeptime=`cat /mnt/jffs2/saftime`
				else
					sleeptime=60
				fi	
				sleep $sleeptime
				echo "start ctrg saf-huawei"

				#天翼网关oom策略修改
				#0标识oom时不panic，默认值2
				echo 0 > /proc/sys/vm/panic_on_oom 
				#1标识oom时谁申请杀谁，默认值0
				echo 1 > /proc/sys/vm/oom_kill_allocating_task

				ctrg_m & break; 
			else
				break; 
			fi
		fi
	done &
fi

# After system up, drop the page cache.
while true; do sleep 30 ; echo 3 > /proc/sys/vm/drop_caches ; echo "Dropped the page cache."; break; done &
while true;
do
	sleep 4
	# FixedDevice/OneTrack#993
	# 宽带确认阶段三完成RPC注册，此处选取阶段4时启动mu
	if [ -f /var/bbsploaddata ] && [ -f /var/ssmploaddata ] ; then
		echo -n "Start mu..."
		sleep 16
		mu& break;
	fi
done &

#系统启动后加载 诊断信息获取ko
if [ -f /lib/modules/wap/hw_module_diag.ko ]; then
    insmod /lib/modules/wap/hw_module_diag.ko
fi

#启动完成之后恢复打印级别为4
echo 4 > /proc/sys/kernel/printk

# Print system process status for debug.
ps

sleep 6

#skb内存池
feature_double_wlan=`GetFeature HW_AMP_FEATURE_DOUBLE_WLAN`
feature_11ac=`GetFeature HW_AMP_FEATURE_11AC`
if [ $feature_double_wlan = 1 ] || [ $feature_11ac = 1 ];then

	if [ -f /var/runinram ]; then
		echo "In MU Upgrade Mode, not need installed skpool!"
	else
		insmod /lib/modules/wap/skpool.ko
		echo "skpool installed ok!"
	fi
fi

while true; do
	sleep 2
	#SSMP启动完后后再启动老化进程
	if [ -f /var/ssmploadconfig ] ; then
		sleep 5
		echo "Start flash aging test..."
		/mnt/jffs2/equipment/bin/aging & break;
	fi
done &

##如果内存测试存在，拉起内存测试进程
if [ -e /bin/mbist_test ] ;then
	echo "Start DDR mbist test..."
	/bin/mbist_test &
fi

fttr_spt=`GetFeature FT_FTTR_MAIN_ONT`
if [ $fttr_spt == 1 ]; then
    echo -n "Start LINEOMCI..."
    if [ -f /lib/modules/wap/ethomci.ko ]; then
        insmod /lib/modules/wap/ethomci.ko
    fi
    while true; do
        sleep 1
        if [ -f /var/ssmploaddata ] && [ -f /var/fpga_load ] && [ -e /bin/lineomci ]; then
            /bin/lineomci &
            break;
        fi
    done &
fi
