<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);

	String ID=request.getParameter("id")==null?"":(String)request.getParameter("id");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
    <script type="text/javascript">	    
		$(function(){
			history.replaceState(null, "", "/WeiXin/tx/TabbarMenu.jsp?id=5");
		});	
		
    </script>
	
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
    <div class="weui-toptips weui-toptips_warn js_tooltips">错误提示</div>


			
<jsp:include page="/res/temple/LoadingToast.jsp"/>
	<div class="weui-form-preview" style="height: 100%;">
        <div class="weui-form-preview__bd"  style="height: 100%;">          
            <div class="weui-form-preview__item"  style="height: 100%;">
            <% 
            if (ID.equals("webremark")) 
            	{
            		%>
            			<label class="weui-form-preview__label">主面简介</label>
            		<%
            	}
            else if (ID.equals("operationremark")) 
	          {
	            %>
	              <label class="weui-form-preview__label">预约操作说明</label>
	            <%
	          }
            else if (ID.equals("cardremark")) 
	          {
	            %>
	              <label class="weui-form-preview__label">次卡操作说明</label>
	            <%
	          }
            else
            {
        		%>
	    			  <label class="weui-form-preview__label">项目说明</label>
	    			<%
            	
            }
            	
            %>
            	<textarea class="weui-textarea" placeholder="请输入文本" style="background-color: #f8f8f8;color: black;    font-size: 13px;height:450px" id="Item_Parameter" KeyName="<%= ID %>"></textarea>
        	</div>  
        </div>

    </div>
	<div class="weui-tabbar" style="bottom: 55px;">
		<a class="weui-btn weui-btn_warn saveBtn" style="width:100%;" href="javascript:SaveData();">确认修改</a>
	</div>
<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
    <script type="text/javascript">	    
	    $(function(){
	    	var data=<jsp:include page="/BackStage/GetBaseParameter?id=<%= ID %>"/>
				$("#Item_Parameter").attr("KeyName",data.DataRows.Name);
				$("#Item_Parameter").val(decodeURI(data.DataRows.Value).replace(/<br>/g,"\n"));
	    	
	    });	    

	    function SaveData()
	    {
	    	$('#loadingToast').show();	
	    	var Name=$("#Item_Parameter").attr("KeyName");
	    	var Value=encodeURI($("#Item_Parameter").val().replace(/\n/g,"<br>"));
	    	var JsonData={"DataRows":[{"Name":Name,"Value":Value}]};
	    	//console.log(JsonData);
	    	
	    	$.ajax({
	            url:"/WeiXin/BackStage/PostBaseParameter",
	            type:'POST',
	            data:  JSON.stringify(JsonData),
	            dataType:'Json',
	            success:function(data){
	            	if (data.MsgID!=1)
	            	{
	            		weui.alert(data.MsgText);
	            		$('#loadingToast').hide();	
	            	}
	            	else
	            	{
	            		window.location.reload();
	            	}	            	
	            }
	    	});	
	    } 
		
	
	
    </script>
</body>
</html>