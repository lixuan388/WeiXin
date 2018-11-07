<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.java.web.weixin.base.GlobalVariable" %>
<%



java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmmss");   
java.util.Date currentTime = new java.util.Date();//得到当前系统时间   
String str_date1 = formatter.format(currentTime); //将日期时间格式化  

session.setAttribute("URLDateString", str_date1);
 


	String openid=request.getSession().getAttribute("openid")==null?"":(String)request.getSession().getAttribute("openid");
	String nickname=request.getSession().getAttribute("nickname")==null?"":(String)request.getSession().getAttribute("nickname");
	String headimgurl=request.getSession().getAttribute("headimgurl")==null?"":(String)request.getSession().getAttribute("headimgurl");
	String groupid=request.getSession().getAttribute("groupid")==null?"":(String)request.getSession().getAttribute("groupid");
	
	headimgurl=headimgurl.replace("/0", "/132");
	
	if (openid.equals(""))
	{

    System.out.println("index not openid sendRedirect " );
	    HttpServletRequest httpRequest=(HttpServletRequest)request;  
	    String WebUrl =request.getScheme() +"://" + request.getServerName(); //服务器地址
/* 	    if (request.getServerPort()!=80)
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
	<jsp:include page="/head.jsp"/>
	
    <style type="text/css">
	.txspan
	{
		font-size:12px;
		height:15px;
		display: block;
	}
	
	.TabbarPage {
	    top: 200px;
	}
	
	.weui-panel {
	    margin: 5px;
	}
	.weui-media-box__desc {
	    -webkit-line-clamp: 10000; 
	}
    </style>	
    <script type="text/javascript">	    
	    $(function(){
	        $('a').on('click', function(){
	        		$('#loadingToast').show();					
	        });
	        
	    	//var data=<jsp:include page="/BackStage/GetBaseParameter?id=webremark"/>
			//$("#webremark").html(data.DataRows.Value);
			
	    	//var data2=<jsp:include page="/BackStage/GetBaseParameter?id=operationremark"/>
			//$("#operationremark").html(data2.DataRows.Value);
    	
	    });	    
    </script>
    
    
<jsp:include page="/tx/Notice/NoticeJS.jsp" flush="true">     
     <jsp:param name="type" value="1"/> 
</jsp:include> 
</head>
<body>

<div style="position:relative;">
	<img alt="" src="<%=request.getContextPath() %>/image/backgroud.png" style="width:100%;height:200px">
	<img alt="" src="<%= headimgurl %>" style="position: absolute;left: 50%;top: 15px;width: 96px;height: 96px;z-index: -100;
    border-radius: 50%;    margin-left: -48px; ">
	<span style="position: absolute;left: 50%;top: 110px;width: 96px;height: 30px;background-color: white;text-align: center;margin-left: -48px;"><%= nickname %></span>
	<div style="position: absolute;left: 0px;top: 155px;width:100%;height:45px;background-color:#000000;font-size:12px;opacity: 0.5;color: white;">
	</div>
	<div style="position: absolute;left: 0px;/*top: 155px;*/width:100%;font-size:12px;color: white;    bottom: 0px;">
		<span class="txspan">&nbsp;&nbsp;感谢支持童心美容</span>
		<span class="txspan" style="color: #FFB300;">&nbsp;&nbsp;西华路司马街38号</span>
		<span class="txspan"style="color: #B7B2B2;">&nbsp;&nbsp;网络预约，次卡查询</span>
	</div>
</div>


<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>


<div class="weui-panel weui-panel_access">
</div>

		<div class="weui-panel weui-panel_access">
            <div class="weui-panel__bd">
                <div class="weui-media-box weui-media-box_text">
                    <h4 class="weui-media-box__title">简介</h4>
                    <p  id="webremark" class="weui-media-box__desc" ><%= System.getProperty("WeiXin.tx.webremark")  %></p>
                </div>
            </div>
        </div>


		    <div class="weui-panel weui-panel_access">
            <div class="weui-panel__bd">
                <div class="weui-media-box weui-media-box_text">
                    <h4 class="weui-media-box__title">预约操作说明</h4>
                    <p  id="operationremark" class="weui-media-box__desc"><%= System.getProperty("WeiXin.tx.operationremark")  %></p>
                </div>
            </div>
        </div>


<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>    



    <div id="loadingToast" style="display: none;">
        <div class="weui-mask_transparent"></div>
        <div class="weui-toast">
            <i class="weui-loading weui-icon_toast"></i>
            <p class="weui-toast__content">操作中</p>
        </div>
    </div>
	
</body>
</html>