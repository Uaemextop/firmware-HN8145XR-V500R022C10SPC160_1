<html>
<head>
<title></title>		
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>
<style>
.input_time {border:0px; }
</style>


<script language="JavaScript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script language="javascript" src="/Cusjs/<%HW_WEB_CleanCache_Resource(ajaxconfig.js);%>"></script>
<script language="javascript" type="text/javascript">

$.ajax({
    type : "POST",
    async : false,
    cache : false,
    url : "setMarketRdirect.cgi?RequestFile=html/ssmp/appstore/marketRedirect.asp",
    data: getDataWithToken(),
    success : function(data) {
    },
});

var Flag = 0;
var IntervalHandle ;

function ParseResult(RedirectContent)
{
	var para ="https://" + RedirectContent;
	var resultStr = RedirectContent.toLowerCase();

	if(resultStr == 'stop')
	{
		
		alert("无法打开应用商城，请重试！");
		if(Flag == 1)
		{
			clearInterval(IntervalHandle) ;
		}
		Flag = 1 ;
			

	}
	else if(resultStr == 'continue')
	{
	}
	else if(resultStr.indexOf("token") > 1)
	{
		if(Flag == 1)
			clearInterval(IntervalHandle) ;
		Flag = 1 ;
		window.top.location=para;
	}
}

function GetRedirectResult()
{
	var RedirectContent= "";
	var data;
	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : "./GetMarketRedirectResult.asp",
		success : function(data) {
		if (data.length  > 0)
		{
			RedirectContent = data;
			ParseResult(RedirectContent);
		}
		},
		complete: function (XHR, TS) { 
            PingContent=null;			
			XHR = null;
		}
	});
}

function GetAllResult()
{
    GetRedirectResult();
    
    if(Flag == 0)
    {   
		Flag = 1 ; 
        IntervalHandle = setInterval("GetAllResult()", 1000);
    }
}

function LoadFrame()
{ 
GetAllResult();

}

</script>


<body onLoad="LoadFrame();"> 
</body> 
</html>