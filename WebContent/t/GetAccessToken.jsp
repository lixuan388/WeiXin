<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	
    
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery.form.js"></script>
</head>
<body>    

<div>
	<input type="button" value="Get Access Token" onclick="GetAccessToken();">
	<br>
	<input type="text" id="AccessToken" size=200>
</div>
<div id="msg">

</div>

<script type="text/javascript">

	function GetAccessToken()
	{
		$.ajax({
	        url:"/WeiXin/GetAccessToken",
	        type:'get',
	        dataType:'Json',
	        success:function(data){
	        	$("#AccessToken").val(data.access_token);
	        }
		});	
	}
	
	
	
</script>
</body>
</html>