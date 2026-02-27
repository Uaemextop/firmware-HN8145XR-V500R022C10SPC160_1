<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Pragma" content="no-cache" />
  <link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css" />
  <link rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
  <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
  <title>PSK Protect</title>
  <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
  <script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
  <script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
  <script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
  <script language="JavaScript" type="text/javascript">
    var enblPskProtect = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_WIFIInfo.X_HW_PskMassiveDetect.Enable, DB);%>';

    function LoadFrame() {
      if (enblPskProtect != '') {
        setCheck('Enable', enblPskProtect);
      }
    }

    function ApplyConfig() {
      setDisable('buttonApply', 1);
      setDisable('cancelValue', 1);
      var url = 'set.cgi?x=InternetGatewayDevice.X_HW_WIFIInfo.X_HW_PskMassiveDetect' + '&RequestFile=html/amp/wlanadv/wlanpskprotect.asp';
      var Form = new webSubmitForm();
      Form.addParameter('x.Enable', getCheckVal('Enable'));
      Form.addParameter('x.X_HW_Token', getValue('onttoken'));
      Form.setAction(url);
      Form.submit();
    }

    function CancelConfig() {
      LoadFrame();
    }
  </script>
  
  <style>
    #EnableColleft {
      padding-left: 10px;
    }
  </style>
</head>

<body onLoad="LoadFrame();" class="mainbody">
  <script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo("pskprotect", GetDescFormArrayById(cfg_wlancfgadvance_language, "amp_advance_pskprotect_enable"), GetDescFormArrayById(cfg_wlancfgadvance_language, "amp_advance_pskprotect_title"), false);
  </script>
  <div class="title_spread"></div>
  <form id="ConfigForm">
    <table border="0" cellpadding="0" cellspacing="1" width="100%">
      <li id="Enable" RealType="CheckBox" DescRef="amp_advance_pskprotect_enable" RemarkRef="Empty" ErrorMsgRef="Empty"
        Require="FALSE" BindField="x.Enable" InitValue="Empty" />
    </table>
    <script>
      var TableClass = new stTableClass("table_title width_per30", "table_right", "", "");
      HWParsePageControlByID("ConfigForm", TableClass, cfg_wlancfgadvance_language, null);
    </script>
    <table width="100%" cellpadding="5" cellspacing="0" class="table_button">
      <tr>
        <td class="width_per25"></td>
        <td class="pad_left5p">
          <button id="buttonApply" name="buttonApply" type="button" class="ApplyButtoncss buttonwidth_100px"
            onClick="ApplyConfig();">
            <script>document.write(cfg_wlancfgadvance_language['amp_app']);</script>
          </button>
          <button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px"
            onClick="CancelConfig();">
            <script>document.write(cfg_wlancfgadvance_language['amp_cancel']);</script>
          </button>
        </td>
        <td><input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"></td>
      </tr>
    </table>
  </form>
</body>

</html>