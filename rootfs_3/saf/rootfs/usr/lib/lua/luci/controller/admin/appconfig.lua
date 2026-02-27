-- Licensed to the public under the Apache License 2.0.
module("luci.controller.admin.appconfig", package.seeall)

function index()
	entry({"admin", "appconfig"}, alias("admin", "appconfig", "mall"), nil, 190).index = true
	
	entry({"admin", "appconfig", "mall"},
		template("admin_appconfig/main_app_mall"),
		nil, 10).leaf = true
		
	entry({"admin", "appconfig", "getMallUrl"}, call("get_mall_url")).leaf = true
end

function get_mall_url()
	local info = sgwconfig:get("getMallUrl")

	luci.http.prepare_content("application/json")
	luci.http.write_json(info)
end