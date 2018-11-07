<%@page import="com.java.web.weixin.base.GlobalVariable"%>
<%@page import="com.java.sql.table.MySQLTable"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	String ID=request.getParameter("id")==null?"":(String)request.getParameter("id");



	java.util.Date ss = new java.util.Date();  
	java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");  
	String now = format.format(ss);//这个就是把时间戳经过处理得到期望格式的时间  

	
String id="";
String time="";
String type="";
String flag="";
String remark="";
	if (ID.equals("-1"))
	{
		id=GlobalVariable.GUIDString();
		time=now;
		type="1";
		flag="1";
		remark="";
	}
	else
	{
		MySQLTable table=new MySQLTable("select * from anl_noticelist where anl_id='"+ID+"'");

		table.Open();
		if(table.next())
		{ 
			id=table.getString("anl_id");
			String StringDate =format.format(table.getDateTime("anl_time"));			
			time=StringDate;
			type=table.getString("anl_type");
			flag=table.getString("anl_flag");
			remark=table.getString("anl_remark");
		}
		table.Close();
	}
	
	
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

	<script src="<%=request.getContextPath() %>/res/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/res/js/bootstrap-datetimepicker.zh-CN.js"></script>
	<link href="<%=request.getContextPath() %>/res/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
		
<title>修改</title>

<style type="text/css">

  [type=radio]+label
    {
      display: block;
    }
    [type=radio]:checked+label
    {
      background-color: blue;
      Color:white;
    }
    [type=radio]
    {
      display: none;
    }
    .weui-form-preview__item
    {
    	margin-top: 10px;
    }
</style>
</head>
<body>

	<div class="weui-form-preview" style="height: 100%;">
		<div class="weui-form-preview__bd"  style="height: calc(100vh - 46px);">
					<div>
				<a class="weui-btn weui-btn_warn saveBtn" style="width:100%;" href="javascript:SaveData();">确认修改</a>
			</div>
			
			<div class="weui-form-preview__item">
				<label class="weui-form-preview__label">公告类型</label>
				<div class="input-group" style="width: 100%;">
					<div style="display: inline-block; width:33%;padding: 2px;font-size: 14px;" >
						<input type="radio" name="type"  id ="type1" value='1'>
						<label for="type1" class="btn btn-xs btn-default" >主页公告</label>
					</div>   
					<div style="display: inline-block; width:33%;padding: 2px;font-size: 14px;" >
						<input type="radio" name="type"  id ="type2"  value='2'>
						<label for="type2" class="btn btn-xs btn-default" >预约页面</label>
					</div>   
					<div style="display: inline-block; width:33%;padding: 2px;font-size: 14px;" >
						<input type="radio" name="type"  id ="type3"  value='3'>
						<label for="type3" class="btn btn-xs btn-default" >次卡页面</label>
					</div>   
				</div>
			</div>
			<div class="weui-form-preview__item">
				<label class="weui-form-preview__label">期限</label>
				<input type="text" value="<%=time%>" id="" class=" form-control form_datetime " FieldName='time' readonly data-date-format="yyyy-mm-dd">
			</div>
      <div class="weui-form-preview__item">
          <label class="weui-form-preview__label">启用</label>
          <label for="switchCP" class="weui-form-preview__value" style="">
              <input id="flag" FieldName="flag" checked="checked" type="checkbox">                        
          </label>
      </div>
			<div class="weui-form-preview__item"  style="height: calc(100% - 106px);min-height:200px">
				<label class="weui-form-preview__label">项目说明</label>
				<textarea class="weui-textarea" placeholder="请输入文本" style="background-color: #f8f8f8;color: black;    font-size: 18px;height:calc(100% - 56px)" id="Item_Parameter" FieldName="remark"><%=remark%></textarea>
			</div>  
			<input type="hidden" value="<%=id %>" FieldName="id">

		</div>
	</div>


<script type="text/javascript"> 
 $(function () {
   $('.form_datetime').datetimepicker({
         weekStart: 0, //一周从哪一天开始
         todayBtn:  1, //
         autoclose: 1,
         todayHighlight: 1,
         startView: 2,
         minView: 2, 
         forceParse: 0,
         showMeridian: 1,
         language:'zh-CN',
         startDate:'2010-01-01'
     });
   console.log("flag:<%=flag%>");
	<%
	
		if (!flag.equals("1"))
		{
			%>
			$("#flag").get(0).checked=false;
			<%
		}
		else
		{
			%>
			$("#flag").get(0).checked=true;
			<%			
		}
	%>
	 $("[name=type][value=<%=type%>]").attr("checked","checked");
   
 })
 
 function SaveData()
 {
		var Data={};
		var id=$("[FieldName=id]").val();
		var time=$("[FieldName=time]").val();
		var remark=$("[FieldName=remark]").val();	 
		var type=$("[type=radio]:checked").attr("value");
		var flag=1;
		if (!$("[FieldName=flag]").get(0).checked)
		{
			flag=0;
		}
		 
		Data.id=id;
		Data.time=time;
		Data.remark=remark;
		Data.type=type;
		Data.flag=flag;
		console.log(Data);
		$.post("<%=request.getContextPath() %>/notice/SaveNoticeData.json",JSON.stringify(Data),function(data){
		  //console.log(data);
		  if (data.MsgID!=1)
		  {
		  	alertLayer(data.MsgText);
		  }
		  else
		  {
		  	alertLayer("数据保存成功！",function(){
		  		var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
		  		parent.layer.close(index); //再执行关闭   
		  		
		  	});
		  }
		},"json");
   
   
 }
</script>
 
</body>
</html>