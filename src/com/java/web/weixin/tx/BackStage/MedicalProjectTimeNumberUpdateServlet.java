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
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/BackStage/PostMedicalProjectTimeNumber")
public class MedicalProjectTimeNumberUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MedicalProjectTimeNumberUpdateServlet() {
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

    	MySQLUpdate SqlUpdate=new MySQLUpdate();
	    
	    int Length=0;
		try {
			Length = DataJson.getJSONArray("DataRows").length();
		} catch (JSONException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		

		SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyy-MM-dd");
		String BeginDateStr =formatter1.format(new Date());
		Date EndDate=new Date();
		EndDate.setTime(new Date().getTime()+1000*60*60*24*8);
		String EndDateStr =formatter1.format(EndDate);
		
		
	    
	    
	    for (int i =0;i<Length;i++)
	    {
	    	JSONObject DataJsonChild=null;
			try {
				DataJsonChild = DataJson.getJSONArray("DataRows").getJSONObject(i);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    	int atn_id;	        
	    	try {
	    		atn_id=DataJsonChild.getInt("id");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(id)");
				return ;
			}
	        
	    	
	    	int atn_id_amp;	        
	    	try {
	    		atn_id_amp=DataJsonChild.getInt("mp");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(mp)");
				return ;
			}
	    	int atn_number;	
	    	try {
	    		atn_number=DataJsonChild.getInt("number");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(number)");
				return ;
			}
	    	String atn_time;
	    	try {
	    		atn_time=DataJsonChild.getString("time");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(time)");
				return ;
			}
	    	int atn_week;
	    	try {
	    		atn_week=DataJsonChild.getInt("week");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(week)");
				return ;
			}

	    	table.SQL("select * from  atn_time_number where atn_id="+atn_id);
	    	table.Open();
	    	if (!table.next())
	    	{
	    		table.moveToInsertRow();
	    		table.updateString("_Status", "I");
	    		table.updateString("_User_Ins", GlobalVariable.GetMemberID(request));
	    		table.updateDateTime("_Date_Ins",new Date());
	    		table.updateString("atn_time", atn_time);
	    		table.updateInt("atn_week", atn_week);
	    		table.updateInt("atn_id_amp", atn_id_amp);
	    	}
	    	else
	    	{
	    		table.updateString("_Status", "E");
	    		table.updateString("_User_Lst", GlobalVariable.GetMemberID(request));
	    		table.updateDateTime("_Date_Lst",new Date());
	    	}
	    	//table.updateInt("amps_id", amps_id);
	    	table.updateInt("atn_number", atn_number);
	    	table.PostRow();
	    	
	    	SqlUpdate.Update("update abd_bookingdatetime set abd_number ="+atn_number+",abd_MaxBooking =abd_ModifyBooking + "+atn_number+
	    				",_Status='E',_Date_Lst=now(),_User_Lst='"+GlobalVariable.GetMemberID(request)+
	    				"' where _Status<>'D' and abd_bookingdatetime like '%"+atn_time+"'"+
	    				" and abd_id_amp="+atn_id_amp+
	    				" and date_format(abd_BookingDate,'%w')="+atn_week+
	    				" and datediff(abd_bookingDate,now())>=0 and datediff(abd_bookingDate,now())<=8"+
	    				" and abd_MaxBooking<>"+atn_number);
	    	SqlUpdate.Close();	    	
	    }
	    
	    GlobalVariable.WriteMsgText(response, 1,"数据保存成功！");    
	    
	}


}
