#! /bin/sh

set +x

#从SPEC中获取MAC地址
mac_common=$(GetSpec SPEC_WIFI_EQUIP_HISI_COMMON_MAC)

# wifi_equipment 使用方法
PrintOutUsage()
{
	echo "Usage:"
	echo "wifi_equipment.sh init chip {1|2} max xx:xx:xx:xx:xx:xx"
	echo "wifi_equipment.sh del chip {1|2} max xx:xx:xx:xx:xx:xx"
	echo "wifi_equipment.sh config chip {1|2} direction {tx|rx} switch {start|stop}"
	echo "wifi_equipment.sh config chip {1|2} direction rx mode 11ax2g20 bw 20 ch 3 mcs 7 ant 1"
	echo "wifi_equipment.sh config chip {1|2} direction tx mode 11ax2g20 bw 20 ch {chValue} {rate {1|6} | mcs 0 | mcsac {0|9|11}} ant 1 tid x x x mac xx:xx:xx:xx:xx:xx"
	exit 255
}

#================================================================
# 各芯片公用函数

#Notice: 这个函数无法传递引号参数
RunCmd()
{
	echo "$* "
	$*
}

iwprivWrapper()
{
	vapStr=$1

	if [ $2 = "alg" ]; then
		shift 2
		echo "iwpriv $vapStr alg" \"$*\"
		iwpriv $vapStr alg "$*" > /tmp/null_alg_log
	elif [ $2 = "fast_aging" ]; then 
		shift 2
		echo "iwpriv $vapStr fast_aging" \"$*\"
		iwpriv $vapStr fast_aging "$*" > /tmp/null_alg_log
	else
		echo "iwpriv" $*
		iwpriv $* > /tmp/null_log
	fi

	returnCodeStr=$?

	if [ "$returnCodeStr"x != "0"x ]; then
		sucStr="fail!($returnCodeStr)"
	fi
}

HiPrivWrapper()
{
	echo hipriv.sh \"$*\"
	hipriv.sh "$*"
}

#=================================================================
# HISI 1152 芯片命令适配

#参数格式 mac 06:05:xx:xx:02:04
wifi_chip_init_hi1152_2G()
{
	#从SPEC中获取MAC地址
	mac_5G=$(GetSpec SPEC_WIFI_EQUIP_HISI_5G_MAC)

	hostapd_pids=`pidof hostapd`
	if [ "$hostapd_pids" != "" ];
	then
		RunCmd kill -15 $hostapd_pids
		RunCmd sleep 0.3
	fi
	RunCmd ifconfig vap4 down
	RunCmd ifconfig vap4 hw ether $mac_5G    #设置单板5Gmac地址为其他mac

	iwprivWrapper vap0 set_eqmode 1 #进入装备模式
	RunCmd ifconfig vap0 down
	iwprivWrapper vap0 setcountry 99
	RunCmd ifconfig vap0 hw ether $mac_common    #设置单板mac地址
	iwprivWrapper vap0 setessid hi1152_2g
	iwprivWrapper vap0 privflag 2
	iwprivWrapper vap0 freq 1
	iwprivWrapper vap0 mode 11ax2g20
	iwprivWrapper vap0 privflag 1
	RunCmd ifconfig vap0 up
	iwprivWrapper vap0 privflag 2
	HiPrivWrapper "vap0 alg_cfg edca_opt_en_ap 0" #关edca
	iwprivWrapper vap0 nobeacon 1 #关beacon
	HiPrivWrapper "vap0 add_user $2 3"
	iwprivWrapper vap0 alg "tpc_mode 0"
	iwprivWrapper vap0 fast_aging "enable 0" #关fast_aging
	iwprivWrapper vap0 alg "online_dpd 0 0"
	iwprivWrapper vap0 alg "online_iq 0 0 0"
	iwprivWrapper vap0 alg "online_iq 0 1 0"
}

