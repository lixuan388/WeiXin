<%@page import="com.java.web.weixin.tx.card.MemberCardFunction"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.sql.table.MySQLTable"%>
<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  

	String AmcaID =request.getParameter("ID")==null?"":(String)request.getParameter("ID");
	
	

	java.util.Date ss = new java.util.Date();  
	java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");
	java.util.Calendar rightNow = java.util.Calendar.getInstance();
	  rightNow.setTime(ss);
	  rightNow.add(java.util.Calendar.YEAR,1);//日期减1年
	  java.util.Date NewDate=rightNow.getTime();
	  

	  String now = format.format(NewDate);//这个就是把时间戳经过处理得到期望格式的时间  
	  String now2 = format.format(ss);//这个就是把时间戳经过处理得到期望格式的时间  
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/head.jsp" />
<script src="<%=request.getContextPath() %>/res/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/res/js/bootstrap-datetimepicker.zh-CN.js"></script>
<link href="<%=request.getContextPath() %>/res/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
<style type="text/css">
.page, body {
  background-color: #f8f8f8;
}

.input-group+.input-group {
  margin-top: 10px;
}

.bs-example {
  margin-right: 5px;
  margin-left: 5px;
  padding: 10px;
  background-color: #fff;
  border-color: #ddd;
  border-width: 1px;
  border-radius: 4px 4px 0 0;
  -webkit-box-shadow: none;
  box-shadow: none;
  position: relative;
  padding: 15px;
  border-style: solid;
}

[type=radio]+label {
  display: block;
}

[name=RechargeCount][type=radio]:checked+label {
  background-color: blue;
}

[type=radio] {
  display: none;
}
</style>
<script type="text/javascript">

    var ac=<% MemberCardFunction.GetCouponsShtNameListJson(pageContext);%>;
    </script>
