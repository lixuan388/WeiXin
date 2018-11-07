

<%@page import="java.io.IOException"%>
<%@page import="java.util.List"%>
<%@page import="org.jdom.Document"%>
<%@page import="org.jdom.Element"%>
<%@page import="org.jdom.JDOMException"%>
<%@page import="org.jdom.input.SAXBuilder"%>
<%@page import="org.xml.sax.InputSource"%>


<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.StringReader"%>
<%@page import="com.java.sql.table.MySQLTable"%>
<%@page import="com.ecity.java.web.WebFunction"%>
<%@page import="com.ecity.java.weixin.mvc.service.WXService"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.java.web.weixin.base.GlobalVariable" %>


<%
	response.setHeader("Pragma","No-cache");  
	response.setHeader("Cache-Control","no-cache");  
	response.setDateHeader("Expires", 0);  
	WXService service=new WXService();
  //WebFunction.sendHttpPost("http://www.jackiehor.org/WeiXin/PayResult", result);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
<body>


  <%
    MySQLTable tableList=new MySQLTable();
    
    String sqlStr=" select abdp_urlcode from abdp_bookingdatetime_pay,abd_bookingdatetime where abdp_statustype='超时取消' and abdp_id_abd=abd_id   and abd_bookingDate>'2019-03-01'" ;
    //String sqlStr=" select abdp_urlcode from abdp_bookingdatetime_pay where abdp_id_amb='c0178bc0c74e4ce3b82e0496d3c037b' and abdp_date_lst>'2019-02-22'";
    //String sqlStr=" select abdp_urlcode from abdp_bookingdatetime_pay,abd_bookingdatetime where abdp_statustype='已支付' and abdp_id_abd=abd_id   and abd_bookingDate>'2018-02-28'" ;


    try
    {
      tableList.SQL(sqlStr);
      tableList.Open();
      while (tableList.next())
      {

        String orderid=tableList.getString("abdp_urlcode");
        String result=service.OrderQuery(GlobalVariable.AppID, GlobalVariable.mch_id, GlobalVariable.APIKey,orderid);
        

        StringReader sr = new StringReader(result);
        InputSource is = new InputSource(sr);
        JSONObject ReturnList = new JSONObject();

        try {
          Document doc = (new SAXBuilder()).build(is);
          List<Element> xmlList = doc.getRootElement().getChildren();
          for (int i = 0; i < xmlList.size(); i++) {
            Element e = xmlList.get(i);
            String Key = e.getName();
            String Value = e.getText();
            ReturnList.put(Key, Value);
          }
        } catch (JDOMException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
        } catch (IOException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
        }

        
        
        %>
        <div >
        <div><%=orderid %></div>
        <div><%=ReturnList.get("trade_state") %></div>
        <div><%=ReturnList.get("transaction_id") %></div>
        <%
        String trade_state=(String)ReturnList.get("trade_state");
        System.out.println(trade_state);
        if ((trade_state!=null) && (trade_state.equals("SUCCESS")))
        {
          //WebFunction.sendHttpPost("http://www.jackiehor.org/WeiXin/PayResult", result);
        }
        %>
        
        <input type='text' value='<%=result %>' style="width:100%;margin: 5px">
        </div>
        <%
      }
    }
    finally
    {
      tableList.Close();
    } 
    System.out.println("查检完成");
  %>
  
</body>
</html>