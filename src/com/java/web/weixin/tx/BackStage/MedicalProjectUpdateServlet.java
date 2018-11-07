package com.java.web.weixin.tx.BackStage;

import java.io.BufferedReader;
import java.io.IOException;
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

import com.java.sql.table.MySQLTable;
import com.java.web.weixin.base.GlobalVariable;

@WebServlet("/BackStage/PostMedicalProjectInfo")
public class MedicalProjectUpdateServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		super.doGet(req, resp);
		
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		System.out.println("PostMedicalProjectInfo");
		

		
		BufferedReader bufferReader = req.getReader();

		
		StringBuffer buffer = new StringBuffer();
		String line = " ";
		while ((line = bufferReader.readLine()) != null) {
			buffer.append(line);
		}
		
		System.out.println(buffer.toString());
		JSONObject DataJson=null;
		try {
			DataJson=new JSONObject(buffer.toString());
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			GlobalVariable.WriteMsgText(resp, -1, "json错误！");
			return ;
		}
		int amp_id;
		try {
			amp_id=DataJson.getJSONArray("DataRows").getJSONObject(0).getInt("id");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();

			GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(id)");
			return ;
		}
		String amp_Name;
		try {
			amp_Name=DataJson.getJSONArray("DataRows").getJSONObject(0).getString("Name");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();

			GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(Name)");
			return ;
		}
		String amp_NameSht;
		try {
			amp_NameSht=DataJson.getJSONArray("DataRows").getJSONObject(0).getString("NameSht");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();

			GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(NameSht)");
			return ;
		}
		String amp_Remark;
		try {
			amp_Remark=DataJson.getJSONArray("DataRows").getJSONObject(0).getString("Remark");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		
			GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(Remark)");
			return ;
		}
		boolean amp_Useflag;
		try {
			amp_Useflag=DataJson.getJSONArray("DataRows").getJSONObject(0).getBoolean("Useflag");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
	
			GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(Useflag)");
			return ;
		}
		double amp_Money;
		try {
			amp_Money=DataJson.getJSONArray("DataRows").getJSONObject(0).getDouble("Money");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
	
			GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(Money)");
			return ;
		}
		

		double amp_Money2;
		try {
			amp_Money2=DataJson.getJSONArray("DataRows").getJSONObject(0).getDouble("Money2");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
	
			GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(Money2)");
			return ;
		}
		

		int amp_MaxDay;
		try {
			amp_MaxDay=DataJson.getJSONArray("DataRows").getJSONObject(0).getInt("MaxDay");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();

			GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(MaxDay)");
			return ;
		}
		
		
		MySQLTable table=new MySQLTable("select * from amp_medical_project where amp_id="+amp_id);
		table.Open();
		if (table.next())
		{
			table.updateString("_Status","E");
			table.updateString("_User_Lst",GlobalVariable.GetMemberID(req));
			table.updateDateTime("_Date_Lst", new java.sql.Date(new Date().getTime()));
			table.updateString("amp_Name",amp_Name);
			table.updateString("amp_NameSht",amp_NameSht);
			table.updateString("amp_Remark",amp_Remark);
			table.updateBoolean("amp_Useflag",amp_Useflag);
			table.updateDouble("amp_Money",amp_Money);
			table.updateDouble("amp_Money2",amp_Money2);
			table.updateDouble("amp_MaxDay",amp_MaxDay);
			table.updateBoolean("_SyncFlag",false);
			table.updateRow();
		}
		else if (amp_id==-1)
		{
			table.moveToInsertRow();
			table.updateString("_Status","I");
			table.updateString("_User_Ins",GlobalVariable.GetMemberID(req));
			table.updateDateTime("_Date_Ins", new java.sql.Date(new Date().getTime()));
			table.updateString("amp_Name",amp_Name);
			table.updateString("amp_NameSht",amp_NameSht);
			table.updateString("amp_Remark",amp_Remark);
			table.updateBoolean("amp_Useflag",amp_Useflag);
			table.updateDouble("amp_Money",amp_Money);
			table.updateDouble("amp_Money2",amp_Money2);
			table.updateDouble("amp_MaxDay",amp_MaxDay);
			table.updateBoolean("_SyncFlag",false);
			table.insertRow();
			
		}
		else
		{
			GlobalVariable.WriteMsgText(resp, -1, "记录不存在！(d="+amp_id+")");
			return;
		}			 
		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();	  
		ResultXml.put("MsgID","1");
		ResultXml.put("MsgText","数据保存成功！");
		
		try {
			resp.setContentType("application/json;charset=utf-8"); 
			resp.setCharacterEncoding("UTF-8");  
			resp.setHeader("Cache-Control", "no-cache");  
			resp.getWriter().print(ResultXml.toString());
			resp.getWriter().flush();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	
	
}
