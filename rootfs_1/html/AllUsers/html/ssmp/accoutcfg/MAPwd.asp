<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_CleanCache_Resource(style_n.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_CleanCache_Resource(pwd.css);%>' type='text/css'>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>

<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script type="text/javascript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script type="text/javascript" src="../../../Cusjs/<%HW_WEB_CleanCache_Resource(pwd_dyn.js);%>"></script>
</head>
<script type="text/javascript">
var sptUserName;

function stModifyUserInfo(domain,UserName,UserLevel)
{
	this.domain = domain;
	this.UserName = UserName;
	this.UserLevel = UserLevel;
}

var stModifyUserInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.{i}, UserName|UserLevel, stModifyUserInfo);%>;

for(var i = 0; i < stModifyUserInfos.length - 1; i++)
{
	if(stModifyUserInfos[i].UserLevel == 1 )
	{
		sptUserName = stModifyUserInfos[i].UserName;
	}
}

function GetLanguageDesc(Name)
{
	return AccountLgeDes[Name];
}

function Loadframe()
{
	setDisplay("Div_pwd_cpy_info", 0);
	setDisplay("simpleicon", 0);
	setDisplay("simplechar", 0);
	setDisplay("mediumicon", 0);
	setDisplay("mediumchar", 0);
	setDisplay("strongicon", 0);
	setDisplay("strongchar", 0);

	if( ( window.location.href.indexOf("set.cgi?") > 0) )
	{
		AlertEx("当前用户的密码修改成功！");
	}

}


function title_show()
{
	var val=document.getElementById("PwdNotice");
	val.style.display = 'block';
}
function title_back()
{
	ChangeLockInfo(0, 'capStatus');
	var div=document.getElementById("PwdNotice");
	div.style.display = "none";
}

function CheckParameter()
{
	var oldPassword = document.getElementById("mapwd_oldpwd");
	var newPassword = document.getElementById("mapwd_newpwd");
	var cfmPassword = document.getElementById("mapwd_cfmpwd");

	if (oldPassword.value == "")
	{
		AlertEx(GetLanguageDesc("s1906"));
		return false;
	}

	if (newPassword.value == "")
	{
		AlertEx(GetLanguageDesc("s0f02"));
		return false;
	}

	if("simple" == CheckPwdCpy(newPassword.value))
	{
		AlertEx(GetLanguageDesc("s1902"));
		return false;
	}

	if (cfmPassword.value != newPassword.value)
	{
		AlertEx(GetLanguageDesc("s0f06"));
		return false;
	}

	var NormalPwdInfo = FormatUrlEncode(oldPassword.value);
    var CheckResult = 0;

	$.ajax({
	type : "POST",
	async : false,
	cache : false,
	url : "../common/CheckNormalPwd.asp?&1=1",
	data :'NormalPwdInfo='+NormalPwdInfo, 
	success : function(data) {
		CheckResult=data;
		}
	});

	if (CheckResult != 1)
	{
		AlertEx(GetLanguageDesc("s1907"));
		return false;
	}

	setDisable('mapwdApply', 1);
	return true;
}


function CheckPwdCpy(val)
{
	var HaveDigit = 0;
	var HaveBigChar = 0;
	var HaveSmallChar = 0;
	var HaveSpecialChar = 0;

	for ( var i = 0 ; i < val.length ; i++ )
	{
		var ch = val.charAt(i);
		if ( ch <= '9' && ch >= '0' )
		{
			HaveDigit = 1;
		}
		else if(ch <= 'z' && ch >= 'a')
		{
			HaveSmallChar = 1;
		}
		else if(ch <= 'Z' && ch >= 'A')
		{
			HaveBigChar = 1;
		}
		else
		{
			HaveSpecialChar = 1;
		}
	}

	var Result = HaveDigit + HaveSmallChar + HaveBigChar + HaveSpecialChar;

	if(1 == Result || val.length < 8)
	{
		return "simple";
	}
	else if( (1 == HaveDigit) && (1 == (HaveSmallChar + HaveBigChar)) && (0 == HaveSpecialChar))
	{
		return "medium";
	}
	else
	{
		return "strong";
	}
}

function ShowPwdCpy(Para)
{
	setDisplay("simpleicon", 0);
	setDisplay("simplechar", 0);
	setDisplay("mediumicon", 0);
	setDisplay("mediumchar", 0);
	setDisplay("strongicon", 0);
	setDisplay("strongchar", 0);
	setDisplay("Div_pwd_cpy_info", 0);
	if( "" == Para.value)
	{
		return 0;
	}

	if ('' != isValidAscii(Para.value))
	{
		AlertEx(GetLanguageDesc("s0f04"));
		return 0;
	}

	var Result = CheckPwdCpy(Para.value);
	setDisplay("Div_pwd_cpy_info", 1);
	if(Result == "simple")
	{
		setDisplay("simpleicon", 1);
		setDisplay("simplechar", 1);
	}
	else if(Result == "medium")
	{
		setDisplay("simpleicon", 1);
		setDisplay("simplechar", 1);
		setDisplay("mediumicon", 1);
		setDisplay("mediumchar", 1);
	}
	else
	{
		setDisplay("simpleicon", 1);
		setDisplay("simplechar", 1);
		setDisplay("mediumicon", 1);
		setDisplay("mediumchar", 1);
		setDisplay("strongicon", 1);
		setDisplay("strongchar", 1);
	}

	return 0;
}

