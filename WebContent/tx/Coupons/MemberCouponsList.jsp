<%@page import="com.java.web.weixin.base.GlobalVariable"%>
<%@page import="com.java.sql.table.MySQLTable"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
  response.setHeader("Pragma","No-cache");  
  response.setHeader("Cache-Control","no-cache");  
  response.setDateHeader("Expires", 0);  
  String MemberID=GlobalVariable.GetMemberID(request);
%>
    
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
  <jsp:include page="/head.jsp"/>
  
<meta charset="UTF-8">
<title>我的赠券</title>
</head>
<body>


<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
    <div class="weui-cells__title"><p>我的赠券</p></div> 
    <div id ="container" class="container" style="height: calc(100vh - 100px);overflow: auto;">
    
    <%
      MySQLTable CouponsTable = new MySQLTable("select amc_Name,date_format(amc_TimeValidity,'%Y-%m-%d') as amc_TimeValidity,amc_UseFlag,amc_id_ac from amc_Member_Coupons where _status<>'D' and amc_Flag=1 and amc_id_amb='"+MemberID+"'  order by amc_UseFlag,amc_TimeValidity ");
      try {
        CouponsTable.Open();
        int i = 1;
        while (CouponsTable.next()) {
          %>
          <div class="CouponsCard">
            <div class="CouponsName"><span><%=CouponsTable.getString("amc_Name") %></span></div>
            <div class="CouponsTimeValidity"><span><%=CouponsTable.getString("amc_TimeValidity") %></span></div>
            <div class="CouponsRemark"><a href="javascript:void(0);" onclick="ShowCouponsRemark('<%=CouponsTable.getString("amc_id_ac")%>')"><span>赠券说明<i class="weui-icon-info-circle weui-icon_msg"></i></span></a></div>
            <div class="CouponsButton">
            <%
            if (CouponsTable.getInt("amc_UseFlag")==0)
            {
              %>
              <a class="btn  btn-success" href="javascript:void(0);" role="button" >未使用</a>
              <%
            }
            else
            {

              %>
              <a class="btn btn-default " href="javascript:void(0);" role="button" >已使用</a>
              <%
            }
            %>
          
            </div>
            <div style="clear: both;"></div>
          </div>
          <%
          i++;
        }
        if (i==1)
        {
          %>
            <div class="input-group font1 text-center" style="line-height: 20px; padding: 2px; margin-top: 10px">
              <span>无可用的赠券</span>
            </div>
          <%
        }
      } finally {
        CouponsTable.Close();
      }
    %>    
    </div>
            

      

  
<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
  <script type="text/javascript">
  function ShowCouponsRemark(id){
    layer.open({
      type: 2,
      title: '赠券说明',
      shadeClose: true,
      shade: 0.8,
      area: ['90%', '400px'],
      content: '<%=request.getContextPath() %>/tx/Coupons/ShowCouponsRemark.jsp?ID='+id
    }); 
  }
  
  </script>

</body>
</html>