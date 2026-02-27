<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<link rel="stylesheet" href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" type="text/javascript">
var logText = '<%WEB_GetInstrusionLog();%>';
var languageList = '<%HW_WEB_GetSPEC(SSMP_SPEC_WEB_LANGUAGE_SET.STRING);%>';
var initLanguage = '<%HW_WEB_GetSPEC(SSMP_SPEC_WEB_LANGUAGE.STRING);%>';
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
var languageSet = new Array();

if ((typeof languageList == 'string') && (languageList != '')) {
    languageSet = languageList.split("|");
}

function LoadFrame() {
    document.getElementById("logarea").value = logText;
}

function DownloadLog() {
    XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
    var Form = new webSubmitForm();
    Form.addParameter('logtype', "opt");
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('instrusionlogdown.cgi?FileType=instrusionlog&RequestFile=html/ssmp/instrusionlog/instrusionlog.asp');
    Form.submit();
}

function IsSupportPrompt()
{
    if (languageSet.length > 1) {
        for (var lang in languageSet) {
            if ((languageSet[lang] != 'english') && (languageSet[lang] != 'chinese')) {
                return false;
            }
        }
    }

    if ((initLanguage != 'english') && (initLanguage != 'chinese')) {
        return false;
    }

    if ((curLanguage != 'english') && (curLanguage != 'chinese')) {
        return false;
    }

    return true;
}

function backupSetting() {
    if (IsSupportPrompt() == true) {
        if (ConfirmEx(LogviewLgeDes["s0b29"]) == false) {
            return;
        }
    }

    var ua = navigator.userAgent.toLowerCase();
    if (/iphone|ipad|ipod/.test(ua)) {
        window.open("/html/ssmp/instrusionlog/instrusionlog_ios.asp");
        return;
    }

    DownloadLog();
}


</script>
</head>

<body class="mainbody pageBg" onLoad="LoadFrame();">
<script language="JavaScript" type="text/javascript">
 HWCreatePageHeadInfo("logHead", GetDescFormArrayById(instrusionLogDes, "s0100"), GetDescFormArrayById(instrusionLogDes, "s0101"), false);</script>
<div class="title_spread"></div>
<div class="func_title">
    <script>document.write(DebuglogviewLgeDes['s0b0f'])</script>
</div> 
<div id="backlog"> 
  <table width="100%" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td> <input class="ApplyButtoncss buttonwidth_150px_250px" name="downbutton" id="downbutton" type='button'  onClick='backupSetting()'>
      <script>getElementById("downbutton").value = DebuglogviewLgeDes['s0b11'];</script>
      <input type="hidden" name="onttoken" id="onttoken" value="<%HW_WEB_GetToken();%>"></td> 
    </tr> 
  </table> 
</div>
<div class="button_spread"></div>

<form id="LogviewsCfgForm" name="LogviewsCfgForm">
    <div id="logviews">
        <textarea name="logarea" id="logarea" class="text_log" wrap="off" readonly="readonly">
        </textarea>
    </div>
</form>

</body>
</html>
