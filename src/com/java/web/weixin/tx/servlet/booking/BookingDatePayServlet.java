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
import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.tx.Class.booking.TBookingSuccessSendMessage;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/BookingDatePay")
public class BookingDatePayServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookingDatePayServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");


		String BookingID=request.getSession().getAttribute("BookingID")==null?"0":(String)request.getSession().getAttribute("BookingID");
		if (BookingID.equals("0"))
		{
			String ErrText="错误的参数，无法操作！(BookingID)";
			GlobalVariable.GoErrerHtml(request,response,ErrText);
			return;
		}
		String MemberID=request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");
		if (MemberID.equals(""))
		{
			String ErrText="错误的参数，无法操作！(MemberID)";
			GlobalVariable.GoErrerHtml(request,response,ErrText);
			return;
		}
		

    String MemberName =request.getParameter("Name")==null?"":request.getParameter("Name");
    if (MemberName.equals(""))
    {
      String ErrText="错误的参数，无法操作！(MemberName)";
      GlobalVariable.GoErrerHtml(request,response,ErrText);
      return;
    }

    String isWxMini =request.getParameter("isWxMini")==null?"false":request.getParameter("isWxMini");
    if (isWxMini.equals(""))
    {
      String ErrText="错误的参数，无法操作！(isWxMini)";
      GlobalVariable.GoErrerHtml(request,response,ErrText);
      return;
    }

//		System.out.println("MemberName:"+MemberName);	
		
		MemberName=URLDecoder.decode(MemberName, "utf-8");

		String MemberTel =request.getParameter("Tel")==null?"":request.getParameter("Tel");
		if (MemberTel.equals(""))
		{
			String ErrText="错误的参数，无法操作！(MemberTel)";
			GlobalVariable.GoErrerHtml(request,response,ErrText);
			return;
		}
		MemberTel=URLDecoder.decode(MemberTel, "utf-8");
//		System.out.println("MemberName:"+MemberName+"/MemberTel:"+MemberTel);	
		

		Date now=new Date();
		SimpleDateFormat formatter; 
		formatter = new SimpleDateFormat ("yyyyMMddHHmmss");
		String StringDate =formatter.format(now);
		
		String UrlCode=("PID"+StringDate+GlobalVariable.GUIDString()).substring(0,21).toUpperCase();
		
		MySQLTable table=new MySQLTable(" select abd_id,'待付款',amp_money,amp_money2,'"+UrlCode+"',0,'"+MemberName+"','"+MemberTel+"','"+MemberID+"','I',now(),'"+MemberID+"' from abd_bookingdatetime,amp_Medical_Project where abd_status<>'D' and abd_id_amp=amp_id and abd_id= "+BookingID);
		table.Open();
		if (!table.next())
		{
			String ErrText="订单信息异常，无法创建支付信息！";
			GlobalVariable.GoErrerHtml(request,response,ErrText);
			table.Close(); 
			return ;			
		}
		MySQLUpdate update=new MySQLUpdate();
    	String sql="insert into abdp_BookingDatetime_pay (abdp_id_abd,abdp_StatusType,abdp_money,abdp_UrlCode,abdp_CheckIn,abdp_call,abdp_GuestName,abdp_GuestTel,abdp_id_amb,_status,_date_ins,_user_ins,abdp_status )"+ 
    			" values( "+table.getInt("abd_id")+",";
    	Double amp_money;
    	String amb_Level =request.getSession().getAttribute("amb_Level")==null?"":(String)request.getSession().getAttribute("amb_Level");

    	System.out.println("amb_Level:"+amb_Level);
    	if (amb_Level.equals("2"))
    	{
    		amp_money=table.getDouble("amp_money2");
    	}
    	else
    	{
    		amp_money=table.getDouble("amp_money");
    	}
    	
    	if (amp_money==0)
    	{
    		sql=sql+"'已付款',";
    	}
    	else
    	{
    		sql=sql+"'待付款',";
    	}

    	sql=sql+amp_money+",'"+UrlCode+"',0,0,'"+MemberName+"','"+MemberTel+"','"+MemberID+"','I',now(),'"+MemberID+"','I')";			    	
    	update.Update(sql); 
    	System.out.println(sql);

		sql="update abd_bookingdatetime set abd_hasbooking=abd_hasbooking+1,_SyncFlag=0 where  abd_id= "+BookingID;			    	
		update.Update(sql); 

		sql="update amb_member set amb_name='"+MemberName+"',amb_tel='"+MemberTel+"',amb_date_lst=getdate() where  amb_id= '"+MemberID+"'";			    	
		update.Update(sql); 
		
		update.Close();
		
//		Statement stmt = null;
//	    Connection con = null;
// 		
//	    try {       	
//        	con=SQLConnect.GetConnect();
//           	if (con==null)
//           	{
//    			String ErrText="数据库连接异常";
//    			GlobalVariable.GoErrerHtml(request,response,ErrText);
//           		return ;
//           	}    	     
//			try {
//				stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
//			    ResultSet rs = null;  
//			    try {
//			    	String sql="insert into abdp_BookingDatetime_pay (abdp_id_abd,abdp_StatusType,abdp_money,abdp_UrlCode,abdp_CheckIn,abdp_GuestName,abdp_GuestTel,abdp_id_amb,_status,_date_ins,_user_ins )"+ 
//			    			" select abd_id,'待付款',amp_money,'"+UrlCode+"',0,'"+MemberName+"','"+MemberTel+"','"+MemberID+"','I',now(),'"+MemberID+"' from abd_bookingdatetime,amp_Medical_Project where abd_status<>'D' and abd_id_amp=amp_id and abd_id= "+BookingID;			    	
//					stmt.executeUpdate(sql); 
//
//					sql="update abd_bookingdatetime set abd_hasbooking=abd_hasbooking+1 where  abd_id= "+BookingID;			    	
//					stmt.executeUpdate(sql); 
//
//					sql="update amb_member set amb_name='"+MemberName+"',amb_tel='"+MemberTel+"',amb_date_lst=getdate() where  amb_id= '"+MemberID+"'";			    	
//					stmt.executeUpdate(sql); 
//
//					
//				} catch (SQLException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//	    			String ErrText=e.getMessage();
//	    			GlobalVariable.GoErrerHtml(request,response,ErrText);
//			        return ;
//				}
//				finally {
//					if (rs != null) try { rs.close(); } catch(Exception e) {}
//			    }     			    
//			} catch (SQLException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//    			String ErrText=e.getMessage();
//    			GlobalVariable.GoErrerHtml(request,response,ErrText);
//		        return ;
//			}	
//			finally {
//		        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
//		    }     
//		} 
//       finally {
//           if (con != null) try { con.close(); } catch(Exception e) {}
//       }      
	    if (amp_money==0)
	    {

			String ErrText="预约成功！";
	    	GlobalVariable.GoSuccessHtml(request, response, ErrText);
	    	new TBookingSuccessSendMessage(UrlCode);
	    	return;
	    }
	    else
	    {
		    try {
		    	System.out.println("BookingDatePay");
		    	if (isWxMini.equals("true"))
		    	{

		        response.sendRedirect(request.getContextPath()+"/tx/pay/MiniWaitPay.jsp?code="+UrlCode);
		    	}
		    	else
		    	{

		        response.sendRedirect(request.getContextPath()+"/tx/pay/WaitPay.jsp?code="+UrlCode);
		    	}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
	    }
	    
	    
	}


}
