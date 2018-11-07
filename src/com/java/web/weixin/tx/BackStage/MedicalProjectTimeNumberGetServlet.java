package com.java.web.weixin.tx.BackStage;



import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

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
@WebServlet("/BackStage/GetMedicalProjectTimeNumber")
public class MedicalProjectTimeNumberGetServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MedicalProjectTimeNumberGetServlet() {
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

//		String openid=request.getSession().getAttribute("openid")==null?"0":(String)request.getSession().getAttribute("openid");
//		if (openid.equals(""))
//		{
//			String ErrText="用户信息错误，无法操作！(openid)";
//			GlobalVariable.WriteMsgText(response, -103, ErrText);
//			return;
//		}
//		
//		String groupid=request.getSession().getAttribute("groupid")==null?"0":(String)request.getSession().getAttribute("groupid");
//		if (!groupid.equals("100"))
//		{
//			String ErrText="权限错误，无法操作！";
//			GlobalVariable.WriteMsgText(response, -100, ErrText);
//			return;
//		}

		String MP =request.getParameter("mp")==null?"":request.getParameter("mp");
		if (MP.equals(""))
		{
			String ErrText="错误的参数，无法操作！(MP)";
			GlobalVariable.WriteMsgText(response, -103, ErrText);
			return;
		}	

		String Week =request.getParameter("Week")==null?"":request.getParameter("Week");
		if (MP.equals(""))
		{
			String ErrText="错误的参数，无法操作！(Week)";
			GlobalVariable.WriteMsgText(response, -103, ErrText);
			return;
		}	
	    
		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();

        List<HashMap> RowsInfo = new ArrayList<HashMap>();				
		
		MySQLTable table=new MySQLTable("select * from atn_time_number where atn_id_amp="+MP+" and atn_week="+Week+" order by atn_time");
		table.Open();
		if (!table.next())
		{
			for (int i =9;i<21;i++)
			{
				//System.out.println(formatter.format(NowDate));
				String time = new DecimalFormat("00").format(i);
	            HashMap<String, String> DateJson1 = new HashMap<String, String>();		
				DateJson1.put("id","-1");     
				DateJson1.put("time",time+":00:00");   
				DateJson1.put("week",Week);    
				DateJson1.put("Number","0");
				DateJson1.put("mp",MP);
	            RowsInfo.add(DateJson1);				

	            HashMap<String, String> DateJson2 = new HashMap<String, String>();	
				DateJson2.put("id","-1");     
				DateJson2.put("time",time+":30:00");    
				DateJson2.put("week",Week);     
				DateJson2.put("Number","0");
				DateJson2.put("mp",MP);
	            RowsInfo.add(DateJson2);
			}
		}
		else 
		{
            HashMap<String, String> DateJson1 = new HashMap<String, String>();	
			DateJson1.put("id",""+table.getInt("atn_id"));     
			DateJson1.put("time",table.getString("atn_time"));
			DateJson1.put("week",table.getString("atn_week"));    
			DateJson1.put("Number",""+table.getInt("atn_number"));
			DateJson1.put("mp",""+table.getInt("atn_id_amp"));
            RowsInfo.add(DateJson1);	
            
			while (table.next())
			{
	            HashMap<String, String> DateJson2 = new HashMap<String, String>();	
				DateJson2.put("id",""+table.getInt("atn_id"));     
				DateJson2.put("time",table.getString("atn_time"));
				DateJson2.put("week",table.getString("atn_week"));    
				DateJson2.put("Number",""+table.getInt("atn_number"));
				DateJson2.put("mp",""+table.getInt("atn_id_amp"));
	            RowsInfo.add(DateJson2);		
			}
		}
		table.Close();

        ResultXml.put("DataRows",RowsInfo);
		response.getWriter().print(ResultXml.toString());
		response.getWriter().flush();
        
	    	
	    
	    
	}


}
