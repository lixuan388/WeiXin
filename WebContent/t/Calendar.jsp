<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.booking.TMedicalProjectList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
    
    <style type="text/css">
    	body{
    		background-color: rgba(236, 236, 236, 1);
    	}
    	.Calendar {
    		width:49px;
    		height:90px;
    		background-color: rgba(217, 217, 217, 1);
    		/*margin: 2px;*/
    		position:absolute;
    	}
    	.CalendarMonth {
    		width:350px;
    		height:50px;
    		font-size: 35px;
    		position:absolute;
    		text-align: center;
    		
    		background-color: rgba(204, 204, 204, 1);
    		
    	}
    	.Calendar span {
    		width:100%;
    		font-size: 35px;
    		text-align: center;
    		display: inline-block;
    	}
    	.WeekName {
    		width:49px;
    		height:50px;
    		font-size: 35px;
    		text-align: center;
    		
    		background-color: rgba(204, 204, 204, 1);
    		
    		position:absolute;
    		display: inline-block;
    	}
    	.Week0 , .Week6  {
    		color:red;
    	
    	}
    </style>
    
    <script type="text/javascript">
    	var date;
    	function loaddate(year,month,mp)
    	{	    	
			$.ajax({
		        url:"/WeiXin/CalendarHoliday?year="+year+"&month="+month+"&mp="+mp+"&d="+new Date().Format('yyyymmddhhnnss'),
		        type:'get',
		        dataType:'Json',
		        success:function(data){
		        	date=data;
		    		//console.log(data);
		    		var x=-1;
		    		var y=0;
		    		var m=0;
		    		var weekname=["日","一","二","三","四","五","六"];
		    		$("#container").html("");
		    		for(var i in date) {//不使用过滤
		            	//console.log(i,":",date[i]);
		    			if (m!=date[i].month)
		    			{
		    				if (x!=-1)
		    				{
		    					y=y+92;
		    				}		    				
		    				$("#container").append("<div class='CalendarMonth' style=\"left:"+0+"px;top:"+y+"px\">"+date[i].month+"月</div>");

		    				y=y+51;
		    				for (j=0;j<7;j++)
		    				{
		    					x=j*50;
		    					$("#container").append("<div class='WeekName Week"+j+"' style=\"left:"+x+"px;top:"+y+"px\">"+weekname[j]+"</div>");
		    				}
		    				m=date[i].month;
		    				y=y+51;
		    			}
		    			x=date[i].week*50;    
		    			var ii
		    			if (date[i].flag="Ture")
		    			{
		    				ii="<i class='weui-icon-success'></i>"
		    			}
		    			else
		    			{
		    				ii="<i class='weui-icon-circle'></i>"
		    			}
		    			
		    			$("#container").append("<a href=\"javascript:void(0);\" onclick=\"DoCalendar(this);\"><div class='Calendar' style=\"left:"+x+"px;top:"+y+"px\" json_year='"+date[i].year+"' json_month='"+date[i].month+"' json_day='"+date[i].day+"' json_week='"+date[i].week+"' json_mp='"+date[i].mp+"' json_date='"+date[i].date+"' json_name='"+date[i].name+"' ><span class=\"Week"+date[i].week+"\">"+date[i].day+"</span><center>"+ii+"</center></div></a>");

		    			if (date[i].week==6)
		    			{
		    				y=y+91;	
		    				x=-1;
		    			}
		        	}
		        }
			});	
			
	    }
    	function doloaddate()
    	{
    		loaddate($("#selectYear").val(),$("#selectMonth").val(),$("#selectMP").val())
    	}
    	function DoCalendar(tt)
    	{
    		console.log(tt);
    		if ($(tt).find("i").hasClass("weui-icon-success"))
    		{
    			$(tt).find("i").attr("class","weui-icon-circle");
    		}
    		else
    		{
    			$(tt).find("i").attr("class","weui-icon-success");
    		}
    	}

	    function SaveData()
	    {
	    	var JsonData={"DataRows":[{}]};
	    	$(".Calendar").each(function(index){

	    		var json_year=$(this).attr("json_year");
				var json_month=$(this).attr("json_month");
				var json_day=$(this).attr("json_day");
				var json_week=$(this).attr("json_week");
				var json_mp=$(this).attr("json_mp");
				var json_date=$(this).attr("json_date");
				var json_name=$(this).attr("json_name");
				var json_flag=$(this).find("i").hasClass("weui-icon-success");
				JsonData.DataRows[index]={}; 
				JsonData.DataRows[index].year=json_year;
				JsonData.DataRows[index].month=json_month;
				JsonData.DataRows[index].day=json_day;
				JsonData.DataRows[index].week=json_week;
				JsonData.DataRows[index].mp=json_mp;
				JsonData.DataRows[index].name=json_name;
				JsonData.DataRows[index].date=json_date;
				JsonData.DataRows[index].flag=json_flag;
	    	});
	    	console.log(JSON.stringify(JsonData));
	    	/*$.ajax({
	            url:"/WeiXin/BackStage/PostMedicalProjectInfo",
	            type:'POST',
	            data:  JSON.stringify(JsonData),
	            dataType:'Json',
	            success:function(data){
	            	if (data.MsgID!=1)
	            	{
	            		weui.alert(data.MsgText);
	            	}
	            	else
	            	{
	            		window.location.reload();
	            	}	            	
	            }
	    	});*/	
	    	
	    }
    </script>
	
</head>
    <div class="weui-toptips weui-toptips_warn js_tooltips">错误提示</div>
    
    <div class="weui-cells">
            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">项目</label>
                </div>
                <div class="weui-cell__bd">
        
        
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
                    <select class="weui-select" id="selectMP">
					<%
					for (int i=0;i<MedicalProjectList.Length();i++)
					{		
						request.getSession().setAttribute("amp_id_"+MedicalProjectList.GetItem(i).ID, MedicalProjectList.GetItem(i).Name);
						%> 	
						<option value=<%= MedicalProjectList.GetItem(i).ID %>><%= MedicalProjectList.GetItem(i).Name %>
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
			
            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">年份</label>
                </div>
                <div class="weui-cell__bd">
                 <select class="weui-select"  id="selectYear">
                  <%
                 	for (int i =2017;i<2030;i++)
                 	{
                 		%>
                 		<option value="<%= i %>"><%= i %></option>
                 		<%                 		
                 	}
                 %>
						
					</select>
                </div>
            </div>
			
            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">月份</label>
                </div>
                <div class="weui-cell__bd">
                 <select class="weui-select"  id="selectMonth">
                 <%
                 	for (int i =1;i<13;i++)
                 	{
                 		%>
                 		<option value="<%= i %>"><%= i %>月</option>
                 		<%                 		
                 	}
                 %>	
					</select>
                </div>
            </div>
            
            <div class="weui-form-preview__ft">
                <a class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:doloaddate();">查询</a>
            </div>
			
    </div>

    <div class="container" id="container" style="overflow: auto;position:relative;height:556px;margin: 2px"></div>
    
            <div class="weui-form-preview__ft">
                <a class="weui-btn weui-btn_warn" href="javascript:SaveData();"style="width: 100%;">保存</a>
            </div>
    
</body>
</html>