<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.tx.Class.booking.TMedicalProjectList" %>
<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);
	
	String Modify =request.getParameter("Modify")==null?"False":request.getParameter("Modify");
	
	String amb_Level=request.getSession().getAttribute("amb_Level")==null?"1":(String)request.getSession().getAttribute("amb_Level");
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
    <style type="text/css">
    .page, body {
    	background-color: #f8f8f8;
	}
    
    </style>
    <% 
    	if (Modify.equals("True"))
    	{
    		
    %>
   	<script type="text/javascript">	    
		$(function(){
			history.replaceState(null, "", "<%=request.getContextPath()%>/tx/TabbarMenu.jsp?id=5");
		});	
		
    </script>
    <%
    	}
    		
    %>
<jsp:include page="/tx/Notice/NoticeJS.jsp" flush="true">     
     <jsp:param name="type" value="2"/> 
</jsp:include> 
	
</head>
<body>

<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
    <div class="container" id="container">
    	<div class="weui-cells__title"><p>选择挂号类型
    								<% 
    								if (Modify.equals("True"))
				                	{
				                		%>
				                		调整人数
				                		<%
				                		
				                	}
				                	else if (Modify.equals("Change"))
				                	{
				                		%>
				                		修改日期
				                		<%
				                		
				                	}
				                	else
					                	{
					                %>
					                	进行预约
					                <%
					                	}
					                %></p></div>   
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
					for (int i=0;i<MedicalProjectList.Length();i++)
					{		
						request.getSession().setAttribute("amp_id_"+MedicalProjectList.GetItem(i).ID, MedicalProjectList.GetItem(i).Name);
						%> 	
						<a class="weui-form-preview__btn weui-form-preview__btn_primary" href="<%=request.getContextPath()%>/tx/BookingDateSelect.jsp?type=<%=MedicalProjectList.GetItem(i).ID%>&Modify=<%=Modify%>" onclick="$('#loadingToast').show();">
							<div class="weui-form-preview">
					            <div class="weui-form-preview__hd">
					                <div class="weui-form-preview__item">
					                    <label class="weui-form-preview__label">挂号项目</label>
					                    <em class="weui-form-preview__value" style="line-height: 2em;"><%= MedicalProjectList.GetItem(i).Name %></em>
					                </div>
					            </div>
					            <div class="weui-form-preview__bd">
					            
					                <div class="weui-form-preview__item">
					                    <label class="weui-form-preview__label">项目说明</label>
					                    <em class="weui-form-preview__value" style="text-align: left;"><%= MedicalProjectList.GetItem(i).Remark %></em>
					                </div>
					                
					                <div class="weui-form-preview__item">
					                    <label class="weui-form-preview__label">挂号金额<span style="color:#E8E8E8"><%=amb_Level%></span></label>
					                    <%
					                    if (amb_Level.equals("2"))
					                    {
						                    %>
						                    <em class="weui-form-preview__value"  style="">¥<%= MedicalProjectList.GetItem(i).Money2 %></em>
						                    <%
					                    }
					                    else
					                    {
						                    %>
						                    <em class="weui-form-preview__value"  style="">¥<%= MedicalProjectList.GetItem(i).Money %></em>
						                    <%
															}
					                    %>
					                </div>
					            </div>
					        </div>
					    </a>
					        <br>
						<%
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


<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
</body>
</html>



