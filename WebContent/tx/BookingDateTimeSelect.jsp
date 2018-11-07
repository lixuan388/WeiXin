<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.java.web.weixin.tx.Class.booking.TBookingDateTimeList" %>

<% 
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  


	Date now=new Date();
	SimpleDateFormat formatter;
	formatter = new SimpleDateFormat ("yyyy-MM-dd");
	String dateString =request.getParameter("date")==null?formatter.format(now):request.getParameter("date");
	String Type =request.getSession().getAttribute("MedicalProjectType")==null?"0":(String)request.getSession().getAttribute("MedicalProjectType");
	//System.out.println("dateString:"+dateString);
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
			background-color: #ececec;;
		}  	
	.restdate>.weui-cell__ft 
		{    	
			color: black;
		}  
    </style>
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>

<div class="container" id="container">
	<div class="weui-cells__title"><p>网上预约<span style="color:red">【<%=request.getSession().getAttribute("amp_id_"+Type)%>】<%= dateString%></span>挂号</p></div>    	
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
				TBookingDateTimeList BookingDateTimeList=new TBookingDateTimeList(Type,dateString,false);
				if (BookingDateTimeList.ErrCode!=1)
				{
					%>
					<div><%= BookingDateTimeList.ErrText %></div>
					<%
				}
				else if (BookingDateTimeList.Length()==0)
				{
					%>
					<div>无可挂号时间段</div>
					<%
				}
				else
				{
					for (int i=0;i<BookingDateTimeList.Length();i++)
					{		
						if (!BookingDateTimeList.GetItem(i).Flag)
						{
						%>
						<a class="weui-cell weui-cell_access restdate" href="javascript:;"  ">
			        		<div class="weui-cell__bd">
			            		<p><%= BookingDateTimeList.GetItem(i).BookingDateTime %></p>
			            	</div>
			            	<div class="weui-cell__ft">
			            		<p>休息</p>
			            	</div>
			        	</a>
						<%	
						}
						else if (BookingDateTimeList.GetItem(i).HasBooking >= BookingDateTimeList.GetItem(i).MaxBooking)
						{

							%>
							<a class="weui-cell weui-cell_access restdate" href="javascript:;"  ">
				        		<div class="weui-cell__bd">
				            		<p><%= BookingDateTimeList.GetItem(i).BookingDateTime %></p>
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
						<a class="weui-cell weui-cell_access ShowSelectDialog" href="javascript:;" MPType="<%= Type %>" BookingID="<%= BookingDateTimeList.GetItem(i).ID %> ">
			        		<div class="weui-cell__bd">
			            		<p><%= BookingDateTimeList.GetItem(i).BookingDateTime %></p>
			            	</div>
			            	<div class="weui-cell__ft">
			            		<p>余<%= BookingDateTimeList.GetItem(i).MaxBooking-BookingDateTimeList.GetItem(i).HasBooking %>位</p>
			            	</div>
			            	<div style="display: none;" class="dailogText">是否确定预约<br>
			            		<% 
			            			String ampName=(String)request.getSession().getAttribute("amp_id_"+Type);				            		
			            		%>
			            		<%= ampName %>
			            		<br><%= dateString%>&nbsp;<%= BookingDateTimeList.GetItem(i).BookingDateTime %>？</div>
			        	</a>
						<%
						}
					}
				}
			}
		%>
	</div>
</div>
		
<div id="dialogs">
	<div class="js_dialog" id="SelectDialog" style="/*opacity: 0;*/ display: none;">
		<div class="weui-mask"></div>
	    <div class="weui-dialog weui-skin_android">
	    	<div class="weui-dialog__hd"><strong class="weui-dialog__title">预约确定</strong></div>
	        <div class="weui-dialog__bd dailogText">
	        </div>
	        <div class="weui-dialog__ft">
	           <a href="javascript:;" onclick="($('#SelectDialog').hide())" class="weui-dialog__btn weui-dialog__btn_default">取消预约</a>
	           <a href="<%=request.getContextPath()%>/tx/BookingDatePay.jsp?ID=123" class="weui-dialog__btn weui-dialog__btn_primary SelectDialog_YesBtn" onclick="$('#loadingToast').show();">确定预约</a>
	       	</div>
	    </div>
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
    
<script type="text/javascript">
	$(function(){		
	    var $SelectDialog = $('#SelectDialog');
		    $('.ShowSelectDialog').on('click', function(){
		    	$SelectDialog.find(".dailogText").html($(this).find(".dailogText").html());
		    	Booking=$(this).attr("BookingID");
		    	$SelectDialog.find(".SelectDialog_YesBtn").attr("href","<%=request.getContextPath()%>/tx/BookingDatePay.jsp?ID="+Booking);
		    	$SelectDialog.show();
	    });
	});		
	
	$(function(){
		history.replaceState(null, "", "<%=request.getContextPath()%>/tx/MedicalProjectSelect.jsp");
	});	
</script>

<script src="/dist/example/zepto.min.js"></script>

    		
</body>
</html>