<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
    
	
</head>
<body>
<%
	java.util.Enumeration enu=request.getHeaderNames();//取得全部头信息
    while(enu.hasMoreElements()){//以此取出头信息
        String headerName=(String)enu.nextElement();
        String headerValue=request.getHeader(headerName);//取出头信息内容
%>
        <h5><%=headerName%><font color="red">--></font>
        <font color="blue"><%=headerValue%></font></h5>
<%        
    }
%>
<br><br><br>

        <h5>user-agent<font color="red">--></font>
        <font color="blue"><%=request.getHeader("user-agent")%></font></h5>
        <h5>user-agent index<font color="red">--></font>
        <font color="blue"><%=request.getHeader("user-agent").indexOf("MicroMessenger")%></font></h5>

<br>
window.addEventListener
	<script type="text/javascript">	    
window.addEventListener("popstate", function(e) {  
	console.log("我监听到了浏览器的返回按钮事件啦");
	
    alert("我监听到了浏览器的返回按钮事件啦");//根据自己的需求实现自己的功能  
}, false);  

		$(function(){

			console.log("window.addEventListener");
			window.onpopstate = function(event) {
				   //做一些操作

				console.log("我监听到了浏览器的返回按钮事件啦222");
				history.replaceState(state,'',"blog/index.html");
			    };
			
			
		});	
		
    </script>
    
    
</body>
</html>