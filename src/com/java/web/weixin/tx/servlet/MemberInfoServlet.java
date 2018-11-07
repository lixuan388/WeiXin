package com.java.web.weixin.tx.servlet;



import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.SQLConnect;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.jssdk.WXSnsapiBaseCode;
import com.java.web.weixin.jssdk.WXUserInfo;
import com.java.web.weixin.tx.Class.booking.TMedicalProjectList.TMedicalProjectListItem;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/MemberInfo")
public class MemberInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberInfoServlet() {
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

		request.getSession().setAttribute("MemberID", "");
		request.getSession().setAttribute("MemberName", "");
		request.getSession().setAttribute("MemberTel", "");
		
		String openid=request.getSession().getAttribute("openid")==null?"":(String)request.getSession().getAttribute("openid");
		if (openid.equals(""))
		{
			return;
		}
		else
		{

			Statement stmt = null;
		    Connection con = null;
	 		
		    try {       	
	        	con=SQLConnect.GetConnect();
	           	if (con==null)
	           	{
	           		System.out.println("数据库连接异常");
	           		return ;
	           	}    	     
				try {
					stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
				    ResultSet rs = null;  
				    try {
				    	String sql="select amb_ID,amb_Name,amb_WXID,amb_Tel,amb_Code,amb_PassWord from amb_member where amb_wxid='"+openid+"'";
				    	
						rs = stmt.executeQuery(sql);   
						if (!rs.next())
						{	
							rs.moveToInsertRow();
							String ID=GlobalVariable.GUIDString();
							rs.updateString("amb_ID", ID);
							rs.updateString("amb_Name", (String)request.getSession().getAttribute("nickname"));
							rs.updateString("amb_WXID", (String)request.getSession().getAttribute("openid"));
							rs.updateString("amb_Tel", "");
							rs.updateString("amb_Code", (String)request.getSession().getAttribute("nickname"));
							rs.updateString("amb_PassWord", "88888888");
							request.getSession().setAttribute("MemberID", ID);
							request.getSession().setAttribute("MemberName", (String)request.getSession().getAttribute("nickname"));
							request.getSession().setAttribute("MemberTel", "");
							rs.insertRow();
						}
						else
						{
						request.getSession().setAttribute("MemberID", rs.getString("amb_ID"));
						request.getSession().setAttribute("MemberName", rs.getString("amb_Name"));
						request.getSession().setAttribute("MemberTel", rs.getString("amb_Tel"));
						}
						
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
				        return ;
					}
					finally {
						if (rs != null) try { rs.close(); } catch(Exception e) {}
				    }     		
				    
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
			        return ;
				}	
				finally {
			        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
			    }     
			} 
	       finally {
	           if (con != null) try { con.close(); } catch(Exception e) {}
	       }      
		}
	}
}
