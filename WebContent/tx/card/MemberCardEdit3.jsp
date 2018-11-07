<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.sql.table.MySQLTable" %>


<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  
	String AbdpID =request.getParameter("ID")==null?"":(String)request.getParameter("ID");

    String AmcID="-1";
	MySQLTable Card=new MySQLTable("select amc_id from abdp_bookingdatetime_pay,amc_member_card where abdp_id_amb=amc_id_amb and  abdp_id="+AbdpID);
	try
	{
	  Card.Open();
	  if (Card.next())
	  {  
		AmcID=Card.getString("amc_id");
	  }
	}
	finally
	{
		Card.Close();
	}
    response.sendRedirect(request.getContextPath()+"/tx/card/MemberCardEdit.jsp?ID="+AmcID);
%>