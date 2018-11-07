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

@WebServlet("/BackStage/ChangeDate")
public class ChangeDateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChangeDateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub


		String id =request.getParameter("id")==null?"":request.getParameter("id");
		
		if (id.equals(""))
		{
			String ErrText="参数错误！(id)";			
			GlobalVariable.WriteMsgText(response,-1,ErrText);
			return;
		}

		String code =request.getParameter("code")==null?"":request.getParameter("code");
		if (code.equals(""))
		{
			String ErrText="参数错误！(code)";
			GlobalVariable.WriteMsgText(response,-1,ErrText);
			return;
		}

		MySQLTable abdp=new MySQLTable("select abdp_id_abd,abdp_money,abdp_id,abdp_urlcode" + 
				"		from abdp_bookingdatetime_pay where abdp_urlcode='"+code+"'");
		
		MySQLTable abd=new MySQLTable("select amp_money,abd_id " + 
				"		from abd_bookingdatetime,amp_medical_project " + 
				"		where abd_id_amp=amp_id and  abd_id="+id);
		try
		{
			abdp.Open();
			if (!abdp.next())
			{
				String ErrText="无订单信息！";
				GlobalVariable.WriteMsgText(response,-1,ErrText);
				return;
			}
			abd.Open();
			if (!abd.next())
			{
				String ErrText="无项目信息！";
				GlobalVariable.WriteMsgText(response,-1,ErrText);
				return;
			}
			
			if (!abdp.getString("abdp_money").equals(abd.getString("amp_money")))
			{
				String ErrText="已付款金额与新项目挂号所需金额不一致，不可调整！";
				GlobalVariable.WriteMsgText(response,-1,ErrText);
				return;
			}
			String Old_abd_id=abdp.getString("abdp_id_abd");
			String New_abd_id=abd.getString("abd_id");
			int abdp_id=abdp.getInt("abdp_id");
			System.out.println("Old:"+Old_abd_id+";New:"+New_abd_id);
//			abdp.updateString("abdp_id_abd", New_abd_id);
//			abdp.PostRow();

			MySQLUpdate update=new MySQLUpdate();
//			String Sql="update abd_bookingdatetime set abd_hasbooking=abd_hasbooking+1 where abd_id="+New_abd_id+";\r\n" +
//					"update abd_bookingdatetime set abd_hasbooking=abd_hasbooking-1 where abd_id="+Old_abd_id+";\r\n" + 
//					"update abdp_bookingdatetime_pay set abdp_id_abd="+New_abd_id+" where abdp_id="+abdp_id+";";
//			System.out.println(Sql);
			update.Update("update abd_bookingdatetime set abd_hasbooking=abd_hasbooking+1,_SyncFlag=0 where abd_id="+New_abd_id+";\r\n"); 
			update.Update("update abd_bookingdatetime set abd_hasbooking=abd_hasbooking-1,_SyncFlag=0 where abd_id="+Old_abd_id+";\r\n"); 
			update.Update("update abdp_bookingdatetime_pay set abdp_id_abd="+New_abd_id+",_SyncFlag=0 where abdp_id="+abdp_id+";"); 


		    GlobalVariable.WriteMsgText(response, 1,"日期调整成功！");
			
		}
		finally
		{
			abdp.Close();
			abd.Close();
		}	    
	}


}
