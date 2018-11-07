<%@page import="com.java.web.weixin.tx.Class.booking.TCancelBooking"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.booking.TQueryMemberBookingDateList" %>
<%@ page import="com.java.web.weixin.base.GlobalVariable" %>
<%@ page import="org.apache.catalina.Session" %>


<%
	response.setHeader("Pragma","No-cache");	
	response.setHeader("Cache-Control","no-cache");	
	response.setDateHeader("Expires", 0);	

	String MemberID=request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");
	if (MemberID.equals(""))
	{
		String ErrText="参数错误！(MemberID)";
		GlobalVariable.GoErrerHtml(request,response,ErrText);
		return;
	}
	TQueryMemberBookingDateList query=new TQueryMemberBookingDateList(MemberID);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	<jsp:include page="/head.jsp"/>

	
<script type="text/javascript">
	function pay(UrlCode)
	{
		window.location.href="/WeiXin/tx/pay/WaitPay.jsp?code="+UrlCode+"&d="+new Date().Format("yyyyMMddHHmmss"); 
	}
	

	function CancelBooking(url,MedicalProject,BookingDateTime)
	{
		confirmLayer('挂号项目:'+MedicalProject+'<br>预约时间:'+BookingDateTime+'<br>是否确认取消预约？<br>【是】，确认取消预约！<br>【否】，不取消预约',  function(index, layero){
			layer.close(index);
			CancelBooking2(url)
		}, function(index, layero){
			layer.close(index);
		});
	}
	function CancelBooking2(url)
	{
		$("#loadingToast").show();
		$.post("<%=request.getContextPath() %>/booking/CancelBooking",{"url":url},function(data){
			console.log(data);
			$("#loadingToast").hide();
			if (data.MsgID==-1)
			{
				alertLayer(data.MsgTest);
			}
			else
			{
				alertLayer("预约取消成功！",function(){
					window.location.href='<%=request.getContextPath() %>/tx/QueryMemberBookingDate.jsp?d=' + new Date().getTime();
				});
			}
		},"json");
	}
</script>	

