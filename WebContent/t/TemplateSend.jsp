<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.base.GlobalVariable" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <meta http-equiv="Access-Control-Allow-Origin" content="*">

	<script type="text/javascript" src="/js/date.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
		
<title>Insert title here</title>
</head>
<body>

<div id ="gotoindex">
<% 
	String url="https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=Tktanc4JzGjXtlWg-7bTHEqgp9KPhFBbb6Buksevn_Fr_2pJBVvjeVP5Pvw7HA2J58cC9holmG5EKDoza6g5zerYivDMtFRt6vwrOg8ZCjUYf_qM8v1Y1EAl2XvsjTzPQVJbAAAVAO";
	String Data="{\"touser\":\"oziEnwXc5eWwN9HOIn8AxV7eFDfE\","+
			"\"template_id\":\"-LvbW5QwKcvWk1rrdbA6xbGvA92dZnKncej4hdSV7P0\","+
			"\"url\":\"\",	"+
			"\"miniprogram\":{},"+
			"\"data\":{"+					
					"\"first\":{\"value\":\"恭喜您已经预约成功！\",\"color\":\"#173177\"},"+
					"\"keyword1\":{\"value\":\"水光针注射\",\"color\":\"#173177\"},"+
 					"\"keyword2\":{\"value\":\"2014年7月21日 18:36\",\"color\":\"#173177\"},"+
					"\"keyword3\":{\"value\":\"2014年7月21日 18:36\",\"color\":\"#173177\"},"+
					"\"keyword4\":{\"value\":\"2014年7月21日 18:36\",\"color\":\"#173177\"},"+
					"\"remark\":{\"value\":\"2014年7月21日 18:36\",\"color\":\"#173177\"}"+

			"}}";
	//GlobalVariable.sendHttpPost(url,Data);	
%>
</div>


<script type="text/javascript">
$(function ()
		{	
			$.ajax({
		        url:"/WeiXin/MessageTemplateSend?touser=oziEnwXc5eWwN9HOIn8AxV7eFDfE&template_id=-LvbW5QwKcvWk1rrdbA6xbGvA92dZnKncej4hdSV7P0&first="+encodeURI(encodeURI("恭喜您已经预约成功！"))+"&keyword1="+encodeURI(encodeURI("水光针注射"))+"&keyword2="+encodeURI(encodeURI("2014年7月21日 18:36"))+"&remark="+encodeURI(encodeURI("2014年7月21日 18:36")),
		        type:'get',
		        dataType:'Json',
		        success:function(data){
		        	console.log(data);
		        	$("#gotoindex").html("errcode:"+data.errcode+"<br>errmsg:"+data.errmsg+"<br>msgid:"+data.msgid);
		        }
			});	
			
		});	

</script>

</body>
</html>