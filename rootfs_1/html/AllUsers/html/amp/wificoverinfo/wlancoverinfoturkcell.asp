<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1" /><!-IE7 mode->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html, cfg_wificoverinfo_language);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>


<title>Smart WiFi Coverage</title>
<style type="text/css">
html,body,div,p,ul,li,dl,dt,dd,h1,h2,h3,h4,h5,h6,form,input,select,button,textarea,iframe,table,th,td {
    margin: 0;
    padding: 0
}

img {
    border: 0 none;
    vertical-align: top
}

.firstConnectLine{
	padding: 0px 5px;
	width: 22px;
	height:2px;
	background-color:#d3d3d3;
	margin-top: 35px;
}

ul,li {
    list-style-type: none
}

.firstOntIcon{
	width: 60px;
	height: 60px;
	background-image:url(../../../images/wifiseticon.png);
	background-position: left center;
	background-size: 60px 60px;
	background-repeat: no-repeat;
	padding: 0px 5px;
	margin-top:8px;
}

i,em,cite {
    font-style: normal
}

h1,h2,h3,h4,h5,h6 {
    font-size: 14px
}

body,input,select,button,textarea {
    font-size: 12px;
    font-family: "Microsoft YaHei", "微软雅黑", Tahoma, Geneva, sans-serif
}

.firstOntIcon,.firstOntStruct,.firstConnectLine,.secondOntStruct,.firstMountDevType{
	float:left;
}

button {
    cursor: pointer
}

body {
    line-height: 1.2
}

a,a:link {
    text-decoration: none
}

a:active,a:hover {
    text-decoration: none
}

a:focus {
    outline: none
}

.ApLevelStruct {
	width: 115%;
	height:100%;
	background-color:#f6f6f6;
	color:black;
}

#secondOntStructId {

}
.firstMountDevType{
	margin-top: 25px;
	line-height: 14px;
}
.ssss{
	min-height:100px;
	background-position: 0px 35px;
	background-repeat: no-repeat;
}
.AccessTypeLine{
    color:#b60000;
    background-image:url(../../../images/phoneiconmove.png);
}
.AccessTypeLine_1{
	color:#b60000;
	background-image:url(../../../images/linedev.png);
}
.AccessTypeLine_0{
	color:#b60000;
	background-image:url(../../../images/phoneiconmove.png);
}

.AccessTypeLine_2{
	color:#b60000;
	background-image:url(../../../images/phoneiconmove.png);
}
.AccessTypeLine_3{
	color:#b60000;
	background-image:url(../../../images/phoneiconmove.png);
}

.AccessTypeLine_4{
    color:#b60000;
    background-image:url(../../../images/phoneiconmove.png);
}

.AccessTypeLine_5{
	color:#b60000;
	background-image:url(../../../images/phoneiconmove.png);
}
.sssDDDDs{
	min-height:100px;
	clear:both;
	width:780px;
}

.WifiStatusShow{
display:none;
width:700px;
height:700px;
margin-left:0px;
margin-right:auto;
margin-top:0px;
position:absolute;
z-index:100;
filter: alpha(opacity=0); 
-moz-opacity: 0; 
-khtml-opacity: 0; 
opacity: 0;
background-color:#eeeeee;
}
.topuMsg tbody{
	position: absolute;
	width: 320px;
	margin-top: 0px;
}
.topuMsg {
    position: relative;
    width: 320px;
    height: 120px;
    background-image: url(../../../images/topuMsg.png);
    margin-top: 65px;
    left: -130px;
    z-index: 222;
    display: none;
    background-size: 100%;
    color: #fff;
    background-repeat: round;
}
.ethDisMsg div {
float: left;
margin: 0px 5px;
line-height: 24px;
font-size: 12px;
color: #fff;
}
.ethDisMsg {
clear: both;
margin-left: 10px;
margin-top: 20px;
}
.tabal_02 th{
width:16%;
padding-top: 14px;
}
.ApLevelStruct div{
color:black;
}
.apOffLinePic {
    float:left;
    width: 60px;
    height: 60px;
    background-position: center center;
    background-size: 60px 60px;
    background-repeat: no-repeat;
    opacity:0.5;
    filter: alpha(opacity=50); 
    -moz-opacity: 0.5; 
    -khtml-opacity: 0.5; 
}
.apOffLineText {
    opacity:0.7;
    filter: alpha(opacity=70); 
    -moz-opacity: 0.7; 
    -khtml-opacity: 0.7; 
}
</style>
<script language="JavaScript" type="text/javascript">

var CfgMode = '<%HW_WEB_GetCfgMode();%>';

var token="<%HW_WEB_GetToken();%>"
$.ajax({
    type : "POST",
    async : false,
    cache : false,
    url : "userDevSendArp.cgi?RequestFile=html/amp/wificoverinfo/wlancoverinfoturkcell.asp",
    data: 'x.X_HW_Token=' + token,
    success : function(data) {
    }
});

var rosunionGame = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_ROSUNION_GAME);%>';
var nohometitle = '<%HW_WEB_GetFeatureSupport(FT_WEB_NOHOME_TITLE);%>';
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';
var TypeWord='<%HW_WEB_GetTypeWord();%>';
var isBponFlag = '<%HW_WEB_GetFeatureSupport(HW_FEATURE_ZQ);%>';
var isPhone = 0;
if ((navigator.userAgent.match(/(phone|pad|pod|iPhone|iPod|ios|iPad|Android|wOSBrowser|BrowserNG|WebOS)/i))) {
    isPhone = 1;
}

function USERDeviceInfo(Domain,MACAddress,Name) {
    this.Domain = Domain;
    this.MACAddress = MACAddress;
    this.Name = Name;
}
var g_AllUserDevinfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_HOMENET_NAME.hosts.{i},MACAddress|Name ,USERDeviceInfo);%>;

function stPlcAdptInfos(domain, DeviceName, Manufacturer, ManufacturerOUI, SerialNumber, HardwareVersion, SoftwareVersion, MacAddress, DuplexMode, Speed, DomainName, MiniBoost)
{
    this.domain = domain;
    this.DeviceName = DeviceName;
    this.Manufacturer = Manufacturer;    
    this.ManufacturerOUI = ManufacturerOUI.toUpperCase();
    this.SerialNumber = SerialNumber;
    this.HardwareVersion = HardwareVersion;
    this.SoftwareVersion = SoftwareVersion;
    this.MacAddress = MacAddress.toUpperCase();
    this.DuplexMode = DuplexMode;
    this.Speed = Speed;
	this.DomainName = DomainName;
	this.MiniBoost = MiniBoost ;
}

function stPlcInfos(domain, MacAddress, RxRate, TxRate) 
{
    this.domain = domain;
    this.MacAddress = MacAddress.toUpperCase();
    this.RxRate = RxRate;    
    this.TxRate = TxRate;
}


var PlcAdptInfo = new Array();
var PlcInfo = new Array();
var PlcAdptNum = 0;
var PlcNum = 0;

var PlcInfoIndexMap = {};
if (0 != PlcInfo.length - 1)
{
	for (index = 0; index < PlcInfo.length - 1; index++)
	{	
		var plcInfoMac = PlcInfo[index].MacAddress;
		PlcInfoIndexMap[plcInfoMac] = index;
	}
}
   
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';

var miniBoostArr = { '4' : '50Mhz', 
	                  '20' : '50Mhz MIMO', 
	                  '22' : '50Mhz MIMO', 
	                  '1' : '100Mhz ', 
	                  '7' : '100Mhz MIMO', 
					  '23' : '100Mhz',
	                  '25' : 'Coax 200Mhz',
                      '9' :  'Coax 100Mhz'					  
	                };	

var deviceNameMap = { 'MVL5152' : 'PA8011V', 
	                  'MVL5153' : 'CA8011V'			  
	                };						
					
function LoadResource()
{
    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) 
    {
        var b = all[i];
        if(b.getAttribute("BindText") == null)
        {
            continue;
        }

        if (cfg_wificoverinfo_language[b.getAttribute("BindText")]) 
        {
            b.innerHTML = cfg_wificoverinfo_language[b.getAttribute("BindText")];
        }
    }
}

function getInstIdByDomain(domain)
{
    if ('' != domain)
    {
        return parseInt(domain.substr(domain.lastIndexOf('.') + 1));    
    }
}

function stApDevice(domain, type, sn, hwversion, swversion,uptime, channel, transmitepower, ApOnlineFlag, SupportedRFBand, UplinkType, GhnMacAddr, APMacAddr, SyncStatus)
{
    this.domain = domain;
    this.type = type;
    this.sn = sn;
    this.hwversion = hwversion;
    this.swversion = swversion;
    this.uptime = uptime;
    this.channel = channel;
    this.transmitepower = transmitepower;
	this.ApOnlineFlag = ApOnlineFlag;
	this.SupportedRFBand = SupportedRFBand;
	this.UplinkType = UplinkType;
	this.GhnMacAddr = GhnMacAddr.toUpperCase();
    this.APMacAddr = APMacAddr;
    this.SyncStatus = SyncStatus;
}

var apDeviceList = new Array();
apDeviceList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i}, DeviceType|SerialNumber|HardwareVersion|SoftwareVersion|UpTime|CurrentChannel|TransmitPower|ApOnlineFlag|SupportedRFBand|UplinkType|GhnMacAddr|APMacAddr|SyncStatus, stApDevice);%>;

function stApConfDevice(domain, BSSID, RFBand) {
    this.domain = domain;
    this.BSSID = BSSID;
    this.RFBand = RFBand;
}

var apDeviceConfigList = new Array();
apDeviceConfigList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i}.WLANConfiguration.{i}, BSSID|RFBand, stApConfDevice);%>;

var LineId = 0;

function getSecMac(macSet)
{
    var secMac = "00:00:00:00:00:00";
    var len = secMac.length;
    if(macSet.length >= 2 * len + 1)
    {
        secMac = macSet.substring(len + 1, 2 * len + 1);
    }
    return secMac.toUpperCase();         
}

function getInstFromMacDom(domain)
{
    var path = "InternetGatewayDevice.X_HW_APDevice.1";
    var apdomain = '';
    if(domain.length >= path.length)
    {
        apdomain = domain.substring(0, path.length);
    }
    return getInstIdByDomain(apdomain);         
}

function stApSsid(domain, SSID, RFBand, Channel)
{
    this.domain = domain;
    this.SSID = SSID;
    this.RFBand = RFBand;
	this.Channel = Channel;
}

var apSsid = new Array();
var apSsid= <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i}.WLANConfiguration.{i}, SSID|RFBand|Channel, stApSsid);%>;

function stApRadioCfg(domain, RFBand, Channel, Power)
{
    this.domain = domain;
    this.RFBand = RFBand;
    this.Channel = Channel;
    this.Power = Power;
}

var apRadiCfg = new Array();

function stGhnNodeInfoTotal(GhnNodeName, GhnNodeInfoTotal)
{
    this.GhnNodeName = GhnNodeName;
    this.GhnNodeInfoTotal = GhnNodeInfoTotal;
}

function stGhnOtherInfoTotal(DomainName, DomainNameValue, MacAddress, MacAddressValue,
                                Manufacturer, ManufacturerValue, ManufacturerOUI, ManufacturerOUIValue,
                                MiniBoost, MiniBoostValue, SerialNumber, SerialNumberValue,
                                DeviceName, DeviceNameValue, SoftwareVersion, SoftwareVersionValue)
{
    this.DomainName = DomainName;
    this.DomainNameValue = DomainNameValue;
    this.MacAddress = MacAddress;
    this.MacAddressValue = MacAddressValue;
    this.Manufacturer = Manufacturer;
    this.ManufacturerValue = ManufacturerValue;
    this.ManufacturerOUI = ManufacturerOUI;
    this.ManufacturerOUIValue = ManufacturerOUIValue;
    this.MiniBoost = MiniBoost;
    this.MiniBoostValue = MiniBoostValue;
    this.SerialNumber = SerialNumber;
    this.SerialNumberValue = SerialNumberValue;
    this.DeviceName = DeviceName;
    this.DeviceNameValue = DeviceNameValue;
    this.SoftwareVersion = SoftwareVersion;
    this.SoftwareVersionValue = SoftwareVersionValue;
}

function stGhnEthStatisInfo(TIMER, MSECS, ETHATxByte, ETHARxByte, ETHBTxByte, ETHBRxByte, ETHATxPackets, ETHARxPackets, ETHBTxPackets, ETHBRxPackets)
{
    this.TIMER = TIMER;
    this.MSECS = MSECS;
    this.ETHARxByte = ETHARxByte;
    this.ETHARxPackets = ETHARxPackets;
    this.ETHATxByte = ETHATxByte;
    this.ETHATxPackets = ETHATxPackets;

    this.ETHBTxByte = ETHBTxByte;
    this.ETHBRxByte = ETHBRxByte;
    this.ETHBTxPackets = ETHBTxPackets;
    this.ETHBRxPackets = ETHBRxPackets;
}

function stGhnOtherStatisInfo(DomainName, MacAddress, Manufacturer, ManufacturerOUI, MiniBoost, SerialNumber, DeviceName, HardwareVersion, SoftwareVersion)
{
	this.DomainName = DomainName;
	this.MacAddress = MacAddress;
	this.Manufacturer = Manufacturer;
	this.ManufacturerOUI = ManufacturerOUI;
	this.MiniBoost = MiniBoost;
	this.SerialNumber = SerialNumber;
	this.DeviceName = DeviceName;
	this.HardwareVersion = HardwareVersion;
	this.SoftwareVersion = SoftwareVersion;
}