</head>
<body>
  <jsp:include page="/res/temple/TabbarMenuBegin.jsp" />
  <div class="container" id="container">
    <div class="weui-cells__title">
      <p>购买次卡</p>
    </div>
    <% 
				if (AmcaID.equals(""))
				{
					%>
    <span>参数错误！</span>
    <%
				}
				else
				{
					MySQLTable Card=new MySQLTable("select *from amca_member_card_apply where amca_id='"+AmcaID+"'");
					
					try
					{
						Card.Open();
						if (!Card.next())
						{
							%>
    <span>无对应的申请记录！</span>
    <%
						}
						else
					{
							 %>
    <div class="bs-example bs-example-form">
      <p class="bg-success" style="text-align: center; padding: 5px; background-color: #EEEEEE; border-radius: 3px; border: 1px solid #CCCCCC;">购卡信息确认</p>
      <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">开卡日期</span> <input type="text" value="<%=now2%>" id="CreateDate" class=" form-control form_datetime " onchange="CreateDateChange()"
          data-date-format="yyyy-mm-dd"
        >
      </div>
      <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">购买姓名</span> <input type="text" class="form-control" id="GuestName" placeholder="购买人姓名" aria-describedby="basic-addon1"
          value="<%=Card.getString("amca_GuestName")%>"
        >
      </div>
      <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">手机号码</span> <input type="text" class="form-control" id="GuestTel" placeholder="购买人手机号码" aria-describedby="basic-addon1"
          value="<%=Card.getString("amca_GuestTel")%>"
        >
      </div>
      <div class="container-fluid" style="font-size: 0px; margin-top: 5px; margin-bottom: 5px;">
        <%
				         MySQLTable RechargeAmount=new MySQLTable("select amcra_Count,amcra_Money,amcra_id_ac from amcra_member_card_recharge_amount where _status<>'D' and amcra_Flag=1  order by amcra_Count");
				         try
				         {
				           RechargeAmount.Open();
				           int i=1;
				           while (RechargeAmount.next())
				           {
				             %>
        <div style="display: inline-block; width: 50%; padding: 2px; font-size: 14px;" name="RechargeCount">
          <input type="radio" name="RechargeCount" id="RechargeCountRadio<%=i%>" Count="<%=RechargeAmount.getInt("amcra_Count") %>" Money="<%=RechargeAmount.getInt("amcra_Money") %>"
            acid="<%=RechargeAmount.getString("amcra_id_ac") %>" acname=""  value="<%=i%>"
          > <label for="RechargeCountRadio<%=i%>" class="btn btn-success">充值<%=RechargeAmount.getInt("amcra_Count")%>次<%=RechargeAmount.getInt("amcra_Money")%>元 <%
                        if (!RechargeAmount.getString("amcra_id_ac").equals(""))
                        {
                          %> <br>赠券：<span acid="<%=RechargeAmount.getString("amcra_id_ac") %>"></span> <%
                        }
                        else{
                          %> <br>&nbsp;<span>&nbsp;</span> <%
                        }
                        %>
          </label>
        </div>
        <%
				             i++;
				           }
				         }
				         finally
				         {
				           RechargeAmount.Close();
				         }
				
				         %>
      </div>
      <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">使用次数</span> <input type="Number" class="form-control" id="Count" placeholder="使用次数" aria-describedby="basic-addon1" value="0">
      </div>
      <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">充值金额</span> <input type="Number" class="form-control" id="Money" placeholder="充值金额" aria-describedby="basic-addon1" value="0">
      </div>
      <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">赠券信息</span> <input type="text" class="form-control" id="RechargeCoupons" placeholder="赠券信息" ariadescribedby="basic-addon1" readonly value="0">
      </div>
      <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">有效期限</span> <input type="text" value="<%=now%>" id="EndDate" class=" form-control form_datetime " readonly data-date-format="yyyy-mm-dd">
      </div>
      <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">会员号码</span> <input type="text" value="<%=Card.getString("amca_id_amb")%>" id="MemberID" class=" form-control" readonly>
      </div>
      <div class="input-group" style="width: 100%; padding-top: 20px;" id="ApplyBtn">
        <%
        if (Card.getString("_Status").equals("I"))
          {
            %>
        <a class="btn btn-danger" href="javascript:void(0);" onclick="CreateCard()" role="button" style="width: 100%">确认发卡</a>
        <%
        }
        else
          {
          %>
        <span style='color: blue; width: 100%; text-align: center'>已成功发卡！</span>
        <%									
        }
        %>
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
					          $('#EndDate').val('<%=now%>');  
					          $('#CreateDate').val('<%=now2%>');
            $("div[name=RechargeCount]").on('click', function() {
              //console.log($(this));
              $("#Count").val($("input[name=RechargeCount]:checked").attr("Count"));
              $("#Money").val($("input[name=RechargeCount]:checked").attr("Money"));
              var RechargeCoupons = $("input[name=RechargeCount]:checked").attr("acname");
              if (RechargeCoupons == '') {
                $("#RechargeCoupons").val("无赠券");
                $("#RechargeCoupons").attr("acid", "");
              } else {
                $("#RechargeCoupons").val(RechargeCoupons);
                $("#RechargeCoupons").attr("acid", $("input[name=RechargeCount]:checked").attr("acid"));
              }
            });

            $('span[acid]').each(function() {
              var acid = $(this).attr('acid');
              $(this).html(ac[acid]);
              $('input[acid=' + acid + ']').attr('acname', ac[acid]);
            });
          })
        </script>
    <script type="text/javascript">
							 			function CreateDateChange()
							 			{
							 				var CreateDate=$("#CreateDate").val();
							 				
							 				
							 			}
										function CreateCard()
										{
											GuestName=$("#GuestName").val();
											GuestTel=$("#GuestTel").val();
                      Count=$("#Count").val();
                      Money=$("#Money").val();
                      EndDate=$("#EndDate").val();
                      CreateDate=$("#CreateDate").val();
											MemberID=$("#MemberID").val();
						          var acid=$("#RechargeCoupons").attr("acid");
											
											if (GuestName=="")
											{
												alert("请输入【购买人姓名】！")
												return;
											}
											if (GuestTel=="")
											{
												alert("请输入【手机号码】！")
												return;
											}
                      if (Count=="")
                      {
                        alert("请输入【使用次数】！")
                        return;
                      }
                      if (Money=="")
                      {
                        alert("请输入【充值金额】！")
                        return;
                      }
											if (EndDate=="")
											{
												alert("请输入【有效期限】！")
												return;
											}
											//console.log("GuestName:"+GuestName);

											$("#loadingToast").show();
											$.post("<%=request.getContextPath() %>/card/MemberCardCreate",{"GuestTel":GuestTel,"GuestName":GuestName,"Count":Count,"Money":Money,"EndDate":EndDate,"CreateDate":CreateDate,"MemberID":MemberID,"ID":"<%=AmcaID%>","acid":acid},function(data){
											      console.log(data);

										    	  $("#loadingToast").hide();
											      if (data.MsgID==-1)
											      {
											  		alert(data.MsgTest);
											      }
											      else
											      {
											    	  $("#ApplyBtn").html("<span style='color:blue;width:100%;text-align: center'>已成功发卡！</span>");
											      }
											  },"json");
										}

										function CreateDateChange()
										{
											var CreateDate=$("#CreateDate").val();
											var sTime=new Date(CreateDate).getTime()+1000*60*60*24*365;
											$("#EndDate").val(new Date(sTime).Format('yyyy-MM-dd'));
										} 
								</script>
    <%
						}
					}
					finally
					{
						Card.Close();
					}
					
					    
				}
			%>
  </div>
  <div id="loadingToast" style="display: none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
      <i class="weui-loading weui-icon_toast"></i>
      <p class="weui-toast__content">操作中</p>
    </div>
  </div>
  <jsp:include page="/res/temple/TabbarMenuEnd.jsp" />
  <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>