package com.java.web.weixin.system;



import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;

import com.java.web.weixin.base.GlobalVariable;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/System/GetJsapiTicket")
public class GetJsapiTicket extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetJsapiTicket() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");  
		
		response.getWriter().print(GetJsapi_ticket());
		response.getWriter().flush();
		
	}
	public String GetJsapi_ticket()
	{	
		String vjsapi_ticket=System.getProperty("WeiXin.jsapi_ticket");
		if (vjsapi_ticket==null)
		{
			vjsapi_ticket="";
		}
		String vjsapi_ticket_TimeOutString=System.getProperty("WeiXin.jsapi_ticket_TimeOut");
		if (vjsapi_ticket_TimeOutString==null)
		{
			vjsapi_ticket_TimeOutString="0";
		}
		long vjsapi_ticket_TimeOut=Long.parseLong(vjsapi_ticket_TimeOutString);
		
		System.out.println("GetJsapi_ticket()");
		long d=System.currentTimeMillis();
		if (d>vjsapi_ticket_TimeOut)
		{
			String url="https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="+GlobalVariable.AccessToken+"&type=jsapi";
			String result=GlobalVariable.sendHttpGet(url);
			System.out.println(result);
			try {
				JSONObject json=new JSONObject(result);
				GlobalVariable.jsapi_ticket=json.getString("ticket");
				GlobalVariable.jsapi_ticket_TimeOut=d+json.getLong("expires_in")*1000;

				System.setProperty("WeiXin.jsapi_ticket",GlobalVariable.jsapi_ticket);
				System.setProperty("WeiXin.jsapi_ticket_TimeOut",""+GlobalVariable.jsapi_ticket_TimeOut);
				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else
		{
			GlobalVariable.jsapi_ticket=vjsapi_ticket;
			GlobalVariable.jsapi_ticket_TimeOut=vjsapi_ticket_TimeOut;
		}
		return GlobalVariable.jsapi_ticket;
	}

}
