<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.TMemberInfo" %>
<%@ page import="org.apache.catalina.Session" %>
<%@ page import="com.java.sql.table.MySQLTable" %>


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
	
    <style type="text/css">
    .page, body {
    	background-color: #f8f8f8;
	}
    .font1{
    	font-size: 12px;
    	
    }
    

    thead,tr
    {
    	text-align: center;
    }
    </style>
	
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
    <div class="container" id="container">
    	<div class="weui-cells__title"><p>次卡充值设置</p></div>    	
		  <table class="table table-condensed table-striped" id="DataTable">
		    <thead>
		      <tr>
		        <td style="width:100px">
		                      次数
		        </td>
            <td >
                                金额
            </td>              
            <td style="width:100px">
                                赠券
            </td>              
		      </tr>
		    </thead>
		    <tbody>
				<% 
						MySQLTable RechargeAmount=new MySQLTable("select * from amcra_member_card_recharge_amount where _status<>'D' order by amcra_Count");
						try
						{
							RechargeAmount.Open();
							while (RechargeAmount.next())
							{
								%>
								  <tr DataID="<%=RechargeAmount.getString("amcra_id")%>">
								    <td>
								      <input type="number" FieldName="Count" value="<%=RechargeAmount.getInt("amcra_Count")%>">
								    </td>
                    <td>
                      <input type="number" FieldName="Money" value="<%=RechargeAmount.getInt("amcra_Money")%>">
                    </td>
                    <td>
                      <select ><option>1</option><option>2</option></select>
                    </td>
								  </tr>
								<%
							}
						}
						finally
						{
							RechargeAmount.Close();
						}
				%>
				</tbody>
		  </table>
		  <div class="text-center">
		    <a class="btn btn-info btn-xs" style="margin-right: 10px;" href="javascript:void(0)" onclick="AddRow()">新增</a>
		    <a class="btn btn-success btn-xs" style="margin-left: 10px;"  href="javascript:void(0)" onclick="SaveTable()">保存</a>
		  </div>
		  
	</div>
<script type="text/javascript">
function AddRow()
{
	$("#DataTable>tbody").append("<tr DataID=\"-1\">"+
			   "<td>"+
         "   <input type=\"number\" FieldName=\"Count\" value=\"0\">"+
          "</td>"+
          "<td>"+
           " <input type=\"number\" FieldName=\"Money\" value=\"0\">"+
          "</td>"+
        "</tr>")
}
function SaveTable()
{
	var Data={"DataRows":[]};
	$("#DataTable>tbody>tr[DataID]").each(function(index){
		console.log(index);
		var FieldData={};
    FieldData.ID=$(this).attr("DataID");
    FieldData.Count=$(this).find("[FieldName=Count]").val();
    FieldData.Money=$(this).find("[FieldName=Money]").val();
    Data.DataRows[index]=FieldData;		
	})
	//console.log(Data);
  $.post("<%=request.getContextPath() %>/card/MemberCardRechargeAmountPost.json",JSON.stringify(Data),function(data){
      console.log(data);

      if (data.MsgID!=1)
      {
        alert(data.MsgTest);
      }
      else
      {
    	  window.location.reload();
      }
  },"json");
}
</script>     
	<div id="loadingToast" style="display: none;">
        <div class="weui-mask_transparent"></div>
        <div class="weui-toast">
            <i class="weui-loading weui-icon_toast"></i>
            <p class="weui-toast__content">操作中</p>
        </div>
    </div>
<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>    
	

</body>
</html>