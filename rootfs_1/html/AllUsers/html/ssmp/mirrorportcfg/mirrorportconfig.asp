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

function GetLanguageDesc(Name)
{
    return ConfigMirrorPortDes[Name];
}

var EthPortNumMax = 8;
var PonPortValue = 10;

var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var TopoInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Topo,X_HW_EthNum,TopoInfo);%>;
var APAutoUPPortFlag = '<%HW_WEB_GetFeatureSupport(FT_AP_WEB_SELECT_UPPORT);%>';

var MirrorPortConfigDetailList = new Array();
var TableClass = new stTableClass("width_per30", "width_per70", "ltr");
var TopoInfo = TopoInfoList[0];
var EthPortNum = 0;
var SrcMirroPortArray1 = [];
var SrcMirroPortArray2 = [];
var DestMirrorPortArray = [];
var TypeMirrorArray = [];
var TimeMirrorArray = [];

var curEnMirror = {"X_HW_SrcMirror1":0, "X_HW_SrcMirror2":0, "X_HW_DestMirror":0, "X_HW_TypeMirror":2, "X_HW_TimeMirror":30};
var curEnMirrorExpr = 0;
var curEnMirrorTimeoutTimer = 0;
var curEnMirrorIntervalTimer = 0;
var isFuncDisable = false;

function TopoInfo(Domain, EthNum)
{
    this.Domain = Domain;
    this.EthNum = EthNum;
}

if ((TopoInfo.EthNum !== "") && (TopoInfo.EthNum !== undefined)) {
    var num = parseInt(TopoInfo.EthNum);
    if ((num > 0) && (num <= EthPortNumMax)) {
        EthPortNum = parseInt(TopoInfo.EthNum);
        if (APAutoUPPortFlag === '1') {
            EthPortNum--;
        }
    }
}

function CurMirrorInfoGet()
{
    var RequestFile = '&RequestFile=/html/ssmp/mirrorportcfg/mirrorportconfig.asp';
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        data : 'MirrorPortGet=0',
        url : "getmirrorport.cgi?" + RequestFile,
        success : function(data) {
            var portMirrorInfo = JSON.parse(hexDecode(data));
            if (portMirrorInfo["src1"] !== 0 || portMirrorInfo["src2"] !== 0) {
                curEnMirror["X_HW_SrcMirror1"] = portMirrorInfo["src1"];
                curEnMirror["X_HW_SrcMirror2"] = portMirrorInfo["src2"];
                curEnMirror["X_HW_DestMirror"] = portMirrorInfo["dest"];
                curEnMirror["X_HW_TypeMirror"] = portMirrorInfo["type"];
                curEnMirror["X_HW_TimeMirror"] = portMirrorInfo["time"];
                curEnMirrorExpr = portMirrorInfo["expr"];
            } else {
                curEnMirror["X_HW_SrcMirror1"] = 0;
                curEnMirror["X_HW_SrcMirror2"] = 0;
                curEnMirror["X_HW_DestMirror"] = 0;
                curEnMirrorExpr = 0;
            }
        },
        complete: function (XHR, TS) {
            XHR = null;
        }
    });
}
CurMirrorInfoGet();

if (EthPortNum !== 0) {
    var i = 0;
    for(i = 1; i <= EthPortNum; i++) {
        SrcMirroPortArray1[i - 1] = "LAN" + i;
        SrcMirroPortArray2[i - 1] = "LAN" + i;
        DestMirrorPortArray[i - 1] = "LAN" + i;
    }
    SrcMirroPortArray1[i] = "PON";
    SrcMirroPortArray2[i] = "PON";
}


var index = 0;
TypeMirrorArray[index++] = GetLanguageDesc("sCMP016");
TypeMirrorArray[index++] = GetLanguageDesc("sCMP017");
TypeMirrorArray[index++] = GetLanguageDesc("sCMP015");
index = 0;
TimeMirrorArray[index++] = "5";
TimeMirrorArray[index++] = "15";
TimeMirrorArray[index++] = "30";
TimeMirrorArray[index++] = "45";
TimeMirrorArray[index++] = "60";
TimeMirrorArray[index++] = "120";

