<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.jssdk.WXUserInfo" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.java.web.weixin.tx.Class.booking.TBookingDatePay" %>
<%
	String ShowUrlText =request.getParameter("ShowText")==null?"":request.getParameter("ShowText");
String ShowText=new String(ShowUrlText.getBytes("iso-8859-1"), "utf-8");

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
    <style type="text/css">
    .page, body {
    	background-color: #f8f8f8;
	}
    
    </style>
	
</head>
<body>

<div class="page msg_success js_show">
    <div class="weui-msg">
        <div class="weui-msg__icon-area"><i class="weui-icon-success weui-icon_msg"></i></div>
        <div class="weui-msg__text-area">
            <h2 class="weui-msg__title">操作成功</h2>
            
            <p class="weui-msg__desc"><%= ShowText %></p>
        </div>
        <div class="weui-msg__opr-area">
            <p class="weui-btn-area">
                <a href="<%=request.getContextPath()%>/tx/index.jsp" class="weui-btn weui-btn_primary">主页</a>
                <a href="javascript:history.back();" class="weui-btn weui-btn_default">返回</a>
            </p>
        </div>
        <div class="weui-msg__extra-area">
            <div class="weui-footer">
                <p class="weui-footer__links">
                    <a href="javascript:void(0);" class="weui-footer__link">底部链接文本</a>
                </p>
                <p class="weui-footer__text">Copyright © 2008-2016 weui.io</p>
            </div>
        </div>
    </div>
</div>


</body>
</html>