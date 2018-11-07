package com.java.web.weixin.tx.servlet;



import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
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
import com.java.web.weixin.tx.Class.message.TMessageTemplateSend;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/MessageTemplateSend")
public class MessageTemplateSendServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MessageTemplateSendServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub


		String touser =request.getParameter("touser")==null?"0":URLDecoder.decode(request.getParameter("touser"), "utf-8");
		String template_id =request.getParameter("template_id")==null?"0":URLDecoder.decode(request.getParameter("template_id"), "utf-8");
		String url =request.getParameter("url")==null?"0":URLDecoder.decode(request.getParameter("url"), "utf-8");
		String miniprogram =request.getParameter("miniprogram")==null?"0":URLDecoder.decode(request.getParameter("miniprogram"), "utf-8");

				
		String first =request.getParameter("first")==null?"":URLDecoder.decode(request.getParameter("first"), "utf-8");
		String keyword1 =request.getParameter("keyword1")==null?"":URLDecoder.decode(request.getParameter("keyword1"), "utf-8");
		String keyword2 =request.getParameter("keyword2")==null?"":URLDecoder.decode(request.getParameter("keyword2"), "utf-8");
		String keyword3 =request.getParameter("keyword3")==null?"":URLDecoder.decode(request.getParameter("keyword3"), "utf-8");
		String keyword4 =request.getParameter("keyword4")==null?"":URLDecoder.decode(request.getParameter("keyword4"), "utf-8");
		String keyword5 =request.getParameter("keyword5")==null?"":URLDecoder.decode(request.getParameter("keyword5"), "utf-8");
		String remark =request.getParameter("remark")==null?"":URLDecoder.decode(request.getParameter("remark"), "utf-8");
		

		TMessageTemplateSend Send=new TMessageTemplateSend(touser,template_id,url,miniprogram,first,keyword1,
				keyword2,keyword3,keyword4,keyword5,remark);
		org.json.JSONObject result=Send.Send();
		
        try {
            resp.setContentType("application/json;charset=utf-8"); 
            resp.setCharacterEncoding("UTF-8");  
            resp.setHeader("Cache-Control", "no-cache");  
			resp.getWriter().print(result.toString());
	        resp.getWriter().flush();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
