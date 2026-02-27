<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<style>
.sntpselectdefcss{
	width:110px;
}
</style>
<script language="JavaScript" type="text/javascript">
var MainUpportConfigDetailList = new Array();
var TableClass = new stTableClass("width_per30", "width_per70", "ltr");
var CurrentIPTVUpInfo = "";
var CurrentLANPortList = new Array();
var LANPath = "InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.";
var SSIDPath = "InternetGatewayDevice.LANDevice.1.WLANConfiguration.";
var IPTVUpPortInfo = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_APService.IPTVUpPort);%>'.toUpperCase();
var LANPortInfo = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_APService.MultiSrvPortList.PhyPortName);%>'.toUpperCase();
var PortConfigInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo,X_HW_MainUpPort|X_HW_UpPortMode|X_HW_UpPortID,stConfigPort);%>;
var PortConfigInfo = PortConfigInfos[0];
var MainUpportModeArray = [];
var TopoInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Topo,X_HW_EthNum,TopoInfo);%>;
var TopoInfo = TopoInfoList[0];
var portlen = TopoInfoList[0].EthNum;
var OriUpPortMode ='<%HW_WEB_GetOriUpPortMode();%>';
var IsSupportOptic ='<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_OPTIC);%>';
var portalAPType = '<%HW_WEB_GetApMode();%>';
var curCfgModeWord ='<%HW_WEB_GetCfgMode();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var CfgFtWordArea = '<%GetConfigAreaInfo();%>';
var IsSHCTA8C = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SHCTA8C);%>';
var IsFttrEdge = '<%HW_WEB_GetFeatureSupport(FT_FTTR_EDGE_ONT);%>';
var RegNewPageFlag = "<%HW_WEB_GetFeatureSupport(FT_MULTI_SERVICE_IPTV_PORT_NEW);%>";
var RegPageFlag = "<%HW_WEB_GetFeatureSupport(FT_MULTI_SERVICE_IPTV_PORT);%>";
var fttoFlag = '<%HW_WEB_GetFeatureSupport(FT_CMCC_FTTO);%>';
var xrFlag = '<%HW_WEB_GetFeatureSupport(FT_FTTR_MAIN_XR);%>';
var isFttrApEbg = '<%HW_WEB_GetFeatureSupport(FT_FTTR_AP_EBG);%>';
var isZqUnicom = '<%HW_WEB_GetFeatureSupport(HW_FEATURE_ZQCU);%>';
var isZq = '<%HW_WEB_GetFeatureSupport(HW_FEATURE_ZQ);%>';
var isRedirect = '<%HW_WEB_GetFeatureSupport(BBSP_FT_REDIRECT);%>' == 1;
var fttrFlag = '<%HW_WEB_GetFeatureSupport(FT_FTTR_MAIN_ONT);%>';
var tr069WanOnlyRead = '<%HW_WEB_GetFeatureSupport("BBSP_FT_TR069_WAN_ONLY_READ");%>';

function stIpoeWanList(domain, Enable,ConnectionStatus, X_HW_SERVICELIST) {
    this.domain = domain;
    this.ConnectionStatus = ConnectionStatus;
    this.X_HW_SERVICELIST = X_HW_SERVICELIST;
}

function stPppoeWanList(domain, Enable,ConnectionStatus, X_HW_SERVICELIST) {
    this.domain = domain;
    this.ConnectionStatus = ConnectionStatus;
    this.X_HW_SERVICELIST = X_HW_SERVICELIST;
}

var ipoeWanList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i},Enable|ConnectionStatus|X_HW_SERVICELIST,stIpoeWanList);%>;
var pppoeWanList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i},Enable|ConnectionStatus|X_HW_SERVICELIST,stPppoeWanList);%>;
var reconfiguredBr0 = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_FeatureList.BBSPCustomization.ReconfiguredBr0);%>';

function stResultInfo(domain, Result, Status)
{
    this.domain = domain;
    this.Result = Result;
    this.Status = Status;
}
var submitUserInfo = 0;
var userInfo = '<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UserInfo, Result|Status, stResultInfo);%>';
if ((userInfo != null) && (userInfo[0] != null) && (xrFlag == '1')) {
    submitUserInfo = 1;
}

