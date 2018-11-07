<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.java.web.weixin.base.GlobalVariable" %>
<%@ page import="com.java.web.weixin.jssdk.WXConfig" %>
<%@ page import="com.java.web.weixin.jssdk.WXUnifiedorder" %>
<%@ page import="com.java.web.weixin.jssdk.WXChooseWXPay" %>
<%@ page import="com.java.web.weixin.tx.Class.booking.TQueryBookingDateByUrlID" %>


<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  
	

	String code =request.getParameter("code")==null?"":request.getParameter("code");
	
	if (code.equals(""))
	{
		String ErrText="参数错误！(UrlCode)";
		GlobalVariable.GoErrerHtml(request,response,ErrText);
		return;
	}

	String openid=request.getSession().getAttribute("openid")==null?"":(String)request.getSession().getAttribute("openid");
	if (openid.equals(""))
	{
		String ErrText="参数错误！(openid)";
		GlobalVariable.GoErrerHtml(request,response,ErrText);
		return;
	}	

	TQueryBookingDateByUrlID BookingDateByUrlID=new TQueryBookingDateByUrlID(code);
	if (BookingDateByUrlID.ErrCode!=1)
	{
		String ErrText="订单信息查询失败！"+BookingDateByUrlID.ErrText;
		GlobalVariable.GoErrerHtml(request,response,ErrText);
		return;
	}
	
	if (BookingDateByUrlID.Length()!=1)
	{
		String ErrText="订单记录异常，无法付款！(Length="+BookingDateByUrlID.Length()+")";
		GlobalVariable.GoErrerHtml(request,response,ErrText);
		return;
	}
	
	String prepay_id;
	
	prepay_id=BookingDateByUrlID.GetItem(0).PrepayID;
	
	WXChooseWXPay chooseWXPay=new WXChooseWXPay(prepay_id);

	WXConfig c=new WXConfig(request,"/tx/pay/MiniWaitPayShow.jsp?"+request.getQueryString());
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
	
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
	<div class="weui-cells__title"><p>付款</p></div> 
	<div  class="weui-cells">
		<div class="weui-form-preview">
            <div class="weui-form-preview__hd">
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">付款单号</label>
                    <em class="weui-form-preview__value" style="font-size: 12px"><%= BookingDateByUrlID.GetItem(0).UrlCode %></em>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">付款金额</label>
                    <em class="weui-form-preview__value">¥<%= BookingDateByUrlID.GetItem(0).Money %></em>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">付款状态</label>
                    <%
                    	String Color="";
                    	if (BookingDateByUrlID.GetItem(0).StatusType.equals("待付款"))
                    	{
                    		Color="color:red;";
                    	}
                    %>
                    <em class="weui-form-preview__value" style="font-size: 16px;<%= Color %>"><%= BookingDateByUrlID.GetItem(0).StatusType %></em>
                </div>
                <% 
                	if (!BookingDateByUrlID.GetItem(0).PayDate.equals(""))
                	{
                		%>
		                <div class="weui-form-preview__item">
		                    <label class="weui-form-preview__label">付款时间</label>
		                    <em class="weui-form-preview__value"><%= BookingDateByUrlID.GetItem(0).PayDate %></em>
		                </div>
                		<%
                		
                	}
                %>
            </div>
            <div class="weui-form-preview__bd">				            
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">挂号项目</label>
                    <em class="weui-form-preview__value"><%= BookingDateByUrlID.GetItem(0).MedicalProject %></em>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">项目说明</label>
                    <em class="weui-form-preview__value"><%= BookingDateByUrlID.GetItem(0).MedicalProjectRemark %></em>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">预约时间</label>
                    <em class="weui-form-preview__value"><%= BookingDateByUrlID.GetItem(0).BookingDateTime %></em>
                </div>
                
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">预约人姓名</label>	                    
                    <em class="weui-form-preview__value"><%= BookingDateByUrlID.GetItem(0).MemberName %></em>
                </div>
                
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">预约人手机</label>
                    <em class="weui-form-preview__value"><%= BookingDateByUrlID.GetItem(0).MemberTel %></em>
                </div>      	                      
            </div>	            
            <div class="weui-form-preview__ft">
            	<%
	            	if (BookingDateByUrlID.GetItem(0).StatusType.equals("待付款"))
                	{
	            		%>
	            			<a class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:;" onclick="Pay();">确认付款</a>		
	            		<%
                	}
	            	else
	            	{
	            		%>
            				<a class="weui-form-preview__btn weui-form-preview__btn_default" href="<%=request.getContextPath()%>/tx/index.jsp" style="color:red;">返回首页</a>		
            			<%
	            	}
            	%>
            </div>
       	</div>
	</div>  
	<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
</body>
</html>