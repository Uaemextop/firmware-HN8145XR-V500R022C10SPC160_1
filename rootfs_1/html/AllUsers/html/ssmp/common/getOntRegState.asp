function() {
    function OntStateInfo(domain, ONTID, Status) {
        this.domain = domain;
        this.OntId = ONTID;
        this.Status = Status;
    }

    function UpEthInfo(domain, Status) {
        this.domain = domain;
        this.Status = Status;

        if (Status == "Up") {
            this.Status = "ONLINE";
        } else {
            this.Status = "OFFLINE";
        }
    }

    var gponStateInfo = <% HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT, Ontid|State, OntStateInfo);%>;
    var eponStateInfo = <% HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.OAM.ONT, Ontid|State, OntStateInfo);%>;
    var ponMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
    var WanEthInfos = <% HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANEthernetInterfaceConfig, Status, UpEthInfo);%>;
    var OntState = "";
    if ("GPON" == ponMode.toUpperCase()) {
        OntState = ((gponStateInfo[0].Status.toUpperCase() == "O5") || (OntState = gponStateInfo[0].Status.toUpperCase() == "O5AUTH")) ? "ONLINE" : "OFFLINE";
    } else if ("EPON" == ponMode.toUpperCase()) {
        OntState = eponStateInfo[0].Status.toUpperCase();
    } else if ((WanEthInfos.length > 1) && ("GE" == ponMode.toUpperCase())) {
        OntState = WanEthInfos[0].Status;
    } else {
        OntState = "ONLINE";
    }

    return OntState;
}