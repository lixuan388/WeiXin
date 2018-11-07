<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

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
    
    </style>
	    <script type="text/javascript">	    
		$(function(){
			history.replaceState(null, "", "<%=request.getContextPath()%>/tx/TabbarMenu.jsp?id=5");
		});	
		
    </script>
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
    <div class="weui-cells__title"><p>修改挂号项目</p></div> 
    <div id ="container" class="container"></div>
    <div id ="insertBtn">
    	<a class="weui-btn weui-btn_warn" href="javascript:void(0);"onclick="InsertData()" >新建项目</a>
    </div>
			
			

    <div id="loadingToast" style="display: none;">
        <div class="weui-mask_transparent"></div>
        <div class="weui-toast">
            <i class="weui-loading weui-icon_toast"></i>
            <p class="weui-toast__content">操作中</p>
        </div>
    </div>
    <div id="Template" style="display: none;" class="Template">
      <div class="weui-form-preview">
            <div class="weui-form-preview__hd">
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">挂号项目</label>
                    <input class="weui-input" placeholder="请输入文本" type="text" style="background-color: #f8f8f8;"  id="Item_Name">
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">简称</label>
                    <input class="weui-input" placeholder="请输入文本" type="text" style="background-color: #f8f8f8;"  id="Item_NameSht">
                </div>
            </div>
            <div class="weui-form-preview__bd">
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">项目说明</label>
                    <textarea class="weui-textarea" placeholder="请输入文本" rows="2" style="background-color: #f8f8f8;color: black;" id="Item_Remark"></textarea>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">挂号金额</label>
                    <input class="weui-input" placeholder="请输入文本" type="text" style="background-color: #f8f8f8;color: black;" id="Item_Money">
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">爽约金额</label>
                    <input class="weui-input" placeholder="请输入文本" type="text" style="background-color: #f8f8f8;color: black;" id="Item_Money2">
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">可提前预约天数</label>
                    <input class="weui-input" placeholder="请输入文本" type="text" style="background-color: #f8f8f8;color: black;" id="Item_MaxDay">
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">启用</label>
                    <label for="switchCP" class="weui-form-preview__value" style="margin-top: 10px;">
                        <input id="Item_Useflag" checked="checked" type="checkbox">                        
                    </label>
                </div>
            </div>
            <div class="weui-form-preview__ft">
                <a class="weui-form-preview__btn weui-form-preview__btn_primary saveBtn" href="javascript:void(0);">确认修改</a>
            </div>
        </div>
    </div>
<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
    <script type="text/javascript">	    
	    $(function(){
	    	var data=<jsp:include page="/BackStage/GetMedicalProjectInfo"/>
	    	$("#container").html("");
			for (i =0;i<data.DataRows.length;i++)
			{
				console.log('GetMedicalProjectInfo:'+data.DataRows[i]);
				var Template=$("#Template").clone();
				$(Template).attr("style","");
				$(Template).attr("id","Template"+data.DataRows[i].id);
        $(Template).find("#Item_Name").val(data.DataRows[i].Name);
        $(Template).find("#Item_NameSht").val(data.DataRows[i].NameSht);
				$(Template).find("#Item_Remark").val(data.DataRows[i].Remark);
				$(Template).find("#Item_Money").val(data.DataRows[i].Money);
				$(Template).find("#Item_Money2").val(data.DataRows[i].Money2);
				$(Template).find("#Item_MaxDay").val(data.DataRows[i].MaxDay);
				$(Template).find("#Item_Useflag").get(0).checked=data.DataRows[i].Useflag=="true";
				$(Template).find(".saveBtn").attr("keyID",data.DataRows[i].id);

				$(Template).find(".saveBtn").on("click", function(){
					SaveData($(this).attr("KeyID"));
			    });

				$("#container").append($(Template));						
			}		
	    	
	    });	    

	    function SaveData(keyID)
	    {
	    	var Template=$("#Template"+keyID)
	    	var id=$(Template).attr("id");
	      var Name=$(Template).find("#Item_Name").val();
	      var NameSht=$(Template).find("#Item_NameSht").val();
	    	var Remark=$(Template).find("#Item_Remark").val();
	    	var Money=$(Template).find("#Item_Money").val();
	    	var Money2=$(Template).find("#Item_Money2").val();
	    	var MaxDay=$(Template).find("#Item_MaxDay").val();
	    	var Useflag=$(Template).find("#Item_Useflag").get(0).checked;
	    	var JsonData={"DataRows":[{"Name":Name,"NameSht":NameSht,"id":keyID,"Remark":Remark,"Useflag":Useflag,"Money":Money,"Money2":Money2,"MaxDay":MaxDay}]};
	    	//console.log(JsonData);
	    	
	    	$.ajax({
	            url:"<%=request.getContextPath()%>/BackStage/PostMedicalProjectInfo",
	            type:'POST',
	            data:  JSON.stringify(JsonData),
	            dataType:'Json',
	            success:function(data){
	            	if (data.MsgID!=1)
	            	{
	            		weui.alert(data.MsgText);
	            	}
	            	else
	            	{
	            		window.location.reload();
	            	}	            	
	            }
	    	});	
	    }
	    
	    function InsertData()
	    {
			var Template=$("#Template").clone();
			$(Template).attr("style","");
			$(Template).attr("id","Template-1");
			$(Template).find("#Item_Name").val("新项目");
			$(Template).find("#Item_Remark").val("");
			$(Template).find("#Item_Money").val(20);
			$(Template).find("#Item_Money2").val(20);
			$(Template).find("#Item_MaxDay").val(8);
			$(Template).find("#Item_Useflag").get(0).checked=true;
			$(Template).find(".saveBtn").attr("keyID",-1);
			$(Template).find(".saveBtn").on("click", function(){
				SaveData($(this).attr("KeyID"));
		    });
			
			$("#container").append($(Template));	
			$("#insertBtn").html("");
	    }
	    
		
	
	
    </script>
</body>
</html>