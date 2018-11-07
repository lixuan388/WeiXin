<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.sql.table.MySQLTable" %>


<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  
	String AmcID =request.getParameter("ID")==null?"":(String)request.getParameter("ID");
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
	<script src="<%=request.getContextPath() %>/res/js/bootstrap-datetimepicker.min.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/res/js/bootstrap-datetimepicker.zh-CN.js"></script>
    <link href="<%=request.getContextPath() %>/res/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
	
	
</head>
<body style="position: relative;">

<%
MySQLTable Card=new MySQLTable("select amc_id,amc_GuestName,amc_GuestTel,amc_CreateDate,amc_Count,amc_Money,amc_EndDate,amc_id_amb,amb_Level,amb_LevelValue from amc_member_card,amb_member where amb_id=amc_id_amb and  amc_id='"+AmcID+"'");

try
{
  Card.Open();
  if (!Card.next())
  {
	  %>
	  <div ><p>无次卡记录</p></div>
	  <%
  }
  else
  {
		java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");
		String CreateDate=format.format(Card.getDateTime("amc_CreateDate"));



		java.util.Date ss = new java.util.Date();  
		java.util.Calendar rightNow = java.util.Calendar.getInstance();
		rightNow.setTime(ss);
		rightNow.add(java.util.Calendar.YEAR,1);//日期减1年
		String NewRechargeDate=format.format(rightNow.getTime());
		  

	  java.util.Date today = new java.util.Date();  
    %>
    	<div style="margin: 10px;">
				<div class="input-group">
					<span class="input-group-addon" id="basic-addon1">开卡日期</span>
					<input type="text" class="form-control form_datetime" placeholder="" aria-describedby="basic-addon1"FieldName="amc_CreateDate">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" onclick="EditCreateDateClose();">取消</button>
					<button type="button" class="btn btn-primary" onclick="EditCreateDatePost();" >保存</button>
				</div>
			</div>
<script type="text/javascript">

$(function(){
	$('.form_datetime').datetimepicker({
	  weekStart: 0, //一周从哪一天开始
	  todayBtn:  1, //
	  autoclose: 1,
	  todayHighlight: 1,
	  startView: 2,
	  minView: 2, 
	  forceParse: 0,
	  showMeridian: 1,
		format:'yyyy-mm-dd',
	  language:'zh-CN'
	});
	$('.form_datetime').val('<%=CreateDate%>');
})
function EditCreateDatePost()
{
	var $loadingToast = loadingToast();
	var ID='<%=AmcID%>';
	var date=encodeURIComponent(encodeURIComponent($("[FieldName=amc_CreateDate]").val()));
	
	$.ajax({
		 url: '<%=request.getContextPath() %>/card/MemberCardEditCreateDate?ID='+ID+'&CreateDate='+date+'&d=' + new Date().getTime(),
		 type: 'get',
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
					EditCreateDateClose();
			 }
		 }
	 })	
}
function EditCreateDateClose()
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