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
	if (BookingDateByUrlID.GetItem(0).PrepayID.equals(""))
	{

		//String body=BookingDateByUrlID.GetItem(0).MedicalProject+"挂号费";
		String body=BookingDateByUrlID.GetItem(0).MedicalProject+"挂号费 "+BookingDateByUrlID.GetItem(0).BookingDateTime+"";
		body=new String(body.getBytes("UTF-8"),"UTF-8");
	
		String out_trade_no=BookingDateByUrlID.GetItem(0).UrlCode;
		int total_fee= (int)(BookingDateByUrlID.GetItem(0).Money*100);
		//int total_fee=1;
		String product_id="OrderID"+BookingDateByUrlID.GetItem(0).OrderID;
		WXUnifiedorder unifiedorder=new WXUnifiedorder(request,body,out_trade_no,total_fee,product_id,openid);
		if (!unifiedorder.GetReturnList().get("return_code").equals("SUCCESS"))
		{
			String ErrText="申请微信支付失败！<br>return_msg："+unifiedorder.GetReturnList().get("return_msg");
			GlobalVariable.GoErrerHtml(request,response,ErrText);
			return;
		}
		if (!unifiedorder.GetReturnList().get("result_code").equals("SUCCESS"))
		{
			String ErrText="申请微信支付失败！<br>err_code："+unifiedorder.GetReturnList().get("err_code")+"<br>err_code_des:"+unifiedorder.GetReturnList().get("err_code_des");
			GlobalVariable.GoErrerHtml(request,response,ErrText);
			return;
		}
		
		prepay_id=unifiedorder.GetReturnList().get("prepay_id");
	}
	else
	{
		prepay_id=BookingDateByUrlID.GetItem(0).PrepayID;
	}
	
	WXChooseWXPay chooseWXPay=new WXChooseWXPay(prepay_id);

	WXConfig c=new WXConfig(request,"/tx/pay/WaitPay.jsp?"+request.getQueryString());
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
<script type="text/javascript">


wx.config({
    debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
    appId: '<%= c.appId %>', // 必填，公众号的唯一标识
    timestamp: <%= c.timestamp %> , // 必填，生成签名的时间戳
    nonceStr: '<%= c.nonceStr %>', // 必填，生成签名的随机串
    signature: '<%= c.signature %>',// 必填，签名，见附录1
    jsApiList: ['chooseWXPay'] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
});
wx.error(function(res){
	console.log('wx.error');
	console.log(res);
});
wx.ready(function(){
	console.log('wx.ready');   

	Pay();		
});

function Pay()
{
	wx.chooseWXPay({
		timestamp:<%= chooseWXPay.timestamp %>, // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
		nonceStr: '<%= chooseWXPay.nonceStr %>', // 支付签名随机串，不长于 32 位
		package: '<%= chooseWXPay.Package %>', // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=***）
		signType: '<%= chooseWXPay.signType %>', // 签名方式，默认为'SHA1'，使用新版支付需传入'MD5'
		paySign: '<%= chooseWXPay.paySign %>', // 支付签名
		success: function (res) {
			// 支付成功后的回调函数
			window.location.href="/WeiXin/tx/index.jsp?d="+new Date().Format("yyyyMMddHHmmss"); 
		}
	});
}	

</script>
	
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
            				<a class="weui-form-preview__btn weui-form-preview__btn_default" href="/WeiXin/tx/index.jsp" style="color:red;">返回首页</a>		
            			<%
	            	}
            	%>
            </div>
       	</div>
	</div>  
	<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
</body>
</html>