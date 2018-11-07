<%@page import="com.java.sql.table.MySQLTable"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/head.jsp" />
<title>Insert title here</title>

<style type="text/css">
html,body{
  box-sizing:border-box;
  margin:0;
  padding:20px;
  height:100%;
  background:#fadaa7;
}
.wrap{
  width:600px;
}
.coupon{
  display:inline-block;
  overflow:hidden;
  border-radius:10px;
}
.coupon-left{
  float:left;
  width:150px;
  height:150px;
  position:relative;
}
.coupon-left::before{
  content: '';
  position: absolute;
  top: -210px;
  display: block;
  right: -210px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  border: 200px solid #252525;
  clip: rect(auto,auto,285px,auto);
}
.coupon-left::after{
  content: '';
  position: absolute;
  bottom: -210px;
  display: block;
  right: -210px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  border: 200px solid #252525;
  clip: rect(135px,auto,auto,auto);
}
.coupon-con{
  float:left;
  width:350px;
  height:150px;
  position:relative;
}
.coupon-con::before{
  content: '';
  position: absolute;
  top: -410px;
  display: block;
  left: -410px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  border: 400px solid #fff;
  clip: rect(0,auto,485px,410px);
}
.coupon-con::after{
  content: '';
  position: absolute;
  bottom: -410px;
  display: block;
  left: -410px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  border: 400px solid #fff;
  clip: rect(335px,auto,auto,410px);
}

</style>
</head>
<body>

<div class="wrap">
  <div class="coupon">
    <div class="coupon-left"></div>
    <div class="coupon-con"></div>
  </div>
</div>
</body>
</html>



