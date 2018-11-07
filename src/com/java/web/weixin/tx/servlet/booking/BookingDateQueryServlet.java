package com.java.web.weixin.tx.servlet.booking;



import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
import com.java.web.weixin.tx.Class.booking.TMedicalProjectList.TMedicalProjectListItem;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/booking/BookingDateQuery.json")
public class BookingDateQueryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookingDateQueryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("application/json;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");

		net.sf.json.JSONObject ReturnJson = new net.sf.json.JSONObject();		

		Map<String, String[]> params = request.getParameterMap();
		String GuestName =params.get("GuestName")==null?"":(String)(params.get("GuestName")[0]);
		String GuestTel =params.get("GuestTel")==null?"":(String)(params.get("GuestTel")[0]);		
		String BeginDate =params.get("BeginDate")==null?"":(String)(params.get("BeginDate")[0]);		
		String EndDate =params.get("EndDate")==null?"":(String)(params.get("EndDate")[0]);		

		
		try
		{
			if (BeginDate.equals(""))
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","无【开始日期】信息！");				
				return;
			}
			if (EndDate.equals(""))
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","无【结束日期】信息！");
				return;
			}		
			
			String SqlString="select abdp_guestname,abdp_guesttel,abd_BookingDateTime,amp_Name,amc_id,abdp_checkin \r\n" + 
			    "from abdp_bookingdatetime_pay,abd_bookingdatetime,amp_medical_project,amc_member_card\r\n" + 
			    "where abdp_id_abd=abd_id and abd_id_amp=amp_id and abdp_id_amb=amc_id_amb\r\n"+
			    " and abd_BookingDateTime >='"+BeginDate+"' and abd_BookingDateTime<='"+EndDate+" 23:59:59'";

			if (!GuestName.equals(""))
			{
				SqlString=SqlString+" and abdp_guestname='"+GuestName+"' ";
			}
			if (!GuestTel.equals(""))
			{
				SqlString=SqlString+" and abdp_guesttel='"+GuestTel+"' ";
			}	
			
			SqlString=SqlString+" order by abd_BookingDateTime";
					

			net.sf.json.JSONArray DatasJson = new net.sf.json.JSONArray();	

			java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
			
//			System.out.println(SqlString);
			MySQLTable query=new MySQLTable(SqlString);
			try
			{
				query.Open();
				while (query.next())
				{
					net.sf.json.JSONObject DataJson = new net.sf.json.JSONObject();	
					DataJson.put("Name", query.getString("abdp_guestname"));
					DataJson.put("Tel", query.getString("abdp_guesttel"));
					DataJson.put("BookingDate",format.format(query.getDateTime("abd_BookingDateTime")));
					DataJson.put("MedicalProject",query.getString("amp_Name"));
					DataJson.put("ID", query.getString("amc_id"));
					DataJson.put("checkin", query.getString("abdp_checkin"));

					DatasJson.add(DataJson);
				}
				

				ReturnJson.put("Data",DatasJson);
				ReturnJson.put("MsgID","1");
				ReturnJson.put("MsgTest","Success！");
				  
			}
			finally
			{
				query.Close();
			}
			
		}
		finally
		{
			response.getWriter().print(ReturnJson.toString());
			response.getWriter().flush();	
		}
	}
}
