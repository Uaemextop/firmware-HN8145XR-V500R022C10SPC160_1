-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2011 Jo-Philipp Wich <jow@openwrt.org>

-- Licensed to the public under the Apache License 2.0.
module("luci.controller.admin.wifi", package.seeall)

function index()
	entry({"admin", "wifi"}, alias("admin", "wifi", "base"), nil, 60).index = true
	
	entry({"admin", "wifi", "base"},
		template("admin_wifi/main_wifi_base"),
		nil, 10).leaf = true

	entry({"admin", "wifi", "base_settings"},
		call("get_base_settings")).leaf = true
		
	entry({"admin", "wifi", "wifiBasic"},
		post("set_base_settings")).leaf = true					
		
	entry({"admin", "wifi", "advance"},
		template("admin_wifi/main_wifi_advance"),
		nil, 20).leaf = true

	entry({"admin", "wifi", "adv_settings"},
		call("get_adv_settings")).leaf = true

	entry({"admin", "wifi", "wifiAdv"},
		post("set_adv_settings")).leaf = true	

	entry({"admin", "wifi", "inter_connd"},
		template("admin_wifi/main_wifi_extend"),
		nil, 30).leaf = true

	entry({"admin", "wifi", "mesh"},
		template("admin_wifi/main_wifi_mesh"),
		nil, 40).leaf = true		

	entry({"admin", "wifi", "interConndStatus"}, call("get_inter_connd_status")).leaf = true

	entry({"admin", "wifi", "startInterConnd"}, post("start_inter_connd")).leaf = true

	entry({"admin", "wifi", "syncConfig"}, post("set_config_sync")).leaf = true

	entry({"admin", "wifi", "syncOnoff"}, post("set_onoff_sync")).leaf = true

	entry({"admin", "wifi", "configAP"}, post("set_config_ap")).leaf = true

	entry({"admin", "wifi", "easymeshInfo"}, call("get_easymesh_settings")).leaf = true	

	entry({"admin", "wifi", "easymeshSettings"}, post("set_easymesh_settings")).leaf = true		
end

function get_base_settings()
	local info = sgwconfig:get("wifiBasic")

	luci.http.prepare_content("application/json")
	luci.http.write_json(info)	
end

function set_base_settings()
	local tbl

	tbl = {wifi_dualBand = luci.http.formvalue("dualBand"),
		   wifi_2G_enbl = luci.http.formvalue("wifi_2G_switch"), 
	       wifi_2G_ssid = luci.http.formvalue("wifi_2G_SSID"),
	       wifi_2G_strength = luci.http.formvalue("wifi_2G_strength"),
	       wifi_2G_auth = luci.http.formvalue("wifi_2G_auth"), 
	       wifi_2G_passwd = luci.http.formvalue("wifi_2G_password"), 
	       wifi_5G_enbl = luci.http.formvalue("wifi_5G_switch"), 
	       wifi_5G_ssid = luci.http.formvalue("wifi_5G_SSID"),
	       wifi_5G_strength = luci.http.formvalue("wifi_5G_strength"),
	       wifi_5G_auth = luci.http.formvalue("wifi_5G_auth"), 
	       wifi_5G_passwd = luci.http.formvalue("wifi_5G_password")}

	sgwconfig:set("wifiBasic", tbl)
	luci.http.redirect(luci.dispatcher.build_url("admin/wifi/base"))
end

function get_adv_settings()
	local info = sgwconfig:get("wifiAdv")

	luci.http.prepare_content("application/json")
	luci.http.write_json(info)	
end

function set_adv_settings()
	local tbl
	tbl = {wifi_timing = luci.http.formvalue("wifi_timing_switch"), 
	       start_time = luci.http.formvalue("wifi_start_time"), 
	       end_time = luci.http.formvalue("wifi_end_time")}

	sgwconfig:set("wifiAdv", tbl)
	luci.http.redirect(luci.dispatcher.build_url("admin/wifi/advance"))
end

function get_inter_connd_status()
	local info = sgwconfig:get("interConndStatus")

	luci.http.prepare_content("application/json")
	luci.http.write_json(info)
end

function start_inter_connd()
    local ret = sgwconfig:set("startInterConnd")
  
	luci.http.prepare_content("application/json")
	local rv = {message=ret}
	luci.http.write_json(rv)
end

function set_config_sync()
	local tbl = {
				 syncConfig = luci.http.formvalue("syncConfig")
				}
	sgwconfig:set("syncConfig", tbl)
end

function set_onoff_sync()
	local tbl = {
				 syncOnoff = luci.http.formvalue("syncOnoff")
				}
	sgwconfig:set("syncOnoff", tbl)
end

function set_config_ap()
	local tbl = {
				 mac = luci.http.formvalue("mac"),
				 modeflg = luci.http.formvalue("modeflg"),
				 enbl2g = luci.http.formvalue("enbl2g"),
				 ssid2g = luci.http.formvalue("ssid2g"),
				 pwd2g = luci.http.formvalue("pwd2g"),
				 enbl5g = luci.http.formvalue("enbl5g"),
				 ssid5g = luci.http.formvalue("ssid5g"),
				 pwd5g = luci.http.formvalue("pwd5g"),				 
				}
	sgwconfig:set("configAP", tbl)
end

function get_easymesh_settings()
	local info = sgwconfig:get("easymesh_config")
	
	luci.http.prepare_content("application/json")
	luci.http.write_json(info)
end

function set_easymesh_settings()
	local tbl
	tbl = {easymeshEnbl = luci.http.formvalue("mesh_sync_switch"),
		   mesh_2G_enbl = luci.http.formvalue("wifi_2G_switch"),
	       mesh_2G_ssid = luci.http.formvalue("mesh_2G_SSID"),
	       mesh_2G_auth = luci.http.formvalue("mesh_2G_auth"), 
	       mesh_2G_passwd = luci.http.formvalue("mesh_2G_password"),
	       mesh_5G_enbl = luci.http.formvalue("wifi_5G_switch"),
	       mesh_5G_ssid = luci.http.formvalue("mesh_5G_SSID"),
	       mesh_5G_auth = luci.http.formvalue("mesh_5G_auth"), 
	       mesh_5G_passwd = luci.http.formvalue("mesh_5G_password")}
	       
	sgwconfig:set("easymesh_config", tbl)
 	luci.http.redirect(luci.dispatcher.build_url("admin/wifi/mesh"))
end