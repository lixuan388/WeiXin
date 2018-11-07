<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.java.sql.table.MySQLTable" %>    
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

	<jsp:include page="/head.jsp"/>
<title>次卡购买申请</title>
</head>
<body>
<%

//MySQLTable apply=new MySQLTable("select *from amca_member_card_apply where _Status='I' and unix_timestamp(now())-unix_timestamp(amca_CreateDate)<60*60*2");
MySQLTable apply=new MySQLTable("select *from amca_member_card_apply where _Status='I' and unix_timestamp(now())-unix_timestamp(amca_CreateDate)<60*60*2");
try
	{
		apply.Open();
		while (apply.next())
		{
			%>
			<div class="weui-cells">
				<div class="weui-cell">
            		<a href="<%=request.getContextPath() %>/tx/card/MemberCardCreate.jsp?ID=<%=apply.getString("amca_id")%>"><span><%=apply.getString("amca_GuestName")%>/<%=apply.getString("amca_GuestTel") %></span></a>
	            </div>
	        </div>
			<%
		}
	}
	finally
	{
		apply.Close();
	}

%>

</body>
</html>