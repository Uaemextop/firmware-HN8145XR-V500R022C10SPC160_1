<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<link href="../../../Cuscss/<%HW_WEB_CleanCache_Resource(style_n.css);%>" rel="stylesheet" type="text/css">
<title>查看日志</title>
<script language="JavaScript" type="text/javascript">
function stSyslogCfg(domain,Enable,Level,QueryLevel)
{
     this.domain = domain;
	this.Enable = Enable;
	this.Level = Level;
	this.QueryLevel = QueryLevel;
}

var LogHeaderLineNum = 8;
var DefNumOnePage = 10;
var AllLogLineNum = 0;
var AllLogPageNum = 0;
var CurrentShowPage = 1;
	
var temp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo.X_HW_Syslog, Enable|Level|QueryLevel, stSyslogCfg);%>; 
var SyslogCfg = temp[0];

var LogLevelInfo = ["[Emergency", "[Alert", "[Critical", "[Error", "[Warning", "[Notice", "[Informational", "[Debug"];


function LoadFrame()
{   
	AllLogLineNum = GetLogLineNum();
}

function RefreshContentForFiter()
{
	var xmlHttp = null;

	if(window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
	} else if(window.ActiveXObject) {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	}

	xmlHttp.open("GET", "../../get_swm_status.asp", false);
	xmlHttp.send(null);

	var swm_status = xmlHttp.responseText;
	if (swm_status.substr(1, 1) == "0") {
		return true;
	} else {
		return false;
	}
}

function CheckLogLevel( LineLogText, LookLogLevel )
{
	var LevelInfoLength = LogLevelInfo.length;
	var i = parseInt(LookLogLevel,10) + 1;
	
	for (; i < LevelInfoLength ; i++)
	{   
	    if ( -1 != LineLogText.indexOf(LogLevelInfo[i]) )
		{
			return false;
		}
	}
	
	return true;
}

function RefreshByLogType(ShowPageNum, val)
{
	var OldLogText = document.getElementById("logarea").value;
	var QueryLevel = SyslogCfg.QueryLevel;
	var ResultLog = OldLogText.split("\n");
	var NewShowLog = "";
	var IDtable = 1;
	var StartLogLineIndex = (ShowPageNum -1) * val + LogHeaderLineNum - 1;
	
	var Loghtml='<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="SysLogInstContent">';
	
	for (var i = StartLogLineIndex; i < StartLogLineIndex + val; i++ )
	{
		if (ResultLog[i] != "\r\n" || ResultLog[i] != "" ||  ResultLog[i] != "\0")
		{
			if ((true == CheckLogLevel(ResultLog[i], QueryLevel)))
			{
				NewShowLog += ResultLog[i];
				NewShowLog += "\n";
				var loginof =ResultLog[i];
				var logtime = loginof.split("[");

				var temp = loginof.split("]");
				var logalert = loginof.substring(temp[0].length+1,loginof.length);
				var HTMLlogalert = logalert;
				var id = "log_2_" + (IDtable++) + "_table";	
				var id_time = "log_2_" + (IDtable++) + "_table";
				var id_alert= "log_2_" + (IDtable++) + "_table";
				
				var IdNum = i - StartLogLineIndex + 1;
				if( null == logtime[0] || (-1 == logtime[0].indexOf("-")))
				{
					break;
				}

				Loghtml += '<tr height="35">';
				Loghtml += '<TD id="' + id +'" width="5%" align="center">' + htmlencode(IdNum) + '</TD>';
				Loghtml += '<TD id="' + id_time +'" width="30%" align="center">' + htmlencode(logtime[0]) + '</TD>';
				Loghtml += '<TD id="' + id_alert + '" title="'+htmlencode(HTMLlogalert)+'" width="65%" align="left">'+GetStringContent(htmlencode(HTMLlogalert), 38)+'</TD>';					
				Loghtml += '</tr>';	
			}
		}
	}
	Loghtml += '</table>';
	
	RefreshContentForFiter();
	
	return Loghtml;
}

function GetLogLineNum()
{	
	var OldLogText = document.getElementById("logarea").value;
	var ResultLog = OldLogText.split("\n");
	var allNum = ResultLog.length - LogHeaderLineNum - 1;
	return allNum;
}

function GetLogPageNum()
{	
	var OnePageNum = DefNumOnePage;
	return (0 == AllLogLineNum%OnePageNum) ? (AllLogLineNum/OnePageNum) : (parseInt(AllLogLineNum/OnePageNum) + 1);
}

function LogDownLoadFunc()
{
	var ua = navigator.userAgent.toLowerCase();	
	if (/iphone|ipad|ipod/.test(ua)) {
		window.open("/html/ssmp/userlog/logview_ios.asp");
		return;
	}
	XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
	var Form = new webSubmitForm();
	Form.addParameter('logtype', "opt");
	Form.setAction('logviewdown.cgi?FileType=log&RequestFile=CtcApp/logview.asp');
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}


