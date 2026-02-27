#!/bin/sh
echo "enter equip_single..................................."
# bin_type 参数表示板子形态,可选择的参数有：bin4, bin5, bin6, 5610
bin_type=$1
[[ $bin_type == "bin5" ]] && mount -o remount,exec /mnt/jffs2
if [[ $bin_type == "bin6" ]]; then
    mount -o remount,exec /mnt/jffs2
    flashtype_v5=1
    tianyi_cut_128=0
    tianyi_256=0
else
    flashtype_v5=$(cat /proc/mtd | grep "ubilayer" | wc -l)
    tianyi_cut_128=$(cat /proc/mtd | grep "exrootfs" | wc -l)
    tianyi_256=$(cat /proc/mtd | grep "frameworkA" | wc -l)
fi
txt_boardinfo=""
txt_boardinfo_bak=""
var_xpon_mode=""
pon_type_value=""
chip_type=$(echo $(md 0x10100800 1) | sed 's/.*:: //' | sed 's/[0-9][0-9]00//' | cut -b 1-4)
slic_type=""
slic_chiptype=""
pots_num=""
usb_num=""
ssid_num=""
echo "bin_type:$bin_type, flashtype_v5:$flashtype_v5, tianyi_cut_128=$tianyi_cut_128, tianyi_256=$tianyi_256, chip_type=$chip_type"

if [ $tianyi_cut_128 = 1 ] && [ $flashtype_v5 = 1 ]; then
    echo "start load tianyi_cut ex rootfs"
    touch /var/tianyi_cut_128
fi

function get_wlan_calibration_flag()
{
    if [ -f /mnt/jffs2/wlan_calibration_flag ]; then
        wlan_cali_flag=$(cat /mnt/jffs2/wlan_calibration_flag)
    else
        wlan_cali_flag="NULL"
    fi

    #通过命令替换的方式获取子shell中的局部变量wlan_cali_flag
    temp_wlan_flag=`cat /proc/bus/pci/devices | cut -f 2 | sort -u | while read dev_id;
    do
        if [ "$dev_id" != "19e51152" -a "$dev_id" != "59e70002" -a "$dev_id" != "59e70003" ]; then
            wlan_cali_flag="True"
            echo $wlan_cali_flag
            break
        fi
    done`

    if [ "$temp_wlan_flag" != "" ]; then
        wlan_cali_flag=$temp_wlan_flag
    fi
}

function insmod_ko_if_exist()
{
    if [ -f $1 ]; then
        insmod $1
    fi
}

function change_kernel_config()
{
    echo 74 > /proc/sys/kernel/msgmni
}

function active_eth_driver()
{
    echo "start active_eth_driver............."
    if [ $soc_type == HWSOC4 ] || [ $soc_type == HWSOC7 ] || [ $soc_type == HWSOC8 ]; then
        insmod /lib/modules/linux/kernel/net/llc/llc.ko
        insmod /lib/modules/linux/kernel/net/802/stp.ko
        insmod /lib/modules/linux/kernel/net/bridge/bridge.ko
        brctl addbr br0
        ifconfig eth0 up
    fi

    export HW_LANMAC_TEMP="/var/hw_lanmac_temp"
    getlanmac $HW_LANMAC_TEMP
    if [ 0  -eq  $? ]; then
        read HW_BOARD_LANMAC < $HW_LANMAC_TEMP
        ifconfig br0 hw ether $HW_BOARD_LANMAC
        if [ $soc_type == HWSOC4 ] || [ $soc_type == HWSOC7 ] || [ $soc_type == HWSOC8 ]; then
            ifconfig eth0 hw ether $HW_BOARD_LANMAC
        fi
    fi

    ifconfig lo up
    ifconfig br0 mtu 1500
    ifconfig br0 192.168.100.1 up
     # delete temp lanmac file
    if [ -f $HW_LANMAC_TEMP ]; then
        rm -f $HW_LANMAC_TEMP
    fi
    unset HW_LANMAC_TEMP
    echo "end active_eth_driver............."
}

function reload_feature()
{
    echo "start reload_feature............."
    smoothTtreeDef -ttree /mnt/jffs2/ttree_spec_smooth.tar.gz 
    smoothTtreeDef -spec /mnt/jffs2/encrypt_spec_key.tar.gz > /dev/null
    if [ -f /proc/wap_proc/feature ];then
        echo "Reload" > /proc/wap_proc/feature
    else
        insmod /lib/modules/wap/hw_module_feature.ko
    fi

    rm -rf /var/spec/
    echo "end reload_feature............."
}

function load_optic_pon_ko()
{
    echo "start load_optic_pon_ko............."
    insmod /lib/modules/wap/hw_module_optic.ko
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
    elif [ ${var_xpon_mode} == "15" ]; then
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
    elif [ ${var_xpon_mode} == "3" ]; then
        echo "eth mode"
    else
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_epon.ko
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
    fi
    echo "end load_optic_pon_ko............."
}

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

function insmod_ko_by_soc_type()
{
    if [ $1 == HWSOC3 ] || [ $1 == HWSOC4 ] || [ $1 == HWSOC5 ] || [ $1 == SD5118V2 ] || [ $1 == HWSOC7 ] || [ $1 == HWSOC8 ] || [ $1 == HWSOC9 ]; then
        insmod_ko_if_exist $sdk_path/hi_ipsec.ko
        insmod_ko_if_exist /lib/modules/wap/hw_module_sec.ko
        if [ -f /lib/modules/wap/hw_module_sec.ko ];then
            kmc_tool check kmc_store_A3
        fi
    fi
}

