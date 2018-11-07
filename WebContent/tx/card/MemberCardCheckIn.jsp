<%@page import="com.java.web.weixin.base.GlobalVariable"%>
<%@page import="com.java.sql.table.MySQLTable"%>
<%@page import="com.java.web.weixin.tx.Class.message.TMessageCheckIn"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%

Date now=new Date();    //创建一个Date对象，获取当前时间
//指定格式化格式
SimpleDateFormat f=new SimpleDateFormat("yyyy年 MM月dd日HH时mm分");


String MemberID =request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");


MySQLTable Card=new MySQLTable("select amc_id,amc_GuestName,amc_GuestTel,amc_CreateDate,amc_Count,amc_EndDate from amc_member_card where amc_id_amb='"+MemberID+"'");

String amc_id="";
String amc_GuestName="";
String amc_GuestTel="";

try
{
  Card.Open();
  if (!Card.next())
  {
    %>
    无次卡信息！
    <%
    return;    
  }
  amc_id=Card.getString("amc_id");
  amc_GuestName=Card.getString("amc_GuestName");
  amc_GuestTel=Card.getString("amc_GuestTel");
}
finally
{
  Card.Close();  
}
  
      
      
//String touser="oziEnwXc5eWwN9HOIn8AxV7eFDfE";
String touser=GlobalVariable.AdminWeiXinOpenID;
String url=request.getScheme()+"://"+request.getServerName()+request.getContextPath()+"/tx/card/MemberCardEdit.jsp?ID="+amc_id+"&d="+request.getSession().getLastAccessedTime();  

System.out.print(url);
String first="客人签到！";
String keyword1=amc_GuestName+"/"+amc_GuestTel;
String keyword2=f.format(now); 
String remark="点击可直接跳转至次卡页面";
TMessageCheckIn checkin=new TMessageCheckIn(touser,url,first,keyword1,keyword2,remark);
checkin.Send();


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
<div class="page msg_success js_show">
    <div class="weui-msg" style="
    height: 100vh;
">
        <div class="weui-msg__icon-area"><i class="weui-icon-success weui-icon_msg"></i></div>
        <div class="weui-msg__text-area" style="
    height: calc(100vh - 326px);
">
            <h2 class="weui-msg__title">签到成功</h2>
            
            <p class="weui-msg__desc">请与店员联系</p>
        </div>
        <div class="weui-msg__opr-area">
            <p class="weui-btn-area">
                <a href="<%=request.getContextPath() %>/tx/index.jsp" class="weui-btn weui-btn_primary">返回主页</a>
            </p>
        </div>
        <div class="weui-msg__extra-area">
            <div class="weui-footer">
                <p class="weui-footer__links">
                    <a href="javascript:void(0);" class="weui-footer__link">童心美容</a>
                </p>
                <p class="weui-footer__text">Copyright ©2019 jackiehor.cn</p>
            </div>
        </div>
    </div>
</div>
</body>
</html>