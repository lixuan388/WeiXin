<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.base.GlobalVariable" %>
<%@ page import="com.java.web.weixin.jssdk.WXConfigOutPrint" %>


<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
<script type="text/javascript">
<%
WXConfigOutPrint c=new WXConfigOutPrint(request,"");
out.println(c.ReturnString);
%>

wx.onMenuShareTimeline({
	  title: '分享标题', // 分享标题
	  link: 'http://www.17ecity.cc/WeiXin/test/WeiXinShare.jsp?aads=123123', // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
	  imgUrl: 'http://www.17ecity.cc/ThermosFile/efd7f58895ae462cba3dee62b07ab912.jpg', // 分享图标
	  success: function () {
	    // 用户确认分享后执行的回调函数
	  },
	  cancel: function () {
	    // 用户取消分享后执行的回调函数
	  }
	});
wx.onMenuShareAppMessage({
	  title: '分享标题', // 分享标题
	  desc: '分享描述', // 分享描述
	  link: 'http://www.17ecity.cc/WeiXin/test/WeiXinShare.jsp?aads=123123', // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
	  imgUrl: 'http://www.17ecity.cc/ThermosFile/efd7f58895ae462cba3dee62b07ab912.jpg', // 分享图标
	  type: 'link', // 分享类型,music、video或link，不填默认为link
	  dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
	  success: function () {
	    // 用户确认分享后执行的回调函数
	  },
	  cancel: function () {
	    // 用户取消分享后执行的回调函数
	  }
});


</script>
	
</head>
<body>
request.getQueryString():<%= request.getQueryString() %>
<br>
<%

HttpServletRequest httpRequest=(HttpServletRequest)request;  
System.out.println("httpRequest.getPathInfo() :"+httpRequest.getPathTranslated());
%>
request.getRequestURL():<%= httpRequest.getRequestURL() %>

</body>
</html>