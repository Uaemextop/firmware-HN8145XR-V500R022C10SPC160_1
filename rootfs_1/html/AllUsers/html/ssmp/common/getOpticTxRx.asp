function() {
    function stOpticInfo(domain, TxPower, RxPower) {
        this.domain = domain;
        this.TxPower = TxPower;
        this.RxPower = RxPower;
    }
    var opticInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic, TxPower|RxPower, stOpticInfo);%>;

    return opticInfos;
}