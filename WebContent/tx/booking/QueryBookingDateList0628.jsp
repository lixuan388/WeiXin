<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.base.GlobalVariable"%>
<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  
		
	if (!GlobalVariable.CheckIfNoLoginToLogin(request, response,"2001"))
	{
		return;
	}
	if (!GlobalVariable.CheckIsManager(request, response))
	{
		return;
	}
	
    SimpleDateFormat formatter; 
    formatter = new SimpleDateFormat ("yyyy-MM-dd");
    String date =formatter.format(new Date());  
    
    
%>
<!DOCTYPE html >
<html class="ecity">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/head.jsp" />
<link type="text/css" rel="stylesheet" href="<%=request.getContextPath() %>/res/css/em.css?2019062901">
<style type="text/css">

.Name-btn span {
    font-size: 1.5rem;
}


.weui-form-preview__btn_primary {
  background-color: #efeff4;
}

.restdate {
  background-color: #ececec;;
}

.restdate>.weui-cell__ft {
  color: black;
}

.t0, .t1, .t2, .t3 {
  display: inline-block;
}

.DateList_hour {
  font-size: 0.7142rem;
}

#DateList>tbody>tr>td .btn {
    font-size: 0.7142rem;
    margin: 0.1428rem;
    line-height: inherit;
    overflow: hidden;
    color: #fff;
    width: 4.9rem;
    padding: 0.5rem 0;
}

#DateList>tbody>tr>.m2 {
  background-color: #EDFFED;;
  text-align: left;
}

#DateList>tbody>tr>.m0 {
  background-color: #D3FFD3;
  text-align: left;
  width: 20%;
}

#DateList>tbody>tr>.m1 {
  background-color: #E7F4FF;
  text-align: left;
  width: 20%;
}

#DateList>thead>tr>td {
  padding: 0px;
  text-align: center;
}

#DateList>tbody>tr>td {
  padding: 0px;
  text-align: center;
}

#DateList .DateList_hour {
  font-size: 1rem;
  width: calc(20vw - 1.6174rem);
}

.striped div:nth-of-type(odd) {
  /*奇数行*/
  background-color: #f8f8f8;
}

.weui-form-preview__value span {
  font-style: normal;
  font-size: 1rem;
}

#CheckInBtn>.btn {
  margin: 0.1428rem;
  margin-left: auto;
}

[data-checkin="1"] {
  background-color: #46DA7D;
  color: #FFFFFF;
}

[data-checkin="0"] {
  background-color: #5bc0de;
  color: #FFFFFF;
}

[data-checkin="2"] {
  background-color: #000;
  color: #FFFFFF;
}

[data-checkin="3"] {
  background-color: #C3C3C3;
  color: #000;
}

[data-checkin="4"] {
  background-color: #EF0000;
  color: #FFFFFF;
}

[data-checkin].focus, [data-checkin]:focus, [data-checkin]:hover {
  color: inherit;
  text-decoration: none;
}