#参数格式 mac 06:05:xx:xx:02:04
wifi_chip_init_hi1152_5G()
{
	#从SPEC中获取MAC地址
	mac_2G=$(GetSpec SPEC_WIFI_EQUIP_HISI_2G_MAC)

	hostapd_pids=`pidof hostapd`
	if [ "$hostapd_pids" != "" ];
	then
		RunCmd kill -15 $hostapd_pids
		RunCmd sleep 0.3
	fi
	RunCmd ifconfig vap0 down
	RunCmd ifconfig vap0 hw ether $mac_2G    #设置单板2.4Gmac地址为其他mac

	iwprivWrapper vap4 set_eqmode 1 #进入装备模式
	RunCmd ifconfig vap4 down
	iwprivWrapper vap4 setcountry 99
	RunCmd ifconfig vap4 hw ether $mac_common    #设置单板mac地址
	iwprivWrapper vap4 setessid hi1152_5g
	iwprivWrapper vap4 privflag 2
	iwprivWrapper vap4 freq 36
	iwprivWrapper vap4 mode 11ax20
	iwprivWrapper vap4 privflag 1
	RunCmd ifconfig vap4 up
	iwprivWrapper vap4 privflag 2
	HiPrivWrapper "vap4 alg_cfg edca_opt_en_ap 0" #关edca
	iwprivWrapper vap4 nobeacon 1 #关beacon
	HiPrivWrapper "vap4 add_user $2 3"
	iwprivWrapper vap4 alg "tpc_mode 0"
	iwprivWrapper vap4 fast_aging "enable 0" #关fast_aging
	iwprivWrapper vap4 alg "online_dpd 0 0"
	iwprivWrapper vap4 alg "online_iq 0 0 0"
	iwprivWrapper vap4 alg "online_iq 0 1 0"
}

#参数格式 mac 06:05:xx:xx:02:04
wifi_chip_del_hi1152_2G()
{
	HiPrivWrapper "vap0 del_user $2 3"
}

#参数格式 mac 06:05:xx:xx:02:04
wifi_chip_del_hi1152_5G()
{
	HiPrivWrapper "vap4 del_user $2 3"
}

#$* ->  "vap0 direction tx switch start"
wifi_chip_action_hi1152()
{
	vapStr=$1
	direction=$3
	switch=$5
	directionStr="al_tx"
	startStr="1"

	if [ "$direction"x != "tx"x ]; then
		directionStr="al_rx"
	fi

	if [ "$switch"x != "start"x ]; then
		startStr="0"
	fi

	if [ "$directionStr"x = "al_tx"x ] && [ "$startStr"x = "1"x ]; then
		echo "iwpriv" $vapStr $directionStr \"1 10 2 1500 0\"
		iwpriv $vapStr $directionStr "1 10 2 1500 0" > /tmp/null_log
	else
		iwprivWrapper $vapStr $directionStr $startStr
	fi
}

#./wifiequipment.sh config chip 1 direction tx switch start
wifi_chip_action_hi1152_2G()
{
	wifi_chip_action_hi1152 "vap0" $*
}

wifi_chip_action_hi1152_5G()
{
	wifi_chip_action_hi1152 "vap4" $*
}

#传递参数 $* 为 "vap0 direction rx mode 11ax2g20 bw 20 ch 3 mcs 7 ant 1 mac 06:05:xx:xx:02:04" 
wifi_chip_config_rx_hi1152()
{
	vapStr=$1
	modeStr=$5
	freqStr=${9}
	ant=${13}
	chMaskStr="0011"

	if [ ${ant} = 1 ]; then
		chMaskStr="0001"
	elif [ ${ant} = 2 ]; then
		chMaskStr="0010"
	fi

	iwprivWrapper $vapStr freq $freqStr
	iwprivWrapper $vapStr mode $modeStr
	HiPrivWrapper "$vapStr add_user ${15} 3"
	iwprivWrapper $vapStr rxch $chMaskStr
}

#./wifi_equipment.sh config chip 1 direction rx mode 11ax2g20 bw 20 ch 3 mcs 7 ant 1
wifi_chip_config_rx_hi1152_2G()
{
	wifi_chip_config_rx_hi1152 "vap0" $*
}

wifi_chip_config_rx_hi1152_5G()
{
	wifi_chip_config_rx_hi1152 "vap4" $*
}

