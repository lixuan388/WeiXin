<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.TMemberInfo"%>
<%@ page import="org.apache.catalina.Session"%>
<%@ page import="com.java.sql.table.MySQLTable"%>
<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  

	String MemberID =request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");
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

.input-group {
  width: 100%
}

thead, tr {
  text-align: center;
}
</style>
<jsp:include page="/tx/Notice/NoticeJS.jsp" flush="true">
  <jsp:param name="type" value="3" />
</jsp:include>
</head>
<body>
  <jsp:include page="/res/temple/TabbarMenuBegin.jsp" />
  <div class="container" id="container" style="padding-bottom: 20px;">
    <div class="weui-cells__title">
      <p>次卡信息</p>
    </div>
    <% 
				if (MemberID.equals(""))
				{
					%>
    <span>参数错误！</span>
    <%
				}
				else
				{
					MySQLTable Card=new MySQLTable("select amc_id,amc_GuestName,amc_GuestTel,amc_CreateDate,amc_Count,amc_EndDate from amc_member_card where amc_id_amb='"+MemberID+"'");
					
					try
					{
						Card.Open();
						if (!Card.next())
						{
							TMemberInfo memberInfo=new TMemberInfo(MemberID);
							if (memberInfo.ErrCode!=1)
							{
								%>
    <span><%= memberInfo.ErrText %></span>
    <%						
							}
							else
							{
								%>
    <div class="weui-cells">
      <div class="weui-cell">
        <div class="weui-cell__hd">
          <label class="weui-label">购买姓名：</label>
        </div>
        <div class="weui-cell__bd">
          <input id="MemberName" class="weui-input" placeholder="请输入姓名" type="text" value="<%= memberInfo.amb_name %>"> <input style="display: none;" name="MemberName" id="MemberName2"
            class="weui-input" placeholder="请输入姓名" type="text" value="<%= memberInfo.amb_name %>"
          >
        </div>
      </div>
      <div class="weui-cell">
        <div class="weui-cell__hd">
          <label class="weui-label">手机号码：</label>
        </div>
        <div class="weui-cell__bd">
          <input id="MemberTel" class="weui-input" pattern="[0-9]*" placeholder="请输入手机号码" type="number" value="<%= memberInfo.amb_Tel %>"> <input style="display: none;" name="MemberTel"
            id="MemberTel2" class="weui-input" pattern="[0-9]*" placeholder="请输入手机号码" type="number" value="<%= memberInfo.amb_Tel %>"
          >
        </div>
      </div>
    </div>
    <div class="weui-cells">
      <div class="weui-cell">
        <span style="color: red">请先与客服沟通，再按指示进行次卡的购买操作！</span>
      </div>
    </div>
    <div class="weui-cells">
      <div class="weui-cell" id="ApplyBtn">
        <a href="javascript:GetCardImage();" class="weui-btn weui-btn_mini weui-btn_primary">发送购买申请</a>
      </div>
    </div>
    <div class="weui-panel weui-panel_access" style="margin-bottom: 10px;">
      <div class="weui-panel__bd">
        <div class="weui-media-box weui-media-box_text">
          <h4 class="weui-media-box__title">次卡操作说明</h4>
          <p id="operationremark" class="weui-media-box__desc" style="-webkit-line-clamp: 10000;"><%= System.getProperty("WeiXin.tx.cardremark")  %></p>
        </div>
      </div>
    </div>
    <script type="text/javascript">
										function GetCardImage()
										{
											GuestName=$("#MemberName").val();
											GuestTel=$("#MemberTel").val();
											if (GuestName=="")
											{
												alert("请输入姓名！")
												return;
											}
											if (GuestTel=="")
											{
												alert("请输入手机号码！")
												return;
											}

											$("#loadingToast").show();
											$.post("<%=request.getContextPath() %>/card/MemberCardApply",{"GuestName":GuestName,"GuestTel":GuestTel},function(data){
											      //console.log(data);

										    	  $("#loadingToast").hide();
											      if (data.MsgID==-1)
											      {
											  		alert(data.MsgTest);
											      }
											      else
											      {
											    	  $("#ApplyBtn").html("<span style='color:blue;'>购买申请提交成功，请与客服联系！</span>");
											      }
											  },"json");
										}
										
									</script>
    <%	
							}				 
						}
						else
						{


							java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");
							String CreateDate=format.format(Card.getDateTime("amc_CreateDate"));
							String EndDate=format.format(Card.getDateTime("amc_EndDate"));
							
							
							
							%>
    <div class="" style="font-size: 12px; line-height: 1em;">
      <div class="input-group" style="padding: 0px; width: 50%; float: left;">
        <span style="display: table-cell; text-align: right;" id="basic-addon1">姓名：</span> <span style="color: blue; width: 100px; display: table-cell; padding: 5px;" id="CardGuestName"><%=Card.getString("amc_GuestName")%></span>
      </div>
      <div class="input-group" style="padding: 0px; width: 50%; float: left; margin-top: 0px;">
        <span style="display: table-cell; text-align: right;" id="basic-addon1">手机：</span> <span style="color: blue; width: 100px; display: table-cell; padding: 5px;" id="CardGuestTel"><%=Card.getString("amc_GuestTel")%></span>
      </div>
      <div style="clear: both; height: 1px; background-color: #E4E4E4;"></div>
    </div>
    <div class="" style="font-size: 12px; line-height: 1em;">
      <div class="input-group" style="padding: 0px; width: 50%; float: left;">
        <span style="display: table-cell; text-align: right;" id="basic-addon1">充值日期：</span> <span style="color: blue; width: 100px; display: table-cell; padding: 5px;"><%=CreateDate%></span>
      </div>
      <div class="input-group" style="padding: 0px; width: 50%; float: left; margin-top: 0px;">
        <span style="display: table-cell; text-align: right;" id="basic-addon1">有效期：</span> <span style="color: blue; width: 100px; display: table-cell; padding: 5px;" id="CardEndDate"><%=EndDate%></span>
      </div>
      <div style="clear: both; height: 1px; background-color: #E4E4E4;"></div>
    </div>
    <div class="input-group font1 text-center" style="line-height: 20px; padding: 2px;">
      <span>剩余消费次数：</span><span style="color: red; font-size: 20px"><%=Card.getString("amc_Count")%></span>
    </div>
    <div class="input-group" id="History">
      <a class="btn btn-success " href="javascript:void(0);" onclick="QueryHistory()" role="button" style="width: 100%">查询使用历史</a>
    </div>
    <%
							
							String url=request.getScheme()+"://"+request.getServerName()+request.getContextPath()+"/tx/card/MemberCardEdit.jsp?ID="+Card.getString("amc_id");
							String urlCode=java.net.URLEncoder.encode(url, "utf-8"); 
							%>
    <div class="text-center">
      <img alt="" src="<%=request.getContextPath()%>/System/CreateQRCode?url=<%=urlCode %>" style="width: 100%;">
    </div>
    <div class="weui-panel weui-panel_access" style="margin-bottom: 10px;">
      <div class="weui-panel__bd">
        <div class="weui-media-box weui-media-box_text">
          <h4 class="weui-media-box__title">次卡操作说明</h4>
          <p id="operationremark" class="weui-media-box__desc" style="-webkit-line-clamp: 10000;"><%= System.getProperty("WeiXin.tx.cardremark")  %></p>
        </div>
      </div>
    </div>
    <script type="text/javascript">
								function QueryHistory()
								{	

				          $("#loadingToast").show();
									$.ajax({
								        url:"<%=request.getContextPath() %>/card/MemberCardHistoryQuery?ID=<%=Card.getString("amc_id")%>&d="+new Date().Format('yyyymmddhhnnss'),
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
								        		//console.log(data);
								        		$("#History").html("");
								        		var table=$("<table class='table table-striped table-condensed'></table>");
								        		var th=$("<thead><td>类型</td><td>日期</td><td>次数</td></thead>")
								        		table.append(th);
								        		var body=$("<tbody></tbody>")
								        		for (var i=0;i<data.Data.length;i++)
								        		{

									        		//console.log(data.Data[i].Type);
								        			var tr=$("<tr><td>"+data.Data[i].Type+"</td><td>"+data.Data[i].Date+"</td><td>"+data.Data[i].Count+"</td></tr>");
								        			body.append(tr);
								        		}
								        		table.append(body);
								        		$("#History").append(table);
									            
									            
								        	}
								        }
									});	
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
</body>
</html>