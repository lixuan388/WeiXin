package com.java.web.weixin.tx.servlet;



import java.io.IOException;
import java.net.URLDecoder;
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
@WebServlet("/UpdateMemberInfo")
public class UpdateMemberInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateMemberInfoServlet() {
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

		String MemberName=request.getParameter("MemberName")==null?"":request.getParameter("MemberName");
		if (MemberName.equals(""))
		{
			String ErrText="参数错误，保存失败！(MemberName)";
			GlobalVariable.GoErrerHtml(request,response,ErrText);
			return;
		}
		String MemberTel=request.getParameter("MemberTel")==null?"":request.getParameter("MemberTel");
		if (MemberTel.equals(""))
		{
			String ErrText="参数错误，保存失败！(MemberTel)";
			GlobalVariable.GoErrerHtml(request,response,ErrText);
			return;
		}
		MemberName=URLDecoder.decode(MemberName, "utf-8");
		MemberTel=URLDecoder.decode(MemberTel, "utf-8");
		
		
		String MemberID=request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");
		

		
		System.out.println("MemberID:"+MemberID+"/MemberName:"+MemberName+"/MemberTel:"+MemberTel);
		
		
		if (MemberID.equals(""))
		{

			String ErrText="参数错误，保存失败！(MemberID)";
			GlobalVariable.GoErrerHtml(request,response,ErrText);
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
	    			String ErrText="数据库连接异常";
	    			GlobalVariable.GoErrerHtml(request,response,ErrText);
	           		return ;
	           	}    	     
				try {
					stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
				    ResultSet rs = null;  
				    try {
				    	String sql="update amb_member set  amb_Name='"+MemberName+"',amb_Tel='"+MemberTel+"' where amb_id='"+MemberID+"'";
				    	stmt.executeUpdate(sql);

						request.getSession().setAttribute("MemberName",MemberName);
						request.getSession().setAttribute("MemberTel", MemberTel);
				    	
//						if (rs.next())
//						{	
//							rs.updateString("amb_Name", MemberName);							
//							rs.updateString("amb_Tel",MemberTel);
//							request.getSession().setAttribute("MemberName",MemberName);
//							request.getSession().setAttribute("MemberTel", MemberTel);
//							rs.rowUpdated();
//						}
//						else
//						{
//			    			String ErrText="无对应的数据，保存失败！";
//			    			GlobalVariable.GoErrerHtml(request,response,ErrText);
//			    			return;
//						}
						
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();

		    			String ErrText=e.getMessage();
		    			GlobalVariable.GoErrerHtml(request,response,ErrText);
						
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

		String ErrText="个人信息，保存成功！";
		GlobalVariable.GoSuccessHtml(request,response,ErrText);
	}
}
