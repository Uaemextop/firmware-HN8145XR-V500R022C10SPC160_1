#! /bin/sh

# 写入一个SSID的recover脚本，该脚本通过读取 /var/customizepara.txt
# 文件中的定制信息，来将定制信息写入ctree中
#customize.sh COMMON_WIFI XXX SSID WPA密码
# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/var/customizepara.txt

# 定制信息写入文件，该文件通过tar包解压后复制产生
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree=/var/hw_default_ctree.xml

var_pack_temp_dir=/bin/

var_ssid1=""
var_wpa1=""

var_ssid2=""
var_wpa2=""
var_web_pwd=""
var_web_passwd_len=8

cli_olt_modifyFlag=1

# check the customize file
HW_Script_CheckFileExist()
{
    if [ ! -f "$var_customize_file" ] ;then
        echo "ERROR::customize file is not existed."
        return 1
    fi
    return 0
}

# read data from customize file
HW_Script_ReadDataFromFile()
{
    read -r var_ssid1 var_wpa1 var_ssid2 var_wpa2 var_web_pwd < $var_customize_file
    if [ 0 -ne $? ]
    then
        echo "Failed to read spec info!"
        return 1
    fi
    return
}

# set customize data to file
HW_Script_SetDatToFile()
{
    var_node_ssid1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
    var_node_wpa_pwd1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1

    var_node_ssid2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5
    var_node_wpa_pwd2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5.PreSharedKey.PreSharedKeyInstance.1

    var_node_web_pwd=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.1

    # set ssid 
    cfgtool set $var_default_ctree $var_node_ssid1 SSID $var_ssid1
    if [ 0 -ne $? ]
    then
        echo "Failed to set common ssid1 name!"
        return 1
    fi

    cfgtool set $var_default_ctree $var_node_ssid2 SSID $var_ssid2
    if [ 0 -ne $? ]
    then
        echo "Failed to set common ssid2 name!"
        return 1
    fi

    # set wpa password
    cfgtool set $var_default_ctree $var_node_wpa_pwd1 PreSharedKey $var_wpa1
    if [ 0 -ne $? ]
    then
        echo "Failed to set common ssid1 wap password!"
        return 1
    fi

    cfgtool set $var_default_ctree $var_node_wpa_pwd2 PreSharedKey $var_wpa2
    if [ 0 -ne $? ]
    then
        echo "Failed to set common ssid2 wap password!"
        return 1
    fi

    cfgtool set $var_default_ctree $var_node_web_pwd Password $var_web_pwd
    if [ 0 -ne $? ]
    then
        echo "Failed to set web common user password!"
        return 1
    fi

    #设置普通用户出厂密码，没有就新增
    cfgtool gettofile $var_default_ctree $var_node_web_pwd "FactoryPassword"
    if [ 0 -eq $? ]
    then
        cfgtool set $var_default_ctree $var_node_web_pwd "FactoryPassword" $var_web_pwd
    else
        cfgtool add $var_default_ctree $var_node_web_pwd "FactoryPassword" $var_web_pwd
    fi

    return
}

HW_Script_CheckWebPasswd()
{
    if [ ${#var_web_pwd} -ne $var_web_passwd_len ]
    then
        echo "The length of web password is not eight"
        return 1
    fi
    return
}

#
HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

#
HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

HW_Script_CheckWebPasswd
[ ! $? == 0 ] && exit 1

#
HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "set spec info OK!"

exit 0