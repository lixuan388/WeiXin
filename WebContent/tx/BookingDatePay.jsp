<%@page import="com.java.web.weixin.jssdk.WXConfig"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.booking.TBookingDatePay" %>
<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  
	

	String ID =request.getParameter("ID")==null?"0":request.getParameter("ID");	
	String MemberID =request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");
	String amb_Level =request.getSession().getAttribute("amb_Level")==null?"":(String)request.getSession().getAttribute("amb_Level");

	TBookingDatePay BookingDatePay=new TBookingDatePay(ID,MemberID,amb_Level);
	
	
	String MemberName =request.getSession().getAttribute("MemberName")==null?"":(String)request.getSession().getAttribute("MemberName");
	String MemberTel =request.getSession().getAttribute("MemberTel")==null?"":(String)request.getSession().getAttribute("MemberTel");


  WXConfig c=new WXConfig(request,"/tx/MedicalProjectSelect2018.jsp");
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
    
    .info {
	    font-size: 20px;
	    line-height: 2em;
	}

	.info input.red{ 
		border-bottom:1px solid red; 
		background:#FFF; 
	}
    .info label {
    	Color: red;
	    background-color: #ccc;
	    width: 100%;
	}

	.info input {
	    background-color: #ececec;
	    color: black;
	    line-height: 1.5em;
	    font-size: 20px;
	    height: 1.5em;
	    border-bottom: 1px solid black;
	    margin-bottom: 2px;
	}

    </style>
    
    <script type="text/javascript">
    var isWxMini=false;
    wx.config({
      debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
      appId: '<%= c.appId %>', // 必填，公众号的唯一标识
      timestamp: <%= c.timestamp %> , // 必填，生成签名的时间戳
      nonceStr: '<%= c.nonceStr %>', // 必填，生成签名的随机串
      signature: '<%= c.signature %>',// 必填，签名，见附录1
      jsApiList: [] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
    });
    wx.error(function(res){
      console.log('wx.error');
    });
    wx.ready(function(){
      isWxMini = window.__wxjs_environment === 'miniprogram';
    });
  
	function pay()
	{
		BookName=$("#BookName").val();
		BookTel=$("#BookTel").val();
		if (BookName=="")
		{
			alert("请填写预约人姓名！");
			return;
		}
		if (BookTel=="")
		{
			alert("请填写预约人电话！");
			return;
		}
		BookName=encodeURI(encodeURI(BookName));
		BookTel=encodeURI(encodeURI(BookTel));
		

		window.location.href="<%=request.getContextPath()%>/BookingDatePay?Name="+BookName+"&Tel="+BookTel+"&isWxMini="+isWxMini+"&d="+new Date();  

	}
	

	function shake(ele,cls,times)
	{
		var i = 0,t= false ,o =ele.attr("class")+" ",c ="",times=times||2;
		if(t) return;
		t= setInterval(function(){
			i++;
			c = i%2 ? o+cls : o;
			ele.attr("class",c);
			if(i==2*times){
				clearInterval(t);
				ele.removeClass(cls);
				shake(ele,cls,times)
			}
		},500);
	};
	
	$(function(){
		//domready 就闪动
		shake($(".info>input"),"red",3);

	});

	$(function(){
		//history.replaceState(null, "", "<%=request.getContextPath()%>/tx/MedicalProjectSelect.jsp");
	  history.replaceState(null, "", "<%=request.getContextPath()%>/tx/MedicalProjectSelect2018.jsp");
	});	
	
</script>	
	
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
	<div class="weui-cells__title"><p>挂号付款</p></div>    
	<%
		if (BookingDatePay.ErrCode!=1)
		{
			%>
			<span><%= BookingDatePay.ErrText %></span>
			<%
		}
		else
		{
			if (BookingDatePay.MaxBooking<=BookingDatePay.HasBooking)
			{
				%>
					<span>此时间已预约满，请选择其它时间!</span>
				<%
			}
			else
			{
				request.getSession().setAttribute("BookingID",ID);
				%>
				<div class="weui-form-preview">
		            <div class="weui-form-preview__hd">
		                <div class="weui-form-preview__item">
		                    <label class="weui-form-preview__label">付款金额</label>
		                    <em class="weui-form-preview__value">¥<%= BookingDatePay.Money %></em>
		                </div>
		            </div>
		            <div class="weui-form-preview__bd">
					            
		                <div class="weui-form-preview__item">
		                    <label class="weui-form-preview__label">挂号项目</label>
		                    <em class="weui-form-preview__value"><%= BookingDatePay.name %></em>
		                </div>
		                <div class="weui-form-preview__item">
		                    <label class="weui-form-preview__label">项目说明</label>
		                    <em class="weui-form-preview__value" style="text-align: left;"><%= BookingDatePay.remark %></em>
		                </div>
		                <div class="weui-form-preview__item">
		                    <label class="weui-form-preview__label">预约时间</label>
		                    <em class="weui-form-preview__value"><%= BookingDatePay.bookingdatetime %></em>
		                </div>
		            </div>
		                
		            <div class="weui-form-preview__bd">
					            
		                <div class="weui-form-preview__item info">
		                    <label class="weui-form-preview__label">预约人姓名(请填写真实姓名)</label>
		                    <input id="BookName" class="weui-form-preview__value weui-input" placeholder="请输入预约人姓名" type="text"  value="<%= MemberName %>">
		                </div>
		                
		                <div class="weui-form-preview__item info">
		                    <label class="weui-form-preview__label">预约人手机</label>
			                    <input id="BookTel" class="weui-form-preview__value weui-input" placeholder="请输入手机号" type="tel"  value="<%= MemberTel %>">
		                </div>
					                
					                
		            </div>
		            <div class="weui-form-preview__ft">
		                <a class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:;" onclick="pay();">确认预约信息并付款</a>
		            </div>
	        	</div>
	        <%
			}
		}
	%>
<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
		
	
</body>
</html>