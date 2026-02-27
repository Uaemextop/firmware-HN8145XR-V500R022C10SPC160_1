#! /bin/sh

var_boardinfo_dup="/var/dup_boardinfo"

var_upport="0x0030400"`cat /proc/wap_proc/pd_static_attr | grep ssid_num | awk -F "\"" '{print $2}'`
var_eth="0x0000000"`cat /proc/wap_proc/pd_static_attr | grep eth_num | awk -F "\"" '{print $2}'`

#首先读取产品属性下的静态属性access_port_type的值： 0盲插 1-4表示固定上行口
var_upport_mode=`cat /proc/wap_proc/pd_static_attr | grep access_port_type | awk -F "\"" '{print $2}'`

#如果没有access_port_type这个产品属性，则保持定制中上行模式相关的boardinfo;当该产品静态属性值为0，则上行模式为盲插，并将上行端口，以及上行口保持与原始定制模式下的boardinfo保持一致；最后将该静态属性的值作为ap固定上行的端口
if [ -z "$var_upport_mode" ]
then 
    #1为盲插上行
    echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"'$1'\"/g' -i
    echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"'$var_upport'\"/g' -i
    echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_eth'\"/g' -i
elif [ 0 -eq "$var_upport_mode" ]
then 
    echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"1\"/g' -i
    echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"'$var_upport'\"/g' -i
    echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_eth'\"/g' -i
else
    var_upport="0x0030400"`cat /proc/wap_proc/pd_static_attr | grep ssid_num | awk -F "\"" '{print $2}'`
    var_eth="0x0000000"`cat /proc/wap_proc/pd_static_attr | grep access_port_type | awk -F "\"" '{print $2}'
    #access_port_type静态属性值不为0时，产品为固定上行，0x0000003c字段的值为产品的静态属性access_port_type的值`
    echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"2\"/g' -i
    echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"'$var_upport'\"/g' -i
    echo $var_boardinfo_dup | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_eth'\"/g' -i
fi

exit 0