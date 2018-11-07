<%@page import="com.java.sql.table.MySQLTable"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.base.GlobalVariable" %>
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

    String AmcID =request.getParameter("ID")==null?"-1":(String)request.getParameter("ID");
    
    String GuestName="";
    String GuestTel="";
    String AmbID="-1";
    if (!AmcID.equals("-1"))
    {
    	MySQLTable amc=new MySQLTable("select amc_id_amb,amc_guestname,amc_guesttel from amc_member_card where amc_id='"+AmcID+"'");
    	try
    	{
    		amc.Open();
    		if (amc.next())
    		{
                GuestName=amc.getString("amc_guestname");
                GuestTel=amc.getString("amc_guesttel");
                AmbID=amc.getString("amc_id_amb");
    		}
    	}
    	finally
    	{
    		amc.Close();
    	}
    }
%>

<!DOCTYPE html >
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	<style type="text/css">
	   .input-group+.input-group
	   {
	       margin-top:10px;
	   }
	    [type=radio]+label
	    {
	      display: block;
	    }
	    [name=BookingTime][type=radio]:checked+label
	    {
	      background-color: red;
	    }
	    [type=radio]
	    {
	      display: none;
	    }
	</style>
</head>
<body>
   	<div class="weui-cells__title"><p>手工排队</p></div>    
        <div class="weui-cells">
            <div class="weui-cell" style="padding-top: 20px;">     
            
                <div class="bs-example bs-example-form" >       
	                <div class="input-group">
	                  <span class="input-group-addon" id="basic-addon1">姓名</span>
	                  <input type="text" class="form-control" id="GuestName"  placeholder="姓名" aria-describedby="basic-addon1" value="<%=GuestName%>" >
	                </div>
	                <div class="input-group">
	                  <span class="input-group-addon" id="basic-addon1">电话</span>
	                  <input type="text" class="form-control" id="GuestTel"  placeholder="电话" aria-describedby="basic-addon1" value="<%=GuestTel%>" >
	                </div>
	                <div class="input-group" style="display: none;">
	                  <span class="input-group-addon" id="basic-addon1">ID</span>
	                  <input type="text" class="form-control" id="AmbID"  placeholder="购买人姓名" aria-describedby="basic-addon1" value="<%=AmbID%>" >
	                </div>
                </div>
            </div>    
            
            <div class="weui-cell" style="padding-top: 20px;">
            
              <div class="container-fluid" style="font-size: 0px;margin-top: 0px;" >  
            <%

            java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");

            String now = format.format(new Date());//这个就是把时间戳经过处理得到期望格式的时间  
            

            java.text.SimpleDateFormat BookingDateFormat = new java.text.SimpleDateFormat("HH:mm");
            
            MySQLTable abd=new MySQLTable("select abd_bookingdatetime,abd_id from abd_bookingdatetime \r\n"+
            		   " where abd_id_amp=2 and abd_status<>'D' and _status<>'D' and abd_BookingDate='"+now+"' \r\n"+
            		   " order by abd_bookingdatetime");
            try
            {
            	abd.Open();
            	while (abd.next())
            	{
            		String DateString=BookingDateFormat.format(abd.getDateTime("abd_bookingdatetime"));
            		%>
            		<div style="display: inline-block; width:20%;padding: 2px;font-size: 14px;" >
	                    <input type="radio" name="BookingTime"  id ="BookingTime<%=abd.getString("abd_id")%>" caption="<%=DateString%>" value="<%=abd.getString("abd_id")%>">
	                    <label for="BookingTime<%=abd.getString("abd_id")%>" class="btn btn-success" ><%=DateString%></label>
                   </div>
            		<%
            	}
            }
            finally
            {
            	abd.Close();
            }
            
            %> 
                </div>
            </div>
            
            <div class="weui-cell" style="padding-top: 20px;">
                
		        <div class="input-group font1 text-center" style="line-height: 20px;padding: 2px 30px;margin-top: 0px;width:100%">
		          <a class="btn  btn-danger" href="javascript:void(0);"  role="button" onclick="SaveBooking()" 
		            id="SaveBookingBtn" style="width:100%"  >确认并手工排队</a>
		        </div>
            </div>
                      
        </div>
    </div>    
    
    <!-- 手工排队确认 -->
    <div class="modal" id="BookingConfirm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="myModalLabel">手工排队</h4>
          </div>
          <div class="modal-body">
            
                <div class="bs-example bs-example-form" >  
                    <div class="input-group">
                      <span class="input-group-addon" id="basic-addon1">姓名</span>
                      <input type="text" class="form-control" id="GuestName2" aria-describedby="basic-addon1" value="" readonly>
                    </div>
                    <div class="input-group">
                      <span class="input-group-addon" id="basic-addon1">电话</span>
                      <input type="text" class="form-control" id="GuestTel2"  aria-describedby="basic-addon1" value="" readonly >
                    </div>
                    <div class="input-group">
                      <span class="input-group-addon" id="basic-addon1">时段</span>
                      <input type="text" class="form-control" id="BookingTimeName"  aria-describedby="basic-addon1" value=""  readonly>
                    </div>
                </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            <button type="button" class="btn btn-primary" onclick="BookingConfirm();">确认</button>
          </div>
          
        </div>
      </div>
    </div>      
    <script type="text/javascript">        
      function SaveBooking()
      {
        if ($("input[name=BookingTime]:checked").length==0)
        {
          alert("请选择【时段】！")
          return;
        }
        GuestName=$("#GuestName").val();
        GuestTel=$("#GuestTel").val();
        BookingTimeID=$("input[name=BookingTime]:checked").val();
        BookingTimeName=$("input[name=BookingTime]:checked").attr("caption");
        
        $("#GuestName2").val(GuestName);
        $("#GuestTel2").val(GuestTel);
        $("#BookingTimeName").val(BookingTimeName);
        
        $("#BookingConfirm").modal("show");
      }
      function BookingConfirm()
      {
    	  
        $("#BookingConfirm").modal("hide");

        AmbID=$("#AmbID").val();
        GuestName=$("#GuestName").val();
        GuestTel=$("#GuestTel").val();
        BookingTimeID=$("input[name=BookingTime]:checked").val();
        
        $("#loadingToast").show();
        $.post("<%=request.getContextPath() %>/booking/BookingDateManualEntry.json",{"AmbID":AmbID,"GuestName":GuestName,"GuestTel":GuestTel,"AbdID":BookingTimeID},function(data){
              //console.log(data);

              $("#loadingToast").hide();
              if (data.MsgID==-1)
              {
                  alert(data.MsgTest);
              }
              else
              {    
                  alert("排队成功！")
                  window.location.href='<%=request.getContextPath() %>/tx/booking/QueryBookingDateList0628.jsp?d=' + new Date().Format('yyyymmddhhnnss')
              }
          },"json");
        
      }
      
      </script>          
<div id="loadingToast" style="display: none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
        <i class="weui-loading weui-icon_toast"></i>
        <p class="weui-toast__content">操作中</p>
    </div>
</div>      
</body>
</html>