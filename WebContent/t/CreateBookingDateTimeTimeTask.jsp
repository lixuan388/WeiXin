<%@page import="com.java.web.weixin.TimeTask.UpdateCheckInTimeTask"%>
<%@page import="com.java.sql.table.MySQLUpdate"%>
<%@page import="com.java.sql.table.MySQLTable"%>
<%@ page isELIgnored="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	UpdateCheckInTimeTask u=new UpdateCheckInTimeTask();
	u.RunTime=1;
	u.run();
%>
<div>ok</div>
</body>
</html>