#传递参数 $* 为 "vap0 direction tx mode 11ax2g20 bw 20 ch 1 rate 1 ant 1 tid 6 0 0 mac 06:05:xx:xx:02:04" 
wifi_chip_config_tx_hi1152()
{
	vapStr=$1
	modeStr=$5
	bwStr=${7}
	freqStr=${9}
	rateStr=${10}
	rateValue=${11}
	ant=${13}
	tid0=${15}
	tid1=${16}
	tid2=${17}
	macStr=${19}
	chMaskStr="0011"

	if [ "$ant"x = "1"x ]; then
		chMaskStr="0001"
	elif [ "$ant"x = "2"x ]; then
		chMaskStr="0010"
	elif [ "$ant"x = "all"x ]; then
		if [ ${rateValue} -lt 8 ]; then
			rateValue=`expr ${rateValue} + 8`;
		fi
	fi

	iwprivWrapper $vapStr privflag 2
	iwprivWrapper $vapStr freq $freqStr
	iwprivWrapper $vapStr mode $modeStr
	if [ "$vapStr"x = "vap0"x ]; then
		RunCmd sleep 0.4
	fi

	HiPrivWrapper "$vapStr add_user $macStr 3"
	iwprivWrapper $vapStr alg "su_sch_user $macStr"
	iwprivWrapper $vapStr alg "su_sch_tid $tid0 $tid1 $tid2"

	if [ "$rateStr"x = "rate"x ]; then
		if [ ${rateValue} = 1 ] || [ ${rateValue} = 2 ] || [ ${rateValue} = 5.5 ] || [ ${rateValue} = 11 ]; then
			#2G/5G 11b
			iwprivWrapper $vapStr alg "ucast_data preamble_type long"
		fi
	fi

	if [ "$ant"x = "all"x ]; then
		if [ "$rateStr"x = "mcs"x ]; then
			iwprivWrapper $vapStr alg "ucast_data hi_rate 0 11n nss2 mcs${rateValue} long"
		elif [ "$rateStr"x = "mcsac"x ]; then
			iwprivWrapper $vapStr alg "ucast_data hi_rate 0 11ac nss2 mcs${rateValue} long"
		elif [ "$rateStr"x = "mcsax"x ]; then
			iwprivWrapper $vapStr alg "ucast_data hi_rate 0 11ax_su nss2 mcs${rateValue} gi4"
			iwprivWrapper $vapStr alg "ucast_data he_ltf_type 0 4x"
			iwprivWrapper $vapStr alg "ucast_data fec_coding ldpc"
		fi
	else
		iwprivWrapper $vapStr $rateStr $rateValue

		if [ "$rateStr"x = "mcsax"x ]; then
			#2G/5G 11ax
			iwprivWrapper $vapStr alg "ucast_data he_ltf_type 0 4x"
			iwprivWrapper $vapStr alg "ucast_data fec_coding ldpc"
		fi
	fi

	iwprivWrapper $vapStr bw $bwStr
	iwprivWrapper $vapStr alg "txmode_mode_sw enable"
	iwprivWrapper $vapStr txch $chMaskStr
}


#传递参数 $* "vap0 direction tx ant 1" 
wifi_chip_ant_hi1152()
{
	vapStr=$1
	ant=${5}
	chMaskStr="0011"

	if [ ${ant} = 1 ]; then
		chMaskStr="0001"
	elif [ ${ant} = 2 ]; then
		chMaskStr="0010"
	fi

	iwprivWrapper $vapStr txch $chMaskStr
}
#传递参数 $* "vap0 direction tx rate/mcsax 1" 
wifi_chip_rate_hi1152()
{
	vapStr=$1
	rateStr=$5
	rateValue=${6}
	
	if [ "$rateStr"x = "rate"x ]; then
		if [ ${rateValue} = 1 ] || [ ${rateValue} = 2 ] || [ ${rateValue} = 5.5 ] || [ ${rateValue} = 11 ]; then
			#2G/5G 11b
			iwprivWrapper $vapStr alg "ucast_data preamble_type long"
		fi
	fi

	iwprivWrapper $vapStr $rateStr $rateValue

	if [ "$rateStr"x = "mcsax"x ]; then
		#2G/5G 11ax
		iwprivWrapper $vapStr alg "ucast_data he_ltf_type 0 4x"
		iwprivWrapper $vapStr alg "ucast_data fec_coding ldpc"
	fi
}


#./wifiequipment.sh config chip 1 direction tx mode 11b bw 20 ch 1 rate 1 ant 1
wifi_chip_config_tx_hi1152_2G()
{
	wifi_chip_config_tx_hi1152 "vap0" $*
}

