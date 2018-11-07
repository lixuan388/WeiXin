package com.java.web.weixin;



import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.digest.DigestUtils;

import com.java.web.weixin.base.GlobalVariable;

import net.sf.json.JSONObject;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/token")
public class token extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public token() {
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
		response.addHeader("Access-Control-Allow-Origin", "*");

		System.out.println("微信token验证");

		String signature=request.getParameter("signature");
		String echostr=request.getParameter("echostr");
		String timestamp=request.getParameter("timestamp");
		String nonce=request.getParameter("nonce");
		String openid=request.getParameter("openid");
		
		String sign=DigestUtils.sha1Hex(timestamp+nonce+"lixuan388");

		System.out.println("getQueryString:"+request.getQueryString());

		System.out.println("signature:"+signature);
		System.out.println("echostr:"+echostr);
		System.out.println("timestamp:"+timestamp);
		System.out.println("nonce:"+nonce);
		System.out.println("sha1:"+sign);
		
	    BufferedReader bufferReader = new BufferedReader(new InputStreamReader(request.getInputStream(),"utf-8"));

	    StringBuffer buffer = new StringBuffer();
	    String line = "";
	    while ((line = bufferReader.readLine()) != null) {
	        buffer.append(line);
	    }
	    String XmlData=new String(buffer.toString());

		System.out.println("PostData:"+XmlData);
	    
	    
		if (echostr!=null)
		{
			response.getWriter().println(echostr);
		}
		else if (openid!=null)
		{
			String param="<xml><ToUserName><![CDATA["+openid+"]]></ToUserName><FromUserName><![CDATA[gh_5d8787589854]]></FromUserName>"+
						"<CreateTime>12345678</CreateTime><MsgType><![CDATA[text]]></MsgType><Content><![CDATA[你好]]></Content></xml>";
//
//			response.setContentType("application/xml;charset=utf-8"); 
//			String param="success";
			response.getWriter().println(param);
		}
			
		response.getWriter().flush();
        
        
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request,response);
	}	
}
