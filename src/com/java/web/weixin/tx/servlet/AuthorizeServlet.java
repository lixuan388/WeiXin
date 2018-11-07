package com.java.web.weixin.tx.servlet;



import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Base64;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.SQLConnect;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.jssdk.WXSnsapiBaseCode;
import com.java.web.weixin.jssdk.WXUserInfo;
import com.java.web.weixin.tx.notice.NoticeUserInfo;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/Authorize")
public class AuthorizeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AuthorizeServlet() {
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
		

		request.getSession().setAttribute("openid", "");
		request.getSession().setAttribute("nickname", "");
		request.getSession().setAttribute("headimgurl", "");
		request.getSession().setAttribute("groupid", "");
		request.getSession().setMaxInactiveInterval(60*60*6);
		



		String url =request.getParameter("url")==null?"":request.getParameter("url");
		
		String stateStr =request.getParameter("state")==null?"0":request.getParameter("state");
		int state=Integer.parseInt(stateStr);
		

		String SnsapiBaseCode =request.getParameter("code")==null?"":request.getParameter("code");
		if (SnsapiBaseCode.equals(""))
		{
			String ErrText="参数错误，登录失败！(code)";
			GlobalVariable.GoErrerHtml(request,response,ErrText);
			return;
		}

		WXSnsapiBaseCode codeInfo=new WXSnsapiBaseCode(SnsapiBaseCode);
		if (codeInfo.GetValue("errcode").equals(""))
		{
			String openid=codeInfo.GetValue("openid");
			WXUserInfo userinfo=new WXUserInfo(openid);
			if (userinfo.GetValue("errcode").equals(""))
			{
				request.getSession().setAttribute("openid", userinfo.GetValue("openid"));
				request.getSession().setAttribute("nickname", GlobalVariable.filterEmoji(userinfo.GetValue("nickname")));
				request.getSession().setAttribute("headimgurl", userinfo.GetValue("headimgurl"));
				request.getSession().setAttribute("groupid", userinfo.GetValue("groupid"));
				

				request.getSession().setAttribute("MemberID", "");
				request.getSession().setAttribute("MemberName", "");
				request.getSession().setAttribute("MemberTel", "");
				
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
					    	String sql="select amb_ID,amb_Name,amb_WXID,amb_Tel,amb_Code,amb_PassWord,amb_Level from amb_member where amb_wxid='"+openid+"'";
					    	
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
								rs.updateString("amb_Level", "1");
								request.getSession().setAttribute("MemberID", ID);
								request.getSession().setAttribute("MemberName", (String)request.getSession().getAttribute("nickname"));
								request.getSession().setAttribute("MemberTel", "");
								request.getSession().setAttribute("amb_Level", "1");
								rs.insertRow();
							}
							else
							{
								request.getSession().setAttribute("MemberID", rs.getString("amb_ID"));
								request.getSession().setAttribute("MemberName", rs.getString("amb_Name"));
								request.getSession().setAttribute("MemberTel", rs.getString("amb_Tel"));
								request.getSession().setAttribute("amb_Level", rs.getString("amb_Level"));
							}
							new NoticeUserInfo(request);

//							System.out.println("MemberName:"+rs.getString("amb_Name")+"/MemberTel:"+rs.getString("amb_Tel"));
//							System.out.println("groupid:"+userinfo.GetValue("groupid"));
							
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
				if (url.equals(""))
				{
					response.sendRedirect(request.getContextPath()+"/tx/index.jsp");
				}
				else
				{
					Base64.Decoder Base64Decoder = Base64.getDecoder();
					String RedirectUrl= new String(Base64Decoder.decode(url), "UTF-8");
					
					System.out.println("Authorize_sendRedirect:"+RedirectUrl);
					Cookie cookie = new Cookie("JSESSIONID", request.getSession().getId());      //此时通过sessionid生成Cookie
		      response.addCookie(cookie);         //加入response
		       
					response.sendRedirect(RedirectUrl);
				}
			}
			else
			{
				String ErrText="用户信息获取失败！<br>errcode:"+userinfo.GetValue("errcode")+"<br>errmsg:"+userinfo.GetValue("errmsg");
				GlobalVariable.GoErrerHtml(request,response,ErrText);
				return;
			}
			userinfo=null;
			
		}
		else
		{
			String ErrText="登录失败！<br>errcode:"+codeInfo.GetValue("errcode")+"<br>errmsg:"+codeInfo.GetValue("errmsg");
			GlobalVariable.GoErrerHtml(request,response,ErrText);
			return;
		}
		codeInfo=null;
	}
}
