<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.jssdk.WXSnsapiBaseCode" %>

<%
	String code=request.getParameter("code")==null?"":request.getParameter("code");
	WXSnsapiBaseCode codeInfo=new WXSnsapiBaseCode(code);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
</head>
<body>    
errcode:<%= codeInfo.GetValue("errcode") %><br>
errmsg:<%= codeInfo.GetValue("errmsg") %><br>
access_token:<%= codeInfo.GetValue("access_token") %><br>
expires_in:<%= codeInfo.GetValue("expires_in") %><br>
refresh_token:<%= codeInfo.GetValue("refresh_token") %><br>
openid:<%= codeInfo.GetValue("openid") %><br> 
scope:<%= codeInfo.GetValue("scope") %><br> 
<br>
<a href="/WeiXin/test/GetUserInfo.jsp?openid=<%= codeInfo.GetValue("openid") %>" target="_blank">"/WeiXin/test/GetUserInfo?openid=<%= codeInfo.GetValue("openid") %></a>

<br><br><br>
{ "access_token":"ACCESS_TOKEN",    

 "expires_in":7200,    

 "refresh_token":"REFRESH_TOKEN",    

 "openid":"OPENID",    

 "scope":"SCOPE" } 
 



</body>
</html>