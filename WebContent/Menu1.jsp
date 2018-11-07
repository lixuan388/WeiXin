<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.java.web.weixin.base.GlobalVariable" %>
<%@ page import="com.java.web.weixin.jssdk.WXConfig" %>


<% 
//WXConfig c=new WXConfig("http://www.17ecity.cc/WeiXin/Menu1.jsp");
System.setProperty("scheduler.start","1");
System.setProperty("WeiXin.AccessTokenTimeOut","0");
	WXConfig c=new WXConfig(request,"/Menu1.jsp");
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

	<script type="text/javascript" src="/js/date.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
	
	
	<script type="text/javascript">
		var d=new Date();
		

		console.log(d.Format('yyyyMMddHHmmss'));
	
		wx.config({
		    debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
		    appId: '<%= c.appId %>', // 必填，公众号的唯一标识
		    timestamp: <%= c.timestamp %> , // 必填，生成签名的时间戳
		    nonceStr: '<%= c.nonceStr %>', // 必填，生成签名的随机串
		    signature: '<%= c.signature %>',// 必填，签名，见附录1
		    jsApiList: ['chooseWXPay'] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
		});
		wx.error(function(res){
			console.log('wx.error');
			console.log(res);
		});
		wx.ready(function(){
			console.log('wx.ready');   
		});
		
	</script>
<title>Insert title here</title>
</head>
<body>
	AccessToken:<%= GlobalVariable.GetAccessToken() %><br>
	jsapi_ticket:<%= GlobalVariable.GetJsapi_ticket() %><br>
<br><br>
WXConfig:<br>

appId:<%= c.appId%><br>
timestamp:<%= c.timestamp %><br>
nonceStr:<%= c.nonceStr %><br>
signature:<%= c.signature %><br>
sha1:<%= c.sha1 %><br>

<br><br>
getServerName():<%= request.getServerName()  %><br>
System.getProperty('scheduler.start'):<%= System.getProperty("scheduler.start") %><br>

</body>
</html>