function stGhnLineStatisInfo(BytesSent, BytesReceived, PacketsSent, PacketsReceived, ErrorsSent, ErrorsReceived, UnicastPacketsSent, UnicastPacketsReceived, DiscardPacketsSent, DiscardPacketsReceived, MacAddress, RxRate, TxRate)
{
    this.MacAddress = MacAddress;
    this.RxRate = RxRate;    
    this.TxRate = TxRate;

    this.BytesReceived = BytesReceived;
    this.PacketsReceived = PacketsReceived;
    this.ErrorsReceived = ErrorsReceived;
    this.DiscardPacketsReceived = DiscardPacketsReceived;

    this.BytesSent = BytesSent;
    this.PacketsSent = PacketsSent;
    this.ErrorsSent = ErrorsSent;
    this.DiscardPacketsSent = DiscardPacketsSent;

    this.UnicastPacketsSent = UnicastPacketsSent;
    this.UnicastPacketsReceived = UnicastPacketsReceived;

}

var ghnEthStatisInfo  = new stGhnEthStatisInfo('-','-','-','-','-','-','-','-','-','-','-','-','-');
var ghnOtherStatisInfo = new stGhnOtherStatisInfo('-', '-', '-', '-', '-', '-', '-', '-', '-');
var ghnLineStatisInfo = new stGhnLineStatisInfo('-','-','-','-','-','-','-','-','-','-');

function DisplayGhnEthInfo(plcInst)
{
    var Mac;
    var DuplexMode;
    var Speed;
    var RxBytes;
    var RxPackets;
    var TxBytes;
    var TxPackets;

    if (plcInst > 0) {
        setDisplay('ghntab1', 0);

        var divGhnTab = document.getElementById('DivGhnTab');
        var Htmldiv = divGhnTab.innerHTML;
        divGhnTab.innerHTML = '';
        divGhnTab.innerHTML = Htmldiv;
    } else {
        setDisplay('ghntab1', 1);
        if (PlcAdptNum > 0) {
            DuplexMode = PlcAdptInfo[0].DuplexMode;
            Speed = PlcAdptInfo[0].Speed;
            RxBytes = ghnEthStatisInfo.ETHBRxByte;
            RxPackets = ghnEthStatisInfo.ETHBRxPackets;
            TxBytes = ghnEthStatisInfo.ETHBTxByte;
            TxPackets = ghnEthStatisInfo.ETHBTxPackets;

            getElementById('tdPlcNum').innerHTML = PlcNum;
            getElementById('tdGhnEthDuplexMode').innerHTML = DuplexMode;
            getElementById('tdGhnEthSpeed').innerHTML = Speed;
            getElementById('tdGhnEthRxBytes').innerHTML = RxBytes;
            getElementById('tdGhnEthRxPackets').innerHTML = RxPackets;
            getElementById('tdGhnEthTxBytes').innerHTML = TxBytes;
            getElementById('tdGhnEthTxPackets').innerHTML = TxPackets;
        }
    }
}

function DisplayGhnOtherInfo(apMapId)
{
    if (apMapId > 0) {

        getElementById('tdGhnOtherDomainName').innerHTML = ghnOtherStatisInfo.DomainName;
        getElementById('tdGhnOtherMAC').innerHTML = ghnOtherStatisInfo.MacAddress;
        getElementById('tdGhnOtherVendor').innerHTML = ghnOtherStatisInfo.Manufacturer;
        getElementById('tdGhnOtherVendorOUI').innerHTML = ghnOtherStatisInfo.ManufacturerOUI;
        getElementById('tdGhnOtherSN').innerHTML = ghnOtherStatisInfo.SerialNumber.substr(20, 16);
        getElementById('tdGhnOtherMiniBoost').innerHTML = miniBoostArr[ghnOtherStatisInfo.MiniBoost];
        getElementById('tdGhnOtherDviceName').innerHTML = ghnOtherStatisInfo.DeviceName;
        getElementById('tdGhnOtherHardware').innerHTML = ghnOtherStatisInfo.HardwareVersion;
        getElementById('tdGhnOtherSoftware').innerHTML = ghnOtherStatisInfo.SoftwareVersion;
    } else {
        getElementById('tdGhnOtherDomainName').innerHTML = PlcAdptInfo[0].DomainName;
        getElementById('tdGhnOtherMAC').innerHTML = PlcAdptInfo[0].MacAddress;
        getElementById('tdGhnOtherVendor').innerHTML = PlcAdptInfo[0].Manufacturer;
        getElementById('tdGhnOtherVendorOUI').innerHTML = PlcAdptInfo[0].ManufacturerOUI;
        getElementById('tdGhnOtherSN').innerHTML = PlcAdptInfo[0].SerialNumber;
        getElementById('tdGhnOtherMiniBoost').innerHTML = miniBoostArr[PlcAdptInfo[0].MiniBoost];
        getElementById('tdGhnOtherDviceName').innerHTML = PlcAdptInfo[0].DeviceName;
        getElementById('tdGhnOtherHardware').innerHTML = PlcAdptInfo[0].HardwareVersion;
        getElementById('tdGhnOtherSoftware').innerHTML = PlcAdptInfo[0].SoftwareVersion;
    }
}


var ghnMacAddress;

var itemArray;
var ghnEthStatisInfoTotal = new Array();
var ghnOtherStatisInfoTotal = new Array();
var ghnLineStatisInfoTotal = new Array();
var ghnLineStatisInfoList = new Array();

function setGhnPlcLineStatisTable()
{
    if (0 == ghnLineStatisInfoList.length) {
        return;
    }
    var DivGhnLine = getElementById('Div_ghntab2_Table_Container');
    var TbGhnLineHtml = '';
    TbGhnLineHtml += '<table id="ghn_line_statistic_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">';
    TbGhnLineHtml += '<tr class="head_title">';
    TbGhnLineHtml += '<td class="width_per20" rowspan="2">' + cfg_wificoverinfo_language['amp_wificover_ghn_mac']+ '</td>';
    TbGhnLineHtml += '<td class="width_per10" rowspan="2">' + cfg_wificoverinfo_language['amp_wificover_ap_sta_rate_rx']+ '</td>';
    TbGhnLineHtml += '<td class="width_per10" rowspan="2">' + cfg_wificoverinfo_language['amp_wificover_ap_sta_rate_tx']+ '</td>';
    TbGhnLineHtml += '<td colspan="4">' + cfg_wificoverinfo_language['amp_wificover_ap_stats_rx']+ '</td>';
    TbGhnLineHtml += ' <td colspan="4">' + cfg_wificoverinfo_language['amp_wificover_ap_stats_tx']+ '</td></tr>';
    TbGhnLineHtml += '<tr class="head_title">';
    TbGhnLineHtml += '<td>' + cfg_wificoverinfo_language['amp_wificover_ap_stats_byte']+ '</td>';
    TbGhnLineHtml += '<td>' + cfg_wificoverinfo_language['amp_wificover_ap_stats_pkg']+ '</td>';
    TbGhnLineHtml += '<td>' + cfg_wificoverinfo_language['amp_wificover_ap_stats_errpkg']+ '</td>';
    TbGhnLineHtml += '<td>' + cfg_wificoverinfo_language['amp_wificover_ap_stats_droppkg']+ '</td>';
    TbGhnLineHtml += '<td>' + cfg_wificoverinfo_language['amp_wificover_ap_stats_byte']+ '</td>';
    TbGhnLineHtml += '<td>' + cfg_wificoverinfo_language['amp_wificover_ap_stats_pkg']+ '</td>';
    TbGhnLineHtml += '<td>' + cfg_wificoverinfo_language['amp_wificover_ap_stats_errpkg']+ '</td>';
    TbGhnLineHtml += '<td>' + cfg_wificoverinfo_language['amp_wificover_ap_stats_droppkg']+ '</td></tr>';

    for(var i = 0; i < ghnLineStatisInfoList.length; i++ ) {
        TbGhnLineHtml += '<tr id="record_' + i + '" class="tabal_02">';

        TbGhnLineHtml += '<td id ="tdGhnLineMAC' + i + '"  class=\"align_center\">'+  ghnLineStatisInfoList[i].MacAddress  +'</td>';
        TbGhnLineHtml += '<td id= "tdGhnLineRxRate' + i + '" class=\"align_center\">'+  ghnLineStatisInfoList[i].RxRate  +'</td>';
        TbGhnLineHtml += '<td id= "tdGhnLineTxRate' + i + '" class=\"align_center\">'+  ghnLineStatisInfoList[i].TxRate  +'</td>';
        TbGhnLineHtml += '<td id= "tdGhnLineRxBytes' + i + '" class=\"align_center\">'+  ghnLineStatisInfoList[i].BytesReceived   +'</td>';
        TbGhnLineHtml += '<td id= "tdGhnLineRxPackets' + i + '" class=\"align_center\">'+  ghnLineStatisInfoList[i].PacketsReceived   +'</td>';
        TbGhnLineHtml += '<td id= "tdGhnLineRxErrPackets' + i + '" class=\"align_center\">'+  ghnLineStatisInfoList[i].ErrorsReceived   +'</td>';
        TbGhnLineHtml += '<td id= "tdGhnLineRxDropPackets' + i + '" class=\"align_center\">'+  ghnLineStatisInfoList[i].DiscardPacketsReceived   +'</td>';
        TbGhnLineHtml += '<td id= "tdGhnLineTxBytes' + i + '" class=\"align_center\">'+  ghnLineStatisInfoList[i].BytesSent   +'</td>';
        TbGhnLineHtml += '<td id= "tdGhnLineTxPackets' + i + '" class=\"align_center\">'+  ghnLineStatisInfoList[i].PacketsSent   +'</td>';
        TbGhnLineHtml += '<td id= "tdGhnLineTxErrPackets' + i + '" class=\"align_center\">'+  ghnLineStatisInfoList[i].ErrorsSent   +'</td>';
        TbGhnLineHtml += '<td id= "tdGhnLineTxDropPackets' + i + '" class=\"align_center\">'+  ghnLineStatisInfoList[i].DiscardPacketsSent  +'</td>';
        TbGhnLineHtml += '</tr>';
    }
    TbGhnLineHtml += '</table>';
    DivGhnLine.innerHTML = '';
    DivGhnLine.innerHTML = TbGhnLineHtml;
}

function getGhnEthStatisInfo(param1, param2)
{
    $.ajax({
            type : "POST",
            async : false,
            cache : false,

            data :"ParaSetList="+param1+"&GhnConstruct="+param2,
            url : "./getGhnDeviceInfo.asp",
            success : function(data) 
            {
                if (data != '') {
                    ghnEthStatisInfoTotal = eval(data);
                    if (undefined == ghnEthStatisInfoTotal[0]) {
                        return;
                    }

                    itemArray = ghnEthStatisInfoTotal[0].GhnNodeInfoTotal.split(',');
                    ghnEthStatisInfo = new stGhnEthStatisInfo(itemArray[0], itemArray[1], itemArray[2], itemArray[3], itemArray[4], itemArray[5], itemArray[6], itemArray[7], itemArray[8], itemArray[9]);
                }
        }});
}

function getGhnOtherStatisInfo(param1, param2)
{
    $.ajax({
            type : "POST",
            async : false,
            cache : false,

            data :"ParaSetList="+param1+"&GhnConstruct="+param2,
            url : "./getGhnDeviceInfo.asp",
            success : function(data) 
            {
                if (data != '') {
                    var changeData = data.replace(/stGhnNodeInfoTotal/, "stGhnOtherInfoTotal");
                    ghnOtherStatisInfoTotal = eval(changeData);
                    if (undefined == ghnOtherStatisInfoTotal[0]) {
                        return;
                    }

                    var DeviceNameValue = ghnOtherStatisInfoTotal[0].DeviceNameValue;
                    var deviceName = DeviceNameValue.substr(0, DeviceNameValue.indexOf('.'));
                    var hardwareVersion = DeviceNameValue.substr(DeviceNameValue.indexOf('.')+1);

                    var Manufacturer = ghnOtherStatisInfoTotal[0].ManufacturerValue;

                    var SoftwareVersionValue = ghnOtherStatisInfoTotal[0].SoftwareVersionValue.replace(/V300/, "V3").replace(/SPC/, "S");
                    var SoftwareVersion = SoftwareVersionValue;

                    var IndexOfB0 = SoftwareVersionValue.indexOf('B');
                    if (IndexOfB0 >= 0) {
                        SoftwareVersion = SoftwareVersionValue.substr(0, IndexOfB0);
                    }

                    ghnOtherStatisInfo = new stGhnOtherStatisInfo(ghnOtherStatisInfoTotal[0].DomainNameValue, ghnOtherStatisInfoTotal[0].MacAddressValue,
                                                                  Manufacturer, "00259E",
                                                                  ghnOtherStatisInfoTotal[0].MiniBoostValue, ghnOtherStatisInfoTotal[0].SerialNumberValue,
                                                                  deviceNameMap[deviceName], hardwareVersion, SoftwareVersion);
                }
        }});
}

