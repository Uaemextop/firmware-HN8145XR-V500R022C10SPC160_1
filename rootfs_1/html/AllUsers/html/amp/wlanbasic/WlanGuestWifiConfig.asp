<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(common.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(errdes.html);%>"></script>

<style type='text/css'>
    span.language-string {
    padding: 0px 15px;
    display: block;
    height: 40px;
    line-height: 40px;
    }
    .row.hidden-pw-row {
    width: 132px;
    height: 30px;
    line-height: 30px;
    }
    .tabal_noborder_bg {
        padding: 0px 0px 20px 0px;
        border-bottom: 1px solid #E8E7E7;
    }
    .font_size15 {
        font-size: 15px;
    }
</style>
<title>Guest WiFi</title>
<script language="JavaScript" type="text/javascript">
    var broadenable2g = 0;
    var broadenable5g = 0;
    var guestWifienable2g = 0;
    var guestWifienable5g = 0;
    var sptUserType ='1';
    var IsNos = "<%HW_WEB_GetFeatureSupport(FT_WLAN_NOS2WIFI);%>";
    var CfgMode ='<%HW_WEB_GetCfgMode();%>';
    var PccwFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PCCW);%>';
    var t2Flag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TDEWIFI);%>';
    var WPS20AuthSupported = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.WPS20AuthSupported.Enable);%>';
    var WapiFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WAPI);%>';
    var megacablePwd = '<%HW_WEB_GetFeatureSupport(FT_WLAN_MEGACABLEPWD);%>';
    var ttnet2Flag = '<%HW_WEB_GetFeatureSupport(FT_TTNET2_DEFAULT);%>';
    var DslTalkTalkFlag = '<%HW_WEB_GetFeatureSupport(FT_PRODUCT_TALKTALK);%>';
    var trimssidFlag = '<%HW_WEB_GetFeatureSupport(FT_WLAN_NOT_TRIM_SSID);%>';
    var curUserType='<%HW_WEB_GetUserType();%>';
    var AmpTDESepicalCharaterFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TDE_SEPCIAL_CHARACTER);%>';
    var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';
    var WPAPSKFlag = '<%HW_WEB_GetFeatureSupport(FT_WLAN_WPAPSK_SUPPORT);%>';
    var nonWepFlag = '<%HW_WEB_GetFeatureSupport(FT_WLAN_NON_WEP);%>';
    var turkcellFlag = '<%HW_WEB_GetFeatureSupport(FT_WLAN_TURKCELL);%>';
    var isBponFlag = '<%HW_WEB_GetFeatureSupport(HW_FEATURE_ZQ);%>';
    var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
    var wifiPasswordMask='<%HW_WEB_GetWlanPsdMask();%>';
    var syncToAPDisable = '<%HW_WEB_GetFeatureSupport(FT_DESKAP_MODE_SIMPLE);%>';
    var PwdTipsFlag = '<%HW_WEB_GetFeatureSupport(FT_WEB_SHOW_PWD_TIPS);%>';
    var ssidIndexOf2G = -1;
    var WlanArrIndexOf2G = -1;
    var guestInfoIndexOf2G = -1;
    var ssidIndexOf5G = -1;
    var WlanArrIndexOf5G = -1;
    var guestInfoIndexOf5G = -1;
    var ssidInstNumOf2G = 0;
    var ssidInstNumOf5G = 0;
    var isShowWpa3Eap = 0;
    var basic5GIfIndex = SsidPerBand;
    var has2GSubmit = 0;

    var isSontOrSYN = false;
    var isFitAp = 0;
    var fitApFt = '<%HW_WEB_GetFeatureSupport(FT_FIT_AP);%>';
    var fitApEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Capwap.APMode);%>';
    if ((fitApFt == 1) && (fitApEnable == 1)) {
        isFitAp = 1;
    }

    function FitApDisable() {
        setDisable('AutoExtendGuestEnable', 1);
        setDisable('guestWifiEnableSwitch_2G', 1);
        setDisable('wlAuthMode_2G', 1);
        setDisable('wlEncryption_2G', 1);
        setDisable('pwd_ssidpassword_2G', 1);
        setDisable('displaypassword_2G', 1);
        setDisable('duration_2G', 1);
        setDisable('uplinkRateLimit_2G', 1);
        setDisable('downlinkRateLimit_2G', 1);
        setDisable('guestWifiEnableSwitch_5G', 1);
        setDisable('ssidname_5G', 1);
        setDisable('wlAuthMode_5G', 1);
        setDisable('wlEncryption_5G', 1);
        setDisable('pwd_ssidpassword_5G', 1);
        setDisable('displaypassword_5G', 1);
        setDisable('duration_5G', 1);
        setDisable('uplinkRateLimit_5G', 1);
        setDisable('downlinkRateLimit_5G', 1);
        setDisable('btnApplySubmit', 1);
        setDisable('cancel', 1);
    }

    function SontOrSYN() {
        if ((CfgMode == 'SYNCSGP210W') || (CfgMode == 'SONETSGP210W')) {
            isSontOrSYN = true;
        } else {
            isSontOrSYN = false;
        }
    }

    function stWifiCoverService(domain, AutoExtendGuestWifi, SyncIotSsidInst){
        this.domain = domain;
        this.AutoExtendGuestWifi = AutoExtendGuestWifi;
        this.SyncIotSsidInst = SyncIotSsidInst;
    }
    var WifiCoverService = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_WifiCoverService, AutoExtendGuestWifi|SyncIotSsidInst, stWifiCoverService);%>;

    function stGuestWifi(domain,SSID_IDX,PortIsolation,Duration,UpRateLimit,DownRateLimit,AutoGenFlag){
        this.domain = domain;
        this.SSID_IDX = SSID_IDX;
        this.PortIsolation = PortIsolation;
        this.Duration = Duration;
        this.UpRateLimit = UpRateLimit;
        this.DownRateLimit = DownRateLimit;
        this.AutoGenFlag = AutoGenFlag;
    }
    var GuestWifiArr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_WLANForGuest.{i},SSID_IDX|PortIsolation|Duration|UpRateLimit|DownRateLimit|AutoGenFlag,stGuestWifi);%>;

    function stWlan(domain,name,enable,SSID,SSIDAdvertisementEnabled,DeviceNum,wmmEnable,BeaconType,BasicEncryptionModes,BasicAuthenticationMode,
                KeyIndex,EncryptionLevel,WPAEncryptionModes,WPAAuthenticationMode,IEEE11iEncryptionModes,IEEE11iAuthenticationMode,
                X_HW_WPAand11iEncryptionModes,X_HW_WPAand11iAuthenticationMode,WPARekey,RadiusServer,RadiusPort,RadiusKey,X_HW_ServiceEnable, LowerLayers,
                X_HW_WAPIEncryptionModes,X_HW_WAPIAuthenticationMode,X_HW_WAPIServer,X_HW_WAPIPort, X_HW_Standard, X_HW_WebVisibility){
        this.domain = domain;
        this.name = name;
        this.enable = enable;
        this.SSID = SSID;
        this.SSIDAdvertisementEnabled = SSIDAdvertisementEnabled;
        this.DeviceNum = DeviceNum;
        this.wmmEnable = wmmEnable;
        this.BeaconType = BeaconType;
        this.BasicEncryptionModes = BasicEncryptionModes;
        this.BasicAuthenticationMode = BasicAuthenticationMode;
        this.KeyIndex = KeyIndex;
        this.EncypBit = EncryptionLevel;
        this.WPAEncryptionModes = WPAEncryptionModes;
        this.WPAAuthenticationMode = WPAAuthenticationMode;
        this.IEEE11iEncryptionModes = IEEE11iEncryptionModes;
        this.IEEE11iAuthenticationMode = IEEE11iAuthenticationMode;
        this.X_HW_WPAand11iEncryptionModes = X_HW_WPAand11iEncryptionModes;
        this.X_HW_WPAand11iAuthenticationMode = X_HW_WPAand11iAuthenticationMode;
        this.WPARekey = WPARekey;
        this.RadiusServer = RadiusServer;
        this.RadiusPort = RadiusPort;
        this.RadiusKey = RadiusKey;
        this.X_HW_ServiceEnable = X_HW_ServiceEnable;
        this.LowerLayers = LowerLayers;
        this.X_HW_WAPIEncryptionModes = X_HW_WAPIEncryptionModes;
        this.X_HW_WAPIAuthenticationMode = X_HW_WAPIAuthenticationMode;
        this.X_HW_WAPIServer = X_HW_WAPIServer;
        this.X_HW_WAPIPort = X_HW_WAPIPort;
        this.mode = X_HW_Standard;
        this.isVisibility = X_HW_WebVisibility;
    }
    var WlanArr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|SSIDAdvertisementEnabled|X_HW_AssociateNum|WMMEnable|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WEPKeyIndex|WEPEncryptionLevel|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|X_HW_GroupRekey|X_HW_RadiuServer|X_HW_RadiusPort|X_HW_RadiusKey|X_HW_ServiceEnable|LowerLayers|X_HW_WAPIEncryptionModes|X_HW_WAPIAuthenticationMode|X_HW_WAPIServer|X_HW_WAPIPort|X_HW_Standard|X_HW_WebVisibility,stWlan);%>;
    var WlanWifi = WlanArr[0];

    var currentWlan = new stWlan();
    function stPreSharedKey(domain, psk, kpp) {
        this.domain = domain;
        this.value = psk;

        if('1' == kppUsedFlag)
        {
            this.value = kpp;
        }
    }
    var wpaPskKey = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.PreSharedKey.1,PreSharedKey|KeyPassphrase,stPreSharedKey);%>;

    function stIspSsid(domain, SSID_IDX) {
        this.domain = domain;
        this.SSID_IDX = SSID_IDX;
    }
    var IspSsidList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.{i}, SSID_IDX, stIspSsid);%>;

    var aWiFiSSID2GInst = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_AWiFi_SSID.SSID2GINST);%>';
    var ShowFirstSSID = '<%HW_WEB_GetFeatureSupport(FT_WLAN_SHOW_FIRST_SSID);%>';

    var WlanMap = new Array();
    var j = 0;
    for (var i = 0; i < WlanArr.length - 1; i++) {
        if (isShowWlan(WlanArr[i])) {
            var index = getWlanPortNumber(WlanArr[i].name);
            WlanMap[j] = new stIndexMapping(i, index);
            j++;
        }
    }

    if (WlanMap.length >= 2) {
        for (var i = 0; i < WlanMap.length-1; i++) {
            for( var j =0; j < WlanMap.length-i-1; j++) {
                if (WlanMap[j+1].portIndex < WlanMap[j].portIndex) {
                    var middle = WlanMap[j+1];
                    WlanMap[j+1] = WlanMap[j];
                    WlanMap[j] = middle;
                }
            }
        }
    }

    var Auth = '';
    var Encrypt = '';
    function AssignEncrypt(wlan) {
        if ((wlan.BeaconType == 'Basic') || (wlan.BeaconType == 'None')) {
            Auth = wlan.BasicAuthenticationMode;
            Encrypt = wlan.BasicEncryptionModes;
        } else if (wlan.BeaconType == 'WPA') {
            Auth = wlan.WPAAuthenticationMode;
            Encrypt = wlan.WPAEncryptionModes;
        } else if ((wlan.BeaconType == '11i') || (wlan.BeaconType == 'WPA2')) {
            Auth = wlan.IEEE11iAuthenticationMode;
            Encrypt = wlan.IEEE11iEncryptionModes;
        } else if ((wlan.BeaconType == 'WPAand11i') || (wlan.BeaconType == 'WPA/WPA2') || (wlan.BeaconType == 'WPA3') || (wlan.BeaconType == 'WPA2/WPA3')) {
            Auth = wlan.X_HW_WPAand11iAuthenticationMode;
            Encrypt = wlan.X_HW_WPAand11iEncryptionModes;
        }
        authTrueValue = wlan.BeaconType;
    }

    function getInstIdByDomain(domain) {
        if (domain !== '') {
            return parseInt(domain.substr(domain.lastIndexOf('.') + 1));
        }
    }

    function IsIspSsid(wlanInst) {
        for (var i = 0; i < IspSsidList.length - 1; i++) {
            if (wlanInst == IspSsidList[i].SSID_IDX) {
                return true;
            }
        }

        return false;
    }

    function IsAwifiSsid(wlanInst) {
        if (wlanInst == aWiFiSSID2GInst) {
            return true;
        }
        return false;
    }

    function stFonSsidInst(domain, inst2g, inst5g) {
        this.domain = domain;
        this.fonssid2g = inst2g;
        this.fonssid5g = inst5g;
    }
    var fonssidinsts  = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.FON, SSID2GINST|SSID5GINST, stFonSsidInst, EXTEND);%>;
    var fonssidinst = new stFonSsidInst("", 0 , 0);
    if ((fonssidinsts.length > 1) && ('<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_FON);%>' == '1')) {
        fonssidinst = fonssidinsts[0];
    }

    function setAuthModeSug(freDesc) {
        if (ttnet2Flag != 1) {
            return;
        }

        var authMode = getSelectVal('wlAuthMode_' + freDesc);
        var spanAuth = getElementById('SpanAuthMode_' +freDesc);

        if (authMode == 'open') {
            spanAuth.innerHTML = cfg_wlancfgdetail_language['amp_wlancfgdetail_auth_status'];
            spanAuth.style.color = '#ff0000';
        } else {
            spanAuth.innerHTML = '';
        }
    }

    function onMethodChange(freDesc) {
        setEncryptSug(freDesc);
    }

    function setEncryptSug(freDesc) {
        setAuthModeSug(freDesc);
        if (isSontOrSYN) {
            return;
        }
        
        if (capTkip == '0' || PccwFlag == 1 || DslTalkTalkFlag == 1 || (CfgMode.toUpperCase() == 'ROSUNION')) {
            return;
        }
        
        var encryMode = getSelectVal('wlEncryption_' + freDesc);
        var spanEncrypt = getElementById('SpanEncrypt_' + freDesc);
        var authMode = getSelectVal('wlAuthMode_' + freDesc);
        if ((authMode == 'wpa3-psk') || (authMode == 'wpa2/wpa3-psk')) {
            spanEncrypt.innerHTML = '';
            return;
        }
        
        if ((cap11ax == 1) && (isShowWpa3Eap == 1)) {
            if (encryMode != 'AESEncryption') {
                spanEncrypt.innerHTML = cfg_wlancfgdetail_language['amp_wlancfgdetail_11axencry_status'];
                spanEncrypt.style.color = '#ff0000';  
            } else {
                spanEncrypt.innerHTML = '';
            }
            return;
        }

        if (CfgMode.toUpperCase() == 'VIETTEL' || CfgMode.toUpperCase() == 'VIETTEL2') {
            if (encryMode != 'TKIPandAESEncryption' && encryMode != 'AESEncryption') {
                spanEncrypt.innerHTML = cfg_wlancfgdetail_language['amp_wlancfgdetail_encry_onlyaes_status'];
                spanEncrypt.style.color = '#ff0000';
            } else {
                spanEncrypt.innerHTML = '';
            }
        } else {
            if (encryMode != 'TKIPandAESEncryption') {
                if (encryMode == 'AESEncryption') {
                    if ((CfgMode == 'OSK') || (CfgMode == 'OSK2') || (CfgMode == 'COMMON') ||
                        ("COMMON2" == CfgMode) || (1 == DefaultAesFlag)) {
                        spanEncrypt.innerHTML = '';
                        return ;
                    }
                }

                spanEncrypt.innerHTML = cfg_wlancfgdetail_language['amp_wlancfgdetail_encry_status'];
                spanEncrypt.style.color = '#ff0000';
            } else {
                spanEncrypt.innerHTML = '';
            }
        }
    }

    function isMainSSID(name) {
        var portIndex = getWlanPortNumber(name);
        if ((portIndex === 0) || (portIndex === parseInt(basic5GIfIndex))) {
            return true;
        }
        return false;
    }

    function isShowWlan(wlan) {
        AssignEncrypt(wlan);

        if (wlan.isVisibility === '0') {
            return false;
        }

        if(Auth == 'EAPAuthentication') {
            return false;
        }

        if(Encrypt == 'NONE' || Encrypt == 'None') {
            if (Auth == 'Both') {
                Encrypt = 'WEP';
            } else {
                Encrypt = 'OPEN';
            }
        } else if(Encrypt == 'WEPEncryption') {
            Encrypt = 'WEP';
        } else if(Encrypt == 'AESEncryption') {
            if (wlan.BeaconType == 'WPA3') {
                Encrypt = 'WPA3-Personal';
            } else if (wlan.BeaconType == 'WPA2/WPA3') {
                Encrypt = 'WPA2-WPA3-Personal';
            } else {
                Encrypt = 'WPA2-Personal';
            }
        } else if(Encrypt == 'TKIPEncryption') {
            Encrypt = 'WPA-Personal';
        } else if(Encrypt == 'TKIPandAESEncryption') {
            Encrypt = 'WPA-WPA2-Personal';
        }

        if (Encrypt == 'WEP') {
            return false;
        }
        var wlanInst = getInstIdByDomain(wlan.domain);
        
        if (IsIspSsid(wlanInst)) {
            return false;
        } 
        
        if(IsAwifiSsid(wlanInst)) {
            return false;
        }
        if(ShowFirstSSID == 1) {
            if((wlanInst != 1) &&(wlanInst != 5)) {
                return false;
            } 
        }
        if (fonssidinst !== undefined) {
            if ((wlanInst == fonssidinst.fonssid2g) || (wlanInst == fonssidinst.fonssid5g)) {
                return false;
            }
        }

        if(wlan.X_HW_ServiceEnable !== '1') {
            return false;
        }

        return true;
    }

    function endsWithStr(domain, str) {
        var domainIndex = domain.length - 1;
        for (var i = str.length - 1; i > 0; i--) {
            if (domain[domainIndex] !== str[i]) {
                return false;
            }
            domainIndex--;
        }

        return true;
    }

    function is2GSSID(ssid_idx) {
        var matchStr = '.' + ssid_idx;
        for (var i = 0; i < WlanArr.length - 1; i++) {
            if (endsWithStr(WlanArr[i].domain, matchStr)) {
                var index = getWlanPortNumber(WlanArr[i].name);
                if (index <= (basic5GIfIndex - 1)) {
                    return true;
                }
            }
        }
        return false;
    }

    function is5GSSID(ssid_idx) {
        var matchStr = '.' + ssid_idx;
        for (var i = 0; i < WlanArr.length - 1; i++) {
            if (endsWithStr(WlanArr[i].domain, matchStr)) {
                var index = getWlanPortNumber(WlanArr[i].name);
                if (index >= basic5GIfIndex) {
                    return true;
                }
            }
        }
        return false;
    }

    function getSSIDIndex() {
        for (var i = 0; i < GuestWifiArr.length - 1; i++) {
            if (is2GSSID(GuestWifiArr[i].SSID_IDX)) {
                ssidIndexOf2G = GuestWifiArr[i].SSID_IDX;
                guestInfoIndexOf2G = i;
            } else if (is5GSSID(GuestWifiArr[i].SSID_IDX)) {
                ssidIndexOf5G = GuestWifiArr[i].SSID_IDX;
                guestInfoIndexOf5G = i;
            }
        }
    }

    function getIndexFromPort(index) {
        for (var i = 0; i < WlanMap.length; i++) {
            if (index == WlanMap[i].portIndex) {
                return WlanMap[i].index;
            }
        }
    }

    function getFirstWlanArrIndexOf2G() {
      for (var i = 0; i < WlanMap.length; i++) {
        if (WlanMap[i].portIndex === 0) {
            WlanArrIndexOf2G = WlanMap[i].index;
            break;
        }
      }
    }

    function getFirstWlanArrIndexOf5G() {
      for (var i = 0; i < WlanMap.length; i++) {
        if (WlanMap[i].portIndex === parseInt(basic5GIfIndex)) {
            WlanArrIndexOf5G = WlanMap[i].index;
            break;
        }
      }
    }

    function getWlanArrIndex(freDesc) {
        var str = '';
        if (freDesc === '2G') {
            str = "." + ssidIndexOf2G;
        } else {
            str = "." + ssidIndexOf5G;
        }

        var index = -1;
        for (var i = 0; i < WlanArr.length - 1; i++) {
            if (endsWithStr(WlanArr[i].domain, str)) {
                index = i;
            }
        }

        return index;
    }


    function getWlanArrIndexs() {
        WlanArrIndexOf2G = getWlanArrIndex('2G');
        WlanArrIndexOf5G = getWlanArrIndex('5G');

        if (ssidIndexOf2G === -1) {
            getFirstWlanArrIndexOf2G();
        }
        if (ssidIndexOf5G === -1) {
            getFirstWlanArrIndexOf5G();
        }
    }

    function initGuestWifiInfo(freDesc) {
        var wlanArrIndexOf;
        var guestInfoIndex;
        if (freDesc === '2G') {
            wlanArrIndexOf = WlanArrIndexOf2G;
            guestInfoIndex = guestInfoIndexOf2G;
        } else {
            wlanArrIndexOf = WlanArrIndexOf5G;
            guestInfoIndex = guestInfoIndexOf5G;
        }

        if (wlanArrIndexOf !== -1) {
            fileSSIDInfo(freDesc);
        }
        if (guestInfoIndex !== -1) {
            fileGuestWifiInfo(freDesc);
        }
    }

    function initGuestWifiInfos() {
        initGuestWifiInfo('2G');
        initGuestWifiInfo('5G');
    }

    var initDefaultPassword = function(band, pass) {
      var defIndexMap = {'band2G': ssidIndexOf2G, 'band5G': ssidIndexOf5G};
      var bandKey = getBandKey(band);
      var newPass = pass;
      if ((defIndexMap[bandKey] === -1) && (pass === '********')) {
        newPass = '';
      }

      setText('pwd_ssidpassword_' + band, newPass);
      setText('txt_ssidpassword_' + band, newPass);
    }

    function setEncryptionAndPassword(wlanloop, wlEncryption,freDesc) {
        setDisplay('wpakeyInfo_' + freDesc, 1);
        setSelect('wlEncryption_' + freDesc, wlEncryption);
        if (freDesc === '2G') {
            wpapskpassword_2G = wpaPskKey[wlanloop].value;
            initDefaultPassword(freDesc, wpaPskKey[wlanloop].value);
        } else {
            wpapskpassword_5G = wpaPskKey[wlanloop].value;
            initDefaultPassword(freDesc, wpaPskKey[wlanloop].value);
        }
    }

    function beaconTypeChange(authMode, wlanloop, freDesc){
        if (authMode == 'Basic') {
            var BasicAuthenticationMode = WlanArr[wlanloop].BasicAuthenticationMode;
            var BasicEncryptionModes = WlanArr[wlanloop].BasicEncryptionModes;
            if ((BasicAuthenticationMode == 'None') || (BasicAuthenticationMode == 'OpenSystem')) {
                addEncryMethodOption('open', freDesc);
                setSelect('wlAuthMode_' + freDesc, 'open');
                setSelect('wlEncryption_' + freDesc, BasicEncryptionModes);
                setDisplay('wpakeyInfo_' + freDesc, 0);
            }
        } else if (authMode == 'WPA') {
            if (WlanArr[wlanloop].IEEE11iAuthenticationMode !== 'EAPAuthentication') {
                addEncryMethodOption("wpa-psk", freDesc);
                setSelect('wlAuthMode_' + freDesc, 'wpa-psk');
            }
            setEncryptionAndPassword(wlanloop, WlanArr[wlanloop].WPAEncryptionModes, freDesc);
        } else if ((authMode == 'WPA2') || (authMode == '11i')) {
            if (WlanArr[wlanloop].IEEE11iAuthenticationMode !== 'EAPAuthentication') {
                addEncryMethodOption("wpa2-psk", freDesc);
                setSelect('wlAuthMode_' + freDesc, 'wpa2-psk');
            }
            setEncryptionAndPassword(wlanloop, WlanArr[wlanloop].IEEE11iEncryptionModes, freDesc);
        } else if ((authMode == 'WPA/WPA2') || (authMode == 'WPAand11i')) {
            if (WlanArr[wlanloop].IEEE11iAuthenticationMode !== 'EAPAuthentication') {
                addEncryMethodOption("wpa/wpa2-psk", freDesc);
                setSelect('wlAuthMode_' + freDesc, 'wpa/wpa2-psk');
            }
            setEncryptionAndPassword(wlanloop, WlanArr[wlanloop].X_HW_WPAand11iEncryptionModes, freDesc);
        } else if (authMode == 'WPA3') {
            if (WlanArr[wlanloop].X_HW_WPAand11iAuthenticationMode !== 'EAPAuthentication') {
                addEncryMethodOption("wpa3", freDesc);
                setSelect('wlAuthMode_' + freDesc, 'wpa3-psk');
            }
            setEncryptionAndPassword(wlanloop, WlanArr[wlanloop].X_HW_WPAand11iEncryptionModes, freDesc);
        } else if (authMode == 'WPA2/WPA3') {
            if (WlanArr[wlanloop].X_HW_WPAand11iAuthenticationMode !== 'EAPAuthentication') {
                setSelect('wlAuthMode_' + freDesc, 'wpa2/wpa3-psk');
                addEncryMethodOption("wpa3", freDesc);
            }
            setEncryptionAndPassword(wlanloop, WlanArr[wlanloop].X_HW_WPAand11iEncryptionModes, freDesc);
        } else {
            addEncryMethodOption('open', freDesc);
            setSelect('wlAuthMode_' + freDesc, 'open');
            setSelect('wlEncryption_' + freDesc, 'None');
            setDisplay('wpakeyInfo_' + freDesc, 0);
        }
        setPasswordDisplay(freDesc);
    }

    function setPasswordDisplay(freDesc) {
        if (0 == getCheckVal('displaypassword_' + freDesc)) {
            setDisplay('pwd_ssidpassword_' + freDesc, 0);
            setDisplay('txt_ssidpassword_' + freDesc, 1);
        } else {
            setDisplay('pwd_ssidpassword_' + freDesc, 1);
            setDisplay('txt_ssidpassword_' + freDesc, 0);
        }
    }

    function getGuestSSIDName(band, SSID) {
        var SSID_MAX_LEN = 32;
        var SSID_SUFFIX_MAX_LEN =　4;
        var SSID_GUEST_SUFFIX = 'guest';
        if (band === '2G' && ssidIndexOf2G === -1) {
          var suffix = '-' + SSID_GUEST_SUFFIX;
          return getTruncateStr(SSID, SSID_MAX_LEN - suffix.length) + suffix;
        }

        if (band === '5G' && ssidIndexOf5G === -1) {
          var suffix = '-' + SSID_GUEST_SUFFIX + '-5G';
          return getTruncateStr(SSID, SSID_MAX_LEN - suffix.length) + suffix;
        }

        return SSID;
    }

    function fileSSIDInfo(freDesc) {
        if (freDesc === '2G') {
            setText('ssidname_2G', getGuestSSIDName(freDesc, WlanArr[WlanArrIndexOf2G].SSID));
            authMode = WlanArr[WlanArrIndexOf2G].BeaconType;
            beaconTypeChange(authMode, WlanArrIndexOf2G, freDesc);
        } else {
            setText('ssidname_5G', getGuestSSIDName(freDesc, WlanArr[WlanArrIndexOf5G].SSID));
            authMode = WlanArr[WlanArrIndexOf5G].BeaconType;
            beaconTypeChange(authMode, WlanArrIndexOf5G, freDesc);
        }
    }

    function fileGuestWifiInfo(freDesc) {
        var duration = (freDesc === '2G'? GuestWifiArr[guestInfoIndexOf2G].Duration : GuestWifiArr[guestInfoIndexOf5G].Duration);
        if (freDesc === '2G') {
            setText('duration_2G', parseInt(duration) / 60);
            setText('uplinkRateLimit_2G', GuestWifiArr[guestInfoIndexOf2G].UpRateLimit);
            setText('downlinkRateLimit_2G', GuestWifiArr[guestInfoIndexOf2G].DownRateLimit);
        } else {
            setText('duration_5G', parseInt(duration) / 60);
            setText('uplinkRateLimit_5G', GuestWifiArr[guestInfoIndexOf5G].UpRateLimit);
            setText('downlinkRateLimit_5G', GuestWifiArr[guestInfoIndexOf5G].DownRateLimit);
        }
    }

    function SetGuestWifiEnable(enableName) {
        if (isFitAp == 1) {
            return;
        }
        setBroadFlag = 1;
        if (enableName === "2G") {
            guestWifienable2g = 1 - guestWifienable2g;
            setCheck('guestWifiEnableSwitch_2G', guestWifienable2g);
            getWlanArrIndex('2G');
            initGuestWifiInfo('2G');
            hiddenElement("tableOf2G", guestWifienable2g);
            setDisplay('checkinfo5Row_2G');
            if (getSelectVal('wlAuthMode_2G') === 'open') {
                setDisplay('wpakeyInfo_2G', 0);
            }
        } else {
            guestWifienable5g = 1 - guestWifienable5g;
            setCheck('guestWifiEnableSwitch_5G', guestWifienable5g);
            getWlanArrIndex('5G');
            initGuestWifiInfo('5G');
            hiddenElement("tableOf5G", guestWifienable5g);
            setDisplay('checkinfo5Row_5G');
            if (getSelectVal('wlAuthMode_5G') === 'open') {
                setDisplay('wpakeyInfo_5G', 0);
            }
        }
    }

    function hiddenElement(elemId, flag) {
        var ele = document.getElementById(elemId);
        var isDisplay = (flag === 1) ? "table-row" : "none";
        for(var i = 1 ; i < ele.rows.length; i++) {
            ele.rows[i].style.display = isDisplay;
        }
    }

    var checkSSIDAvailable = function(index) {
      var ssidInst = GuestWifiArr[index].SSID_IDX;
      var wlanArrrIndex = getWlanArrIndexByInst(ssidInst);
      return WlanArr[wlanArrrIndex].enable === '1';
    }

    function initGuestWifiEnable() {
        if (guestInfoIndexOf2G !== -1 && checkSSIDAvailable(guestInfoIndexOf2G)) {
            guestWifienable2g = 1;
        } else {
            guestWifienable2g = 0;
        }
        setCheck('guestWifiEnableSwitch_2G', guestWifienable2g);

        if (guestInfoIndexOf5G !== -1 && checkSSIDAvailable(guestInfoIndexOf5G)) {
            guestWifienable5g = 1;
        } else {
            guestWifienable5g = 0;
        }
        setCheck('guestWifiEnableSwitch_5G', guestWifienable5g);
    }

    var wifiPasswordMask='<%HW_WEB_GetWlanPsdMask();%>';
    function displayPasswordEnable() {
        setCheck('displaypassword_2G',1);
        setCheck('displaypassword_5G',1);
        if(wifiPasswordMask === '1') {
            setDisable('displaypassword_2G',1);
            setDisable('displaypassword_5G',1);
        } else {
            setDisable('displaypassword_2G',0);
            setDisable('displaypassword_5G',0);
        }
        setPasswordDisplay('2G');
        setPasswordDisplay('5G');
    }

    function showOrHideText(checkBoxId, passwordId, textId) {
        if (1 == getCheckVal(checkBoxId)) {
            setDisplay(passwordId, 1);
            setDisplay(textId, 0);
        } else {
            setDisplay(passwordId, 0);
            setDisplay(textId, 1);
        }
    }

    function CheckPskLenValid(value) {
        if ((megacablePwd == 1) && (curUserType == '0') && (value == "********")) {
            return true;
        }

        if (isValidWPAPskKey(value) == false) {
            if (megacablePwd == 1) {
                AlertEx(cfg_wlancfgdetail_language['amp_wpskey_invalid_telmex']);
            } else if (CfgMode.toUpperCase() === "GNVDF") {
                AlertEx(cfg_wlancfgdetail_language['amp_wpskey_invalid_gn']);
            } else {
                AlertEx(cfg_wlancfgdetail_language['amp_wpskey_invalid']);
            }
            return false;
        }

        return true;
    }

    function checkPskValid(authmode, freDesc) {
        var value = getSelectVal('pwd_ssidpassword_' + freDesc);
        if (authmode === 'open') {
            return true;
        }
        if (value === '') {
            AlertEx(cfg_guest_wifi['guest_wifi_PreSharedKey_valid']);
            return false;
        }

        if (AmpTDESepicalCharaterFlag == true) {
            if (isValidWPAPskSepcialKey(value) != true) {
                return false;
            }
        } else {
            if ((wifiPasswordMask !== '1') || (value !== '********')) {
                if (CfgMode.toUpperCase() === "EGVDF2") {
                    if (checkPasswordStrength('pwd_ssidpassword_' + freDesc) < 2) {
                        AlertEx(cfg_wlancfgdetail_language['amp_encrypt_keynote_eg']);
                        return false;
                    }
                } else if (CfgMode.toUpperCase() === "GNVDF") {
                    if (checkPasswordStrength('pwd_ssidpassword_' + freDesc) < 2) {
                        AlertEx(cfg_wlancfgdetail_language['amp_encrypt_keynote_eg_gn']);
                        return false;
                    }
                }
            }
            if ((authmode == 'wpa3-psk') || (authmode == 'wpa2/wpa3-psk')) {
                if ((isValidWPAPskKey(value) == false) || (value.length == 64)) {
                    AlertEx(cfg_wlancfgdetail_language['amp_wpskey_invalid_63']);
                    return false;
                }
            } else {
                if (CheckPskLenValid(value) != true){
                    return false;
                }
            }

            if (preflag == 1) {
                if ((wifiPasswordMask !== '1') || (value !== '********')) {
                    if (IsPskKeyValid_PLDT(getElementById('pwd_ssidpassword_' + freDesc).value) == false) {
                        AlertEx(cfg_wlancfgdetail_language['amp_wpskey_invalid_pldt']);
                        return false;
                    }
                }
            }
        }
        return true;
    }

    function getGuestWifiOperateType(freDesc, dualBandState) {
        var guestWifienable;
        var guestInfoIndex;
        if (freDesc === '2G') {
            guestWifienable = guestWifienable2g;
            guestInfoIndex = guestInfoIndexOf2G;
        } else {
            guestWifienable = (dualBandState === 1? guestWifienable2g : guestWifienable5g);
            guestInfoIndex = guestInfoIndexOf5G;
        }
        if (guestWifienable === 1 && guestInfoIndex === -1) {
            return 'add';
        } else if (guestWifienable === 1 && guestInfoIndex !== -1) {
            return 'set';
        } else if (guestWifienable === 0 && guestInfoIndex !== -1) {
            return 'disable';
        } else {
            return '';
        }
    }

    function isValIdRule(val) {
        var reg = /^[A-Za-z0-9-]+$/;
        if(val.match(reg)) {
            return val;
        } else {
            return '';
        }
    }

    function isValPWDRule(val) {
        var reg = /^[A-Za-z0-9]+$/;
        if(val.match(reg)) {
            return val;
        } else {
            return '';
        }
    }

    function passwordChange(freDesc, dualBandState) {
        if (getSelectValExtend('wlAuthMode_', freDesc, dualBandState) === 'open') {
            return false;
        }
        var pskValue = getSelectValExtend('pwd_ssidpassword_', freDesc, dualBandState);
        if (wifiPasswordMask === '1' && pskValue === '********') {
            return false;
        }
        return true;
    }

    function ltrim(str) { 
        if(0 == trimssidFlag) {
            return str.toString().replace(/(^\s*)/g,""); 
        } else {
            return str.toString();
        } 
    }

    var checkIsSameBandSSID = function(wlanObj, band) {
      var instNum = getInstIdByDomain(wlanObj.domain);
      var curBand = is2GSSID(instNum)? '2G' : '5G';
      return curBand === band? true : false;
    }

    var isGuestSSIDIndex = function(index) {
      if ((ssidIndexOf2G !== -1 && index === WlanArrIndexOf2G)
         || (ssidIndexOf5G !== -1 && index === WlanArrIndexOf5G)) {
        return true;
      }

      return false;
    }

    var checkIsDupSSID = function(index, ssid, dualBandState, band) {
      if (isGuestSSIDIndex(index)) {
        return false;
      }

      var wlanObj = WlanArr[index];
      var existSSID = wlanObj.SSID;
      if (dualBandState === 1 || checkIsSameBandSSID(wlanObj, band)) {
        return existSSID === ssid? true : false;
      }

      return false;
    }

    function checkSSID(freDesc, dualBandState, operateType) {
        var ssid = getValue('ssidname_' + freDesc);
        var AuthModeCheck = getSelectVal('wlAuthMode_' + freDesc);

        if(1 == DslTalkTalkFlag) {
            if(isValIdRule(ssid) == '') {
                AlertEx(cfg_wlancfgother_language['amp_ttd_ssid_check']);
                return false;
            }

            if ((AuthModeCheck == 'wpa-psk') || (AuthModeCheck == 'wpa2-psk') || (AuthModeCheck == 'wpa/wpa2-psk') || (AuthModeCheck == 'wpa3-psk') || (AuthModeCheck == 'wpa2/wpa3-psk')) {
                if(isValPWDRule(getValue('twlWpaPsk')) == '') {
                    AlertEx(cfg_wlancfgother_language['amp_ttd_pwd_check']);
                    return false;
                }
            }
        }

        ssid = ltrim(ssid);
    
        if (ssid == '') {
            AlertEx(cfg_wlancfgother_language['amp_empty_ssid']);
            return false;
        }

        if (ssid.length > 32) {
            AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_too_loog']);
            return false;
        }
        
        if (1 == DslTalkTalkFlag) {
            if (ssid.length < 3) {
                AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_too_short']);
                return false;
            }
        }
        
        if(true == AmpTDESepicalCharaterFlag) {
            if (true != checkSepcailStrValid(ssid)) {
                AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_invalid']);
                return false;
            }
        
            if(getTDEStringActualLen(ssid) > 32) {
                AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_too_loog']);
                return false;
            }
        } else {
            if ((isBponFlag != 1) && (curLanguage.toUpperCase() != "CHINESE"))
            {
                if (isValidAscii(ssid) != '')
                {
                    AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_invalid'] + isValidAscii(ssid));
                    return false;
                }
            } else {
                if (GetChineseNumLength(ssid) > 32) {
                    AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_too_loog']);
                    return false;
                }
            }

        }
        var index;
        if (freDesc === '2G') {
            index = WlanArrIndexOf2G;
        } else {
            index = WlanArrIndexOf5G;
        }
        
        for (i = 0; i < WlanArr.length - 1; i++) {
          if (checkIsDupSSID(i, ssid, dualBandState, freDesc)) {
            AlertEx(cfg_wlancfgother_language['amp_ssid_exist']);
            return false;
          }
        }
        return true;
    }

    function checkDuration(freDesc) {
        var durationTime = getValue('duration_' + freDesc);
        if(!isInteger(durationTime)) {
            AlertEx(cfg_wlanguestwifi_language['amp_wlan_ptvdf_guestwifi_duration_invalid']);
            return false;
        }

        var duration = parseInt(durationTime);
        if(duration < 0 || duration > 24) {
            AlertEx(cfg_wlanguestwifi_language['amp_wlan_ptvdf_guestwifi_duration_invalid']);
            return false;
        }
        return true;
    }

    function checkStreamRateValue(freDesc) {
        var UpstreamRate = getValue('uplinkRateLimit_' + freDesc);
        var DownstreamRate = getValue('downlinkRateLimit_' + freDesc);

        if(!isInteger(UpstreamRate)) {
            AlertEx(cfg_wlanguestwifi_language['amp_uprate_int']);
            return false;
        }

        if( (parseInt(UpstreamRate,10) < 0) || (parseInt(UpstreamRate,10) > 4094) ) {
            AlertEx(cfg_wlanguestwifi_language['amp_uprate_out_range']);
            return false;
        }

        if(!isInteger(DownstreamRate)) {
            AlertEx(cfg_wlanguestwifi_language['amp_downrate_int']);
            return false;
        }

        if( (parseInt(DownstreamRate,10) < 0) || (parseInt(DownstreamRate,10) > 4094) ) {
            AlertEx(cfg_wlanguestwifi_language['amp_downrate_out_range']);
            return false;
        }

        return true;
    }

    function getGuestInstNum(index) {
        var instNum = GuestWifiArr[index].domain.substring(GuestWifiArr[index].domain.lastIndexOf('.') + 1);
        return instNum;
    }

    function syncGuestWifiToAPs(operateTypeOf2G, operateTypeOf5G) {
        var instNum;
        if (operateTypeOf2G !== '') {
            if (operateTypeOf2G === 'add') {
                if (guestInfoIndexOf5G === -1) {
                    guestInfoIndexOf2G = 0;
                    instNum = 1;
                } else {
                    if (getGuestInstNum(guestInfoIndexOf5G) === '1') {
                        instNum = 2;
                    } else {
                        instNum = 1;
                    }
                }
            } else {
                instNum = getGuestInstNum(guestInfoIndexOf2G);
            }
            if (operateTypeOf2G !== '') {
                $.ajax({
                    type : "POST",
                    async : false,
                    cache : false,
                    url : 'syncGuestWifiToAPs.cgi?RequestFile=/html/amp/wlanbasic/WlanGuestWifiConfig.asp',
                    data :'ControType=' + operateTypeOf2G + '&Guest2GInst=' + instNum + '&x.X_HW_Token=' + getValue('onttoken'),
                    success : function(data) {
                    }
                });
            }
        }

        if (operateTypeOf5G !== '') {
            if (operateTypeOf5G === 'add') {
                if ((operateTypeOf2G === 'disable') || (guestInfoIndexOf2G === -1)) {
                    instNum = 1;
                } else if (GuestWifiArr.length <= 1) {
                    instNum = 2;
                } else {
                    if (getGuestInstNum(guestInfoIndexOf2G) === '1') {
                        instNum = 2;
                    } else {
                        instNum = 1;
                    }
                }
            } else {
                instNum = getGuestInstNum(guestInfoIndexOf5G);
            }

            if (operateTypeOf5G !== '') {
                $.ajax({
                    type : "POST",
                    async : false,
                    cache : false,
                    url : '/syncGuestWifiToAPs.cgi?RequestFile=/html/amp/wlanbasic/WlanGuestWifiConfig.asp',
                    data :'ControType=' + operateTypeOf5G + '&Guest5GInst=' + instNum + '&x.X_HW_Token=' + getValue('onttoken'),
                    success : function(data) {
                    }
                });
            }
        }
    }


    var getSelectValExtend = function(id, band, dualBandState) {
      if (dualBandState === 1) {
        return getSelectVal(id + '2G');
      }

      return getSelectVal(id + band);
    }

    var updateCurOptSSIDInst = function(band) {
      if ((ssidIndexOf2G === -1 && band === 'band2G')
         || (ssidIndexOf5G === -1 && band === 'band5G')) {
        g_guestWifiInst.updateCurOptInst(band);
      }
    }

    var checkSubmitState = function(operateTypeOf2G, operateTypeOf5G) {
      if (g_guestWifiInst.getCurOptInst('band2G') === -1 && g_guestWifiInst.getCurOptInst('band5G') === -1) {
        AlertEx(cfg_guest_wifi['guest_wifi_title_NO_SSID']);
        return false;
      }

      if (operateTypeOf2G !=='' && g_guestWifiInst.getCurOptInst('band2G') === -1) {
        AlertEx(cfg_guest_wifi['guest_wifi_notice_NO_2G']);
      }

      if (operateTypeOf5G !== '' && g_guestWifiInst.getCurOptInst('band5G') === -1) {
        AlertEx(cfg_guest_wifi['guest_wifi_notice_NO_5G']);
      }

      return true;
    }

    var controlButtonState = function(state) {
      $('#btnApplySubmit').attr('disabled', state);
      $('#cancel').attr('disabled', state);
    }

    var btnApplySubmitEx = function() {
      controlButtonState(true);
      setTimeout(function() {
        btnApplySubmit();
      }, 100);
    }

    var getAllSubmitInfo = function(operateType, authmode, band, dualBandState) {
      var ssidInfo =  getSSIDSubmit(authmode, band, dualBandState, operateType);
      var url = ssidInfo.url;
      var formDate = ssidInfo.formDate;
      if (passwordChange(band, dualBandState)) {
        var passSubmitInfo = getPassword(band, dualBandState);
        url += passSubmitInfo.url;
        formDate += passSubmitInfo.formDate;
      }
      
      var guestInfo = setGuestSubmit(operateType, band, dualBandState);
      url += guestInfo.url;
      formDate += guestInfo.formDate;

      var allSubmitInfo = {};
      allSubmitInfo.url = url;
      allSubmitInfo.formDate = formDate;
      return allSubmitInfo;
    }

    function btnApplySubmit() {
        var dualBandState = getCheckVal('splitSsidEnable');
        var operateTypeOf2G = getGuestWifiOperateType('2G', dualBandState);
        var operateTypeOf5G = getGuestWifiOperateType('5G', dualBandState);
        if (operateTypeOf2G === '' && operateTypeOf5G === '') {
            window.location.reload();
            return;
        }

        var authmodeOf2G = getSelectValExtend('wlAuthMode_', '2G', dualBandState);
        var authmodeOf5G = getSelectValExtend('wlAuthMode_', '5G', dualBandState);

        if ((operateTypeOf2G === 'set' || operateTypeOf2G === 'add')) {
            if (!(checkPskValid(authmodeOf2G, '2G') && checkSSID('2G', dualBandState, operateTypeOf2G) && checkDuration('2G') &&
                  checkStreamRateValue('2G'))) {
                controlButtonState(false);
                return;
            }
            updateCurOptSSIDInst('band2G');
            if (dualBandState === 1) {
                updateCurOptSSIDInst('band5G');
            }
        }

        if ((dualBandState === 0) && (operateTypeOf5G === 'set' || operateTypeOf5G === 'add')) {
            if (!(checkPskValid(authmodeOf5G, '5G') && checkSSID('5G', dualBandState, operateTypeOf5G) && checkDuration('5G') && 
                  checkStreamRateValue('5G'))) {
                controlButtonState(false);
                return;
            }
            updateCurOptSSIDInst('band5G');
        }

        if (!checkSubmitState(operateTypeOf2G, operateTypeOf5G)) {
          controlButtonState(false);
          return;
        }

        var url = 'complexajax.cgi?w=InternetGatewayDevice.X_HW_DEBUG.AMP.WifiCoverSetWlanBasic&';
        var formDate = '';
        if (operateTypeOf2G !== '') {
          var band2GSubmitInfo = getAllSubmitInfo(operateTypeOf2G, authmodeOf2G, '2G', dualBandState);
          url += band2GSubmitInfo.url;
          formDate += band2GSubmitInfo.formDate;
        }

        if (operateTypeOf5G !== '') {
          var band5GSubmitInfo = getAllSubmitInfo(operateTypeOf5G, authmodeOf5G, '5G', dualBandState);
          url += band5GSubmitInfo.url;
          formDate += band5GSubmitInfo.formDate;
        }

        var requestObj = {};
        url = url.substring(0, url.length - 1);
        requestObj.postData = formDate + 'x.X_HW_Token=' + getValue('onttoken');
        requestObj.requestUrl = url + '&RequestFile=/html/amp/wlanbasic/WlanGuestWifiConfig.asp',
        requestObj.async = false;
        var self = this;
        ajaxPostData(requestObj, function(data) {
          if (data.indexOf('200') !== -1) {
            syncGuestWifiToAPs(operateTypeOf2G, operateTypeOf5G);
          } else {
            AlertEx(cfg_guest_wifi['invalid_param']);
          }
          window.location.reload();
        });
    }

    var getSSIDDomainPath = function(band) {
      return 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.' + g_guestWifiInst.getCurOptInst(getBandKey(band));
    }

    function getSSIDInfo(freDesc, dualBandState, operateType) {
      var SSIDInfo = {};
      var ssid = getSelectValExtend('ssidname_', freDesc, dualBandState);
      SSIDInfo.enable = operateType === 'disable'? 0 : 1;
      SSIDInfo.domain = getSSIDDomainPath(freDesc);
      SSIDInfo.ssid = ssid;
      SSIDInfo.ssidAdvertisementEnabled = 1;
      return SSIDInfo;
    }

    function getSSIDSubmit(authMode, freDesc, dualBandState, operateType) {
        var SSIDInfoSubmitInfo = {};
        var SSIDInfo = getSSIDInfo(freDesc, dualBandState, operateType);
        var pre;
        var suffix = '';
        var wlanArrIndex;
        if (freDesc === '2G') {
            pre = 'y';
            wlanArrIndex = WlanArrIndexOf2G;
            has2GSubmit = 1;
        } else {
            pre = 'x';
            if (has2GSubmit === 1) {
                suffix = '5G';
                has2GSubmit = 0;
            }
            wlanArrIndex = WlanArrIndexOf5G;
        }
        var formDate = '';
        var encryptionMode = getSelectValExtend('wlEncryption_', freDesc, dualBandState);
        formDate += pre + '.Enable=' + SSIDInfo.enable + '&';
        formDate += pre + '.SSID=' + encodeURIComponent(SSIDInfo.ssid) + '&';
        formDate += pre + '.SSIDAdvertisementEnabled=' + SSIDInfo.ssidAdvertisementEnabled + '&';
        formDate += 'w.SsidInst' + suffix + '=' + g_guestWifiInst.getCurOptInst(getBandKey(freDesc)) + '&';
        formDate += 'w.SSID' + suffix + '=' + encodeURIComponent(SSIDInfo.ssid) + '&';
        formDate += 'w.Enable' + suffix + '=' + SSIDInfo.enable + '&';
        formDate += 'w.SSIDAdvertisementEnabled' + suffix + '=' + SSIDInfo.ssidAdvertisementEnabled + '&';
        if (authMode == 'open') {
            if (WPS20AuthSupported === '1') {
                if (ConfirmEx('Security is not set, continue?') == false) {
                    return false;
                }
            }
            formDate += pre + '.BeaconType=Basic' + '&';
            formDate += pre + '.BasicAuthenticationMode=None' + '&';
            formDate += pre + '.BasicEncryptionModes=' + encryptionMode + '&';
            formDate += 'w.BeaconType' + suffix + '=Basic' + '&';
            formDate += 'w.BasicAuthenticationMode' + suffix + '=None' + '&';
            formDate += 'w.BasicEncryptionModes' + suffix + '=' + encryptionMode + '&';
        } else if (authMode == 'wpa-psk') {
            formDate += pre + '.BeaconType=WPA' + '&';
            formDate += pre + '.WPAAuthenticationMode=PSKAuthentication' + '&';
            formDate += pre + '.WPAEncryptionModes=' + encryptionMode + '&';
            formDate += 'w.BeaconType' + suffix + '=WPA' + '&';
            formDate += 'w.WPAAuthenticationMode' + suffix + '=PSKAuthentication' + '&';
            formDate += 'w.WPAEncryptionModes' + suffix + '=' + encryptionMode + '&';
        } else if (authMode == 'wpa2-psk') {
            formDate += pre + '.BeaconType=11i' + '&';
            formDate += pre + '.IEEE11iAuthenticationMode=PSKAuthentication' + '&';
            formDate += pre + '.IEEE11iEncryptionModes=' + encryptionMode + '&';
            formDate += 'w.BeaconType' + suffix + '=11i' + '&';
            formDate += 'w.IEEE11iAuthenticationMode' + suffix + '=PSKAuthentication' + '&';
            formDate += 'w.IEEE11iEncryptionModes' + suffix + '=' + encryptionMode + '&';
        } else if (authMode == 'wpa/wpa2-psk') {
            formDate += pre + '.BeaconType=WPAand11i' + '&';
            formDate += pre + '.X_HW_WPAand11iAuthenticationMode=PSKAuthentication' + '&';
            formDate += pre + '.X_HW_WPAand11iEncryptionModes=' + encryptionMode + '&';
            formDate += 'w.BeaconType' + suffix + '=WPAand11i' + '&';
            formDate += 'w.MixAuthenticationMode' + suffix + '=PSKAuthentication' + '&';
            formDate += 'w.MixEncryptionModes' + suffix + '=' + encryptionMode + '&';
        } else if (authMode == 'wpa3-psk') {
            formDate += pre + '.BeaconType=WPA3' + '&';
            formDate += pre + '.X_HW_WPAand11iAuthenticationMode=SAEAuthentication' + '&';
            formDate += pre + '.X_HW_WPAand11iEncryptionModes=' + encryptionMode + '&';
            formDate += 'w.BeaconType' + suffix + '=WPA3' + '&';
            formDate += 'w.MixAuthenticationMode' + suffix + '=SAEAuthentication' + '&';
            formDate += 'w.MixEncryptionModes' + suffix + '=' + encryptionMode + '&';
        } else if (authMode == 'wpa2/wpa3-psk') {
            formDate += pre + '.BeaconType=WPA2/WPA3' + '&';
            formDate += pre + '.X_HW_WPAand11iAuthenticationMode=PSKandSAEAuthentication' + '&';
            formDate += pre + '.X_HW_WPAand11iEncryptionModes=' + encryptionMode + '&';
            formDate += 'w.BeaconType' + suffix + '=WPA2/WPA3' + '&';
            formDate += 'w.MixAuthenticationMode' + suffix + '=PSKandSAEAuthentication' + '&';
            formDate += 'w.MixEncryptionModes' + suffix + '=' + encryptionMode + '&';
        } else if (authMode == 'wapi') {
            formDate += pre + '.BeaconType=X_HW_WAPI' + '&';
            formDate += pre + '.X_HW_WAPIAuthenticationMode=WAPICERT' + '&';
            formDate += pre + '.X_HW_WAPIEncryptionModes=SMS4' + '&';
            formDate += pre + '.X_HW_WAPIServer=' + WlanArr[wlanArrIndex].X_HW_WAPIServer + '&';
            formDate += pre + '.X_HW_WAPIPort=' + WlanArr[wlanArrIndex].X_HW_WAPIPort + '&';
            formDate += 'w.BeaconType' + suffix + '=X_HW_WAPI' + '&';
        } else if (AuthMode == 'wapi-psk') {
            formDate += pre + '.BeaconType=X_HW_WAPI' + '&';
            formDate += pre + '.X_HW_WAPIAuthenticationMode=WAPIPSK' + '&';
            formDate += pre + '.X_HW_WAPIEncryptionModes=SMS4' + '&';
            formDate += 'w.BeaconType' + suffix + '=X_HW_WAPI' + '&';
        }

        formDate = setDefault(formDate, suffix, encryptionMode);
        formDate = setOtherparam(formDate, suffix, freDesc);

        var url = pre + '=' + SSIDInfo.domain + '&';
        SSIDInfoSubmitInfo.formDate = formDate;
        SSIDInfoSubmitInfo.url = url;
        return SSIDInfoSubmitInfo;
    }

    function setOtherparam(formDate, suffix, freDesc) {
        var wanIndex;
        if (freDesc === '2G') {
            wanIndex = WlanArrIndexOf2G;
        } else {
            wanIndex = WlanArrIndexOf5G;
        }

        formDate += 'w.WMMEnable' + suffix + '=' + WlanArr[wanIndex].wmmEnable + '&';
        return formDate;
    }

    function setDefault(formDate, suffix, encryptionMode) {
        if (formDate.indexOf('w.BasicAuthenticationMode') === -1) {
            formDate += 'w.BasicAuthenticationMode' + suffix + '=None' + '&';
        }
        if (formDate.indexOf('w.BasicEncryptionModes') === -1) {
            formDate += 'w.BasicEncryptionModes' + suffix + '=' + encryptionMode + '&';
        }
        if (formDate.indexOf('w.WPAAuthenticationMode') === -1) {
            formDate += 'w.WPAAuthenticationMode' + suffix + '=EAPAuthentication' + '&';
        }
        if (formDate.indexOf('w.WPAEncryptionModes') === -1) {
            formDate += 'w.WPAEncryptionModes' + suffix + '=' + encryptionMode + '&';
        }
        if (formDate.indexOf('w.IEEE11iAuthenticationMode') === -1) {
            formDate += 'w.IEEE11iAuthenticationMode' + suffix + '=EAPAuthentication' + '&';
        }
        if (formDate.indexOf('w.IEEE11iEncryptionModes') === -1) {
            formDate += 'w.IEEE11iEncryptionModes' + suffix + '=' + encryptionMode + '&';
        }
        if (formDate.indexOf('w.MixAuthenticationMode') === -1) {
            formDate += 'w.MixAuthenticationMode' + suffix + '=EAPAuthentication' + '&';
        }
        if (formDate.indexOf('w.MixEncryptionModes') === -1) {
            formDate += 'w.MixEncryptionModes' + suffix + '=' + encryptionMode + '&';
        }

        return formDate;
    }

    function getPassword(freDesc, dualBandState) {
        var passwordSubmitInfo = {};
        var pre;
        var index;
        var suffix = '';
        if (freDesc === '2G') {
            pre = 'm';
            index = WlanArrIndexOf2G;
        } else {
            pre = 'n';
            index = WlanArrIndexOf5G;
            suffix = '5G';
        }

        var passwordFromText = getSelectValExtend('pwd_ssidpassword_', freDesc, dualBandState);
        var password =  pre + '.PreSharedKey=' + encodeURIComponent(passwordFromText) + '&';
        password += 'w.Key' + suffix + '=' + encodeURIComponent(passwordFromText) + '&';
        var url = pre + '=' + getSSIDDomainPath(freDesc) + '.PreSharedKey.1' + '&';
        passwordSubmitInfo.formDate = password;
        passwordSubmitInfo.url = url;
        return passwordSubmitInfo;
    }

    function getCheckValExtend(id, band, dualBandState) {
      var realId = dualBandState === 1? id + '2G' : id + band;
      var element = getElement(realId);
      if (element == null) {
       return -1;
      }

      return element.checked ? 1 : 0;
    }

    function getGuestInfo(freDesc, dualBandState) {
        var guestInfo = {};
        var duration = getSelectValExtend('duration_', freDesc, dualBandState);
        var uplinkRateLimit = getSelectValExtend('uplinkRateLimit_', freDesc, dualBandState);
        var downlinkRateLimit = getSelectValExtend('downlinkRateLimit_', freDesc, dualBandState);
        guestInfo.duration = parseInt(duration) * 60;
        guestInfo.uplinkRateLimit = parseInt(uplinkRateLimit);
        guestInfo.downlinkRateLimit = parseInt(downlinkRateLimit);
        return guestInfo;
    }

    function setGuestSubmit(operate, freDesc, dualBandState) {
        var guestSubmitInfo = {};
        var guestInfo = getGuestInfo(freDesc, dualBandState);
        var pre;
        if (freDesc === '2G') {
            pre = 'a';
        } else {
            pre = 'b';
        }
        var domain = 'InternetGatewayDevice.LANDevice.1.X_HW_WLANForGuest';
        var formDate = '';
        var url = '';
        switch (operate) {
            case 'add' : {
                pre = 'Add_' + pre;

                formDate += pre + '.SSID_IDX=' + g_guestWifiInst.getCurOptInst(getBandKey(freDesc)) + '&';
                formDate += pre + '.PortIsolation=1' + '&';
                formDate += pre + '.Duration=' + guestInfo.duration + '&';
                formDate += pre + '.UpRateLimit=' + guestInfo.uplinkRateLimit + '&';
                formDate += pre + '.DownRateLimit=' + guestInfo.downlinkRateLimit + '&';
                url = pre + '=' + domain + '&';
                break;
            };
            case 'set' : {
                if (freDesc === '2G') {
                    domain = GuestWifiArr[guestInfoIndexOf2G].domain;
                } else {
                    domain = GuestWifiArr[guestInfoIndexOf5G].domain;
                }
                pre = 'Set_' + pre;

                formDate += pre + '.SSID_IDX=' + g_guestWifiInst.getCurOptInst(getBandKey(freDesc)) + '&';
                formDate += pre + '.PortIsolation=1' + '&';
                formDate += pre + '.Duration=' + guestInfo.duration + '&';
                formDate += pre + '.UpRateLimit=' + guestInfo.uplinkRateLimit + '&';
                formDate += pre + '.DownRateLimit=' + guestInfo.downlinkRateLimit + '&';
                url = pre + '=' + domain + '&';
                break;
            };
            case 'disable' : {
                break;
            }
        }

        guestSubmitInfo.formDate = formDate;
        guestSubmitInfo.url = url;
        return guestSubmitInfo;
    }

    function cancelValue() {
        getWlanArrIndexs();
        initGuestWifiInfos();
        initGuestWifiEnable();
        displayAll();
    }

    function enableAutoExtendGuest() {
        var Form = new webSubmitForm();
        Form.addParameter('x.AutoExtendGuestWifi', getCheckVal('AutoExtendGuestEnable'));
        Form.setAction('set.cgi?'
                    + 'x=' + 'InternetGatewayDevice.X_HW_WifiCoverService'
                    + '&RequestFile=/html/amp/wlanbasic/WlanGuestWifiConfig.asp');
        Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.submit();
    }

    function funProtectionmodeSelect(freDesc) {
        var hidewlWpaPskNote = '';
        if (freDesc === '2G') {
            hidewlWpaPskNote = 'hidewlWpaPsk_note_2G';
        } else {
            hidewlWpaPskNote = 'hidewlWpaPsk_note_5G';
        }
        var value = getSelectVal('wlAuthMode_' + freDesc);
        changeauthandpassword(value, freDesc);
        if (value === 'open') {
            addEncryMethodOption(value, freDesc);
            setSelect('wlEncryption','None');
        } else if ((value === "wpa-psk") || (value === "wpa2-psk") || (value === "wpa/wpa2-psk") || (value === "wpa3-psk") || (value === "wpa2/wpa3-psk")) {
            if ((value == "wpa3-psk") || (value == "wpa2/wpa3-psk")) {
                addEncryMethodOption("wpa3", freDesc);
            } else {
                if (PccwFlag == 1) {
                    addEncryMethodOption(value, freDesc);
                } else {
                    addEncryMethodOption("psk", freDesc);
                }
            }
            
            HidewlWpaPskDisplayBaseAuthMode(value, hidewlWpaPskNote);
        } else if ((value === 'wapi-psk') || (value === 'wapi')) {
            addWapiEncryMethodOption(freDesc);
        }
    }

    function changeauthandpassword(value, freDesc) {
        displayPasswordEnable();
        if (value == 'open') {
            setDisplay('wpakeyInfo_' + freDesc, 0);
            setText('pwd_ssidpassword_' + freDesc, "");
            setText('txt_ssidpassword_' + freDesc, "");
        } else {
            setDisplay('wpakeyInfo_' + freDesc, 1);
            var index;
            if (freDesc === '2G') {
                index = WlanArrIndexOf2G;
            } else {
                index = WlanArrIndexOf5G;
            }
            setText('pwd_ssidpassword_' + freDesc, wpaPskKey[index] && wpaPskKey[index].value);
            setText('txt_ssidpassword_' + freDesc , wpaPskKey[index] && wpaPskKey[index].value);
        }
    }

    function IsAuthModeWithoutOpen() {
        if (((CfgMode.toUpperCase() == 'DTURKCELL2WIFI') || (turkcellFlag == 1)) && (curUserType == sptUserType)) {
            return true;
        }

        return false;
    }

    function addAuthModeOption(id) {
        initWlanCap(id);
        var mode = WlanWifi.mode;
        var auth = getSelectVal('wlAuthMode_' + id);
        if ('1' == WPS20AuthSupported)
        {
            capWPAPSK = 0;
            capWPAWPA2PSK = 0;
            capWPAEAP = 0;
            capWPAWPA2EAP = 0;
            wepCap = 0;
        }	
        
        if ('1' == nonWepFlag)
        {
            wepCap = 0;
        }

        var authModes = { 'open' : [cfg_wlancfgdetail_language['amp_auth_open'], 1], 
                        'wpa-psk' : [cfg_wlancfgdetail_language['amp_auth_wpapsk'], (capWPAPSK == 1) && (WPAPSKFlag == '1')], 
                        'wpa2-psk' : [cfg_wlancfgdetail_language['amp_auth_wpa2psk'], 1], 
                        'wpa/wpa2-psk' : [cfg_wlancfgdetail_language['amp_auth_wpawpa2psk'], (capWPAWPA2PSK == 1)], 
                        'wpa3-psk' : [cfg_wlancfgdetail_language['amp_auth_wpa3psk'], (capWpa3 == 1)], 
                        'wpa2/wpa3-psk' : [cfg_wlancfgdetail_language['amp_auth_wpa2wpa3psk'], (capWpa3 == 1)], 
                        'wapi-psk' : [cfg_wlancfgdetail_language['amp_auth_wapi_psk'], 1], 
                        'wapi' : [cfg_wlancfgdetail_language['amp_auth_wapi'], 1]
                        };

        if ((CfgMode.toUpperCase() == 'EGVDF2') || (CfgMode.toUpperCase() == 'GNVDF')) {
            authModes = { 'wpa-psk' : [cfg_wlancfgdetail_language['amp_auth_wpapsk'], (capWPAPSK == 1) && (WPAPSKFlag == '1')], 
                        'wpa2-psk' : [cfg_wlancfgdetail_language['amp_auth_wpa2psk'], 1], 
                        'wpa/wpa2-psk' : [cfg_wlancfgdetail_language['amp_auth_wpawpa2psk'], (capWPAWPA2PSK == 1)], 
                        'wpa3-psk' : [cfg_wlancfgdetail_language['amp_auth_wpa3psk'], (capWpa3 == 1)], 
                        'wpa2/wpa3-psk' : [cfg_wlancfgdetail_language['amp_auth_wpa2wpa3psk'], (capWpa3 == 1)], 
                        'wapi-psk' : [cfg_wlancfgdetail_language['amp_auth_wapi_psk'], 1], 
                        'wapi' : [cfg_wlancfgdetail_language['amp_auth_wapi'], 1]
                        };
        }

        var ssidIndex = -1;
        if (IsAuthModeWithoutOpen()) {
            var record = -1;
            if (id === '2G') {
                ssidIndex = WlanArrIndexOf2G;
            } else {
                ssidIndex = WlanArrIndexOf5G;
            }

            var BasicAuthenticationMode = WlanArr[ssidIdx].BasicAuthenticationMode;
            var BeaconType = WlanArr[ssidIdx].BeaconType;

            if (((BasicAuthenticationMode == 'None') || (BasicAuthenticationMode == 'OpenSystem')) && (BeaconType == 'Basic')) {
                authModes['open'][0] = "";
            }

            if (!(((BasicAuthenticationMode == 'None') || (BasicAuthenticationMode == 'OpenSystem')) && (BeaconType == 'Basic'))) {
                authModes['open'][1] = 0;
            }
        }

        if (cap11ax != 1) {
            authModes['wpa3-psk'][1] = 0;
            authModes['wpa2/wpa3-psk'][1] = 0;
        }

        if ('ANTEL' == CfgMode.toUpperCase() || 'ANTEL2' == CfgMode.toUpperCase()) {
            authModes['open'][1] = 0;
            authModes['wapi-psk'][1] = 0;
            authModes['wapi'][1] = 0;
        }

        if(('SAFARICOM2' == CfgMode.toUpperCase()) || ('SAFARICOM' == CfgMode.toUpperCase()))
        {
            authModes['open'][1] = 0;
            authModes['wpa-psk'][1] = 0;
            authModes['wpa/wpa2-psk'][1] = 0;
        }
        
        if((1 != WapiFlag) || (0 == wapiCap))
        {
            authModes['wapi-psk'][1] = 0;
            authModes['wapi'][1] = 0;
        }

        InitDropDownListWithSelected('wlAuthMode_' + id, authModes, auth);

        if (ttnet2Flag == 1) {
            ModifyAuthAndEncryMode(ssidIndex, id);
        }
    }

    function ModifyAuthAndEncryMode(ssidIndex, id) {
        if (ssidIndex == -1) {
            return;
        }

        var elem = "wlAuthMode_" + id;

        var beaconType = WlanArr[ssidIndex].BeaconType;
        if (beaconType == 'Basic') {
            var basicAuthenticationMode = WlanArr[ssidIndex].BasicAuthenticationMode;
            var basicEncryptionModes = WlanArr[ssidIndex].BasicEncryptionModes;
            if ((basicAuthenticationMode == 'None') || (basicEncryptionModes == 'OpenSystem')) {
                var index = getOptionIndex(elem, 'open');
                if (index < 0) {
                    $(elem).prepend("<option value='open'>" + cfg_wlancfgdetail_language['amp_auth_open'] + "</option>");
                }
                
                removeOption(elem, 'shared');
                if (basicEncryptionModes == 'None') {
                    removeOption('wlEncryption', 'WEPEncryption');
                } else {
                    removeOption('wlEncryption', 'None');
                }
            } else {
                var index = getOptionIndex(elem, 'shared');
                if (index < 0) {
                    $("#elem").prepend("<option value='shared'>" + cfg_wlancfgdetail_language['amp_auth_shared'] + "</option>");
                }

                removeOption(elem, 'open');
            }
        } else {
            removeOption(elem, 'open');
            removeOption(elem, 'shared');
        } 

        if (beaconType == 'WPA') {
            var wpaEncryptionModes = WlanArr[ssidIndex].WPAEncryptionModes;
            if (wpaEncryptionModes != 'TKIPEncryption') {
                removeOption('wlEncryption', 'TKIPEncryption');
            }
        }
    }

    function addEncryMethodOption(value, freDesc) {
        var len;
        var wlEncryption;
        if (freDesc === '2G') {
            len = document.forms[0].wlEncryption_2G.options.length;
            wlEncryption = document.forms[0].wlEncryption_2G;
        } else {
            len = document.forms[0].wlEncryption_5G.options.length;
            wlEncryption = document.forms[0].wlEncryption_5G;
        }
        
        var mode = WlanWifi.mode;
        if (WPS20AuthSupported === '1') {
            capTkip = 0;
        }

        for (var i = 0; i < len; i++) {
            wlEncryption.remove(0);
        }

        if (value === "open") {
            if((CfgMode.toUpperCase() !== 'SAFARICOM2') && (CfgMode.toUpperCase() !== 'SAFARICOM')){
                wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_none'], "None");
            }
        } else if (value == "wpa3") {
            wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");
        } else {
            if ((mode === "11n")|| (mode === "11aconly")) {
                wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");
            } else {
                if (PccwFlag == 1) {
                    if (value == "wpa2-psk") {
                        wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");
                    } else if(value == "wpa-psk") {
                        wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkip'], "TKIPEncryption");
                    } else if(value == "wpa/wpa2-psk") {
                        wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkipaes'], "TKIPandAESEncryption");  
                    } else {
                        wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");
                        wlEncryption[1] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkip'], "TKIPEncryption");
                        wlEncryption[2] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkipaes'], "TKIPandAESEncryption");
                    }
                } else {
                    wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_aes'], "AESEncryption");
                    if((t2Flag != 1) || (3 != getWlanInstFromDomain(currentWlan.domain))) {
                        if('1' == capTkip)
                        {
                            wlEncryption[1] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkip'], "TKIPEncryption");
                            wlEncryption[2] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkipaes'], "TKIPandAESEncryption");
                        }
                    } else {
                        wlEncryption[1] = new Option(cfg_wlancfgdetail_language['amp_encrypt_tkipaes'], "TKIPandAESEncryption");
                    }
                }
            }
        }
    }

    function addWapiEncryMethodOption(freDesc) {
        var len;
        var wlEncryption;
        if (freDesc === '2G') {
            len = document.forms[0].wlEncryption_2G.options.length;
            wlEncryption = document.forms[0].wlEncryption_2G;
        } else {
            len = document.forms[0].wlEncryption_5G.options.length;
            wlEncryption = document.forms[0].wlEncryption_5G;
        }
        for (i = 0; i < len; i++) {
            wlEncryption.remove(0);
        }
        wlEncryption[0] = new Option(cfg_wlancfgdetail_language['amp_encrypt_sms4'], "SMS4");
    }


    function getInstNumFromDomain(domain) {
        return domain.substring(domain.lastIndexOf('.') + 1);
    }

    function SsidEnable(freDesc) {
        var ssidIdx;
        if (freDesc === '2G') {
            ssidIdx = WlanArrIndexOf2G;
        } else {
            ssidIdx = WlanArrIndexOf5G;
        }
        if (WlanArr[ssidIdx].X_HW_ServiceEnable !== '1') {
            AlertEx(cfg_wlancfgother_language['amp_ssid_state']);
            setCheck('wlEnable', 0);
        }
    }

    function setHidewlWpaPskDisplay(freDesc) {
        var ssidIdx;
        var hidewlWpaPskNote = '';
        var mode = getSelectVal('wlAuthMode_' + freDesc);;
        if (freDesc === '2G') {
            ssidIdx = WlanArrIndexOf2G;
            hidewlWpaPskNote = 'hidewlWpaPsk_note_2G';
        } else {
            ssidIdx = WlanArrIndexOf5G;
            hidewlWpaPskNote = 'hidewlWpaPsk_note_5G';
        }
        
        HidewlWpaPskDisplayBaseAuthMode(mode, hidewlWpaPskNote);
    }

    function displayAll() {
        hiddenElement("tableOf2G", guestWifienable2g);
        hiddenElement("tableOf5G", guestWifienable5g);
        setHidewlWpaPskDisplay('2G');
        setHidewlWpaPskDisplay('5G');
        if (getSelectVal('wlAuthMode_2G') === 'open') {
            setDisplay('wpakeyInfo_2G', 0);
        }
        if (getSelectVal('wlAuthMode_5G') === 'open') {
            setDisplay('wpakeyInfo_5G', 0);
        }
        displayPasswordEnable();
        $("#checkinfo5Row_2G").css("display", "none");
        var pwdcheck5 = document.getElementById('checkinfo5_2G');
        pwdcheck5.innerHTML =' <div class="row hidden-pw-row" id="psd_checkpwd5_2G" style="display:none;"><div class="left" style="display: table-cell; float:left; width: 126px;"><span style="text-align:center;" class="language-string" id="pwdvalue5_2G" BindText="amp_pwd_strength_low"></span></div></div>';
        $("#checkinfo5Row_5G").css("display", "none");
        var pwdcheck5 = document.getElementById('checkinfo5_5G');
        pwdcheck5.innerHTML =' <div class="row hidden-pw-row" id="psd_checkpwd5_5G" style="display:none;"><div class="left" style="display: table-cell; float:left; width: 126px;"><span style="text-align:center;" class="language-string" id="pwdvalue5_5G" BindText="amp_pwd_strength_low"></span></div></div>';
    }

    function setWlAuthMode() {
        addAuthModeOption('2G');
        addAuthModeOption('5G');
    }

    function vdfPwdStrength(id, freDesc) {
        var checkid;
        if (freDesc === '2G') {
            checkid= "pwdvalue5_2G";
        } else {
            checkid= "pwdvalue5_5G";
        }
        egvdfPwdStrengthcheck(id, checkid);
    }
    
    function psdStrength5(id, freDesc) {
        var checkid;
        if (freDesc === '2G') {
            checkid= "pwdvalue5_2G";
        } else {
            checkid= "pwdvalue5_5G";
        }
        pwdStrengthcheck(id, checkid);
    }

    function wlanAttachConf(domain, X_HW_Backhaul)
    {
        this.domain = domain;
        this.X_HW_Backhaul = X_HW_Backhaul;
    }

    var wlanAttachConfArr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.X_HW_AttachConf, X_HW_Backhaul, wlanAttachConf);%>;
    var fttrFlag = '<%HW_WEB_GetFeatureSupport(FT_FTTR_MAIN_ONT);%>' === '1';
    var ssidMaxNumBand = parseInt('<%HW_WEB_GetSPEC(AMP_SPEC_SSID_NUM_MAX_BAND.UINT32);%>');

    var checkIsIOTSSID = function(instNum) {
      return instNum === parseInt(WifiCoverService[0].SyncIotSsidInst);
    }

    var auxWInst = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_LinkTurboInfo.AuxWlInst);%>';
    var scnInst5G = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_SCN.ScnInst5G);%>';

    var isLinkTurboSSID = function(instNum) {
      return instNum === parseInt(auxWInst);
    }

    var isSCNSSID = function(instNum) {
      return instNum === parseInt(scnInst5G);
    }

    var curBinMode = '<%HW_WEB_GetBinMode();%>';
    var checkIsAvaliableSSID = function(wlanObj, wlanAttachObj, instNum) {
      if (curBinMode === 'CMCC' && instNum === 4) {
        return false;
      }

      if (isMainSSID(wlanObj.name)) {
        return false;
      }

      if (wlanObj.enable === '1' || wlanAttachObj.X_HW_Backhaul === '1') {
        return false;
      }

      if (IsIspSsid(instNum) || checkIsIOTSSID(instNum) || isLinkTurboSSID(instNum) || isSCNSSID(instNum)) {
        return false;
      }

      return true;
    }

    var getBandKey = function(band) {
      return 'band' + band;
    }

    var initArr = function(arrLen) {
      var arr = new Array(arrLen);
      for (var i = 0; i < arr.length; i++) {
        arr[i] = 0;
      }
      return arr;
    }

    var GuestWifiInstClass = function(ssidMaxNumBand) {
      this.maxSSIDNum = ssidMaxNumBand;
      this.ssidInstPool = initArr(2 * ssidMaxNumBand),
      this.band2G = {
                     curOptInst: -1,
                     usedNum: 0,
                     avaliableSSID: [],
                     defData: {
                        LowerLayers: 'InternetGatewayDevice.LANDevice.1.WiFi.Radio.1',
                        Enable: 1,
                        SSIDAdvertisementEnabled: 1,
                        X_HW_AssociateNum: 64,
                        WMMEnable: 1,
                     }},

      this.band5G = {
                     curOptInst: -1,
                     usedNum: 0,
                     avaliableSSID: [],
                     defData: {
                        LowerLayers: 'InternetGatewayDevice.LANDevice.1.WiFi.Radio.2',
                        Enable: 1,
                        SSIDAdvertisementEnabled: 1,
                        X_HW_AssociateNum: 64,
                        WMMEnable: 1,
                     }},

      this.updateSSIDInstPool = function(inst, status) {
        if (inst < 1) {
          return;
        }

        var index = inst - 1;
        this.ssidInstPool[index] = status;
      }

      this.getNotUsedSSIDInstId = function(band) {
        var start = 0;
        var end = 0;
        if (band === 'band2G') {
          start = this.maxSSIDNum - 1;
          end = 0;
        } else {
          start = 2 * this.maxSSIDNum - 1;
          end = this.maxSSIDNum;
        }

        for (var i = start; i >= end; i--) {
          if (this.ssidInstPool[i] === 0) {
            return i + 1;
          }
        }

        var lastInst = this.ssidInstPool.length - 1;
        for (var i = lastInst; i >= 0; i--) {
          if (this.ssidInstPool[i] === 0) {
            return i + 1;
          }
        }
        return -1;
      }

      this.updateBandInfo = function(band, index, opt) {
        this.updateSSIDInstPool(index, opt);
        this.updateSSIDUsedNum(band, opt);
        this.updateAvaliableSSID(band, index, opt);
      }

      this.addSSIDInfo = function(band, index) {
        var defObj = this[band].defData;
        defObj.SSID = getSelectVal('ssidname_' + band.replace('band', ''));
        defObj.SSIDAlias = 'ath' + (index - 1);

        var requestObj = {};
        requestObj.postData = getPostDataByObj(defObj, 'x') + 'x.X_HW_Token=' + getValue('onttoken');
        requestObj.requestUrl = 'addajax.cgi?x=InternetGatewayDevice.LANDevice.1.WLANConfiguration&RequestFile=/html/amp/wlanbasic/WlanGuestWifiConfig.asp';
        requestObj.async = false;
        var self = this;
        ajaxPostData(requestObj, function(data) {
          var result = JSON.parse(hexDecode(data));
          if (result.result == 0) {
            self.updateBandInfo(band, index, 1);
            self[band].curOptInst = index;
          } else {
            console.error('add ssid inst faild');
          }
        });
      }

      this.updateCurOptInst = function(band) {
        var curBandArr = this[band].avaliableSSID;
        for (var i = 0; i < curBandArr.length; i++) {
          var index = getWlanArrIndexByInst(curBandArr[i]);
          var ssidName = WlanArr[index].SSID;
          if (/guest/i.test(ssidName)) {
            this[band].curOptInst = curBandArr[i];
            return;
          }
        }

        if (this[band].usedNum === this.maxSSIDNum && this[band].avaliableSSID.length > 0) {
          this[band].curOptInst = this[band].avaliableSSID[0];
          return;
        }

        var index = this.getNotUsedSSIDInstId(band);
        if (index === -1) {
          this[band].curOptInst = -1;
          return;
        }

        this.addSSIDInfo(band, index);
      }

      this.getCurOptInst = function(band) {
        return this[band].curOptInst;
      }

      this.setCurOptInst = function(band, index) {
        this[band].curOptInst = index;
      }

      this.removeAvaliableSSID = function(instArr, instNum) {
        for (var i = 0; i < instArr.length; i++) {
          if (instArr[i] === instNum) {
              instArr.splice(i, 1);
              return;
          }
        }
      }

      this.addAvaliableSSID = function(instArr, instNum) {
        instArr.push(instNum);
        instArr.sort(function(a, b) {
          return b - a;
        });
      }

      this.updateAvaliableSSID = function(band, instNum, opt) {
        var instArr = this[band].avaliableSSID;
        if (opt === 1) {
          this.addAvaliableSSID(instArr, instNum);
        } else {
          this.removeAvaliableSSID(instArr, instNum);
        }
      }

      this.updateSSIDUsedNum = function(band, opt) {
        if (opt === 1) {
          this[band].usedNum++;
        } else {
          this[band].usedNum--;
        }
      }

      this.initData = function(wlanArr, wlanAttachConfArr, index2G, index5G) {
        this.setCurOptInst('band2G', index2G);
        this.setCurOptInst('band5G', index5G);

        for (var i = 0; i < wlanArr.length - 1; i++) {
          var instNum = getInstIdByDomain(wlanArr[i].domain);
          var portNum = getWlanPortNumber(wlanArr[i].name);
          var band = (portNum <= (basic5GIfIndex - 1))? 'band2G' : 'band5G';
          this.updateSSIDInstPool(instNum, 1);
          this.updateSSIDUsedNum(band, 1)
          if (checkIsAvaliableSSID(wlanArr[i], wlanAttachConfArr[i], instNum)) {
            this.updateAvaliableSSID(band, instNum, 1);
          }
        }
      }
    }

    var isNeedSyncGuestToAp = function() {
      if (fttrFlag) {
        return false;
      }

      return true;
    }

    var isNotExistGuestInst = function() {
      if (guestWifienable2g === 0 && guestWifienable5g === 0) {
        return true;
      }

      return false;
    }

    function getWlanArrIndexByInst(instNum) {
        var str = '.' + instNum;
        for (var i = 0; i < WlanArr.length - 1; i++) {
          if (endsWithStr(WlanArr[i].domain, str)) {
            return i;
          }
        }

        return -1;
    }

    var getCurEncMode = function(wlanObj) {
      var beaconType = wlanObj.BeaconType;
      var basicEncMode = wlanObj.BasicEncryptionModes;
      if (beaconType === 'Basic') {
        if ((basicEncMode === 'None') || (basicEncMode === 'OpenSystem')) {
          return 'OPEN';
        }
        return 'WEP';
      }

      if (/^(WPA|WPA2|11i|WPA\/WPA2|WPAand11i)$/.test(beaconType)) {
        if (wlanObj.IEEE11iAuthenticationMode === 'EAPAuthentication') {
          return 'EAP';
        }
        return 'WPA'
      }

      if (/^(WPA3|WPA2\/WPA3)$/.test(beaconType)) {
        if (wlanObj.X_HW_WPAand11iAuthenticationMode === 'EAPAuthentication') {
          return 'EAP';
        }
        return 'WPA'
      }

      return 'OPEN';
    }

    var checkPassIsInvisible = function(pass) {
      return pass === '********';
    }

    var checkPasswdIsSame = function(pass2G, pass5G) {
      if (checkPassIsInvisible(pass2G) && checkPassIsInvisible(pass5G)) {
        return true;
      }

      return pass2G === pass5G;
    }

    var checkGuestWifiPassIsSame = function(index2G, index5G) {
      var encMode2G = getCurEncMode(WlanArr[index2G]);
      var encMode5G = getCurEncMode(WlanArr[index5G]);
      if (encMode2G !== encMode5G) {
        return false;
      }

      if (encMode2G === 'WPA') {
        return checkPasswdIsSame(wpaPskKey[index2G].value, wpaPskKey[index5G].value);
      }

      return true;
    }

    var checkIsAllBandParamSame = function(inst2G, inst5G) {
      if (inst2G === -1 || inst5G === -1) {
        return false;
      }

      var index2G = getWlanArrIndexByInst(inst2G);
      var index5G = getWlanArrIndexByInst(inst5G);
      var wlanObj2G = WlanArr[index2G];
      var wlanObj5G = WlanArr[index5G];
      if ((wlanObj2G.enable === wlanObj5G.enable)
         && (wlanObj2G.SSID === wlanObj5G.SSID)
         && (wlanObj2G.BeaconType === wlanObj5G.BeaconType)
         && (checkGuestWifiPassIsSame(index2G, index5G))) {
        return true;
      }

      return false;
    }

    var getCurSplitState = function() {
      if (isNotExistGuestInst() || checkIsAllBandParamSame(ssidIndexOf2G, ssidIndexOf5G)) {
        return 1;
      }

      return 0;
    }

    var setTitle = function(id, text) {
      $('#' + id).text(text);
    }

    var getBandTitle = function(state, band) {
      if (state === 1) {
        return cfg_guest_wifi['guest_wifi_title_ALL_BAND'];
      }

      var bandTitleMap = {'2G': cfg_guest_wifi['guest_wifi_title_2G'],
                          '5G': cfg_guest_wifi['guest_wifi_title_5G']};
      return bandTitleMap[band];
    }

    var setBandTitle = function(state, band) {
      var id = 'ssidBandTtile_' + band;
      setTitle(id, getBandTitle(state, band));
    }

    var getCurTableDisplayState = function (state) {
      if (state === 0) {
        return 'ALL_BAND';
      }

      return 'ONLY_2G';
    }

    var setBandTableDisplay = function(displayState) {
        if (displayState === 'ONLY_2G') {
          $("#tableOf2G").show();
          $("#tableOf5G").hide();
        } else {
          $("#tableOf5G").show();
          $("#tableOf2G").show();
        }
    }

    var initAllBandsElement = function(state) {
      setCheck('splitSsidEnable', state);
      setBandTitle(state, '2G');
      setBandTitle(state, '5G');
      setBandTableDisplay(getCurTableDisplayState(state));
    }

    var setSplitSSidEnable = function() {
      var state = getCheckVal('splitSsidEnable');
      initAllBandsElement(state);
    }

    var initGuestWifiUIElement = function() {
      if (isNeedSyncGuestToAp()) {
        $('#syncGuestToAp').show();
      }

      var state = getCurSplitState();
      initAllBandsElement(state);
    }

    var g_guestWifiInst = new GuestWifiInstClass(ssidMaxNumBand);

    var initGuestWifiParas = function() {
      g_guestWifiInst.initData(WlanArr, wlanAttachConfArr, ssidIndexOf2G, ssidIndexOf5G);
      initGuestWifiUIElement();
    }

    function LoadFrame() {
        getSSIDIndex();
        getWlanArrIndexs();
        setWlAuthMode();
        initGuestWifiInfos();
        initGuestWifiEnable();
        displayAll();
        if (DoubleFreqFlag !== '1') {
            setDisplay('tableOf5G', 0);
        }
        if (isFitAp == 1) {
            FitApDisable();
        }

        initGuestWifiParas();
    }
