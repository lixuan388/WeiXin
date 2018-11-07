package com.java.web.weixin.tx.servlet.booking;



import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.SQLConnect;
import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/booking/BookingDateManualEntry.json")
public class BookingDateManualEntryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookingDateManualEntryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("application/json;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");


		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();      

		String groupid=request.getSession().getAttribute("groupid")==null?"0":(String)request.getSession().getAttribute("groupid");
		if (!groupid.equals("100") && !groupid.equals("101"))
		{
			String ErrText="权限错误，无法操作！";
			GlobalVariable.WriteMsgText(response, -100, ErrText);
			return;
		}
		

		Map<String, String[]> params = request.getParameterMap();	
		
//		String abdp_id_abd =params.get("AbdID")==null?"":(String)(params.get("AbdID")[0]);		
//		if (abdp_id_abd.equals(""))
//		{
//			String ErrText="错误的参数，无法操作！(AbdID)";
//			GlobalVariable.WriteMsgText(response,-1,ErrText);
//			return;
//		}
		String abdp_id_abd ="0";		
		
		String abdp_GuestName =params.get("GuestName")==null?"":(String)(params.get("GuestName")[0]);		
		if (abdp_GuestName.equals(""))
		{
			String ErrText="错误的参数，无法操作！(GuestName)";
			GlobalVariable.WriteMsgText(response,-1,ErrText);
			return;
		}
		
		String abdp_GuestTel =params.get("GuestTel")==null?"":(String)(params.get("GuestTel")[0]);    
//  if (abdp_GuestTel.equals(""))
//  {
//    String ErrText="错误的参数，无法操作！(GuestTel)";
//    GlobalVariable.WriteMsgText(response,-1,ErrText);
//    return;
//  }
		String CheckIn =params.get("CheckIn")==null?"1":(String)(params.get("CheckIn")[0]);    
//  if (abdp_GuestTel.equals(""))
//  {
//    String ErrText="错误的参数，无法操作！(GuestTel)";
//    GlobalVariable.WriteMsgText(response,-1,ErrText);
//    return;
//  }
		
		String abdp_id_amb =params.get("AmbID")==null?"":(String)(params.get("AmbID")[0]);		
		if (abdp_id_amb.equals(""))
		{
			String ErrText="错误的参数，无法操作！(AmbID)";
			GlobalVariable.WriteMsgText(response,-1,ErrText);
			return;
		}
		
		
		Date now=new Date();
		SimpleDateFormat formatter; 
		formatter = new SimpleDateFormat ("yyyyMMddHHmmss");
		String StringDate =formatter.format(now);

		String UserID=GlobalVariable.GetMemberID(request);

		String UrlCode=("PID"+StringDate+GlobalVariable.GUIDString()).substring(0,21).toUpperCase();
		
		String Sql1="insert into abdp_bookingdatetime_pay(abdp_id_abd,abdp_StatusType,abdp_money,abdp_UrlCode,abdp_PayDate,abdp_CheckIn,abdp_CheckInDate,\r\n" + 
				"abdp_CheckUser,abdp_GuestName,abdp_GuestTel,abdp_id_amb,abdp_Remark,_Status,abdp_status,_Date_Ins,\r\n" + 
				"_User_Ins,_SyncFlag)\r\n"+
				"values ('"+abdp_id_abd+"','已付款',0,'"+UrlCode+"',now(),"+CheckIn+",now(),\r\n" + 
				"'"+UserID+"','"+abdp_GuestName+"','"+abdp_GuestTel+"','"+abdp_id_amb+"','手工录入排队','I','I',now(),\r\n" + 
				"'"+UserID+"',0)";
		String Sql2="update abd_bookingdatetime set abd_hasbooking=abd_hasbooking+1,_SyncFlag=0 where abd_id="+abdp_id_abd;
		MySQLUpdate update=new MySQLUpdate();
		update.Update(Sql1);
		update.Update(Sql2);
		
        ResultXml.put("MsgID","1");
        ResultXml.put("MsgText","SUCCESS");
        
				

		response.getWriter().print(ResultXml.toString());
		response.getWriter().flush();    
	    
	}


}
