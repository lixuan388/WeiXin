package com.java.web.weixin.tx.servlet.booking;



import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.table.MySQLTable;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/booking/BlackListQueryQuery.json")
public class BlackListQueryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BlackListQueryServlet() {
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
		
		try
		{
			
			String SqlString="select amb_id,amb_name,amb_tel,amb_levelvalue \r\n" + 
					",ifnull((select amc_guestname from amc_member_card where amc_id_amb=amb_id limit 1),'') as amc_guestname\r\n" + 
					",ifnull((select amc_guesttel from amc_member_card where amc_id_amb=amb_id limit 1),'') as amc_guesttel\r\n" + 
					",ifnull((select amc_id from amc_member_card where amc_id_amb=amb_id limit 1 ),'')  as amc_id\r\n" + 
					"from amb_member where amb_level=2\r\n" + 
					"order by amb_name";
			net.sf.json.JSONArray DatasJson = new net.sf.json.JSONArray();	
			MySQLTable query=new MySQLTable(SqlString);
			try
			{
				query.Open();
				while (query.next())
				{
					net.sf.json.JSONObject DataJson = new net.sf.json.JSONObject();	
					DataJson.put("Name", query.getString("amb_name"));
					DataJson.put("Tel", query.getString("amb_tel"));
					DataJson.put("GuestName", query.getString("amc_guestname"));
					DataJson.put("GuestTel", query.getString("amc_guesttel"));
					DataJson.put("ID",query.getString("amb_id"));
					DataJson.put("AmcID",query.getString("amc_id"));
					DataJson.put("levelvalue",query.getString("amb_levelvalue"));

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
