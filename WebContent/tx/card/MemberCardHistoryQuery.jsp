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
    
  </style>
  <title>次卡消费查询</title>
</head>
<body>
 <div class="bs-example bs-example-form" >
   <p class="bg-success" style="text-align: center;padding: 5px;background-color: #EEEEEE;border-radius: 3px;border: 1px solid #CCCCCC;">次卡消费信息查询</p>
   <div class="input-group">
     <span class="input-group-addon" id="basic-addon1">购买姓名</span>
     <input type="text" class="form-control" id="GuestName"  placeholder="购买人姓名" aria-describedby="basic-addon1" value="" >
   </div>
   <div class="input-group">
     <span class="input-group-addon" id="basic-addon1">手机号码</span>
     <input type="text" class="form-control" id="GuestTel" placeholder="购买人手机号码" aria-describedby="basic-addon1" value="">
   </div>
   <div class="input-group">
     <span class="input-group-addon" id="basic-addon1">开始日期</span>
     <input type="text" value="2018-01-01" id="BeginDate" class=" form-control form_datetime "  readonly data-date-format="yyyy-mm-dd">
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
    <p class="weui-toast__content">操作中</p>
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
 
 function Query()
 {
   

     var GuestName=$("#GuestName").val();
     var GuestTel=$("#GuestTel").val();
     var BeginDate=$("#BeginDate").val();
     var EndDate=$("#EndDate").val();
   
   $("#loadingToast").show();
   $.post("<%=request.getContextPath() %>/card/query/MemberCardHistoryQuery",{"GuestTel":GuestTel,"GuestName":GuestName,"BeginDate":BeginDate,"EndDate":EndDate},function(data){
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
             var th=$("<thead><td>姓名</td><td>手机</td><td>类型</td><td>业务日期</td><td>次数</td></thead>")
             table.append(th);
             var body=$("<tbody></tbody>")
             for (var i=0;i<data.Data.length;i++)
             {
               //console.log(data.Data[i].Type);
               var tr=$("<tr><td><a href=\"<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID="+data.Data[i].CardID+"\">"+data.Data[i].Name+"</a></td>"+
            		   "<td><a href=\"<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID="+data.Data[i].CardID+"\">"+data.Data[i].Tel+"</a></td>"+
            		   "<td><a href=\"<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID="+data.Data[i].CardID+"\">"+data.Data[i].Type+"</a></td>"+
            		   "<td><a href=\"<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID="+data.Data[i].CardID+"\">"+data.Data[i].Date+"</a></td>"+
            		   "<td><a href=\"<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID="+data.Data[i].CardID+"\">"+data.Data[i].Count+"</a></td></tr>");
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