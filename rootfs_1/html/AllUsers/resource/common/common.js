var firstCharToUpperCase = function(str) {
  return str.slice(0, 1).toUpperCase() + str.slice(1).toLowerCase();
}

function dealDataWithFun(str) {
  if (typeof str === 'string' && str.indexOf('function') === 0) {
    return Function('"use strict";return (' + str + ')')()();
  }
  return str;
}

var getElementId = function(domain) {
  if (domain) {
    var reg = /[.]/g;
    return domain.replace(reg, '_');
  }
  return '';
}

function IsValideFileType(target) {
  var fileName = target.files[0].name;
  var index = fileName.lastIndexOf('.');
  var suffix = fileName.substring(index);
  var valideSuffix = ['.der', '.crt', '.cer', '.csr', '.pfx', '.jsk', '.pem', '.crl', '.key'];
  for (var i = 0; i < valideSuffix.length; i++) {
    if (suffix === valideSuffix[i]) {
      return true;
    }
  }
  return false;
}

function IsValideFileSize(target) {
  var fileSize = target.files[0].size;
  if (fileSize > 1024 * 1024) {
    return false;
  }

  return true;
}

var removeInvisibleChar = function(str) {
  var newStr = '';
  for (var i = 0; i < str.length; i++) {
    var curCharCode = str.charCodeAt(i);
    if (curCharCode > 32 && curCharCode <= 126) {
      newStr += str[i];
    }
  }

  return newStr;
}

var removeSpecialChar = function (ele) {
  var val = ele.value;
  var emojiReg = /(\ud83c[\udf00-\udfff])|(\ud83d[\udc00-\ude4f])|(\ud83d[\ude80-\udeff])/g;
  if (val.match(emojiReg)) {
    ele.value = val.replace(emojiReg, '');
  }
}

var checkInSameSubNet = function(sipAddr, lanHostObj) {
  if (isValidIpAddress(sipAddr)) {
    var ipAddr = lanHostObj.IPInterfaceIPAddress;
    var subnetMask = lanHostObj.IPInterfaceSubnetMask;
    if (isSameSubNet(ipAddr, subnetMask, sipAddr, subnetMask)) {
      return true;
    }
  }
  
  return false;
}

var isSameNetSegmentWithLanHost = function(sipArry) {
  var commonInfo = ajaxGetAspData('/html/bbsp/common/commonInterface.asp');
  if (!commonInfo || !commonInfo.lanHostInfo) {
    return false;
  }

  var lanHostInfo = commonInfo.lanHostInfo;
  for (var key = 0; key < lanHostInfo.length - 1; ++key) {
    for (var i = 0; i < sipArry.length; ++i) {
      if (checkInSameSubNet(sipArry[i], lanHostInfo[key])) {
        return true;
      }
    }
  }
  
  return false;
}

var isNeedWriteNatSwitch = function(cfgWord, userType) {
  var SYS_USER_TYPE = '0';

  if (['DTTNET2WIFI', 'TTNET2'].indexOf(cfgWord) >= 0 && userType !== SYS_USER_TYPE) {
    return true;
  }

  return false;
}

var ajaxPostData = function(data, callBack) {
  $.ajax({
    type : 'POST',
    async : data.async,
    cache : false,
    data : data.postData,
    url : data.requestUrl,
    success : function(data) {
      if (callBack) {
        callBack(data);
      }
    }
  });
}

var getRandomStr = function(length) {
  var str = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  var result = '';
  for(var i = 0; i < length; i++) {
    var index = Math.floor(Math.random() * str.length);
    result += str[index];
  }
  return result;
}

var getTruncateStr = function(str, maxLen) {
  var realLen = 0;
  var newStr = '';
  for (var i = 0; i < str.length; i++) {
    if (str.charCodeAt(i) > 255) {
      realLen += 3;
    } else {
      realLen += 1;
    }

    if (realLen > maxLen) {
      return newStr;
    }
    newStr += str[i];
  }

  return newStr;
}

var getPostDataByObj = function(obj, preKey) {
  var postData = '';
  Object.keys(obj).forEach(function(key) {
    postData += preKey + '.' + key + '=' + obj[key] + '&';
  });
  
  return postData;
}
