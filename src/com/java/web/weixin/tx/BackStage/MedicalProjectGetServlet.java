package com.java.web.weixin.tx.BackStage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.table.MySQLTable;

@WebServlet("/BackStage/GetMedicalProjectInfo")
public class MedicalProjectGetServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		System.out.println("GetMedicalProjectInfo");
		
		MySQLTable table=new MySQLTable("select * from amp_medical_project where _Status<>'D'");
		table.Open();
		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();
        List<HashMap> RowsInfo = new ArrayList<HashMap>();
        
        while (table.next()) {
            HashMap<String, String> RowInfo = new HashMap<String, String>();
            RowInfo.put("id",""+table.getInt("amp_id"));
            RowInfo.put("Name",""+table.getString("amp_Name"));
            RowInfo.put("NameSht",""+table.getString("amp_NameSht"));
            RowInfo.put("Remark",""+table.getString("amp_Remark"));
            RowInfo.put("Useflag",""+table.getBoolean("amp_Useflag"));
            RowInfo.put("Money",""+table.getDouble("amp_Money"));
            RowInfo.put("Money2",""+table.getDouble("amp_Money2"));
            RowInfo.put("MaxDay",""+table.getInt("amp_MaxDay"));
            
            RowsInfo.add(RowInfo);
        }             
        ResultXml.put("DataRows",RowsInfo);
        table.Close();
        
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

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		super.doGet(req, resp);
	}

	
	
}
