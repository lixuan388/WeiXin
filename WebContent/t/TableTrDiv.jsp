<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.jssdk.WXUserInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
    <style type="text/css">
        .unshow{
           display: none;
        }
        tr:hover>td>.unshow {
           background-color: red;
           display:inherit;
           
        }
        tr:hover {
           background-color: blue;
        }
	</style>
</head>
<table class="table">
    <tr>
        <td>100</td>
        <td>200</td>
        <td>300</td>
    </tr>
    <tr>
        <td>100</td>
        <td>200</td>
        <td>300</td>
    </tr>
    <tr>
        <td>100</td>
        <td>200</td>
        <td>300<div class="unshow">123123123</div></td>    
    </tr>
    <tr>
        <td>100</td>
        <td>200</td>
        <td>300</td>
    </tr>
        
</table>

    <div class="container" id="container"></div>

</body>
</html>