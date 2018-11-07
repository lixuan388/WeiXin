package com.java.web.weixin.tx.servlet;



import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.SQLConnect;
import com.java.sql.table.MySQLTable;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.jssdk.WXSnsapiBaseCode;
import com.java.web.weixin.jssdk.WXUserInfo;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/GetBookingDateTimeList")
public class GetBookingDateTimeListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetBookingDateTimeListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");
		


		String MP =request.getParameter("MP")==null?"":request.getParameter("MP");
		if (MP.equals(""))
		{
			String ErrText="参数错误！(MP)";			
			GlobalVariable.WriteMsgText(response,-1,ErrText);
			return;
		}

		String date =request.getParameter("date")==null?"":request.getParameter("date");
		if (date.equals(""))
		{
			String ErrText="参数错误！(date)";
			GlobalVariable.WriteMsgText(response,-1,ErrText);
			return;
		}

		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();     
		net.sf.json.JSONArray DateLists = new net.sf.json.JSONArray();  
		
	    ResultXml.put("MsgID","1");
		MySQLTable table=new MySQLTable("select abd_id, abd_bookingdatetime,abd_maxbooking,ifnull(abd_hasBooking,0) as abd_hasbooking,abd_ModifyBooking ,amps_flag"+
				"  from abd_BookingDatetime ,amps_medical_project_schedule "+
				"  where  abd_BookingDatetime._status<>'D' and amps_medical_project_schedule._status<>'D' "+
				" and abd_id_amp=amps_id_amp and abd_bookingdate=amps_date "+
				" and abd_bookingdatetime>now() "+
				" and  abd_bookingdate='"+date+"' and abd_id_amp="+MP+
				" order by abd_bookingdatetime");

		table.Open();
		while (table.next())
		{ 

			SimpleDateFormat formatter; 
			formatter = new SimpleDateFormat ("yyyy-MM-dd HH:mm");
			String StringDate =formatter.format(table.getDateTime("abd_bookingdatetime"));	
			
			
			net.sf.json.JSONObject Info = new net.sf.json.JSONObject();  
			Info.put("id",table.getString("abd_id"));
			Info.put("bookingdatetime",StringDate);
			Info.put("maxbooking",table.getString("abd_maxbooking"));
			Info.put("hasbooking",table.getString("abd_hasbooking"));
			Info.put("ModifyBooking",table.getString("abd_ModifyBooking"));
			Info.put("flag",table.getString("amps_flag"));
			DateLists.add(Info);
		}
		ResultXml.put("DateList",DateLists);
		table.Close();
		
		response.setContentType("application/json;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");  
		response.getWriter().print(ResultXml.toString());
		response.getWriter().flush();
        
        
	}
}
