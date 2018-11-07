<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.jssdk.WXUserInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
    <link rel="stylesheet" href="/dist/example/example.css"/>
    <%
    System.out.println("getCharacterEncoding:"+request.getCharacterEncoding());
    System.out.println("defaultCharset:"+java.nio.charset.Charset.defaultCharset());
    

		String body=new String("挂号费黄小贞中医周五 （2017-10-23）(123)");
	System.out.println("body:"+body.toCharArray()[0]);

	System.out.println("body UTF-8:"+new String(body.getBytes("UTF-8"),"UTF-8"));
	System.out.println("body ISO-8859-1:"+new String(body.getBytes("ISO-8859-1"),"ISO-8859-1"));
	System.out.println("body GBK:"+new String(body.getBytes("GBK"),"GBK"));
	System.out.println("body GB2312:"+new String(body.getBytes("GB2312"),"GB2312"));
	System.out.println("body URLEncoder:"+java.net.URLEncoder.encode(body,"UTF-8"));
	
	
	
	String a = body; 
	String b=new String(a.getBytes("gbk"),"ISO-8859-1"); 
	System.out.println(b); 
	String c=new String(b.getBytes("ISO-8859-1"),"utf-8"); 
	System.out.println(c);
	
	
    
    %>
    
	
</head>
    <div class="weui-toptips weui-toptips_warn js_tooltips">错误提示</div>

    <div class="container" id="container"></div>

    <script type="text/html" id="tpl_home"></script>
    <script type="text/html" id="tpl_tabbar">
<div class="page">
    <div class="page__bd" style="height: 100%;">
        <div class="weui-tab">
            <div class="weui-tab__panel">

            </div>
            <div class="weui-tabbar">
                <a href="javascript:;" class="weui-tabbar__item weui-bar__item_on">
                    <span style="display: inline-block;position: relative;">
                        <img src="./images/icon_tabbar.png" alt="" class="weui-tabbar__icon">
                        <span class="weui-badge" style="position: absolute;top: -2px;right: -13px;">8</span>
                    </span>
                    <p class="weui-tabbar__label">微信</p>
                </a>
                <a href="javascript:;" class="weui-tabbar__item">
                    <img src="./images/icon_tabbar.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">通讯录</p>
                </a>
                <a href="javascript:;" class="weui-tabbar__item">
                    <span style="display: inline-block;position: relative;">
                        <img src="./images/icon_tabbar.png" alt="" class="weui-tabbar__icon">
                        <span class="weui-badge weui-badge_dot" style="position: absolute;top: 0;right: -6px;"></span>
                    </span>
                    <p class="weui-tabbar__label">发现</p>
                </a>
                <a href="javascript:;" class="weui-tabbar__item">
                    <img src="./images/icon_tabbar.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">我</p>
                </a>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        $('.weui-tabbar__item').on('click', function () {
            $(this).addClass('weui-bar__item_on').siblings('.weui-bar__item_on').removeClass('weui-bar__item_on');
        });
    });
</script>
</script>
    

    <script src="/dist/example/zepto.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
    <script src="/dist/example/example.js"></script>
</body>
</html>