#!/bin/sh

# 导出产品静态属性
eval $(cat /proc/wap_proc/pd_static_attr | while read attr_id obj_id obj_name obj_value ; do	
	echo "export "$obj_name=$obj_value
done)

# 导出是否支持硬件路由
eval $(cat /proc/wap_proc/chip_attr | grep hard_route_cap | while read chip_type obj_id obj_name obj_value ; do
	echo "export "hw_route=$obj_value
done)

# 导出ipv6特性开关
eval $(cat /proc/wap_proc/feature | grep BBSP_FT_IPV6 | while read obj_name obj_enable obj_ctrl ; do
	if [ $obj_name = "BBSP_FT_IPV6" ];then
		echo "export "ipv6=$obj_enable
	fi
done)

# 导出l3_ex特性开关
export l3_ex=1
