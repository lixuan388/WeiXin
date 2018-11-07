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
    .TabbarPage2 {
	    position: absolute;
	    top: 0;
	    right: 0;
	    bottom: 0px;
	    left: 0;
	    overflow: hidden;	    
    	width: 100%;
	}	
    </style>
    
    <script type="text/javascript">
    	var date;
    	function loaddate(mp,week)
    	{	    
    		$('#loadingToast').show();	
			$.ajax({
		        url:"/WeiXin/BackStage/GetMedicalProjectTimeNumber?mp="+mp+"&Week="+week+"&d="+new Date().Format('yyyymmddHHMMss'),
		        type:'get',
		        dataType:'Json',
		        success:function(data){
		        	$("#container").html("");
					for (i =0;i<data.DataRows.length;i++)
					{
						var Template=$("#timenumber").clone();
						$(Template).attr("style","");
						$(Template).attr("id","timenumber"+data.DataRows[i].id);
						$(Template).attr("keyid",data.DataRows[i].id);
						$(Template).attr("mp",data.DataRows[i].mp);
						$(Template).attr("week",data.DataRows[i].week);
						$(Template).addClass("timenumber");
						$(Template).find("#timelabel").html(data.DataRows[i].time);
						$(Template).find("#inputnumber").val(data.DataRows[i].Number);
						$(Template).find("#inputnumber").on("change", function(){
							var sum=0;
							$("#container #inputnumber").each(function(){			
								sum=sum+$(this).val()*1;
								
							});
							$("#SaveBtn").html("保存("+sum+")");
					    });
						$(Template).find("#inputnumber").on("focus", function(){
							console.log($(this));
							var pos = $(this).position().top;
							console.log("pos:"+pos);
							$($(this).parent()).scrollIntoView();
					    });


						$("#container").append($(Template));						
					}	

		    		$('#loadingToast').hide();	

					$("#SaveBtn").html("保存");
		        }
			});	
			
	    }

    	function doloaddate()
    	{
    		loaddate($("#selectMP").val(),$("#selectWeek").val())
    	}

	    function SaveData()
	    {
	    	$('#loadingToast').show();	
	    	var JsonData={"DataRows":[{}]};
	    	$(".timenumber").each(function(index){

	    		var json_id=$(this).attr("keyid");
	    		var json_mp=$(this).attr("mp");
	    		var json_week=$(this).attr("week");
				var json_time=$(this).find("#timelabel").html();
				var json_number=$(this).find("#inputnumber").val()==""?0:$(this).find("#inputnumber").val();
				
				JsonData.DataRows[index]={}; 
				JsonData.DataRows[index].id=json_id;
				JsonData.DataRows[index].mp=json_mp;
				JsonData.DataRows[index].week=json_week;
				JsonData.DataRows[index].time=json_time;
				JsonData.DataRows[index].number=json_number;	
	    	});
	    	//console.log(JSON.stringify(JsonData));
	    	$.ajax({
	            url:"/WeiXin/BackStage/PostMedicalProjectTimeNumber",
	            type:'POST',
	            data:  JSON.stringify(JsonData),
	            dataType:'Json',
	            success:function(data){
            		weui.alert(data.MsgText);   
            		if (data.MsgID==1)
            		{
            			doloaddate();
            		}
            		$('#loadingToast').hide();	
	            }
	    	});
	    	
	    }
    </script>
	    <script type="text/javascript">	    
		$(function(){
			history.replaceState(null, "", "/WeiXin/tx/TabbarMenu.jsp?id=5");
		});	
		
    </script>
</head>
<body >

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
<div>    
    <div >
    	<div class="weui-cells__title"><p>时间段人数设置</p></div>   
    </div>
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
                <label for="" class="weui-label">星期</label>
            </div>
            <div class="weui-cell__bd">
             	<select class="weui-select"  id="selectWeek">
	              <%
	             	for (int i =0;i<7;i++)
	             	{
	             		String WeekName="";
	             		
	    	            switch (i) {
	    				case 0:
	    					WeekName="日";        					
	    					break;
	    				case 1:
	    					WeekName="一";        					
	    					break;
	    				case 2:
	    					WeekName="二";        					
	    					break;
	    				case 3:
	    					WeekName="三";        					
	    					break;
	    				case 4:
	    					WeekName="四";        					
	    					break;
	    				case 5:
	    					WeekName="五";        					
	    					break;
	    				case 6:
	    					WeekName="六";        					
	    					break;
	    				}
	             		
	             		%>
	             		<option value="<%= i %>">星期<%= WeekName %></option>
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
</div>

<div class="weui-cells"  style2="height: 100%;margin-bottom: -500px;">
	<div style2="overflow: auto;position: absolute;top: 0;bottom: 0;right: 0;left: 0;padding-bottom: 270px;box-sizing: border-box;" id="container" ></div>
</div>    
<div class="weui-tabbarXX">
	<div class="" style2="display: -webkit-box;display: -webkit-flex;display: flex;position: absolute;z-index: 500;bottom: 55px;width: 100%;background-color: #f7f7fa;">
		<a class="weui-btn weui-btn_warn" href="javascript:SaveData();"style="width: 100%;" id="SaveBtn">保存</a>
	</div>
</div>

<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>    
<div id="loadingToast" style="display: none;">
    <div class="weui-mask_transparent"></div>
    <div class="weui-toast">
        <i class="weui-loading weui-icon_toast"></i>
        <p class="weui-toast__content">操作中</p>
    </div>
</div>

<div class="weui-cell" id="timenumber" style="display: none;">
    <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel" >时间</label></div>
    <div class="weui-cell__bd">
        <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
    </div>
</div>    
    
</body>
</html>