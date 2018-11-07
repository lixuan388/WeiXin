<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.java.web.weixin.base.GlobalVariable" %>
<%
	String openid=request.getSession().getAttribute("openid")==null?"":(String)request.getSession().getAttribute("openid");
	
	if (openid.equals(""))
	{
	    HttpServletRequest httpRequest=(HttpServletRequest)request;  
      String WebUrl =request.getScheme() +"://" + request.getServerName(); //服务器地址
/*      if (request.getServerPort()!=80)
      {
        WebUrl=WebUrl + ":" + request.getServerPort();           //端口号
      } */
	    WebUrl=WebUrl+httpRequest.getContextPath()+"/Authorize";
	    WebUrl="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+GlobalVariable.AppID+"&redirect_uri="+ URLEncoder.encode(WebUrl, "utf-8") +"&response_type=code&scope=snsapi_base&state=1&connect_redirect=1#wechat_redirect";
		response.sendRedirect(WebUrl);		
	}
	else
	{
		response.sendRedirect("http://192.168.0.63:8063/MisApp/Login/login.jsp");
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
 </head>
<body>
1111
	
</body>
</html>