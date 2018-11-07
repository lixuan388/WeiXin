<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.java.web.weixin.base.GlobalVariable" %>

<%@ page import="java.util.Enumeration" %>


<% 
//WXConfig c=new WXConfig("http://www.17ecity.cc/WeiXin/Menu1.jsp");
	System.setProperty("scheduler.start","1");
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

	<script type="text/javascript" src="/js/date.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
		
<title>Insert title here</title>
</head>
<body>

<br>
https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx8af2e5e7b3163da1&redirect_uri=http%3A%2F%2Fwww.17ecity.cc%2FWeiXin%2FMenu2.jsp%3Fada%3Dasdqweq%26sss%3Dqweqwe&response_type=code&scope=snsapi_base&state=123#wechat_redirect
 
<br>
getParameter:<br>
<%


Enumeration enu = request.getParameterNames();
while(enu.hasMoreElements()){
    String key =(String) enu.nextElement();
    String value =new String(request.getParameter(key).getBytes("iso-8859-1"), "utf-8");
	%>
	--------------<br>
	key:<%= key %><br>
	value:<%= value %><br>	
	<%
}

%>
 
<br>----------------------------------------------------<br>
<%

    HttpServletRequest httpRequest=(HttpServletRequest)request;  
              
    String strBackUrl = "http://" + request.getServerName() //服务器地址  
                        + ":"   
                        + request.getServerPort()           //端口号  
                        + httpRequest.getContextPath()      //项目名称  
                        + httpRequest.getServletPath()      //请求页面或其他地址  
                    + "?" + (httpRequest.getQueryString()); //参数  


%>
url:<%= strBackUrl %>
	
	
<br>----------------------------------------------------<br>
getServerName():<%= request.getServerName()  %><br>
System.getProperty('WeiXin.AccessToken'):<%= System.getProperty("WeiXin.AccessToken") %><br>
System.getProperty('WeiXin.AccessTokenTimeOut'):<%= System.getProperty("WeiXin.AccessTokenTimeOut") %><br>

</body>
</html>