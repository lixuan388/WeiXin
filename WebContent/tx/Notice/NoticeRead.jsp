<%@page import="com.java.web.weixin.base.GlobalVariable"%>
<%@page import="com.java.sql.table.MySQLTable"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	String ID=request.getParameter("id")==null?"":(String)request.getParameter("id");



	
String id="";
String remark="";

		MySQLTable table=new MySQLTable("select * from anl_noticelist where anl_id='"+ID+"'");

		table.Open();
		if(table.next())
		{ 
			id=table.getString("anl_id");
			remark=table.getString("anl_remark");
		}
		table.Close();
	
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">  
	<jsp:include page="/head.jsp"/>

		
<title>公告</title>
</head>
<body>

	<div class="weui-form-preview" style="height: calc(100vh - 95px);background-color: #f8f8f8;">
			<div class="weui-form-preview__item"  style="height: 100%;padding: 5px;">
				<textarea class="weui-textarea" readonly placeholder="请输入文本" style="background-color: #FFFFFF;color: black;    font-size: 18px;height:100%" id="Item_Parameter" FieldName="remark"><%=remark%></textarea>
			</div>  
	</div>
	<div style="margin: 10px 20px;">
	
	  <label for="readflag" class="weui-form-preview__value" style="">
	      <input id="readflag" type="checkbox" style="    margin-right: 10px;"><span>不再提示</span>             
	  </label>
	</div>
	<div  >
		<a class="weui-btn weui-btn_warn saveBtn" style="width:100%;" href="javascript:Read();">确认</a>
	</div>

<script type="text/javascript"> 

 function Read()
 {

		if ($("#readflag").get(0).checked)
		{
			var Data={"id":"<%=ID%>"};
			$.post("<%=request.getContextPath() %>/notice/ReadNoticeData.json",JSON.stringify(Data),function(data){
			  //console.log(data);

		  		var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
		  		parent.layer.close(index); //再执行关闭   
			},"json");
		}
		else
		{
			var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
  		parent.layer.close(index); //再执行关闭   
		}
		 
   
 }
</script>
 
</body>
</html>