GetLANPortListInfo();
function GetLANPortListInfo() {
    var tempLANPortValue = "";
    var tempLANPortList = LANPortInfo.split(",");
    var CurLANPortList = new Array();
    for (var i = 0; i < tempLANPortList.length; i++) {		
        if (tempLANPortList[i].indexOf(LANPath.toUpperCase()) != -1) {
            tempLANPortValue = tempLANPortList[i].replace(LANPath.toUpperCase(), "LAN");
        } else {
            tempLANPortValue = tempLANPortList[i].replace(SSIDPath.toUpperCase(), "SSID");
        }

        var tempLANPortInfoList = tempLANPortValue.split(".");
        CurLANPortList[i] = tempLANPortInfoList[0];
    }
    CurrentLANPortList = CurLANPortList;
}

function stConfigPort(domain, X_HW_MainUpPort, X_HW_UpPortMode, X_HW_UpPortID) {
    this.domain = domain;
    this.X_HW_MainUpPort = X_HW_MainUpPort;
    this.X_HW_UpPortMode = X_HW_UpPortMode;
    this.X_HW_UpPortID = X_HW_UpPortID;
}

function TopoInfo(Domain, EthNum, SSIDNum) {   
    this.Domain = Domain;
    this.EthNum = EthNum;
}

if ((IsSHCTA8C == 1) || (isZqUnicom == 1) || (curCfgModeWord.toUpperCase() == "SDCCENTER")) {
    TopoInfo.EthNum = 1;
}
else {
    TopoInfo.EthNum = parseInt(TopoInfo.EthNum);
}

if(TopoInfo.EthNum != "" && TopoInfo.EthNum != undefined) {	
    if ((IsSupportOptic == 1) && (portalAPType == 0)) {
        MainUpportModeArray[0] = "Optical";
        if (curCfgModeWord.toUpperCase() == "AISAP") {
            MainUpportModeArray[1] = "LAN4";
        } else if (curCfgModeWord.toUpperCase() == "SDCCENTER") {
            MainUpportModeArray[1] = "LAN";
            MainUpportModeArray[2] = "SFP GE";
        } else if ((fttoFlag == '1') || (curCfgModeWord.toUpperCase() == "MDSTARNET")) {
            MainUpportModeArray[1] = "LAN1";
        } else {
            MainUpportModeArray[0] = GetDescFormArrayById(ConfigMainUpportDes, "sCMU007");
        for(var i = 1; i <= TopoInfo.EthNum; i++) {
            MainUpportModeArray[i] = "LAN"+i;
            }
        }
    } else {
        if (IsFttrEdge == '1') {
            MainUpportModeArray[0] = "Optical";
            if (isFttrApEbg == '1') {
                for(var i = 1; i <= TopoInfo.EthNum; i++) {
                    MainUpportModeArray[i] = "LAN" + i;
                }
            } else {
                MainUpportModeArray[1] = "LAN4";
            }
        } else if ((curCfgModeWord.toUpperCase() == "SDCREMOTEOUT") || (curCfgModeWord.toUpperCase() == "SDCREMOTEOUTIN")) {
            MainUpportModeArray[0] = "Wi-Fi";
            MainUpportModeArray[1] = "LAN";
        } else {
            for(var i = 0; i < TopoInfo.EthNum; i++) {
                MainUpportModeArray[i] = "LAN"+(i+1);
            }
        }
    }
}

if (curCfgModeWord.toUpperCase() == "T672EPCHINAEBG5") {
    MainUpportModeArray.splice(0);
    MainUpportModeArray.push("GE(SFP)");
    MainUpportModeArray.push("GPON/EPON");
}

GetIPTVPortInfo();
function GetIPTVPortInfo() {
    if (IPTVUpPortInfo.length != 0) {
        var tempIPTVUpValue = IPTVUpPortInfo.replace(LANPath.toUpperCase(), "LAN");
        var tempIPTVUpList = tempIPTVUpValue.split(".");
        CurrentIPTVUpInfo = tempIPTVUpList[0];
    }
}

