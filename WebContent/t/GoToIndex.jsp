<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.jssdk.WXUserInfo" %>
<%@ page import="com.java.web.weixin.base.GlobalVariable" %>
<%@ page import="java.net.URLEncoder" %>

<%

String state =request.getParameter("state")==null?"10000":request.getParameter("state");

String WebUrl="http://www.jackiehor.org/WeiXin/Authorize";
WebUrl="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+GlobalVariable.AppID+"&redirect_uri="+ URLEncoder.encode(WebUrl, "utf-8") +"&response_type=code&scope=snsapi_base&state="+state+"&connect_redirect=1#wechat_redirect";
response.sendRedirect(WebUrl);		
%>