function LoadFrame()
{
    return;
}


function ConvertPortStrToNum(type, portStr)
{
    var tmp = portStr.length;
    if (type === "port") {
        if (portStr.indexOf("LAN") !== -1) { 
            return parseInt(portStr.substring(3, tmp));
        }

        if (portStr.indexOf("PON") !== -1) { 
            return PonPortValue;
        }
    }

    if (type === "type") {
        if (portStr === GetLanguageDesc("sCMP016"))  {
            return 0;
        }
        if (portStr === GetLanguageDesc("sCMP017")) {
            return 1;
        }
        if (portStr === GetLanguageDesc("sCMP015")) {
            return 2;
        }
    }

    if (type === "time") {
        var time = parseInt(portStr);
        if (time) {
            return time;
        }
    }
    return 0;
}

function ConvertTextNode(id, value)
{
    if ((id === "X_HW_SrcMirror1") || (id === "X_HW_SrcMirror2")) {
        if (value <= EthPortNumMax){
            return "LAN" + value;
        }
        if (value === PonPortValue) {
            return "PON";
        }
    }

    if (id === "X_HW_DestMirror") {
        if (value <= EthPortNumMax){
            return "LAN" + value;
        }
    }

    if (id === "X_HW_TypeMirror") {
        if (value === 0) {
            return GetLanguageDesc("sCMP016");
        }
        if (value === 1) {
            return GetLanguageDesc("sCMP017");
        }
        if (value === 2) {
            return GetLanguageDesc("sCMP015");
        }
    }
    if (id === "X_HW_TimeMirror") {
        return value;
    }
}

function CreateDropDownListSelect(id, selectarray)
{
    var select = document.getElementById(id);
    var isEmpty = true;

    if (curEnMirror[id] !== 0) {
        var opt = document.createElement('option');
        var optShow = ConvertTextNode(id, curEnMirror[id]);
        var html = document.createTextNode(optShow);
        opt.value = ConvertTextNode(id, curEnMirror[id]);
        opt.appendChild(html);
        select.appendChild(opt);
        isEmpty = false;
    }
    if (isEmpty) {
        var opt = document.createElement('option');
        var optShow = "";
        var html = document.createTextNode(optShow);
        opt.value = "";
        opt.appendChild(html);
        select.appendChild(opt);
    }
    for (var i in selectarray) {
        if (selectarray[i] === ConvertTextNode(id, curEnMirror[id])) {
            continue;
        }
        var opt = document.createElement('option');
        var optShow = selectarray[i];
        var html = document.createTextNode(optShow);
        opt.value = selectarray[i];
        opt.appendChild(html);
        select.appendChild(opt);
    }
    return;
}

function updateSelect()
{
    return;
}

function MirrorTableDisableSet(value)
{
    if (value !== 0) {
        value = 1;
    }
    setDisable('X_HW_SrcMirror1', value);
    setDisable('X_HW_SrcMirror2', value);
    setDisable('X_HW_DestMirror', value);
    setDisable('X_HW_TypeMirror', value);
    setDisable('X_HW_TimeMirror', value);
    return;
}

function CurMirrorIntervalCb()
{
    CurMirrorInfoGet();
    if ((curEnMirror["X_HW_SrcMirror1"] === 0) && (curEnMirror["X_HW_SrcMirror2"] === 0) && (curEnMirror["X_HW_DestMirror"] === 0)) {
        var btn = document.getElementById('btnMirrorCtrl');
        btn.setAttribute('BindText', "sCMP008");
        ParseBindTextByTagName(ConfigMirrorPortDes, "input",  2);
        MirrorTableDisableSet(0);
        clearInterval(curEnMirrorIntervalTimer);
        curEnMirrorIntervalTimer = 0;
    }
}

function CurMirrorTimeoutCb()
{
    if (curEnMirrorIntervalTimer !== 0) {
        clearInterval(curEnMirrorIntervalTimer);
        curEnMirrorIntervalTimer = 0;
    }
    curEnMirrorIntervalTimer = setInterval(CurMirrorIntervalCb, 10 * 1000);
    clearInterval(curEnMirrorTimeoutTimer);
    curEnMirrorTimeoutTimer = 0;
    return;
}

