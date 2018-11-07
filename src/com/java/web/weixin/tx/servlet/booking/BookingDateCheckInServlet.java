package com.java.web.weixin.tx.servlet.booking;



import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.SQLConnect;
import com.java.web.weixin.base.GlobalVariable;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/BookingDateCheckIn")
public class BookingDateCheckInServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookingDateCheckInServlet() {
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


		String groupid=request.getSession().getAttribute("groupid")==null?"0":(String)request.getSession().getAttribute("groupid");
		if (!groupid.equals("100") && !groupid.equals("101"))
		{
			String ErrText="权限错误，无法操作！";
			GlobalVariable.WriteMsgText(response, -100, ErrText);
			return;
		}
		

		String openid=request.getSession().getAttribute("openid")==null?"0":(String)request.getSession().getAttribute("openid");
		if (openid.equals(""))
		{
			String ErrText="用户信息错误，无法操作！(openid)";
			GlobalVariable.WriteMsgText(response, -103, ErrText);
			return;
		}
		

		String UrlCode =request.getParameter("code")==null?"":request.getParameter("code");
		if (UrlCode.equals(""))
		{
			String ErrText="错误的参数，无法操作！(UrlCode)";
			GlobalVariable.WriteMsgText(response, -101, ErrText);
			return;
		}	
		Date now=new Date();
		SimpleDateFormat formatter; 
		formatter = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
		String NowDate =formatter.format(now);	
		

		Statement stmt = null;
	    Connection con = null;
 		
	    try {       	
        	con=SQLConnect.GetConnect();
           	if (con==null)
           	{
    			String ErrText="数据库连接异常";
    			GlobalVariable.WriteMsgText(response, -1000, ErrText);
           		return ;
           	}    	     
			try {
				stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
			    ResultSet rs = null;  
			    try {
			    	String sql="update abdp_BookingDatetime_Pay set abdp_CheckIn=1,abdp_CheckInDate='"+NowDate+"',abdp_CheckUser='"+openid+"',_SyncFlag=0 where abdp_CheckIn=0 and  abdp_urlcode='"+UrlCode+"'";			    	
					stmt.executeUpdate(sql); 
					
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
	    			String ErrText=e.getMessage();
	    			GlobalVariable.WriteMsgText(response, -103, ErrText);
			        return ;
				}
				finally {
					if (rs != null) try { rs.close(); } catch(Exception e) {}
			    }     			    
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
    			String ErrText=e.getMessage();
    			GlobalVariable.WriteMsgText(response, -104, ErrText);
		        return ;
			}	
			finally {
		        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
		    }     
		} 
	    finally {
           if (con != null) try { con.close(); } catch(Exception e) {}
	    }      
	    
		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();      
        ResultXml.put("MsgID","1");
        ResultXml.put("MsgText","SUCCESS");
        ResultXml.put("CheckInDate",NowDate);
        

		response.getWriter().print(ResultXml.toString());
		response.getWriter().flush();
        
	    	
	    
	    
	}


}
