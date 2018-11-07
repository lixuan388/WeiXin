<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.jssdk.WXUserInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	<style type="text/css">
		
		.btn{
		
			margin-top: 20px;
		}
		
	</style>

</head>
<div id="loadingToast" style="display1: none;">
	<div class="weui-mask_transparent"></div>
	<div class="weui-toast">
		<i class="weui-loading weui-icon_toast"></i>
		<p class="weui-toast__content">操作中</p>
	</div>
</div>


          <a class="btn  btn-success" href="javascript:void(0);"  role="button" onclick="ShowMessage()" 
            id="SaveEndDateBtn" style="width:100%"  >确认修改有新效期</a>
            
            
          <a class="btn  btn-success" href="javascript:void(0);"  role="button" onclick="ShowMessage2(doShow)" 
            id="SaveEndDateBtn" style="width:100%"  >layer ShowMessage2(doShow)</a>
            
          <a class="btn  btn-success" href="javascript:void(0);"  role="button" onclick="ShowMessage2()" 
            id="SaveEndDateBtn" style="width:100%"  >layer ShowMessage2()</a>
            
            
          <a class="btn  btn-success" href="javascript:void(0);"  role="button" onclick="confirm()" 
            id="SaveEndDateBtn" style="width:100%"  >layer confirm</a>
            
            
<script type="text/javascript">
function ShowMessage()
{
	alert("asdasdasd");
}

function ShowMessage2(f)
{
	alertLayer('layer ShowMessage',f);
}

function show(Text)
{
	layer.msg(Text)
}

function doShow()
{
	layer.msg("doShow");
}

function confirm()
{
	confirmLayer('confirmLayer<br>是否确认操作？<br>确认【是】<br>不确认【否】',  function(index, layero){
		layer.close(index);
		show('确认【是】');
	}, function(index, layero){
		layer.close(index);
		show('不确认【否】');

	});
}


</script>

<script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/res/js/ECityAlert.js"></script>

</body>
</html>