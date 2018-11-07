<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.sql.table.MySQLTable" %>


<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  
	String AbdpID =request.getParameter("ID")==null?"":(String)request.getParameter("ID");
%>

<%
String groupid=request.getSession().getAttribute("groupid")==null?"":(String)request.getSession().getAttribute("groupid");
if (!groupid.equals("100")&&  !groupid.equals("101") )
{
%>		
	<div ><p>无权操作</p></div>
<%
}
else
{

MySQLTable Card=new MySQLTable("select amc_id,amc_GuestName,amc_GuestTel,amc_CreateDate,amc_Count,amc_Money,amc_EndDate,amc_id_amb from amc_member_card,abdp_bookingdatetime_pay  where amc_id_amb=abdp_id_amb and  abdp_id='"+AbdpID+"'");

try
{
  Card.Open();
  if (!Card.next())
  {
	  %>
	  <div ><p>无次卡记录</p></div>
	  <%
  }
  else
  {
	java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");
	String CreateDate=format.format(Card.getDateTime("amc_CreateDate"));
	String EndDate=format.format(Card.getDateTime("amc_EndDate"));
	
	
	java.util.Date ss = new java.util.Date();  
	java.util.Calendar rightNow = java.util.Calendar.getInstance();
	rightNow.setTime(ss);
	rightNow.add(java.util.Calendar.YEAR,1);//日期减1年
	String NewRechargeDate=format.format(rightNow.getTime());
	  

	java.util.Date today = new java.util.Date();  
		    
    request.getSession().setAttribute("CountAmcID",  Card.getString("amc_id"));
    request.getSession().setAttribute("CountMemberID", Card.getString("amc_id_amb"));
    

    String AmcID=Card.getString("amc_id");
    String amc_id_amb=Card.getString("amc_id_amb");
    %>
<style type="text/css">
    .page, body {
        background-color: #f8f8f8;
       }
    .input-group+.input-group
    {
        margin-top: 0.7142rem;
    }
    
      .input-group
    {
      width:100%
    }
    thead,tr
    {
      text-align: center;
    }
    .nav>li
    {
      width: 25%;
      text-align: center;
    }
    .row >div> a
    {
      width:100%;
    }
    /*
    .row  a:hover
    {
      width:100%;
      background-color: red;
    }
    */
    
    .row >div>.SelectCount
    {
      background-color: red;
    }
    .row 
    {
      width:100%;    
      margin-top: 1.4285rem;
      margin-left: 0px;
      margin-right: 0px;
    }
    .row>div
    {
      height:100%;
      padding-right:0.07142rem;
      padding-left:0.07142rem;
    }
    [type=radio]+label
    {
      display: block;
    }
    [name=UseCount][type=radio]:checked+label
    {
      background-color: red;
    }
    [name=RechargeCount][type=radio]:checked+label
    {
      background-color: blue;
    }
    [type=radio]
    {
      display: none;
    }
    .cancelDiv{
        display:none;
        width: 0;
        line-height:0px;
        margin-left: auto;
        margin-right: auto;
    }
    a.cancelDiv{
        padding: 0px;
        font-size: 0.8571rem;
        margin-top:  0.7142rem;
    }
    .HistoryTale>tbody>tr:hover>td>.cancelDiv {
        display:inline-block;
        line-height:1rem;
        width: 100%;
    }
    .HistoryTale>tbody>tr.D {
        background-color: #ec971f;
    }
    
    .weui-mask, .weui-mask_transparent {
        z-index: 1050;
    }


    </style>
        
<div class="container" >
  <div class="input-group font1 text-center">
    <span >姓名：</span><span style="color:blue" id="CardGuestName"><%=Card.getString("amc_GuestName")%></span>/ <span>手机：</span><span style="color:blue" id ="CardGuestTel"><%=Card.getString("amc_GuestTel")%></span>
  </div>
  <div class="input-group font1 text-center">
    <span >开卡日期：</span><span style="color:blue"><%=CreateDate%></span>/ <span>有效期：</span><span style="color:blue"  id="CardEndDate"><%=EndDate%></span>
  </div>
	<div class="input-group font1 text-center" style="line-height: 20px;padding: 2px;">
	  <span>剩余消费次数：</span><span style="color:red;font-size:20px" id="CardCount"><%=Card.getString("amc_Count")%></span>
	</div>
</div>
<%
if (today.after(Card.getDateTime("amc_EndDate")))
{
	%>
	<div class="alert alert-danger" role="alert">此卡已过期！</div>
	
	  <!-- 已过期确认 -->
      <div class="modal" id="TimeOutConfirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" >
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h4 class="modal-title" id="myModalLabel">过期确认</h4>
            </div>
            <div class="modal-body">
              <span>此卡已过有效期，请注意！</span>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-default" onclick="CloseTimeOutConfirm()">确定</button>
            </div>            
          </div>
        </div>
      </div>
      <script type="text/javascript">        
      $(function(){
          $("#TimeOutConfirm").modal("show");
          

      });             
      function CloseTimeOutConfirm()
      {
          $("#TimeOutConfirm").modal("hide");
      } 
      </script>
	<%
}
%>
  

	

    <!-- 消费 -->
      <div class="container-fluid" id="SelectCountBtn" style="background-color: rgb(117, 255, 117);height: 100%;">
        <div class="input-group font1 text-center" style="line-height: 20px;padding: 2px;margin-top: 10px">
          <span>最近充值金额：<%=Card.getInt("amc_Money") %></span>
        </div>
        <div class="input-group font1 text-center" style="line-height: 20px;padding: 2px;margin-top: 10px">
          <span>选择消费次数</span>
        </div>
			  
			  <div class="container-fluid" style="font-size: 0px;margin-top: 20px;" >
			   <%
			   for (int i=1;i<=10;i++)
			   {
				   %>
				   <div style="display: inline-block; width:20%;padding: 2px;font-size: 14px;" >
				    <input type="radio" name="UseCount"  id ="UseCountRadio<%=i%>" value="<%=i%>">
				    <label for="UseCountRadio<%=i%>" class="btn btn-success" ><%=i%></label>
				   </div>
				   <%
			   }
			   %>
			  </div>

        
        <div class="input-group font1 text-center" style="line-height: 20px;padding: 2px 30px;margin-top: 30px">
          <a class="btn  btn-default" href="javascript:void(0);"  role="button" onclick="SaveUse()" 
            id="SaveUseBtn" style="width:100%" disabled="disabled" >请选择消费次数</a>
        </div>
      </div>
      <!-- 消费次数确认 -->
			<div class="modal" id="CountConfirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
			  <div class="modal-dialog" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        <h4 class="modal-title" id="myModalLabel">消费确认</h4>
			      </div>
			      <div class="modal-body">
			        <span>是否确认消费<span id="modalCount"></span>次？</span>
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
			        <button type="button" class="btn btn-primary" onclick="CountConfirm();">确认消费</button>
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
        $.post("<%=request.getContextPath() %>/card/MemberCardUse",{"ID":"<%=Card.getString("amc_id")%>","Count":count},function(data){
              console.log(data);

              $("#loadingToast").hide();
              if (data.MsgID==-1)
              {
            	  alert(data.MsgTest);
              }
              else
              {
                  $.post("<%=request.getContextPath() %>/booking/BookingDateChangeType.json",{"ID":<%=AbdpID%>,"CheckIn":1},function(data){
                      //console.log(data);

                      $("#loadingToast").hide();
                      if (data.MsgID==-1)
                      {
                        alert(data.MsgText);
                      }
                      else
                      {

                          var Guest = $('#GuestInfoModal').data('Info');
                          $(Guest).attr('data-Checkin', data.CheckIn);
                          $(Guest).attr('data-CheckInDate', data.CheckInDate);
                          SetGuestToTable($(Guest));
                          $('.modal').modal('hide');
                          alert("操作成功！");
                      }
                  },"json");       
              }
          },"json");
        
      }
      
      </script>
      

      <!-- 赠券  -->
        <div class="container-fluid" id="" style="background-color: rgb(192, 192, 192);height:calc(32vh); padding-top: 0.7142rem;overflow: auto;">
            <%
            int CouponsCount=0;
              MySQLTable CouponsTable = new MySQLTable("select amc_Name,date_format(amc_TimeValidity,'%Y-%m-%d') as amc_TimeValidity,amc_id,amc_UseFlag,amc_id_ac from amc_Member_Coupons where _status<>'D' and amc_Flag=1 and amc_UseFlag=0 and amc_id_amb='"+amc_id_amb+"'   order by amc_UseFlag , amc_TimeValidity ");
              try {
                CouponsTable.Open();
                int i = 1;
                while (CouponsTable.next()) {
                  %>
                  <div class="CouponsCard CouponsCard<%=CouponsTable.getString("amc_id") %>" UseFlag="<%=CouponsTable.getInt("amc_UseFlag")%>">
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

                      $("#loadingToast").hide();
                      if (data.MsgID==-1)
                      {
                        $("#loadingToast").hide();
                        weui.alert(data.MsgText);
                      }
                      else
                      {
                        $('.CouponsCard'+ticketID).remove();
                        weui.alert('赠券使用成功！', {
                          title: '赠券',
                          buttons: [{
                              label: '确认',
                              type: 'primary',
                              onClick: function(){ 
                                //window.location.href='<%=request.getContextPath()%>/tx/card/MemberCardEdit.jsp?ID=<%=AmcID%>&d=' + new Date().getTime();
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
  <%
  }
}
finally
{
	Card.Close();
}
}
  %>	
	