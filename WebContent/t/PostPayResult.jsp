<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<title>jpg</title>
</head>
<body >

<button onclick="SendData()">上传JPG</button>
<br>
<input id="jpgPath" type="text"style="width:1000px"><br>

<div id="SuccessText"></div>

<script type="text/javascript">

function SendData()
{	
	var sealImg="<xml><appid><![CDATA[wx8af2e5e7b3163da1]]></appid><attach></attach><body><![CDATA[中医挂号费(123)]]></body><detail></detail><device_info><![CDATA[公众号支付]]></device_info><fee_type><![CDATA[CNY]]></fee_type><goods_tag></goods_tag><limit_pay></limit_pay><mch_id><![CDATA[1386603002]]></mch_id><nonce_str><![CDATA[d874fe61da224b8590fe21898869b23]]></nonce_str><notify_url><![CDATA[http://192.168.1.103:8080/WeiXin/PayResult]]></notify_url><openid><![CDATA[oziEnwXc5eWwN9HOIn8AxV7eFDfE]]></openid><out_trade_no><![CDATA[PID201708280102355260]]></out_trade_no><product_id><![CDATA[OrderID549]]></product_id><scene_info></scene_info><sign_type><![CDATA[MD5]]></sign_type><spbill_create_ip><![CDATA[192.168.1.103]]></spbill_create_ip><time_expire><![CDATA[20170828011235]]></time_expire><time_start><![CDATA[20170828010235]]></time_start><total_fee><![CDATA[1]]></total_fee><trade_type><![CDATA[JSAPI]]></trade_type><sign>5D1B3C930638422982DBCC2F93470AC1</sign></xml>";
	$.ajax({
        url:"/WeiXin/test",
        type:'POST',
        data: sealImg,
        dataType:'html',
        success:function(data){
        	$("#SuccessText").html(data);	
        }
	});	
	
}		
</script>


</body>
</html>