function getGhnLineStatisInfo(param1, param2, param3, plcInst)
{
    $.ajax({
            type : "POST",
            async : true,
            cache : false,

            data :"ParaSetList="+param1+"&GhnConstruct="+param2,
            url : "./getGhnDeviceInfo.asp",
            success : function(data) 
            {
                if (data != '') {
                    ghnLineStatisInfoTotal = eval(data);
                    if (undefined == ghnLineStatisInfoTotal[0]) {
                        return;
                    }
                    itemArray = ghnLineStatisInfoTotal[0].GhnNodeInfoTotal.split(',');
                    if (param3 > 0) {
                        ghnLineStatisInfo = new stGhnLineStatisInfo(itemArray[0], itemArray[1], itemArray[2], itemArray[3], itemArray[4], itemArray[5], itemArray[6], itemArray[7], itemArray[8], itemArray[9], PlcInfo[param3 - 1].MacAddress, PlcInfo[param3 - 1].RxRate, PlcInfo[param3 - 1].TxRate);
                        ghnLineStatisInfoList.push(ghnLineStatisInfo);
                        if (PlcNum == ghnLineStatisInfoList.length) {
                            setGhnPlcLineStatisTable();
                        }
                    } else {
                        ghnLineStatisInfo = new stGhnLineStatisInfo(itemArray[0], itemArray[1], itemArray[2], itemArray[3], itemArray[4], itemArray[5], itemArray[6], itemArray[7], itemArray[8], itemArray[9], PlcAdptInfo[0].MacAddress, PlcInfo[plcInst - 1].TxRate, PlcInfo[plcInst - 1].RxRate);
                        ghnLineStatisInfoList.push(ghnLineStatisInfo);
                        setGhnPlcLineStatisTable();
                    }

                }
            }
        });
}

function GetPlcGhnLineStatisInfoList(plcInst)
{
    ghnLineStatisInfoList = [];

    if (plcInst == 0) {
        for (var i = 1; i <= PlcNum; i++) {
            getGhnLineStatisInfo(PlcInfo[i - 1].MacAddress + '|QOS.STATS.G9962', 'stGhnNodeInfoTotal', i, 0);
        }
    } else {
        getGhnLineStatisInfo(PlcAdptInfo[0].MacAddress + '|QOS.STATS.G9962', 'stGhnNodeInfoTotal', 0, plcInst);
    }
}

function GetGhnInfo(MAC, plcInst)
{
    ghnMacAddress = MAC;

    if ((PlcAdptNum > 0) || (PlcNum > 0)) {
        getGhnEthStatisInfo(ghnMacAddress + '|ETHIFDRIVER.STATS.INFO', 'stGhnNodeInfoTotal');
        getGhnOtherStatisInfo(ghnMacAddress + '|NODE.GENERAL.DOMAIN_NAME|SYSTEM.PRODUCTION.MAC_ADDR|SYSTEM.PRODUCTION.DEVICE_MANUFACTURER|SYSTEM.PRODUCTION.MANUFACTURER_OUI|PHYMNG.GENERAL.RUNNING_PHYMODE_ID|SYSTEM.PRODUCTION.SERIAL_NUMBER|SYSTEM.PRODUCTION.DEVICE_NAME|HWEXT.GENERAL.EXTRA_VERSION', 'stGhnNodeInfoTotal');
        GetPlcGhnLineStatisInfoList(plcInst);
    }
}

var selApInsIdVal = -1;

var ApSsidList5G;
var ApSsidList2G;

function getApSsidList(domain)
{
    ApSsidList5G = '';
    ApSsidList2G = '';

    var domainIdArray = domain.split('.');
    var domainId = domainIdArray[domainIdArray.length - 1];
    for (var i = 0; i < apSsid.length - 1; i++) {
        var pathApWlcArray = apSsid[i].domain.split('.');
        var pathApId = pathApWlcArray[pathApWlcArray.length - 3];

        if (domainId == pathApId) {
            if ("5G" == apSsid[i].RFBand) {
                if ('' == ApSsidList5G) {
                    ApSsidList5G = htmlencode(apSsid[i].SSID);
                } else {
                    ApSsidList5G += ',' + htmlencode(apSsid[i].SSID);
                }
            }

            if ("2.4G" == apSsid[i].RFBand) {
                if ('' == ApSsidList2G) {
                    ApSsidList2G = htmlencode(apSsid[i].SSID);
                } else {
                    ApSsidList2G += ',' + htmlencode(apSsid[i].SSID);
                }
            }
        }
    }
}

function removeTrColor()
{

    var allTr = $(".tabal_02");
    for (var i = 0; i < allTr.length; i++) {
        allTr[i].style.backgroundColor = '';
        allTr[i].style.color = "";
    }
}

var selApId;
var selRFBand;
var LastApId = 0;
function selectAp(id)
{
    var NewId = id;
    selRFBand = NewId.split("_")[1];
    selApId = NewId.split("_")[2];

    if (0 != LastApId) {
        $('#' + LastApId).css("border", "none");
    }

    LastApId = selApId;

    removeTrColor();
    getElementById(NewId).style.backgroundColor =  'rgb(199, 231, 254)';
    getElementById(NewId).style.color =  "black";
    $('#' + selApId).css("border","1px solid #c3c3c3");
    setControl();
}

var wificoverApId = 1;
var wificoverApRfband = '';
var wificoverTabN = 1;
var apDeviceListMap = {};
var isDisplayDevice = 0;
var staInfo = eval('[' + '<%WLAN_GetAllTopoInfoToWeb();%>' + ']');

if (0 != apDeviceList.length - 1)
{
    for (index = 0; index < apDeviceList.length - 1; index++)
    {
        var apDevice = apDeviceList[index];
        var ApInstId = getInstIdByDomain(apDevice.domain);
        apDeviceListMap[ApInstId] = apDevice;
    }
}

function setControl()
{
    var wificoverApId = 0;
    var wificoverApRfband = 0;
    var onlineFlag = 0;
    if (selApInsIdVal >= 0 && selApId != null && selRFBand != null) {
        wificoverApId = selApId;
        wificoverApRfband = selRFBand;
        onlineFlag = apDeviceListMap[selApInsIdVal].ApOnlineFlag;
    }

    if (2 == wificoverTabN) {
        window.coverinfo_content.location = "./apNeighborList.asp?" + wificoverApId + '&' + wificoverApRfband + '&' + onlineFlag;
    } else if (3 == wificoverTabN) {
        window.coverinfo_content.location = "./apssidStat.asp?" + wificoverApId + '&' + wificoverApRfband + '&' + onlineFlag;
    } else {
        window.coverinfo_content.location = "./apssidStation.asp?" + wificoverApId + '&' + wificoverApRfband + '&' + onlineFlag;
    }
}

function switchTab(TableN)
{
    for (var i = 1; i <= 3; i++) {
        if ("tab" + i == TableN) {
            document.getElementById(TableN).style.backgroundColor = "#f6f6f6";
            document.getElementById(TableN).style.color = "black";
        } else {
            document.getElementById("tab" + i).style.backgroundColor = "";
            document.getElementById("tab" + i).style.color = "";
        }
    }

    if ("tab2" == TableN) {
        wificoverTabN = 2;
    } else if ("tab3" == TableN) {
        wificoverTabN = 3;
    } else {
        wificoverTabN = 1;
    }

    setControl();
}
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var FirstOnlineApInst = 0;

function switchGhnTab(TableN)
{
    for (var i = 1; i <= 3; i++) {
        if ("ghntab" + i == TableN)  {
            document.getElementById(TableN).style.backgroundColor = "#f6f6f6";
            setDisplay('Div_ghntab' + i + '_Table_Container', 1);
        } else {
            document.getElementById("ghntab" + i).style.backgroundColor = "";
            setDisplay('Div_ghntab' + i + '_Table_Container', 0);
        }
    }
}

function HideAPDiv()
{
    setDisplay('smartwifiinfo', 0);
}

function ShowApDiv()
{
    setDisplay('smartwifiinfo', 1);
}

function OnSelectPlcAdpt()
{
    HideAPDiv();
    switchGhnTab('ghntab3');
    setDisplay('DivGhnAP', 1);
    var MacAddress = PlcAdptInfo[0].MacAddress;
    GetGhnInfo(MacAddress, 0);
    DisplayGhnEthInfo(0);
    DisplayGhnOtherInfo(0);
}

function OnSelectPlc(id)
{ 
    switchGhnTab('ghntab3');
    setDisplay('DivGhnAP', 1);
    var ap = apDeviceListMap[id];
    var MacAddress = ap.GhnMacAddr;

    GetGhnInfo(MacAddress, 1);
    DisplayGhnEthInfo(id);
    DisplayGhnOtherInfo(id);
}

function autoHeight()
{
    var iframeHeight = window.coverinfo_content.document.body.offsetHeight + 10;
    var adjustHeight = iframeHeight > 100 ? iframeHeight : 100;
    $('#coverinfo_content').css("height",adjustHeight +"px");
}

function ConversionUwToDbm(power) {
    return (10 * Math.log10(power / 10000)).toFixed(2);
}

function DisplayAccessDevice()
{
    if (isDisplayDevice == 0) {
		isDisplayDevice = 1;
    } else {
		isDisplayDevice = 0;
    }

    if (isDisplayDevice == 0) {
		document.getElementById("apply").innerHTML = cfg_wificoverinfo_language['amp_wlancover_wifi_hidedevice'];
    } else {
		document.getElementById("apply").innerHTML = cfg_wificoverinfo_language['amp_wlancover_wifi_displaydevice'];
    }
    $("#ApLevelStruct").empty();
    var ApLevelinit = "";
    var rthtml = "";

    ApLevelinit += '<div class="firstOntStruct"  id="firstOntStruct" style="margin-left: 20px;">'
                + '<div class="firstOntIcon" id="firstOntIcon"></div>'
                + '<div class="firstMountDevType" id="firstMountDevInfo"></div>'
                + '<div class="firstConnectLine" id="ConnectLineShow" style = "display:none;"></div>'
                + '</div>';
    ApLevelinit +='<div class="secondOntStruct" id="secondOntStructId">'
                + '<div class="secondStructLine" id="secondStructLine" style="width:2px; background-color:#d3d3d3; float:left; margin-top: 35px;"></div>'
                + '<div id="secondOntStruct" style="float:left;"></div>'
                + '</div>';
    ApLevelinit +='<div style="float:left;">'
                + '<div id="secondOntStructTHIRD" style="float:left"></div>'
                + '</div>';
    $("#ApLevelStruct").append(ApLevelinit);
    showMainPage();
}
function GetMacByNum(mac) {
    return mac[0] + mac[1] + ":" + mac[2] + mac[3] + ":" + mac[4] + mac[5] + ":" + mac[6] + mac[7] + ":" + mac[8] + mac[9] + ":" + mac[10] + mac[11];
}
var SecondLastDiv ='';

function LoadFrame()
{
    LoadResource();

    var startDeviceNum = "";
    startDeviceNum	+='<tr id="startNumNull" class="tabal_02">';
 
    startDeviceNum	+= '<td class=\"align_center\">--</td>'
                    + '<td class=\"align_center\">--</td>'
                    + '<td class=\"align_center\">--</td>'
                    + '<td class=\"align_center\">--</td>'
                    + '<td class=\"align_center\">--</td>'
                    + '<td class=\"align_center\">--</td>'
                    + '<td class=\"align_center\">--</td>'
                    + '</tr>';
    $("#ap_wlan_table_table").append(startDeviceNum);						
    setControl();

    fixIETableScroll("wlancoverAPInfo_Table_Container", "ap_wlan_table_table");
    switchTab('tab1');
    switchGhnTab('ghntab3');


    if(CfgMode.toUpperCase() == "TURKCELL2") {
        setDisplay("apply", 1);
    }

    var setHeightTime= setInterval("ControlHeight();",500);
}
var onLineApNum = 0;
var offLineApNum = 0;
var offLineApList = new Array();

</script>

</head>
<body class="mainbody" onLoad="LoadFrame();" scrolling ="auto">

<script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo("amp_wificover_status_desc", 
    GetDescFormArrayById(cfg_wificoverinfo_language, "amp_wificover_status_desc_head"), 
    GetDescFormArrayById(cfg_wificoverinfo_language, "amp_wificover_status_desc"), false);
</script>

