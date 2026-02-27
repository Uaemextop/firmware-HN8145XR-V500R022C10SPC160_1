<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="Pragma" content="no-cache"/>
    <link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
    <link rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
    <script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
    <script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
    <script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
    <script language="JavaScript" src="/html/bbsp/common/lanuserinfo.asp"></script>
    <title>session limit</title>

    <script language="javascript">
        var deviceMinSession = 10;
        var deviceMaxSession = 30000;
        var token = '<%HW_WEB_GetToken();%>';
        var emptyStr = "----";
        var sessionLinitflag =  '<%HW_WEB_GetFeatureSupport(BBSP_FT_SESSION_LIMIT);%>';

        function loadlanguage() {
            var all = document.getElementsByTagName("td");
            for (var i = 0; i < all.length; i++) {
                var b = all[i];
                if (b.getAttribute("BindText") == null) {
                    continue;
                }
                b.innerHTML = sessionLimit_language[b.getAttribute("BindText")];
            }
        }

        function LoadFrame() {
            loadlanguage();
            if (devSessionLimitList.length > 8) {
                setDisable('Newbutton', 1);
            }
            setDisable('DeleteButton', 1);
        }

        function devSessionLimit(domain, Mac, DevSession) {
            this.domain = domain;
            this.Mac = Mac;
            this.DevSession = DevSession;
        }

        var devSessionLimitList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.DevSessionLimit.{i}, Mac|DevSession,devSessionLimit);%>;

        if(devSessionLimitList.length === 1 && devSessionLimitList[0] == null) {
            devSessionLimitList[0] = {
                domain : emptyStr,
                Mac : emptyStr,
                DevSession : emptyStr
            }
        }

        function stUserDevInfoPTVDF(HostName, DevType, IpAddr, MacAddr, DevStatus, Port, Time, Leasetion, Domain, RealMacAddr, TrafficRecvRate, TrafficSendRate) {
            this.HostName = HostName;
            this.DevType = DevType;
            this.IpAddr = IpAddr;
            this.MacAddr = MacAddr;
            this.DevStatus = DevStatus;
            this.Port = Port;
            this.Time = Time;
            this.Leasetion = Leasetion;
            this.Domain = Domain;
            this.RealMacAddr = RealMacAddr;
            this.TrafficRecvRate = TrafficRecvRate;
            this.TrafficSendRate = TrafficSendRate;
        }

        function stLimit(domain,Enable,MAXSession)
        {
            this.domain = domain;
            this.Enable = Enable;
            this.MAXSession = MAXSession;
        }
        var sessionLimits = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.UsrSessionLimit,Enable|MAXSession,stLimit);%>;
        var sessionLimit = sessionLimits[0];

        function getDevice(devices) {
            var set = new Set();
            for (var i = 0; i < devices.length; i++) {
                if ((devices[i] != null) && (devices[i].DevType != 'HWAP')){
                    set.add(devices[i].MacAddr);
                }
            }
            for (var i = 0; i < devSessionLimitList.length; i++) {
                if (devSessionLimitList[i] != null) {
                    set.delete(devSessionLimitList[i].Mac)
                }
            }
            var deviceList = Array.from(set);
            for (var i = 0; i < deviceList.length; i++) {
                var item = '<option value="' + deviceList[i] + '" id="' + deviceList[i] + '">' +  deviceList[i] + '</option>';
                $("#deviceMac").append(item);
            }
        }

        function addDevice() {
            var mac = getSelectVal('deviceMac');
            if (mac == -1) {
                return;
            }
            var maxSession = $('#deviceMaxSession').val();
            if (!(/(^[1-9]\d*$)/.test(maxSession)) || maxSession > deviceMaxSession || maxSession < deviceMinSession) {
                AlertEx(sessionLimit_language['Sessionrange']);
                return;
            }

            var form = new webSubmitForm();
            form.addParameter('x.Mac', mac);
            form.addParameter('x.DevSession', maxSession);
            form.addParameter('x.X_HW_Token', token);
            form.setAction('add.cgi?x=InternetGatewayDevice.X_HW_Security.DevSessionLimit' +
                '&RequestFile=html/bbsp/ipincoming/devsessionlimit.asp');
            form.submit();
        }

        function OnDeleteButtonClick() {
            var checkedDevice = document.getElementsByName('deviceTablerml');
            var form = new webSubmitForm();
            for (var i = 0; i < checkedDevice.length; i++) {
                if (checkedDevice[i].checked) {
                    form.addParameter(checkedDevice[i].value,'');
                }
            }
            setDisable('DeleteButton',1);
            form.addParameter('x.X_HW_Token', token);
            form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_Security.DevSessionLimit' +
                '&RequestFile=html/bbsp/ipincoming/devsessionlimit.asp');
            form.submit();
        }

        function cancelDevice() {
            setDisplay('deviceForm', 0);
            $('#deviceMac').val(-1);
            $('#deviceMaxSession').val(1000);
            document.getElementById('deviceTable_record_null').remove();
            setDisplay("DeleteButton", 1);
        }

        function setControl(index) {
            if (index === -1) {
                setDisplay('deviceForm', 1);
                setDisable('DeleteButton', 1)
            }
        }

        function deviceTableselectRemoveCnt(val) {
            if (val.value === emptyStr) {
                return;
            }
            var ckeckedDevice = document.getElementsByName('deviceTablerml');
            var checkedNum = 0;
            for (var i = 0; i < ckeckedDevice.length; i++) {
                if (ckeckedDevice[i].checked) {
                    checkedNum++;
                }
            }
            setDisable("DeleteButton", checkedNum == 0);
        }

        function CheckForm()
        {
            var specSessionLinit = '<%HW_WEB_GetSPEC(BBSP_SPEC_FWD_SESSIONNUM.UINT32);%>'
            if (specSessionLinit == '') {
                specSessionLinit = 16000;
            }
            specSessionLinit = parseInt(specSessionLinit, 10);

            var Sessionrange = parseInt(getValue("allMaxSession"), 10);
            if (Sessionrange < 1 || Sessionrange > specSessionLinit) {
                AlertEx(sessionLimit_language["bbsp_limit_recognition_isNaN"] + specSessionLinit);
                return false;
            }
            return true;
        }

        function ApplyConfig()
        {
            if (!CheckForm()) {
                return false;
            }

            var Form = new webSubmitForm();
            Form.addParameter('x.Enable',getCheckVal("LimitEnable")); 
            Form.addParameter('x.MAXSession',getValue("allMaxSession")); 
            Form.addParameter('x.X_HW_Token', getValue('onttoken'));
            Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security.UsrSessionLimit'
                           + '&RequestFile=html/bbsp/ipincoming/devsessionlimit.asp');
            Form.submit();  
        }

        function CancelConfig()
        {
            LoadFrame();
        }

    </script>