.weui-form-preview__item {
    margin-bottom: 0.5rem;
}
.weui-form-preview__item label{
margin-bottom: 0;
}
</style>
</head>
<body class="ecity">
  <jsp:include page="/res/temple/TabbarMenuBegin.jsp" />
  <div class="weui-cells__title">
    <p>预约情况</p>
  </div>
  <div class="weui-cells">
    <div class="weui-cell" style="padding-top: 1rem; line-height: 2rem; height: 3.5rem;">
      <%
                Date now=new Date();
                SimpleDateFormat formatter1 = new SimpleDateFormat ("dd");

                SimpleDateFormat formatter2 = new SimpleDateFormat ("yyyy-MM-dd");
        
                for (int i =0;i<8;i++)
                {   
                    %>
      <div style="position: relative;" id="Day<%=i%>">
        <a href="javascript:void(0);" onclick="LoadBookingData('<%=formatter2.format(now)%>');" class="weui-btn weui-btn_primary"
          style="line-height: 1rem; padding: 0.2rem; width: 2rem; margin-top: 0px; margin-right: 0.071rem; margin-left: 0.35rem;"
        > <span><%=formatter1.format(now)%></span>
        </a> <span class="weui-badge" style="position: absolute; top: -1.0rem; right: -0.5rem; z-index: 9; display: inherit;">0</span>
      </div>
      <%
                    now.setTime(now.getTime()+1000*60*60*24);       
                }
            %>
    </div>
  </div>
  <div class="weui-cells">
    <center id="dateName"><%=date%></center>
    <div class="weui-cell" style="">
      <table id="DateList" class="table">
        <thead>
          <tr>
            <td></td>
            <td colspan="2">
              <div style="position: relative; width: 100px; padding-top: 0.5em; margin-left: auto; margin-right: auto;">
                <span>美容</span> <span class="weui-badge Count1" style="position: absolute; top: -0.1em; right: -0.5em; z-index: 9; display: inherit;">0</span>
              </div>
            </td>
            <td colspan="2">
              <div style="position: relative; padding-top: 0.5em;">
                <span>黄医生</span> <span class="weui-badge Count2" style="position: absolute; top: -0.1em; right: -0.5em; z-index: 9; display: inherit;">0</span>
              </div>
            </td>
          </tr>
        </thead>
        <tbody>
        </tbody>
      </table>
    </div>
    <div class="weui-cell" style="padding-top: 20px;">
      <div class="input-group font1 text-center" style="line-height: 20px; padding: 2px 30px; margin-top: 0px; margin-bottom: 20px; width: 100%;">
        <a class="btn  btn-warning" href="javascript:void(0);" ambID="0" GuestName="" GuestTel="" role="button" onclick="ShowManualEntry(this)" style="width: 100%">手工排队</a>
      </div>
    </div>
  </div>
  <div id="toast" style="display: none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
      <i class="weui-icon-success-no-circle weui-icon_toast"></i>
      <p class="weui-toast__content">已完成</p>
    </div>
  </div>
  <div id="loadingToast" style="display: none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
      <i class="weui-loading weui-icon_toast"></i>
      <p class="weui-toast__content">查询中</p>
    </div>
  </div>
  <jsp:include page="/res/temple/TabbarMenuEnd.jsp" />
  <script type="text/javascript">     