function SubmitMirrorOpenForm()
{
    var src1 = ConvertPortStrToNum("port", getSelectVal('X_HW_SrcMirror1'));
    var src2 = ConvertPortStrToNum("port", getSelectVal('X_HW_SrcMirror2'));
    var dest = ConvertPortStrToNum("port", getSelectVal('X_HW_DestMirror'));
    var type = ConvertPortStrToNum("type", getSelectVal('X_HW_TypeMirror'));
    var time = ConvertPortStrToNum("time", getSelectVal('X_HW_TimeMirror'));

    if ((src1 === 0) && (src2 === 0)) {
        alert(GetLanguageDesc("sCMP011"));
        return;
    }

    if (dest === 0) {
        alert(GetLanguageDesc("sCMP012"));
        return;
    }

    if (src1 === src2) {
        alert(GetLanguageDesc("sCMP014"));
        return;
    }

    if ((src1 === dest) || (src2 === dest)) {
        alert(GetLanguageDesc("sCMP013"));
        return;
    }

    if (ConfirmEx(GetDescFormArrayById(ConfigMirrorPortDes, "sCMP007"))) {

        var parm = src1 + " " + src2 + " " + dest + " " + type + " " + time;
        var RequestFile = '&RequestFile=/html/ssmp/mirrorportcfg/mirrorportconfig.asp';
        $.ajax({
            type : "POST",
            async : true,
            cache : false,
            data : 'MirrorPortSet=' + parm + "&x.X_HW_Token=" + getValue('onttoken'),
            url : "setmirrorport.cgi?" + RequestFile,
            success : function(data) {
                var res = JSON.parse(hexDecode(data));
                if (res["result"] === 0) {
                    MirrorTableDisableSet(1);
                    var btn = document.getElementById('btnMirrorCtrl');
                    btn.setAttribute('BindText', "sCMP009");
                    ParseBindTextByTagName(ConfigMirrorPortDes, "input",  2);
                    if (curEnMirrorTimeoutTimer === 0) {
                        curEnMirrorTimeoutTimer = setTimeout(CurMirrorTimeoutCb, time * 60 * 1000);
                    }
                }
            },
            complete: function (XHR, TS) {
                XHR = null;
            }
        });
    }
}

function SubmitMirrorCloseForm()
{
    if (ConfirmEx(GetDescFormArrayById(ConfigMirrorPortDes, "sCMP010"))) {
        var src1 = ConvertPortStrToNum("port", getSelectVal('X_HW_SrcMirror1'));
        var src2 = ConvertPortStrToNum("port", getSelectVal('X_HW_SrcMirror2'));
        var dest = ConvertPortStrToNum("port", getSelectVal('X_HW_DestMirror'));
        var type = ConvertPortStrToNum("type", getSelectVal('X_HW_TypeMirror'));
        var time = 0;
        var parm = src1 + " " + src2 + " " + dest + " " + type + " " + time;

        var RequestFile = '&RequestFile=/html/ssmp/mirrorportcfg/mirrorportconfig.asp';
        $.ajax({
            type : "POST",
            async : true,
            cache : false,
            data : 'MirrorPortSet=' + parm + "&x.X_HW_Token=" + getValue('onttoken'),
            url : "setmirrorport.cgi?" + RequestFile,
            success : function(data) {
                var res = JSON.parse(hexDecode(data));
                if (res["result"] === 0) {
                    if (curEnMirrorIntervalTimer !== 0) {
                        clearInterval(curEnMirrorIntervalTimer);
                        curEnMirrorIntervalTimer = 0;
                    }
                    if (curEnMirrorTimeoutTimer !== 0) {
                        clearInterval(curEnMirrorTimeoutTimer);
                        curEnMirrorTimeoutTimer = 0;
                    }
                    var btn = document.getElementById('btnMirrorCtrl');
                    btn.setAttribute('BindText', "sCMP008");
                    ParseBindTextByTagName(ConfigMirrorPortDes, "input",  2);
                    MirrorTableDisableSet(0);
                }
            },
            complete: function (XHR, TS) {
                XHR = null;
            }
        });
    }
}

