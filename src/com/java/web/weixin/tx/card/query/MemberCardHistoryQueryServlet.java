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
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.jssdk.WXSnsapiBaseCode;
import com.java.web.weixin.jssdk.WXUserInfo;
import com.java.web.weixin.tx.Class.booking.TMedicalProjectList.TMedicalProjectListItem;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/card/query/MemberCardHistoryQuery")
public class MemberCardHistoryQueryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberCardHistoryQueryServlet() {
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
			
			String SqlString ="select * from amc_member_card,amch_member_card_history where amc_id=amch_id_amc and amc_member_card._status<>'D' and   amch_Date >='"+BeginDate+"' and amch_Date<='"+EndDate+" 23:59:59'  ";
			if (!GuestName.equals(""))
			{
				SqlString=SqlString+" and amc_GuestName='"+GuestName+"' ";
			}
			if (!GuestTel.equals(""))
			{
				SqlString=SqlString+" and amc_GuestTel='"+GuestTel+"' ";
			}	
					

			SqlString=SqlString+" order by amc_id,amch_Date";
			
			net.sf.json.JSONArray DatasJson = new net.sf.json.JSONArray();	

			java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");
			
			System.out.println(SqlString);
			MySQLTable query=new MySQLTable(SqlString);
			try
			{
				query.Open();
				while (query.next())
				{
					net.sf.json.JSONObject DataJson = new net.sf.json.JSONObject();	
					DataJson.put("CardID", query.getString("amc_ID"));
					DataJson.put("Name", query.getString("amc_GuestName"));
					DataJson.put("Tel", query.getString("amc_GuestTel"));
					DataJson.put("Type", query.getString("amch_Type"));
					DataJson.put("Date",format.format(query.getDateTime("amch_Date")));
					DataJson.put("Count", query.getString("amch_Count"));
					DataJson.put("Money", query.getString("amch_Money"));

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