</script>
</head>
<body class="mainbody" onload="LoadFrame();">
<script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo("Guest WiFi", GetDescFormArrayById(cfg_wlanguestwifi_language, "amp_wlan_ptvdf_guestwifi_header"), GetDescFormArrayById(cfg_wlanguestwifi_language, "amp_wlan_ptvdf_guestwifi_tittle"), false);
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr ><td class="height5p"></td></tr>
</table>
<div id="GuestWifiDetail" >
    <div style="display: none;" id="syncGuestToAp">
        <input type="checkbox" name="AutoExtendGuestEnable" id="AutoExtendGuestEnable" onclick="enableAutoExtendGuest()"; value="OFF">
            <script>
                setCheck('AutoExtendGuestEnable', WifiCoverService[0].AutoExtendGuestWifi);
                var autoExtendGuestEnableText = cfg_guest_wifi['guest_wifi_AutoExtendGuestEnable'];
                document.write(autoExtendGuestEnableText);
                if (syncToAPDisable === '1') {
                    setDisable('AutoExtendGuestEnable', 1);
                }
            </script>
        </input>
    </div><br>
    <form>
    <table height="50" cellspacing="1" cellpadding="0" width="100%" border="0" id="splitSSID">
        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_wlan_simplewificfg_AP['amp_wlan_split_ssid_title']);</script></td>
            <td class="table_right width_per75">
                <div class="contentItem contentSwitchicon">
                  <input type="checkbox" id="splitSsidEnable" onclick="setSplitSSidEnable();">
                </div>
            </td>
        </tr>
    </table>

    <table height="50" cellspacing="1" cellpadding="0" width="100%" border="0" class="tabal_noborder_bg" id="tableOf2G" style="display:none">
        <tr class="tabal_01">
            <td class="table_submit width_per25"><span id="ssidBandTtile_2G"></span></td>
            <td class="table_right width_per75">
                <div class="contentItem ">
                  <input type="checkbox" id="guestWifiEnableSwitch_2G" onclick="SetGuestWifiEnable('2G');">
                </div>
            </td>
        </tr>

        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_wlanguestwifi_language['amp_guestwifi_ssidname']);</script></td>
            <td class="table_right width_per75">
                <label>
                    <input type="text" name="ssidname_2G" id="ssidname_2G" class="tb_input" maxlength="32"/>
                </label>
                <font class="color_red">*</font>
                <script>document.write(cfg_wlancfgdetail_language['amp_linkname_note'])</script>
            </td>
        </tr>

        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_ontauth_language['amp_auth_mode']);</script></td>
            <td class="table_right width_per75">
                <select name="wlAuthMode_2G" id="wlAuthMode_2G" onchange="funProtectionmodeSelect('2G');">
                    <script language="JavaScript" type="text/javascript">
                        if (CfgMode.toUpperCase() !== 'ANTEL' && CfgMode.toUpperCase() !== 'ANTEL2') {
                            document.write("<option value='open' selected>"+cfg_wlancfgdetail_language['amp_auth_open']+"</option>");
                        }
                        document.write("<option value='wpa-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpapsk']+"</option>");
                        document.write("<option value='wpa2-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpa2psk']+"</option>");
                        document.write("<option value='wpa/wpa2-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpawpa2psk']+"</option>");
                        document.write("<option value='wpa3-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpa3psk']+"</option>");
                        document.write("<option value='wpa2/wpa3-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpa2wpa3psk']+"</option>");
                    </script>
                </select>
                <span id="SpanAuthMode_2G" class="gray"></span>
            </td>
        </tr>
        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_wlancfgdetail_language['amp_encrypt_mode']);</script></td>
            <td class="table_right" id="TdEncrypt_2G">
                <select id = 'wlEncryption_2G' name = 'wlEncryption_2G'  size='1' class="width_180px" onChange='onMethodChange("2G");'>
                </select>
                <script language="JavaScript" type="text/javascript">
                    if ((CfgModeWord != 'SYNCSGP210W') && (CfgModeWord != 'SONETSGP210W')) {
                        document.write("<span id='SpanEncrypt_2G' class='gray'></span>");
                    }
                </script>
            </td>
        </tr>
        <tr id='wpakeyInfo_2G' class="tabal_01">
            <td class="table_submit width_per25">
                <script>
                    var authMode = getSelectVal('wlAuthMode_2G'); 
                    if(authMode == 'wapi-psk') {
                            document.write(cfg_wlancfgdetail_language['amp_wapi_psk']);
                    } else {
                            document.write(cfg_wlancfgdetail_language['amp_wpa_psk']);
                    }
                </script>
            </td>
            <td class="table_right width_per75">
                <input class="textbox" type='password' autocomplete='off' id='pwd_ssidpassword_2G' onchange="wpapskpassword_2G=getValue('pwd_ssidpassword_2G');getElById('txt_ssidpassword_2G').value=wpapskpassword_2G;"/>
                <input class="textbox" type='text' id='txt_ssidpassword_2G' name='txt_ssidpassword_2G' maxlength='64' style='display:none' onchange="wpapskpassword_2G=getValue('txt_ssidpassword_2G');getElById('pwd_ssidpassword_2G').value=wpapskpassword_2G;"/>
                <input type="checkbox" name="displaypassword_2G" id="displaypassword_2G" value='on' onClick="showOrHideText('displaypassword_2G', 'pwd_ssidpassword_2G', 'txt_ssidpassword_2G');"/>
                <script>
                    if ((["SONETSGP200W", "SYNCSGP200W", "SYNCSGP210W"].indexOf(CfgMode.toUpperCase()) >= 0) && (curUserType == 0)) {
                       document.write("");
                    } else {
                        document.write(cfg_wlancfgdetail_language['amp_wlanpassword_hide']);
                    }
               </script>
                <font class="color_red">*</font>
                <span class="gray" id="hidewlWpaPsk_note_2G">
                    <script>
                        var wpaPskNoteTxt = '';
                        if (CfgMode.toUpperCase() == 'GNVDF') {
                            wpaPskNoteTxt = cfg_wlancfgdetail_language['amp_wpa_psknote_pldt_gn'];
                        } else if (preflag == 1) {
                            wpaPskNoteTxt = cfg_wlancfgdetail_language['amp_wpa_psknote_pldt'];
                        } else {
                            if (megacablePwd == 1) {
                                wpaPskNoteTxt = cfg_wlancfgdetail_language['amp_wpa_psknote_telmex'];
                            } else {
                                wpaPskNoteTxt = cfg_wlancfgdetail_language['amp_wpa_psknote' + ('1' == kppUsedFlag ? '_63' : '')];
                            }
                        }
                        document.write(wpaPskNoteTxt);
                    </script>
                </span>
            </td>
        </tr>
        <tr id = "checkinfo5Row_2G" style="display:none;">
            <td id = "checkinfotite5_2G" class="table_title width_per25"><script>document.write(cfg_wlancfgdetail_language['amp_wpa_psk_strength']);</script></td>
            <td id = "checkinfo5_2G" class="table_title"></td>
                <script>
                    if ((CfgMode.toUpperCase() == "EGVDF2") || (CfgMode.toUpperCase() == 'GNVDF')) {
                        $('#pwd_ssidpassword_2G').on('keyup',function() {
                            if ((PwdTipsFlag == 1) || (CfgMode.toUpperCase() == "EGVDF2") || (CfgMode.toUpperCase() == 'GNVDF')) {
                                $("#checkinfo5Row_2G").css("display", "");
                                $("#psd_checkpwd5_2G").css("display", "block");
                                vdfPwdStrength("pwd_ssidpassword_2G", "2G");
                            }
                        });
                        $('#txt_ssidpassword_2G').on('keyup',function() {
                            if ((PwdTipsFlag == 1) || (CfgMode.toUpperCase() == "EGVDF2") || (CfgMode.toUpperCase() == 'GNVDF')) {
                                $("#checkinfo5Row_2G").css("display", "");
                                $("#psd_checkpwd5_2G").css("display", "block");
                                vdfPwdStrength("txt_ssidpassword_2G", "2G");
                            }
                        });
                    } else {
                        $('#pwd_ssidpassword_2G').on('keyup',function() {
                            if ((PwdTipsFlag == 1) || (CfgMode.toUpperCase() == "EGVDF2") || (CfgMode.toUpperCase() == 'GNVDF')) {
                                $("#checkinfo5Row_2G").css("display", "");
                                $("#psd_checkpwd5_2G").css("display", "block");
                                psdStrength5("pwd_ssidpassword_2G", "2G");
                            }
                        });
                        $('#txt_ssidpassword_2G').on('keyup',function() {
                            if ((PwdTipsFlag == 1) || (CfgMode.toUpperCase() == "EGVDF2") || (CfgMode.toUpperCase() == 'GNVDF')) {
                                $("#checkinfo5Row_2G").css("display", "");
                                $("#psd_checkpwd5_2G").css("display", "block");
                                psdStrength5("txt_ssidpassword_2G", "2G");
                            }
                        });
                    }
                </script>
            </td>
        </tr>

        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_guest_wifi['guest_wifi_duration'])</script></td>
            <td class="table_right width_per75">
                <label>
                    <input type="text" name="duration_2G" id="duration_2G" class="tb_input" value='0' maxlength="32"/>
                </label>
                <script>document.write(cfg_guest_wifi['guest_wifi_duration_tip'])</script>
            </td>
        </tr>
        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_guest_wifi['guest_wifi_uplink_limit'])</script></td>
            <td class="table_right width_per75">
                <label>
                    <input type="text" name="uplinkRateLimit_2G" id="uplinkRateLimit_2G" class="tb_input" value='0' maxlength="32"/>
                </label>
                <script>document.write(cfg_guest_wifi['guest_wifi_link_tip'])</script>
            </td>
        </tr>
        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_guest_wifi['guest_wifi_downlink_limit'])</script></td>
            <td class="table_right width_per75">
                <label>
                    <input type="text" name="downlinkRateLimit_2G" id="downlinkRateLimit_2G" class="tb_input" value='0' maxlength="32"/>
                </label>
                <script>document.write(cfg_guest_wifi['guest_wifi_link_tip'])</script>
            </td>
        </tr>
    </table>

    <table height="50" cellspacing="1" cellpadding="0" width="100%" border="0" class="tabal_noborder_bg" id="tableOf5G" style="display: none;">
        <tr class="tabal_01">
            <td class="table_submit width_per25"><span id="ssidBandTtile_5G"></span></script></td>
            <td class="table_right width_per75">
                <div class="contentItem contentSwitchicon">
                  <input type="checkbox" id="guestWifiEnableSwitch_5G" onclick="SetGuestWifiEnable('5G');">
                </div>
            </td>
        </tr>

        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_wlanguestwifi_language['amp_guestwifi_ssidname']);</script></td>
            <td class="table_right width_per75">
                <label>
                    <input type="text" name="ssidname_5G" id="ssidname_5G" class="tb_input" maxlength="32"/>
                </label>
                <font class="color_red">*</font>
                <script>document.write(cfg_wlancfgdetail_language['amp_linkname_note'])</script>
            </td>
        </tr>

        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_ontauth_language['amp_auth_mode']);</script></td>
            <td class="table_right width_per75">
                <select name="wlAuthMode_5G" id="wlAuthMode_5G" onchange="funProtectionmodeSelect('5G');">
                    <script language="JavaScript" type="text/javascript">
                        if (CfgMode.toUpperCase() !== 'ANTEL' && CfgMode.toUpperCase() !== 'ANTEL2') {
                            document.write("<option value='open' selected>"+cfg_wlancfgdetail_language['amp_auth_open']+"</option>");
                        }
                        document.write("<option value='wpa-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpapsk']+"</option>");
                        document.write("<option value='wpa2-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpa2psk']+"</option>");
                        document.write("<option value='wpa/wpa2-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpawpa2psk']+"</option>");
                        document.write("<option value='wpa3-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpa3psk']+"</option>");
                        document.write("<option value='wpa2/wpa3-psk'>"+cfg_wlancfgdetail_language['amp_auth_wpa2wpa3psk']+"</option>");
                    </script>
                </select>
            </select>
            <span id="SpanAuthMode_5G" class="gray"></span>
            </td>
        </tr>
        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_wlancfgdetail_language['amp_encrypt_mode']);</script></td>
            <td class="table_right" id="TdEncrypt_5G">
                <select id = 'wlEncryption_5G' name = 'wlEncryption_5G' size='1' class="width_180px" onChange='onMethodChange("5G");'>
                </select>
                <script language="JavaScript" type="text/javascript">
                    if ((CfgModeWord != 'SYNCSGP210W') && (CfgModeWord != 'SONETSGP210W')) {
                        document.write("<span id='SpanEncrypt_5G' class='gray'></span>");
                    }
                </script>
          </td>
        </tr>
        <tr id='wpakeyInfo_5G' class="tabal_01">
            <td class="table_submit width_per25">
                <script>
                    var authMode = getSelectVal('wlAuthMode_5G'); 
                    if(authMode == 'wapi-psk') {
                            document.write(cfg_wlancfgdetail_language['amp_wapi_psk']);
                    } else {
                            document.write(cfg_wlancfgdetail_language['amp_wpa_psk']);
                    }
                </script>
            </td>
            <td class="table_right width_per75">
                <input class="textbox" type='password' autocomplete='off' id='pwd_ssidpassword_5G' onchange="wpapskpassword_5G=getValue('pwd_ssidpassword_5G');getElById('txt_ssidpassword_5G').value=wpapskpassword_5G;"/>
                <input class="textbox" type='text' id='txt_ssidpassword_5G' name='txt_ssidpassword_5G' maxlength='64' style='display:none' onchange="wpapskpassword_5G=getValue('txt_ssidpassword_5G');getElById('pwd_ssidpassword_5G').value=wpapskpassword_5G;"/>
                <input type="checkbox" name="displaypassword_5G" id="displaypassword_5G" value='on' onClick="showOrHideText('displaypassword_5G', 'pwd_ssidpassword_5G', 'txt_ssidpassword_5G');"/>
                <script>
                    if ((["SONETSGP200W", "SYNCSGP200W", "SYNCSGP210W"].indexOf(CfgMode.toUpperCase()) >= 0) && (curUserType == 0)) {
                       document.write("");
                    } else {
                        document.write(cfg_wlancfgdetail_language['amp_wlanpassword_hide']);
                    }
               </script>
                <font class="color_red">*</font>
                <span class="gray" id="hidewlWpaPsk_note_5G">
                    <script>
                        var wpaPskNoteTxt = '';
                        if (preflag == 1) {
                            wpaPskNoteTxt = cfg_wlancfgdetail_language['amp_wpa_psknote_pldt'];
                        } else {
                            if (megacablePwd == 1) {
                                wpaPskNoteTxt = cfg_wlancfgdetail_language['amp_wpa_psknote_telmex'];
                            } else {
                                wpaPskNoteTxt = cfg_wlancfgdetail_language['amp_wpa_psknote' + ('1' == kppUsedFlag ? '_63' : '')];
                            }
                        }
                        document.write(wpaPskNoteTxt);
                    </script>
                </span>
            </td>
        </tr>
        <tr id = "checkinfo5Row_5G" style="display:none;">
            <td id = "checkinfotite5_5G" class="table_title width_per25"><script>document.write(cfg_wlancfgdetail_language['amp_wpa_psk_strength']);</script></td>
            <td id = "checkinfo5_5G" class="table_title"></td>
                <script>
                    if (CfgMode.toUpperCase() == "EGVDF2") {
                        $('#pwd_ssidpassword_5G').on('keyup',function() {
                            if ((PwdTipsFlag == 1) || (CfgMode.toUpperCase() == "EGVDF2")) {
                                $("#checkinfo5Row_5G").css("display", "");
                                $("#psd_checkpwd5_5G").css("display", "block");
                                vdfPwdStrength("pwd_ssidpassword_5G", '5G');
                            }
                        });
                        $('#txt_ssidpassword_5G').on('keyup',function() {
                            if ((PwdTipsFlag == 1) || (CfgMode.toUpperCase() == "EGVDF2")) {
                                $("#checkinfo5Row_5G").css("display", "");
                                $("#psd_checkpwd5_5G").css("display", "block");
                                vdfPwdStrength("txt_ssidpassword_5G", '5G');
                            }
                        });
                    } else {
                        $('#pwd_ssidpassword_5G').on('keyup',function() {
                            if ((PwdTipsFlag == 1) || (CfgMode.toUpperCase() == "EGVDF2")) {
                                $("#checkinfo5Row_5G").css("display", "");
                                $("#psd_checkpwd5_5G").css("display", "block");
                                psdStrength5("pwd_ssidpassword_5G", '5G');
                            }
                        });
                        $('#txt_ssidpassword_5G').on('keyup',function() {
                            if ((PwdTipsFlag == 1) || (CfgMode.toUpperCase() == "EGVDF2")) {
                                $("#checkinfo5Row_5G").css("display", "");
                                $("#psd_checkpwd5_5G").css("display", "block");
                                psdStrength5("txt_ssidpassword_5G", '5G');
                            }
                        });
                    }
                </script>
            </td>
        </tr>

        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_guest_wifi['guest_wifi_duration'])</script></td>
            <td class="table_right width_per75">
                <label>
                    <input type="text" name="duration_5G" id="duration_5G" class="tb_input" value='0' maxlength="32"/>
                </label>
                <script>document.write(cfg_guest_wifi['guest_wifi_duration_tip'])</script>
            </td>
        </tr>
        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_guest_wifi['guest_wifi_uplink_limit'])</script></td>
            <td class="table_right width_per75">
                <label>
                    <input type="text" name="uplinkRateLimit_5G" id="uplinkRateLimit_5G" class="tb_input" value='0' maxlength="32"/>
                </label>
                <script>document.write(cfg_guest_wifi['guest_wifi_link_tip'])</script>
            </td>
        </tr>
        <tr class="tabal_01">
            <td class="table_submit width_per25"><script>document.write(cfg_guest_wifi['guest_wifi_downlink_limit'])</script></td>
            <td class="table_right width_per75">
                <label>
                    <input type="text" name="downlinkRateLimit_5G" id="downlinkRateLimit_5G" class="tb_input" value='0' maxlength="32"/>
                </label>
                <script>document.write(cfg_guest_wifi['guest_wifi_link_tip'])</script>
            </td>
        </tr>
    </table>
</form>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
                    <tr>
                        <td class="table_submit width_per25"></td>
                        <td class="table_submit">
                        <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
                        <button id="btnApplySubmit" name="btnApplySubmit" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="btnApplySubmitEx();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_apply']);</script></button>
                        <button id="cancel" name="cancel" type="button" class="CancleButtonCss buttonwidth_100px" onClick="cancelValue();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_cancel']);</script></button>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
