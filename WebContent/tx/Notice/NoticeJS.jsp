<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%

String type=request.getParameter("type")==null?"0":(String)request.getParameter("type");

String anl=request.getSession().getAttribute("Notice"+type)==null?"":(String)request.getSession().getAttribute("Notice"+type);

if (!anl.equals(""))
{
%>

<script type="text/javascript">
$(function () {
	ShowNotice('<%=anl%>')
});
	
function ShowNotice(id){

	
	 OpenWindowLayer('公告','<%=request.getContextPath() %>/tx/Notice/NoticeRead.jsp?id='+id,function(){
	 });
}
</script>
<%

}

%>    

	
