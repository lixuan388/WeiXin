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
@WebServlet("/BackStage/GetBaseParameter")
public class BaseParameterGetServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BaseParameterGetServlet() {
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

		String id =request.getParameter("id")==null?"":request.getParameter("id");
		if (id.equals(""))
		{
			String ErrText="错误的参数，无法操作！(id)";
			GlobalVariable.WriteMsgText(response, -101, ErrText);
			return;
		}	
	    
		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();     

				
		
		MySQLTable table=new MySQLTable("select * from abp_base_parameter where abp_name='"+id+"'");
		table.Open();
		if (table.next())
		{
			net.sf.json.JSONObject DateJson = new net.sf.json.JSONObject();     
			DateJson.put("Name",table.getString("abp_name"));
			DateJson.put("Value",table.getString("abp_value"));
			ResultXml.put("DataRows",DateJson);
		}
		else
		{
			net.sf.json.JSONObject DateJson = new net.sf.json.JSONObject();     
			DateJson.put("Name",id);
			DateJson.put("Value","");
			ResultXml.put("DataRows",DateJson);
		}

		table.Close();

		response.getWriter().print(ResultXml.toString());
		response.getWriter().flush();
	}


}