function SubmitMirrorForm()
{
    if (isFuncDisable) {
        return;
    }

    var value = document.getElementById('btnMirrorCtrl').getAttribute('BindText');
    if (value === "sCMP008") {
        SubmitMirrorOpenForm();
    }
    if (value === "sCMP009") {
        SubmitMirrorCloseForm();
    }
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
    <script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo("MirrorConfig", GetDescFormArrayById(ConfigMirrorPortDes, "sCMP000"), GetDescFormArrayById(ConfigMirrorPortDes, "sCMP001"), false);
    </script>

    <div id="MirrorPortConfig">
    <form id="MirrorPortConfigDetail">
    <table id="MirrorPortConfigDetailTable"  cellpadding="0" cellspacing="0" width="100%">
    <li id="X_HW_SrcMirror1" RealType="DropDownList" DescRef="sCMP002" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.X_HW_MainUpPort" InitValue="Empty" Elementclass="sntpselectdefcss" ClickFuncApp="onChange=updateSelect"/>
    <li id="X_HW_SrcMirror2" RealType="DropDownList" DescRef="sCMP003" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.X_HW_MainUpPort" InitValue="Empty" Elementclass="sntpselectdefcss" ClickFuncApp="onChange=updateSelect"/>
    <li id="X_HW_DestMirror" RealType="DropDownList" DescRef="sCMP004" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.X_HW_MainUpPort" InitValue="Empty" Elementclass="sntpselectdefcss" ClickFuncApp="onChange=updateSelect"/>
    <li id="X_HW_TypeMirror" RealType="DropDownList" DescRef="sCMP005" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.X_HW_MainUpPort" InitValue="Empty" Elementclass="sntpselectdefcss" ClickFuncApp="onChange=updateSelect"/>
    <li id="X_HW_TimeMirror" RealType="DropDownList" DescRef="sCMP006" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.X_HW_MainUpPort" InitValue="Empty" Elementclass="sntpselectdefcss" ClickFuncApp="onChange=updateSelect"/>
    </table>
    <script>
        MirrorPortConfigDetailList = HWGetLiIdListByForm("MirrorPortConfigDetail", null);
        HWParsePageControlByID("MirrorPortConfigDetail", TableClass, ConfigMirrorPortDes, null);
        CreateDropDownListSelect("X_HW_SrcMirror1", SrcMirroPortArray1);
        CreateDropDownListSelect("X_HW_SrcMirror2", SrcMirroPortArray2);
        CreateDropDownListSelect("X_HW_DestMirror", DestMirrorPortArray);
        CreateDropDownListSelect("X_HW_TypeMirror", TypeMirrorArray);
        CreateDropDownListSelect("X_HW_TimeMirror", TimeMirrorArray);
    </script>
    </form>
    </div>

    <table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
        <tr>
            <td class="table_submit width_per30"></td>
            <td class="table_submit">
                <input type="button" name="btnMirrorCtrl" id="btnMirrorCtrl" class="ApplyButtoncss buttonwidth_100px" onClick="SubmitMirrorForm();"/>
                <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            </td>
        </tr>
    </table>
    <script>
        var btn = document.getElementById('btnMirrorCtrl');
        if ((ontPonMode === "gpon") || (ontPonMode === "epon")) {
            isFuncDisable = false;
            if ((curEnMirror["X_HW_SrcMirror1"] === 0) && (curEnMirror["X_HW_SrcMirror2"] === 0) && (curEnMirror["X_HW_DestMirror"] === 0)) {
                btn.setAttribute('BindText', "sCMP008");
            } else {
                btn.setAttribute('BindText', "sCMP009");
                if (curEnMirrorTimeoutTimer === 0) {
                    curEnMirrorTimeoutTimer = setTimeout(CurMirrorTimeoutCb, curEnMirrorExpr * 60 * 1000);
                }
                MirrorTableDisableSet(1);
            }
        } else {
            btn.setAttribute('BindText', "sCMP009");
            MirrorTableDisableSet(1);
            setDisable('btnMirrorCtrl', 1);
            isFuncDisable = true;
        }
        ParseBindTextByTagName(ConfigMirrorPortDes, "input",  2);
    </script>
</body>
</html>