function WriteLogAllPage(val)
{
	var DefPageNum = val;
	var SeleteHtml = '<select id="SelectPage" style="width:40px" name="SelectPage" onchange=ChangeLogByPageId(this.value);>';
	for (i = 1; i <= DefPageNum; i++)
	{
		 SeleteHtml += '<option value="' + i + '">' + i + '</option>';
	}
	SeleteHtml += '</select>';
	
	return SeleteHtml;
}

function ChangeLogByPageId(PageNum)
{
	if(parseInt(CurrentShowPage) == PageNum)
	{
		AlertEx("当前已经是第" + PageNum + "页。");
		return 0;
	}
	CurrentShowPage = PageNum;
	document.getElementById("LogContent").innerHTML = RefreshByLogType(PageNum, DefNumOnePage);
	document.getElementById("CurrentPage").innerHTML = htmlencode(CurrentShowPage);
	
}

function ChangePage(val)
{
	var OptId = val.id;
	if("First" == OptId)
	{	
		if(1 == parseInt(CurrentShowPage))
		{
			AlertEx("已经是第一页。");
			return 0;
		}
		
		CurrentShowPage = 1;
	}
	else if("Pre" == OptId)
	{
		if(1 == parseInt(CurrentShowPage))
		{
			AlertEx("已经是第一页。");
			return 0;
		}
		
		CurrentShowPage = parseInt(CurrentShowPage) - 1;
	}
	else if("Next" == OptId)
	{
		if(AllLogPageNum == parseInt(CurrentShowPage))
		{
			AlertEx("已经是最后一页。");
			return 0;
		}
		
		CurrentShowPage = parseInt(CurrentShowPage) + 1;
	}
	else
	{
		if(AllLogPageNum == parseInt(CurrentShowPage))
		{
			AlertEx("已经是最后一页。");
			return 0;
		}
		
		CurrentShowPage = AllLogPageNum;
	}
	
	setSelect('SelectPage', parseInt(CurrentShowPage));
	document.getElementById("LogContent").innerHTML = RefreshByLogType(parseInt(CurrentShowPage), DefNumOnePage);
	document.getElementById("CurrentPage").innerHTML = htmlencode(CurrentShowPage);
	
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();" > 
<div id="logconfig"> 
<table id="table_logtitle" width="100%" border="0" cellspacing="0" cellpadding="0">
<label id="Title_log_enable_lable" > 
<tr> 
<td><span style="font-size: 15px;font-weight: bold; color:#66FFFF">系统日志</span>
</td>
</tr>
<tr> 
</label>  
</table>
 
<div id="DivLogView">
<div  id="LogheadInfo" style="height:30px; width:100px; margin-left:450px;">
<table>
<tr>
<td><img height="30px" src="../../../images/nimages/logsaveicon.jpg" onclick="LogDownLoadFunc();"></td></tr></table>
</div>

<div id="logviews" align="center" style="display:none"> 
  <textarea name="logarea" id="logarea" style="width:100%;height:330px;margin-bottom:20px;" wrap="off" >
</textarea> 
  <script type="text/javascript">
		document.getElementById("logarea").value='<%HW_WEB_GetLogInfo();%>';
	 </script> 
</div>

<div id="LogViewTable" style="width:550px;">
<div>
<table width="550" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="SysLogInst">
<tr height="5"><td align="center" colspan="3"><img height="5" src="../../../images/nimages/logline.jpg"></td></tr>
</table>
<table width="550" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="SysLogInst">
<tr class="table_title" height="35">
<td width="5%" id="log_id_table" align="center"><div align="center">ID</div></td>
<td width="28%" id="log_time_table" align="center"><div align="center">记录时间</div></td>
<td width="67%" id="log_info_table" align="center"><div align="center">消息</div></td>
</tr>
</table>
</div>
<div id="LogContent" style="overflow:auto; height:380px; width:550px;">
<script language="JavaScript" type="text/javascript">
document.write(RefreshByLogType(1, htmlencode(DefNumOnePage)));
</script>
</div>
<table width="100%" border="0" cellspacing="1" cellpadding="0"> 
<tr style="background:#EFEFEF;"> 
<td id="LogChangePage">
<img id="First" src="../../../images/nimages/logFirstPage.jpg" onclick="ChangePage(this);" title="跳转到首页"/>
<img id="Pre" src="../../../images/nimages/logPrePage.jpg" onclick="ChangePage(this);" title="跳转到上一页"/>
<img id="Next" src="../../../images/nimages/LogNextPage.jpg" onclick="ChangePage(this);" title="跳转到下一页"/>
<img id="Last" src="../../../images/nimages/LogLastPage.jpg" onclick="ChangePage(this);" title="跳转到最后一页"/></td>
<td align="right">跳转到</td>
<td id="TdPageSlect" align="left">
<script language="JavaScript" type="text/javascript">
AllLogLineNum = GetLogLineNum();
AllLogPageNum = GetLogPageNum();
document.write((WriteLogAllPage(htmlencode(AllLogPageNum))));
</script> 
</td> 
<td align="right">目前第</td> 
<td id="CurrentPage" align="left"><script>document.write(htmlencode(CurrentShowPage));</script></td> 
<td align="left">页<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"></td> 
</tr> 
</table>
</div> 
</div> 
</div> 
</body>
</html>