function InitIPTVUpSelectValue() {
    var MainUpPort = getSelectVal('X_HW_MainUpPort');
    if(MainUpPort == GetDescFormArrayById(ConfigMainUpportDes, "sCMU007")) {
        setDisable('IPTVUpPortID',1);
        setSelect("IPTVUpPortID", "");
        return;
    } else {
        setDisable('IPTVUpPortID',0);
    }
    var isNeedAdd = 1;
    var Option = document.createElement("Option");
    Option.value = "";
    Option.innerText = "";
    Option.text = "";
    removeAllOption("IPTVUpPortID");
    getElById("IPTVUpPortID").appendChild(Option);
    for (var i = 1; i <= TopoInfo.EthNum; i++) {
        isNeedAdd = 1;
        lanoption = "LAN" + i;
        for (var j = 0; j < CurrentLANPortList.length; j++) {
            if (lanoption == CurrentLANPortList[j]) {
                isNeedAdd = 0;
                break;
            }
        }
        
        if (isNeedAdd == 1) {
            if(MainUpPort != lanoption) {
                Option = document.createElement("Option");
                Option.value = lanoption;
                Option.innerText = lanoption;
                Option.text = lanoption;
                getElById("IPTVUpPortID").appendChild(Option);
            }
        }
    }
    if (CurrentIPTVUpInfo != "") {
        setSelect("IPTVUpPortID", CurrentIPTVUpInfo);
    }
    return;
}



function LoadFrame() {
    setDisable('X_HW_MainUpPort',0);
    if ((CfgMode.toUpperCase() == "SDCCENTER") && (PortConfigInfo.X_HW_MainUpPort == "LAN2")) {
        setSelect("X_HW_MainUpPort", "LAN");
    } else if (curCfgModeWord.toUpperCase() == "T672EPCHINAEBG5") {
        if(PortConfigInfo.X_HW_UpPortMode == 4) {
            setSelect("X_HW_MainUpPort", "GPON/EPON");
        } else {
            setSelect("X_HW_MainUpPort", "GE(SFP)");
        }
    } else {
        setSelect("X_HW_MainUpPort", PortConfigInfo.X_HW_MainUpPort);
    }
    setDisplay('IPTVUpPortConfigForm', 0);
    if ((RegPageFlag != 0) && (RegNewPageFlag == 1) && (xrFlag != 1)) {
        setDisplay('IPTVUpPortConfigForm', 1);
        InitIPTVUpSelectValue();
    }

    if (CfgMode.toUpperCase() == "SDCCENTER") {
        if (PortConfigInfo.X_HW_UpPortMode == 1) {
            setSelect("X_HW_MainUpPort", "Optical");
        } else if (PortConfigInfo.X_HW_UpPortMode == 3) {
            if (PortConfigInfo.X_HW_UpPortID == 1056769) {
                setSelect("X_HW_MainUpPort", "SFP GE");
            } else if (PortConfigInfo.X_HW_UpPortID == 2) {
                setSelect("X_HW_MainUpPort", "LAN");
            }
        }
    }

    if (CfgMode.toUpperCase() == "SDCREMOTEOUT") {
        if (PortConfigInfo.X_HW_UpPortMode == 8) {
            setSelect("X_HW_MainUpPort", "Wi-Fi");
        } else {
            setSelect("X_HW_MainUpPort", "LAN");
        }
    }

    if (CfgFtWordArea.toUpperCase() == 'CHOOSE') {
        setDisable('X_HW_MainUpPort', 1);
    }
}
								
function CreateMainUpportSelect(list, selectarray) {
    var select = document.getElementById(list);
    for (var i in selectarray) {	
        var isNeedAdd = 1;
        for (var j = 0; j < CurrentLANPortList.length; j++) {
            if (selectarray[i].toUpperCase() == CurrentLANPortList[j].toUpperCase()) {
                isNeedAdd = 0;
                break;
            }
        }
        if(isNeedAdd == 0) {
            continue;
        }
        var opt = document.createElement('option');
        var optShow = selectarray[i];
        var html = document.createTextNode(optShow);
        opt.value = selectarray[i];
        opt.appendChild(html);
        select.appendChild(opt);
    }
}

function updateUPSelect() {
    if ((CfgFtWordArea.toUpperCase() == 'CHOOSE') && (CfgMode.toUpperCase() != 'CMCC_RMSBRIDGE')) {
        alert('设备注册前，请选择省份！');
        LoadFrame();
        return;
    }

    if ((RegPageFlag != 0) && (RegNewPageFlag == 1)) {
        InitIPTVUpSelectValue();
    }
}

