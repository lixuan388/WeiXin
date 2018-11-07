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
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/notice/SaveNoticeData.json")
public class SaveNoticeDataServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SaveNoticeDataServlet() {
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

		String anl_type;
		try {
			anl_type=DataJson.getString("type");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			GlobalVariable.WriteMsgText(response, -1, "json数据错误！(type)");
			return ;
		}

		String anl_time;
		try {
			anl_time=DataJson.getString("time");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			GlobalVariable.WriteMsgText(response, -1, "json数据错误！(time)");
			return ;
		}

		String anl_remark;
		try {
			anl_remark=DataJson.getString("remark");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			GlobalVariable.WriteMsgText(response, -1, "json数据错误！(remark)");
			return ;
		}

		String anl_flag;
		try {
			anl_flag=DataJson.getString("flag");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			GlobalVariable.WriteMsgText(response, -1, "json数据错误！(flag)");
			return ;
		}
		MySQLTable table=new MySQLTable();
		
		table.SQL("select * from anl_noticelist where anl_id='"+anl_id+"'");
		try
		{
		table.Open();
			if (!table.next())
			{
				table.moveToInsertRow();
				table.updateString("_Status", "I");
				table.updateString("_SyncFlag", "0");
				table.updateString("_User_Ins", GlobalVariable.GetMemberID(request));
				table.updateDateTime("_Date_Ins",new Date());
				table.updateString("anl_id", anl_id);
			}
			else
			{
				table.updateString("_Status", "E");
				table.updateString("_SyncFlag", "0");
				table.updateString("_User_Lst", GlobalVariable.GetMemberID(request));
				table.updateDateTime("_Date_Lst",new Date());
			}
			table.updateString("anl_type", anl_type);
			table.updateString("anl_time", anl_time);
			table.updateString("anl_type", anl_type);
			table.updateString("anl_flag", anl_flag);
			table.updateString("anl_remark", anl_remark);
			table.PostRow();
		}
		finally
		{
			table.Close();
		}
		
		MySQLUpdate update=new MySQLUpdate();
		update.Update("delete from anr_noticeRead where anr_id_anl='"+anl_id+"'");
		update.Close();

		GlobalVariable.WriteMsgText(response, 1,"数据保存成功！");	
		
	}


}
