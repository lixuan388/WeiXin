<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.java.web.weixin.tx.Class.booking.TBookingDateList" %>


<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  

	String Type =request.getParameter("type")==null?"0":request.getParameter("type");

	String Modify =request.getParameter("Modify")==null?"False":request.getParameter("Modify");
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
	.restdate
		{    	
			background-color: #e5e5e5;
		}  	
	.restdate>.weui-cell__ft 
		{    	
			color: black;
		}  
		
    </style>
    <% 
    	if (Modify.equals("True"))
    	{
    		
    %>
   	<script type="text/javascript">	    
		$(function(){
			history.replaceState(null, "", "<%=request.getContextPath()%>/tx/MedicalProjectSelect.jsp?Modify=True");
		});	
		
    </script>
    <%
    	}
    	else
    	{
    		
    %>
    <script type="text/javascript">
	
	$(function(){
		history.replaceState(null, "", "<%=request.getContextPath()%>/tx/MedicalProjectSelect.jsp");
	});	
    <%
    	}
    		
    %>
    
	

	
	</script>
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>

    <div class="container" id="container">
    	<div class="weui-cells__title"><p>网上预约挂号<span style="color:red">【<%=request.getSession().getAttribute("amp_id_"+Type)%>】</span></p></div>    	
		<div class="weui-cells">
			<% 
				if (Type.equals("0"))
				{
					%>
						<span>参数错误！</span>					
					<%
				}
				else
				{
					request.getSession().setAttribute("MedicalProjectType", Type);

					Date d=new Date();  

					SimpleDateFormat formatter; 
					formatter = new SimpleDateFormat ("yyyy-MM-dd");
					String StringDate =formatter.format(d);	
					TBookingDateList BookingDateList=new TBookingDateList(Type,StringDate);
					if (BookingDateList.ErrCode!=1)
					{
						%>
						<div><%= BookingDateList.ErrText %></div>
						<%
					}
					else if (BookingDateList.Length()==0)
					{
						%>
						<div>无可挂号日期</div>
						<%
					}
					else
					{
						for (int i=0;i<BookingDateList.Length();i++)
						{				    
							if (!BookingDateList.GetItem(i).Flag)
							{
								%>
								<a class="weui-cell weui-cell_access restdate " href="javascript:void(0);">
					        		<div class="weui-cell__bd">
					            		<p><%= BookingDateList.GetItem(i).BookingDate %>(<%= BookingDateList.GetItem(i).Week %>)</p>
					            	</div>
					            	<div class="weui-cell__ft">
					            			<p>休息</p>
					            	</div>
					        	</a>
								<%
							}
							else if (Modify.equals("True"))
							{
								%>
								<a class="weui-cell weui-cell_access " href="<%=request.getContextPath()%>/tx/BackStage/BookingDateTimeModify.jsp?date=<%=BookingDateList.GetItem(i).BookingDate%>" onclick="$('#loadingToast').show();">
		        		  <div class="weui-cell__bd">
		            		<p><%=BookingDateList.GetItem(i).BookingDate%>(<%=BookingDateList.GetItem(i).Week %>)</p>
		            	</div>
		            	<div class="weui-cell__ft">
		            		<p><%=BookingDateList.GetItem(i).MaxBooking%>余<%=BookingDateList.GetItem(i).MaxBooking-BookingDateList.GetItem(i).HasBooking%></p>
		            	</div>
		        		</a>
		        		<%
							}
							else if (BookingDateList.GetItem(i).HasBooking>=BookingDateList.GetItem(i).MaxBooking)
							{
								%>
								<a class="weui-cell weui-cell_access restdate " href="javascript:void(0);">
			        		<div class="weui-cell__bd">
			            		<p><%= BookingDateList.GetItem(i).BookingDate %>(<%= BookingDateList.GetItem(i).Week %>)</p>
			            	</div>
			            	<div class="weui-cell__ft">
			            	
			            			<p>已满</p>
			            	</div>
			        	</a>
								<%
							}
							else
							{
							%>
								<a class="weui-cell weui-cell_access " href="<%=request.getContextPath()%>/tx/BookingDateTimeSelect.jsp?date=<%= BookingDateList.GetItem(i).BookingDate %>" onclick="$('#loadingToast').show();">
			        		<div class="weui-cell__bd">
			            		<p><%= BookingDateList.GetItem(i).BookingDate %>(<%= BookingDateList.GetItem(i).Week %>)</p>
			            	</div>
			            	<div class="weui-cell__ft">
			            		<p>余<%= BookingDateList.GetItem(i).MaxBooking-BookingDateList.GetItem(i).HasBooking %>位</p>
			            	</div>
			        	</a>
							<%
							}
						}
					}
				     
				}

			%>
		</div>
	</div>

    <div id="loadingToast" style="display: none;">
        <div class="weui-mask_transparent"></div>
        <div class="weui-toast">
            <i class="weui-loading weui-icon_toast"></i>
            <p class="weui-toast__content">操作中</p>
        </div>
    </div>
    <jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
</body>
</html>