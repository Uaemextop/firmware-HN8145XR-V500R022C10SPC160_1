function() {
    function stLine(Domain, DirectoryNumber, PhyReferenceList, Status, CallState, RegisterError) {
        this.Domain = Domain;
        if (DirectoryNumber != null) {
            this.DirectoryNumber = DirectoryNumber.toString().replace(/&apos;/g, "\'");
        }
        else {
            this.DirectoryNumber = DirectoryNumber;
        }

        this.PhyReferenceList = PhyReferenceList;
        this.Status = Status;
        this.CallState = CallState;
        this.RegisterError = RegisterError;
    }

    var AllLine = <% HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}, DirectoryNumber|PhyReferenceList|Status|CallState|X_HW_LastRegisterError, stLine);%>;

    function stAuth(Domain, AuthUserName) {
        this.Domain = Domain;
        if (AuthUserName != null) {
            this.AuthUserName = AuthUserName.toString().replace(/&apos;/g, "\'");
        }
        else {
            this.AuthUserName = AuthUserName;
        }

        var temp = Domain.split('.');
        this.key = '.' + temp[7] + '.';
    }

    var AllAuth = <% HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.SIP, AuthUserName, stAuth);%>;
    var Auth = new Array();
    for (var i = 0; i < AllAuth.length - 1; i++)
        Auth[i] = AllAuth[i];

    var User = new Array();

    function stUser(Domain, UserId) {
        this.Domain = Domain;
        this.UserId = UserId;
    }

    for (var i = 0; i < AllLine.length - 1; i++) {
        User[i] = new stUser();
        User[i].UserId = AllLine[i].DirectoryNumber;
    }

    function GetPhoneNum(UserName, VoipInfo) {
        if (UserName.indexOf(":") >= 0) {
            var Authpart = UserName.split(':');
            var k1 = Authpart[1];
            var k2 = k1.split('@');
            var k3 = k2[0];
            if (k3 == "") {
                VoipInfo.phoneNum = "--";
            } else {
                VoipInfo.phoneNum = k3;
            }
        } else {
            var Authpart = UserName.split('@');
            var k = Authpart[0];
            if (k == "") {
                VoipInfo.phoneNum = "--";
            } else {
                VoipInfo.phoneNum = k;
            }
        }
    }

    var VoipArray = new Array();
    function VoipInfo(phoneNum, voipStatus) {
        this.phoneNum = phoneNum;
        this.voipStatus = voipStatus;
    }

    for (i = 0; i < AllLine.length - 1; i++) {
        var voipInfo = new VoipInfo();
        if (User[i].UserId == "") {
            GetPhoneNum(Auth[i].AuthUserName, voipInfo);
        } else {
            GetPhoneNum(User[i].UserId, voipInfo);
        }
        voipInfo.voipStatus = AllLine[i].Status;
        VoipArray.push(voipInfo);
    }

    VoipArray.push(null);

    return VoipArray;
}
