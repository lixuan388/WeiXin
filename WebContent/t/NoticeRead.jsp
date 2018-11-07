<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">  
	<jsp:include page="/head.jsp"/>
	
<title>Insert title here</title>
</head>
<body>
<button onclick="open();">公告</button>

<jsp:include page="/tx/Notice/NoticeJS.jsp" flush="true">     
     <jsp:param name="type" value="2"/> 
</jsp:include> 
</body>
</html>