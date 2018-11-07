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
@WebServlet("/BackStage/PostMedicalProjectTimeModifyNumber")
public class MedicalProjectTimeModifyNumberUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MedicalProjectTimeModifyNumberUpdateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub


		String groupid=request.getSession().getAttribute("groupid")==null?"0":(String)request.getSession().getAttribute("groupid");
		if (!groupid.equals("100") && !groupid.equals("101"))
		{
			String ErrText="权限错误，无法操作！";
			GlobalVariable.WriteMsgText(response, -100, ErrText);
			return;
		}
		

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
			
	    
	    
	    for (int i =0;i<Length;i++)
	    {
	    	JSONObject DataJsonChild=null;
			try {
				DataJsonChild = DataJson.getJSONArray("DataRows").getJSONObject(i);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    	int abd_id;	        
	    	try {
	    		abd_id=DataJsonChild.getInt("id");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(id)");
				return ;
			}
	        
	    	
	    	int abd_ModifyBooking;	        
	    	try {
	    		abd_ModifyBooking=DataJsonChild.getInt("Modify");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				GlobalVariable.WriteMsgText(response, -1, "json数据错误！(Modify)");
				return ;
			}

	    	table.SQL("select * from  abd_bookingdatetime where abd_id="+abd_id);
	    	table.Open();
	    	if (!table.next())
	    	{

				GlobalVariable.WriteMsgText(response, -200, "ID错误，无对应的记录！");
				return ;
	    	}
	    	else
	    	{
	    		table.updateString("_Status", "E");
	    		table.updateString("_User_Lst", GlobalVariable.GetMemberID(request));
	    		table.updateDateTime("_Date_Lst",new Date());
	    	}

	    	int abd_MaxBooking=table.getInt("abd_number")+abd_ModifyBooking;
	    	int abd_HasBooking=table.getInt("abd_HasBooking");
	    	
	    	table.updateInt("abd_ModifyBooking", abd_ModifyBooking);
	    	table.updateInt("abd_MaxBooking",abd_MaxBooking);
	    	table.PostRow();
	    	
			net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();      
	        ResultXml.put("MsgID",""+1);
	        ResultXml.put("MsgText","数据保存成功！");
	        ResultXml.put("ID",""+abd_id);
	        ResultXml.put("MaxBooking",""+abd_MaxBooking);
	        ResultXml.put("ModifyBooking",""+abd_ModifyBooking);
	        ResultXml.put("HasBooking",""+abd_HasBooking);
	        try {
	        	response.setContentType("application/json;charset=utf-8"); 
	        	response.setCharacterEncoding("UTF-8");  
	        	response.setHeader("Cache-Control", "no-cache");  
	        	response.getWriter().print(ResultXml.toString());
	        	response.getWriter().flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        return;
	    }
	    
	}


}
