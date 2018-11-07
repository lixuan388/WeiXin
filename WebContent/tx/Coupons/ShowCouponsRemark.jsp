<%@page import="com.java.sql.table.MySQLTable"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
  response.setHeader("Pragma","No-cache");  
  response.setHeader("Cache-Control","no-cache");  
  response.setDateHeader("Expires", 0);  
  String acID = request.getParameter("ID") == null ? "" : (String) request.getParameter("ID");;
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
  <jsp:include page="/head.jsp"/>
<title>赠送说明</title>
</head>
<body>

<%
  MySQLTable CouponsTable = new MySQLTable("select ac_Name,ac_id,ac_remark from ac_Coupons where _Status<>'D' and ac_id='"+acID+"' order by ac_ShtName");
  try {
    CouponsTable.Open();
    if (CouponsTable.next()) {
%>
<div style="padding: 20px;"><div class="card"><h4><%=CouponsTable.getString("ac_Name")%></h4></div>
<div class="card" style="min-height:250px"><%=CouponsTable.getString("ac_remark")%></div></div>
<%      
    }
  }finally {
    CouponsTable.Close();
  }
%>
</body>
</html>