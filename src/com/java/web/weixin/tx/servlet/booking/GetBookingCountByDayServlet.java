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
@WebServlet("/booking/GetBookingCountByDay.json")
public class GetBookingCountByDayServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetBookingCountByDayServlet() {
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


		SimpleDateFormat formatter; 
		formatter = new SimpleDateFormat ("yyyy-MM-dd");
		String date =formatter.format(new Date());	


		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();     

		for (int i =0;i<8;i++)
		{
			ResultXml.put("Day"+i,"0");
		}
		
		MySQLTable table=new MySQLTable("select datediff(abd_BookingDateTime,now()) as BookDayOff,count(0) as c \r\n" + 
				"from abdp_bookingdatetime_pay,abd_bookingdatetime \r\n" + 
				"where abdp_id_abd=abd_id and abd_BookingDate>='"+date+"'\r\n" + 
				"and abdp_bookingdatetime_pay._status<>'D'\r\n" + 
				"group by datediff(abd_BookingDateTime,now())\r\n");

		table.Open();
		while (table.next())
		{
			ResultXml.put("Day"+table.getString("BookDayOff"),table.getString("c"));
		}
		table.Close();		

		response.getWriter().print(ResultXml.toString());
		response.getWriter().flush();
        
        
	}
}
