<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.base.GlobalVariable" %>
<%@ page import="com.java.web.weixin.jssdk.WXSnsapiBaseCode" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.net.URLEncoder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

	<script type="text/javascript" src="/js/date.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
		
<title>Insert title here</title>
</head>
<body>



<a id="gotoindex" href="/WeiXin/test/GoToIndex.jsp?openid=oziEnwXc5eWwN9HOIn8AxV7eFDfE">
go to index.jsp
</a>






<script type="text/javascript">
$(function ()
{	
	$.ajax({
        url:"http://www.jackiehor.org/WeiXin/token",
        type:'get',
        dataType:'Json',
        success:function(data){
        	$("#gotoindex").attr("href","/WeiXin/test/GoToIndex.jsp?AccessToken="+data.AccessToken+"&jsapi_ticket="+data.jsapi_ticket);
        	$("#gotoindex").html("/WeiXin/test/GoToIndex.jsp?AccessToken="+data.AccessToken+"&jsapi_ticket="+data.jsapi_ticket);
        }
	});	
	
});		
</script>

</body>
</html>