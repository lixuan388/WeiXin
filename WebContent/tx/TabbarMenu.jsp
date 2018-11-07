<%@page import="com.java.version"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.booking.TQueryMemberBookingDateList"%>
<%@ page import="com.java.web.weixin.base.GlobalVariable"%>
<%@ page import="org.apache.catalina.Session"%>
<%

	String ID=request.getParameter("id")==null?"1":(String)request.getParameter("id");
	if (ID.equals("1"))
	{
		response.sendRedirect(request.getContextPath()+"/tx/index.jsp");
		return;
	}
	else if (ID.equals("2"))
	{
	  //response.sendRedirect(request.getContextPath()+"/tx/MedicalProjectSelect.jsp");
    response.sendRedirect(request.getContextPath()+"/tx/MedicalProjectSelect2019.jsp");
		return;
	}
	else if (ID.equals("4"))
	{
		response.sendRedirect(request.getContextPath()+"/tx/card/MemberCard.jsp");
		return;
	}
		
	Integer id=Integer.parseInt(ID);
%>
<!DOCTYPE html>
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
<style type="text/css">
p {
  margin: 0px;
}

.on>span.early0, .off>span.early0, .late>span.early0, .early>span.early0 {
  color: black;
  font-weight: 100;
}

.on>span, .off>span, .late>span, .early>span {
  color: red;
  font-weight: 800;
}

.day {
  font-weight: 800;
}

.daydiv {
  border: 1px solid silver;
  border-radius: 5px;
  padding: 1px;
  height: 100%;
  width: 100%;
}

.daydiv2.daydiv3 {
  border-color: red;
}

.daydiv2.daydiv3 .null {
  background-color: red;
  display: inline-block;
  width: 90%;
  border-radius: 5px;
}

.daydiv2 {
  border-color: #749dff;
}
</style>
</head>
<body>
  <jsp:include page="/res/temple/TabbarMenuBegin.jsp" />
  <%

	switch (id) {
	case 3:
		///////////////////////////我////////////////////////////////////
		%>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/MemberInfo.jsp">
      <div class="weui-cell__bd">
        <p>我的资料</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/QueryMemberBookingDate.jsp">
      <div class="weui-cell__bd">
        <p>我的预约</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
                
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/TabbarMenu.jsp?id=4">
      <div class="weui-cell__bd">
        <p>我的次卡</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>          
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/Coupons/MemberCouponsList.jsp">
      <div class="weui-cell__bd">
        <p>我的赠券</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <%
		break;
	case 4:
		///////////////////////////次卡////////////////////////////////////
		%>
  <div class="weui-cells">
    <div class="weui-cell__bd">
      <p>次卡功能暂未开放</p>
    </div>
  </div>
  <%
		break;
	case 5:
		///////////////////////////管理////////////////////////////////////
		%>
  <div class="weui-cells">
    <div class="weui-cell__bd">
      <p>
        版本号：<%=version.Version %></p>
    </div>
    <div class="weui-cell__ft">
      <p></p>
    </div>
  </div>
  <%
		
		String groupid=request.getSession().getAttribute("groupid")==null?"":(String)request.getSession().getAttribute("groupid");
		if (groupid.equals("100") ||groupid.equals("101") )
		{
		%>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/QueryBookingDateList.jsp">
      <div class="weui-cell__bd">
        <p>预约管理</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <!--
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/booking/QueryBookingDateList0628.jsp">
      <div class="weui-cell__bd">
        <p>预约管理（新版）</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>-->
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/booking/QueryBookingDateList0628.jsp">
    <!--  <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/booking/QueryBookingDateList2019.jsp">-->
      <div class="weui-cell__bd">
        <p>预约管理（2019版）</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <%
		}
		if (groupid.equals("101"))
		{
		%>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/MedicalProjectSelect.jsp?Modify=True">
      <div class="weui-cell__bd">
        <p>调整单日预约人数</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/booking/BookingDateQuery.jsp">
      <div class="weui-cell__bd">
        <p>预约查询</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/card/MemberCardApply.jsp">
      <div class="weui-cell__bd">
        <p>次卡购买申请</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/card/MemberCardQuery.jsp">
      <div class="weui-cell__bd">
        <p>次卡查询</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/booking/BlackListQuery.jsp">
      <div class="weui-cell__bd">
        <p>黑名单查询</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <!-- 
<div class="weui-cells">
  <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/card/MemberCardHistoryQuery.jsp">
    <div class="weui-cell__bd">
      <p>次卡消费查询</p>
    </div>
        <div class="weui-cell__ft">
          <p></p>
        </div>
    </a>
</div>
 -->
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/card/MemberCardRechargeAmount.jsp">
      <div class="weui-cell__bd">
        <p>次卡充值设置</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/Coupons/CouponsList.jsp">
      <div class="weui-cell__bd">
        <p>赠券信息设置</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/BackStage/MedicalProjectEdit.jsp">
      <div class="weui-cell__bd">
        <p>预约项目设置</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/BackStage/MedicalProjectScheduleEdit.jsp">
      <div class="weui-cell__bd">
        <p>排班设置</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/BackStage/MedicalProjectTimeNumberEdit.jsp">
      <div class="weui-cell__bd">
        <p>时间段人数设置</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/BackStage/BaseParameter.jsp?id=webremark">
      <div class="weui-cell__bd">
        <p>主页简介</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/BackStage/BaseParameter.jsp?id=operationremark">
      <div class="weui-cell__bd">
        <p>操作说明</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/BackStage/BaseParameter.jsp?id=cardremark">
      <div class="weui-cell__bd">
        <p>次卡操作说明</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/tx/Notice/NoticeList.jsp">
      <div class="weui-cell__bd">
        <p>公告设置</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="/SyncData/GetTableCount.jsp">
      <div class="weui-cell__bd">
        <p>数据同步情况</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <div class="weui-cells">
    <a class="weui-cell weui-cell_access" href="<%=request.getContextPath() %>/t/logout.jsp">
      <div class="weui-cell__bd">
        <p>重新登录</p>
      </div>
      <div class="weui-cell__ft">
        <p></p>
      </div>
    </a>
  </div>
  <%
		}
		break;
	}
		
%>
  <jsp:include page="/res/temple/LoadingToast.jsp" />
  <jsp:include page="/res/temple/TabbarMenuEnd.jsp" />
</body>
</html>