</head>
<body onLoad="LoadFrame();" class="mainbody">

<script language="JavaScript" type="text/javascript">
    if (sessionLinitflag == 1) {
        HWCreatePageHeadInfo("portalalltitle", GetDescFormArrayById(sessionLimit_language, "bbsp_all_mune"), GetDescFormArrayById(sessionLimit_language, "bbsp_allsessionLimit_title"), false);
    }
</script>
<div id="alldeviceForm" style="display:none;">
    <form id="AllLimitConfigForm">
        <table border="0" cellpadding="0" cellspacing="1" width="100%">
            <li id="LimitEnable"   RealType="CheckBox" DescRef="bbsp_alldevice_enable" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Enable" InitValue="Empty" />
            <li id="allMaxSession" RealType="TextBox"  DescRef="bbsp_allmax_session" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.MAXSession" InitValue="Empty" />
        </table>
        <script>
            var TableClass = new stTableClass("table_title width_per30", "table_right", "", "");
            HWParsePageControlByID("AllLimitConfigForm", TableClass, sessionLimit_language, null);
        </script>
        <table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
            <tr>
                <td class="width_per25"></td>
                <td class="pad_left5p">
                    <button id="buttonApply" name="buttonApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="ApplyConfig();">
                        <script>document.write(sessionLimit_language['apply']);</script>
                    </button>
                    <button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();">
                        <script>document.write(sessionLimit_language['bbsp_cancel']);</script>
                    </button>
                </td>
                <td><input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"></td>
            </tr>
        </table>
    </form>
</div>

<script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo("portaltitle", GetDescFormArrayById(sessionLimit_language, "bbsp_mune"), GetDescFormArrayById(sessionLimit_language, "bbsp_sessionLimit_title"), false);
</script>
<div id="deviceDiv">
    <script language="JavaScript" type="text/javascript">
        var TableName = "deviceTable";
        var titleList = new Array(new stTableTileInfo("Empty", "align_center", "DomainBox"),
            new stTableTileInfo("mac_address", "align_center", "Mac"),
            new stTableTileInfo("max_session", "align_center", "DevSession"), 
            null);
        HWShowTableListByType(1, TableName, true, titleList.length - 1, devSessionLimitList, titleList, sessionLimit_language, null);
    </script>
    </table>

    <div id="deviceForm" style="display:none; margin-top: 5px">
        <div class="list_table_spread"></div>
        <div>
            <div class="table_title width_per20" style="display: inline-block"><script>document.write(sessionLimit_language['mac_address']);</script></div>
            <select id="deviceMac" name="deviceMac" style="width: 140px">
                <option value="-1"><script>document.write(sessionLimit_language['please_select']);</script></option>
            </select>
        </div>

        <div style="margin-top: 2px">
            <div class="table_title width_per20" style="display: inline-block"><script>document.write(sessionLimit_language['max_session']);</script></div>
            <input type="text" value="1000" id="deviceMaxSession" maxlength="5" style="width: 132px"/>
            <span style="color: red">*</span>
            <span><script>document.write("(" + deviceMinSession + "-" + deviceMaxSession + ")")</script></span>
        </div>

        <div class="width_per20" style="display: inline-block"></div>
        <div style="display: inline-block; padding-left: 5px; padding-top: 10px">
            <button name="btnApply_ex" type="button" onClick="addDevice();"/>
                <script>document.write(sessionLimit_language['apply']);</script>
            </button>
            <button name="cancel" type="button" onClick="cancelDevice();"/>
                <script>document.write(sessionLimit_language['bbsp_cancel']);</script>
            </button>
        </div>
    </div>
</div>
<script language="JavaScript" type="text/javascript">
    GetLanUserDevInfo(function(para) {
        getDevice(para);
    });

    if (sessionLinitflag == 1) {
        document.getElementById("alldeviceForm").style.display ='block';
        setCheck('LimitEnable',sessionLimit.Enable);
        setText('allMaxSession',sessionLimit.MAXSession);
    }
</script>
</body>
</html>
