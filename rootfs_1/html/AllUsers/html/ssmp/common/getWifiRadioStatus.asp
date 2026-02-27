function(){
    function stRadio(domain, Enable) {
        this.domain = domain;
        this.Enable = Enable;
    }

    var wifiRadioStatus = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WiFi.Radio.{i}, Enable,stRadio);%>;

    return wifiRadioStatus;
}
