<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.sql.table.MySQLTable"%>
<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  
	String AmcID =request.getParameter("ID")==null?"":(String)request.getParameter("ID");
%>
<!DOCTYPE html>
<html style="height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/head.jsp" />
<script src="<%=request.getContextPath() %>/res/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/res/js/bootstrap-datetimepicker.zh-CN.js"></script>
<link href="<%=request.getContextPath() %>/res/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
</head>
<body style="position: relative;height: calc(100% - 10px);">
<%
MySQLTable Card=new MySQLTable("select amc_id,amc_Remark from amc_member_card,amb_member where amb_id=amc_id_amb and  amc_id='"+AmcID+"'");

try
{
  Card.Open();
  if (!Card.next())
  {
	  %>
  <div>
    <p>无次卡记录</p>
  </div>
  <%
  }
  else
  {
    %>
  <div style="margin: 10px;height: calc(100% - 20px);">
    <textarea rows="" cols="" FieldName='amc_Remark' style="height: calc(100% - 50px);width: 100%;"><%=Card.getString("amc_Remark") %></textarea>
    <div class="modal-footer">
      <button type="button" class="btn btn-default" onclick="EditRemarkClose();">取消</button>
      <button type="button" class="btn btn-primary" onclick="EditRemarkPost();">保存</button>
    </div>
  </div>
  <script type="text/javascript">


function EditRemarkPost()
{
	var $loadingToast = loadingToast();
	var ID='<%=AmcID%>';
	var Remark=$("[FieldName=amc_Remark]").val();
	var Data={'ID':ID,'Remark':Remark};
	
	$.ajax({
		 url: '<%=request.getContextPath() %>/card/MemberCardEditRemark?d=' + new Date().getTime(),
		 type: 'post',
		 data:JSON.stringify(Data),
		 dataType: 'Json',
		 success: function (data) {
			 $loadingToast.fadeOut(100);
			 if (data.MsgID != 1)
			 { 
				 alert(data.MsgText);
				 return;
			 } 
			 else
			 {
				 alert('修改成功！');
				 EditRemarkClose();
			 }
		 }
	 })	
}
function EditRemarkClose()
{
	var iJquery=window.parent.jQuery;
	iJquery("#"+window.name).modal("hide");
}



</script>
  <%
  }
}
finally
{
	Card.Close();
}
%>
  <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>