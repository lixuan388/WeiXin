package com.java.web.weixin.tx.BackStage;



import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
@WebServlet("/BackStage/GetMedicalProjectSchedule")
public class MedicalProjectScheduleGetServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MedicalProjectScheduleGetServlet() {
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

		String Year =request.getParameter("year")==null?"":request.getParameter("year");
		if (Year.equals(""))
		{
			String ErrText="错误的参数，无法操作！(Year)";
			GlobalVariable.WriteMsgText(response, -101, ErrText);
			return;
		}	

		String Month =request.getParameter("month")==null?"":request.getParameter("month");
		if (Month.equals(""))
		{
			String ErrText="错误的参数，无法操作！(Month)";
			GlobalVariable.WriteMsgText(response, -102, ErrText);
			return;
		}	

		String MP =request.getParameter("mp")==null?"":request.getParameter("mp");
		if (MP.equals(""))
		{
			String ErrText="错误的参数，无法操作！(MP)";
			GlobalVariable.WriteMsgText(response, -103, ErrText);
			return;
		}	
        
		SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyy-MM-dd");
		Date BeginDate = null;

		Date NowDate=null;
		try {
			BeginDate = formatter1.parse(Year+"-"+Month+"-01");
			NowDate = formatter1.parse(Year+"-"+Month+"-01");
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		SimpleDateFormat formatter2 = new SimpleDateFormat ("yyyyMMdd");
	    
		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();     
				
		while (NowDate.getMonth()==BeginDate.getMonth())
		{
			//System.out.println(formatter.format(NowDate));
			net.sf.json.JSONObject DateJson = new net.sf.json.JSONObject();     
			DateJson.put("id",-1);     
			DateJson.put("year",NowDate.getYear()+1900);    
			DateJson.put("month",NowDate.getMonth()+1);
			DateJson.put("day",NowDate.getDate());
			DateJson.put("week",NowDate.getDay());
			DateJson.put("mp",MP);
			DateJson.put("date",formatter1.format(NowDate));
			DateJson.put("name",formatter2.format(NowDate));
			switch (NowDate.getDay()) {
				case 3:
					DateJson.put("flag","false");
					break;
				default:
					DateJson.put("flag","true");
					break;
			}
//			DateJson.put("flag","false");
			ResultXml.put(formatter2.format(NowDate),DateJson);
			NowDate.setTime(NowDate.getTime()+1000*60*60*24);			
//			System.out.println(formatter2.format(NowDate));			
		}
		
		MySQLTable table=new MySQLTable("select * from amps_medical_project_schedule where amps_year="+Year+" and amps_month="+Month+" and amps_id_amp="+MP);
		table.Open();
		while (table.next())
		{
			NowDate=table.getDateTime("amps_date");
			net.sf.json.JSONObject DateJson=ResultXml.getJSONObject(formatter2.format(NowDate));
			DateJson.put("id",table.getInt("amps_id"));
			DateJson.put("flag",table.getBoolean("amps_flag"));
//			System.out.println("table:"+formatter2.format(NowDate));
		}
		table.Close();

		response.getWriter().print(ResultXml.toString());
		response.getWriter().flush();
	}


}
