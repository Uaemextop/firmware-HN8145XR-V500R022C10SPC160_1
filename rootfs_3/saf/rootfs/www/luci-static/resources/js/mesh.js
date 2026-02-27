function enable_disable_mesh( enbl)
{
	if (enbl)
	{
		$(".wifi_" + "2" +"G_item").css("display", "");
		$("#" + "2" +"G_security").css("background-color", $("#mesh_" + "2" +"G_SSID").css("background-color"));
		$("#mesh_" + "2" +"G_password").parent().css("background-color", $("#mesh_" + "2" +"G_SSID").css("background-color"));
			$(".wifi_" + "5" +"G_item").css("display", "");
		$("#" + "5" +"G_security").css("background-color", $("#mesh_" + "5" +"G_SSID").css("background-color"));
		$("#mesh_" + "5" +"G_password").parent().css("background-color", $("#mesh_" + "5" +"G_SSID").css("background-color"));
	
		$(".wifi_devs").css("display", "");
	}
	else
	{
		$(".wifi_" + "2" +"G_item").css("display", "none");
		$("#" + "2" +"G_security").css("background-color", $("#mesh_" + "2" +"G_SSID").css("background-color"));
		$("#mesh_" + "2" +"G_password").parent().css("background-color", $("#mesh_" + "2" +"G_SSID").css("background-color"));

		$(".wifi_" + "5" +"G_item").css("display", "none");
		$("#" + "5" +"G_security").css("background-color", $("#mesh_" + "5" +"G_SSID").css("background-color"));
		$("#mesh_" + "5" +"G_password").parent().css("background-color", $("#mesh_" + "5" +"G_SSID").css("background-color"));
	
		$(".wifi_devs").css("display", "none");
	}
}

function enable_disable_radio(id, enbl)
{
	if (enbl)
	{
		$(".wifi_" + id +"G_item").css("display", "");
		$("#" + id +"G_security").css("background-color", $("#wifi_" + id +"G_SSID").css("background-color"));
		$("#wifi_" + id +"G_password").parent().css("background-color", $("#wifi_" + id +"G_SSID").css("background-color"));

		$("#onoff_" + id +"G_hint").css("display", "none");
	}
	else
	{
		$(".wifi_" + id +"G_item").css("display", "none");
		$("#" + id +"G_security").css("background-color", $("#wifi_" + id +"G_SSID").css("background-color"));
		$("#wifi_" + id +"G_password").parent().css("background-color", $("#wifi_" + id +"G_SSID").css("background-color"));

		$("#onoff_" + id +"G_hint").css("display", "");
	}
}


$(document).ready(function(){
	customSwitchInit();

	$("#mesh_sync_switch").bind("click", function(){
		if($(this).hasClass("switch_content_on"))
			{
				enable_disable_mesh(true);
				$(".wifi_2G").css("display", "");
				$(".wifi_5G").css("display", "");

				if ($("#wifi_2G_switch").hasClass("switch_content_on"))
				{
					enable_disable_radio("2", true);

					if ($("#2G_mesh_security_list_value").val() == "None")
						$("#mesh_2G_password").parent().parent().parent().hide();							
				}
				else
					enable_disable_radio("2", false);

				if ($("#wifi_5G_switch").hasClass("switch_content_on"))
				{
					enable_disable_radio("5", true);

					if ($("#5G_mesh_security_list_value").val() == "None")
						$("#mesh_5G_password").parent().parent().parent().hide();						
				}
				else
					enable_disable_radio("5", false);				
			}
		else
			{
			enable_disable_mesh(false);
				$(".wifi_2G").css("display", "none");
				$(".wifi_5G").css("display", "none");			
			}

		$(".wifi_save").css("display", "");
	});

	$("#wifi_2G_switch").bind("click", function(){
		if($(this).hasClass("switch_content_on"))
		{
			enable_disable_radio("2", true);
			
			if ($("#2G_mesh_security_list_value").val() == "None")
				$("#mesh_2G_password").parent().parent().parent().hide();			
		}
		else
			enable_disable_radio("2", false);
	});

	$("#wifi_5G_switch").bind("click", function(){
		if($(this).hasClass("switch_content_on"))
		{
			enable_disable_radio("5", true);
			
			if ($("#5G_mesh_security_list_value").val() == "None")
				$("#mesh_5G_password").parent().parent().parent().hide();			
		}
		else
			enable_disable_radio("5", false);
	});	

	customSelectInit();
	//passowrd

	$("input[type='password']").bind("focusin", function(){
		$(this).parent().eq(0).addClass("wifi-password-focus");
	});
	$("input[type='password']").bind("focusout", function(){
		$(this).parent().eq(0).removeClass("wifi-password-focus");
	});

	$("input[type='text']").bind("focusin", function(){
		if(judedNavation() < 9){
			$(this).css("border", "1px solid #39ba93");
		}
	});
	$("input[type='text']").bind("focusout", function(){
		if(judedNavation() < 9){
			$(this).css("border", "1px solid #dbdbdb");
		}
	});

	$(".dropdown-menu-select li").click(function(){
			if ($(this).parent().siblings("label").first().text() == "Open")
				$(this).parent().parent().parent().parent().next().hide();
			else
				$(this).parent().parent().parent().parent().next().show();
		});

	customPasswordInit();
});