function SetPara(subDataInfo, paramUrl)
{
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        data : subDataInfo,
        url : paramUrl + '&RequestFile=html/ssmp/mainupportcfg/mainupportconfig.asp',
        success : function(data) {
 
        }
    });
}

function CommonSubmitForm() {
    if (CfgMode.toUpperCase() == "AHCT") {
        setDisplay('btnApply', 0);
        setDisplay('btnCancle', 0);
        setDisplay('MainUpportConfig', 0);
        setDisplay('UpportConfig', 0);
        setDisplay('resetinfo', 1);
    } else {
        setDisable('btnApply', 1);
        setDisable('btnCancle', 1);
    }
    var subDataInfo = "";
    var MainUpPort = getSelectVal('X_HW_MainUpPort');
    if (MainUpPort == "Optical") {
        if ((CfgMode.toUpperCase() == "SHCT") && (isZq == 1)) {
            subDataInfo += "&z.Status=99";
            subDataInfo += "&z.Result=99";
        }
        if (CfgMode.toUpperCase() == 'PTVDF2WIFI_FTTR') {
            OriUpPortMode = '1';
        }
        subDataInfo += "x.X_HW_UpPortMode=" + OriUpPortMode;
        subDataInfo += "&x.X_HW_UpPortID=0x102001";
        if (submitUserInfo == 1) {
            subDataInfo += "&z.Status=99";
            subDataInfo += "&z.Result=99";
            if(isRedirect) {
                subDataInfo += "&c.HttpUnreachableRedirectEnable=1";
            }
        }
    } else if (MainUpPort == "Wi-Fi") {
        subDataInfo += "x.X_HW_UpPortMode=8";
        subDataInfo += "&x.X_HW_UpPortID=0x00304008";
    } else if ((MainUpPort == "SFP GE") || (MainUpPort == "GE(SFP)")) {
        subDataInfo += "x.X_HW_UpPortMode=3";
        subDataInfo += "&x.X_HW_UpPortID=0x102001";
        MainUpPort = "Optical";
    } else if (MainUpPort == "GPON/EPON") {
        subDataInfo += "x.X_HW_UpPortMode=4";
        subDataInfo += "&x.X_HW_UpPortID=0x102001";
        MainUpPort ="Optical";
    } else {
        if ((CfgMode.toUpperCase() == "SHCT") && (isZq == 1)) {
            subDataInfo += "&z.Status=0";
            subDataInfo += "&z.Result=1";
        }
        subDataInfo += "x.X_HW_UpPortMode=3";
        if ((CfgMode.toUpperCase() == "SDCCENTER") || (CfgMode.toUpperCase() == "SDCREMOTEOUT") || (CfgMode.toUpperCase() == "SDCREMOTEOUTIN")) {
            MainUpPort = "LAN2";
        }
        if ((CfgMode.toUpperCase() == "SDCREMOTEOUT") || (CfgMode.toUpperCase() == "SDCREMOTEOUTIN")) {
            subDataInfo += "&x.X_HW_UpPortID=2";
        }
        if (submitUserInfo == 1) {
            subDataInfo += "&z.Status=0";
            subDataInfo += "&z.Result=1";
            if(isRedirect) {
                subDataInfo += "&c.HttpUnreachableRedirectEnable=0";
            }
        }
    }

    if (MainUpPort != "Wi-Fi") {
        subDataInfo += "&x.X_HW_MainUpPort=" + MainUpPort;
    }
    subDataInfo += "&x.X_HW_Token=" + getValue('onttoken');
    var paramUrl = 'set.cgi?';
    if (submitUserInfo == 1) {
        paramUrl += '&z=InternetGatewayDevice.X_HW_UserInfo';
        if(isRedirect) {
            paramUrl += '&c=InternetGatewayDevice.LANDevice.1.X_HW_LanService';
        }
    }
    if ((CfgMode.toUpperCase() == "SHCT") && (isZq == 1)) {
        paramUrl += '&z=InternetGatewayDevice.X_HW_UserInfo';
    }

    paramUrl += '&x=InternetGatewayDevice.DeviceInfo';
    if ((fttrFlag == '1') && (CfgMode.toUpperCase() != 'PTVDF2WIFI_FTTR')) {
        SetPara(subDataInfo, paramUrl);
        SetGatewayBr0AndRest();
    } else {
        if ((CfgMode.toUpperCase() != "SDCREMOTEOUT") && (CfgMode.toUpperCase() != "SDCREMOTEOUTIN")) {
            paramUrl += '&y=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard';
        }
        SetPara(subDataInfo, paramUrl);
    }
}

