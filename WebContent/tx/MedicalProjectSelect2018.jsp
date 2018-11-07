<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.booking.TMedicalProjectList"%>
<%
	response.setHeader("Pragma","No-cache");	
	response.setHeader("Cache-Control","no-cache");	
	response.setDateHeader("Expires", 0);
	
	
	String amb_Level=(String)request.getSession().getAttribute("amb_Level");
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/head.jsp" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/res/css/em.css?2019062901">

<script type="text/javascript" src="<%=request.getContextPath() %>/res/js/layui/layui.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath() %>/res/js/layui/css/layui.css">
<style type="text/css">
body { /* IOS禁止微信调整字体大小 */
  -webkit-text-size-adjust: 100% !important;
}

.page, body {
  background-color: #f8f8f8;
}

.daydiv {
  border: 0.0714em solid silver;
  border-radius: 0.3571em;
  padding: 0.0714em;
  height: 100%;
  width: 100%;
}

.canselect.select>.daydiv {
  border-color: red;
}

.dateTitle>h {
  width: 100%;
  display: block;
}

.daydiv>div {
  padding: 0.3571em 0px;
}

.dateDiv {
  display: inline-block;
  width: 23%;
  padding: 2%;
  font-size: 0.8571em;
}

.layui-tab-item {
  height: 100%;
}

.layui-tab-card > .layui-tab-title [lay-id='0']{
  background-color: #efdd9c;   
}
.layui-tab-card > .layui-tab-title [lay-id='1']{
  background-color: #9cd8f0;   
}
.layui-tab-card > .layui-tab-title [lay-id='2']{
  background-color: #9caef0;   
}
.layui-tab-card > .layui-tab-title {
    background-color: #b49cf0;
}

.layui-tab-content{
  background-color: #fff;
}
.layui-tab-card > .layui-tab-title .layui-this::after {

    border-width: 0px;

}
</style>

<link rel="stylesheet" href="<%=request.getContextPath() %>/res/css/em.css?2019062901">

<jsp:include page="/tx/Notice/NoticeJS.jsp" flush="true">
  <jsp:param name="type" value="2" />
</jsp:include>
</head>
<body class="ecity">

  <jsp:include page="/res/temple/TabbarMenuBegin.jsp" />
  <div class="container" id="container">
    <!-- <div class="weui-cells__title"><p>选择挂号类型</p></div> -->
    <div class="layui-tab layui-tab-card" lay-filter="tablist" style="height: calc(100vh - 7.428em);">
      <ul class="layui-tab-title">
      </ul>
      <div class="layui-tab-content" style="height: calc(100% - 2.857em); overflow: scroll;"></div>
    </div>
    <div>
      <button type="button" class="btn btn-primary" onclick="Booking();" style="width: 100%;">确认预约</button>
    </div>
  </div>

  <div id="loadingToast" style="display1: none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
      <i class="weui-loading weui-icon_toast"></i>
      <p class="weui-toast__content">操作中</p>
    </div>
  </div>


  <jsp:include page="/res/temple/TabbarMenuEnd.jsp" />

  <div id="dialogs">
    <div class="js_dialog" id="SelectDialog" style="display: none;">
      <div class="weui-mask"></div>
      <div class="weui-dialog weui-skin_android">
        <div class="weui-dialog__hd">
          <strong class="weui-dialog__title">预约确定</strong>
        </div>
        <div class="weui-dialog__bd dailogText"></div>
        <div class="weui-dialog__ft">
          <a href="javascript:;" onclick="($('#SelectDialog').hide())" class="weui-dialog__btn weui-dialog__btn_default">取消预约</a>
          <a href="<%=request.getContextPath()%>/tx/BookingDatePay.jsp?ID=123"
            class="weui-dialog__btn weui-dialog__btn_primary SelectDialog_YesBtn" onclick="$('#loadingToast').show();">确定预约</a>
        </div>
      </div>
    </div>
  </div>



  <script id="cardtpl" type="text/html">
<div class="layui-collapse">
  <div class="layui-colla-item">
    <h2 class="layui-colla-title">{{ d.Name }}</h2>
    <div class="layui-colla-content ">




<div class="weui-form-preview">
	<div class="weui-form-preview__hd">
		<div class="weui-form-preview__item">
			<label class="weui-form-preview__label">挂号项目</label>
			<em class="weui-form-preview__value" style="line-height: 1.2em;font-size: 1.2em;">{{ d.Name }}</em>
		</div>
	</div>
	<div class="weui-form-preview__bd">
		<div class="weui-form-preview__item">
			<label class="weui-form-preview__label">项目说明</label>
			<em class="weui-form-preview__value" style="text-align: left;">{{ d.Remark }}</em>
		</div>
		<div class="weui-form-preview__item">
			<label class="weui-form-preview__label">挂号金额<span style="color:#E8E8E8">{{ d.Level }}</span></label>
			 <em class="weui-form-preview__value"  style="">¥{{ d.Money }}</em>
		</div>
	</div>
</div>
</div>
</div>
</div>
<div id="dateList{{d.ID}}" class="dateList" style="">
		<div class="layui-tab layui-tab-card"  lay-filter="tabdateList{{d.ID}}" style="height: 100%;">
			<ul class="layui-tab-title">
			</ul>
			<div class="layui-tab-content" style="height: calc( 100% - 40px);overflow: scroll;">
			</div>
		</div>
</div>
</script>

  <script id="dateListtpl" type="text/html">


