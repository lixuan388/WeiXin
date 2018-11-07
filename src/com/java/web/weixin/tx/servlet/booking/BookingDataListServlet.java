package com.java.web.weixin.tx.servlet.booking;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.table.MySQLTable;
import com.java.web.weixin.tx.Class.booking.TMedicalProjectList;

/**
 * Servlet implementation class MedicalProjectListServlet
 */
@WebServlet("/booking/BookingDataListList.json")
public class BookingDataListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookingDataListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("application/json;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");

		String amb_Level=request.getSession().getAttribute("amb_Level")==null?"1":(String)request.getSession().getAttribute("amb_Level");
		
		
		net.sf.json.JSONObject ReturnJson = new net.sf.json.JSONObject();		
		try
		{
			net.sf.json.JSONArray DatasJson = new net.sf.json.JSONArray();	
			MySQLTable table=new MySQLTable("select abd_id,abd_id_amp,abd_bookingdate,abd_bookingdatetime,abd_maxbooking,ifnull(abd_hasBooking,0) as abd_hasbooking,amp_money,amp_money2\r\n" + 
					"from abd_BookingDatetime ,amps_medical_project_schedule,amp_medical_project\r\n" + 
					" where  abd_BookingDatetime._status<>'D' and amps_medical_project_schedule._status<>'D'\r\n" + 
					" and abd_id_amp=amps_id_amp and abd_bookingdate=amps_date\r\n" + 
					" and abd_id_amp=amp_id and abd_bookingdate=amps_date\r\n" + 
					" and abd_bookingdatetime>now()\r\n" + 
					" and abd_maxbooking>0\r\n" +
					" and amps_flag =1\r\n" + 
					"order by abd_id_amp,abd_bookingdatetime");
			try
			{
				table.Open();

				SimpleDateFormat DateFormat; 
				DateFormat = new SimpleDateFormat ("MM-dd");
				SimpleDateFormat TimeFormat; 
				TimeFormat = new SimpleDateFormat ("HH:mm");


				
				while (table.next())
				{
					//if (table.getInt("abd_maxbooking")-table.getInt("abd_hasbooking")>0)
					{
						net.sf.json.JSONObject DataJson = new net.sf.json.JSONObject();
						DataJson.put("id",table.getString("abd_id"));
						DataJson.put("ampID",table.getString("abd_id_amp"));
						DataJson.put("Date",DateFormat.format(table.getDateTime("abd_bookingdate")));
						DataJson.put("Time",TimeFormat.format(table.getDateTime("abd_bookingdatetime")));
						DataJson.put("Count", table.getInt("abd_maxbooking")-table.getInt("abd_hasbooking"));
						if (amb_Level.equals("1"))
						{
							DataJson.put("Money", table.getInt("amp_money"));
						}
						else
						{
							DataJson.put("Money", table.getInt("amp_money2"));
						}
						DatasJson.add(DataJson);
					}
				}
			}
			finally
			{
				table.Close();
			}
			ReturnJson.put("Data",DatasJson);
			ReturnJson.put("MsgID","1");
			ReturnJson.put("MsgText","Success！");
			
		}
		finally
		{
			response.getWriter().print(ReturnJson.toString());
			response.getWriter().flush();	
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