<div id='DivWifiCoverMain' style='display:none;'>
    <div id='divApContralScrool' class="ApContralScrool" style="width:100%; min-height:300px; background-color: #f6f6f6; overflow: auto; direction:ltr">
		<button id="apply" name="back" type="button" class="ApplyButtoncss oprateDeviceButton"  style="font-size:16px;display: none;width:auto;" onClick="DisplayAccessDevice();" enable=true  >
			<script>
				if (isDisplayDevice == 0) {
					document.write(cfg_wificoverinfo_language['amp_wlancover_wifi_hidedevice']);
				} else {
					document.write(cfg_wificoverinfo_language['amp_wlancover_wifi_displaydevice']);
				}
			</script></button>
		<div class="ApLevelStruct" id="ApLevelStruct">
			<div class="firstOntStruct"  id="firstOntStruct" style="margin-left: 20px;">
				<div class="firstOntIcon" id="firstOntIcon"></div>
				<div class="firstMountDevType" id="firstMountDevInfo"></div>
				<div class="firstConnectLine" id="ConnectLineShow" style = 'display:none;'></div>
                <div id="apNumDiv" style="margin-top:80px;font-size:16px;display:none;">
                    <script>document.write(cfg_wificoverinfo_language['amp_wlancover_bpon_ap_num1']);</script>
                    <span id="onLineApNum" style="font-weight: bold;"></span>
                    <script>document.write(cfg_wificoverinfo_language['amp_wlancover_bpon_ap_num2']);</script>
                    <span id="offLineApNum" style="font-weight: bold;"></span> 
                </div>
			</div>
			
			<div class="secondOntStruct" id="secondOntStructId">
				<div class="secondStructLine" id="secondStructLine" style="width:2px; background-color:#d3d3d3; float:left; margin-top: 35px;"></div>
				<div id="secondOntStruct" style="float:left;"></div>
			</div>		
			
			<div style="float:left;">
				<div id="secondOntStructTHIRD" style="float:left"></div>
			</div>	
		</div>
    </div>
    <script type="text/javascript">	
    var SecondLastDiv ='';
    var SecondLastDivIndex = 0;
    var thirdLastDivIndex = 0;
    var fourthLastDivIndex = 0;
    var LastIndexDiv = '';
    function ControlHeight(){
        var TranverseLineHeight = $('#secondOntStructId').height() - 100 + 2;
        var ApContralHei = $('#secondOntStructId').height();
        if (SecondLastDiv != '' && LastIndexDiv != '') {
            var secondTop = $('#'+ SecondLastDiv).offset().top;
            var nextTop = $('#'+ LastIndexDiv).offset().top;
            if (secondTop < nextTop) {
                TranverseLineHeight = TranverseLineHeight - (nextTop - secondTop);
            }
        }
        $('#secondStructLine').css("height",TranverseLineHeight+"px");
        $('.ApContralScrool').css("height",ApContralHei+"px");
        if (0 == $('#secondStructLine').height()) {
            $('#secondStructLine').css("width","0px");
        } else {
            $('#secondStructLine').css("width","2px");
        }
	}
    </script>

    <div class="WifiStatusShow" id="WifiStatusShow" ></div>
    <div class="title_spread"></div>
    <div id="smartwifiinfo">
        <div id="wlancoverAPInfo">
			<div class="func_spread"></div>
			<div class="func_title">
				<SCRIPT>document.write(cfg_wificoverinfo_language["amp_wificover_onlineap_head"]);</SCRIPT>
			</div>
			<div id="wlancoverAPInfo_Table_Container" style="overflow:auto;overflow-y:hidden">
				<table id="ap_wlan_table_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
					<tr  class="head_title" id="ApInerNum"> 
						<script>
						</script>
						<td BindText='amp_wificover_onlineap_type'></td>
						<td BindText='amp_wificover_onlineap_sn'></td>;
						<td BindText='amp_wificover_onlineap_hwver'></td>
						<td BindText='amp_wificover_onlineap_swver'></td>
						<td BindText='amp_wificover_onlineap_onlinetime'></td>
						<td BindText='amp_wificover_onlineap_rfband'></td>
						<td BindText='amp_wificover_onlineap_ssidlist'></td>
					</tr>
				</table>
			</div>
			<div class="func_spread"></div>
        </div>
        <div id = 'DivOnlineExternalAP'>
			<div class="func_title">
				<SCRIPT>document.write(cfg_wificoverinfo_language["amp_wificover_onlineap_headchannel"]);</SCRIPT>
			</div>
			<table id="tableinfo" width="100%" height="100%"  class="tabal_bg">
				<tr class="head_title">
					<td width="20%" id="tab1" onclick="switchTab('tab1');" style="background-color:#f6f6f6"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ap_device_title']);</script></td>
					<td width="20%" id="tab2" onclick="switchTab('tab2');"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ap_neigh_title']);</script></td>
					<td width="20%" id="tab3" onclick="switchTab('tab3');"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ap_stats_title']);</script></td>
				</tr>
			</table>

			<iframe id="coverinfo_content" name="coverinfo_content" style="min-height:200px;" width="100%" scrolling="auto" frameborder="0" onload="autoHeight();">
			</iframe>
		</div>
	</div>

	<div id = 'DivGhnAP' style='display:none;'>
        <div class="func_title">
			<SCRIPT>document.write(cfg_wificoverinfo_language['amp_wificover_ghn_info']);</SCRIPT>
		</div>
		<div id = 'DivGhnTab'>
			<table id="ghntableinfo" width="100%" height="100%"  class="tabal_bg">
				<tr class="head_title">
					<td width="20%" id="ghntab3" onclick="switchGhnTab('ghntab3');"style="background-color:#f6f6f6"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ghn_deviceinfo']);</script></td>
					<td width="20%" id="ghntab1" onclick="switchGhnTab('ghntab1');" ><script>document.write(cfg_wificoverinfo_language['amp_wificover_ghn_ethinfo']);</script></td>
					<td width="20%" id="ghntab2" onclick="switchGhnTab('ghntab2');" style="top:0px;"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ghn_lineinfo']);</script></td>
				</tr>
			</table>
        </div>
		
        <div id="Div_ghntab3_Table_Container" style="overflow:auto;overflow-y:hidden;display:none">
			<table id="ghn_other_statistic_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style = "table-layout:fixed">
				<tr class="head_title"> 
                    <td class="width_per10"><script>document.write(cfg_wificoverinfo_language['amp_wificover_onlineap_type'])</script></td>
                    <td class="width_per20"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ghn_domain_name_head'])</script></td>
                    <td class="width_per10"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ap_sta_mac'])</script></td>
                    <td class="width_per10"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ghn_factary'])</script></td>
                    <td class="width_per10"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ghn_factaryoui'])</script></td>
                    <td class="width_per10"><script>document.write(cfg_wificoverinfo_language['amp_wificover_onlineap_sn'])</script></td>
                    <td class="width_per10"><script>document.write(cfg_wificoverinfo_language['amp_wificover_ghn_mimo'])</script></td>
                    <td class="width_per10" style="word-wrap:break-word;"><script>document.write(cfg_wificoverinfo_language['amp_wificover_onlineap_hwver'])</script></td>
                    <td class="width_per10" style="word-wrap:break-word;"><script>document.write(cfg_wificoverinfo_language['amp_wificover_onlineap_swver'])</script></td>
				</tr>
				<script language="JavaScript" type="text/JavaScript"> 
				        document.write('<tr id="record_' + LineId  + '" class="tabal_02">');
						document.write('<td id= "tdGhnOtherDviceName" style="word-wrap:break-word;" class=\"align_center\">--</td>');
						document.write('<td id ="tdGhnOtherDomainName" style="word-wrap:break-word;" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnOtherMAC" style="word-wrap:break-word;" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnOtherVendor" style="word-wrap:break-word;" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnOtherVendorOUI" style="word-wrap:break-word;" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnOtherSN" style="word-wrap:break-word;" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnOtherMiniBoost" style="word-wrap:break-word;" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnOtherHardware" style="word-wrap:break-word;" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnOtherSoftware" style="word-wrap:break-word;" class=\"align_center\">--</td>');
						document.write("</tr>");
				</script>
			</table>
        </div>
        <div id="Div_ghntab1_Table_Container" style="overflow:auto;overflow-y:hidden;display:block">
			<table id="ghn_eth_statistic_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
				<tr class="head_title"> 
					<td class="width_per20" rowspan="2" BindText='amp_wificover_ghn_ethid'></td>
					<td class="width_per10" rowspan="2" BindText='amp_wificover_ghn_eth_workmode'></td>
					<td class="width_per10" rowspan="2" BindText='amp_wificover_ghn_eth_speed'></td>
					<td colspan="2" BindText='amp_wificover_ap_stats_rx'></td>
					<td colspan="2" BindText='amp_wificover_ap_stats_tx'></td>
				</tr>
				<tr class="head_title">
					<td BindText='amp_wificover_ap_stats_byte'></td>
					<td BindText='amp_wificover_ap_stats_pkg'></td>
					<td BindText='amp_wificover_ap_stats_byte'></td>
					<td BindText='amp_wificover_ap_stats_pkg'></td>
				</tr>
				<script language="JavaScript" type="text/JavaScript"> 
				if ((0 == PlcAdptNum) && (0 == PlcNum)) {
                    document.write('<tr id="record_' + LineId  + '" class="tabal_02">');
					document.write('<td  class=\"align_center\">'+ '--' +'</td>');
					document.write('<td  class=\"align_center\">'+ '--' +'</td>');
					document.write('<td  class=\"align_center\">'+ '--' +'</td>');
					document.write('<td class=\"align_center\">'+ '--' +'</td>');
					document.write('<td  class=\"align_center\">'+ '--' +'</td>');
					document.write('<td  class=\"align_center\">'+ '--' +'</td>');
					document.write('<td  class=\"align_center\">'+ '--' +'</td>');
					document.write("</tr>");
				}
				if( PlcAdptNum > 0) {
					document.write('<tr id="record_' + LineId  + '" class="tabal_02">');
					document.write('<td id= "tdPlcNum" class=\"align_center\">--</td>');
					document.write('<td id= "tdGhnEthDuplexMode" class=\"align_center\">-- </td>');
					document.write('<td id= "tdGhnEthSpeed" class=\"align_center\">--</td>');
					document.write('<td id= "tdGhnEthRxBytes" class=\"align_center\">--</td>');
					document.write('<td id= "tdGhnEthRxPackets" class=\"align_center\">--</td>');
					document.write('<td id= "tdGhnEthTxBytes" class=\"align_center\">--</td>');
					document.write('<td id= "tdGhnEthTxPackets" class=\"align_center\">--</td>');
					document.write("</tr>");
				}
				</script>
				</table>
			</div>

			<div id="Div_ghntab2_Table_Container" style="overflow:auto;overflow-y:hidden;display:none">
			<table id="ghn_line_statistic_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
				<tr class="head_title"> 
				<td class="width_per20" rowspan="2" BindText='amp_wificover_ghn_mac'></td>
				<td class="width_per10" rowspan="2" BindText='amp_wificover_ap_sta_rate_rx'></td>
				<td class="width_per10" rowspan="2" BindText='amp_wificover_ap_sta_rate_tx'></td>
				<td colspan="4" BindText='amp_wificover_ap_stats_rx'></td>
				<td colspan="4" BindText='amp_wificover_ap_stats_tx'></td>
			  </tr>
			  <tr class="head_title"> 
				<td BindText='amp_wificover_ap_stats_byte'></td>
				<td BindText='amp_wificover_ap_stats_pkg'></td>
				<td BindText='amp_wificover_ap_stats_errpkg'></td>
				<td BindText='amp_wificover_ap_stats_droppkg'></td>
				<td BindText='amp_wificover_ap_stats_byte'></td>
				<td BindText='amp_wificover_ap_stats_pkg'></td>
				<td BindText='amp_wificover_ap_stats_errpkg'></td>
				<td BindText='amp_wificover_ap_stats_droppkg'></td>
			  </tr>
				<script language="JavaScript" type="text/JavaScript"> 
			 
						document.write('<tr id="record_' + LineId  + '" class="tabal_02">');
						document.write('<td id ="tdGhnLineMAC" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnLineRxRate" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnLineTxRate" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnLineRxBytes" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnLineRxPackets" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnLineRxErrPackets" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnLineRxDropPackets" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnLineTxBytes" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnLineTxPackets" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnLineTxErrPackets" class=\"align_center\">--</td>');
						document.write('<td id= "tdGhnLineTxDropPackets" class=\"align_center\">--</td>');
						
						document.write("</tr>");
					
			  </script>
			</table>
			</div>
        </div>
        <script type="text/javascript">
        var SecondLevelDevArray = null;
        var SecondLevelStaArray = null;
        var SecondLevelApArray = null;
        var ThridLevelApArray = null;
        var FirstMenuStr = "";
        var MenuList = [];
        var MenuJsonData = "";		

        var ethMsg = "";
        var	FirstDevTypeStr = "";
        var	FirstAccessTypeStr = "";
        var	FirstMacStr = "";	

        $.ajax({
            type : "POST",
            async : true,
            cache : false,
            url : "./getTopoInfo.asp",
            success : function(data) {
                MenuJsonData = eval(data);
            setTimeout('showMainPage()', 500);
            }
        });

        function showMainPage()
        {
            setDisplay('DivWifiCoverMain', 1);
            if (isDisplayDevice == 0) {
                AppendFirstDevInfoFunc(MenuJsonData);
            } else if(isDisplayDevice == 1) {
                AppendFirstDevInfoAPStaFunc(staInfo);
            }
        }

        var UserDevices = new Array();

        function stMenuData(APInst, DevType, Level, AccessType, MAC, DuplexMode, SpeedInfo, TX, RX, IP) {
            this.APInst       = APInst;
            this.DevType      = DevType;
            this.Level        = Level;
            this.AccessType   = AccessType;
            this.MAC          = MAC;
            this.DuplexMode   = DuplexMode;
            this.SpeedInfo    = SpeedInfo;
            this.TX           = TX;
            this.RX           = RX;
            this.IP           = IP;
        }

        function GetApInstByDomain(domain) {
            return domain.split(".")[2];
        }

        function GetBssidByDomain(domain, band) {
            for (var index = 0; index < apDeviceConfigList.length - 1; index++) {
                if (GetApInstByDomain(domain) == GetApInstByDomain(apDeviceConfigList[index].domain)) {
                    if (apDeviceConfigList[index].RFBand == band) {
                        return apDeviceConfigList[index].BSSID;
                    }
                }
            }
            return "";
        }

        function GetSpecNameByMac(mac) {
            for (var index = 0; index < g_AllUserDevinfo.length - 1; index++) {
                if (g_AllUserDevinfo[index].MACAddress.toUpperCase() == mac.toUpperCase()) {
                    if (g_AllUserDevinfo[index].Name != "") {
                        return "(" + g_AllUserDevinfo[index].Name + ")";
                    }
                }
            }
            return "";
        }

        function displayMsg(APInst){
            var topuMsgId = "topuMsg_" + APInst;
            var topuMsgDisplay = $('#topuMsg_' +APInst);
            var ethTableHead  = '';
            $.ajax({
                type : "POST",
                async : false,
                cache : false,
                url : "./getEthInfo.asp",
                data :"APInst="+APInst,
                success : function(data) {
                    ethMsg = eval(data);
                }
            });	

            if (undefined == ethMsg) {
                return;
            }

            topuMsgDisplay.stop();
            $('.topuMsg').css('display','none');
            topuMsgDisplay.css('display','block');
            $("#" +topuMsgId).empty();

            var ethMsgLen = ethMsg.length;
            var ponInfo = '';
            if (ethMsg[ethMsgLen - 1].TxPower != undefined) {
                ponInfo = ethMsg[ethMsgLen - 1];
                ethMsgLen--;
                ethTableHead = '<tr><th colspan="5" class=\"align_left\">Ethernet Port Information</th></tr>';
                $('.topuMsg').css('background-repeat', 'no-repeat');
                $('.topuMsg').css('background-size', '100% 105%');
                $('.topuMsg').css('height', 'auto');
            }

            ethTableHead += '<tr>'
                         + '<th class=\"align_center portInfo\">No</th>'
                         + '<th class=\"align_center portInfo\">EthType</th>'
                         + '<th class=\"align_center portInfo\">Enable</th>'
                         + '<th class=\"align_center portInfo\">Status</th>'
                         + '<th class=\"align_center portInfo\">Speed</th>'
                         + '<th class=\"align_center portInfo\">Duplex</th>'
                         + '</tr>';
            $("#" +topuMsgId).append(ethTableHead);

            for (var i = 0; i < ethMsgLen; i++) {
                var ethFirstStruct = ethMsg[i];
                var ethStrAdd = "";
                ethStrAdd += '<tr class="ethDisMsg">'
                          + '<td class=\"align_center\">'+ ethFirstStruct.No +'</td>'
                          + '<td class=\"align_center\">'+ ethFirstStruct.EthType +'</td>'
                          + '<td class=\"align_center\">'+ ethFirstStruct.Enable +'</td>'
                          + '<td class=\"align_center\">'+ ethFirstStruct.Status +'</td>'
                          + '<td class=\"align_center\">'+ ethFirstStruct.Speed +'</td>'
                          + '<td class=\"align_center\">'+ ethFirstStruct.Duplex +'</td>'
                          + '</tr>';

                $("#" + topuMsgId).append(ethStrAdd);
            }

            if (ponInfo != '') {
                $('.portInfo').css('padding-top', '0px');
                var ponInfoAdd = '<tr><th class=\"align_left\" style="padding-top:0px;" colspan="5">Optic Information</th></tr>';

                ponInfoAdd += '<tr>'
                           + '<th class=\"align_center\" style="padding-top:0px;" colspan="2">Status</th>'
                           + '<th class=\"align_center\" style="padding-top:0px;" colspan="2">TxPower</th>'
                           + '<th class=\"align_center\" style="padding-top:0px;" colspan="2">RxPower</th>'
                           + '</tr>';
                ponInfoAdd += '<tr class="ethDisMsg">'
                           + '<td class=\"align_center\" colspan="2"> '+ 'auto' +'</td>'
                           + '<td class=\"align_center\" colspan="2">'+ ConversionUwToDbm(ponInfo.TxPower) +'</td>'
                           + '<td class=\"align_center\" colspan="2">'+ ConversionUwToDbm(ponInfo.RxPower) +'</td>'
                           + '</tr>';

                $("#" +topuMsgId).append(ponInfoAdd);
            }
        }

        function hideMsg(APInst){
            var topuMsgId = "topuMsg_" + APInst;			
            var topuMsgDisplay = $('#topuMsg_' +APInst);
            topuMsgDisplay.stop();
            $('.topuMsg').css('display','none');
            topuMsgDisplay.css('display','none');	
        }



        function changeDetialDev(ApInsIdVal)
        { 
            ShowApDiv();
            setDisplay('DivGhnAP', 0);

            selApInsIdVal = ApInsIdVal;
            for (var control = 1; control <4; control++) {
                $('#' +control).css('border','none');
            }

            if (0 != apDeviceList.length - 1) {
                var apDevice = apDeviceListMap[ApInsIdVal];		
                var apInstNum = "";					
                if (apDevice.ApOnlineFlag == 0) {
                    return;
                }

                getApSsidList(apDevice.domain);

                if (-1 != apDevice.SupportedRFBand.search('2.4G')) {
                    setDisplay("startNumNull",0);
                    $(".tableClass").remove();
                    apInstNum +='<tr id="record_2.4G_' + ApInsIdVal  + '" class="tabal_02 tableClass" onclick="selectAp(this.id);">';
                    apInstNum += '<td class=\"align_center\">'+apDevice.type +'</td>';

                    apInstNum += '<td class=\"align_center\">'+apDevice.sn +'</td>';

                    apInstNum += '<td class=\"align_center\">'+apDevice.hwversion +'</td>'
                              + '<td class=\"align_center\">'+apDevice.swversion  +'</td>'
                              + '<td class=\"align_center\">'+apDevice.uptime +'</td>'
                              + '<td class=\"align_center\">'+ '2.4G' +'</td>'
                              + '<td class=\"align_center\">'+ApSsidList2G  +'</td>'
                              + '</tr>';
                }

                if (-1 != apDevice.SupportedRFBand.search('5G')) {
                    setDisplay("startNumNull",0);
                    $(".tableClass").remove();
                    apInstNum +='<tr id="record_5G_' + ApInsIdVal  + '" class="tabal_02 tableClass" onclick="selectAp(this.id);">';
                    apInstNum += '<td class=\"align_center\">'+apDevice.type +'</td>';
                    apInstNum += '<td class=\"align_center\">'+apDevice.sn +'</td>';

                    apInstNum +='<td class=\"align_center\">'+apDevice.hwversion +'</td>'
                              + '<td class=\"align_center\">'+apDevice.swversion  +'</td>'
                              + '<td class=\"align_center\">'+apDevice.uptime +'</td>'
                              + '<td class=\"align_center\">'+ '5G' +'</td>'
                              + '<td class=\"align_center\">'+ApSsidList5G  +'</td>'
                              + '</tr>';
                }
                $("#ap_wlan_table_table").append(apInstNum);		
            }

            if ('PLC' ==  apDevice.UplinkType || 'Cable' == apDevice.UplinkType) {
                OnSelectPlc(ApInsIdVal);
            }
        }

        function judgeAcessType(AccessType) {
            var AccessMode;
            if (AccessType == 1) {
                AccessMode = "Wi-Fi";
            } else if ((AccessType == 2) || (AccessType == 5)) {
                AccessMode = "Ethernet";
            } else if ((AccessType == 3) || (AccessType == 0)) {
                AccessMode = "G.hn";
            } else if (AccessType == 4) {
                AccessMode = "PON";
            } else {
                AccessMode = AccessType;
            }
            return AccessMode;
        }

        function ChangeAccessType(AccessType) {
            if (AccessType == "ethernet") {
                return "LAN";
            }
            return "Wi-Fi " + AccessType;
        }

        function ChangeAPAccessType(AccessType) {
            if (AccessType == "ethernet") {
                return "Ethernet"
            }
            return "Wi-Fi";
        }

        function IsSpeedShowWithTxRx(accessMode) {
            if ((accessMode == "Wi-Fi") || (accessMode == "G.hn") || (accessMode == "PON")) {
                return true;
            }

            return false;
        }

        function IsSpeedShowWithRSSI(accessMode) {
            if (accessMode.indexOf("Wi-Fi") != -1) {
                return true;
            }
            return false;
        }

        var apinst = 0;
        function AppendFourthDevInfoAPFunc(ParentId, DevDateArray) {
            for (var FourthIndex in DevDateArray) {
                apinst++;
                fourthLastDivIndex++;
                var APInst = apinst;
                var DevType = DevDateArray[FourthIndex].device_name;
                var AccessType = DevDateArray[FourthIndex].link;
                AccessType = ChangeAPAccessType(AccessType);
                var IP = DevDateArray[SecondIndex].ip_addr.toUpperCase();
                var ThirdChildId="";
                var FourthIndexID = "fourth_" + fourthLastDivIndex;
                var secondChildLen="";
                var fourthSpeedInfoStr="";
				var TX = DevDateArray[SecondIndex].TxRate;
                var RX = DevDateArray[SecondIndex].RxRate;

                var MAC = GetMacByNum(DevDateArray[FourthIndex].mac_address.toUpperCase());
				var SpeedInfo = DevDateArray[SecondIndex].TxRate;
                LastIndexDiv = 'fourthLastDiv_' + fourthLastDivIndex;
                fourthSpeedInfoStr += '<div class="sssDDDDs4 ssss_'+apinst +'" id = fourthLastDiv_'+ fourthLastDivIndex + '>';
                fourthSpeedInfoStr += '<div class="firstConnectLine"  style="float:left;"></div>'
                                   + '<div class="secondAccessType_' + apinst + '" style="float:left; text-align: center; margin-top: 23px; width:75px; padding: 0px 6px;">'
                                   + '<div id="AccessType_' + DevDateArray[FourthIndex].link + '">'+ AccessType +'</div>'
                                   if (IsSpeedShowWithTxRx(AccessType)) {
									    fourthSpeedInfoStr += '<div>TX:'+ TX +'Mbps</div>'
                                                           + '<div>RX:'+ RX +'Mbps</div>'
                                   } else {
									    fourthSpeedInfoStr += '<div>'+ SpeedInfo +'Mbps</div>'
                                   }
                fourthSpeedInfoStr += '</div>'
                                   + '<div class="firstConnectLine" id="connectLine" style="float:left;"></div>'
                                   + '<div  style="float:left; cursor: pointer; width: 60px;height: 60px; padding: 5px 5px;">'
                                   + '<div class="AccessTypeLine" id="apfoutType_'+ MAC +'" style="float:left; cursor: pointer; width: 60px;height: 60px;background-position: center center;background-size: 60px 60px;background-repeat: no-repeat;"></div>'
                                   + '<table class="topuMsg tabal_02" border="0" cellpadding="0" cellspacing="0" id="topuMsg_'+MAC+'"></table>'
                                   + '</div>'
                                   + '<div class="secondDevType_Info" style="float:left;margin-top: 23px; width:145px; padding: 0px 5px;">'
                                   + '<div id="thirdDevType_' + DevType + '">'+ DevType +'</div>'
                                   + '<div id="thirdDevType_' + MAC + '">'+ "MAC : "+ MAC +'</div>'
                                   + '<div id="id=thirdJump_' + IP + '"><a href="http://'+ IP + '" title="Login" target="_blank" style="color: #57B7F3">Click to Login</a></div>' + '</div>';
                fourthSpeedInfoStr += '</div>';

                $("#" +ParentId).append(fourthSpeedInfoStr);
            }
        }

        function AppendFourthDevInfoStaFunc(ParentId, DevDateArray) {
            for (var FourthIndex in DevDateArray) {
                staInst++;
                fourthLastDivIndex++;
                var DevType = DevDateArray[FourthIndex].device_name;
                var AccessType = DevDateArray[FourthIndex].link;
                AccessType = ChangeAccessType(AccessType);
                var AccessMode = ChangeAccessType(AccessType);
                var ThirdChildId="";
                var FourthIndexID = "fourth_" + fourthLastDivIndex;
                var secondChildLen="";
                var fourthSpeedInfoStr="";
                var TX = DevDateArray[FourthIndex].TxRate;
                var RX = DevDateArray[FourthIndex].RxRate;
                var Rssi = DevDateArray[FourthIndex].Rssi;
                var SpeedInfo = DevDateArray[FourthIndex].TxRate;

                var MAC = GetMacByNum(DevDateArray[FourthIndex].station_mac.toUpperCase());
                LastIndexDiv = 'fourthLastDiv_' + fourthLastDivIndex;
                fourthSpeedInfoStr += '<div class="sssDDDDs4 ssss_'+staInst +'" id = fourthLastDiv_'+ fourthLastDivIndex + '>';
                fourthSpeedInfoStr += '<div class="firstConnectLine"  style="float:left;"></div>'
                                   + '<div class="secondAccessType_' + staInst + '" style="float:left; text-align: center; margin-top: 23px; width:75px; padding: 0px 6px;">'
                                   + '<div id="AccessType_' + DevDateArray[FourthIndex].link + '">'+ AccessType +'</div>'
                                   if (IsSpeedShowWithRSSI(AccessMode)) {
                                       fourthSpeedInfoStr += '<div>TX:'+ TX +'Mbps</div>'
                                                          + '<div>RX:'+ RX +'Mbps</div>'
                                                          + '<div>RSSI:'+ Rssi +'dBm</div>'
                                   } else {
                                        fourthSpeedInfoStr += '<div>TX:'+ SpeedInfo +'Mbps</div>'
                                   }

                fourthSpeedInfoStr += '</div>'
                                   + '<div class="firstConnectLine" id="connectLine" style="float:left;"></div>'
                                   + '<div  style="float:left; cursor: pointer; width: 60px;height: 60px; padding: 5px 5px;">'
                                   + '<div class="AccessTypeLine_0" id="stafoutType_'+ MAC +'"style="float:left; cursor: pointer; width: 60px;height: 60px;background-position: center center;background-size: 60px 60px;background-repeat: no-repeat;"></div>'
                                   + '<table class="topuMsg tabal_02" border="0" cellpadding="0" cellspacing="0" id="topuMsg_'+MAC+'"></table>'
                                   + '</div>'

                                   + '<div class="secondDevType_Info" style="float:left;margin-top: 23px; width:145px; padding: 0px 5px;">'
                                   if (DevType != "") {
                                        fourthSpeedInfoStr += '<div id="thirdDevType_' + DevType + '">Name : '+ DevType +'</div>'
                                   } 

                fourthSpeedInfoStr += '<div id="thirdDevType_' + MAC + '">'+ "MAC : "+ MAC +'</div>'
                fourthSpeedInfoStr += '</div>';

                $("#" +ParentId).append(fourthSpeedInfoStr);
            }
        }

        function AppendThirdDevInfoFunc(ParentId, DevDateArray)
        {
            for(var ThirdIndex in DevDateArray) {
                var APInst = DevDateArray[ThirdIndex].APInst;
                var DevType = DevDateArray[ThirdIndex].DevType;
                var Level = DevDateArray[ThirdIndex].Level;
                var TX = DevDateArray[ThirdIndex].TX;
                var RX = DevDateArray[ThirdIndex].RX;
                var AccessType = DevDateArray[ThirdIndex].AccessType;
                var DuplexMode = DevDateArray[ThirdIndex].DuplexMode;
                var AccessMode = "";
                var ThirdChildId="";
                var ThirdIndexID = "Third_" + ThirdIndex;
                var thirdControlHei = "Third_" + ThirdIndex + "_Child";
                var thirdCtrMar = "Third_" + ThirdIndex + "_Mar";
                var i = 0;
                var thirdContentHeiLine = "Third_" + ThirdIndex + "_Line_" + i;
                i++;
                var parentHei = "Third_" + ThirdIndex;
                var secondChildLen="";
                var thirdSpeedInfoStr="";
                AccessMode = judgeAcessType(AccessType);

                if (AccessMode == "G.hn") {
                    var apDevice = apDeviceListMap[APInst];
                    if (undefined != apDevice) {
                        var PlcIndex = PlcInfoIndexMap[apDevice.GhnMacAddr];
                        if (undefined != PlcIndex) {
                            TX = PlcInfo[PlcIndex].TxRate;
                            RX = PlcInfo[PlcIndex].RxRate;
                        }
                    }
                }

                var MAC = DevDateArray[ThirdIndex].MAC.toUpperCase();
                var IP = DevDateArray[ThirdIndex].IP.toUpperCase();
                var SpeedInfo = DevDateArray[ThirdIndex].SpeedInfo;
                if (ThirdIndex == DevDateArray.length - 1) {
                    LastIndexDiv = 'thirdLastDiv_' + thirdLastDivIndex;
                    thirdSpeedInfoStr += '<div class="sssDDDDs ssss_'+DevType +'" id = thirdLastDiv_' + thirdLastDivIndex + '>';
                    thirdLastDivIndex++;
                } else {
                    thirdSpeedInfoStr += '<div class="sssDDDDs ssss_'+DevType+'">';
                }
                thirdSpeedInfoStr += '<div class="firstConnectLine"  style="float:left;"></div>'
                                  + '<div class="secondAccessType_' + DevType + '" style="float:left; text-align: center; margin-top: 23px; width:75px; padding: 0px 6px;">'
                                  + '<div id="AccessType_' + AccessType + '">'+ AccessMode +'</div>'			
                                  if (IsSpeedShowWithTxRx(AccessMode)) {									   
                                        thirdSpeedInfoStr += '<div>TX:'+ TX +'Mbps</div>'
                                                          + '<div>RX:'+ RX +'Mbps</div>'
                                   } else {
                                        thirdSpeedInfoStr += '<div id="thirdSpeedInfo_' + SpeedInfo + '">'+ SpeedInfo +'Mbps</div>'					   
                                   }
                thirdSpeedInfoStr += '</div>'
                                  + '<div class="firstConnectLine" id="connectLine" style="float:left;"></div>'
                                  + '<div  style="float:left; cursor: pointer; width: 60px;height: 60px; padding: 5px 5px;">'
                                   + '<div class="AccessTypeLine_' + AccessType + '" id="'+ APInst +'" onmouseout = "hideMsg(this.id)" onmouseover = "displayMsg(this.id)" onclick ="changeDetialDev(this.id)" style="float:left; cursor: pointer; width: 60px;height: 60px;background-position: center center;background-size: 60px 60px;background-repeat: no-repeat;"></div>'
                                   + '<table class="topuMsg tabal_02" border="0" cellpadding="0" cellspacing="0" id="topuMsg_'+APInst+'"></table>'
                                   + '</div>'
                                   + '<div class="secondDevType_Info" style="float:left;margin-top: 14px; width:145px; padding: 0px 5px;">';
                thirdSpeedInfoStr += '<div id="thirdDevType_' + DevType + '">'+ DevType;
                thirdSpeedInfoStr += '</div>'
                                  + '<div id="thirdDevType_' + MAC + '">'+ "MAC:"+ MAC +'</div>';
                thirdSpeedInfoStr += '<div id="id=thirdJump_' + IP + '"><a href="http://'+ IP + '" title="Login" target="_blank" style="color: #57B7F3">Click to Login</a></div>' + '</div>';
                                  if(undefined != DevDateArray[ThirdIndex].sub) {	
                                        ThirdChildId = ThirdIndexID + "_Child";
                                        thirdSpeedInfoStr +='<div class="firstConnectLine" id="thirdConnectLine"></div>'
                                                          + '<div style="float:left;left:388px; top:0px;" class="divPosition">'							
                                                          + '<div class="secondStructLine StructLineClass" id="'+ thirdContentHeiLine +'" style="width:2px; background-color:#d3d3d3; float: left; margin-top: 35px;"></div>'
                                                          + '<div class="getSecondLineHei" id="' + ThirdChildId + '" style="float:left; position: absolute;min-width: 370px;"></div>'
                                                          + '</div>'
                                  }
                thirdSpeedInfoStr +='</div>';	

                $("#" +ParentId).append(thirdSpeedInfoStr);	
                if (DevType == 'STA' && AccessType != 'G.hn') {
                    $(".ssss_" +DevType).css('display','none');
                }
                if (IsSpeedShowWithTxRx(AccessMode)) {		
                    $(".secondAccessType_" +DevType).css("margin-top","15px");
                }
                if ((undefined != DevDateArray[ThirdIndex].sub) ) {
                    if ((undefined != DevDateArray[ThirdIndex].sub)) {
                        ThirdLevelDevArray = DevDateArray[ThirdIndex].sub;
                        AppendFourthDevInfoFunc(ThirdChildId, ThirdLevelDevArray, ThirdLevelApArray);
                    }
                }
                var ControlHei = $('#' + thirdControlHei).height()-100;
                var thirdCtrMarHei = $('#' + thirdControlHei).height();

                $('#'+thirdContentHeiLine).css("height",ControlHei + "px");
                $('#' + thirdControlHei).parents('.sssDDDDs').css("height",thirdCtrMarHei + "px");
                if (ThirdIndex == DevDateArray.length - 1) {
                    if (thirdLastDivIndex != 0 && fourthLastDivIndex != 0) {
                        var thisTop = $('#thirdLastDiv_' + (thirdLastDivIndex-1)).offset().top;
                        var nextTop = $('#fourthLastDiv_' + (fourthLastDivIndex-1)).offset().top;
                        if (thisTop < nextTop) {
                            return nextTop - thisTop;
                        }
                    }
                }
            }
            return 0;
        }

        function AppendThirdDevInfoAPFunc(ParentId, DevDateArray) {
            for (var ThirdIndex in DevDateArray) {
                apinst++;
                thirdLastDivIndex++;
                var APInst = apinst;
                var DevType = DevDateArray[ThirdIndex].device_name;
                var AccessType = DevDateArray[ThirdIndex].link;
                AccessType = ChangeAPAccessType(AccessType);
                var ThirdChildId="";
                var ThirdIndexID = "Third_" + thirdLastDivIndex;
                var thirdControlHei = "Third_" + thirdLastDivIndex + "_Child";
                var thirdCtrMar = "Third_" + thirdLastDivIndex + "_Mar";
                var i = 0;
                var thirdContentHeiLine = "Third_" + thirdLastDivIndex + "_Line_" + i;
                i++;
                var secondChildLen="";
                var thirdSpeedInfoStr="";
                var MAC = GetMacByNum(DevDateArray[ThirdIndex].mac_address.toUpperCase());
				var TX = DevDateArray[ThirdIndex].TxRate;
                var RX = DevDateArray[ThirdIndex].RxRate;
				var SpeedInfo = DevDateArray[ThirdIndex].TxRate;

                LastIndexDiv = 'thirdLastDiv_' + thirdLastDivIndex;
                thirdSpeedInfoStr += '<div class="sssDDDDs ssss_'+DevType +'" id = thirdLastDiv_' + thirdLastDivIndex + '>';
                thirdSpeedInfoStr += '<div class="firstConnectLine"  style="float:left;"></div>'
                                  + '<div class="secondAccessType_' + DevType + '" style="float:left; text-align: center; margin-top: 23px; width:75px; padding: 0px 6px;">'
                                  + '<div id="AccessType_' + DevDateArray[ThirdIndex].link + '">'+ AccessType +'</div>'
                                   if (IsSpeedShowWithTxRx(AccessType)) {
                                       thirdSpeedInfoStr += '<div>TX:'+ TX +'Mbps</div>'
                                                         + '<div>RX:'+ RX +'Mbps</div>'
                                   } else {
                                       thirdSpeedInfoStr += '<div>'+ SpeedInfo +'Mbps</div>'
                                   }
                thirdSpeedInfoStr += '</div>'
                                  + '<div class="firstConnectLine" id="connectLine" style="float:left;"></div>'
                                  + '<div  style="float:left; cursor: pointer; width: 60px;height: 60px; padding: 5px 5px;">'
                                  + '<div class="AccessTypeLine" id="apthirdType_'+ MAC +'" style="float:left; cursor: pointer; width: 60px;height: 60px;background-position: center center;background-size: 60px 60px;background-repeat: no-repeat;"></div>'
                                  + '<table class="topuMsg tabal_02" border="0" cellpadding="0" cellspacing="0" id="topuMsg_'+MAC+'"></table>'
                                  + '</div>'
                                  + '<div class="secondDevType_Info" style="float:left;margin-top: 23px; width:145px; padding: 0px 5px;">'
                                  + '<div id="thirdDevType_' + DevType + '">Name : '+ DevType +'</div>'
                                  + '<div id="thirdDevType_' + MAC + '">'+ "MAC : "+ MAC +'</div>';
                thirdSpeedInfoStr += '</div>';

                if ((DevDateArray[ThirdIndex].child_devices.length != 0) || (DevDateArray[ThirdIndex].station_info.length != 0)) {
                    ThirdChildId = ThirdIndexID + "_Child";
                    thirdSpeedInfoStr +='<div class="firstConnectLine" id="thirdConnectLine"></div>'
                                      + '<div style="float:left;left:388px; top:0px;" class="divPosition">'
                                      + '<div class="secondStructLine StructLineClass" id="'+ thirdContentHeiLine +'" style="width:2px; background-color:#d3d3d3; float: left; margin-top: 35px;"></div>'
                                      + '<div class="getSecondLineHei" id="' + ThirdChildId + '" style="float:left; position: absolute;min-width: 370px;"></div>'
                                      + '</div>'
                }
                thirdSpeedInfoStr +='</div>';

                $("#" +ParentId).append(thirdSpeedInfoStr);

                if ((DevDateArray[ThirdIndex].child_devices.length != 0) || (DevDateArray[ThirdIndex].station_info.length != 0)) {
                    if (DevDateArray[ThirdIndex].child_devices.length != 0) {
                        ThirdLevelDevArray = DevDateArray[ThirdIndex].child_devices;
                        AppendFourthDevInfoAPFunc(ThirdChildId, ThirdLevelDevArray);
                    }

                    if (DevDateArray[ThirdIndex].station_info.length != 0) {
                        ThirdLevelDevArray = DevDateArray[ThirdIndex].station_info;
                        AppendFourthDevInfoStaFunc(ThirdChildId, ThirdLevelDevArray);
                    }
                }
                var ControlHei = $('#' + thirdControlHei).height()-100;
                var thirdCtrMarHei = $('#' + thirdControlHei).height();

                $('#'+thirdContentHeiLine).css("height",ControlHei + "px");
                $('#' + thirdControlHei).parents('.sssDDDDs').css("height",thirdCtrMarHei + "px");
                if (ThirdIndex == DevDateArray.length - 1) {
                    if (thirdLastDivIndex != 0 && fourthLastDivIndex != 0) {
                        var thisTop = $('#thirdLastDiv_' + (thirdLastDivIndex)).offset().top;
                        var nextTop = $('#fourthLastDiv_' + (fourthLastDivIndex)).offset().top;
                        if (thisTop < nextTop) {
                            return nextTop - thisTop;
                        }
                    }
                }
            }
            return 0;
        }

        function AppendThirdDevInfoStaFunc(ParentId, DevDateArray) {
            for (var ThirdIndex in DevDateArray) {
                staInst++;
                thirdLastDivIndex++;
                var DevType = DevDateArray[ThirdIndex].device_name;
                var AccessType = DevDateArray[ThirdIndex].link;
                AccessType = ChangeAccessType(AccessType);
                var AccessMode = ChangeAccessType(AccessType);
                var i = 0;
                i++;
                var thirdSpeedInfoStr="";
                var MAC = GetMacByNum(DevDateArray[ThirdIndex].station_mac.toUpperCase());
                var TX = DevDateArray[ThirdIndex].TxRate;
                var RX = DevDateArray[ThirdIndex].RxRate;
                var Rssi = DevDateArray[ThirdIndex].Rssi;
                var SpeedInfo = DevDateArray[ThirdIndex].TxRate;

                LastIndexDiv = 'thirdLastDiv_' + thirdLastDivIndex;
                thirdSpeedInfoStr += '<div class="sssDDDDs ssss_'+DevType +'" id = thirdLastDiv_' + thirdLastDivIndex + '>';
                thirdSpeedInfoStr += '<div class="firstConnectLine"  style="float:left;"></div>'
                                  + '<div class="secondAccessType_' + DevType + '" style="float:left; text-align: center; margin-top: 23px; width:75px; padding: 0px 6px;">'
                                  + '<div id="AccessType_' + DevDateArray[ThirdIndex].link + '">'+ AccessType +'</div>'
                                  if (IsSpeedShowWithRSSI(AccessMode)) {
                                       thirdSpeedInfoStr += '<div>TX:'+ TX +'Mbps</div>'
                                                          + '<div>RX:'+ RX +'Mbps</div>'
                                                          + '<div>RSSI:'+ Rssi +'dBm</div>'
                                   } else {
                                        thirdSpeedInfoStr += '<div>TX:'+ SpeedInfo +'Mbps</div>'
                                   }

                thirdSpeedInfoStr += '</div>'
                                  + '<div class="firstConnectLine" id="connectLine" style="float:left;"></div>'
                                  + '<div  style="float:left; cursor: pointer; width: 60px;height: 60px; padding: 5px 5px;">'
                                  + '<div class="AccessTypeLine_0" id="stathirdType_'+ MAC +'" style="float:left; cursor: pointer; width: 60px;height: 60px;background-position: center center;background-size: 60px 60px;background-repeat: no-repeat;"></div>'
                                  + '<table class="topuMsg tabal_02" border="0" cellpadding="0" cellspacing="0" id="topuMsg_'+MAC+'"></table>'
                                  + '</div>'
                                  + '<div class="secondDevType_Info" style="float:left;margin-top: 23px; width:145px; padding: 0px 5px;">'
                                  if (DevType != "") {
                                       thirdSpeedInfoStr += '<div id="thirdDevType_' + DevType + '">Name : '+ DevType +'</div>'
                                    } 
                thirdSpeedInfoStr += '<div id="thirdDevType_' + MAC + '">'+ "MAC : "+ MAC +'</div>';
                thirdSpeedInfoStr += '</div>';
                thirdSpeedInfoStr +='</div>';

                $("#" +ParentId).append(thirdSpeedInfoStr);

                if (ThirdIndex == DevDateArray.length - 1) {
                    if (thirdLastDivIndex != 0 && fourthLastDivIndex != 0) {
                        var thisTop = $('#thirdLastDiv_' + (thirdLastDivIndex)).offset().top;
                        var nextTop = $('#fourthLastDiv_' + (fourthLastDivIndex)).offset().top;
                        if (thisTop < nextTop) {
                            return nextTop - thisTop;
                        }
                    }
                }
            }
            return 0;
        }
 
		function AppendFourthDevInfoFunc(ParentId, DevDateArray)
		{
			for(var FourthIndex in DevDateArray) {
				var APInst = DevDateArray[FourthIndex].APInst;
				var DevType = DevDateArray[FourthIndex].DevType;
				var Level = DevDateArray[FourthIndex].Level;
				var TX = DevDateArray[FourthIndex].TX;
				var RX = DevDateArray[FourthIndex].RX;
				var AccessType = DevDateArray[FourthIndex].AccessType;
				var DuplexMode = DevDateArray[FourthIndex].DuplexMode;
				var AccessMode = "";
				var ThirdChildId="";
				var FourthIndexID = "fourth_" + FourthIndex;
				var secondChildLen="";
				var fourthSpeedInfoStr="";
				AccessMode = judgeAcessType(AccessType);

				if (AccessMode == "G.hn") {
					var apDevice = apDeviceListMap[APInst];
					if (undefined != apDevice) {
						var PlcIndex = PlcInfoIndexMap[apDevice.GhnMacAddr];
						if (undefined != PlcIndex) {
							TX = PlcInfo[PlcIndex].TxRate;
							RX = PlcInfo[PlcIndex].RxRate;
						}
					}
				}

                var MAC = DevDateArray[FourthIndex].MAC.toUpperCase();
                var IP = DevDateArray[FourthIndex].IP.toUpperCase();
				var SpeedInfo = DevDateArray[FourthIndex].SpeedInfo;
				if (FourthIndex == DevDateArray.length - 1)
				{
					LastIndexDiv = 'fourthLastDiv_' + fourthLastDivIndex;
					fourthSpeedInfoStr += '<div class="sssDDDDs ssss_'+DevType +'" id = fourthLastDiv_'+ fourthLastDivIndex + '>';
					fourthLastDivIndex++;
				}
				else
				{
					fourthSpeedInfoStr += '<div class="sssDDDDs ssss_'+DevType+'">';
				}
				fourthSpeedInfoStr += '<div class="firstConnectLine"  style="float:left;"></div>'
                                   + '<div class="secondAccessType_' + DevType + '" style="float:left; text-align: center; margin-top: 23px; width:75px; padding: 0px 6px;">'
                                   + '<div id="AccessType_' + AccessType + '">'+ AccessMode +'</div>'			
                                   if (IsSpeedShowWithTxRx(AccessMode)) {								   
										fourthSpeedInfoStr += '<div>TX:'+ TX +'Mbps</div>'
														   +  '<div>RX:'+ RX +'Mbps</div>'
								   } else {
										fourthSpeedInfoStr += '<div id="thirdSpeedInfo_' + SpeedInfo + '">'+ SpeedInfo +'Mbps</div>'
								   }	
				fourthSpeedInfoStr += '</div>'
                                   + '<div class="firstConnectLine" id="connectLine" style="float:left;"></div>'
                                   + '<div  style="float:left; cursor: pointer; width: 60px;height: 60px; padding: 5px 5px;">'
                                   + '<div class="AccessTypeLine_' + AccessType + '" id="'+ APInst +'" onmouseout = "hideMsg(this.id)" onmouseover = "displayMsg(this.id)" onclick ="changeDetialDev(this.id)" style="float:left; cursor: pointer; width: 60px;height: 60px;background-position: center center;background-size: 60px 60px;background-repeat: no-repeat;"></div>'
                                   + '<table class="topuMsg tabal_02" border="0" cellpadding="0" cellspacing="0" id="topuMsg_'+APInst+'"></table>'
                                   + '</div>'
                                   + '<div class="secondDevType_Info" style="float:left;margin-top: 14px; width:145px; padding: 0px 5px;">';
				fourthSpeedInfoStr += '<div id="thirdDevType_' + DevType + '">'+ DevType;
                fourthSpeedInfoStr += '</div>' 
                                   + '<div id="thirdDevType_' + MAC + '">'+ "MAC:"+ MAC +'</div>';
                fourthSpeedInfoStr += '<div id="id=fourthJump_' + IP + '"><a href="http://'+ IP + '" title="Login" target="_blank" style="color: #57B7F3">Click to Login</a></div>' + '</div>';

				$("#" +ParentId).append(fourthSpeedInfoStr);	
				if (DevType == 'STA' && AccessType != 'G.hn') {
					$(".ssss_" +DevType).css('display','none');
				}
				if (IsSpeedShowWithTxRx(AccessMode)) {		
					$(".secondAccessType_" +DevType).css("margin-top","15px");
				}
				if(undefined != DevDateArray[FourthIndex].sub) {			
					ThirdLevelDevArray = DevDateArray[FourthIndex].sub;
				}
			}
		}

        function AppendSecondDevInfoFunc(ParentId, DevDateArray, ApDateArray)
        {
            for(var SecondIndex in DevDateArray) {
				var DevType = DevDateArray[SecondIndex].DevType
				var TX = DevDateArray[SecondIndex].TX;
				var RX = DevDateArray[SecondIndex].RX;					
				var Level = DevDateArray[SecondIndex].Level;
				var AccessType = DevDateArray[SecondIndex].AccessType;
				var AccessMode = "";
				var SecondChildId="";
				AccessMode = judgeAcessType(AccessType);
				
				if (AccessMode == "G.hn") {
					var apDevice = apDeviceListMap[APInst];
					if (undefined != apDevice) {
						var PlcIndex = PlcInfoIndexMap[apDevice.GhnMacAddr];
						if (undefined != PlcIndex) {
							TX = PlcInfo[PlcIndex].TxRate;
							RX = PlcInfo[PlcIndex].RxRate;
						}
					}
				}
				
				var i = 0;
				
				var SecondIndexID = "Second_" + SecondIndex;
				if (SecondIndex == DevDateArray.length -1) {
					SecondLastDiv = SecondIndexID;
				}
				var secondControlHei = "Second_" + SecondIndex + "_Child";
				var secondContentHeiLine = "Second_" + SecondIndex + "_Line" + i;
				i++;
				var parentHei = "Second_" + SecondIndex;
				var MAC = DevDateArray[SecondIndex].MAC.toUpperCase();
                var IP = DevDateArray[SecondIndex].IP.toUpperCase();
				var APInst = DevDateArray[SecondIndex].APInst;
				var DuplexMode = DevDateArray[SecondIndex].DuplexMode;
				var SpeedInfo = DevDateArray[SecondIndex].SpeedInfo;
				var SecondSpeedInfoStr = "";
				var secondChildLen = "";
				SecondSpeedInfoStr += '<div class="ssss ssss_'+DevType+'" id="' + SecondIndexID + '" style="position: relative;">'
                                   + '<div class="firstConnectLine"  style="float:left;"></div>'
                                   + '<div class="secondAccessType_' + DevType + '" style="float:left; text-align: center; margin-top: 23px; width:75px; padding: 0px 6px;">'
                                   + '<div id="AccessType_' + AccessType + '">'+ AccessMode +'</div>'
                                   if (IsSpeedShowWithTxRx(AccessMode)) {										   									
										SecondSpeedInfoStr += '<div>TX:'+ TX +'Mbps</div>'
														   +  '<div>RX:'+ RX +'Mbps</div>'
								   } else {
										SecondSpeedInfoStr += '<div id="thirdSpeedInfo_' + SpeedInfo + '">'+ SpeedInfo +'Mbps</div>'
								   }	
			    SecondSpeedInfoStr += '</div>'
                                   + '<div class="firstConnectLine" id="connectLine" style="float:left;"></div>'
                                   + '<div  style="float:left; cursor: pointer; width: 60px;height: 60px; padding: 5px 5px;">'
                                   + '<div class="AccessTypeLine_' + AccessType + '" id="'+ APInst +'" onmouseout = "hideMsg(this.id)" onmouseover = "displayMsg(this.id)" onclick ="changeDetialDev(this.id)" style="float:left; cursor: pointer; width: 60px;height: 60px;background-position: center center;background-size: 60px 60px;background-repeat: no-repeat;"></div>'
                                   + '<table class="topuMsg tabal_02" border="0" cellpadding="0" cellspacing="0" id="topuMsg_'+APInst+'"></table>'
                                   + '</div>'
                                   + '<div class="secondDevType_Info" style="float:left;margin-top: 14px; width:145px;">';
				SecondSpeedInfoStr += '<div id="secondDevType_' + DevType + '">'+ DevType;
                SecondSpeedInfoStr += '</div>'
                                   + '<div id="secondDevType_' + MAC + '">'+ "MAC:"+ MAC +'</div>';
                
                SecondSpeedInfoStr += '<div id="id=secondJump_' + IP + '"><a href="http://'+ IP + '" title="Login" target="_blank" style="color: #57B7F3">Click to Login</a></div>' + '</div>';
				if(undefined != DevDateArray[SecondIndex].sub) {
					SecondChildId = SecondIndexID + "_Child";
					SecondSpeedInfoStr +='<div class="firstConnectLine" id="thirdConnectLine"></div>'
									   + '<div style="float:left; left:388px; top:0px;" class="divPosition">'						
									   + '<div class="secondStructLine StructLineClass" id="'+secondContentHeiLine+'" style="width:2px; background-color:#d3d3d3; float: left; margin-top: 35px;"></div>'
									   + '<div class="getSecondLineHei" id="' + SecondChildId + '" style="float:left; position: absolute;min-width: 370px;"></div>'
									   + '</div>'
				}
				SecondSpeedInfoStr +='</div>';	
				$("#secondOntStruct").append(SecondSpeedInfoStr);
				if (DevType == 'STA' && AccessType != 'G.hn') {
					$(".ssss_" +DevType).css('display','none');
				}
				if (IsSpeedShowWithTxRx(AccessMode)) {		
					$(".secondAccessType_" +DevType).css("margin-top","15px");
				}
				var lineLarge = 0;
				if(undefined != DevDateArray[SecondIndex].sub)
				{
					ThirdLevelDevArray = DevDateArray[SecondIndex].sub;
					ApDateArray = ApDateArray[SecondIndex].child_devices;
					lineLarge = AppendThirdDevInfoFunc(SecondChildId, ThirdLevelDevArray);
				}
				var ControlHei = $('#' + secondControlHei).height()-100;
				var secondControlMar = $('#' + secondControlHei).height();
				ControlHei  = ControlHei - lineLarge;
				$('#' + secondContentHeiLine).css("height",ControlHei + "px");			
				$('#' + secondControlHei).parents('.ssss').css("height",secondControlMar + "px");					
				
			}
        }

        function AppendFirstDevInfoAPStaFunc(MenuJsonData) {
            for (var FirstMenuindex in MenuJsonData) {
                var DevType = (MenuJsonData[FirstMenuindex].device_name == "") ? productName : MenuJsonData[FirstMenuindex].device_name;
                var AccessType = MenuJsonData[FirstMenuindex].link;
                var MAC = GetMacByNum(MenuJsonData[FirstMenuindex].mac_address.toUpperCase());
                var FirstDevTypeStr = "";
                var FirstMacStr = "";
                FirstDevTypeStr += '<div class="FirstDevTypeStr" id="firstDevType_' + AccessType + '">'+ DevType +'</div>';
                FirstMacStr += '<div class="FirstMacStr" id="firstMAC_' + MAC + '">'+ "MAC : " + MAC +'</div>';

                $("#firstMountDevInfo").append(FirstDevTypeStr);
                $("#firstMountDevInfo").append(FirstMacStr);
                if ((MenuJsonData[FirstMenuindex].child_devices.length != 0) || (MenuJsonData[FirstMenuindex].station_info.length != 0)) {
                    var ParentId = "firstOntStruct";
                    if (MenuJsonData[FirstMenuindex].child_devices.length != 0)  {
                        SecondLevelDevArray = MenuJsonData[FirstMenuindex].child_devices;
                        AppendSecondDevInfoAPFunc(ParentId, SecondLevelDevArray);
                    }

                    if (MenuJsonData[FirstMenuindex].station_info.length != 0)  {
                        SecondLevelDevArray = MenuJsonData[FirstMenuindex].station_info;
                        AppendSecondDevInfoStaFunc(ParentId, SecondLevelDevArray);
                    }
                    setDisplay('ConnectLineShow', 1);
                } else {
                $("#ConnectLineShow").css('display','none');
                }
                break;
            }
        }

        function AppendFirstDevInfoFunc(MenuJsonData)
        {
            for(var FirstMenuindex in MenuJsonData) {
                var APInst = MenuJsonData[FirstMenuindex].APInst;
                var DevType = MenuJsonData[FirstMenuindex].DevType;
                var Level = MenuJsonData[FirstMenuindex].Level;
                var AccessType = MenuJsonData[FirstMenuindex].AccessType;
                var MAC = MenuJsonData[FirstMenuindex].MAC.toUpperCase();
                var IP = MenuJsonData[FirstMenuindex].IP.toUpperCase();
                var DuplexMode = MenuJsonData[FirstMenuindex].DuplexMode;
                var SpeedInfo = MenuJsonData[FirstMenuindex].SpeedInfo;
                var FirstDevTypeStr = "";
                var FirstMacStr = "";
                var FirstIpStr = "";
                FirstDevTypeStr += '<div class="FirstDevTypeStr" id="firstDevType_' + AccessType + '">'+ DevType;
                FirstDevTypeStr += '</div>';
                FirstMacStr += '<div class="FirstMacStr" id="firstMAC_' + MAC + '">'+ "MAC:" + MAC +'</div>';
                FirstIpStr += '<div class="FirstIpStr" id="firstIP_' + IP + '">' + "IP:" + IP + '</div>';

                $("#firstMountDevInfo").append(FirstDevTypeStr);
                $("#firstMountDevInfo").append(FirstMacStr);

                if(DevType == 'STA' && AccessType != 'G.hn') {
                    $(".ssss_" +DevType).css('display','none');
                }
                if (undefined != MenuJsonData[FirstMenuindex].sub) {
                    var ParentId = "firstOntStruct";
                    if (undefined != MenuJsonData[FirstMenuindex].sub) {
                        SecondLevelDevArray = MenuJsonData[FirstMenuindex].sub;
                        AppendSecondDevInfoFunc(ParentId, SecondLevelDevArray);	
                    }

                    setDisplay('ConnectLineShow', 1);
                } else {
                    $("#ConnectLineShow").css('display','none');
                }
                break;
            }
        }


        var staInst = 0;
        function AppendSecondDevInfoStaFunc(ParentId, DevDateArray) {
            for(var SecondIndex in DevDateArray) {
                staInst++;
                var DevType = DevDateArray[SecondIndex].device_name;
                var AccessType = DevDateArray[SecondIndex].link;
                var AccessMode = ChangeAccessType(AccessType);
                AccessType = ChangeAccessType(AccessType);
        
                var SecondChildId="";
                var TX = DevDateArray[SecondIndex].TxRate;
                var RX = DevDateArray[SecondIndex].RxRate;
                var Rssi = DevDateArray[SecondIndex].Rssi;
				var SpeedInfo = DevDateArray[SecondIndex].TxRate;
                var i = 0;
        
                SecondLastDivIndex++;
                var SecondIndexID = "Second_" + SecondLastDivIndex;
                if (SecondIndex == DevDateArray.length -1) {
                    SecondLastDiv = SecondIndexID;
                }

                i++;
                var MAC = GetMacByNum(DevDateArray[SecondIndex].station_mac.toUpperCase());
                var SecondSpeedInfoStr = "";
                var secondChildLen = "";
                SecondSpeedInfoStr += '<div class="ssss ssss_' + staInst + '" id="' + SecondIndexID + '" style="position: relative;">'
                                   + '<div class="firstConnectLine"  style="float:left;"></div>'
                                   + '<div class="secondAccessType_' + staInst + '" style="float:left; text-align: center; margin-top: 23px; width:75px; padding: 0px 6px;">'
                                   + '<div id="AccessType_' + DevDateArray[SecondIndex].link + '">'+ AccessType +'</div>'
                                   if (IsSpeedShowWithRSSI(AccessMode)) {
                                       SecondSpeedInfoStr += '<div>TX:'+ TX +'Mbps</div>'
                                                          + '<div>RX:'+ RX +'Mbps</div>'
                                                          + '<div>RSSI:'+ Rssi +'dBm</div>'
                                   } else {
                                        SecondSpeedInfoStr += '<div>'+ SpeedInfo +'Mbps</div>'
                                   }
                SecondSpeedInfoStr += '</div>'
                                   + '<div class="firstConnectLine" id="connectLine" style="float:left;"></div>'
                                   + '<div  style="float:left; cursor: pointer; width: 60px;height: 60px; padding: 5px 5px;">'
                                   + '<div class="AccessTypeLine_0" id="stasecondType_'+ MAC +'"style="float:left; cursor: pointer; width: 60px;height: 60px;background-position: center center;background-size: 60px 60px;background-repeat: no-repeat;"></div>'
                                   + '<table class="topuMsg tabal_02" border="0" cellpadding="0" cellspacing="0" id="topuMsg_' + MAC+'"></table>'
                                   + '</div>'
                                   + '<div class="secondDevType_Info" style="float:left;margin-top: 23px; width:145px;">'
                                    if (DevType != "") {
                                        SecondSpeedInfoStr += '<div >Name : '+ DevType +'</div>'
                                    }
                SecondSpeedInfoStr += '<div id="secondDevType_' + MAC + '">'+ "MAC : "+ MAC +'</div>'
                                   + '</div>';
                SecondSpeedInfoStr +='</div>';
                $("#secondOntStruct").append(SecondSpeedInfoStr);
            }
        }

        function AppendSecondDevInfoAPFunc(ParentId, DevDateArray) {
            for(var SecondIndex in DevDateArray) {
                apinst++;
                var DevType = DevDateArray[SecondIndex].device_name;
                var AccessType = DevDateArray[SecondIndex].link;
                AccessType = ChangeAPAccessType(AccessType);
                var IP = DevDateArray[SecondIndex].ip_addr.toUpperCase();
                var SecondChildId="";
                var TX = DevDateArray[SecondIndex].TxRate;
                var RX = DevDateArray[SecondIndex].RxRate;

                var i = 0;
                SecondLastDivIndex++;
                var SecondIndexID = "Second_" + SecondLastDivIndex;
                if (SecondIndex == DevDateArray.length -1) {
                    SecondLastDiv = SecondIndexID;
                }
                var secondControlHei = "Second_" + SecondLastDivIndex + "_Child";
                var secondContentHeiLine = "Second_" + SecondLastDivIndex + "_Line" + i;
                i++;
                var MAC = GetMacByNum(DevDateArray[SecondIndex].mac_address.toUpperCase());
                var SpeedInfo = DevDateArray[SecondIndex].TxRate;

                var APInst = apinst;
                var SecondSpeedInfoStr = "";
                var secondChildLen = "";
                SecondSpeedInfoStr += '<div class="ssss ssss_'+apinst+'" id="' + SecondIndexID + '" style="position: relative;">'
                                   + '<div class="firstConnectLine"  style="float:left;"></div>'
                                   + '<div class="secondAccessType_' + DevType + '" style="float:left; text-align: center; margin-top: 23px; width:75px; padding: 0px 6px;">'
                                   + '<div id="AccessType_' + DevDateArray[SecondIndex].link + '">'+ AccessType +'</div>'
                                   if (IsSpeedShowWithTxRx(AccessType)) {
                                        SecondSpeedInfoStr += '<div>TX:'+ TX +'Mbps</div>'
                                                           +  '<div>RX:'+ RX +'Mbps</div>'
                                   } else {
                                        SecondSpeedInfoStr += '<div>'+ SpeedInfo +'Mbps</div>'
                                   }
                SecondSpeedInfoStr += '</div>'
                                   + '<div class="firstConnectLine" id="connectLine" style="float:left;"></div>'
                                   + '<div  style="float:left; cursor: pointer; width: 60px;height: 60px; padding: 5px 5px;">'
                                   + '<div class="AccessTypeLine" id="apsecondType_'+ MAC +'" style="float:left; cursor: pointer; width: 60px;height: 60px;background-position: center center;background-size: 60px 60px;background-repeat: no-repeat;"></div>'
                                   + '<table class="topuMsg tabal_02" border="0" cellpadding="0" cellspacing="0" id="topuMsg_'+MAC+'"></table>'
                                   + '</div>'
                                   + '<div class="secondDevType_Info" style="float:left;margin-top: 23px; width:145px;">'
                                   + '<div id="secondDevType_' + DevType + '">'+ DevType +'</div>'
                                   + '<div id="secondDevType_' + MAC + '">'+ "MAC : "+ MAC +'</div>'
                                   + '<div id="id=thirdJump_' + IP + '"><a href="http://'+ IP + '" title="Login" target="_blank" style="color: #57B7F3">Click to Login</a></div>' + '</div>';
                                   + '</div>';

                if ((DevDateArray[SecondIndex].child_devices.length != 0) || (DevDateArray[SecondIndex].station_info.length != 0)) {
                    SecondChildId = SecondIndexID + "_Child";
                    SecondSpeedInfoStr +='<div class="firstConnectLine" id="thirdConnectLine"></div>'
                                       + '<div style="float:left; left:388px; top:0px;" class="divPosition">'
                                       + '<div class="secondStructLine StructLineClass" id="'+secondContentHeiLine+'" style="width:2px; background-color:#d3d3d3; float: left; margin-top: 35px;"></div>'
                                       + '<div class="getSecondLineHei" id="' + SecondChildId + '" style="float:left; position: absolute;min-width: 370px;"></div>'
                                       + '</div>'
                }
                SecondSpeedInfoStr +='</div>';
                $("#secondOntStruct").append(SecondSpeedInfoStr);
                var lineLarge = 0;
                if ((DevDateArray[SecondIndex].child_devices.length != 0) || (DevDateArray[SecondIndex].station_info.length != 0)) {
                    if (DevDateArray[SecondIndex].child_devices.length != 0) {
                        ThirdLevelDevArray = DevDateArray[SecondIndex].child_devices;
                        lineLarge = AppendThirdDevInfoAPFunc(SecondChildId, ThirdLevelDevArray);
                    }
                    if (DevDateArray[SecondIndex].station_info.length != 0) {
                        ThirdLevelDevArray = DevDateArray[SecondIndex].station_info;
                        lineLarge = AppendThirdDevInfoStaFunc(SecondChildId, ThirdLevelDevArray);
                    }
                }
                var ControlHei = $('#' + secondControlHei).height()-100;
                var secondControlMar = $('#' + secondControlHei).height();
                ControlHei  = ControlHei - lineLarge;
                $('#' + secondContentHeiLine).css("height",ControlHei + "px");
                $('#' + secondControlHei).parents('.ssss').css("height",secondControlMar + "px");
            }
        }

	</script>

	<table width="100%" border="0" cellspacing="5" cellpadding="0">
	<tr ><td style = 'height:80px'></td></tr>
	</table>	
</div>
</body>
</html>
