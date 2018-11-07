<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
  response.setHeader("Pragma","No-cache");  
  response.setHeader("Cache-Control","no-cache");  
  response.setDateHeader("Expires", 0);  
%>    
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">  
	<jsp:include page="/head.jsp"/>
	
	
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
	<title>公告设置</title>
</head>
<body>
 <div class="bs-example bs-example-form" >
	 <div class="input-group" style="width:100%;padding-top: 0px;" id ="QueryBtn">
	   <a class="btn btn-primary" href="javascript:void(0);" onclick="Query()" role="button" style="width:100%" >刷新</a>
	 </div>            
	 <div class="input-group" style="width:100%;padding-top: 0px;" id ="InsertBtn">
	   <a class="btn btn-danger" href="javascript:void(0);" onclick="Insert()" role="button" style="width:100%" >新增</a>
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
	Query();
});

var NoticeTypeName={"1":"主页公告","2":"预约页面","3":"次卡页面"}; 
var NoticeFlagName={"1":"启用","0":"停用"}; 
 
 function Query()
 {
	 $("#loadingToast").show();
   $.post("<%=request.getContextPath() %>/notice/GetNoticeList.json",{},function(data){
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
                $("#DataDiv").html("无公告记录");
                return; 
            }
             var table=$("<table class='table table-striped table-condensed'></table>");
             var th=$("<thead><td>类型</td><td>期限</td><td>状态</td></thead>")
             table.append(th);
             var body=$("<tbody></tbody>")
             for (var i=0;i<data.Data.length;i++)
             {
               //console.log(data.Data[i].Type);
               
               var trStr="<tr onclick=\"Edit('"+data.Data[i].id+"')\"><td>"+NoticeTypeName[data.Data[i].type]+"</td>"+
            		    "<td>"+data.Data[i].time+"</td><td>"+NoticeFlagName[data.Data[i].flag]+"</td></tr>";
            		var tr=$(trStr);
               body.append(tr);
             }
             table.append(body);
             $("#DataDiv").append(table);
         }
     },"json");
 }

 function Edit(id)
 {
	 OpenWindowLayer('修改公告','<%=request.getContextPath() %>/tx/Notice/NoticeEdit.jsp?id='+id,function(){
		 Query();
	 });
 }
 
 function Insert()
 {
	 OpenWindowLayer('新增公告','<%=request.getContextPath() %>/tx/Notice/NoticeEdit.jsp?id=-1',function(){
		 Query();
	 });
 }
</script>
               
               
</body>
</html>