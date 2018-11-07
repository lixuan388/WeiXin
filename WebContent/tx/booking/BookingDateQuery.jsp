<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
  response.setHeader("Pragma","No-cache");  
  response.setHeader("Cache-Control","no-cache");  
  response.setDateHeader("Expires", 0);  

  String AmcaID =request.getParameter("ID")==null?"":(String)request.getParameter("ID");
  
  

  java.util.Date ss = new java.util.Date();  
  java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");

    
    
  String now = format.format(ss);//这个就是把时间戳经过处理得到期望格式的时间  
%>    
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">  
	<jsp:include page="/head.jsp"/>
	
	<script src="<%=request.getContextPath() %>/res/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/res/js/bootstrap-datetimepicker.zh-CN.js"></script>
	<link href="<%=request.getContextPath() %>/res/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
	
	<style type="text/css">

   .input-group
   {
     width:100%;
   }
   thead,tr
    {
      text-align: center;
    }
    .table
    {
      font-size: 12px;
    }
    
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
	</style>
	<title>预约查询</title>
</head>
<body>
 <div class="bs-example bs-example-form" >
	 <p class="bg-success" style="text-align: center;padding: 5px;background-color: #EEEEEE;border-radius: 3px;border: 1px solid #CCCCCC;">预约查询</p>
	 <div class="input-group">
	   <span class="input-group-addon" id="basic-addon1">预约姓名</span>
	   <input type="text" class="form-control" id="GuestName"  placeholder="预约人姓名" aria-describedby="basic-addon1" value="" >
	 </div>
	 <div class="input-group">
	   <span class="input-group-addon" id="basic-addon1">手机号码</span>
	   <input type="text" class="form-control" id="GuestTel" placeholder="预约人手机号码" aria-describedby="basic-addon1" value="">
	 </div>
   <div class="input-group">
     <span class="input-group-addon" id="basic-addon1">开始日期</span>
     <input type="text" value="<%=now %>" id="BeginDate" class=" form-control form_datetime "  readonly data-date-format="yyyy-mm-dd">
   </div>
   <div class="input-group">
     <span class="input-group-addon" id="basic-addon1">结束日期</span>
     <input type="text" value="<%=now %>" id="EndDate" class=" form-control form_datetime "  readonly data-date-format="yyyy-mm-dd">
   </div>
	 <div class="input-group" style="width:100%;padding-top: 0px;" id ="ApplyBtn">
	   <a class="btn btn-danger" href="javascript:void(0);" onclick="Query()" role="button" style="width:100%" >查询</a>
	 </div>            
</div>
<div id ="DataDiv" style="margin-top: 10px;">

</div>


<div id="loadingToast" style="display: none;">
  <div class="weui-mask_transparent"></div>
  <div class="weui-toast">
    <i class="weui-loading weui-icon_toast"></i>
    <p class="weui-toast__content">查询中</p>
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
   //$('.form_datetime').val('<%=now%>');
 })
 
var checkinName={"0":"未到","1":"已扣","2":"已叫","3":"爽约","4":"未扣"};
                
                
 function Query()
 {
	 

	   var GuestName=$("#GuestName").val();
	   var GuestTel=$("#GuestTel").val();
	   var BeginDate=$("#BeginDate").val();
	   var EndDate=$("#EndDate").val();
	   //return;
   
	 $("#loadingToast").show();
   $.post("<%=request.getContextPath() %>/booking/BookingDateQuery.json",{"GuestTel":GuestTel,"GuestName":GuestName,"BeginDate":BeginDate,"EndDate":EndDate},function(data){
         //console.log(data);

         $("#loadingToast").hide();
         if (data.MsgID==-1)
         {
          alert(data.MsgTest);
         }
         else
         {

            $("#DataDiv").html("");
            if (data.Data.length==0)
            {
                $("#DataDiv").html("无符合条件的记录");
                return; 
            }
             var table=$("<table class='table table-striped table-condensed'></table>");
             var th=$("<thead><td>姓名/手机</td><td>预约日期</td><td>预约项目</td></thead>")
             table.append(th);
             var body=$("<tbody></tbody>")
             for (var i=0;i<data.Data.length;i++)
             {
               //console.log(data.Data[i].Type);
               
               var tr=$("<tr><td><a href=\"<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID="+data.Data[i].ID+"\">"+data.Data[i].Name+
              		 	"<br>"+data.Data[i].Tel+"</a></td>"+
            		    "<td>"+data.Data[i].BookingDate+"<br>【"+checkinName[data.Data[i].checkin]+"】</td>"+
            		    "<td>"+data.Data[i].MedicalProject+"</td></tr>");
               body.append(tr);
             }
             table.append(body);
             $("#DataDiv").append(table);
             
         }
     },"json");
 }
</script>
               
               
</body>
</html>