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
















.CouponsCard{
  border: 1px solid silver;
  max-width: 400px;
  border-radius: 5px;
  margin: 5px;
  padding: 5px; 
  background-color:white; 
  padding-left: 20px;
  position: relative;
}
.CouponsName{
  font-size: 1.5em;
  color: blue;
}
.CouponsTimeValidity:before{
  content: "有效期：";
  font-size: 0.8em;
  color: silver;
    
}
.CouponsTimeValidity{
  float: left;
  color: red;
  margin-top: 2px;
}

.CouponsCard:before{
  content: "";
  position: absolute;
  float: left;
  top: calc(50% - 5px);
  left: 0px;
    width:0;
    height:5px;
    border-top:5px solid transparent;
    border-bottom:5px solid transparent;
    border-left:5px solid silver;
}

.CouponsCard:after{
  content: "";
  position: absolute;
  float: right;
  top: calc(50% - 5px);
  right: 0px;
    width:0;
    height:5px;
    border-top:5px solid transparent;
    border-bottom:5px solid transparent;
    border-right: 5px solid silver;
}
.CouponsButton{
  float: right;  
}
.CouponsButton .btn{
  padding: 1px 5px;
}






</style>

</head>
<body>


 <%
              MySQLTable CouponsTable = new MySQLTable("select amc_Name,date_format(amc_TimeValidity,'%Y-%m-%d') as amc_TimeValidity from amc_Member_Coupons where _status<>'D' and amc_Flag=1 and amc_UseFlag=0  order by amc_TimeValidity ");
              try {
                CouponsTable.Open();
                int i = 1;
                while (CouponsTable.next()) {
                  %>
                  <div class="CouponsCard">
                    <div class="CouponsName"><span><%=CouponsTable.getString("amc_Name") %></span></div>
                    <div class="CouponsTimeValidity"><span><%=CouponsTable.getString("amc_TimeValidity") %></span></div>
                    <div class="CouponsButton"><a class="btn  btn-success" href="javascript:void(0);" role="button" onclick="SaveRecharge()" id="SaveRechargeBtn" >立即使用</a></div>
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
</body>
</html>