function ScschoolConfigForm()
{
    setDisable('btnApply', 1);
    setDisable('btnCancle', 1);
    var RequestFile = '&RequestFile=/html/ssmp/mainupportcfg/mainupportconfig.asp';
    var MainUpPort = getSelectVal('X_HW_MainUpPort');
    var parainfo = ""; 
    if(MainUpPort == "Optical") {
        parainfo = "x.X_HW_UpPortMode=" + OriUpPortMode;
        parainfo += "&x.X_HW_UpPortID=" + 0x102001;
    } else {
        parainfo = "x.X_HW_UpPortMode=" + 3;
    }

    parainfo += "&x.X_HW_MainUpPort=" + MainUpPort;
    parainfo += '&x.X_HW_Token=' + getValue('hwonttoken');
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        data : parainfo,
        url : 'set.cgi?x=InternetGatewayDevice.DeviceInfo' + RequestFile,
        success : function(data) {
        }
    });

    $.ajax({
     type : "POST",
     async : true,
     cache : false,
     data : 'UpModeType=' + MainUpPort + "&x.X_HW_Token=" + getValue('onttoken'),
     url : "ponlanswitch.cgi?" + RequestFile,
     success : function(data) {
     },
     complete: function (XHR, TS) {
        XHR=null;
     }
    });
}

function DelAllWanInfo()
{
    var DelData = "";
    var ipoeWanFlag = 0;
    for (var i = 0; ipoeWanList.length > 0 && i < ipoeWanList.length -1; i++) {
        if ((ipoeWanList[i].X_HW_SERVICELIST.indexOf("TR069") != -1) && (tr069WanOnlyRead == '1')) {
            continue;
        }
        if (i > 0) {
            DelData += "&";
        }
        DelData += ipoeWanList[i].domain + "=";
        ipoeWanFlag = 1;
    }

    for (var j = 0; pppoeWanList.length > 0 && j < pppoeWanList.length - 1; j++) {
        if ((pppoeWanList[j].X_HW_SERVICELIST.indexOf("TR069") != -1) && (tr069WanOnlyRead == '1')) {
            continue;
        }
        if ((ipoeWanFlag == 1) || (j > 0)) {
            DelData += "&";
        }
        DelData += pppoeWanList[j].domain + "=";
    }

    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        data : DelData + "&x.X_HW_Token=" + getValue('onttoken'),
        url: 'del.cgi?RequestFile=html/ssmp/mainupportcfg/mainupportconfig.asp',
        success: function() {}
    });
}

var ConfigUrl = "";
var ParameterList = "";
function AddInternteWANdata()
{
    var add_wanpath = "InternetGatewayDevice.WANDevice.1.WANConnectionDevice";
    var add_wanpath2 = add_wanpath + '.{i}.WANIPConnection';
    ConfigUrl += 'Add_x='+ add_wanpath + '&Addconnect_z=' + add_wanpath2;

    ParameterList += "Addconnect_z.Enable=1&Addconnect_z.X_HW_IPv4Enable=1&Addconnect_z.X_HW_IPv6MultiCastVLAN=-1&Addconnect_z.X_HW_SERVICELIST=INTERNET" + 
    "&Addconnect_z.X_HW_ExServiceList=&Addconnect_z.X_HW_VLAN=0&Addconnect_z.X_HW_PRI=0&Addconnect_z.X_HW_PriPolicy=Specified&Addconnect_z.X_HW_DefaultPri=0&Addconnect_z.ConnectionType=IP_Routed" + 
    "&Addconnect_z.X_HW_MultiCastVLAN=4294967295&Addconnect_z.NATEnabled=1&Addconnect_z.X_HW_NatType=0&Addconnect_z.DNSEnabled=1&Addconnect_z.MaxMTUSize=1500&Addconnect_z.AddressingType=DHCP" + 
    "&Addconnect_z.X_HW_VenderClassID=&Addconnect_z.X_HW_BindPhyPortInfo=";

    ConfigUrl += "&Addconnect_m=" + add_wanpath2 + ".1.X_HW_IPv6.IPv6Address&Addconnect_n=" + add_wanpath2 + ".1.X_HW_IPv6.IPv6Prefix";
    ParameterList += "&Addconnect_z.X_HW_IPv6Enable=1&Addconnect_m.Alias=&Addconnect_m.Origin=AutoConfigured&Addconnect_m.IPAddress=&Addconnect_m.ChildPrefixBits=&Addconnect_m.AddrMaskLen=64&Addconnect_m.DefaultGateway=&Addconnect_n.Alias=&Addconnect_n.Origin=PrefixDelegation&Addconnect_n.Prefix=";

    HwAjaxConfigPara(ConfigUrl, ParameterList, false);
}