wifi_chip_config_tx_hi1152_5G()
{
	wifi_chip_config_tx_hi1152 "vap4" $*
}


wifi_chip_ant_hi1152_2G()
{
    wifi_chip_ant_hi1152 "vap0" $*
}

wifi_chip_ant_hi1152_5G()
{
    wifi_chip_ant_hi1152 "vap4" $*
}

wifi_chip_rate_hi1152_2G()
{
    wifi_chip_rate_hi1152 "vap0" $*
}

wifi_chip_rate_hi1152_5G()
{
    wifi_chip_rate_hi1152 "vap4" $*
}

#===================================================

#wifi_equipment 命令框架
wifi_equip_do_cmd()
{
	cmd_func_str=$1
	chip_type=$2
	chip_band=$3

	shift 3
	args=$*

	cmd_func="${cmd_func_str}_${chip_type}_${chip_band}"

	if [ "$(type -t $cmd_func)" != "function"  -a "$(type -t $cmd_func)" != "$cmd_func" ] ; then
		echo "$cmd_func : Not support!"
		exit 255
	fi

	$cmd_func $args

	echo "success!"
}

#=========================================================

wifi_equipment_get_band_type()
{
	band=$1
	chip_band=""

	case $band in 
		1)
		chip_band="2G"
		;;

		2)
		chip_band="5G"
		;;

		3)
		chip_band="5G_HIGHBAND"
		;;
	esac

	echo $chip_band
}

wifi_equipment_get_chip_type()
{
	band_arg=$1
	wifi_dev_list=""
	band_2g="NON"
	band_5g="NON"
	band_5g_high="NON"

	wifi_dev_list=`cat /proc/bus/pci/devices | cut -f 2`

	for dev_id in $wifi_dev_list;
	do
		case $dev_id in
		#mars_5v2
		19e51152 )
			if [ "$band_2g" = "hi1152" ];then
				band_5g="hi1152"   #1152 双频
			fi
			band_2g="hi1152"
			;;
		59e70002 )
			if [ "$band_2g" = "hi1152" ];then
				band_5g="hi1152"   #1152 双频
			fi
			band_2g="hi1152"
			;;
		* )
		echo "$dev_id unknow!"
		exit 255
		esac
	done

	if [ "$band_arg" = "1" ];then
		echo "$band_2g" 
	elif [ "$band_arg" = "2" ];then
		echo "$band_5g"  
	elif [ "$band_arg" = "3" ];then
		echo "$band_5g_high"
	else
		echo "NON"
	fi
}

#装备测试主函数
wifi_equipment_main()
{
	subcmd=$1
	chip_band=""
	chip_type="hi1152"
	band_arg="1"

	#跳过 subcmd 和 chip 参数
	shift 2
	band_arg=$1

	#获取命令操作频段
	chip_band=$(wifi_equipment_get_band_type $band_arg)
	chip_type=$(wifi_equipment_get_chip_type $band_arg)

	#跳过 band 参数
	shift
	args=$*
	args_num=$#

	case $subcmd in
	 "init")
		wifi_equip_do_cmd "wifi_chip_init"  $chip_type $chip_band $args
		;;

	"del")
		wifi_equip_do_cmd "wifi_chip_del" $chip_type $chip_band $args
		;;

	"config")
		if [ "$#" = "4" ];then
			if [ "$3" = "ant" ];then
				wifi_equip_do_cmd "wifi_chip_ant" $chip_type $chip_band $args
			elif [ "$3" = "switch" ];then 
				wifi_equip_do_cmd "wifi_chip_action" $chip_type $chip_band $args
			else
				wifi_equip_do_cmd "wifi_chip_rate" $chip_type $chip_band $args
			fi
		elif [ "$#" = "14" ];then 
			wifi_equip_do_cmd "wifi_chip_config_rx" $chip_type $chip_band $args
		elif [ "$#" = "18" ];then 
			wifi_equip_do_cmd "wifi_chip_config_tx" $chip_type $chip_band $args
		else
			PrintOutUsage
		fi
		;;

	"help")
		PrintOutUsage
		;;

	* )
		echo "unknown command $subcmd"
		PrintOutUsage
		;;
	esac
}

# 脚本执行入口
wifi_equipment_main $*

