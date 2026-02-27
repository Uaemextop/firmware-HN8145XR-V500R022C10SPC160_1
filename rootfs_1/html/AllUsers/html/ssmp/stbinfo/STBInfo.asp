<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" />
<title>Share-Settings</title>
<link rel="stylesheet" type="text/css" href="../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>"/>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" type="text/javascript">

var token = "<%HW_WEB_GetToken();%>";
$.ajax({
    type : "POST",
    async : false,
    cache : false,
    url : 'setSTBInfo.cgi?RequestFile=html/ssmp/stbinfo/STBInfo.asp',
    data : 'x.X_HW_Token=' + token,
    success : function() {
    }
});

var STBInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_STBDeviceInfo, SWVersion|HDVersion|OS|ReleaseTime|PlatAddr|NTPAddr|IfCount|IPTVVersion, stSTBInfo);%>;
var STBWANInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_STBDeviceInfo.X_HW_STBWanInfo.{i}, IfIndex|IfName|MAC|IPAddr|IPMask|GateWayIP|PrimaryDNS|SecondaryDNS|IPV6AddrDHCP|IPV6AddrSLAAC|IPV6AddrLLA|IPV6GateWay|IPV6PrimaryDNS|IPV6SecondaryDNS, stSTBWANInfo);%>;

InitSTBWANInfo();

function stSTBInfo(domain, SWVersion, HDVersion, OS, ReleaseTime, PlatAddr, NTPAddr, IfCount, IPTVVersion)
{
	this.Domain = domain;
	this.swversion = SWVersion;
	this.hdversion = HDVersion;
	this.os = OS;
	this.releasetime = ReleaseTime;
	this.plataddr = PlatAddr;
	this.ntpaddr = NTPAddr;
	this.ifcount = IfCount;
	this.iptvversion = IPTVVersion;
}

function stSTBWANInfo(domain, IfIndex, IfName, MAC, IPAddr, IPMask, GateWayIP, PrimaryDNS, SecondaryDNS, IPV6AddrDHCP, IPV6AddrSLAAC, IPV6AddrLLA, IPV6GateWay, IPV6PrimaryDNS, IPV6SecondaryDNS)
{
	this.domain = domain;
	this.wanindex = IfIndex;
	this.name = IfName;
	this.macinfo = MAC;
	this.wanip = IPAddr;
	this.wanmask = IPMask;
	this.br0ip = GateWayIP;
	this.primarydns = PrimaryDNS;
	this.seconddns = SecondaryDNS;
	this.ipv6addrdhcp = IPV6AddrDHCP;
	this.ipv6addrslaac = IPV6AddrSLAAC;
	this.ipv6addrlla = IPV6AddrLLA;
	this.ipv6gateway = IPV6GateWay;
	this.ipv6primarydns = IPV6PrimaryDNS;
	this.ipv6seconddns = IPV6SecondaryDNS;
}

function InitSTBWANInfo()
{
	if (STBInfo[0].ifcount == 0)
	{
		STBWANInfo[0] = new stSTBWANInfo();
		STBWANInfo[0].wanindex = "--";
		STBWANInfo[0].name = "--";
		STBWANInfo[0].macinfo = "--";
		STBWANInfo[0].wanip = "--";
		STBWANInfo[0].wanmask = "--";
		STBWANInfo[0].br0ip = "--";
		STBWANInfo[0].primarydns = "--";
		STBWANInfo[0].seconddns = "--";
		STBWANInfo[0].ipv6addrdhcp = "--";
		STBWANInfo[0].ipv6addrslaac = "--";
		STBWANInfo[0].ipv6addrlla = "--";
		STBWANInfo[0].ipv6gateway = "--";
		STBWANInfo[0].ipv6primarydns = "--";
		STBWANInfo[0].ipv6seconddns = "--";
	}
}

