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
    <script type="text/javascript">	    
		$(function(){
			history.replaceState(null, "", "/WeiXin/tx/MedicalProjectSelect.jsp?Modify=True");
		});	
		
    </script>
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>

<div class="container" id="container">
	<div class="weui-cells__title"><p>网上预约<%= dateString%>挂号</p></div>    	
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
				TBookingDateTimeList BookingDateTimeList=new TBookingDateTimeList(Type,dateString,true);
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
						else
						{
						%>
						<div class1="weui-cell weui-cell_access " style="padding: 0px;">
						<a class="weui-cell weui-cell_access ShowSelectDialog" href="javascript:;" id="DivBookingID<%=BookingDateTimeList.GetItem(i).ID%>" Modify="<%=BookingDateTimeList.GetItem(i).ModifyBooking%>">
				        		<div class="weui-cell__bd">
				            		<p><%= BookingDateTimeList.GetItem(i).BookingDateTime %></p>
				            	</div>
				            	<div  class="weui-cell__ft">
				            		<p>共<%=BookingDateTimeList.GetItem(i).MaxBooking%>订<%=BookingDateTimeList.GetItem(i).HasBooking%>调<%=BookingDateTimeList.GetItem(i).ModifyBooking%></p>
				            	</div>

			            	
			            	
			            	
			        	</a>
			        	<div style="display: none;" class="dailogText">
			            		<div style="margin: 0px;margin-left: 10px;width: 40%;"" onclick="Sub(<%=BookingDateTimeList.GetItem(i).ID%>)" class="weui-btn weui-btn_default weui-btn_mini">减少位置</div>
	           					<div style="margin: 0px;margin-right: 10px;width: 40%;"" onclick="Add(<%=BookingDateTimeList.GetItem(i).ID%>)" class="weui-btn weui-btn_primary weui-btn_mini">增加位置</div>
			            		
						</div>
			        	</div>
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
    
<script type="text/javascript">
	$(function(){
		    $('.ShowSelectDialog').on('click', function(){

		    	//console.log($(this).find(".dailogText"));
		    	$(this).parent().find(".dailogText").show();
	    });
	});		
	function Add(id)
	{

		var DivBookingID=$("#DivBookingID"+id);
		var Modify=DivBookingID.attr("Modify")*1+1;
		Send(id,Modify);
	}
	function Sub(id)
	{

		var DivBookingID=$("#DivBookingID"+id);
		var Modify=DivBookingID.attr("Modify")*1-1;
		Send(id,Modify);
	}
	function Send(ID,Value)
	{
		$('#loadingToast').show();

    	var id=ID;
    	var JsonData={"DataRows":[{"id":ID,"Modify":Value}]};
    	//console.log(JsonData);
    	
    	$.ajax({
            url:"/WeiXin/BackStage/PostMedicalProjectTimeModifyNumber",
            type:'POST',
            data:  JSON.stringify(JsonData),
            dataType:'Json',
            success:function(data){
            	if (data.MsgID!=1)
            	{
            		weui.alert(data.MsgText);
            	}
            	else
            	{
            		var DivBookingID=$("#DivBookingID"+id);
            		DivBookingID.attr("Modify",data.ModifyBooking);
            		DivBookingID.find(".weui-cell__ft").html("<p>共"+data.MaxBooking+"订"+data.HasBooking+"调"+data.ModifyBooking+"</p>");
            	}	    
            	$('#loadingToast').hide();
            }
    	});	
	}
</script>

<script src="/dist/example/zepto.min.js"></script>

    		
</body>
</html>