function() {
    var commonObj = {};
    function LANHostConfigInfo() {
        var keyArr = ['Domain', 'Enable', 'IPInterfaceIPAddress', 'IPInterfaceSubnetMask'];

        var len = arguments.length;
        for(var i = 0; i < len; i++) {
          var key = keyArr[i];
          this[key] = arguments[i];
        }
    }
    
    commonObj.lanHostInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i}, Enable|IPInterfaceIPAddress|IPInterfaceSubnetMask, LANHostConfigInfo);%>;
    return commonObj;
}