function SubmitPwd()
{
	if(!CheckParameter())
	{
		return false;
	}

	var parainfo="";
	parainfo='x.OldPassword=' + FormatUrlEncode(getValue('mapwd_oldpwd')) + "&";
	parainfo+='x.Password=' + FormatUrlEncode(getValue('mapwd_newpwd')) + "&";
	parainfo+='x.X_HW_Token=' + getValue('onttoken');
	$.ajax({
		 type : "POST",
		 async : false,
		 cache : false,
		 data : parainfo,
		 url : "setajax.cgi?x=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.1&RequestFile=html/ssmp/accoutcfg/MAPwd.asp",
		 success : function(data) {
				var ResultInfo = JSON.parse(hexDecode(data));
				if (0 == ResultInfo.result)
				{
					AlertEx("当前用户的密码修改成功！");
					CancelValue();
				}
				else
				{
					AlertEx("当前用户的密码修改失败！");
				}
		 },
		 complete: function (XHR, TS) {
			XHR=null;
		 }
	});
}
</script>
<body class="mainbody" onLoad="Loadframe();" style=" overflow:hidden;">
	<div class="contentItem" style="margin-top:80px;">
		<div class="labelBox">用户名：</div>
		<div class="contenbox"><script language="JavaScript" type="text/javascript">document.write(htmlencode(sptUserName));</script></div>
	</div>
	<div class="contentItem">
		<div class="labelBox">原密码：</div>
		<div class="contenbox">
			<input type="password" autocomplete="off" id="mapwd_oldpwd" name="mapwd_oldpwd" class="textbox">
			<script type="text/javascript">
				InjectCapStateHtml("capStatus_prev", '0px', '0px');
				InjectCapStateEvent("mapwd_oldpwd", "capStatus_prev", true);
			</script>
		</div>
	</div>
	
	<div class="contentItem" style="margin:10px 0;">
		<div class="labelBox">新密码：</div>
		<div class="contenbox"  onmouseover="title_show();" onmouseout="title_back();">
			<input id='mapwd_newpwd' name="mapwd_newpwd" type="password" autocomplete="off" size="20"  maxlength="256" onKeyUp="ShowPwdCpy(this);">
			<div id="PwdNotice" style="display:none;"><script language="JavaScript" type="text/javascript">document.write(GetLanguageDesc("s1116"));</script>
			</div>
		</div>
		
	</div>
	
	<div class="contentItem" id="Div_pwd_cpy_info" style="display:none;font-size:12px;padding-top:0px;margin-left:-13px;">
		<div class="labelBox" style="color:white;">.</div>
		<div class="contenbox">
			<table id="pwd_cpy_info">
				<tr height="10">
					<td id="space1"></td>
					<td style="padding-right:0;" id="simpleicon"><img height="10px;" src="../../../images/nimages/simple.jpg"/></td>
					<td style="padding-left:0; padding-right:0;" id="mediumicon"><img height="10px;" src="../../../images/nimages/medium.jpg"/></td>
					<td style="padding-left:0;" id="strongicon"><img height="10px;" src="../../../images/nimages/strong.jpg"/></td>
					<td id="space2"></td>
				</tr>
				<tr height="20">
					<td id="space1"></td>
					<td align="center" id="simplechar">弱</td>
					<td align="center" id="mediumchar">中</td>
					<td align="center" id="strongchar">强</td>
					<td ></td>
				</tr>
			</table>
		</div>
	</div>

	<div class="contentItem">
		<div class="labelBox">确认密码：</div>
		<div class="contenbox">
			<input  id='mapwd_cfmpwd' name="mapwd_cfmpwd" type="password" autocomplete="off" size="20"  maxlength="256" />
			<script type="text/javascript">
				InjectCapStateHtml("capStatus", '0px', '0px');
				InjectCapStateEvent("mapwd_newpwd", "capStatus", false);
				InjectCapStateEvent("mapwd_cfmpwd", "capStatus", true);
			</script>
		</div>
	</div>
	<div>
		<table id="CapsLockinfo" height="20">
			<tr height="10">
				<td id="spacecaps">
					
				</td>
			</tr>
		</table>
	</div>

	<div style=" margin-left:160px;">
		<table>
			<tr>
				<td align="center">
					<button class="button" id="button" onClick="SubmitPwd();">确定</button>
					<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
				</td>
			</tr>
		</table>
	</div>
</body>
</html>