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
		WXUnifiedorder unifiedorder=new WXUnifiedorder(request,body,out_trade_no,total_fee,product_id,openid,"wx49021171260b4f00");
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
    jsApiList: [] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
});
wx.error(function(res){
	console.log('wx.error');
	console.log(res);
	//alert(res);
});
wx.ready(function(){
	console.log('wx.ready');   
	wx.miniProgram.navigateTo({url: 'RequestPayment?code=<%=code%>&<%=chooseWXPay.urlhttp("wx49021171260b4f00", prepay_id)%>'})
});

</script>
	
</head>
<body>

</body>
</html>