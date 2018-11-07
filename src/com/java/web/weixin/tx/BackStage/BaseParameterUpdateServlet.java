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
@WebServlet("/BackStage/PostBaseParameter")
public class BaseParameterUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BaseParameterUpdateServlet() {
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
	    	
	    	String abp_name;	        
	    	try {
	    		abp_name=DataJsonChild.getString("Name");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(Name)");
				return ;
			}
	        
	    	
	    	String abp_value;	        
	    	try {
	    		abp_value=URLDecoder.decode(DataJsonChild.getString("Value"),"utf-8");
//	    		System.out.println(abp_value);
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(Value)");
				return ;
			}
	    	table.SQL("select * from abp_base_parameter where abp_name='"+abp_name+"'");
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
	    	table.updateString("abp_name", abp_name);
	    	table.updateString("abp_value", abp_value);
	    	table.PostRow();
	    	System.setProperty("WeiXin.tx."+abp_name,abp_value);
	    }
	    GlobalVariable.WriteMsgText(response, 1,"数据保存成功！");
	    
	}


}