function HwAjaxConfigPara(ObjPath, ParameterList, isAsync)
{
    $.ajax({
        type : "POST",
        async : isAsync,
        cache : false,
        url : 'complex.cgi?' + ObjPath + "&RequestFile=html/ssmp/mainupportcfg/mainupportconfig.asp",
        data: ParameterList + '&x.X_HW_Token='+ getValue('onttoken'),
        success : function(data) {
        }
    });
}

function InitGateway()
{
    $.ajax({
        type : "POST",
        async : true,
        cache : false,
        data : "x.X_HW_Token=" + getValue('onttoken'),
        url : 'set.cgi?y=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard'
              + '&RequestFile=html/ssmp/mainupportcfg/mainupportconfig.asp',
        success : function(data) {
    }});
}

function SetGatewayBr0AndRest()
{
    if (reconfiguredBr0 == "") {
        InitGateway();
        return;
    }
    var submitParaInfo = "";
    var gatewayBr0Info = reconfiguredBr0.split(",");
    if (gatewayBr0Info.length == 4) {
        submitParaInfo = "a.IPInterfaceIPAddress=" + gatewayBr0Info[0];
        submitParaInfo += "&a.IPInterfaceSubnetMask=" + gatewayBr0Info[1];
        submitParaInfo += "&b.MinAddress=" + gatewayBr0Info[2];
        submitParaInfo += "&b.MaxAddress=" + gatewayBr0Info[3];
        submitParaInfo += "&b.SubnetMask=" + gatewayBr0Info[1];

        $.ajax({
            type : "POST",
            async : true,
            cache : false,
            data : submitParaInfo + "&x.X_HW_Token=" + getValue('onttoken'),
            url : 'set.cgi?'
                + 'a=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1'
                + '&b=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement'
                + '&y=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard'
                + '&RequestFile=html/ssmp/mainupportcfg/mainupportconfig.asp',
            success : function(data) {
        }});
    }
}