function LoadFrame()
{
	setControl(0);
	return;
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<div id="PanelPrompt"> 
  <table class='width_100p'  border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
    <tr> 
      <td class="prompt">
	  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	  	<table class='width_100p' border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
			<td class='title_common' ><label id="Title_wan_satus_lable">在本页面上，您可以查询STB相关信息。</label> </td> 
          </tr> 
        </table></td> 
    </tr> 
  </table> 
  <div class="title_spread"></div>
</div>

<div class="func_title">机顶盒模块版本信息</div>
<table id="table_STBInfo" width="100%" border="0" cellpadding="0" cellspacing="1" class="table_bg">
	<tr>
	<td class="table_title" width="25%" align="left" id="Table_base1_1_table" name="Table_base1_1_table">系统软件版本号:&nbsp;</td>
	<td class="table_right" width="75%" id="Table_base1_2_table" name="Table_base1_2_table">
	<script type="text/javascript" language="javascript">
		document.write(STBInfo[0].swversion);
	</script>
	</td>
	</tr>
	
	<tr>
	<td class="table_title" width="25%" align="left" id="Table_base2_1_table" name="Table_base2_1_table">硬件版本号:&nbsp;</td>
	<td class="table_right" width="75%" id="Table_base2_2_table" name="Table_base2_2_table">
	<script type="text/javascript" language="javascript">
		document.write(STBInfo[0].hdversion);
	</script>
	</td>
	</tr>

	<tr>
	<td class="table_title" width="25%" align="left" id="Table_base3_1_table" name="Table_base3_1_table">操作系统版本号:&nbsp;</td>
	<td class="table_right" width="75%" id="Table_base3_2_table" name="Table_base3_2_table">
	<script type="text/javascript" language="javascript">
		document.write(STBInfo[0].os);
	</script>
	</td>
	</tr>
	
	<tr>
	<td class="table_title" width="25%" align="left" id="Table_base4_1_table" name="Table_base4_1_table">版本日期:&nbsp;</td>
	<td class="table_right" width="75%" id="Table_base4_2_table" name="Table_base4_2_table">
	<script type="text/javascript" language="javascript">
		document.write(STBInfo[0].releasetime);
	</script>
	</td>
	</tr>
	
	<tr>
	<td class="table_title" width="25%" align="left" id="Table_base4_1_table" name="Table_base4_1_table">IPTV版本号:&nbsp;</td>
	<td class="table_right" width="75%" id="Table_base4_2_table" name="Table_base4_2_table">
	<script type="text/javascript" language="javascript">
		document.write(STBInfo[0].iptvversion);
	</script>
	</td>
	</tr>
</table>


<div class="title_spread"></div>
<div class="func_title">服务器信息</div>
<table id="table_STBInfo" width="100%" border="0" cellpadding="0" cellspacing="1" class="table_bg">
	<tr>
	<td class="table_title" width="25%" align="left" id="Table_base5_1_table" name="Table_base5_1_table">机顶盒终端管理平台地址:&nbsp;</td>
	<td class="table_right" width="75%" id="Table_base5_2_table" name="Table_base5_2_table">
	<script type="text/javascript" language="javascript">
		document.write(STBInfo[0].plataddr);
	</script>
	</td>
	</tr>

	<tr>
	<td class="table_title" width="25%" align="left" id="Table_base6_1_table" name="Table_base6_1_table">NTP地址:&nbsp;</td>
	<td class="table_right" width="75%" id="Table_base6_2_table" name="Table_base6_2_table">
	<script type="text/javascript" language="javascript">
		document.write(STBInfo[0].ntpaddr);
	</script>
	</td>
	</tr>
</table>

<table class="tabal_bg width_100p"  cellspacing="1" id="table_STBWANPanel" > 
  <div class="title_spread"></div>
  <div class="func_title" id = "table_stb_wan_table">网络信息</div>
  <tr class="head_title"> 
	<td id = "table_stb_wan_1_1_table" nowrap>序号</td> 
	<td id = "table_stb_wan_1_2_table" nowrap>WAN名称</td> 
    <td id = "table_stb_wan_1_3_table" nowrap>MAC地址</td> 
    <td id = "table_stb_wan_1_4_table" nowrap>IP地址</td>
  </tr>
  <script type="text/javascript" language="javascript">
	function InitSTBWANInfoShow()
	{
		var iCol = 0;

		for (var i = 0; i < STBInfo[0].ifcount; i++)
		{
			iCol = i + 2;
			document.write('<tr id="record_' + i + '" onclick="selectSTBWANLine(this.id);" class="tabal_center01">');
			document.write('<td id = "table_stb_wan_' + iCol + '_1_table" nowrap>' + STBWANInfo[i].wanindex + '</td>');
			document.write('<td id = "table_stb_wan_' + iCol + '_1_table" nowrap>' + STBWANInfo[i].name + '</td>');
			document.write('<td id = "table_stb_wan_' + iCol + '_1_table" nowrap>' + STBWANInfo[i].macinfo + '</td>');
			document.write('<td id = "table_stb_wan_' + iCol + '_1_table" nowrap>' + STBWANInfo[i].wanip + '</td>');
			document.write('</tr>');
		}
		
		if (STBInfo[0].ifcount == 0)
		{
			document.write('<tr id="record_2" onclick="selectSTBWANLine(this.id);" class="tabal_center01">');
			document.write('<td id = "table_stb_wan_2_1_table" nowrap>' + STBWANInfo[0].wanindex + '</td>');
			document.write('<td id = "table_stb_wan_2_1_table" nowrap>' + STBWANInfo[0].name + '</td>');
			document.write('<td id = "table_stb_wan_2_1_table" nowrap>' + STBWANInfo[0].macinfo + '</td>');
			document.write('<td id = "table_stb_wan_2_1_table" nowrap>' + STBWANInfo[0].wanip + '</td>');
			document.write('</tr>');			
		}
	}
		
	function setControl(WanIndex)
	{
		var CurrentWan = STBWANInfo[WanIndex];
		document.getElementById("WanDetail").style.display = "";
		setElementInnerHtmlById("WANIndexID", CurrentWan.wanindex);
		setElementInnerHtmlById("WANNameID", CurrentWan.name);
		setElementInnerHtmlById("WANMacID", CurrentWan.macinfo);
		setElementInnerHtmlById("WANIPID", CurrentWan.wanip);
		setElementInnerHtmlById("WANMaskID", CurrentWan.wanmask);
		setElementInnerHtmlById("WANBR0ID", CurrentWan.br0ip);
		setElementInnerHtmlById("WANPrimaryDNSID", CurrentWan.primarydns);
		setElementInnerHtmlById("WANSecondDNSID", CurrentWan.seconddns);
		setElementInnerHtmlById("WANIPV6AddrDHCPID", CurrentWan.ipv6addrdhcp);
		setElementInnerHtmlById("WANIPV6AddrSLAACID", CurrentWan.ipv6addrslaac);
		setElementInnerHtmlById("WANIPV6AddrLLAID", CurrentWan.ipv6addrlla);
		setElementInnerHtmlById("WANIPV6GateWayID", CurrentWan.ipv6gateway);
		setElementInnerHtmlById("WANIPV6PrimaryDNSID", CurrentWan.ipv6primarydns);
		setElementInnerHtmlById("WANIPV6SecondaryDNSID", CurrentWan.ipv6seconddns);
	}

	function selectSTBWANLine(id)
	{
		selectLine(id);
	}
	
	InitSTBWANInfoShow();
  </script> 
</table>

<div  align='center' id="WanDetail">
<table id="table_wandetail" class="tabal_bg width_100p"  cellspacing="1" > 
  <tr class="head_title align_left"> 
    <td  colspan="8">网络详细信息</td> 
  </tr> 

  <tr class="tabal_01 align_left" id="WANIndexRow">
    <td  width="30%">序号</td>
    <td  width="70%" id="WANIndexID"></td>
  </tr>
  
  <tr class="tabal_01 align_left"  id="WANNameRow">
    <td  width="30%">WAN名称</td>
    <td  width="70%" id="WANNameID"></td>
  </tr>

  <tr class="tabal_01 align_left"  id="WANMacRow">
    <td  width="30%">MAC地址</td>
    <td  width="70%" id="WANMacID"></td>
  </tr>
  
  <tr class="head_title align_left"> 
    <td  colspan="8">IPv4</td> 
  </tr> 
  
  <tr class="tabal_01 align_left"  id="WANIPRow">
    <td  width="30%">IP地址</td>
    <td  width="70%" id="WANIPID"></td>
  </tr>

  <tr class="tabal_01 align_left"  id="WANMaskRow">
    <td  width="30%">子网掩码</td>
    <td  width="70%" id="WANMaskID"></td>
  </tr>

  <tr class="tabal_01 align_left"  id="WANBR0Row">
    <td  width="30%">默认网关</td>
    <td  width="70%" id="WANBR0ID"></td>
  </tr>

  <tr class="tabal_01 align_left"  id="WANPrimaryDNSRow">
    <td  width="30%">首选DNS</td>
    <td  width="70%" id="WANPrimaryDNSID"></td>
  </tr>
  
  <tr class="tabal_01 align_left"  id="WANSecondDNSRow">
    <td  width="30%">备选DNS</td>
    <td  width="70%" id="WANSecondDNSID"></td>
  </tr>
  
  <tr class="head_title align_left"> 
    <td  colspan="8">IPv6</td> 
  </tr>  
  
  <tr class="tabal_01 align_left"  id="WANIPV6AddrDHCPRow">
    <td  width="30%">DHCPv6地址</td>
    <td  width="70%" id="WANIPV6AddrDHCPID"></td>
  </tr>
  
  <tr class="tabal_01 align_left"  id="WANIPV6AddrSLAACRow">
    <td  width="30%">SLAAC地址</td>
    <td  width="70%" id="WANIPV6AddrSLAACID"></td>
  </tr>
  
  <tr class="tabal_01 align_left"  id="WANIPV6AddrLLARow">
    <td  width="30%">LLA地址</td>
    <td  width="70%" id="WANIPV6AddrLLAID"></td>
  </tr>
  
  <tr class="tabal_01 align_left"  id="WANIPV6GateWayRow">
    <td  width="30%">默认网关</td>
    <td  width="70%" id="WANIPV6GateWayID"></td>
  </tr>
  
  <tr class="tabal_01 align_left"  id="WANIPV6PrimaryDNSRow">
    <td  width="30%">首选DNS</td>
    <td  width="70%" id="WANIPV6PrimaryDNSID"></td>
  </tr>
  
  <tr class="tabal_01 align_left"  id="WANIPV6SecondaryDNSRow">
    <td  width="30%">备选DNS</td>
    <td  width="70%" id="WANIPV6SecondaryDNSID"></td>
  </tr>
</table>
</div>

</body>
</html>
