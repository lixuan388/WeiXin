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
	<title>黑名单查询</title>
</head>
<body>
 <div class="bs-example bs-example-form" >
	 <div class="input-group" style="width:100%;padding-top: 0px;" id ="ApplyBtn">
	   <a class="btn btn-danger" href="javascript:void(0);" onclick="Query()" role="button" style="width:100%" >查询黑名单</a>
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

 function Query()
 {
   
	 $("#loadingToast").show();
   $.post("<%=request.getContextPath() %>/booking/BlackListQueryQuery.json",{},function(data){
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
                $("#DataDiv").html("无黑名单记录");
                return; 
            }
             var table=$("<table class='table table-striped table-condensed'></table>");
             var th=$("<thead><td>会员信息</td><td>次卡信息</td><td>剩余天数</td></thead>")
             table.append(th);
             var body=$("<tbody></tbody>")
             for (var i=0;i<data.Data.length;i++)
             {
               //console.log(data.Data[i].Type);
               
               var tr=$("<tr onclick='OpenUrl(\""+data.Data[i].AmcID+"\")'><td>"+data.Data[i].Name+"<br>"+data.Data[i].Tel+"</td>"+
              		 "<td>"+data.Data[i].GuestName+"<br>"+data.Data[i].GuestTel+"</td>"+
            		    "<td>"+data.Data[i].levelvalue+"</td></tr>");
               body.append(tr);
             }
             table.append(body);
             $("#DataDiv").append(table);
         }
     },"json");
 }
 function OpenUrl(code)
 {
	if (code!="")
	{
    window.location.href='<%=request.getContextPath() %>/tx/card/MemberCardEdit.jsp?ID='+code+'&d=' + new Date().Format('yyyymmddhhnnss');
	}
 }
</script>
               
               
</body>
</html>