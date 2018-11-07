<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.TMemberInfo" %>
<%@ page import="org.apache.catalina.Session" %>


<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  

	String MemberID =request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
    <style type="text/css">
    .page, body {
    	background-color: #f8f8f8;
	}
    
    </style>
	
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
    <div class="container" id="container">
    	<div class="weui-cells__title"><p>个人信息</p></div>    	
		
			<% 
				if (MemberID.equals(""))
				{
					%>
						<span>参数错误！</span>					
					<%
				}
				else
				{
					TMemberInfo memberInfo=new TMemberInfo(MemberID);
					if (memberInfo.ErrCode!=1)
					{
						%>
							<span><%= memberInfo.ErrText %></span>
						<%
					}
					else
					{

						%>
						<form id ="UpdateMemberInfo"" action="/WeiXin/UpdateMemberInfo">
							<div class="weui-cells">
								<div class="weui-cell">
					                <div class="weui-cell__hd"><label class="weui-label">姓&nbsp;&nbsp;名：</label></div>
					                <div class="weui-cell__bd">
					                    <input id="MemberName" class="weui-input"  placeholder="请输入姓名" type="text" value="<%= memberInfo.amb_name %>">
					                    <input style="display: none;" name="MemberName" id="MemberName2" class="weui-input"  placeholder="请输入姓名" type="text" value="<%= memberInfo.amb_name %>">
					                </div>
					            </div>
								<div class="weui-cell">
					                <div class="weui-cell__hd"><label class="weui-label">手机号码：</label></div>
					                <div class="weui-cell__bd">
					                    <input  id="MemberTel" class="weui-input" pattern="[0-9]*" placeholder="请输入手机号码" type="number"  value="<%= memberInfo.amb_Tel %>">
					                    <input style="display: none;" name="MemberTel" id="MemberTel2" class="weui-input" pattern="[0-9]*" placeholder="请输入手机号码" type="number"  value="<%= memberInfo.amb_Tel %>">
					                </div>
					            </div>
				            </div>
				            <div class="weui-cells">
								<div class="weui-cell">
				            		<a href="javascript:Save();" class="weui-btn weui-btn_mini weui-btn_primary">保存</a>
					            </div>
					        </div>
					    </form>
						<%	
					}				     
				}
			%>
	</div>
	<div id="loadingToast" style="display: none;">
        <div class="weui-mask_transparent"></div>
        <div class="weui-toast">
            <i class="weui-loading weui-icon_toast"></i>
            <p class="weui-toast__content">操作中</p>
        </div>
    </div>
<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>    
<script type="text/javascript">
	function Save()
	{
		MemberName=$("#MemberName").val();
		MemberTel=$("#MemberTel").val();
		if (MemberName=="")
		{
			alert("请输入姓名！")
			return;
		}
		if (MemberTel=="")
		{
			alert("请输入手机号码！")
			return;
		}
		$("#MemberName2").val((encodeURI(MemberName)));
		$("#MemberTel2").val((encodeURI(MemberTel)));
		
		$("#UpdateMemberInfo").submit();	
		$("#loadingToast").show();
	}
	
</script>			

</body>
</html>