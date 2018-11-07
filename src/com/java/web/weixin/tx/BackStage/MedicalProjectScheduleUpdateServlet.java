package com.java.web.weixin.tx.BackStage;



import java.io.BufferedReader;
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

import org.json.JSONException;
import org.json.JSONObject;

import com.java.sql.SQLConnect;
import com.java.sql.table.MySQLTable;
import com.java.web.weixin.base.GlobalVariable;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/BackStage/PostMedicalProjectSchedule")
public class MedicalProjectScheduleUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MedicalProjectScheduleUpdateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub


	    BufferedReader bufferReader = request.getReader();

	    
	    StringBuffer buffer = new StringBuffer();
	    String line = " ";
	    while ((line = bufferReader.readLine()) != null) {
	        buffer.append(line);
	    }
		
//	    System.out.println(buffer.toString());
	    JSONObject DataJson=null;
	    try {
			DataJson=new JSONObject(buffer.toString());
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			GlobalVariable.WriteMsgText(response, -1, "json错误！");
			return ;
		}
	    
	    MySQLTable table=new MySQLTable();
	    
	    int Length=0;
		try {
			Length = DataJson.getJSONArray("DataRows").length();
		} catch (JSONException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
	    
	    
	    for (int i =0;i<Length;i++)
	    {
	    	JSONObject DataJsonChild=null;
			try {
				DataJsonChild = DataJson.getJSONArray("DataRows").getJSONObject(i);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    	int amps_id;	        
	    	try {
	    		amps_id=DataJsonChild.getInt("id");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(id)");
				return ;
			}
	        
	    	
	    	int amps_id_amp;	        
	    	try {
	    		amps_id_amp=DataJsonChild.getInt("mp");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(mp)");
				return ;
			}
	    	Date amps_date;	        
	    	try {

	    		SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyy-MM-dd");	    		
	    		try {
					amps_date = formatter1.parse(DataJsonChild.getString("date"));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					GlobalVariable.WriteMsgText(response, -1, "json数据错误！(date)");
					return ;
				}
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(date)");
				return ;
			}
	    	int amps_year;
	    	try {
	    		amps_year=DataJsonChild.getInt("year");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(year)");
				return ;
			}
	    	int amps_month;
	    	try {
	    		amps_month=DataJsonChild.getInt("month");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(month)");
				return ;
			}
	    	int amps_week;
	    	try {
	    		amps_week=DataJsonChild.getInt("week");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(week)");
				return ;
			}
	    	int amps_day;
	    	try {
	    		amps_day=DataJsonChild.getInt("day");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(day)");
				return ;
			}
	    	boolean amps_flag;

	    	try {
	    		amps_flag=DataJsonChild.getBoolean("flag");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(flag)");
				return ;
			}
	    	table.SQL("select * from amps_medical_project_schedule where amps_id="+amps_id);
	    	table.Open();
	    	if (!table.next())
	    	{
	    		table.moveToInsertRow();
	    		table.updateString("_Status", "I");
	    		table.updateString("_User_Ins", GlobalVariable.GetMemberID(request));
	    		table.updateDateTime("_Date_Ins",new Date());
	    	}
	    	else
	    	{
	    		table.updateString("_Status", "E");
	    		table.updateString("_User_Lst", GlobalVariable.GetMemberID(request));
	    		table.updateDateTime("_Date_Lst",new Date());
	    	}
	    	//table.updateInt("amps_id", amps_id);
	    	table.updateInt("amps_id_amp", amps_id_amp);
	    	table.updateDateTime("amps_date",amps_date);
	    	table.updateInt("amps_year", amps_year);
	    	table.updateInt("amps_month", amps_month);
	    	table.updateInt("amps_week", amps_week);
	    	table.updateInt("amps_day", amps_day);
	    	table.updateBoolean("amps_flag", amps_flag);
	    	table.PostRow();
	    }
	    GlobalVariable.WriteMsgText(response, 1,"数据保存成功！");    
	    
	}


}
