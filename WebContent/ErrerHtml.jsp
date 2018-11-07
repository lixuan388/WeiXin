<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%
	String ErrUrlText =request.getParameter("ErrText")==null?"":request.getParameter("ErrText");
String ErrText=new String(ErrUrlText.getBytes("iso-8859-1"), "utf-8");

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
<div class="page msg_warn js_show">
    <div class="weui-msg">
        <div class="weui-msg__icon-area"><i class="weui-icon-warn weui-icon_msg"></i></div>
        <div class="weui-msg__text-area">
            <h2 class="weui-msg__title">操作失败</h2>
            <p class="weui-msg__desc"><%= ErrText %></p>
        </div>
        <div class="weui-msg__opr-area">
            <p class="weui-btn-area">
                <a href="<%=request.getContextPath()%>/tx/index.jsp" class="weui-btn weui-btn_primary">主页</a>
                <a href="javascript:history.back();" class="weui-btn weui-btn_default">返回</a>
            </p>
        </div>
        <div class="weui-msg__extra-area">
            <div class="weui-footer">
            </div>
        </div>
    </div>
</div>
	
</body>
</html>