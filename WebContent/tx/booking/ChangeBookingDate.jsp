<%@page import="com.java.web.weixin.tx.Class.booking.TMedicalProjectList"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%

String UrlCode =request.getParameter("UrlCode")==null?"":(String)request.getParameter("UrlCode");
String MP=request.getParameter("MP")==null?"-1":(String)request.getParameter("MP");
String StringDate=request.getParameter("Date")==null?"":(String)request.getParameter("Date");
StringDate=StringDate.substring(0,10);

%>
<div class="modal" id="ChangeDateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"> 
  <div class="modal-dialog" role="document" style="max-width: 360px;margin-left: auto;margin-right: auto;margin-top: 10px;"> 
    <div class="modal-content">
      <div class="modal-body" style="min-height: 50px" > 
        <h ><center>预约信息</center></h>
        
    <div id="ChangeDateDiv" >
<div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                    <% 
                    TMedicalProjectList MedicalProjectList=new TMedicalProjectList();
                        if (MedicalProjectList.ErrCode!=1)
                        {
                            
                        }
                        else
                        {
                            %>
                            <select class="weui-select" id="selectMPChangeDate" style="width: 100%">
                            <option value="-1" <% if (MP.equals("-1")){%>selected<%} %>>请选择项目</option>
                            
                            <%
                            for (int i=0;i<MedicalProjectList.Length();i++)
                            {       
                                request.getSession().setAttribute("amp_id_"+MedicalProjectList.GetItem(i).ID, MedicalProjectList.GetItem(i).Name);
                                %>  
                                <option value=<%= MedicalProjectList.GetItem(i).ID %> <% if (MP.equals(""+MedicalProjectList.GetItem(i).ID)){%>selected<%} %>><%= MedicalProjectList.GetItem(i).Name %>
                                </option>
                                <%
                            }
                            %>
                            </select>
                            <%
                        }
                    %>
                    </div>
                </div>
                    
                <div class="weui-cell">
                    
                    <div class="weui-cell__bd">
                        <input id ="QueryDateChangeDate" class="weui-input" type="date" value="<%= StringDate %>" style="width: 140px;float: left;">
                    </div>
                </div>  

                <div class="weui-cell">
                    
                    <div class="weui-cell__bd">
                        
                        <a href="javascript:ChangeBookingDate_QueryChangeDate();" class="weui-form-preview__btn weui-form-preview__btn_primary" style="">查询</a>
                    </div>
                </div>  
                <div class="weui-cell">
                    
                    <div class="weui-cell__bd">
                        
                        <a href="javascript:ChangeBookingDate_Close();" class="weui-form-preview__btn weui-form-preview__btn_primary" style="">取消</a>
                    </div>
                </div>  

                <div class="*weui-cell" style="overflow: scroll;height: 300px;">
                    
                        
                        <div id="ChangeDateList">
                        </div>
                </div>  
                
            </div>
            
        
    </div>
    <script type="text/javascript">
    function ChangeBookingDate_QueryChangeDate()
    {
        if ($('#selectMPChangeDate').val()==-1)
        {

            alert("请选择项目！");
            return;
        }
        
        QueryDate=$("#QueryDateChangeDate").val();
        if (QueryDate=="")
        {
            alert("请选择日期！");
            return;
        }           

        $('#loadingToast').show();

        $.ajax({
            url:"<%=request.getContextPath()%>/GetBookingDateTimeList?MP="+$('#selectMPChangeDate').val()+"&date="+QueryDate+"&d="+new Date().Format('yyyymmddhhnnss'),
            type:'get',
            dataType:'Json',
            success:function(data){
                if (data.MsgID==-1)
                {
                    alert(data.MsgTest);                        
                }
                else
                {
                    //console.log(data.DateList);
                    if (data.DateList.length==0)
                    {
                        $("#ChangeDateList").html("无可预约时间");                            
                    }
                    else 
                    {

                        $("#ChangeDateList").html("");   
                        
                        for (i=0;i<data.DateList.length;i++)
                        {
                            if (!data.DateList[i].flag)
                            {

                                $("#ChangeDateList").append("<div>"+"<a class=\"weui-cell weui-cell_access restdate\" href=\"javascript:;\"  \">"+
                                    "<div class=\"weui-cell__bd\">"+
                                        "<p>"+data.DateList[i].bookingdatetime+"</p>"+
                                    "</div>"+
                                    "<div class=\"weui-cell__ft\">"+
                                        "<p>休息</p>"+
                                    "</div>"+
                                "</a>");
                            }   
                            else
                            {
                                $("#ChangeDateList").append("<div class1=\"weui-cell weui-cell_access \" style=\"padding: 0px;\">"+
                            "<a class=\"weui-cell weui-cell_access ShowSelectDialog\" href=\"javascript:;\" onclick=\"ChangeBookingDate_DoChangeDate("+data.DateList[i].id+")\" id=\"DivBookingID"+data.DateList[i].id+"\">"+
                                    "<div class=\"weui-cell__bd\">"+
                                    "<p style=\"text-align: left;\">"+data.DateList[i].bookingdatetime+"</p>\r\n" + 
                                    "                                       </div>\r\n" + 
                                    "                                       <div  class=\"weui-cell__ft\">\r\n" + 
                                    "                                           <p>共"+data.DateList[i].maxbooking+"订"+data.DateList[i].hasbooking+"调"+data.DateList[i].ModifyBooking+"</p>\r\n" + 
                                    "                                       </div>                                  \r\n" + 
                                    "                               </a>\r\n" + 
                                    "                               </div>");
                                        
                            }                               
                        }
                    }
                        
                }
                $('#loadingToast').hide();
            }
        }); 
        
        
    }    
    function ChangeBookingDate_Close()
    {

        $("#ChangeDateModal").modal("hide");
        $("#ChangeDateModal").remove();
    }
    function ChangeBookingDate_DoChangeDate(id)
    {
        var UrlCode="<%=UrlCode%>";
        console.log(UrlCode);
        console.log(id);


        $.ajax({
            url:"<%=request.getContextPath()%>/BackStage/ChangeDate?code="+UrlCode+"&id="+id+"&d="+new Date().Format('yyyymmddhhnnss'),
            type:'get',
            dataType:'Json',
            success:function(data){
                if (data.MsgID!=1)
                {
                    alert(data.MsgText);
                }
                else
                {
                    var Guest = $('#GuestInfoModal').data('Info');
                    $(Guest).remove();
                    $('#GuestInfoModal').modal("hide");
                	alert("改期成功！<br>如果是当天不同时间段之间的调整，请手动刷页面！");
                }
            }
        }); 
        
        $("#ChangeDateModal").modal("hide");
        $("#ChangeDateModal").remove();
        
    }
</script>
            </div>
        </div>
    </div>
</div>
	