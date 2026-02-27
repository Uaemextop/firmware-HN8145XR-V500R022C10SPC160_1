function setNoticeStyle(id, type)
{
  var ele = document.getElementById(id);
  if (type) {
    ele.innerHTML = htmlencode('✔ ');
    ele.style.color = 'green';
    return;
  }

  ele.innerHTML = htmlencode('✘ ');
  ele.style.color = 'red';
}

function ClaroPwdStrengthcheck(pwdId, noticeId, minLen)
{
  var newPassword = document.getElementById(pwdId).value;
  setNoticeStyle(noticeId + '1', newPassword.length >= minLen);
  setNoticeStyle(noticeId + '2', isLowercaseInString(newPassword));
  setNoticeStyle(noticeId + '3', isUppercaseInString(newPassword));
  setNoticeStyle(noticeId + '4', isDigitInString(newPassword));
}

function randomPassword(length) {
  var passwordArray = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz', '1234567890'];
  var password = [];
  var n = 0;
  for (var i = 0; i < length; i++) {
    if (password.length < (length - 3)) {
      var arrayRandom = Math.floor(Math.random() * 3);
      var passwordItem = passwordArray[arrayRandom];
      var item = passwordItem[Math.floor(Math.random() * passwordItem.length)];
      password.push(item);
    } else {
      var newItem = passwordArray[n];
      var lastItem = newItem[Math.floor(Math.random() * newItem.length)];
      var spliceIndex = Math.floor(Math.random() * password.length);
      password.splice(spliceIndex, 0, lastItem);
      n++;
    }
  }
  return password.join('');
}

function getEgyptVDFWebPwdStrength(str) {
  var score = 0;

  if (isLowercaseInString(str)) {
    score++;
  }

  if (isUppercaseInString(str)) {
    score++;
  }

  if (isDigitInString(str)) {
    score++;
  }

  if (isSpecialCharacterNoSpace(str)) {
    score++;
  }

  if (str.length < 8) {
    score = 1;
  }

  return score;
}

function egyptVDFWebPwdStrengthcheck(id, pwdid) {
  var password = getElementById(id).value;
  var score = getEgyptVDFWebPwdStrength(password);

  if (score < 3) {
    getElementById(pwdid).innerHTML = getLanguageDesc('s1448');
    getElementById(pwdid).style.width = 23 + '%';
    getElementById(pwdid).style.borderBottom = '10px solid #FF0000';
    return;
  }

  if (score == 3) {
    getElementById(pwdid).innerHTML = getLanguageDesc('s1449');
    getElementById(pwdid).style.width = 60 + '%';
    getElementById(pwdid).style.borderBottom = '10px solid #FFA500';
    return;
  }

  getElementById(pwdid).innerHTML = getLanguageDesc('s1450');
  getElementById(pwdid).style.width = 100 + '%';
  getElementById(pwdid).style.borderBottom = '10px solid #008000';
}
