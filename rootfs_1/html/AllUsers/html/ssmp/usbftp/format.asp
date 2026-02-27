<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_CleanCache_Resource(style_n.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" type="text/javascript">
var USBFileName;

var DevFsType = '<%HW_WEB_GetDevFsType();%>';

function GetLanguageDesc(Name)
{
    return ssmpLanguage[Name];
}

function stUSBDevice(domain,DeviceList)
{
	this.domain = domain;
	this.DeviceList = DeviceList;
}
									
var UsbDevice = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UsbInterface.X_HW_UsbStorageDevice,DeviceList,stUSBDevice);%>;
var usb1 = null;
var usb2 = null;
var DeviceStr = null;
var DeviceArray = null;

if ( UsbDevice.length > 1 )
{
	usb1 = UsbDevice[0].DeviceList;
}

if (UsbDevice.length > 2)
{
    usb2 = UsbDevice[1].DeviceList;
}

DeviceStr = usb1 + usb2;

if(DeviceStr != '')
{
	DeviceArray = DeviceStr.split("|");
}

function MakeDeviceName(DiskName)
{
	var device = DiskName.split("/"); 
	return device[3];
}

function init()
{
	
}		

function WriteDeviceOption()
{
    if (DeviceStr != 'null' && DeviceStr != 0)
	{
		for (i = 0; i < DeviceArray.length-1; i++)
		{
			 document.write('<option value=' + htmlencode(DeviceArray[i]) + '/' +'>'
							+ htmlencode(MakeDeviceName(DeviceArray[i])) + '</option>');
		}
		return true;
	}
	else
	{
	   return false;
	}
}

function CheckUSBFileIsExist()
{
	var USBFileLocalPath=document.getElementById('LocalPath').value;
	var CheckResult =0;
	var USBFileInfo;
	
	if(USBFileLocalPath=='')
	{
		USBFileInfo = getSelectVal('ClDevType')+USBFileName;
	}
	else
	{
		USBFileInfo = getSelectVal('ClDevType')+USBFileLocalPath;
	}

	$.ajax(
	{
	type : "POST",
	async : false,
	cache : false,
	url : "../common/CheckUSBFileExist.asp?&1=1",
	data :'USBFileInfo='+encodeURIComponent(USBFileInfo), 
	success : function(data) {
		CheckResult=data;
		}
	});

	if (CheckResult==1)		
	{
		if(!confirm(ssmpLanguage["s0533"]))
		{
			return false;
		}
	}
	
	return true;
}

function onChangeDev()
{
	var dev = getSelectVal('SrvClDevType'); 
	var tmp;
	
	if(DeviceArray.length-1 > 1)
	{
		return;
	}
	
	if( "" != dev)
 
	{
		tmp = dev.split("/");
 		setText('RootDirPath', tmp[3]+'/');		
	} 
	else
	{
		setText('RootDirPath', '');	
	}
}


function onSelectDev()
{
	var dev = getSelectVal('SrvClDevType'); 
}

function SubmitFormat()
{
	var Form = new webSubmitForm();
	if("" == getSelectVal('SrvClDevType'))
	{
		alert("请先选择USB设备分区！");
		return 0;
	}
	
	if("" == getSelectVal('NewSrvClDevType'))
	{
		alert("请选择要格式化的目的文件系统格式。");
		return 0;
	}
	
	if(ConfirmEx("确定要格式化吗?")) 
	{
		Form.addParameter('DevPath',getSelectVal('SrvClDevType'));	
		Form.addParameter('DevFormat',getSelectVal('NewSrvClDevType'));
		Form.addParameter('x.X_HW_Token', getValue('hwonttoken'));
		Form.setAction('formatdev.cgi?x=formatdisk'
							 + '&RequestFile=html/ssmp/usbftp/format.asp');		
		Form.submit();	
	}
   
}

</script>
</head>
<body class="mainbody">
<div id="UsbFormat" style="margin-top:60px;">
<table width="100%">
<tr height="50">
<td id="format_dev" class="td_Fl_W40_L" >设备分区：</td>
<td colspan="2">
<select id='SrvClDevType' style="width:165px;FONT-SIZE:14px;" name='SrvClDevType'  onChange="onSelectDev()"> 
<script language="JavaScript" type="text/javascript">
if (WriteDeviceOption() == false)
{
	document.write('<option  value="">' + 'NO USB Device' + '</option>');
}
</script> 
</select> 
</td>
</tr>
<tr height="50" style="FONT-SIZE:14px;">
<td id="format_dev" class="td_Fl_W40_L" >分区原格式：</td>
<td colspan="2">
<script language="JavaScript" type="text/javascript">
if("" == DevFsType)
{
	document.write("--");
}
else
{
	document.write(htmlencode(DevFsType));
}
</script> 
</td>
</tr>
<tr height="50">
<td id="format_dev" class="td_Fl_W40_L" >分区新格式：</td>
<td colspan="2">
<select id='NewSrvClDevType' style="width:165px;FONT-SIZE:14px;" name='NewSrvClDevType'> 
	<option value=""></option>
	<option value="FAT32">FAT32</option>
</select> <strong style="color:#FF0000;">*</strong>
</td>
</tr>
</table>

<table width="100%">
<tr height="50">
<td id="td_format_un" align="center"><input class="submitform" name="FormatApply" id= "FormatApply" type="button" value="格式化分区" onClick="SubmitFormat();"> 
<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"></td>
</tr>
</table>
</div>
</body>
</html>