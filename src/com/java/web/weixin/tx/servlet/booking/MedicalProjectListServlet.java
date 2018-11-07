package com.java.web.weixin.tx.servlet.booking;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.table.MySQLTable;
import com.java.web.weixin.tx.Class.booking.TMedicalProjectList;

/**
 * Servlet implementation class MedicalProjectListServlet
 */
@WebServlet("/booking/MedicalProjectList.json")
public class MedicalProjectListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MedicalProjectListServlet() {
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
		
		String amb_Level=(String)request.getSession().getAttribute("amb_Level");

		net.sf.json.JSONObject ReturnJson = new net.sf.json.JSONObject();
		
		try
		{
			TMedicalProjectList MedicalProjectList=new TMedicalProjectList();
			if (MedicalProjectList.ErrCode!=1)
			{
				ReturnJson.put("MsgID",MedicalProjectList.ErrCode);
				ReturnJson.put("MsgText",MedicalProjectList.ErrText);
				return;
			}
			
			net.sf.json.JSONArray DatasJson = new net.sf.json.JSONArray();	

			for (int i=0;i<MedicalProjectList.Length();i++)
			{
				net.sf.json.JSONObject DataJson = new net.sf.json.JSONObject();
				
				DataJson.put("Name", MedicalProjectList.GetItem(i).Name);
				DataJson.put("NameSht", MedicalProjectList.GetItem(i).NameSht);
				DataJson.put("Remark", MedicalProjectList.GetItem(i).Remark);
				DataJson.put("Level",amb_Level);

				if (amb_Level.equals("2"))
				{
					DataJson.put("Money",MedicalProjectList.GetItem(i).Money2);
				}
				else
				{
					DataJson.put("Money",MedicalProjectList.GetItem(i).Money);
				}
				DataJson.put("ID", MedicalProjectList.GetItem(i).ID);
				DataJson.put("index", i);
				DatasJson.add(DataJson);
			}
			ReturnJson.put("Data",DatasJson);
			ReturnJson.put("MsgID","1");
			ReturnJson.put("MsgText","Success！");
			
		}
		finally
		{
			response.getWriter().print(ReturnJson.toString());
			response.getWriter().flush();	
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
