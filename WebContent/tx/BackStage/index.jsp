<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.java.web.weixin.base.GlobalVariable"%>
<%
	String openid=request.getSession().getAttribute("openid")==null?"":(String)request.getSession().getAttribute("openid");

	
	if (openid.equals(""))
	{
	    HttpServletRequest httpRequest=(HttpServletRequest)request;  
      String WebUrl =request.getScheme() +"://" + request.getServerName(); //服务器地址
/*      if (request.getServerPort()!=80)
      {
        WebUrl=WebUrl + ":" + request.getServerPort();           //端口号
      } */
	    WebUrl=WebUrl+httpRequest.getContextPath()+"/Authorize";
	    WebUrl="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+GlobalVariable.AppID+"&redirect_uri="+ URLEncoder.encode(WebUrl, "utf-8") +"&response_type=code&scope=snsapi_base&state=1&connect_redirect=1#wechat_redirect";
		response.sendRedirect(WebUrl);		
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/head.jsp" />
<script type="text/javascript">	    
	    $(function(){
	        $('a').on('click', function(){
	        $('#loadingToast').show();
	        });
	    });	    
    </script>
</head>
<body>
  <jsp:include page="/res/temple/TabbarMenuBegin.jsp" />
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="/WeiXin/tx/BackStage/MedicalProjectEdit.jsp">
      <div class="weui-cell__bd">
        <p>预约项目设置</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="/WeiXin/tx/BackStage/MedicalProjectScheduleEdit.jsp">
      <div class="weui-cell__bd">
        <p>排班设置</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="/WeiXin/tx/BackStage/MedicalProjectTimeNumberEdit.jsp">
      <div class="weui-cell__bd">
        <p>时间段人数设置</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div id="loadingToast" style="display: none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
      <i class="weui-loading weui-icon_toast"></i>
      <p class="weui-toast__content">操作中</p>
    </div>
  </div>
  <jsp:include page="/res/temple/TabbarMenuEnd.jsp" />
</body>
</html>