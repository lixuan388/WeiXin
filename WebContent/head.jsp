<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    String URLDateString=""+request.getSession().getLastAccessedTime();
    %>
    
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	
	<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
	
	<script type="text/javascript" src="/js/date.js?d=<%=URLDateString%>"></script>
	<!--  <script type="text/javascript" src="/js/jquery/jquery.js?d=${ sessionScope.URLDateString}"></script>-->
	
	   <script src="/Res/js/jquery.min.js?d=<%=URLDateString%>"></script>
	  <script src="/Res/js/bootstrap.min.js?d=<%=URLDateString%>"></script>
	  
	  
	<link type="text/css" rel="stylesheet" href="/dist/style/weui.min.css?d=<%=URLDateString%>">
	<link type="text/css" rel="stylesheet" href="<%=request.getContextPath() %>/tx/index.css?d=<%=URLDateString%>">	
	<link type="text/css" rel="stylesheet" href="<%=request.getContextPath() %>/res/css/bootstrap.min.css?d=<%=URLDateString%>">
	<link type="text/css" rel="stylesheet" href="<%=request.getContextPath() %>/res/js/layer/theme/default/layer.css?d=<%=URLDateString%>">
	
	<!--  <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>-->
  <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script>	
  
	<script type="text/javascript" src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/res/js/js.js?d=<%=URLDateString%>"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/res/js/ECityAlert.js?d=<%=URLDateString%>"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/res/js/layer/layer.js?d=<%=URLDateString%>"></script>
	
	 
	
	<style>
    .page, body {
      background-color: #f8f8f8;
     }
  </style> 
<%
	request.setCharacterEncoding("UTF-8") ;  //解决中文乱码的问题
%>
	