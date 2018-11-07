<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.jssdk.WXUserInfo" %>

<%
	String OpenID=request.getParameter("openid")==null?"":request.getParameter("openid");
	WXUserInfo userinfo=new WXUserInfo(OpenID);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
</head>
<body>    
errcode:<%= userinfo.GetValue("errcode") %><br>
errmsg:<%= userinfo.GetValue("errmsg") %><br>
<% 
	String  headimgurl=userinfo.GetValue("headimgurl");
headimgurl=headimgurl.replace("/0", "/96");
	

%>
<img src="<%= headimgurl %>" class="avatar"><br>



subscribe:<%= userinfo.GetValue("subscribe") %><br>
openid:<%= userinfo.GetValue("openid") %><br>
nickname:<%= userinfo.GetValue("nickname") %><br>
sex:<%= userinfo.GetValue("sex") %><br>
city:<%= userinfo.GetValue("city") %><br>
country:<%= userinfo.GetValue("country") %><br>
province:<%= userinfo.GetValue("province") %><br>
language:<%= userinfo.GetValue("language") %><br>
headimgurl:<%= userinfo.GetValue("headimgurl") %><br>
subscribe_time:<%= userinfo.GetValue("subscribe_time") %><br>
unionid:<%= userinfo.GetValue("unionid") %><br>
remark:<%= userinfo.GetValue("remark") %><br>
groupid:<%= userinfo.GetValue("groupid") %><br>
tagid_list:<%= userinfo.GetValue("tagid_list") %><br>


</body>
</html>