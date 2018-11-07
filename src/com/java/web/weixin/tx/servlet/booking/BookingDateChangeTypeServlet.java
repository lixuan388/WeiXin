package com.java.web.weixin.tx.servlet.booking;



import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.SQLConnect;
import com.java.sql.table.MySQLTable;
import com.java.web.weixin.base.GlobalVariable;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/booking/BookingDateChangeType.json")
public class BookingDateChangeTypeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookingDateChangeTypeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("application/json;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");


		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();      

		String groupid=request.getSession().getAttribute("groupid")==null?"0":(String)request.getSession().getAttribute("groupid");
		if (!groupid.equals("100") && !groupid.equals("101"))
		{
			String ErrText="权限错误，无法操作！";
			GlobalVariable.WriteMsgText(response, -100, ErrText);
			return;
		}
		

		Map<String, String[]> params = request.getParameterMap();	
		String ID =params.get("ID")==null?"":(String)(params.get("ID")[0]);		
		if (ID.equals(""))
		{
			String ErrText="错误的参数，无法操作！(ID)";
			GlobalVariable.WriteMsgText(response,-1,ErrText);
			return;
		}
		
		String CheckIn =params.get("CheckIn")==null?"":(String)(params.get("CheckIn")[0]);	
		if (ID.equals(""))
		{
			String ErrText="错误的参数，无法操作！(CheckIn)";
			GlobalVariable.WriteMsgText(response,-1,ErrText);
			return;
		}
		
		
		Date now=new Date();
		SimpleDateFormat formatter; 
		formatter = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
		String NowDate =formatter.format(now);	

		
	    MySQLTable table=new MySQLTable();

    	table.SQL("select abdp_checkin,abdp_checkindate,abdp_CheckUser,abdp_id,_Status,_User_Lst,_Date_Lst,_SyncFlag from  abdp_bookingdatetime_pay where abdp_id="+ID);
    	try
    	{
	    	table.Open();
	    	if (!table.next())
	    	{
		        ResultXml.put("MsgID","-1");
		        ResultXml.put("MsgText","预约记录不存在！");
	    	}
	    	else
	    	{
	    	  String TempCheckIn=table.getString("abdp_checkin");
	    	  
	    	  table.updateString("abdp_checkin", CheckIn);
	    		if (((CheckIn.equals("1"))|| (CheckIn.equals("2"))||(CheckIn.equals("4"))) && ((TempCheckIn.equals("0")) ||(TempCheckIn.equals("3"))))
	    		{
	    		  table.updateDateTime("abdp_checkindate", now);
	    		}
          table.updateString("abdp_checkin", CheckIn);
	    		table.updateString("abdp_CheckUser", GlobalVariable.GetMemberID(request));
	    		table.updateString("_Status", "E");
	    		table.updateString("_User_Lst", GlobalVariable.GetMemberID(request));
	    		table.updateDateTime("_Date_Lst",now);
	    		table.updateString("_SyncFlag","0");
		    	table.PostRow();
		    	
		        ResultXml.put("MsgID","1");
		        ResultXml.put("MsgText","SUCCESS");
		        ResultXml.put("CheckInDate",NowDate);
		        ResultXml.put("CheckIn",CheckIn);
	    	}
    	}
    	finally
    	{
    		table.Close();
    	}	         

		response.getWriter().print(ResultXml.toString());
		response.getWriter().flush();    
	    
	}


}
