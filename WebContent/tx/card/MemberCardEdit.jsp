<%@page import="com.java.web.weixin.tx.card.MemberCardFunction"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.sql.table.MySQLTable"%>
<%
  response.setHeader("Pragma", "No-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setDateHeader("Expires", 0);
			String AmcID = request.getParameter("ID") == null ? "" : (String) request.getParameter("ID");

			//System.out.println("MemberCardEdit");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/head.jsp" />
<script src="<%=request.getContextPath()%>/res/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/res/js/bootstrap-datetimepicker.zh-CN.js"></script>
<link href="<%=request.getContextPath()%>/res/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="<%=request.getContextPath() %>/res/css/em.css?2019062901">
<style type="text/css">
.page, body {
  background-color: #f8f8f8;
}

.input-group+.input-group {
  margin-top: 0.7142rem;
}

.input-group {
  width: 100%
}

thead, tr {
  text-align: center;
}

.nav>li {
  width: 20%;
  text-align: center;
}

.row>div>a {
  width: 100%;
}
/*
    .row  a:hover
    {
      width:100%;
      background-color: red;
    }
    */
.row>div>.SelectCount {
  background-color: red;
}

.row {
  width: 100%;
  margin-top: 1.4285rem;
  margin-left: 0px;
  margin-right: 0px;
}

.row>div {
  height: 100%;
  padding-right: 1px;
  padding-left: 1px;
}

[type=radio]+label {
  display: block;
}

[name=UseCount][type=radio]:checked+label {
  background-color: red;
}

[name=RechargeCount][type=radio]:checked+label {
    color: #FFF;
  background-color: blue;
}

[name=CouponsRadio][type=radio]:checked+label {
    color: #FFF;
  background-color: blue;
}

[type=radio] {
  display: none;
}

.cancelDiv {
  display: none;
  width: 0;
  line-height: 0px;
  margin-left: auto;
  margin-right: auto;
}

a.cancelDiv {
  padding: 0px;
  font-size: 0.8571rem;
  margin-top: 0.7142rem;
}

.HistoryTale>tbody>tr:hover>td>.cancelDiv {
  display: inline-block;
  line-height: 1rem;
  width: 100%;
}

.HistoryTale>tbody>tr.D {
  background-color: #ec971f;
}
[role=tabpanel]{
  height:calc(100% - 41px);
  /*overflow: auto;*/
}

label.btn-success{
    color: #000;
    background-color: #C7D3FF;
    border-color: blue;
}

.span1{
color: blue; 
width:  7.1428rem; 
display: table-cell; 
padding: 0.3571rem;
}

.div_padding1{
    padding: 0.1428rem 2.1428rem;
}
</style>

<script type="text/javascript">

var ac=<% MemberCardFunction.GetCouponsShtNameListJson(pageContext);%>;

function ShowCouponsRemark(id){
  layer.open({
    type: 2,
    title: '赠券说明',
    shadeClose: true,
    shade: 0.8,
    area: ['90%', '400px'],
    content: '<%=request.getContextPath() %>/tx/Coupons/ShowCouponsRemark.jsp?ID='+id
  }); 
} 

</script>
</head>
<body>
  <jsp:include page="/res/temple/TabbarMenuBegin.jsp" />
  <%
    String groupid = request.getSession().getAttribute("groupid") == null
  					? ""
  					: (String) request.getSession().getAttribute("groupid");
  			if (!groupid.equals("100") && !groupid.equals("101")) {
  %>
  <div>
    <p>无权操作</p>
  </div>
  <%
    } else {
  %>
  <div class="container" id="container">
    <div class="weui-cells__title">
      <p>次卡操作</p>
    </div>
    <!-- <div><%=AmcID%></div> -->
  </div>
  <%
    MySQLTable Card = new MySQLTable(
  						"select amc_id,amc_GuestName,amc_GuestTel,amc_CreateDate,amc_Count,amc_Money,amc_EndDate,amc_id_amb,amb_Level,ifnull(amb_LevelValue,0) as amb_LevelValue ,ifnull(amb_MissCount,0) as amb_MissCount,ifnull(amc_Remark,'') as amc_Remark  from amc_member_card,amb_member where amb_id=amc_id_amb and  amc_id='"
  								+ AmcID + "'");

  				try {
  					Card.Open();
  					if (!Card.next()) {
  %>
  <div>
    <p>无次卡记录</p>
  </div>
  <%
    } else {
  						java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");
  						String CreateDate = format.format(Card.getDateTime("amc_CreateDate"));
  						String EndDate = format.format(Card.getDateTime("amc_EndDate"));

  						String Level = "";
  						switch (Card.getInt("amb_Level")) {
  							case 1 :
  								Level = "<span style=\"color:blue;\">高级</span>";
  								break;
  							default :
  								Level = "<span style=\"color:red;\">低级</span>";
  								break;
  						};
  						String LevelValue = Card.getString("amb_LevelValue");
  						String MissCount = Card.getString("amb_MissCount");
  						String Remark = Card.getString("amc_Remark");

  						java.util.Date ss = new java.util.Date();
  						java.util.Calendar rightNow = java.util.Calendar.getInstance();
  						rightNow.setTime(ss);
  						rightNow.add(java.util.Calendar.YEAR, 1);//日期减1年
  						String NewRechargeDate = format.format(rightNow.getTime());

  						java.util.Date today = new java.util.Date();

  						request.getSession().setAttribute("CountAmcID", AmcID);
  						request.getSession().setAttribute("CountMemberID", Card.getString("amc_id_amb"));
              String amc_id_amb= Card.getString("amc_id_amb");
  %>
  <div class="container">
    <div class="" style="font-size: 0.8571rem; line-height: 1rem;">
      <div class="input-group" style="padding: 0px; width: 50%; float: left;">
        <span style="display: table-cell; text-align: right;" id="basic-addon1">姓名：</span> <span class="span1" id="CardGuestName"><%=Card.getString("amc_GuestName")%></span>
      </div>
      <div class="input-group" style="padding: 0px; width: 50%; float: left; margin-top: 0px;">
        <span style="display: table-cell; text-align: right;" id="basic-addon1">手机：</span> <span class="span1" id="CardGuestTel"><%=Card.getString("amc_GuestTel")%></span>
      </div>
      <div style="clear: both; height: 1px; background-color: #E4E4E4;"></div>
    </div>
    <div class="" style="font-size: 0.8571rem; line-height: 1rem;">
      <div class="input-group" style="padding: 0px; width: 50%; float: left;">
        <span style="display: table-cell; text-align: right;" id="basic-addon1">充值日期：</span> <span class="span1"><%=CreateDate%> <a
          href="javascript:void(0);" role="button" onclick="EditCreateTime()"
        > <span class="glyphicon glyphicon-pencil" aria-hidden="true" style="margin-left: 5px; color: red;"></span>
        </a> </span>
      </div>
      <div class="input-group" style="padding: 0px; width: 50%; float: left; margin-top: 0px;">
        <span style="display: table-cell; text-align: right;" id="basic-addon1">有效期：</span> <span class="span1" id="CardEndDate"><%=EndDate%></span>
      </div>
      <div style="clear: both; height: 1px; background-color: #E4E4E4;"></div>
    </div>
    <div class="" style="font-size: 0.8571rem; line-height: 1rem;">
      <div class="input-group" style="padding: 0px; width: 50%; float: left;">
        <span style="display: table-cell; text-align: right;" id="basic-addon1">等级：</span> <span class="span1"><%=Level%></span>
      </div>
      <div class="input-group" style="padding: 0px; width: 50%; float: left; margin-top: 0px;">
        <%
          if (!LevelValue.equals("0")) {
        %>
        <span style="display: table-cell; text-align: center; padding: 5px;" id="basic-addon1">黑名单剩余<%=LevelValue%>天
        </span>
        <%
          } else if (!MissCount.equals("0")) {
        %>
        <span style="display: table-cell; text-align: center; padding: 5px;" id="basic-addon1">30天内爽约<%=MissCount%>次
        </span>
        <%
          } else {
        %>
        <span style="display: table-cell; text-align: center; padding: 5px;" id="basic-addon1">&nbsp;</span>
        <%
          }
        %>
      </div>
      <div style="clear: both; height: 1px; background-color: #E4E4E4;"></div>
    </div>
    <div class="input-group font1 text-center" style="line-height: 1.4285rem; padding: 0.1428rem;">
      <span>剩余消费次数：</span><span style="color: red; font-size: 1.4285rem" id="CardCount"><%=Card.getString("amc_Count")%></span>
    </div>
    <div class="" style="font-size: 0.8571rem; line-height: 1rem;">
      <div class="input-group" style="padding: 0px; width: 100%; float: left;">
        <span style="display: table-cell; width: 5.1428rem; text-align: right;" id="basic-addon1"> <a href="javascript:void(0);" role="button" onclick="EditRemark()"> 备注<span
            class="glyphicon glyphicon-pencil" aria-hidden="true" style="margin-left: 0.3571rem; color: red;"
          ></span>：
        </a>
        </span> <span style="color: blue; display: table-cell; padding: 0.3571rem;"><%=Remark%></span>
      </div>
      <div style="clear: both; height: 1px; background-color: #E4E4E4;"></div>
    </div>
  </div>
  <%
    if (today.after(Card.getDateTime("amc_EndDate"))) {
  %>
  <div class="alert alert-danger" role="alert">此卡已过期！</div>
  <!-- 已过期确认 -->
  <div class="modal" id="TimeOutConfirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-show="true" style="margin-top: 100px">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
          <h4 class="modal-title" id="myModalLabel">过期确认</h4>
        </div>
        <div class="modal-body">
          <span>此卡已过有效期，请注意！</span>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">确定</button>
        </div>
      </div>
    </div>
  </div>
  <script type="text/javascript">        
      $(function(){
          $("#TimeOutConfirm").modal("show");
      });    
      </script>
  <%
    }
  %>
  <div style="height: 100%; padding-bottom: 2.85rem;">
    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
      <li role="Use" class="tab-pane active"><a href="#Use" aria-controls="Use" role="tab" data-toggle="tab">消费</a></li>
      <li role="Coupons" class="tab-pane"><a href="#Coupons" aria-controls="#Coupons" role="tab" data-toggle="tab">赠券</a></li>
      <li role="Recharge" class="tab-pane"><a href="#Recharge" aria-controls="Recharge" role="tab" data-toggle="tab">充值</a></li>
      <li role="EditInfo" class="tab-pane"><a href="#EditInfo" aria-controls="EditInfo" role="tab" data-toggle="tab" style="padding: 0.7142rem 0.07142rem;" >客人资料</a></li>
      <li role="History" class="tab-pane"><a href="#History" aria-controls="History" role="tab" data-toggle="tab">历史</a></li>
    </ul>
    <!-- Tab panes -->
    <div class="tab-content" style="height: 100%; padding-bottom: 0px;">
      <div role="tabpanel" class="tab-pane fade in active" id="Use" ">
        <!-- 消费 -->
        <div class="container-fluid" id="SelectCountBtn" style="background-color: rgb(117, 255, 117); height: 100%;">
          <div class="input-group font1 text-center" style="line-height: 1.4285rem; padding: 0.1428rem; margin-top: 0.7142rem">
            <span>最近充值金额：<%=Card.getInt("amc_Money")%></span>
          </div>
          <div class="input-group font1 text-center" style="line-height: 1.4285rem; padding: 0.1428rem; margin-top: 0.7142rem">
            <span>选择消费次数</span>
          </div>
          <div class="container-fluid" style="font-size: 0px; margin-top: 1.4285rem;">
            <%
              for (int i = 1; i <= 10; i++) {
            %>
            <div style="display: inline-block; width: 20%; padding: 0.1428rem; font-size: 1rem;">
              <input type="radio" name="UseCount" id="UseCountRadio<%=i%>" value="<%=i%>"> <label for="UseCountRadio<%=i%>" class="btn btn-success"><%=i%></label>
            </div>
            <%
              }
            %>
          </div>
          <div class="input-group font1 text-center div_padding1" style="line-height: 1.4285rem; margin-top: 30px">
            <a class="btn  btn-default" href="javascript:void(0);" role="button" onclick="SaveUse()" id="SaveUseBtn" style="width: 100%" disabled="disabled">请选择消费次数</a>
          </div>
          <div class="input-group font1 text-center div_padding1" style="line-height: 1.4285rem;  margin-top: 30px">
            <a class="btn  btn-warning" href="javascript:ShowManualEntry()" role="button" style="width: 100%" disabled="disabled">手工排队</a>
          </div>
        </div>
        <!-- 消费次数确认 -->
        <div class="modal" id="CountConfirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">消费确认</h4>
              </div>
              <div class="modal-body">
                <span>是否确认消费<span id="modalCount"></span>次？
                </span>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="CountConfirm();">确认消费</button>
              </div>
            </div>
          </div>
        </div>
        <div class="modal" id="ManualEntryModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" style="z-index: 1050">
          <div class="modal-dialog" role="document" style="max-width: 360px; margin-left: auto; margin-right: auto; margin-top: 100px;">
            <div class="modal-content">
              <div class="modal-body" style="min-height: 50px">
                <h>
                <center>手工排队</center>
                </h>
                <div class="bs-example bs-example-form">
                  <div class="input-group">
                    <span class="input-group-addon" id="basic-addon1">姓名</span> <input type="text" class="form-control" id="ManualEntryGuestName" placeholder="姓名" aria-describedby="basic-addon1"
                      value="<%=Card.getString("amc_GuestName")%>"
                    >
                  </div>
                  <div class="input-group">
                    <span class="input-group-addon" id="basic-addon1">电话</span> <input type="text" class="form-control" id="ManualEntryGuestTel" placeholder="电话" aria-describedby="basic-addon1"
                      value="<%=Card.getString("amc_GuestTel")%>"
                    >
                  </div>
                </div>
              </div>
              <div class="modal-footer" style="padding: 5px;">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" onclick="ManualEntryConfirm()">确认手工排队</button>
              </div>
            </div>
          </div>
        </div>
        <script type="text/javascript">        
      $(function(){
          $('#SelectCountBtn .btn-success').on('click', function(){
              //$('#SelectCountBtn .btn-success').removeClass("SelectCount");
              //$(this).addClass("SelectCount");
                $("#SaveUseBtn").html("确认消费"+ $(this).html()+"次") 
                $("#SaveUseBtn").removeClass("btn-default");
                 $("#SaveUseBtn").addClass("btn-danger");
                
                $("#SaveUseBtn").removeAttr("disabled");            
            });

      });    
      function SaveUse()
      {
        if ($("input[name=UseCount]:checked").length==0)
        {
          alert("请选择消费次数！")
          return;
        }
        $("#modalCount").html($("input[name=UseCount]:checked").val());
        $("#CountConfirm").modal("show");
      }
      function CountConfirm()
      {
    	  $("#CountConfirm").modal("hide");
        if ($("input[name=UseCount]:checked").length==0)
        {
          alert("请选择消费次数！")
          return;
        }
        var count=0-$("input[name=UseCount]:checked").val()*1;
        $("#loadingToast").show();
        $.post("<%=request.getContextPath()%>/card/MemberCardUse",{"ID":"<%=AmcID%>","Count":count},function(data){
              console.log(data);

              $("#loadingToast").hide();
              if (data.MsgID==-1)
              {
            	  alert(data.MsgTest);
              }
              else
              {

                $("#CardCount").html(data.Count);
            	  alert("消费成功！")
                  
              }
          },"json");
        
      }
      function ShowManualEntry()
      {
          $('#ManualEntryModal').modal('show');
      }
      function ManualEntryConfirm()
      {
          $("#ManualEntryModal").modal("hide");

          AmbID="<%=Card.getString("amc_id_amb")%>";
          GuestName=$("#ManualEntryGuestName").val();
          GuestTel=$("#ManualEntryGuestTel").val();
          BookingTimeID=0;       
          $("#loadingToast").show();
          $.post("<%=request.getContextPath()%>/booking/BookingDateManualEntry.json",{"AmbID":AmbID,"GuestName":GuestName,"GuestTel":GuestTel,"AbdID":BookingTimeID,"CheckIn":"1"},function(data){
                //console.log(data);

                $("#loadingToast").hide();
                if (data.MsgID==-1)
                {
                    alert(data.MsgTest);
                }
                else
                {    
                    alert("排队成功！")
                    window.location.href='<%=request.getContextPath()%>/tx/booking/QueryBookingDateList0628.jsp?d=' + new Date().Format('yyyymmddhhnnss')
                }
            },"json");
      }
      </script>
      </div>
      <!-- 赠券  -->
      <div role="tabpanel" class="tab-pane fade" id="Coupons" >
        <div class="container-fluid" id="" style="background-color: rgb(192, 192, 192); height: 100%; padding-top: 0.7142rem;overflow: auto;">
            <%
            int CouponsCount=0;
              MySQLTable CouponsTable = new MySQLTable("select amc_Name,date_format(amc_TimeValidity,'%Y-%m-%d') as amc_TimeValidity,amc_id,amc_UseFlag,amc_id_ac from amc_Member_Coupons where _status<>'D' and amc_Flag=1  and amc_id_amb='"+amc_id_amb+"'   order by amc_UseFlag , amc_TimeValidity ");
              try {
                CouponsTable.Open();
                int i = 1;
                while (CouponsTable.next()) {
                  %>
                  <div class="CouponsCard" UseFlag="<%=CouponsTable.getInt("amc_UseFlag")%>">
                    <div class="CouponsName"><span><%=CouponsTable.getString("amc_Name") %></span></div>
                    <div class="CouponsTimeValidity"><span><%=CouponsTable.getString("amc_TimeValidity") %></span></div>
                    <div class="CouponsRemark"><a href="javascript:void(0);" onclick="ShowCouponsRemark('<%=CouponsTable.getString("amc_id_ac")%>')"><span>赠券说明<i class="weui-icon-info-circle weui-icon_msg"></i></span></a></div>
                    <% 
                    if (CouponsTable.getInt("amc_UseFlag")==0){
                      %>
                      <div class="CouponsButton"><a class="btn  btn-success" href="javascript:void(0);" role="button" onclick="UseTicket('<%=CouponsTable.getString("amc_id") %>')">立即使用</a></div>
                      <%
                    }
                    else{
                      %>
                      <div class="CouponsButton"><a class="btn  btn-warning" href="javascript:void(0);" role="button" onclick="ResumeTicket('<%=CouponsTable.getString("amc_id") %>')">恢复状态</a></div>
                      <%
                    }
                    %>
                    
                    <div style="clear: both;"></div>
                  </div>
                  <%
                  i++;
                  if (CouponsTable.getInt("amc_UseFlag")==0){
                    CouponsCount++;
                  }
                }
                if (i==1)
                {
                  %>
                    <div class="input-group font1 text-center" style="line-height: 1.4285rem; padding: 0.1428rem; margin-top: 0.7142rem">
                      <span>无可用的赠券</span>
                    </div>
                  <%
                }
              } finally {
                CouponsTable.Close();
              }
            %>
          <script type="text/javascript">
          <%
          if (CouponsCount>0){
            %>
            $('[role=Coupons]').append('<span class="weui-badge Count2" style="position: absolute;top: 0;right: 0;z-index: 9"><%=CouponsCount%></span>');
            <%
          }
          %>
          function UseTicket(ticketID)
          {
              var Str="是否确认使用此赠券？";
              var confirm=weui.confirm(Str, function (){
                confirm.hide();
                $("#loadingToast").show();
                var json={"ticketID":ticketID};
                $.post("<%=request.getContextPath()%>/Coupons/UseCoupons",JSON.stringify(json),function(data){
                      console.log(data);
                      if (data.MsgID==-1)
                      {
                        $("#loadingToast").hide();
                        weui.alert(data.MsgText);
                      }
                      else
                      {
                        weui.alert('赠券使用成功！', {
                          title: '赠券',
                          buttons: [{
                              label: '确认',
                              type: 'primary',
                              onClick: function(){ 
                                window.location.href='<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID=<%=AmcID%>&d=' + new Date().getTime();
                              }
                          }]
                        });
                      }
                  },"json");
              }, function (){

                console.log('confirm2');
              });
              
            }
            function ResumeTicket(ticketID)
            {
                var Str="<span style='color:red'>是否将此赠券恢复成未使用状态？</span>";
                var confirm=weui.confirm(Str, function (){
                  confirm.hide();
                  $("#loadingToast").show();
                  var json={"ticketID":ticketID};
                  $.post("<%=request.getContextPath()%>/Coupons/ResumeCoupons",JSON.stringify(json),function(data){
                        console.log(data);
                        if (data.MsgID==-1)
                        {
                          $("#loadingToast").hide();
                          weui.alert(data.MsgText);
                        }
                        else
                        {
                          weui.alert('赠券恢复成功！', {
                            title: '赠券',
                            buttons: [{
                                label: '确认',
                                type: 'primary',
                                onClick: function(){ 
                                  window.location.href='<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID=<%=AmcID%>&d=' + new Date().getTime();
                                }
                            }]
                          });
                        }
                    },"json");
                }, function (){
  
                  console.log('confirm2');
                });
                
              }
          </script>
        </div>
      </div>
      <!-- 充值  -->
      <div role="tabpanel" class="tab-pane fade" id="Recharge" >
        <div class="container-fluid" id="" style="background-color: rgb(255, 67, 67); height: 100%; padding-top: 0.7142rem;overflow:auto">
          <div class="container-fluid" style="font-size: 0px; margin-top: 1.4285rem;">
            <%
              MySQLTable RechargeAmount = new MySQLTable(
                            "select amcra_Count,amcra_Money,amcra_id_ac from amcra_member_card_recharge_amount where _status<>'D' and amcra_Flag=1  order by amcra_Count");
                        try {
                          RechargeAmount.Open();
                          int i = 1;
                          while (RechargeAmount.next()) {
            %>
            <div style="display: inline-block; width: 50%; padding: 0.1428rem; font-size: 1rem;" name="RechargeCount">
              <input type="radio" name="RechargeCount" id="RechargeCountRadio<%=i%>" Count="<%=RechargeAmount.getInt("amcra_Count")%>" Money="<%=RechargeAmount.getInt("amcra_Money")%>" 
              acid="<%=RechargeAmount.getString("amcra_id_ac") %>" acname=""   value="<%=i%>"
              > <label for="RechargeCountRadio<%=i%>" style="height:3.8571rem;"class="btn btn-success">充值<%=RechargeAmount.getInt("amcra_Count")%>次<%=RechargeAmount.getInt("amcra_Money")%>元
              <%
              if (!RechargeAmount.getString("amcra_id_ac").equals(""))
              {
                %>
                <br>赠券：<span acid="<%=RechargeAmount.getString("amcra_id_ac") %>"></span>
                <%
              }
              else{
                %>
                <br>&nbsp;<span >&nbsp;</span>
                <%
              }
              %>
              </label>
            </div>
            <%
              i++;
                          }
                        } finally {
                          RechargeAmount.Close();
                        }
            %>
          </div>
          <div class="input-group div_padding1" >
            <span class="input-group-addon" id="basic-addon1">充值次数</span> <input type="Number" class="form-control" id="RechargeCount" placeholder="充值次数" aria-describedby="basic-addon1" value="0">
          </div>
          <div class="input-group div_padding1" >
            <span class="input-group-addon" id="basic-addon1">充值金额</span> <input type="Number" class="form-control" id="RechargeMoney" placeholder="充值金额" ariadescribedby="basic-addon1" value="0">
          </div>
          <div class="input-group div_padding1" >
            <span class="input-group-addon" id="basic-addon1">赠券信息</span> <input type="text" class="form-control" id="RechargeCoupons" placeholder="赠券信息" ariadescribedby="basic-addon1" readonly value="0" acid="">
          </div>
          <div class="input-group font1 text-center div_padding1" style="line-height: 1.4285rem;  margin-top: 5px">
            <a class="btn  btn-success" href="javascript:void(0);" role="button" onclick="SaveRecharge()" id="SaveRechargeBtn" style="width: 100%">确认充值</a>
          </div>
          
          <!-- 充值次数确认 -->
          <div class="modal" id="RechargeConfirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                  <h4 class="modal-title" id="myModalLabel">充值确认</h4>
                </div>
                <div class="modal-body">
                  <span id="modalRechargeCount"></span>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                  <button type="button" class="btn btn-primary" onclick="RechargeConfirm();">确认充值</button>
                </div>
              </div>
            </div>
          </div>
          <div class="input-group div_padding1" style="margin-top: 30px; ">
            <span class="input-group-addon" id="basic-addon1">有效期限</span> <input type="text" value="<%=EndDate%>" id="EndDate" class=" form-control form_datetime " readonly
              data-date-format="yyyy-mm-dd"
            >
          </div>
          <div class="input-group font1 text-center div_padding1" style="line-height: 1.4285rem;  margin-top: 5px">
            <a class="btn  btn-success" href="javascript:void(0);" role="button" onclick="SaveEndDate()" id="SaveEndDateBtn" style="width: 100%">确认修改有新效期</a>
          </div>
          <!-- 充值次数确认 -->
          <div class="modal" id="EndDateConfirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                  <h4 class="modal-title" id="myModalLabel">延期确认</h4>
                </div>
                <div class="modal-body">
                  <span>是否确认延期至<span id="modalEndDate"></span>？
                  </span>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                  <button type="button" class="btn btn-primary" onclick="EndDateConfirm();">确认延期</button>
                </div>
              </div>
            </div>
          </div>
          
          <div class="input-group font1 text-center" style="padding: 0.1428rem;margin-top: 0.7142rem;height: 1px;border-bottom: 1px solid #FFF;">
            <span style="color:#FFF">发放赠券</span>
          </div>
            <div class="container-fluid" style="font-size: 0px; margin-top: 1.4285rem;">
              <%
                MySQLTable CouponsTable2 = new MySQLTable("select ac_ShtName,ac_id from ac_Coupons where _Status<>'D' and ac_flag=1 order by ac_ShtName");
                try {
                  CouponsTable2.Open();
                  int i = 1;
                  while (CouponsTable2.next()) {
              %>
              <div style="display: inline-block; width: 50%; padding: 0.1428rem; font-size: 1rem;" name="CouponsRadio">
                <input type="radio" name="CouponsRadio" id="CouponsRadio<%=i%>" value="<%=CouponsTable2.getString("ac_id")%>"CouponsID="<%=CouponsTable2.getString("ac_id")%>" CouponsName="<%=CouponsTable2.getString("ac_ShtName")%>"> 
                  <label for="CouponsRadio<%=i%>" class="btn btn-success"><%=CouponsTable2.getString("ac_ShtName")%></label>
              </div>
              <%
                    i++;
                  }
                }finally {
                  CouponsTable2.Close();
                }
              %>
            </div>
            
            <div class="input-group font1 text-center div_padding1" style="line-height: 1.4285rem;  margin-top: 5px">
              <a class="btn  btn-success" href="javascript:void(0);" role="button" disabled="disabled" onclick="SaveCoupons()" id="SaveCouponBtn" CouponsID="" style="width: 100%">确认发放【<span id ="CouponsName" style="color:blue"></span>】赠券</a>
            </div>
            <div style="margin: 5px;">&nbsp;</div>
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
          $('.form_datetime').val('<%=NewRechargeDate%>');

          $("div[name=RechargeCount]").on('click', function(){
              //console.log($(this));
              $("#RechargeCount").val($("input[name=RechargeCount]:checked").attr("Count")); 
              $("#RechargeMoney").val($("input[name=RechargeCount]:checked").attr("Money"));
              var RechargeCoupons=$("input[name=RechargeCount]:checked").attr("acname");
              if (RechargeCoupons==''){

                $("#RechargeCoupons").val("无赠券");
                $("#RechargeCoupons").attr("acid","");
              }
              else{
                $("#RechargeCoupons").val(RechargeCoupons);
                $("#RechargeCoupons").attr("acid",$("input[name=RechargeCount]:checked").attr("acid"));
              }
          });
          $("div[name=CouponsRadio]").on('click', function(){
              //console.log($(this));
              $("#SaveCouponBtn").attr("CouponsID",$("input[name=CouponsRadio]:checked").attr("CouponsID")); 
              $("#SaveCouponBtn").removeAttr("disabled"); 
              $("#CouponsName").html($("input[name=CouponsRadio]:checked").attr("CouponsName"));
          });
          $('span[acid]').each(function(){
            var acid=$(this).attr('acid');
            $(this).html(ac[acid]);
            $('input[acid='+acid+']').attr('acname',ac[acid]);
          });
          //$("label[for^=UseCountRadio]").on('click', function(){
          //    console.log($(this));
          //    $("#RechargeCount").val($("input[name=RechargeCount]:checked").attr("Count")); 
          //    $("#RechargeMoney").val($("input[name=RechargeCount]:checked").attr("Money"));          
          //});
          
        })
         
      function SaveRecharge()
      {
          var count=$("#RechargeCount").val()*1;
          var money=$("#RechargeMoney").val()*1;
          var acid=$("#RechargeCoupons").attr("acid");
          var EndDate=$("#EndDate").val();
          
          var Str="<div style='text-align: left;font-size: 1.5rem;line-height: 2rem;'>操作确认<br>充值："+count+"次<br>金额："+money+"元<br>延期："+EndDate;
          if (acid!=""){
            Str=Str+"<br><span style='color:red'>赠券："+$("#RechargeCoupons").val()+"</span>";
          }
        
          Str=Str+"</div>";
          
          var confirm=weui.confirm(Str, function (){

            confirm.hide();
            $("#loadingToast").show();
            $.post("<%=request.getContextPath()%>/card/MemberCardRecharge",{"ID":"<%=AmcID%>","Count":count,"Money":money,"EndDate":EndDate,"acid":acid},function(data){
                  console.log(data);
  
                  $("#loadingToast").hide();
                  if (data.MsgID==-1)
                  {
                    alert(data.MsgTest);
                  }
                  else
                  {
                    $("#CardCount").html(data.Count);
                    weui.alert('充值成功！', {
                      title: '充值',
                      buttons: [{
                          label: '确认',
                          type: 'primary',
                          onClick: function(){ 
                            window.location.href='<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID=<%=AmcID%>&d=' + new Date().getTime();
                          }
                      }]
                    });
                  }
              },"json");
          },function(){
            
          });
  
          
          
          
          //$("#modalRechargeCount").html(Str);
          //$("#RechargeConfirm").modal("show");
        }
        function SaveCoupons()
        {
          if ($('#SaveCouponBtn').attr('disabled')==undefined){

            var Str="是否确认<br>发放赠券【<span style='color:blue'>"+$("#CouponsName").html()+"</span>】一张?";
            var CouponsID=$("#SaveCouponBtn").attr('CouponsID');
            
            var confirm=weui.confirm(Str, function (){
              console.log('confirm1');
              confirm.hide();
              $("#loadingToast").show();
              var json={"MemberID":"<%=amc_id_amb%>","CouponsID":CouponsID};
              $.post("<%=request.getContextPath()%>/Coupons/SendCoupons",JSON.stringify(json),function(data){
                    console.log(data);
                    if (data.MsgID==-1)
                    {
                      $("#loadingToast").hide();
                      weui.alert(data.MsgText);
                    }
                    else
                    {

                      console.log('confirm11');

                      console.log('confirm111');
                      weui.alert('赠券发放成功！', {
                        title: '赠券',
                        buttons: [{
                            label: '确认',
                            type: 'primary',
                            onClick: function(){ 
                              window.location.href='<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID=<%=AmcID%>&d=' + new Date().getTime();
                            }
                        }]
                      });
                    }
                },"json");
            }, function (){

              console.log('confirm2');
            });
            
          }
        }
        
      function RechargeConfirm()
      {
        $("#RechargeConfirm").modal("hide");
        var count=$("#RechargeCount").val()*1;
        var money=$("#RechargeMoney").val()*1;
        var EndDate=$("#EndDate").val();
        $("#loadingToast").show();
        $.post("<%=request.getContextPath()%>/card/MemberCardRecharge",{"ID":"<%=AmcID%>","Count":count,"Money":money,"EndDate":EndDate},function(data){
              console.log(data);

              $("#loadingToast").hide();
              if (data.MsgID==-1)
              {
                alert(data.MsgTest);
              }
              else
              {
                $("#CardCount").html(data.Count);
                alert("充值成功！")                  
              }
          },"json");
        
      }
      function SaveEndDate()
      {        
        $("#modalEndDate").html($("#EndDate").val());
        $("#EndDateConfirm").modal("show");
      }
      function EndDateConfirm()
      {
        $("#EndDateConfirm").modal("hide");
        var EndDate=$("#EndDate").val();
        $("#loadingToast").show();
        $.post("<%=request.getContextPath()%>/card/MemberCardEndDate",{"ID":"<%=AmcID%>","EndDate":EndDate},function(data){
              console.log(data);

              $("#loadingToast").hide();
              if (data.MsgID==-1)
              {
                alert(data.MsgTest);
              }
              else
              {
                $("#CardEndDate").html(data.EndDate);
                alert("延期成功！")                  
              }
          },"json");
        
      }
       </script>
        </div>
      </div>
      <div role="tabpanel" class="tab-pane fade" id="History" >
        <!-- 使用历史 -->
        <div class="input-group" id="">
          <a class="btn btn-success " href="javascript:void(0);" onclick="QueryHistory()" role="button" style="width: 100%">查询使用历史</a>
        </div>
        <div class="input-group" id="HistoryData"></div>
        <!-- 修改资料确认 -->
        <div class="modal" id="CancelCardHistoryConfirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">取消操作</h4>
              </div>
              <div class="modal-body">
                <span>是否确认取消</span><span id="modalCancelCardHistory"></span>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="CancelCardHistoryConfirm();">确认取消</button>
              </div>
            </div>
          </div>
        </div>
        <script type="text/javascript">
        function QueryHistory()
        { 

          $("#loadingToast").show();
          $.ajax({
                url:"<%=request.getContextPath()%>/card/MemberCardHistoryQuery?ID=<%=AmcID%>&d="+new Date().Format("yyyyMMddHHmmss"),
                type:'get',
                dataType:'Json',
                success:function(data){

                  $("#loadingToast").hide();
                  if (data.MsgID!=1)
                  {
                    alert(data.MsgText);
                  }
                  else
                  {
                    console.log(data);
                    $("#HistoryData").html("");
                    var table=$("<table class='table table-striped table-condensed HistoryTale'></table>");
                    var th=$("<thead><td>类型</td><td>日期</td><td>剩余次数</td></thead>");
                    table.append(th);
                    var body=$("<tbody></tbody>")
                    for (var i=0;i<data.Data.length;i++)
                    {                        
                      var count="";
                      if (data.Data[i].Count>0)
                      {
                        count="+"+data.Data[i].Count;
                      }
                      else if (data.Data[i].Count<0)
                      {
                        count=data.Data[i].Count;
                      }
                      if (data.Data[i].Money>0)
                    	{
                    	  count=count+"/"+data.Data[i].Money+"元"; 
                    	}
                      var div ="";
                      if (((data.Data[i].Type=='消费') || (data.Data[i].Type=='充值')))
                      {
                    	  if (data.Data[i].Status=="I")
                    	  {
                    		  div="<a class=\"btn btn-danger cancelDiv\" href=\"javascript:void(0);\" onclick=\"CancelCardHistory(this,'"+data.Data[i].ID+"');\" role=\"button\" >取消操作</a>";                    		  
                    	  }
                    	  else if (data.Data[i].Status=="D")
                    	  {
                    		  div="<a class=\"btn btn-info cancelDiv\" href=\"javascript:void(0);\" role=\"button\" >已取消</a>";
                    	  }
                    	  
                      }
                      var tr=$("<tr class=\""+data.Data[i].Status+"\"><td class=\"td1\">"+data.Data[i].Type+"</td><td class=\"td2\">"+data.Data[i].Date+"</td><td><div class=\"td3\">"+count+"</div>"+div+"</td></tr>");
                      console.log(tr);
                      body.append(tr);
                    }
                    table.append(body);
                    $("#HistoryData").append(table);
                  }
                }
          }); 
        }
        var CancelID="";
        
        function CancelCardHistory(t,ID)
        {
        	var tr=$(t).parent().parent();
            CancelID=ID;
        	
            $("#modalCancelCardHistory").html("<br>类型："+tr.find(".td1").html()+"<br>日期："+tr.find(".td2").html()+"<br>次数："+tr.find(".td3").html());
            $("#CancelCardHistoryConfirm").modal("show");
        	//onsole.log($(t).css("display")); 
        	//console.log(ID);
        	
        }
        
        function CancelCardHistoryConfirm()
        {
          $("#CancelCardHistoryConfirm").modal("hide");
          $("#loadingToast").show();
          $.post("<%=request.getContextPath()%>/card/MemberCardCancel",{"ID":"<%=AmcID%>","HistoryID":CancelID},function(data){
                console.log(data);

                $("#loadingToast").hide();
                if (data.MsgID<=0)
                {
                  alert(data.MsgTest);
                }
                else
                {

                    $("#CardCount").html(data.Count);
                    QueryHistory();
                    alert("取消操作成功！")                  
                }
            },"json");          
        }
      </script>
      </div>
      <div role="tabpanel" class="tab-pane fade" id="EditInfo" >
        <!-- 修改资料 -->
        <div class="container-fluid" id="" style="background-color: #E1E1FF; height: 100%; padding-top: 50px;">
          <div class="input-group div_padding1" >
            <span class="input-group-addon" id="basic-addon1">姓名</span> <input type="text" class="form-control" id="EditInfoGuestName" placeholder="姓名" aria-describedby="basic-addon1"
              value="<%=Card.getString("amc_GuestName")%>"
            >
          </div>
          <div class="input-group div_padding1" >
            <span class="input-group-addon" id="basic-addon1">手机</span> <input type="text" class="form-control" id="EditInfoGuestTel" placeholder="手机" aria-describedby="basic-addon1"
              value="<%=Card.getString("amc_GuestTel")%>"
            >
          </div>
          <div class="input-group font1 text-center div_padding1" style="line-height: 1.4285rem;  margin-top: 30px">
            <a class="btn  btn-success" href="javascript:void(0);" role="button" onclick="SaveEditInfo()" id="SaveEditInfoBtn" style="width: 100%">确认修改</a>
          </div>
          <!-- 修改资料确认 -->
          <div class="modal" id="EditInfoConfirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                  <h4 class="modal-title" id="myModalLabel">修改资料确认</h4>
                </div>
                <div class="modal-body">
                  <span>是否确认修改资料<span id="modalEditInfo"></span></span>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                  <button type="button" class="btn btn-primary" onclick="EditInfoConfirm();">确认修改</button>
                </div>
              </div>
            </div>
          </div>
          <script type="text/javascript">
      function SaveEditInfo()
      {        
        $("#modalEditInfo").html("<br>姓名："+$("#EditInfoGuestName").val()+"<br>电话："+$("#EditInfoGuestTel").val());
        $("#EditInfoConfirm").modal("show");
      }
      function EditInfoConfirm()
      {
        $("#EditInfoConfirm").modal("hide");
        var GuestName=$("#EditInfoGuestName").val();
        var GuestTel=$("#EditInfoGuestTel").val();
        $("#loadingToast").show();
        $.post("<%=request.getContextPath()%>/card/MemberCardEditInfo",{"ID":"<%=AmcID%>","GuestName":GuestName,"GuestTel":GuestTel},function(data){
              console.log(data);

              $("#loadingToast").hide();
              if (data.MsgID==-1)
              {
                alert(data.MsgTest);
              }
              else
              {
                $("#CardGuestName").html(GuestName);
                $("#CardGuestTel").html(GuestTel);
                alert("资料修改成功！")                  
              }
          },"json");
        
      }
      </script>
        </div>
      </div>
    </div>
    <div id="loadingToast" style="display: none;">
      <div class="weui-mask_transparent"></div>
      <div class="weui-toast">
        <i class="weui-loading weui-icon_toast"></i>
        <p class="weui-toast__content">操作中</p>
      </div>
    </div>
    <script type="text/javascript">
function EditCreateTime()
{
  console.log("EditCreateTime");
  OpenWindows('<%=request.getContextPath()%>/tx/card/EditCreateDate.jsp?ID=<%=AmcID%>','修改充值日期',EditCreateTimeClose,null,"400px");
}

function EditRemark()
{
  console.log("EditRemark");
  OpenWindows('<%=request.getContextPath()%>/tx/card/EditRemark.jsp?ID=<%=AmcID%>','修改备注',EditCreateTimeClose,null,"500px");
}

	function  EditCreateTimeClose()
	{
		console.log("EditCreateTimeClose");

    window.location.href='<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID=<%=AmcID%>&d=' + new Date().getTime()
    }
	

</script>
    <%
      }
        } finally {
          Card.Close();
        }
      }
    %>
    <jsp:include page="/res/temple/TabbarMenuEnd.jsp" />
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>