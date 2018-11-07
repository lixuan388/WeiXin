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
.amp {
    width: 45%;
    display:inline-block;
    margin-left: 10px;
}
.btn {
  width:100%;
    border: 1px red solid;
}
.container {
    margin-bottom: 50px;
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
    <div class="weui-cells__title"><p>选择挂号类型</p></div>
    <div class="DateList">
    
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



<script id="cardtpl" type="text/html">
    <div class="card">
      <div style="font-size: 1.5em;margin:10px 5px;"><span>{{d.Date}}</span><span>{{d.Week}}</span></div>
      <div style="margin:10px 5px;">
      {{# for (var i=1;i<=3;i++){}}
        {{# if (d[i].ampName!=undefined) {}}
          <div class="amp"><a class="btn  btn-default" href="<%=request.getContextPath()%>/tx/BookingDateSelect2019.jsp?ID={{d[i].ampID}}&DateTime={{d[i].DateTime}}" role="button"  style="background-color:{{colorlist[d[i].ampID]}}" >{{d[i].ampName}}：{{#if (d[i].Count>0){ }}余{{d[i].Count}}位{{#} else {}} 已满{{#} }}</a></div>
        {{#}}}
      {{#} }}
      <div style="clear: both;"></div>
      </div>
    </div>
</script>


<script type="text/javascript">


var colorlist=['#000','#ffcccc','#ff99cc','#ccccff'];

layui.use(['element','laytpl'], function(){
  var element = layui.element;   
  var laytpl = layui.laytpl;
  
  
  function LoadData(){
    $("#loadingToast").show();
    $.post("<%=request.getContextPath()%>/booking/BookingDataList2019.json",{},function(data){
      console.log(data);
      $("#loadingToast").hide();
      if (data.MsgID==-1)
      {
        alertLayer(data.MsgText);
      }
      else
      {
        var card=[];
        for (i in data.Data){
          var date=card[data.Data[i].DateID*1.0]||{'Date':data.Data[i].Date,'Week':data.Data[i].Week,'1':{},'2':{},'3':{}};
          date[data.Data[i].ampID]={"ampID":data.Data[i].ampID,"ampName":data.Data[i].ampName,"Count":data.Data[i].Count,"DateTime":data.Data[i].DateTime};
          card[data.Data[i].DateID*1.0]=date;
        }
        
        console.log(card);
        
        for (i in card)
        {
          var cardTpl = cardtpl.innerHTML;
          var content="";
          laytpl(cardTpl).render(card[i], function(html){
            content = html;
          });
          $('.DateList').append(content);

        } 
        
      }
    },"json");    
  }
  
  LoadData();
  
});

</script>

</body>
</html>