</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
	<div class="weui-cells__title"><p>预约记录</p></div>		
	<%
		if (query.ErrCode!=1)
		{
			%>
			<span><%= query.ErrText %></span>
			<%
		}
		else
		{
			for (int i =0;i<query.Length();i++)
			{
		%>
		<div	class="weui-cells" style="margin: 20px;border-radius: 5px;background: #F8F8F8;box-shadow: 3px 3px 3px 1px rgba(0, 0, 0, 0.27);">
			<div class="weui-form-preview">
							<div class="weui-form-preview__hd">
									<%
											String Color="";
											if (query.GetItem(i).StatusType.equals("待付款"))
											{
												Color="color:red;";
											}
											else if (query.GetItem(i).StatusType.equals("已付款"))
											{
												Color="color:blue;";
											}
											else if (query.GetItem(i).StatusType.equals("付款中"))
											{
												Color="color:#1aad19;";
											}
											else if (query.GetItem(i).StatusType.equals("已取消"))
											{
												Color="color:rgb(153, 153, 153);";
											}												
										%>
									<div class="weui-form-preview__item">
											<label class="weui-form-preview__label">付款单号</label>
											<em class="weui-form-preview__value" style="font-size: 16px;<%= Color %>"><%= query.GetItem(i).UrlCode %></em>
									</div>
									<div class="weui-form-preview__item">
											<label class="weui-form-preview__label">付款金额</label>
											<em class="weui-form-preview__value" style="<%= Color %>">¥<%= query.GetItem(i).Money %></em>
									</div>
									<div class="weui-form-preview__item">
											<label class="weui-form-preview__label" >付款状态</label>
											
											<em class="weui-form-preview__value" style="font-size: 16px;<%= Color %>"><%= query.GetItem(i).StatusType %></em>
									</div>
									<% 
										if (!query.GetItem(i).PayDate.equals(""))
										{
											%>
											<div class="weui-form-preview__item">
													<label class="weui-form-preview__label">付款时间</label>
													<em class="weui-form-preview__value" style="font-size: 16px"><%= query.GetItem(i).PayDate %></em>
											</div>
											<%
										}
									%>
							</div>
							<div class="weui-form-preview__bd">
										
									<div class="weui-form-preview__item">
											<label class="weui-form-preview__label">挂号项目</label>
											<em class="weui-form-preview__value"><%= query.GetItem(i).MedicalProject %></em>
									</div>
									<div class="weui-form-preview__item" style="display: none;">
											<label class="weui-form-preview__label">项目说明</label>
											<em class="weui-form-preview__value"><%= query.GetItem(i).MedicalProjectRemark %></em>
									</div>
									<div class="weui-form-preview__item">
											<label class="weui-form-preview__label">预约时间</label>
											<em class="weui-form-preview__value"><%= query.GetItem(i).BookingDateTime %></em>
									</div>
									
									<div class="weui-form-preview__item">
											<label class="weui-form-preview__label">预约人姓名</label>
											<em class="weui-form-preview__value"><%= query.GetItem(i).MemberName %></em>
									</div>
									
									<div class="weui-form-preview__item">
											<label class="weui-form-preview__label">预约人手机</label>
											<em class="weui-form-preview__value"><%= query.GetItem(i).MemberTel %></em>
									</div>			
									<% 
										if (query.GetItem(i).CheckIn)
										{
											%>
												<div class="weui-form-preview__item">
														<label class="weui-form-preview__label">状态</label>
														<em class="weui-form-preview__value">已报到</em>
												</div> 
												<div class="weui-form-preview__item">
														<label class="weui-form-preview__label">报到时间</label>
														<em class="weui-form-preview__value"><%= query.GetItem(i).CheckInDate %></em>
												</div> 
											<%
										}
										else
										{
											%>
												<div class="weui-form-preview__item">
														<label class="weui-form-preview__label">状态</label>
														<em class="weui-form-preview__value">未报到</em>
												</div>		
												<% 
												TCancelBooking CancelBooking =new TCancelBooking();
												String disabled="btn-danger ";
												if (!CancelBooking.CheckTimeOut(query.GetItem(i).BookingDateTime2))
												{
													disabled="btn-default disabled"; 
												}
												//已付款','客人取消','已退款
												if (query.GetItem(i).StatusType.equals("已付款"))
												{
												%>
												<div style="text-align: center;color: red;">提前<%=TCancelBooking.TimeOoutValue%>小时以上可以取消并退款</div>
												<div>													
													<a class="btn <%=disabled%>" href="javascript:void(0);"	role="button" onclick="CancelBooking('<%= query.GetItem(i).UrlCode %>','<%= query.GetItem(i).MedicalProject %>','<%= query.GetItem(i).BookingDateTime %>');"	style="width:100%" <%=disabled%>>取消预约</a>
												</div>
												<%
												}
												else if ((query.GetItem(i).StatusType.equals("客人取消"))&& (query.GetItem(i).Money>0))
												{
												%>
												<div>
													<a class="btn	btn-danger" href="javascript:void(0);"	role="button" onclick="CancelBooking2('<%= query.GetItem(i).UrlCode %>');"	style="width:100%">退款</a>
												</div>
												<%
												}
												
										}
									%>
							</div>
							
							<div class="weui-form-preview__ft">
								<%
									if (query.GetItem(i).StatusType.equals("待付款"))
										{
										
										%>
											<a class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:;" onclick="pay('<%= query.GetItem(i).UrlCode %>');">确认付款</a>		
										<%
											
										}
								%>
									
							</div>
					</div>
		</div>
				<%
			}
		}
	%>
	</div>
<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
		
<div id="loadingToast" style="display: none;">
	<div class="weui-mask_transparent"></div>
	<div class="weui-toast">
		<i class="weui-loading weui-icon_toast"></i>
		<p class="weui-toast__content">操作中</p>
	</div>
</div>
</body>
</html>