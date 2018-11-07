<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.java.web.weixin.tx.Class.booking.TQueryBookingDateList" %>
<%@ page import="org.apache.catalina.Session" %>
<%@ page import="com.java.web.weixin.tx.Class.booking.TMedicalProjectList" %>
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

	SimpleDateFormat formatter; 
	formatter = new SimpleDateFormat ("yyyy-MM-dd");
	String StringDate =formatter.format(new Date());	

	String QueryDate =request.getParameter("QueryDate")==null?"":request.getParameter("QueryDate");
	String MP =request.getParameter("selectMP")==null?"-1":request.getParameter("selectMP");
	String DateChange =request.getParameter("DateChange")==null?"True":request.getParameter("DateChange");
	if (!QueryDate.equals(""))
	{
		StringDate=QueryDate;
	}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	<style type="text/css">
		.weui-form-preview__btn_primary{background-color: #efeff4;}
	
		.restdate
		{    	
			background-color: #ececec;;
		}  	
	.restdate>.weui-cell__ft 
		{    	
			color: black;
		}  
	
	</style>
	<script type="text/javascript">
		function Query()
		{
			var MP=<%=MP%> 
			QueryDate=$("#QueryDate").val();
			if (QueryDate=="")
			{
				alert("请选择日期！");
				return;
			}			
			if ($('#selectMP').val()==MP)
			{
				$('#DateChange').val("False");
			}
	
			history.replaceState(null, "", "<%=request.getContextPath()%>/tx/TabbarMenu.jsp?id=5");
			$('#loadingToast').show();
			$("#QueryForm").submit();		
		}
		function QueryChangeDate()
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
								"<a class=\"weui-cell weui-cell_access ShowSelectDialog\" href=\"javascript:;\" onclick=\"DoChangeDate("+data.DateList[i].id+")\" id=\"DivBookingID"+data.DateList[i].id+"\">"+
						        		"<div class=\"weui-cell__bd\">"+
						        		"<p style=\"text-align: left;\">"+data.DateList[i].bookingdatetime+"</p>\r\n" + 
							    		"						            	</div>\r\n" + 
							    		"						            	<div  class=\"weui-cell__ft\">\r\n" + 
							    		"						            		<p>共"+data.DateList[i].maxbooking+"订"+data.DateList[i].hasbooking+"调"+data.DateList[i].ModifyBooking+"</p>\r\n" + 
							    		"						            	</div>					            	\r\n" + 
							    		"					        	</a>\r\n" + 
							    		"					        	</div>");
						            		
								}		        				
		        			}
		        		}
		        			
		        	}
		        	$('#loadingToast').hide();
		        }
			});	
			
			
		}
		
		function DoChangeDate(id)
		{
			var UrlCode=$('#ChangeDateDiv').attr("UrlCode");
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
		        		Query();			            
		        	}
		        }
			});	
			
			
			$('#ChangeDateList').html("");
			$('#ChangeDateDiv').attr("UrlCode","");
			$('#ChangeDateDiv').hide();
			
		}
		function Query2(d)
		{
			$("#QueryDate").val(d);
			Query();
		}
		
		function ShowDetil(id)
		{
			if ($("#QueryDetil_"+id).hasClass("IsShow"))
			{
				$("#QueryDetil_"+id).hide(500);
				$("#QueryDetil_"+id).removeClass("IsShow")
			}
			else
			{
				$(".QueryDetil.IsShow").hide(500);
				$(".QueryDetil.IsShow").removeClass("IsShow")
				$("#QueryDetil_"+id).show(500);
				$("#QueryDetil_"+id).addClass("IsShow");
			}
		}

		function CheckIn(UrlCode)
		{
			var sortitem=$("#item"+UrlCode);

			sortitem.attr("keytype","2");

			var key=sortitem.attr("key");
			var keytype=sortitem.attr("keytype");
			var sortid=key*1+keytype*1000;
			sortitem.attr("sortindex",sortid);
			sortitem.find('.StatusTypeText').html('已报到');
        			
        			
			
			

			$(".sortitem").each(function(){
				var sort=$(this).attr("sortindex");
				if (sort<sortid)
				{
					$(this).after(sortitem);
				}			
			})
	
			$.ajax({
		        url:"<%=request.getContextPath()%>/BookingDateCheckIn?code="+UrlCode+"&d="+new Date().Format('yyyymmddhhnnss'),
		        type:'get',
		        dataType:'Json',
		        success:function(data){
		        	if (data.MsgID!=1)
		        	{
		        		alert(data.MsgText);
		        	}
		        	else
		        	{
		        		$('#QueryDetil_'+UrlCode+' #CheckInDate em').html(data.CheckInDate);		        		
		    			$('#QueryDetil_'+UrlCode+' #CheckInDat').show();
		    			$('#QueryDetil_'+UrlCode+' #CheckInBtn').html('&nbsp;');
		    			$('#weuicellft_'+UrlCode).html('<span style=\"color:black;\">已报到</span>');

		    			$("#QueryDetil_"+UrlCode).hide();

			            $('#toast').show();
			            setTimeout(function () {
			            	$('#toast').hide();
			            }, 2000);
			            
			            
		        	}
		        }
			});	
			
		}
		function ChangeDate(UrlCode)
		{
			$('#ChangeDateList').html("");
			$('#ChangeDateDiv').attr("UrlCode",UrlCode);			
			$('#ChangeDateDiv').show();
			
		}
		
	</script>			
		
	<script type="text/javascript">	    
		$(function(){
		});	
		
    </script>
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
   	<div class="weui-cells__title"><p>预约情况</p></div>    
	<form action="<%=request.getContextPath()%>/tx/QueryBookingDateList.jsp" id ="QueryForm">
		<input id ="DateChange" name="DateChange" value="True" style="display: none;">
		<div class="weui-cells">
			<div class="weui-cell">
	            <div class="weui-cell__hd">
	            <% 
					TMedicalProjectList MedicalProjectList=new TMedicalProjectList();
					if (MedicalProjectList.ErrCode!=1)
					{
						%>
						<div><%= MedicalProjectList.ErrText %></div>
						<%
					}
					else
					{
						%>
	                    <select class="weui-select" id="selectMP" name="selectMP" style="width: 100px;">
	                    <option value="-1" <% if (MP.equals("-1")){%>selected<%} %>>全部</option>
	                    
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
	            <div class="weui-cell__bd">
	                <input id ="QueryDate" name="QueryDate" class="weui-input" type="date" value="<%= StringDate %>" style="width: 140px;float: left;">
	                <a href="javascript:Query();" class="weui-btn weui-btn_primary" style="float: right;line-height: 1em;padding: 5px">查询</a>
	            </div>
        	</div>	
        	<div class="weui-cell">
        	<%
        		Date now=new Date();
    		SimpleDateFormat formatter1 = new SimpleDateFormat ("dd");

    		SimpleDateFormat formatter2 = new SimpleDateFormat ("yyyy-MM-dd");
    	
 				for (int i =0;i<8;i++)
 				{
 					//if (QueryDate.equals(""))
					if (DateChange.equals("True")) 						
 					{
 						TQueryBookingDateList query=new TQueryBookingDateList(formatter2.format(now),MP);
 						request.getSession().setAttribute("QueryBookingDate"+formatter1.format(now), ""+query.Length());
 					}
 					String lenght=request.getSession().getAttribute("QueryBookingDate"+formatter1.format(now))==null?"0":(String)request.getSession().getAttribute("QueryBookingDate"+formatter1.format(now));
 					%>
 					<div style="position: relative;">
 					<a href="javascript:Query2('<%=formatter2.format(now)%>');" class="weui-btn weui-btn_primary" style="line-height: 1em;padding:2px;width: 30px;margin-top: 0px;margin-right:1px;margin-left:5px;"><span><%=formatter1.format(now)%></a>
 					<% 
 					if (!lenght.equals("0"))
 					{
 					%>
 					<span class="weui-badge" style="position: absolute;top: -15px;right: -5px;z-index: 1000;"><%=lenght%></span>
 					<%	
 					}
 					%>
 					</div>
 					<%
 					
 					
 					now.setTime(now.getTime()+1000*60*60*24);		
 				}
        	%>
	        	
	        </div>	
        	
		</div>
	</form>
	
			
	<%
	TQueryBookingDateList query;
	if (!QueryDate.equals(""))
	{
		query=new TQueryBookingDateList(QueryDate,MP);
	}
	else
	{
		query=new TQueryBookingDateList(StringDate,MP);
	}
	
		if (query.ErrCode!=1)
		{
			%>
			<div><%= query.ErrText %></div>
			<%
		}
		else
		{
			if (query.Length()==0)
			{
				%>
					<div>无预约记录！</div>
				<%
			}
			else
			{

				for (int i=0;i<query.Length();i++)
				{				   
					
					%>
					
						<div class="weui-cells sortitem" style="margin-top: 5px;" key="<%=i %>" keytype="0" sortindex="<%=i %>" id="item<%=query.GetItem(i).UrlCode %>" >
								<a class="weui-cell weui-cell_access" style="padding: 5px 15px;" href="javascript:ShowDetil('<%= query.GetItem(i).UrlCode %>');">
					        		<div class="weui-cell__bd" style="font-size: 12px;line-height: 2em;">
					            		<p><span style="color:red"><%= query.GetItem(i).MedicalProject %></span>&nbsp;
					            			<span style="color:blue"><%= query.GetItem(i).BookingDateTime %></span></span><br>
					            			<%= query.GetItem(i).MemberName %>&nbsp;
					            			<%= query.GetItem(i).MemberTel %></p>
					            	</div>
									<div id="weuicellft_<%= query.GetItem(i).UrlCode %>" class="weui-cell__ft">
										<%
					                    	String TempStr="&nbsp;";
				                    		if (query.GetItem(i).CheckIn)
				                    		{
				                    			TempStr="<span style=\"color:black;\">已报到</span>";
				                    		}
				                    		else if (!query.GetItem(i).StatusType.equals("已付款"))
					                    	{
					                    		TempStr="<span style=\"color:red;\">"+query.GetItem(i).StatusType+"</span>";
					                    	}
				                    		else
				                    		{
				                    			TempStr="<span style=\"color:blue;\">未报到</span>";
				                    		}				                    		
						                %>
						                <%= TempStr %>		
							        </div>
					        	</a>					        	
								<div class="weui-form-preview QueryDetil" style="display: none;/*border: 1px solid blue;*/" id="QueryDetil_<%= query.GetItem(i).UrlCode %>">
						            <div class="weui-form-preview__hd">
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">付款单号</label>
						                    <em class="weui-form-preview__value" style="font-size: 16px"><%= query.GetItem(i).UrlCode %></em>
						                </div>
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">付款金额</label>
						                    <em class="weui-form-preview__value">¥<%= query.GetItem(i).Money %></em>
						                </div>
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">付款状态</label>
						                    <%
						                    	String Color="";
						                    	if (query.GetItem(i).StatusType.equals("待付款"))
						                    	{
						                    		Color="color:red;";
						                    	}
						                    %>
						                    <em class="weui-form-preview__value " style="font-size: 16px;<%= Color %>"><%= query.GetItem(i).StatusType %></em>
						                </div>
						                <% 
						                	if (!query.GetItem(i).PayDate.equals(""))
						                	{
						                		%>
								                <div class="weui-form-preview__item">
								                    <label class="weui-form-preview__label">付款时间</label>
								                    <em class="weui-form-preview__value" style="font-size: 16px;"><%= query.GetItem(i).PayDate %></em>
								                </div>
						                		<%
						                	}
						                %>
						            </div>
						            <div class="weui-form-preview__bd">
									            
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">挂号项目</label>
						                    <em class="weui-form-preview__value"><%= query.GetItem(i).MedicalProject %></em>
						                </div>
						                <div class="weui-form-preview__item" style="display: none;">
						                    <label class="weui-form-preview__label">项目说明</label>
						                    <em class="weui-form-preview__value"><%= query.GetItem(i).MedicalProjectRemark %></em>
						                </div>
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">预约时间</label>
						                    <em class="weui-form-preview__value"><%= query.GetItem(i).BookingDateTime %></em>
						                </div>
						                
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">预约人姓名</label>	                    
						                    <em class="weui-form-preview__value"><%= query.GetItem(i).MemberName %></em>
						                </div>
						                
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">预约人手机</label>
						                    <em class="weui-form-preview__value"><%= query.GetItem(i).MemberTel %></em>
						                </div>      
						                <% 
						                	if (query.GetItem(i).CheckIn)
						                	{
						                		%>
						                			
									                <div class="weui-form-preview__item">
									                    <label class="weui-form-preview__label">状态</label>
									                    <em class="weui-form-preview__value">已报到</em>
									                </div> 
									                <div id="CheckInDate"  class="weui-form-preview__item">
									                    <label class="weui-form-preview__label">报到时间</label>
									                    <em class="weui-form-preview__value"><%= query.GetItem(i).CheckInDate %></em>
									                </div> 
						                		<%
						                	}
						                	else
						                	{
						                		%>
									                <div class="weui-form-preview__item">
									                    <label class="weui-form-preview__label">状态</label>
									                    <em class="weui-form-preview__value StatusTypeText">未报到</em>
									                </div>	
									                <div id="CheckInDate" class="weui-form-preview__item" style="display: none;">
									                    <label class="weui-form-preview__label">报到时间</label>
									                    <em class="weui-form-preview__value">&nbsp;</em>
									                </div> 
						                		<%
						                	}
						                %>
						                      
						            </div>
						            
						            <div id='CheckInBtn' class="weui-form-preview__ft" style="line-height: 30px;font-size: 14px;"
">
						            	<%
						            		if (query.GetItem(i).CheckIn)
						            		{
						            			%>
					            							&nbsp;
					            				<%
						            		}
						            		else
						            		{
						            			%>
						            				<a class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:;" onclick="CheckIn('<%= query.GetItem(i).UrlCode %>');">报到</a>		
						            				<a class="weui-form-preview__btn_primary" style="width: 100px;text-align: center;background-color: #C3C3C3;color: #e3e3e3;" href="javascript:;" onclick="ChangeDate('<%= query.GetItem(i).UrlCode %>');">改期</a>
						            			<%
						            		}
						            	%>
						            </div>	            
	            				</div>
						</div>
					<%
				}
			}
		}
	%>
	<div id="toast" style=" display: none;">
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
    
    <div id="ChangeDateDiv" style="display: none;">
        <div class="weui-mask_transparent"></div>
        <div  style="
				position: absolute;
				z-index: 5000;
				min-height: 7.6em;
				top: 40px;
				right: 25px;
				left: 25px;
				bottom: 80px;
				background: #e3e3e3;
				text-align: center;
				border-radius: 5px;
				color: #000;
				border: black 1px solid;
				" >
<div class="weui-cells">
				<div class="weui-cell">
		            <div class="weui-cell__hd">
		            <% 
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
		                
		                <a href="javascript:QueryChangeDate();" class="weui-form-preview__btn weui-form-preview__btn_primary" style="">查询</a>
		            </div>
	        	</div>	
				<div class="weui-cell">
					
		            <div class="weui-cell__bd">
		                
		                <a href="javascript:$('#ChangeDateDiv').hide();" class="weui-form-preview__btn weui-form-preview__btn_primary" style="">取消</a>
		            </div>
	        	</div>	

				<div class="*weui-cell" style="overflow: scroll;height: 300px;">
					
		                
		                <div id="ChangeDateList">
		                </div>
	        	</div>	
	        	
			</div>
			
		
        </div>
    </div>
    
    
<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
</body>
</html>