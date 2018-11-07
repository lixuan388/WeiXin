package com.java.web.weixin.tx.notice;



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
@WebServlet("/notice/GetNoticeList.json")
public class GetNoticeListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetNoticeListServlet() {
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
		
		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();     
		net.sf.json.JSONArray DateLists = new net.sf.json.JSONArray();  
		
		ResultXml.put("MsgID","1");
		MySQLTable table=new MySQLTable("select * from anl_noticelist where datediff(anl_time,now())>=0 order by anl_time" );

		table.Open();
		while (table.next())
		{ 

			SimpleDateFormat formatter; 
			formatter = new SimpleDateFormat ("yyyy-MM-dd");
			String StringDate =formatter.format(table.getDateTime("anl_time"));
			
			net.sf.json.JSONObject Info = new net.sf.json.JSONObject();  
			Info.put("id",table.getString("anl_id"));
			Info.put("time",StringDate);
			Info.put("type",table.getString("anl_type"));
			Info.put("flag",table.getString("anl_flag"));
			Info.put("remark",table.getString("anl_remark"));
			DateLists.add(Info);
		}
		ResultXml.put("Data",DateLists);
		table.Close();
		
		response.setContentType("application/json;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");  
		response.getWriter().print(ResultXml.toString());
		response.getWriter().flush();
        
        
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(req, resp);
	}
	
	
}