function RestoreDefaultCfgAll()
{
    var Form = new webSubmitForm();
    Form.setAction('restoredefaultcfgall.cgi?' + 'RequestFile=html/ssmp/reset/reset.asp');
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function SubmitUpportConfigForm()
{
    if (getSelectVal('X_HW_MainUpPort') == PortConfigInfo.X_HW_MainUpPort) {
        return;
    }

    var configTips = GetDescFormArrayById(ConfigMainUpportDes, "sCMU003");
	if (((fttrFlag == '1') && (CfgMode.toUpperCase() != 'PTVDF2WIFI_FTTR')) && (getSelectVal('X_HW_MainUpPort') == "Optical")) {
       configTips = GetDescFormArrayById(ConfigMainUpportDes, "sCMU101");
    }

	if (((fttrFlag == '1') && (CfgMode.toUpperCase() != 'PTVDF2WIFI_FTTR')) && (getSelectVal('X_HW_MainUpPort') != "Optical")) {
       configTips = GetDescFormArrayById(ConfigMainUpportDes, "sCMU100") + reconfiguredBr0.split(",")[0];
    }

    if (ConfirmEx(configTips)) {
        if (((fttrFlag == '1') && (CfgMode.toUpperCase() != 'PTVDF2WIFI_FTTR')) && (getSelectVal('X_HW_MainUpPort') == "Optical")) {
            RestoreDefaultCfgAll();
            return;
        }
        if (CfgMode.toUpperCase() != "SDCREMOTEOUT") {
            $.ajax({
                    type : "POST",
                    async : true,
                    cache : false,
                    url : '/SynchOriUpPortMode.cgi?'+ '&RequestFile=html/ssmp/mainupportcfg/mainupportconfig.asp',
                    data :'x.X_HW_Token=' + getValue('hwonttoken'),
                    success : function(data) {
                    }
                });

            var tempIPTVUPValue = getSelectVal("IPTVUpPortID").replace("LAN", LANPath);
            $.ajax({
                    type : "POST",
                    async : false,
                    cache : false,
                    data : "y.IPTVUpPort=" + tempIPTVUPValue + "&x.X_HW_Token="+getValue('onttoken'),
                    url : "setajax.cgi?y=InternetGatewayDevice.X_HW_APService&RequestFile=html/ssmp/mainupportcfg/mainupportconfig.asp",
                    success : function(data) {
                    }
                });
        }
        if (((fttrFlag == '1') && (CfgMode.toUpperCase() != 'PTVDF2WIFI_FTTR')) && (getSelectVal('X_HW_MainUpPort') !="Optical")) {
            if ((CfgMode.toUpperCase() != "SCCT") && (CfgMode.toUpperCase() != "SCSCHOOL") && (CfgMode.toUpperCase() != "SCCT_FTTO")) {
                DelAllWanInfo();
            }

            AddInternteWANdata();
        }

        if ((CfgMode.toUpperCase() == "SCSCHOOL") || (CfgMode.toUpperCase() == "MDSTARNET")) {
            ScschoolConfigForm();
        } else {
            CommonSubmitForm();
        }
    } else {
        LoadFrame();
    }
}

function CancelUpportConfig() {
    LoadFrame();
    return;
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
    <script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo("UpportConfig", GetDescFormArrayById(ConfigMainUpportDes, "sCMU001"), GetDescFormArrayById(ConfigMainUpportDes, "sCMU000"), false);
    </script>
    <div class="title_spread"></div>
    <div id="resetinfo" style="display:none">设备正在重启，请稍等…</div>
    <div id="MainUpportConfig">
    <form id="MainUpportConfigDetail">
    <table id="MainUpportConfigDetailTable"  cellpadding="0" cellspacing="0" width="100%">
    <li id="X_HW_MainUpPort" RealType="DropDownList" DescRef="sCMU002" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.X_HW_MainUpPort" InitValue="Empty" Elementclass="sntpselectdefcss" ClickFuncApp="onChange=updateUPSelect"/>
    </table>
    <script>
        MainUpportConfigDetailList = HWGetLiIdListByForm("MainUpportConfigDetail", null);
        HWParsePageControlByID("MainUpportConfigDetail", TableClass, ConfigMainUpportDes, null);
        CreateMainUpportSelect("X_HW_MainUpPort", MainUpportModeArray);
    </script>
    </form>
    </div>
    <form id="IPTVUpPortConfigForm">
    <table id="MainIPTVUpportConfigDetailTable"  cellpadding="0" cellspacing="0" width="100%">
        <li id="IPTVUpPortID" RealType="DropDownList" DescRef="sCMU008" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" Elementclass="sntpselectdefcss" InitValue="Empty"/>
    </table>
    <script>
        var UsbConfigFormList = HWGetLiIdListByForm("IPTVUpPortConfigForm", null);
        HWParsePageControlByID("IPTVUpPortConfigForm", TableClass, ConfigMainUpportDes, null);
    </script>
    </form>
    <table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
        <tr>
            <td class="table_submit width_per30"></td>
            <td class="table_submit">
                <input type="button" name="btnApply" id="btnApply" class="ApplyButtoncss buttonwidth_100px"  BindText="sCMU005" onClick="SubmitUpportConfigForm();" />
                <input type="button" name="btnCancle" id="btnCancle" class="CancleButtonCss buttonwidth_100px" BindText="sCMU006" onClick="CancelUpportConfig();" />
                <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            </td>
        </tr>
    </table>
    <script>
        ParseBindTextByTagName(ConfigMainUpportDes, "td",     1);
        ParseBindTextByTagName(ConfigMainUpportDes, "span",   1);
        ParseBindTextByTagName(ConfigMainUpportDes, "input",  2);
    </script>
</body>
</html>
