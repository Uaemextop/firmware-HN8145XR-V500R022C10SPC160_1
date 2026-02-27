<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta content="no-cache" http-equiv="Pragma" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_CleanCache_Resource(style_n.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title></title>
</head>
<script>
function SubmitCfgReset()
{
	if(confirm("恢复默认设置将清除您之前的设置，确认要恢复默认设置吗？"))
	{
		var Form = new webSubmitForm();		
		setDisable('mapwdApply', 1);
		Form.setAction('restoredefaultcfg.cgi?' + 'RequestFile=html/management/reset.asp');
		Form.addParameter('x.X_HW_Token', getValue('hwonttoken'));
		Form.submit();
	} 
}
</script>
<body class="mainbody" style=" overflow:hidden;">
<div id="ApwdComfig" style="margin-top:100px;">
<table width="100%">
<tr height="50">
<td id="td_mapwd_un" align="center"><font style="font-weight:bold;font-size:16px;">恢复默认设置将清除您之前的设置，请谨慎操作。</font></td>
</tr>

<tr height="50">
<td id="td_mapwd_un" align="center"><input class="submitform_red" name="mapwdApply" id= "mapwdApply" type="button" value="恢复" onClick="SubmitCfgReset();"> 
<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"></td>
</tr>
</table>
</div>
</body>
</html>