function insmod_ko_by_bob_type()
{
    echo "chip auto match bob type is "$2
    #M2013 Gpon/Epon光phy
    if [[ $(echo $2 | grep "M02103")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_m02103.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_m02103.ko
    #HN5176 Gpon/Epon光phy
    elif [[ $(echo $2 | grep "HN5176")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_hn5176.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_hn5176.ko
    #HU5176 Gpon/Epon光phy
    elif [[ $(echo $2 | grep "UX5176")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_ux5176.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_ux5176.ko
    elif [[ $(echo $2 | grep "UX5176S")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_ux5176.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_ux5176.ko
    elif [[ $(echo $2 | grep "GNA4221")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_ux5176.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_ux5176.ko
    #SD5175不带MCU版本 XGpon/XEpon
    elif [[ $(echo $2 | grep "SD5175v300")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_sd5175v300.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_sd5175v300.ko
    #GN7355带MCU版本 XGpon/XEpon
    elif [[ $(echo $2 | grep "GN7355")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_sd5175.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_sd5175.ko
    #HN5171/UX5171 XGSPON
    #HN5170/UX5170 XGPON
    elif [[ $(echo $2 | grep "5171")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_517x.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_517x.ko
    elif [[ $(echo $2 | grep "5170")"NOEXIST" != "NOEXIST" ]] && [ -f /lib/modules/wap/hw_ker_optic_517x.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_517x.ko
    else
        echo "borad cfg bob type is"$1
        dir_chip_auto_match=/mnt/jffs2/chip_auto_match
        mkdir -p $dir_chip_auto_match && ontchown 3003:1200 $dir_chip_auto_match && ontchmod 640 $dir_chip_auto_match
        rm -rf /mnt/jffs2/chip_auto_match/bob_chiptype

        if [ $1 == M02103 ] || [ $1 == HN5176 ] || [ $1 == UX5176 ] || [ $1 == UX5176S ] || [ $1 == GNA4221 ]; then
            echo "G/E pon bob group"
            #M2013 Gpon/Epon光phy
            insmod_ko_if_exist /lib/modules/wap/hw_ker_optic_m02103.ko
            #HN5176 Gpon/Epon光phy
            insmod_ko_if_exist /lib/modules/wap/hw_ker_optic_hn5176.ko
            #HU5176 Gpon/Epon光phy
            insmod_ko_if_exist /lib/modules/wap/hw_ker_optic_ux5176.ko
        
        elif [ $1 == SD5175v300 ] || [ $1 == GN7355 ] || [ $1 == HN517X ] || [ $1 == UX517X ]; then
            echo "XG/XE pon bob group"
            #SD5175不带MCU版本 XGpon/XEpon
            insmod_ko_if_exist /lib/modules/wap/hw_ker_optic_sd5175v300.ko
            #GN7355带MCU版本 XGpon/XEpon
            insmod_ko_if_exist /lib/modules/wap/ hw_ker_optic_sd5175.ko
            #HN517X新芯片，这个必须要放在最后面，样片读不到chip，默认为HN5170!!! HN5171/UX5171 XGSPON HN5170/UX5170 XGPON
            insmod_ko_if_exist /lib/modules/wap/hw_ker_optic_517x.ko
        fi
    fi
    insmod_ko_if_exist /lib/modules/wap/hw_module_sfp.ko

    #下行光phy初始化
    echo "chip auto match uni bob type is "$3
    if [[ $(echo $3 | grep "GNA4215")"NOEXIST" != "NOEXIST" ]]; then
        insmod_ko_if_exist /lib/modules/wap/hw_ker_optic_gna4215.ko
    elif [[ $(echo $3 | grep "UX3326")"NOEXIST" != "NOEXIST" ]]; then
        insmod_ko_if_exist /lib/modules/wap/hw_ker_optic_ux3326.ko
    else
        #配置失败，删除配置文件，按老流程加载
        rm -rf $dir_chip_auto_match/uni_bob_chiptype
        insmod_ko_if_exist /lib/modules/wap/hw_ker_optic_gna4215.ko
        insmod_ko_if_exist /lib/modules/wap/hw_ker_optic_ux3326.ko
    fi
}

function insmod_slave_chip_ko()
{
    echo "start insmod_slave_chip_ko............."
    if [ -f /lib/modules/wap/hal_module_slave_chip.ko ]; then
        insmod /lib/modules/wap/hw_module_spi.ko
        insmod /lib/modules/wap/hal_module_slave_chip.ko
        insmod /lib/modules/wap/hal_slave_chip_sd511x.ko
    fi
    echo "end insmod_slave_chip_ko............."
}

function insmod_poe_ko()
{
    if [ -f /lib/modules/wap/hw_module_poe.ko ]; then
        insmod /lib/modules/wap/hw_module_poe.ko
        if [ $1 == rtk8238 ]; then
            insmod /lib/modules/wap/hw_module_spi.ko
            insmod /lib/modules/wap/hw_ker_poe_rtk8238.ko
        fi
    fi
    insmod_ko_if_exist /lib/modules/wap/hw_module_poe_monitor.ko
}

function insmod_ko_by_support_pll()
{
    if [ "$1" == "Y" ]; then
        insmod /lib/modules/wap/hw_module_pll.ko
        insmod /lib/modules/wap/hw_ker_pll_au53x5.ko
        insmod /lib/modules/wap/hw_ker_pll_sa77xx.ko
        insmod /lib/modules/wap/hw_ker_pll_si53xx.ko
    fi
}

function excute_loadexfs()
{
    # V5系列，均起loadexfs。
    # 此处需要添加上V3的HS8145C
    if [ $flashtype_v5 = 1 ] || [ $tianyi_cut_128 = 1 ]; then
        echo "load ex rootfs......"
        mkdir -p /var/image & chmod 750 /var/image
        loadexfs > /dev/null
    fi
}

function insmod_ko_by_support_nfc()
{
    if [ "$1" == "Y" ];then
        insmod /lib/modules/wap/hw_module_nfc_st.ko
        insmod /lib/modules/wap/hw_module_nfc.ko
        insmod /lib/modules/wap/hw_module_nfc_nta5332.ko
        insmod /lib/modules/wap/hw_module_nfc_fm11nc.ko
    fi
}

function insmod_ko_by_ext_phy_type()
{
    #外置phy处理
    if [[ $1 != "NONE" ]] ; then
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
        ###按配置加载外置phy chip ko
        if [[ $(echo $1 | grep "RTL8211")"NOEXIST" != "NOEXIST" ]] ; then
            insmod /lib/modules/wap/hal_extphy_rtl8211.ko
        fi
        if [[ $(echo $1 | grep "YT8521")"NOEXIST" != "NOEXIST" ]] ; then
            insmod /lib/modules/wap/hal_extphy_yt8521.ko
        fi
        if [[ $(echo $1 | grep "BCM84881")"NOEXIST" != "NOEXIST" ]] ; then
            insmod /lib/modules/wap/hw_ker_phy_bcm84881.ko
        fi
        if [[ $(echo $1 | grep "RTL8226")"NOEXIST" != "NOEXIST" ]] ; then
            insmod /lib/modules/wap/hw_ker_phy_rtl8266.ko
        fi
        if [[ $(echo $1 | grep "RTL8261")"NOEXIST" != "NOEXIST" ]] ; then
            insmod /lib/modules/wap/phy_sdk_rtl8261.ko
            insmod /lib/modules/wap/hal_extphy_rtl8261.ko
        fi
        if [[ $(echo $1 | grep "QCA8081")"NOEXIST" != "NOEXIST" ]] ; then
            insmod /lib/modules/wap/hal_extphy_qca8081.ko
        fi
        if [[ $(echo $ext_phy_type | grep "YT8821")"NOEXIST" != "NOEXIST" ]] ; then
            insmod /lib/modules/wap/hal_extphy_yt8821.ko
        fi
    fi
}

function insmod_ko_by_ext_lsw_type()
{
    if [ '$1' == 'RTL8366' ];then
        insmod /lib/modules/wap/hw_module_extlsw.ko
        insmod /lib/modules/wap/hw_ker_eth_rtl8366.ko
    fi
}
function insmod_ko_by_support_sd()
{
    if [ "$1" == "Y" ];then
        insmod /lib/modules/linux/extra/drivers/mmc/core/mmc_core.ko
        insmod /lib/modules/linux/extra/drivers/mmc/card/mmc_block.ko
        insmod /lib/modules/linux/extra/drivers/mmc/host/himciv100/himci.ko
        insmod /lib/modules/linux/extra/drivers/mmc/host/dw_mmc.ko
        insmod /lib/modules/linux/extra/drivers/mmc/host/dw_mmc-pltfm.ko
        insmod /lib/modules/linux/extra/drivers/mmc/host/dw_mmc-hisi.ko	    
        insmod /lib/modules/wap/hw_module_sd.ko
        insmod /lib/modules/wap/smp_sd.ko
    fi
}

function insmod_ko_by_support_lte()
{
    if [ "$1" == "Y" ];then
        insmod /lib/modules/linux/extra/drivers/net/usb/hw_cdc_driver.ko
        insmod /lib/modules/linux/extra/drivers/usb/serial/usb_wwan.ko
        insmod /lib/modules/linux/extra/drivers/net/usb/usbnet.ko
        insmod /lib/modules/linux/extra/drivers/usb/class/cdc-wdm.ko
        insmod /lib/modules/linux/extra/drivers/net/usb/cdc_ether.ko
        insmod /lib/modules/linux/extra/drivers/net/usb/cdc_ncm.ko
        insmod /lib/modules/linux/extra/drivers/net/usb/qmi_wwan_q.ko
        insmod /lib/modules/wap/hw_module_datacard.ko
        insmod_ko_if_exist /lib/modules/wap/hw_module_datacard_chip_huawei.ko
        insmod_ko_if_exist /lib/modules/wap/hw_module_datacard_chip_quectel.ko
    fi
}

function insmod_ko_by_support_iot()
{
    if [ "$1" == "Y" ];then
        insmod /lib/modules/wap/hw_module_uart.ko
        insmod /lib/modules/wap/hw_module_tty.ko
    fi
}

function get_hardware_ability()
{
    echo "start get_hardware_ability....."
    board_cfg=$(cat /var/board_cfg.txt)
    bob_chiptype=$(cat /mnt/jffs2/chip_auto_match/bob_chiptype)
    uni_bob_chiptype=$(cat /mnt/jffs2/chip_auto_match/uni_bob_chiptype)
    extphy_chiptype=$(cat /mnt/jffs2/chip_auto_match/extphy_chiptype)
    slic_chiptype=$(cat /mnt/jffs2/chip_auto_match/slic_chiptype)
    soc_type=$(echo $board_cfg | grep bob_type|cut -d ';' -f 3|cut -d '=' -f 2)
    bob_type=$(echo $board_cfg | grep bob_type|cut -d ';' -f 6|cut -d '=' -f 2)
    slic_type=$(echo $board_cfg | grep board_id|cut -d ';' -f 4|cut -d '=' -f 2) 
    ext_phy_type=$(echo $board_cfg | grep ext_phy_type|cut -d ';' -f 5|cut -d '=' -f 2)
    support_usb=$(echo $board_cfg | grep usb|cut -d ';' -f 8|cut -d '=' -f 2)
    support_sd=$(echo $board_cfg | grep sd|cut -d ';' -f 9|cut -d '=' -f 2)
    support_rf=$(echo $board_cfg | grep rf|cut -d ';' -f 10|cut -d '=' -f 2)
    support_battery=$(echo $board_cfg | grep battery|cut -d ';' -f 11|cut -d '=' -f 2)
    support_iot=$(echo $board_cfg | grep iot|cut -d ';' -f 12|cut -d '=' -f 2)
    support_nfc=$(echo $board_cfg | grep nfc|cut -d ';' -f 13|cut -d '=' -f 2)
    support_lte=$(echo $board_cfg | grep lte|cut -d ';' -f 14|cut -d '=' -f 2)
    pse_type=$(echo $board_cfg | grep pse_type|cut -d ';' -f 15|cut -d '=' -f 2)
    support_rs485=$(echo $board_cfg | grep rs485|cut -d ';' -f 16|cut -d '=' -f 2)
    ext_lsw_type=$(echo $board_cfg | grep ext_lsw_type|cut -d ';' -f 17|cut -d '=' -f 2)
    support_motor=$(echo $board_cfg | grep motor|cut -d ';' -f 18|cut -d '=' -f 2)
    support_pll=$(echo $board_cfg | grep pll|cut -d ';' -f 19|cut -d '=' -f 2)
    echo "soc_type=$soc_type, bob_type=$bob_type, ext_phy_type=$ext_phy_type, ext_lsw_type=$ext_lsw_type, support_motor=$support_motor, support_pll=$support_pll"
    echo "pse_type=$pse_type,support_rs485=$support_rs485, support_usb=$support_usb, support_sd=$support_sd, support_rf=$support_rf, support_battery=$support_battery, support_iot=$support_iot, support_nfc=$support_nfc, support_lte=$support_lte, pse_type=$pse_type"
     # 按照硬件能力集加载ko
    insmod_ko_by_soc_type $soc_type
    insmod_ko_by_bob_type $bob_type $bob_chiptype $uni_bob_chiptype
    insmod_poe_ko $pse_type
    [[ "$support_battery" == "Y" ]] && insmod /lib/modules/wap/hw_module_uart.ko
    [[ "$support_rf" == "Y" ]] && insmod /lib/modules/wap/hw_module_rf.ko
    [[ "$support_rs485" == "Y" ]] && insmod /lib/modules/wap/hw_module_uart.ko
    [[ "$support_motor" == "Y" ]] && insmod /lib/modules/wap/hw_module_motor.ko
    insmod_ko_by_support_pll $support_pll
    insmod_ko_by_support_nfc $support_nfc
    insmod_ko_by_ext_phy_type $ext_phy_type $extphy_chiptype
    insmod_ko_by_ext_lsw_type $ext_lsw_type
    insmod_ko_by_support_sd $support_sd
    insmod_ko_by_support_lte $support_lte
    insmod_ko_by_support_iot $support_iot
    echo "end get_hardware_ability....."
}

function insmod_hw_ko_by_xpon_mode()
{
    echo "start insmod_hw_ko_by_xpon_mode....."
    if [ -f /lib/modules/wap/hw_module_ploam_proxy.ko ]; then
        insmod /lib/modules/wap/hw_module_gmac.ko
        insmod /lib/modules/wap/hw_module_ploam.ko
        insmod /lib/modules/wap/hw_module_xgploam.ko
        insmod /lib/modules/wap/hw_module_ploam_proxy.ko
    elif [ ${var_xpon_mode} == "4" ]; then
        if [ ${pon_type_value} == "1" ]; then
            insmod /lib/modules/wap/hw_module_gmac.ko
            insmod /lib/modules/wap/hw_module_ploam.ko
        else
            insmod /lib/modules/wap/hw_module_emac.ko
            insmod /lib/modules/wap/hw_module_mpcp.ko
        fi
    elif [ ${var_xpon_mode} == "3" ]; then
        echo "eth mode"
    elif [ ${var_xpon_mode} == "12" ]; then
        if [ ${pon_type_value} == "5" ]; then
            insmod /lib/modules/wap/hw_module_gmac.ko
            insmod /lib/modules/wap/hw_module_xgploam.ko
        else
            insmod /lib/modules/wap/hw_module_emac.ko
            insmod /lib/modules/wap/hw_module_mpcp.ko
        fi
    elif [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "6" ] || [ ${var_xpon_mode} == "7" ]; then
        insmod /lib/modules/wap/hw_module_emac.ko
        insmod /lib/modules/wap/hw_module_mpcp.ko
    else
        insmod /lib/modules/wap/hw_module_gmac.ko
        insmod_ko_if_exist /lib/modules/wap/hw_module_ppm.ko
        if [ ${var_xpon_mode} == "5" ] || [ ${var_xpon_mode} == "10" ] || [ ${var_xpon_mode} == "15" ] ; then	
            insmod /lib/modules/wap/hw_module_xgploam.ko
        else
            insmod /lib/modules/wap/hw_module_ploam.ko
        fi
    fi
    echo "end insmod_hw_ko_by_xpon_mode....."
}

#HN8145XR 三大T合一bin
function china_allbin_process()
{
    local osgi_block=$1
    mkdir -p /mnt/jffs2/plug
    mount -t ubifs -o sync /$osgi_block /mnt/jffs2/plug
    if [ $? != 0 ]; then
        echo "Failed to mount apps, reboot system" | ls -l /mnt/jffs2
        reboot
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
        if [ $? != 0 ]; then
            echo "Failed to mount app, reboot system" | ls -l /mnt/jffs2/app
            reboot
        fi
    fi
}

function mount_app_system()
{
    #bin6没有app分区,直接返回
    if [ "$bin_type" == bin6 ];then
        return 0
    fi

    #通过特性开关来挂载opt
    local ctrg_support=$(GetFeature HW_SSMP_FEATURE_CTRG)
    local cuc_support=$(GetFeature FEATURE_CU_DBUS)
    echo "@@@@@@ ctrg_support is $ctrg_support @@@ cuc_support is $cuc_support@@@@@@"
    if [ $tianyi_cut_128 = 0 ]; then 
        if [ $ctrg_support = 1 ] || [ $cuc_support = 1 ] ;then
            echo "start load ex rootfs"
            mkdir -p /var/image & chmod 750 /var/image
            loadexfs

            if [ $flashtype_v5 = 1 ];then
                apps_block=ubi0_12
            else
                apps_block=ubi0_16
            fi

            #挂载C系统网关要求的分区目录，framework1和framework2由中间件挂载，/opt/upt/apps
            mkdir -p /mnt/jffs2/plug
            mount -t ubifs -o sync /dev/$apps_block /mnt/jffs2/plug
            if [ $? != 0 ]; then
                echo "Failed to mount apps, reboot system" | ls -l /mnt/jffs2
                reboot
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

    echo > /var/app_mount_complete
    return 0
}

function insmod_ko_by_pots_num()
{
    echo "input param1 is "$1
    if [ $1 -ne 0 ] || [ -f /lib/modules/wap/hw_module_fpga.ko ]; then
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
            echo "auto match slic chiptype is "$slic_chiptype
            # 根据 chip_auto_match 中记录的芯片类型加载ko
            if [[ $(echo $slic_chiptype | grep "LE964x")"NOEXIST" != "NOEXIST" ]]; then
                insmod /lib/modules/wap/codec_sdk_le964x.ko
                insmod /lib/modules/wap/hw_ker_codec_le964x.ko
            elif [[ $(echo $slic_chiptype | grep "PEF3100x")"NOEXIST" != "NOEXIST" ]]; then
                insmod /lib/modules/wap/hw_ker_codec_pef31002.ko
            elif [[ $(echo $slic_chiptype | grep "N68x38x")"NOEXIST" != "NOEXIST" ]]; then
                insmod /lib/modules/wap/hw_ker_codec_n68x38x.ko
            else
                dir_chip_auto_match=/mnt/jffs2/chip_auto_match
                mkdir -p $dir_chip_auto_match && ontchown 3003:1200 $dir_chip_auto_match && ontchmod 640 $dir_chip_auto_match
                # 如果 chip_auto_match 中没有匹配到芯片类型，则删除该文件走原始流程
                rm -rf /mnt/jffs2/chip_auto_match/slic_chiptype
                #first le964x
                if [ -f /lib/modules/wap/hw_ker_codec_le964x.ko ] && [ -f /lib/modules/wap/codec_sdk_le964x.ko ]; then
                    insmod /lib/modules/wap/codec_sdk_le964x.ko
                    insmod /lib/modules/wap/hw_ker_codec_le964x.ko
                fi
                #second pef3100x
                insmod_ko_if_exist /lib/modules/wap/hw_ker_codec_pef31002.ko
                #third coslic n68x38x
                insmod_ko_if_exist /lib/modules/wap/hw_ker_codec_n68x38x.ko
            fi
        else
            insmod /lib/modules/wap/hw_ker_codec_ve8910.ko
        fi
    fi
}

function insmod_fpga_ko()
{
    if [ -f /lib/modules/wap/hw_module_fpga.ko ]; then
        insmod $sdk_path/hi_hw.ko
        insmod /lib/modules/wap/hw_module_highway.ko
        insmod /lib/modules/wap/hw_module_spi.ko
        insmod /lib/modules/wap/hw_module_codec.ko

        insmod $sdk_path/hi_tms.ko
        # hw_module_gmacdrv_olt 依赖hi_tms
        rm -f /var/fpga_load
        insmod /lib/modules/wap/hw_module_fpga.ko
        insmod /lib/modules/wap/hw_module_gmacdrv_olt.ko
        insmod /lib/modules/wap/hw_ker_fpga_xc7a100t.ko
    fi
}

function insmod_ko_by_usb_num()
{
    if [ $1 -eq 0 ];then
        return 0
    fi

    if [ -f /lib/modules/linux/extra/drivers/usb/storage/usb-storage.ko ]; then
        cd /lib/modules/linux/
        insmod /lib/modules/linux/extra/drivers/scsi/scsi_mod.ko
        insmod_ko_if_exist /lib/modules/linux/kernel/drivers/scsi/scsi_wait_scan.ko	
        insmod /lib/modules/linux/extra/drivers/scsi/sd_mod.ko
        insmod /lib/modules/linux/extra/drivers/usb/common/usb-common.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/core/usbcore.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/host/hiusb-sd511x.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/host/ehci-hcd.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/host/ehci-pci.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/host/ohci-hcd.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/host/xhci-hcd.ko    
	    insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/host/xhci-plat-hcd.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/storage/usb-storage.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/class/usblp.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/class/cdc-acm.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/serial/usbserial.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/serial/pl2303.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/serial/cp210x.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/serial/ch341.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/serial/ftdi_sio.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/input/input-core.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/hid/hid.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/hid/usbhid/usbhid.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/serial/usb_wwan.ko
        insmod_ko_if_exist /lib/modules/linux/extra/drivers/usb/serial/option.ko
        cd /
        insmod /lib/modules/wap/hw_module_usb.ko
        insmod /lib/modules/wap/smp_usb.ko
    fi
}

function load_np_module()
{
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
    elif [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "6" ] || [ ${var_xpon_mode} == "7" ]; then
        insmod /lib/modules/wap/hw_module_emac_sd518x.ko
        echo "insmod hw_module_emac_sd518x!"
    else
        insmod /lib/modules/wap/hw_module_gmac_sd518x.ko
        echo "insmod hw_module_gmac_sd518x!"
    fi
}

function load_bbsp_module()
{
    echo "start load_bbsp_module....."
    active_eth_driver
    if [ $soc_type == HWSOC4 ] || [ $soc_type == HWSOC7 ] || [ $soc_type == HWSOC8 ]; then
        insmod /lib/modules/wap/hal_adpt_hisi_np.ko
        [[ "$bin_type" != "bin6" ]] && load_np_module
    else
        insmod /lib/modules/wap/hal_adpt_hisi.ko
    fi

    insmod /lib/modules/wap/network_equip.ko vlan=4097

    if [ $soc_type == HWSOC4 ] || [ $soc_type == HWSOC7 ] || [ $soc_type == HWSOC8 ]; then
        # equ_fwd.ko要放在network_equip.ko后面加载，因为里面会往pie注册收包函数，需要覆盖
        insmod /lib/modules/wap/equ_fwd.ko
        brctl addif br0 lan1
        brctl addif br0 lan2
        brctl addif br0 lan3
        brctl addif br0 lan4
        ifconfig lan1 up
        ifconfig lan2 up
        ifconfig lan3 up
        ifconfig lan4 up
    fi

    if [[ $bin_type != "bin6" ]]; then
        echo 16000 > /proc/sys/net/nf_conntrack_max 2>>/var/xcmdlog
        echo 1 > proc/sys/net/netfilter/nf_conntrack_tcp_be_liberal 2>>/var/xcmdlog
        iptables-restore -n < /etc/wap/sec_init
    fi
    echo "end load_bbsp_module....."
}

function load_np_wifi_ko()
{
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
}

function load_pcie_ko()
{
    [[ "$bin_type" == "bin6" ]] && return;
    [[ "$bin_type" == "bin5" ]] && return;

    need_support_wifi=$(GetFeature HW_AMP_FEATURE_WLAN)
    if [ $need_support_wifi = 1 ]; then
        insmod_ko_if_exist /lib/modules/linux/extra/arch/arm/mach-hisi/pcie.ko
        insmod_ko_if_exist /lib/modules/wap/hw_module_acp.ko
    fi
}

function load_wifi_product_ko()
{
    [[ "$bin_type" == "bin6" ]] && return;
    [[ "$bin_type" == "bin5" ]] && return;

    echo "start to load_wifi_ko......"
    insmod_ko_if_exist /lib/modules/wap/hw_module_wifi_np.ko
    insmod_ko_if_exist /lib/modules/wap/hw_module_drv_event.ko
    insmod_ko_if_exist /lib/modules/wap/hw_module_wifi_bsd.ko
    insmod_ko_if_exist /lib/modules/wap/hw_module_wifi_drv.ko
    insmod_ko_if_exist /lib/modules/wap/hw_module_wifi_log.ko
    insmod_ko_if_exist /lib/modules/wap/hw_module_wifi_gpl.ko

    if [ ! -e /mnt/jffs2/wifi_kernel_debug ]; then
        insmod_ko_if_exist /lib/modules/wap/cfg80211.ko
    fi

    if [ -f /mnt/jffs2/Equip_MU_UpGRD_Flag ]; then
        return
    else
        ssid_num=$(cat /proc/wap_proc/pd_static_attr | grep ssid_num | cut -d '"' -f 2)
    fi

    if [ $ssid_num -eq 0 ]; then
        return
    fi
}

function load_wifi_sdk_ko()
{
    #提前加载wifi sdk ko
    cat /proc/bus/pci/devices | cut -f 2 | sort -u | while read dev_id;
    do
        if [ "$dev_id" == "19e51152" -o "$dev_id" == "59e70002" ]; then
            load_np_wifi_ko

            if [ -e /bin/WifiPreDfsInstall.sh ]; then
                echo "Loading hisi ko: "
                # hisi ko提前加载开始标志
                echo > /var/wifi_start_hisi_install
                chmod ug=r,o= /var/wifi_start_hisi_install
                chown -h lsv_wifi:lansrv /var/wifi_start_hisi_install

                WifiPreDfsInstall.sh &
            fi
        elif [ "$dev_id" == "59e70003" ] && [ -e /bin/WifiDyChipInstallKo.sh ]; then
            echo "Loading DY ko: "
            load_np_wifi_ko
            WifiDyChipInstallKo.sh &
        elif [ "$dev_id" == "17cb1104" ]; then
            if [ ! -e /mnt/jffs2/wifi_kernel_debug ]; then
                insmod_ko_if_exist /lib/modules/wap/mhi_core.ko
                insmod_ko_if_exist /lib/modules/wap/mhi_controllers.ko
                insmod_ko_if_exist /lib/modules/wap/qrtr.ko
                [[ -e /bin/qrtr-cfg ]] && qrtr-cfg 1
                [[ -e /bin/qrtr-ns ]] && qrtr-ns &
                insmod_ko_if_exist /lib/modules/wap/qrtr-mhi.ko
                insmod_ko_if_exist /lib/modules/wap/qmi_helpers.ko
                insmod_ko_if_exist /lib/modules/wap/qmi_interface.ko
                insmod_ko_if_exist /lib/modules/wap/qcom_kern.ko
                insmod_ko_if_exist /lib/modules/wap/smem.ko
                if [ -e /lib/modules/wap/cnss2.ko ]; then
                    mix_board=$(GetFeature FT_1151_QCA_MIX_BOARD)
                    if [ $mix_board = 1 ]; then
                        insmod /lib/modules/wap/cnss2.ko bdf_pci0=0xA0 skip_radio_bmap=5
                    else
                        insmod /lib/modules/wap/cnss2.ko bdf_pci0=0xA1 bdf_pci1=0xA0 ramdump_enabled=Y
                    fi
                fi
            fi

            load_np_wifi_ko

            if [ -e /bin/WifiQcaAxInstallKo.sh ]; then
                echo "Loading QCA AX ko: "
                # qca ko提前加载开始标志
                echo > /var/qca_install_ko_start
                chmod ug=r,o= /var/qca_install_ko_start
                chown -h lsv_wifi:lansrv /var/qca_install_ko_start

                WifiQcaAxInstallKo.sh &
            fi
        elif [ "$dev_id" == "808609d0" ]; then
            echo "Loading furud ko: "
        elif [ "$dev_id" == "1d692440" -o "$dev_id" == "1d692442" ]; then
            echo "Loading celeno ko: "
        elif [ "$dev_id" == "10ec818c" -o "$dev_id" == "10ecf812" ]; then
            echo "Loading RTL ko: "
        fi
    done

    touch /var/insmodwifikoend

    echo "end load_wifi_ko......"
}

#rtl单板，语音依赖驱动模块
function load_rtl_dsp_module()
{
    if [ $pots_num -eq 0 ]
    then
        echo -n "Do not start VOICE..."
    else
        echo -n "Start VOICE ..."

        #Luna SDK use awk by default
        major=`grep voip /proc/devices| awk '{print $1}'`
        #major=`grep voip /proc/devices| cut -f 1 -d ' '`
        if [! $major ]; then
            echo "no voip devices!"
        else
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
                bin_type_voice=0

                if [ bin_type_voice -eq 0 ]; then
                    aipc_util -e
                    aipc_util -w -d 0xb0000400 -i /bin/dsp.img
                    aipc_util -b
                else
                    aipc_util -B
                    aipc_util -e
                    aipc_util -w -d 0x02000400 -i /bin/dsp.img
                    aipc_util -b
                fi

                if [ -x "/bin/wait_dsp" ]; then
                    wait_dsp
                else
                    echo "no wait_dsp, so force to sleep 5 seconds..."
                    sleep 5
                fi
            fi
        fi
    fi
}

function start_ldsp()
{
    echo "start to start_ldsp......"
    iLoop=0
    if [ -e /bin/hw_ldsp_cfg ];then
        hw_ldsp_cfg &
        while [ $iLoop -lt 500 ] && [ ! -e /var/hw_ldsp_tmp.txt ] 
        do
            echo $iLoop
            iLoop=$(( $iLoop + 1 ))
            sleep 0.1
        done
        [[ -e /var/hw_ldsp_tmp.txt ]] && rm -rf /var/hw_ldsp_tmp.txt
    fi

    iLoop=0
    if [ -e /bin/hw_ldsp_cfg ];then
        while [ $iLoop -lt 1000 ] && [ ! -e /var/epon_up_mode.txt ] && [ ! -e /var/gpon_up_mode.txt ] && [ ! -e /var/ge_up_mode.txt ] && [ ! -e /var/wifi_up_mode.txt ] 
        do
            echo $iLoop
            iLoop=$(( $iLoop + 1 ))
            sleep 0.1
        done
    fi
    echo "end start_ldsp......"
}

function start_equip_main()
{
    echo "start_equip_main:"
    /usr/bin/ssmp &
}

function start_aging()
{
    if [ -f /mnt/jffs2/equipment/bin/aging ]; then
        echo -n "start_aging..."
        /mnt/jffs2/equipment/bin/aging &
    fi
}

function start_mbist_test()
{
    ##如果内存测试存在，拉起内存测试进程
    if [ -e /lib/modules/wap/hw_module_mbist.ko ] ;then
        echo "Start DDR mbist test..."
        #mbist加载
        insmod /lib/modules/wap/hw_module_mbist.ko
    fi
}

function set_env()
{
    cp /mnt/jffs2/equipment/sign/Equip.sh /var/Equip.sh 2>/dev/null 
    echo "" > /var/notsavedata
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
}

function print_time()
{
    echo "=====================$(date '+%Y-%m-%d %H:%M:%S')===================="
}

function start_other_process()
{
    while true;
    do
        sleep 1
        if [ -f /var/ssmploaddata ] && [ -f /var/cmp_init_success ] ; then
            [[ "$bin_type" != "bin6" ]] && wificli &
            start_aging
            kmc &
            sleep 8
            echo -n "Start mu..."
            mu &
            if [ -f /mnt/jffs2/Equip_MU_UpGRD_Flag ] ; then
                rm -f /mnt/jffs2/Equip_MU_UpGRD_Flag
            fi
            break;
        fi
    done
}

function start_line_omci()
{
    fttr_spt=$(GetFeature FT_FTTR_MAIN_ONT)
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
}

function add_pon_dev_to_br()
{
    i=0
    while [ $i -lt 50 ]
    do
        ifconfig -a | grep pon
        if [ 0 -eq  $? ]; then
            brctl addif br0 pon
            ifconfig pon up
            break
        fi
        i=$(( $i + 1 ))
        sleep 1
    done &
}

function generate_xpon_mode()
{
    var_xpon_mode=$(getboardinfo 0x00000001)
    echo "var_xpon_mode:${var_xpon_mode}"
    echo ${var_xpon_mode}>>/var/var_xpon_mode

    if [ ! -f /mnt/jffs2/xpon_mode ]; then
        case ${var_xpon_mode} in
            4)
                echo '1' > /mnt/jffs2/xpon_mode
                ;;
            12)
                echo '5' > /mnt/jffs2/xpon_mode
                ;;
            15)
                echo '10' > /mnt/jffs2/xpon_mode
                ;;
            *)
                echo ${var_xpon_mode} > /mnt/jffs2/xpon_mode
                ;;
        esac
    fi
    chown -h 3003:2002 /mnt/jffs2/xpon_mode && chmod 640 /mnt/jffs2/xpon_mode

    if [ ${var_xpon_mode} == "4" ] || [ ${var_xpon_mode} == "12" ] || [ ${var_xpon_mode} == "15" ]; then
        pon_type_value=$(cat /mnt/jffs2/xpon_mode)
    else
        pon_type_value=${var_xpon_mode}
    fi
}

# 挂载sdk到/var/目录下
function mount_sdk()
{
    [[ -f /mnt/jffs2/equipnoneedmounttsdk ]] && return;
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
                    ontchown -h 3008:2002 /mnt/jffs2/sdk_mnt && ontchmod 770 /mnt/jffs2/sdk_mnt
                    mount -t ubifs -o sync /dev/$file /mnt/jffs2/sdk_mnt
                    break;
                fi
            fi
        fi
    done
 
    # 挂载sdk到/var/目录下
    if [ -d /mnt/jffs2/sdk_mnt ]; then
        echo "load sdk start"
        loadsdkfs sdkequip
        echo "load sdk end"
    fi
}

function generate_equip_ip_enable()
{
    [[ ! -f /mnt/jffs2/equip_ip_enable ]] && echo "" > /mnt/jffs2/equip_ip_enable
}

function generate_product_line_mode()
{
    [[ ! -f /mnt/jffs2/ProductLineMode ]] && echo "" > /mnt/jffs2/ProductLineMode
    chown -h mgt_ssmp:mngt /mnt/jffs2/ProductLineMode
}

function generate_module_desc_xml()
{
    local var_equipment_file="/mnt/jffs2/equipment.tar.gz"
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
}

function generate_hardinfo_spec()
{
    echo "equipment modify"
    if [ -f /lib/modules/wap/hw_wifi_diagnose_ct.ko ];then
        echo "modify hw_hardinfo_spec"
        if [ ! -f /mnt/jffs2/hw_hardinfo_spec ];then
            echo 'spec.name="AMP_SPEC_SSID_NUM_MAX_BAND" spec.type="uint" spec.value="4"'>>/mnt/jffs2/hw_hardinfo_spec
        fi
    fi
}

function generate_customize_relation_cfg()
{
    #判断/mnt/jffs2/customize_xml.tar.gz文件是否存在，存在解压
    if [ -e /mnt/jffs2/customize_xml.tar.gz ]
    then
        #解析customize_relation.cfg
        tar -xzf /mnt/jffs2/customize_xml.tar.gz -C /mnt/jffs2/ customize_xml/customize_relation.cfg  
    fi
}

function generate_jffs2_file()
{
    generate_module_desc_xml
    generate_customize_relation_cfg
    generate_hardinfo_spec
    generate_product_line_mode
    generate_equip_ip_enable
    generate_xpon_mode
}

function load_hisi_cdk()
{
    echo "start to load_hisi_cdk......"
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
 
    if [ -f /var/TsdkFs/lib/modules/hisi_cdk/hal_np.ko ]; then
        insmod /var/TsdkFs/lib/modules/hisi_cdk/hal_np.ko
    elif [ -f /lib/modules/hisi_cdk/hal_np.ko ]; then
        insmod /lib/modules/hisi_cdk/hal_np.ko
    fi
}
function insmod_xgpon_ko()
{
    insmod hi_xgmac.ko
    insmod_ko_if_exist $sdk_path/hi_xgpon.ko
    if [ $flashtype_v5 = 1 ] || [ -f $sdk_path/hi_gpon.ko ]; then
        insmod hi_gpon.ko
    fi
}

function insmod_xepon_ko()
{
    insmod hi_xemac.ko
    insmod hi_xepon.ko
    if [ $flashtype_v5 = 1 ] || [ -f $sdk_path/hi_epon.ko ]; then
        insmod hi_epon.ko
    fi
}

function insmod_gpon_ko()
{
    insmod $sdk_path/hi_gmac.ko
    insmod $sdk_path/hi_gpon.ko
}

function insmod_epon_ko()
{
    insmod $sdk_path/hi_emac.ko
    insmod $sdk_path/hi_epon.ko
}

function insmod_hisi_ko_by_xpon_mode()
{
    if [ -f /lib/modules/wap/hw_module_ploam_proxy.ko ]; then
        insmod hi_xgmac.ko
        insmod_gpon_ko
    elif [ ${var_xpon_mode} == "5" ] || [ ${pon_type_value} == "5" ]; then
        insmod_xgpon_ko
    elif [ ${var_xpon_mode} == "6" ] || [ ${pon_type_value} == "6" ]; then
        insmod_xepon_ko
    elif [ ${var_xpon_mode} == "7" ]; then
        insmod_xepon_ko
    elif [ ${var_xpon_mode} == "10" ] || [ ${pon_type_value} == "10" ]; then
        insmod_xgpon_ko
    elif [ ${var_xpon_mode} == "1" ] || [ ${pon_type_value} == "1" ]; then
        insmod_gpon_ko
    elif [ ${var_xpon_mode} == "2" ] || [ ${pon_type_value} == "2" ]; then
        insmod_epon_ko
    elif [ ${var_xpon_mode} == "3" ]; then
        echo "eth mode"
    else
        insmod_epon_ko
        insmod_gpon_ko
    fi
    
    #特殊接口在此ko中初始化注册，仅限GPON产品加载
    if [ ${var_xpon_mode} == "1" ] || [ ${var_xpon_mode} == "5" ] || [ ${var_xpon_mode} == "10" ] ||\
        [ ${pon_type_value} == "1" ] || [ ${pon_type_value} == "5" ] || [ ${pon_type_value} == "10" ]; then
        insmod /lib/modules/hisi_sdk/hi_gpon_api_regist.ko
    fi

    if [ $chip_type -eq 5115 ]; then
        insmod hi_l3_5115.ko
    else
        insmod hi_l3.ko
    fi    
    insmod hi_oam.ko
}

function load_xd_5610_hisi_sdk()
{
    insmod hi_sdk_kbasic.ko	
    insmod hi_sdk_l0.ko
    insmod hi_sdk_l0_dump.ko
    insmod hi_sdk_l0_oam.ko
    insmod hi_sdk_l1.ko
    insmod hi_adp_cnt.ko
    insmod hi_sdk_adpt.ko
    insmod hi_hw.ko
    insmod hi_spi.ko
    if [ -f /lib/modules/wap/equ_fwd.ko ]; then
        insmod hi_pie.ko tx_chk=0
    else
        insmod hi_pie.ko tx_chk=0 equip_mode=1
    fi

    insmod hi_gpio_5610.ko
    insmod hi_i2c.ko
    insmod hi_timer.ko
    insmod hi_serdes.ko	
    insmod hi_uart.ko
}

function load_hisi_sdk()
{
    insmod_ko_if_exist $1/hi_sal.ko

    #如果有多芯片注册KO，则注册多芯片，否则注册单芯片
    if [ -f /lib/modules/wap/hw_module_multichip.ko ]; then
        insmod hi_sysctl.ko g_chipnum=2
    else
        insmod hi_sysctl.ko
    fi

    #合并之后的ko只需要加载一个
    insmod hi_ecs.ko
    insmod hi_i2c_slave.ko
    insmod hi_ponlink.ko
    insmod_ko_if_exist $1/hi_hilink.ko  #18v1v2的serdies

    if [ $flashtype_v5 = 1 ]; then
        insmod hi_crg.ko pPhyPatchPath=$phy_ponlink_path g_pSerdesFirmwarePath=$phy_ponlink_path
        insmod hi_gemac.ko
        insmod_ko_if_exist $1/hi_xgemac.ko
        insmod hi_pcs.ko
        insmod hi_dp.ko gemport_expand=1
    else
        if [ -f $sdk_path/hi_crg.ko ]; then
            insmod hi_crg.ko pPhyPatchPath=$phy_ponlink_path g_pSerdesFirmwarePath=$phy_ponlink_path
            insmod hi_gemac.ko
            insmod hi_xgemac.ko
            insmod hi_pcs.ko
        fi
        if [ $chip_type -eq 5115 ]; then
            insmod hi_dp_5115.ko
        else
            insmod hi_dp.ko
        fi
    fi

    insmod hi_bridge.ko
    if [ -f /lib/modules/wap/equ_fwd.ko ]; then
        insmod /lib/modules/hisi_sdk/hi_pie.ko tx_chk=0
    else
        insmod /lib/modules/hisi_sdk/hi_pie.ko tx_chk=0 equip_mode=1
    fi
    insmod hi_ponlp.ko
    insmod_hisi_ko_by_xpon_mode
    if [ -f /mnt/jffs2/aging/request_mbist ] && [ ! -f /mnt/jffs2/aging/mbist_end ]; then
        echo " find request_mbist , no mbist_end , not imsmod np.ko "
    else
        insmod_ko_if_exist $sdk_path/hi_woe.ko
    fi
}

# 加载hisi插件ko
function load_hisi_plug_ko()
{
    echo "start to load_hisi_plug_ko......"

    cd $sdk_path
    echo "Loading the HISI SD511X modules: "

    load_hisi_sdk $sdk_path
    load_hisi_cdk
    cd -
    echo "end load_hisi_plug_ko......"
}

function load_ldsp_module()
{
    echo "start load_ldsp_module................"

    insmod /lib/modules/wap/hw_module_common.ko
    insmod /lib/modules/wap/hw_module_bus.ko
    insmod_ko_if_exist  /lib/modules/wap/hw_module_i2c_slave.ko
    insmod /lib/modules/wap/hw_module_dev.ko
    insmod_ko_if_exist /lib/modules/wap/hw_module_extgpio.ko

    dir_cdk_para=/var/amp_cdk_para
    mkdir -p $dir_cdk_para && ontchown 3003:2002 $dir_cdk_para && ontchmod 640 $dir_cdk_para
    insmod_ko_if_exist /lib/modules/wap/hw_module_cdk.ko
    if [ -f /mnt/jffs2/defaultGroup.bin ]; then
        rm /mnt/jffs2/defaultGroup.bin
    fi
    echo "end load_ldsp_module................"
}

function insmod_all_ko()
{
    echo "start insmod_all_ko....."
    #加载多芯片注册KO
    insmod_ko_if_exist /lib/modules/wap/hw_module_multichip.ko
    load_hisi_plug_ko
    load_ldsp_module
    insmod /lib/modules/wap/hw_dm_pdt.ko
    reload_feature
    insmod /lib/modules/wap/hw_module_amp.ko
    insmod_ko_if_exist /lib/modules/wap/equip_fake_ker.ko
    insmod_ko_if_exist /lib/modules/wap/hw_amp.ko
    insmod /lib/modules/wap/hw_module_l2qos.ko
    load_optic_pon_ko
    start_mbist_test
    get_hardware_ability
    insmod_hw_ko_by_xpon_mode
    #关键文件校验log恢复
    ProcDataWh -l
    insmod_slave_chip_ko
    excute_loadexfs &
    insmod_ko_if_exist /lib/modules/wap/hw_ssp_gpl_ext.ko
    insmod_ko_if_exist /lib/modules/wap/hw_ssp_gpl_ext_add.ko
    insmod_fpga_ko
    echo "end insmod_all_ko....."
}

function load_usb_module()
{
     [[ "$bin_type" == "bin6" ]] && return 0;
    echo "start to load_usb_module......"
    while true;
    do
        if [ -f /var/ssmploadconfig ]; then
            insmod_ko_by_usb_num $usb_num > /dev/null 2>&1
            feature_dect=$(GetFeature FT_LTE_SUPPORT)
            if [ $feature_dect -eq 1 ] ;then
                if [ $usb_num -ne 0 ]; then
                    /etc/wap/usb/init_usb.sh
                fi
            fi
            touch /var/insmodusbkoend
            break 
        fi
        sleep 0.01
    done
    echo "end to load_usb_module......"
}

function load_dsp_module()
{
    [[ "$bin_type" == "bin6" ]] && return 0;
    echo "start to load_dsp_module......"
    while true;
    do
        if [ -f /var/ssmploadconfig ]; then
            insmod_ko_by_pots_num $pots_num > /dev/null 2>&1
            if [ $pots_num -ne 0 ]; then
                feature_soft_dsp=$(GetFeature VOICE_FT_SOFT_DSP)
                insmod /lib/modules/wap/hw_module_dopra.ko
                if [ $feature_soft_dsp = 1 ] ;then
                    echo "Loading DSP 1 modules: "
                    if [ -f /lib/modules/wap/hw_module_rtk_dsp_sdk.ko ]; then
                        insmod /lib/modules/wap/hw_module_rtk_dsp_sdk.ko
                    else
                        insmod /lib/modules/wap/hw_module_soft_dsp_sdk.ko
                    fi
                else
                    echo "Loading DSP 2 modules: "
                    if [ -f /lib/modules/wap/hw_module_rtk_dsp_sdk.ko ]; then
                        echo "Loading RTK DSP modules: "
                        insmod /lib/modules/wap/hw_module_rtk_dsp_sdk.ko
                    else
                        insmod /lib/modules/wap/hw_module_dsp_sdk.ko
                    fi
                fi
                insmod /lib/modules/wap/hw_module_dsp.ko
            fi
            echo 1 > /proc/sys/net/ipv4/ip_forward
            echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
            echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
            echo > /var/insmoddspkoend
            break
        fi
        sleep 0.01
    done
    echo "end load_dsp_module......"
}

function load_usb_dsp_module()
{
    if [ "$wlan_cali_flag" != "True" ] && [ "$ssid_num" != "0" ]; then
        #最多等待30s，自动加载usb和dsp
        i=0
        while [ $i -lt 30 ]
        do
            sleep 1
            if [ -f /var/wlan_init_end_flag ]; then
                break
            fi
            i=$(( $i + 1 ))
        done
    fi

    # wifi 校准的场景优先等wifi的ko插入完再加载usb和dsp
    load_usb_module &
    load_dsp_module &
}

function do_after_ssmp_init()
{
    [[ ${var_xpon_mode} != "2" ]] && cd  && insmod_epon_ko
    [[ ${var_xpon_mode} == "2" ]] && insmod_gpon_ko
    if [ ${var_xpon_mode} == "1" ] || [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "5" ] || [ ${var_xpon_mode} == "10" ]; then
        insmod_ko_if_exist /lib/modules/wap/hw_ker_optic_chip_511x_equip.ko
    fi

    if [ -f /mnt/jffs2/Equip_MU_UpGRD_Flag ];then
        pots_num=0
        usb_num=0
        ssid_num=0
    else
        pots_num=$(cat /proc/wap_proc/pd_static_attr | grep pots_num | cut -d '"' -f 2)
        usb_num=$(cat /proc/wap_proc/pd_static_attr | grep usb_num | cut -d '"' -f 2)
        ssid_num=$(cat /proc/wap_proc/pd_static_attr | grep ssid_num | cut -d '"' -f 2)
    fi
    echo "pots_num="$pots_num
    echo "usb_num="$usb_num
    echo "ssid_num="$ssid_num
    load_usb_dsp_module &
    local result=$(cat /proc/mtd | grep app | wc -l)
    if [ "$result" != "0" ]; then
        mount_app_system
    fi
    echo 4 > /proc/sys/kernel/printk
}

function load_kbox()
{
    echo 153600 > /sys/module/kbox/parameters/kbox_default_reg_size
    echo "0x81080000 512K" > /proc/kbox/mem

    var_kbox_config=`cat /proc/kbox/mem`
    echo "kbox config(Addr---Size)="$var_kbox_config

    #打开4.4 R死锁检测softlockup，分配128K大小，OOM大小为128K
    echo 64 > /proc/sys/kernel/softlockup_log_size
    echo 128 > /proc/oom_extend/kbox_region_size
    echo 1 > /proc/sys/kernel/watchdog
    echo 2 500 > /proc/sys/kernel/watchdog_thresh

    #打印进程快照，必须在kbox配置之后
    insmod  /lib/modules/linux/mts/rtos_snapshot.ko log_size=164

    cd /var
    dlw 1 > lastsysinfo
    var_size=`stat -c %s /var/lastsysinfo`
    if [ $var_size -gt 1024 ]; then
        echo "save sys info"
        echo "=======kbox panic=======" >> lastsysinfo
        cat /proc/kbox/regions/panic >> lastsysinfo
        echo "=======kbox deadlock======" >> lastsysinfo
        cat /proc/kbox/regions/deadlock >> lastsysinfo
        echo "======kbox ks_0======" >> lastsysinfo
        cat /proc/kbox/regions/ks_0 >> lastsysinfo
        echo "=======kbox ks_1======" >> lastsysinfo
        cat /proc/kbox/regions/ks_1 >> lastsysinfo
        echo "=======kbox ks_2======" >> lastsysinfo
        cat /proc/kbox/regions/ks_2 >> lastsysinfo
        echo "=======kbox ks_3======" >> lastsysinfo
        cat /proc/kbox/regions/ks_3 >> lastsysinfo
        echo "=======kbox ks_4======" >> lastsysinfo
        cat /proc/kbox/regions/ks_4 >> lastsysinfo
        echo "=======kbox ks_main======" >> lastsysinfo
        cat /proc/kbox/regions/ks_main >> lastsysinfo

        tar -czf lastsysinfo.tar.gz lastsysinfo
    fi
    rm -rf lastsysinfo
    cd /

    if [ -f /var/lastsysinfo.tar.gz ]; then
        mv -f /var/lastsysinfo.tar.gz /mnt/jffs2/lastsysinfo.tar.gz && ontchown :2002 /mnt/jffs2/lastsysinfo.tar.gz
        chmod 440 /mnt/jffs2/lastsysinfo.tar.gz
    fi

    return 0
}

function main()
{
    echo "enter main..................................."
    set_env
    generate_jffs2_file
    # load sdk
    mount_sdk
    insmod_all_ko
    load_bbsp_module
    load_pcie_ko
    get_wlan_calibration_flag
    if [ "$wlan_cali_flag" != "True" ]; then
        load_wifi_product_ko
        load_wifi_sdk_ko &
        loadsdkfs
        start_ldsp
        load_kbox
    else
        loadsdkfs &
        start_ldsp &
        load_kbox &
        wait
        load_wifi_product_ko
        load_wifi_sdk_ko &
    fi

    start_equip_main
    print_time
    do_after_ssmp_init &
    start_other_process &
    start_line_omci &
    add_pon_dev_to_br &
    echo "end............................................"
}

print_time
main