<div  class="dateDiv {{#  if(d.Count>0){ }} canselect {{#  } }}"  >
	<div class="daydiv" data-id="{{d.id}}" data-ampid="{{d.ampID}}" data-date="{{d.Date}}" data-time="{{d.Time}}"  data-money="{{d.Money}}" >
		<div style="text-align: center;"><span style="font-size: 1.2857em;">{{d.Time}}</span></div>
		<div style="text-align: center;"><span>￥{{d.Money}}</span></div>
{{#  if(d.Count>0){ }}
<div style="text-align: center;background-color: #FFA0A0;border-radius: 0px 0px 0.3571em 0.3571em;"><span style="color: red;">
仅剩{{d.Count}}位
</span></div>
{{#  } else { }}
<div style="text-align: center;background-color: #DDD;border-radius: 0px 0px 0.3571em 0.3571em;"><span style="color: blue;">
已满 </span></div>
{{#  } }}           
		
	</div>
</div>

</script>



  <script>



/*
* android禁止微信浏览器调整字体大小

*  这种方法会导致网页延迟大约1S

*/
/*
(function () {
	if (typeof WeixinJSBridge == "object" && typeof WeixinJSBridge.invoke == "function") {
		handleFontSize();
	} else {
		if (document.addEventListener) {
			document.addEventListener("WeixinJSBridgeReady", handleFontSize, false);
		} else if (document.attachEvent) {
			document.attachEvent("WeixinJSBridgeReady", handleFontSize);
			document.attachEvent("onWeixinJSBridgeReady", handleFontSize);
		}
	}
	
	function handleFontSize() {
	
	// 设置网页字体为默认大小
	
		WeixinJSBridge.invoke('setFontSizeCallback', {
		
		'fontSize': 0
		
		});
		// 重写设置网页字体大小的事件
		
		WeixinJSBridge.on('menu:setfont', function () {
			WeixinJSBridge.invoke('setFontSizeCallback', {
				'fontSize': 0
			});
		});
	}
})();

*/

var MedicalProjectName={};
layui.use(['element','laytpl'], function(){
  var element = layui.element;   
  
  var colorlist=['#EFDD9c','#9cd8f0','#9caef0'];
  element.on('tab(tablist)', function(data){
    
		console.log(data);

		var c=colorlist[data.index];
		var layuishow=$(".layui-show")
		var h=$(layuishow).find(".weui-form-preview").height();
    $(layuishow).find(".dateList").css("height","calc(100% - "+h+"px - 10px)");
    $(layuishow).find(".dateList").css("min-height","300px");
    $('.container>.layui-tab-card>.layui-tab-content').css('background-color',c);
		
		var tabid=$(".layui-show .layui-tab").attr("lay-filter");
		var id=$(".layui-show .layui-tab-title li:first").attr("lay-id");
		element.tabChange(tabid,id); 
		console.log("element.on tab(tablist)");
  });
  
  LoadData();
  ShowDate();
  
});

$(function(){
	$("#container").on('click','.dateDiv.canselect',function(){
		$(".dateDiv").removeClass("select");
		$(this).addClass("select");
		console.log(this);
	})
}); 

function LoadData()
{
	$("#loadingToast").show();
	$.post("<%=request.getContextPath()%>/booking/MedicalProjectList.json",{},function(data){
		console.log(data);
		$("#loadingToast").hide();
		if (data.MsgID==-1)
		{
			alertLayer(data.MsgText);
		}
		else
		{
			var element = layui.element;   
		  var laytpl = layui.laytpl;
			for (i in data.Data)
			{
				var cardTpl = cardtpl.innerHTML;
				var content="";
				laytpl(cardTpl).render(data.Data[i], function(html){
					content = html;
				});
				element.tabAdd('tablist', {
				  title: data.Data[i].NameSht,
				  content: content, //支持传入html
				  id:i
				});
				MedicalProjectName[data.Data[i].ID]=data.Data[i].Name;
			} 
			element.tabChange('tablist',"0"); 

		}
	},"json");
}

function ShowDate()
{
	$("#loadingToast").show();
	$.post("<%=request.getContextPath()%>/booking/BookingDataListList.json",{},function(data){
		console.log(data);
		$("#loadingToast").hide();
		if (data.MsgID==-1)
		{
			alertLayer(data.MsgText);
		}
		else
		{
			
		  var laytpl = layui.laytpl;
			var element = layui.element;   
			
			for (i in data.Data)
			{
				var dateListTpl = dateListtpl.innerHTML;
				var content="";
				laytpl(dateListTpl).render(data.Data[i], function(html){
					content = html;
				});
				if ($("#dateTitle"+data.Data[i].ampID+"-"+data.Data[i].Date).length==0)
				{
					element.tabAdd('tabdateList'+data.Data[i].ampID, {
					  title: data.Data[i].Date,
					  content: "<div class='dateTitle' id ='dateTitle"+data.Data[i].ampID+"-"+data.Data[i].Date+"'></div>", //支持传入html
					  id:data.Data[i].Date
					});
				}
				$("#dateTitle"+data.Data[i].ampID+"-"+data.Data[i].Date).append(content);
				
			} 

			element.tabChange('tablist',"0"); 
			element.render('collapse');
		}
	},"json");
}

function Booking()
{
	if ($(".dateDiv.select").length==0)
	{
		alert("请选择预约时间！");
		return ;
	}
	
	var daydiv=$(".dateDiv.select .daydiv");	
	var id=daydiv.data("id");
	var ampid=daydiv.data("ampid");
	var Date=daydiv.data("date");
	var time=daydiv.data("time");
	
	
	var text="是否确定预约<br>"+MedicalProjectName[ampid]+"<br>"+Date+"&nbsp;"+time+"？";
	
	
	
  var $SelectDialog = $('#SelectDialog');
  	$SelectDialog.find(".dailogText").html(text);
  	$SelectDialog.find(".SelectDialog_YesBtn").attr("href","<%=request.getContextPath()%>/tx/BookingDatePay.jsp?ID="+id);

  $SelectDialog.show();
  
	
}
</script>

</body>
</html>