#! /bin/sh

# 写入一个SSID的recover脚本，该脚本通过读取 /var/customizepara.txt 
# 文件中的定制信息，来将定制信息写入ctree中
#customize.sh COMMON_WIFI XXX SSID WPA密码
# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/var/customizepara.txt

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree_var=/var/hw_default_ctree.xml
var_default_ctree2_var=/var/hw_default_ctree2.xml
var_default_ctree=/var/hw_default_ctree.xml
var_default_ctree2=/var/hw_default_ctree2.xml
var_pack_temp_dir=/bin/
var_boardinfo_dup="/var/dup_boardinfo"

var_userpwd=""
var_specsn=""


var_OperatorId="CTC"
var_upport="0x0000000"`cat /proc/wap_proc/pd_static_attr | grep eth_num | awk -F "\"" '{print $2}'`

echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"3\"/g' -i
echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"'$var_upport'\"/g' -i
echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_upport'\"/g' -i

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
	read -r var_specsn var_userpwd< $var_customize_file
	if [ 0 -ne $? ]
	then
	    echo "Failed to read spec info!"
	    return 1
	fi
	return
}

HW_Script_SetSpecSn()
{	
	echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000019\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000019\" ; obj.value = \"'$var_specsn'\"/g' -i
	return
}

# set customize data to file
HW_Script_SetDatToFile()
{
	var_node_web_pwd=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.1

	#继承四川电信的设置
	var_node_app_ftpuser=InternetGatewayDevice.X_HW_AppSrvManage.X_HW_AppSrvManageInstance.1
    var_node_app_smbuser=InternetGatewayDevice.Service.StorageService.StorageServiceInstance.1.UserAccount.UserAccountInstance.1
    var_node_app_srvmng=InternetGatewayDevice.X_HW_ServiceManage
	var_OperatorId_node=InternetGatewayDevice.DeviceInfo

	#设置SpecSn的值到boardinfo
	HW_Script_SetSpecSn

	# set web user password
	cfgtool set $var_default_ctree_var $var_node_web_pwd Password $var_userpwd
	if [ 0 -ne $? ]
	then
		echo "Failed to set common web password!"
		return 1
	fi

	# set web user password
	cfgtool set $var_default_ctree2_var $var_node_web_pwd Password $var_userpwd
	if [ 0 -ne $? ]
	then
		echo "Failed to set common2 web password!"
		return 1
	fi	
	
	cfgtool find $var_default_ctree_var $var_node_app_ftpuser
	if [ 0 -eq $? ];then
		# add app ftpsrv account
		cfgtool add $var_default_ctree_var $var_node_app_ftpuser FtpUserName useradmin
		if [ 0 -ne $? ]
		then
			echo "Failed to add ftpsrv account username!"
			return 1
		fi  

		# add app ftpsrv account
		cfgtool add $var_default_ctree_var $var_node_app_ftpuser FtpPassword $var_userpwd
		if [ 0 -ne $? ]
		then
			echo "Failed to add ftpsrv account password!"
			return 1
		fi 
	fi
	
	cfgtool find $var_default_ctree2_var $var_node_app_ftpuser
	if [ 0 -eq $? ];then
		# add app ftpsrv account
		cfgtool add $var_default_ctree2_var $var_node_app_ftpuser FtpUserName useradmin
		if [ 0 -ne $? ]
		then
			echo "Failed to add ftpsrv account username!"
			return 1
		fi  

		# add app ftpsrv account
		cfgtool add $var_default_ctree2_var $var_node_app_ftpuser FtpPassword $var_userpwd
		if [ 0 -ne $? ]
		then
			echo "Failed to add ftpsrv account password!"
			return 1
		fi 
	fi	
	
	cfgtool find $var_default_ctree_var $var_node_app_srvmng
	if [ 0 -eq $? ];then
		# add app srvmng account
		cfgtool add $var_default_ctree_var $var_node_app_srvmng FtpUserName useradmin
		if [ 0 -ne $? ]
		then
			echo "Failed to add srvmng account username!"
			return 1
		fi  

		# add app srvmng account
		cfgtool add $var_default_ctree_var $var_node_app_srvmng FtpPassword $var_userpwd
		if [ 0 -ne $? ]
		then
			echo "Failed to add srvmng account password!"
			return 1
		fi    
	fi

	cfgtool find $var_default_ctree2_var $var_node_app_srvmng
	if [ 0 -eq $? ];then
		# add app srvmng account
		cfgtool add $var_default_ctree2_var $var_node_app_srvmng FtpUserName useradmin
		if [ 0 -ne $? ]
		then
			echo "Failed to add srvmng account username!"
			return 1
		fi  

		# add app srvmng account
		cfgtool add $var_default_ctree2_var $var_node_app_srvmng FtpPassword $var_userpwd
		if [ 0 -ne $? ]
		then
			echo "Failed to add srvmng account password!"
			return 1
		fi    
	fi	

	cfgtool find $var_default_ctree_var $var_node_app_smbuser
	if [ 0 -eq $? ];then
		# set app smb account
		cfgtool set $var_default_ctree_var $var_node_app_smbuser Password $var_userpwd
		if [ 0 -ne $? ]
		then
			echo "Failed to set smb account password!"
			return 1
		fi	
	fi

	cfgtool find $var_default_ctree2_var $var_node_app_smbuser
	if [ 0 -eq $? ];then
		# set app smb account
		cfgtool set $var_default_ctree2_var $var_node_app_smbuser Password $var_userpwd
		if [ 0 -ne $? ]
		then
			echo "Failed to set smb account password!"
			return 1
		fi	
	fi	
	
	cfgtool set $var_default_ctree_var $var_OperatorId_node X_HW_OperatorID $var_OperatorId
	if [ 0 -ne $? ]
	then
		cfgtool add $var_default_ctree_var $var_OperatorId_node X_HW_OperatorID $var_OperatorId
		if [ 0 -ne $? ]
		then
			echo "Failed to set X_HW_OperatorID !"
			return 1
		fi
	fi
	
	cfgtool set $var_default_ctree2_var $var_OperatorId_node X_HW_OperatorID $var_OperatorId
	if [ 0 -ne $? ]
	then
		cfgtool add $var_default_ctree2_var $var_OperatorId_node X_HW_OperatorID $var_OperatorId
		if [ 0 -ne $? ]
		then
			echo "Failed to set X_HW_OperatorID !"
			return 1
		fi
	fi	

	return
}

HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "set spec info OK!"

exit 0