$(function () {
	  LoadDayCount();
	  LoadBookingData('<%=date%>');
	});
	function LoadDayCount()
	{
	  $.ajax({
	    url: '<%=request.getContextPath()%>/booking/GetBookingCountByDay.json?d=' + new Date().Format('yyyymmddhhnnss'),
	    type: 'get',
	    dataType: 'Json',
	    success: function (data) {
	      if (data.MsgID == - 1)
	      {
	        alert(data.MsgTest);
	      } 
	      else
	      {
	        for (i = 0; i < 8; i++)
	        {
	          $('#Day' + i + '>.weui-badge').html(data['Day' + i]);
	          if (data['Day' + i] > 0)
	          {
	            $('#Day' + i + '>.weui-badge').css('display', 'inherit')
	          } 
	          else
	          {
	            $('#Day' + i + '>.weui-badge').css('display', 'none')
	          }
	        }
	      }
	    }
	  });
	}
	function LoadBookingData(date)
	{
	  $('#loadingToast').show();
	  $.ajax({
	    url: '<%=request.getContextPath()%>/booking/GetBookingDateTimeList.json?Date='+date+'&d=' + new Date().Format('yyyymmddhhnnss'),
	    type: 'get',
	    dataType: 'Json',
	    success: function (data) {
	      if (data.MsgID == - 1)
	      {
	        alert(data.MsgTest);
	      }
	      $("#dateName").html(date);
	      //console.log(data);
	      var Count1=0;
	      var Count2=0;
	      $('#DateList>tbody').html('');
	      for (i = 0; i < data.DateList.length; i++)
	      {
	        var hour = data.DateList[i].Hour;
	        var td='<div class="t1" id="t1"></div><div class="t0" id="t0"></div><div class="t2" id="t2"></div><div class="t3" id="t3"></div>'
	        var tr;
	        if (data.DateList[i].Amp!=0)
	        {
		        if ($('#DateList>tbody>#' + hour).length > 0)
		        {
		          tr = $('#DateList>tbody>#' + hour);
		        } 
		        else
		        {
		          var tr = $('<tr id="' + hour + '"><td class="DateList_hour">' + hour + '</td><td class="m2">'+td+'</td><td class="m0">'+td+'</td><td class="m1">'+td+'</td></tr>')
		          $('#DateList>tbody').append(tr)
		        }
	        }
	        Guest = $('<a class="btn  btn-xs Name-btn" href="javascript:void(0);" onclick="CreateCard(this)" role="button"><span>' + data.DateList[i].GuestName + '</span></a>')
            Guest.attr('data-ID', data.DateList[i].ID);           
	        Guest.attr('data-Checkin', data.DateList[i].CheckIn);
	        Guest.attr('data-Amp', data.DateList[i].Amp);
	        Guest.attr('data-Tr', hour);
	        Guest.attr('data-GuestName', data.DateList[i].GuestName);
	        Guest.attr('data-GuestTel', data.DateList[i].GuestTel);
	        Guest.attr('data-Hour', data.DateList[i].Hour);
	        Guest.attr('data-BookingTime', data.DateList[i].BookingTime);
	        Guest.attr('data-MedicalProject', data.DateList[i].MedicalProject);
	        Guest.attr('data-StatusType', data.DateList[i].StatusType);
	        Guest.attr('data-money', data.DateList[i].money);
	        Guest.attr('data-UrlCode', data.DateList[i].UrlCode);
	        Guest.attr('data-paydate', data.DateList[i].paydate);
            Guest.attr('data-CheckInDate', data.DateList[i].CheckInDate);
            Guest.attr('data-AmbID', data.DateList[i].AmbID);
            if (data.DateList[i].Amp==1)
            {
            	Count2++;
            }
            else
            {
            	Count1++;
            }
	        SetGuestToTable(Guest)
	      }
	      $("td.m0:first").attr("rowspan",$("td.m0").length)
	      while ($("td.m0").length>1)
	      {
	    	  $($("td.m0")[1]).remove();
	      }
	      

	      if (Count1>0)
	      {
	    	  $('.Count1').css('display', 'inherit');
	    	  $('.Count1').html(Count1);
	      }
	      else
	      {
              $('.Count1').css('display', 'none');
	      }
	      
	         if (Count2>0)
	          {
	              $('.Count2').css('display', 'inherit');
	              $('.Count2').html(Count2);
	          }
	          else
	          {
	              $('.Count2').css('display', 'none');
	          }         
	      $('#loadingToast').hide();
	      
	    }
	  });
	}
	function SetGuestToTable(g)
	{
	  //console.log(g);
	  var Amp = g.attr('data-Amp');
	  var CheckIn = g.attr('data-Checkin');
	  var tr = $('#' + g.attr('data-Tr'));
	  var c = ''
	  c='.t'+CheckIn;
	  if ((CheckIn == 4)||(CheckIn==1 )|| (CheckIn==2))
	  {
	      c='.t1';
	  }
	  else
	  {
	    c='.t0';
	  }
	  var NewParent
	  if (Amp==0)
	  {
	    NewParent=$("td.m0:first").find(c)
	  }
	  else
	  {
	    NewParent=tr.find(".m"+Amp).find(c)
	  }
    console.log("NewParent:");
    console.log(NewParent.attr("id"));
    console.log("OldParent:");
    console.log(g.parent().attr("id"));
    console.log(NewParent.attr("id")==g.parent().attr("id"));
    
	  
	  if (NewParent.attr("id")!=g.parent().attr("id"))
	  {
	    NewParent.append(g);
	  }
	    
	  
	}
	function CreateCard(t)
	{
	  $('#GuestInfoModal .GuestName').html($(t).attr('data-GuestName'))
	  $('#GuestInfoModal .GuestTel').html($(t).attr('data-GuestTel'))
	  $('#GuestInfoModal .BookingTime').html($(t).attr('data-BookingTime'))
	  $('#GuestInfoModal .MedicalProject').html($(t).attr('data-MedicalProject'))
	  $('#GuestInfoModal .StatusType').html($(t).attr('data-StatusType'))
	  $('#GuestInfoModal .Money').html($(t).attr('data-money'))
	  $('#GuestInfoModal .UrlCode').html($(t).attr('data-UrlCode'))
	  $('#GuestInfoModal .PayDate').html($(t).attr('data-paydate'))
    $('#GuestInfoModal .CheckInDate').html($(t).attr('data-CheckInDate'))
    
    $('#GuestInfoModal .ManualEntryBooking').attr("AmbID",$(t).attr('data-AmbID'));
    $('#GuestInfoModal .ManualEntryBooking').attr("GuestName",$(t).attr('data-GuestName'));
    $('#GuestInfoModal .ManualEntryBooking').attr("GuestTel",$(t).attr('data-GuestTel'));
	  
	  
      var CheckIn = $(t).attr('data-CheckIn') * 1;
      var Amp = $(t).attr('data-Amp') * 1;
      var AmbID=$(t).attr('data-AmbID');
      var ID = $(t).attr('data-ID');
	  $('#GuestInfoModal .CheckIn').attr('data-CheckIn',$(t).attr('data-CheckIn')); 
	  //console.log(CheckIn);
	  switch (CheckIn)
	    {
	    case 0:
	      $('#GuestInfoModal .CheckIn').html('未到')
	      break;
	    case 1:
	    	if (Amp==2)
	    	//{
                $('#GuestInfoModal .CheckIn').html('已扣')    
	    	//      
	    	//}
	    	//else
	    	//{
        //        $('#GuestInfoModal .CheckIn').html('已到');
	    	//}
	      
	      break;
	    case 2:
	      $('#GuestInfoModal .CheckIn').html('已叫')
	      break;
	    case 3:
	      $('#GuestInfoModal .CheckIn').html('爽约')
	      break;
	    case 4:
	      $('#GuestInfoModal .CheckIn').html('未扣')
	      break;
	    default:
	  }
      //if (Amp==2)
      //{
          $('#GuestInfoModal #CheckInBtn>[data-checkin=1]').html('已扣');
      //}
     // else
      //{
      //    $('#GuestInfoModal #CheckInBtn>[data-checkin=1]').html('已到');
      //}
      

      if (Amp==0)
      {
        $("#GoToChangeDate").hide();
          
      }
      else
      {
          $("#GoToChangeDate").show();
      }
      if (Amp==1)
      {
          $(".ManualEntryBookingDiv").show();
      }
      else
      {
          $(".ManualEntryBookingDiv").hide();
      }
      if (AmbID=="0")
      {
          $("#GoToMemberCardEdit").hide();
      }
      else
      {
          $("#GoToMemberCardEdit").show();
      }
      
      $('#GuestInfoModal #GoToMemberCardEdit').attr('href','<%=request.getContextPath()%>/tx/card/MemberCardEdit3.jsp?ID='+ID+'&d=' + new Date().Format('yyyymmddhhnnss'));
	  $('#GuestInfoModal').data('Info', t);
	  
	  $('#GuestInfoModal').modal('show');
	}
	function ChangeType(t)
	{

	  $('#loadingToast').show();
	  var CheckIn = $(t).attr('data-CheckIn') * 1;

      
	  var Guest = $('#GuestInfoModal').data('Info');
	  //console.log(Guest);
	  var ID=$(Guest).attr("data-ID");

    var Amp = $(Guest).attr('data-Amp') * 1;
	  switch (CheckIn)
    {
	    case 0:
	    case 2:
	    case 3:
      case 4:
          $.post("<%=request.getContextPath() %>/booking/BookingDateChangeType.json",{"ID":ID,"CheckIn":CheckIn},function(data){
                //console.log(data);

                $("#loadingToast").hide();
                if (data.MsgID==-1)
                {
                  alert(data.MsgText);
                }
                else
                {
                    $(Guest).attr('data-Checkin', data.CheckIn);
                    //$(Guest).attr('data-CheckInDate', data.CheckInDate);
                    SetGuestToTable($(Guest));
                    $('#GuestInfoModal').modal('hide');
                    alert("操作成功！");
                }
            },"json");
            
          break;
        case 10://直接改已扣，不需扣次数
            $.post("<%=request.getContextPath() %>/booking/BookingDateChangeType.json",{"ID":ID,"CheckIn":1},function(data){
                  //console.log(data);

                  $("#loadingToast").hide();
                  if (data.MsgID==-1)
                  {
                    alert(data.MsgText);
                  }
                  else
                  {
                      $(Guest).attr('data-Checkin', data.CheckIn);
                      $(Guest).attr('data-CheckInDate', data.CheckInDate);
                      SetGuestToTable($(Guest));
                      $('#GuestInfoModal').modal('hide');
                      alert("操作成功！");
                  }
              },"json");
            
          break;
	    case 1:
	    	if (Amp==2)
	    	{
                $.ajax({
                    url: '<%=request.getContextPath()%>/tx/booking/MemberCardEdit2.jsp?ID='+ID+'&d=' + new Date().Format('yyyymmddhhnnss'),
                    type: 'get',
                    dataType: 'html',
                    success: function (data) {
                      var html=data

                      $('#CardUseModal .modal-body').html("");CardUseModal
                      $('#loadingToast').hide();
                      $('#CardUseModal .modal-body').html(html);
                      $('#CardUseModal').modal("show");
                    }
                  });      
	    	}
	    	else
	    	{
                $.post("<%=request.getContextPath() %>/booking/BookingDateChangeType.json",{"ID":ID,"CheckIn":CheckIn},function(data){
                    //console.log(data);

                    $("#loadingToast").hide();
                    if (data.MsgID==-1)
                    {
                      alert(data.MsgText);
                    }
                    else
                    {
                        $(Guest).attr('data-Checkin', data.CheckIn);
                        $(Guest).attr('data-CheckInDate', data.CheckInDate);
                        SetGuestToTable($(Guest));
                        $('#GuestInfoModal').modal('hide');
                        alert("操作成功！");
                    }
                },"json");
	    	}
	    default:
	  }
	}
    function DoChangeDate()
    {
        $('#loadingToast').show();
        var Guest = $('#GuestInfoModal').data('Info');
        var Amp = $(Guest).attr('data-Amp');
        $.ajax({
            url: '<%=request.getContextPath()%>/tx/booking/ChangeBookingDate.jsp?UrlCode='+$(Guest).attr('data-UrlCode')+'&MP='+Amp+'&Date='+$(Guest).attr('data-BookingTime')+'&d=' + new Date().Format('yyyymmddhhnnss'),
            type: 'get',
            dataType: 'html',
            success: function (data) {
              $("body").append(data);
              $("#ChangeDateModal").modal("show")
              $('#loadingToast').hide();
              //alert(html);
            }
          });     
    }
    function ShowManualEntry(t)
    {
      
        $("#ManualEntryGuestName").val($(t).attr("GuestName"));
        $("#ManualEntryGuestTel").val($(t).attr("GuestTel"));
        $("#ManualEntryAmbID").val($(t).attr("AmbID"));
        $('#ManualEntryModal').modal('show');
    }
    function ManualEntryConfirm()
    {
        $("#ManualEntryModal").modal("hide");

        AmbID=$("#ManualEntryAmbID").val();
        GuestName=$("#ManualEntryGuestName").val();
        GuestTel=$("#ManualEntryGuestTel").val();
        BookingTimeID=0;        
        $("#loadingToast").show();
        $.post("<%=request.getContextPath() %>/booking/BookingDateManualEntry.json",{"AmbID":AmbID,"GuestName":GuestName,"GuestTel":GuestTel,"AbdID":BookingTimeID,"CheckIn":"4"},function(data){
              //console.log(data);

              $("#loadingToast").hide();
              if (data.MsgID==-1)
              {
                  alert(data.MsgText);
              }
              else
              {    
                  alert("排队成功！")
                  window.location.href='<%=request.getContextPath() %>/tx/booking/QueryBookingDateList0628.jsp?d=' + new Date().Format('yyyymmddhhnnss')
              }
          },"json");
    }
