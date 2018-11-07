package com.java.web.weixin.tx.servlet.booking;



import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
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
import com.java.web.weixin.jssdk.WXSnsapiBaseCode;
import com.java.web.weixin.jssdk.WXUserInfo;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/booking/GetBookingDateTimeList.json")
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
		SimpleDateFormat formatter; 
		formatter = new SimpleDateFormat ("yyyy-MM-dd");
		String date =formatter.format(new Date());	
		
		Map<String, String[]> params = request.getParameterMap();	
		date =params.get("Date")==null?date:(String)(params.get("Date")[0]);		

		

		SimpleDateFormat Hourformatter = new SimpleDateFormat ("HHmm");
		SimpleDateFormat Paydateformatter = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
		

		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();     
		net.sf.json.JSONArray DateLists = new net.sf.json.JSONArray();  
		
	    ResultXml.put("MsgID","1");
		MySQLTable table=new MySQLTable("select day(abd_BookingDateTime) as BookDay,hour(abd_BookingDateTime) as BookHour,minute(abd_BookingDateTime) as BookMin,\r\n" + 
				"abd_id_amp,abdp_checkin,abdp_checkindate,abdp_guestname,abdp_id,abdp_guesttel,amp_name,abd_BookingDateTime,abdp_StatusType,abdp_money,abdp_UrlCode,abdp_paydate,abdp_id_amb\r\n" + 
				"from abdp_bookingdatetime_pay,abd_bookingdatetime ,amp_medical_project \r\n" + 
				"where abdp_id_abd=abd_id and abd_BookingDate='"+date+"'\r\n" + 
//"where abdp_id_abd=abd_id and abd_BookingDate='2017-11-23'\r\n" + 
//				"where abdp_id_abd=abd_id and abd_BookingDate='2018-07-01'\r\n" + 
				"and abdp_bookingdatetime_pay._status<>'D' and abd_id_amp=amp_id \r\n" + 
				"order by abd_BookingDateTime,abdp_checkindate,abd_id_amp,abdp_bookingdatetime_pay._date_ins");
		try
		{
			table.Open();
			while (table.next())
			{ 		
				net.sf.json.JSONObject Info = new net.sf.json.JSONObject();  
				Info.put("ID",table.getString("abdp_id"));
				Info.put("BookHour",table.getString("BookHour"));
				Info.put("BookMin",table.getString("BookMin"));
				if (table.getString("abd_id_amp").equals("3"))
				{
					Info.put("Amp","2");
				}
				else
				{
					Info.put("Amp",table.getString("abd_id_amp"));
				}
				Info.put("CheckIn",table.getString("abdp_checkin"));
				if (table.getString("abdp_checkindate").equals(""))
				{
					Info.put("CheckInDate","");
				}
				else
				{
					Info.put("CheckInDate",Paydateformatter.format(table.getDateTime("abdp_checkindate")));
				}
				Info.put("GuestName",table.getString("abdp_guestname"));
				Info.put("GuestTel",table.getString("abdp_guesttel"));
				Info.put("Hour",Hourformatter.format(table.getDateTime("abd_BookingDateTime")));
				Info.put("BookingTime",Paydateformatter.format(table.getDateTime("abd_BookingDateTime")));
				Info.put("MedicalProject",table.getString("amp_name"));
				Info.put("StatusType",table.getString("abdp_StatusType"));
				Info.put("money",table.getInt("abdp_money"));
				Info.put("UrlCode",table.getString("abdp_UrlCode"));

				Info.put("AmbID",table.getString("abdp_id_amb"));
				if (table.getString("abdp_paydate").equals(""))
				{
					Info.put("paydate","");
				}
				else
				{
					Info.put("paydate",Paydateformatter.format(table.getDateTime("abdp_paydate")));
				}			
				DateLists.add(Info);
			}
			
			table=new MySQLTable("select day(abdp_checkindate) as BookDay,hour(abdp_checkindate) as BookHour,minute(abdp_checkindate) as BookMin,\r\n" + 
					"0 as abd_id_amp,abdp_checkin,abdp_checkindate,abdp_guestname,abdp_id,abdp_guesttel,'手工排队' as amp_name,\r\n" + 
					"abdp_checkindate as abd_BookingDateTime,abdp_StatusType,\r\n" + 
					"abdp_money,abdp_UrlCode,abdp_paydate,abdp_id_amb\r\n" + 
					"from abdp_bookingdatetime_pay\r\n" + 
					"where  DATE_FORMAT(abdp_checkindate,'%Y-%m-%d') ='"+date+"'\r\n" + 
					"and _status<>'D' and abdp_id_abd=0\r\n" + 
					"order by abdp_checkindate,abdp_bookingdatetime_pay._date_ins");
			table.Open();
			while (table.next())
			{ 		
				net.sf.json.JSONObject Info = new net.sf.json.JSONObject();  
				Info.put("ID",table.getString("abdp_id"));
				Info.put("BookHour",table.getString("BookHour"));
				Info.put("BookMin",table.getString("BookMin"));
				Info.put("Amp",table.getString("abd_id_amp"));
				Info.put("CheckIn",table.getString("abdp_checkin"));
				if (table.getString("abdp_checkindate").equals(""))
				{
					Info.put("CheckInDate","");
				}
				else
				{
					Info.put("CheckInDate",Paydateformatter.format(table.getDateTime("abdp_checkindate")));
				}
				Info.put("GuestName",table.getString("abdp_guestname"));
				Info.put("GuestTel",table.getString("abdp_guesttel"));
				Info.put("Hour",Hourformatter.format(table.getDateTime("abd_BookingDateTime")));
				Info.put("BookingTime",Paydateformatter.format(table.getDateTime("abd_BookingDateTime")));
				Info.put("MedicalProject",table.getString("amp_name"));
				Info.put("StatusType",table.getString("abdp_StatusType"));
				Info.put("money",table.getInt("abdp_money"));
				Info.put("UrlCode",table.getString("abdp_UrlCode"));
				Info.put("AmbID",table.getString("abdp_id_amb"));
				if (table.getString("abdp_paydate").equals(""))
				{
					Info.put("paydate","");
				}
				else
				{
					Info.put("paydate",Paydateformatter.format(table.getDateTime("abdp_paydate")));
				}			
				DateLists.add(Info);
			}
			
		}
		finally
		{
			table.Close();
		}
		
		
		
		ResultXml.put("DateList",DateLists);
		
		response.setContentType("application/json;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");  
		response.getWriter().print(ResultXml.toString());
		response.getWriter().flush();
        
        
	}
}
