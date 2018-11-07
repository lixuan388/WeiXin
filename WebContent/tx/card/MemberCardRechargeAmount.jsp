<%@page import="com.java.web.weixin.tx.card.MemberCardFunction"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.TMemberInfo"%>
<%@ page import="org.apache.catalina.Session"%>
<%@ page import="com.java.sql.table.MySQLTable"%>
<%
  response.setHeader("Pragma", "No-cache");
  response.setHeader("Cache-Control", "no-cache");
  response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/head.jsp" />
<style type="text/css">
.page, body {
  background-color: #f8f8f8;
}

.font1 {
  font-size: 12px;
}

thead, tr {
  text-align: center;
}

[DataID] {
  width: 100%;
  margin-bottom: 10px;
}

[DataID]>div {
  display: inline-block;
}

[FieldName=Count] {
  width: 30px;
}

[FieldName=Money] {
  width: 40px;
}

[Flag='0']{
  display:none;
}
</style>
</head>
<body>
  <jsp:include page="/res/temple/TabbarMenuBegin.jsp" />
  <div class="container" id="container">
    <div class="weui-cells__title">
      <p>次卡充值设置</p>
    </div>
    <div class="list">
      <%
        MySQLTable RechargeAmount = new MySQLTable(
      					"select * from amcra_member_card_recharge_amount where _status<>'D' order by amcra_Count,amcra_money");
      			try {
      				RechargeAmount.Open();
      				while (RechargeAmount.next()) {
      %>
      <div DataID="<%=RechargeAmount.getString("amcra_id")%>" Flag="<%=RechargeAmount.getInt("amcra_flag")%>">
        <div>
          <span>次数：</span><input type="number" FieldName="Count" value="<%=RechargeAmount.getInt("amcra_Count")%>">
        </div>
        <div>
          <span>金额：</span><input type="number" FieldName="Money" value="<%=RechargeAmount.getInt("amcra_Money")%>">
        </div>
        <div style="width: calc(100% - 206px)">
          <span>赠券：</span><select style="width: calc(100% - 42px);" FieldName="Coupons" value="<%=RechargeAmount.getString("amcra_id_ac")%>"></select>
        </div>
        <div>
          <a class="btn btn-info btn-xs" style="width: 30px; margin-left: 10px;" href="javascript:void(0)" onclick="DelRow(this)">删</a>
        </div>
      </div>
      <%
        }
      			} finally {
      				RechargeAmount.Close();
      			}
      %>
    </div>
    <div class="text-center">
      <a class="btn btn-info " style="margin-right: 10px; width: 100px;" href="javascript:void(0)" onclick="AddRow()">新增</a> <a class="btn btn-success " style="margin-left: 10px; width: 100px;"
        href="javascript:void(0)" onclick="SaveTable()">保存</a>
    </div>
  </div>
  <script type="text/javascript">
  var ac=<% MemberCardFunction.GetCouponsListJson(pageContext);%>;

function InitSelect(select){
  select.each(function(){
    $(this).html('');
    var value=$(this).attr('value');
    $(this).append('<option value="" >不赠券</option>');
    for (item in ac){
      $(this).append('<option value="'+ac[item].id+'">'+ac[item].shtname+'</option>');
    }
    console.log(value);
    $(this).val(value);
  })
}

function AddRow()
{
  var id=new Date().getTime();
  select ='<select class="select'+id+'" style="width: calc(100% - 42px);" FieldName="Coupons" value=""></select>';
  
  var child='<div DataID="-1" Flag="1"><div><span>次数：</span><input type="number" FieldName="Count" value="0"></div>\n'+
      '<div><span>金额：</span><input type="number" FieldName="Money" value="0"></div>\n'+
      '<div style="width: calc(100% - 206px)"><span>赠券：</span>'+select+'</div>\n'+
      '<div><a class="btn btn-info btn-xs" style="width: 30px; margin-left: 10px;" href="javascript:void(0)" onclick="DelRow(this)">删</a></div></div>\n';
      
  $(".list").append(child); 
  InitSelect($('.select'+id));
}

function DelRow(that)
{
  var div=$(that).parent().parent();
  //console.log($(div));
  $(div).attr('Flag','0');
}
function SaveTable()
{
	var Data={"DataRows":[]};
	$(".list [DataID]").each(function(index){
		console.log(index);
		var FieldData={};
    FieldData.ID=$(this).attr("DataID");
    FieldData.Flag=$(this).attr("Flag");
    FieldData.Count=$(this).find("[FieldName=Count]").val();
    FieldData.Money=$(this).find("[FieldName=Money]").val();
    FieldData.Coupons=$(this).find("[FieldName=Coupons]").val();
    Data.DataRows[index]=FieldData;
	})
  console.log(Data);
  //return;
  $.post("<%=request.getContextPath()%>/card/MemberCardRechargeAmountPost.json",JSON.stringify(Data),function(data){
      console.log(data);

      if (data.MsgID!=1)
      {
        alert(data.MsgTest);
      }
      else
      {
        weui.alert('信息修改成功！',function(){
          window.location.reload();
        });
      }
  },"json");
}

InitSelect($('select'));
</script>
  <div id="loadingToast" style="display: none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
      <i class="weui-loading weui-icon_toast"></i>
      <p class="weui-toast__content">操作中</p>
    </div>
  </div>
  <jsp:include page="/res/temple/TabbarMenuEnd.jsp" />
</body>
</html>