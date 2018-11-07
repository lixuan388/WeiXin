package com.java.web.weixin.tx.notice;



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
@WebServlet("/notice/ReadNoticeData.json")
public class ReadNoticeDataServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ReadNoticeDataServlet() {
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

//		System.out.println("---");
//		System.out.println(buffer.toString());
//		System.out.println("---");
		
		JSONObject DataJson=null;
		try {
			DataJson=new JSONObject(buffer.toString());
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			GlobalVariable.WriteMsgText(response, -1, "json错误！");
			return ;
		}
		
		String anl_id;
		try {
			anl_id=DataJson.getString("id");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			GlobalVariable.WriteMsgText(response, -1, "json数据错误！(id)");
			return ;
		}

		String UserID=GlobalVariable.GetMemberID(request);
		MySQLTable table=new MySQLTable();
		
		table.SQL("select * from anr_noticeRead where anr_id_anl='"+anl_id+"' and anr_id_amb='"+UserID+"'");
		try
		{
		table.Open();
			if (!table.next())
			{
				table.moveToInsertRow();

				table.updateString("anr_id", GlobalVariable.GUIDString());
				table.updateString("_Status", "I");
				table.updateString("_SyncFlag", "0");
				table.updateString("_User_Ins", GlobalVariable.GetMemberID(request));
				table.updateDateTime("_Date_Ins",new Date());
				table.updateString("anr_id_amb", UserID);
				table.updateString("anr_id_anl", anl_id);
				table.PostRow();
				
			}
		}
		finally
		{
			table.Close();
		}

		System.out.println("标记已读，"+anl_id);
		for (int i =1;i<=3;i++)
		{
			String anl_id2=request.getSession().getAttribute("Notice"+i)==null?"":(String)request.getSession().getAttribute("Notice"+i);
			System.out.println("Notice"+i+":"+anl_id2);
			if (anl_id.equals(anl_id2))
			{
				request.getSession().setAttribute("Notice"+i,"");
				System.out.println("标记已读，Notice"+i);
			}
		}
		GlobalVariable.WriteMsgText(response, 1,"数据保存成功！");	
		
	}


}