</script>
  <div class="modal" id="GuestInfoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <!--  <div class="modal-dialog" role="document" style="max-width: 360px;margin-left: auto;margin-right: auto;margin-top: 100px;">-->
    <div class="modal-dialog" role="document" style="width: calc(100vw - 4rem); margin: 2rem;">
      <div class="modal-content">
        <div class="modal-body" style="min-height: 50px">
          <h>
          <center>预约信息</center>
          </h>
          <div class="weui-form-preview QueryDetil" style="" id="QueryDetil">
            <div class="weui-form-preview__hd striped">
              <div class="weui-form-preview__item">
                <label class="weui-form-preview__label">预约人姓名</label> <em class="weui-form-preview__value"><span class="GuestName"></span></em>
              </div>
              <div class="weui-form-preview__item">
                <label class="weui-form-preview__label">预约人手机</label> <em class="weui-form-preview__value"><span class="GuestTel"></span></em>
              </div>
              <div class="weui-form-preview__item">
                <label class="weui-form-preview__label">挂号项目</label> <em class="weui-form-preview__value"><span class="MedicalProject"></span></em>
              </div>
              <div class="weui-form-preview__item">
                <label class="weui-form-preview__label">预约时间</label> <em class="weui-form-preview__value"><span class="BookingTime"></span></em>
              </div>
              <div class="weui-form-preview__item">
                <label class="weui-form-preview__label">状态</label> <em class="weui-form-preview__value"><span class="CheckIn" style="width: 100%; display: inline-block;"></span></em>
              </div>
              <div id="CheckInDate" class="weui-form-preview__item">
                <label class="weui-form-preview__label">时间</label> <em class="weui-form-preview__value"><span class="CheckInDate"></span></em>
              </div>
            </div>
            <!-- 
            <div class="weui-form-preview__hd striped">
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">付款单号</label>
                    <em class="weui-form-preview__value" style="font-size: 16px"><span class="UrlCode"></span></em>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">付款金额</label>
                    <em class="weui-form-preview__value"><span>¥</span><span class="Money"></span></em>
                </div>
                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">付款状态</label>
                    <em class="weui-form-preview__value " style="font-size: 16px;"><span class="StatusType"></span></em>
                </div>

                <div class="weui-form-preview__item">
                    <label class="weui-form-preview__label">付款时间</label>
                    <em class="weui-form-preview__value" style="font-size: 16px;"><span class="PayDate"></span></em>
                </div>
            </div>
             -->
            <div id='CheckInBtn' class="weui-form-preview__ft" style="line-height: 30px; font-size: 14px; padding: 5px;">
              <a class="btn  " href="javascript:void(0);" onclick="ChangeType(this)" data-checkin=0 role="button">未到</a> <a class="btn  " href="javascript:void(0);" onclick="ChangeType(this)"
                data-checkin=1 role="button"
              >已扣</a> <a class="btn  " href="javascript:void(0);" onclick="ChangeType(this)" data-checkin=2 role="button">已叫</a> <a class="btn  " href="javascript:void(0);" onclick="ChangeType(this)"
                data-checkin=3 role="button"
              >爽约</a> <a class="btn  " href="javascript:void(0);" onclick="ChangeType(this)" data-checkin=4 role="button">未扣</a>
            </div>
            <div id='CheckInBtn2' class="weui-form-preview__ft" style="line-height: 30px; font-size: 14px; padding: 5px;">
              <a style="margin-left: auto; margin-right: auto;" id="GoToMemberCardEdit" class="btn btn-warning" href="" role="button">跳转至次卡管理页面</a> <a
                style="margin-left: auto; margin-right: auto; width: 100px;" id="GoToChangeDate" class="btn btn-warning" href="javascript:void(0);" onclick="DoChangeDate()" role="button"
              >改期</a>
            </div>
            <div class="input-group font1 text-center ManualEntryBookingDiv" style="line-height: 20px; padding: 2px 30px; margin-top: 0px; margin-bottom: 20px; width: 100%;">
              <a class="btn  btn-warning ManualEntryBooking" href="javascript:void(0);" ambID="0" role="button" onclick="ShowManualEntry(this)" style="width: 100%">手工排队</a>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="padding: 5px;">
          <button type="button" class="btn btn-default" data-dismiss="modal">确定</button>
        </div>
      </div>
    </div>
  </div>
  <div class="modal" id="ManualEntryModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document" style="max-width: 360px; margin-left: auto; margin-right: auto; margin-top: 100px;">
      <div class="modal-content">
        <div class="modal-body" style="min-height: 50px">
          <h>
          <center>手工排队</center>
          </h>
          <div class="bs-example bs-example-form">
            <div class="input-group">
              <span class="input-group-addon" id="basic-addon1">姓名</span> <input type="text" class="form-control" id="ManualEntryGuestName" placeholder="姓名" aria-describedby="basic-addon1" value="">
            </div>
            <div class="input-group">
              <span class="input-group-addon" id="basic-addon1">电话</span> <input type="text" class="form-control" id="ManualEntryGuestTel" placeholder="电话" aria-describedby="basic-addon1" value="">
            </div>
            <input type="hidden" class="form-control" id="ManualEntryAmbID" placeholder="电话" aria-describedby="basic-addon1" value="">
          </div>
        </div>
        <div class="modal-footer" style="padding: 5px;">
          <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
          <button type="button" class="btn btn-danger" onclick="ManualEntryConfirm()">确认手工排队</button>
        </div>
      </div>
    </div>
  </div>
  <div class="modal" id="CardUseModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document" style="max-width: 100%; width: inherit;margin-left: auto; margin-right: auto; margin-top: 0;height: calc(100vh - 2.98rem);">
      <div class="modal-content">
        <div class="modal-body" style="min-height: 50px"></div>
        <div class="modal-footer" style="padding: 5px;">
          <button type="button" class="btn btn-danger" onclick="ChangeType(this)" data-checkin=10 data-dismiss="modal">直接【已扣】</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
        </div>
      </div>
    </div>
  </div>
</body>
</html>