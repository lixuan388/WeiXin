<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.booking.TMedicalProjectList"%>
<%
  response.setHeader("Pragma","No-cache");  
  response.setHeader("Cache-Control","no-cache"); 
  response.setDateHeader("Expires", 0);
  

  String ID =request.getParameter("ID")==null?"0":request.getParameter("ID");
  String DateTime=request.getParameter("DateTime")==null?"0":request.getParameter("DateTime");

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


</head>
<body class="ecity">

  <jsp:include page="/res/temple/TabbarMenuBegin.jsp" />
  <div class="container" id="container">
  <!-- 
  </div>
      <div style="margin-top: 10px;">
      <button type="button" class="btn btn-primary" onclick="Booking();" style="width: 100%;">确认预约</button>
  </div>
  -->
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
    <div style="margin: 10px 34px;"><span>预约日期：</span><span>{{ new Date(<%=DateTime%>).Format('MM月dd日') }}</span>
      <a class="btn  btn-default" href="<%=request.getContextPath()%>/tx/MedicalProjectSelect2019.jsp?d={{new Date().getTime()}}" role="button"  style="background-color:red;color:#fff;float: right;padding: 0px 0.4285em;" >重新选择</a>
      
      <div style="clear: both;"></div>
    </div>
    <h2 class="layui-colla-title">预约项目：{{ d.Name }}</h2>
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
<div id="dateList" class="dateList" style="height: calc(100vh - 175px);overflow: scroll;border: 1px #e4e4e4 solid;">
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

<script type="text/javascript">

var MedicalProjectName={};
layui.use(['element','laytpl'], function(){

  var laytpl = layui.laytpl;
  var element = layui.element;   
  var $ = layui.$;   
  
  
  var colorlist=['#ffcccc','#ff99cc','#ccccff'];

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
        for (i in data.Data)
        {
          if (data.Data[i].ID==<%=ID%>){
            var cardTpl = cardtpl.innerHTML;
            var content="";
            laytpl(cardTpl).render(data.Data[i], function(html){
              content = html;
            });
            $('.container').append(content);
            console.log('container');
            MedicalProjectName[data.Data[i].ID]=data.Data[i].Name;           

            element.render('collapse');
            ShowDate();
          }
        } 

      }
    },"json");
  }

  function ShowDate()
  {
    $("#loadingToast").show();
    $.post("<%=request.getContextPath()%>/booking/BookingDataListList2019.json?ID=<%=ID%>&DateTime=<%=DateTime%>",{},function(data){
      console.log(data);
      $("#loadingToast").hide();
      if (data.MsgID==-1)
      {
        alertLayer(data.MsgText);
      }
      else
      {
        if (data.Data.length==0){

          $("#dateList").append('<div style="font-size: 2em;color: red;text-align: center;font-weight: 800;margin: 50px 20px;">无可预约的记录！</div>');
        }
        else{
         
          for (i in data.Data)
          {
            var dateListTpl = dateListtpl.innerHTML;
            var content="";
            laytpl(dateListTpl).render(data.Data[i], function(html){
              content = html;
            });
            $("#dateList").append(content);          
          } 
        } 
      }
    },"json");
  }
  
  
  LoadData();
  
});

$(function(){
  $("#container").on('click','.dateDiv.canselect',function(){
    $(".dateDiv").removeClass("select");
    $(this).addClass("select");
    Booking();
    //console.log(this);
  })
}); 


function Booking()
{
  //if ($(".dateDiv.select").length==0)
  //{
  //  alert("请选择预约时间！");
  //  return ;
  //}
  
  var daydiv=$(".dateDiv.select .daydiv");  
  var id=daydiv.data("id");
  var ampid=daydiv.data("ampid");
  var Date=daydiv.data("date");
  var time=daydiv.data("time");
  
  
  var text="<div  style='text-align: left;font-size: 1.5em;'>是否确定预约<div style='color:red;font-weight: 900;margin-top: 10px;'>"+MedicalProjectName[ampid]+"</div><div  style='color:red;font-weight: 900;margin-top: 10px;'>"+Date+"&nbsp;"+time+"？</div></div>";
  
  weui.confirm(text,function(){
    console.log('1');
    window.location="<%=request.getContextPath()%>/tx/BookingDatePay.jsp?ID="+id;
  },function(){
    console.log('2');
    
  });
  /*
  
  var $SelectDialog = $('#SelectDialog');
    $SelectDialog.find(".dailogText").html(text);
    $SelectDialog.find(".SelectDialog_YesBtn").attr("href","<%=request.getContextPath()%>/tx/BookingDatePay.jsp?ID="+id);

  $SelectDialog.show();
  */
  
}
</script>

</body>
</html>