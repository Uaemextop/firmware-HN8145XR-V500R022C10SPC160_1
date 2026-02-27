function() {
  var keyArr = ['wanMac', 'txPower', 'rxPower', 'oltRxPower', 'voltage', 'bias', 'temper', 'isTxCalibrated',
                'rxPowerMax', 'rxPowerMin', 'txPowerMax', 'txPowerMin', 'oltRxPowerMax', 'oltRxPowerMin',
                'voltageMax', 'voltageMin', 'biasMax', 'biasMin','temperMax', 'temperMin'
                ];
  if ('<%HW_WEB_GetFeatureSupport(FT_FTTR_MAIN_ONT);%>' === '1') {
    keyArr.push('PonTx', 'PonRx');
  }
  function ApPonInfo() {
    var len = arguments.length;
    for(var i = 0; i < len; i++) {
      var key = keyArr[i];
      this[key] = arguments[i];
    }
  }
  return <%WEB_GetApPonInfo();%>;
}
