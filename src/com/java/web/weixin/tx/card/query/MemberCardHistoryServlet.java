package com.java.web.weixin.tx.card.query;



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
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.jssdk.WXSnsapiBaseCode;
import com.java.web.weixin.jssdk.WXUserInfo;
import com.java.web.weixin.tx.Class.booking.TMedicalProjectList.TMedicalProjectListItem;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/card/MemberCardHistoryQuery")
public class MemberCardHistoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberCardHistoryServlet() {
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

		net.sf.json.JSONObject ReturnJson = new net.sf.json.JSONObject();		

		Map<String, String[]> params = request.getParameterMap();
		String AmcID =params.get("ID")==null?"":(String)(params.get("ID")[0]);
		
		
				
		try
		{
			if (AmcID.equals(""))
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","无【卡号】信息！");				
				return;
			}
			
			MySQLTable history =new MySQLTable(" select * from amch_member_card_history where amch_id_amc='"+AmcID+"' order by amch_date desc");

			net.sf.json.JSONArray DatasJson = new net.sf.json.JSONArray();	

			java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			try
			{
				history.Open();
				while (history.next())
				{
					net.sf.json.JSONObject DataJson = new net.sf.json.JSONObject();	
					DataJson.put("ID", history.getString("amch_id"));
					DataJson.put("Status", history.getString("_status"));
					DataJson.put("Type", history.getString("amch_Type"));
					DataJson.put("Date",format.format(history.getDateTime("amch_Date")));
					DataJson.put("Count", history.getString("amch_Count"));
					DataJson.put("Money", history.getInt("amch_Money"));
					DatasJson.add(DataJson);					
				}
				
				ReturnJson.put("Data",DatasJson);
				ReturnJson.put("MsgID","1");
				ReturnJson.put("MsgTest","Success！");				  
			}
			finally
			{
				history.Close();
			}
			
			
			
		}
		finally
		{
			response.getWriter().print(ReturnJson.toString());
			response.getWriter().flush();	
		}
	}
}
