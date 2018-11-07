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
@WebServlet("/System/GetAccessToken")
public class GetAccessToken extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetAccessToken() {
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
		
		response.getWriter().print(GetAccessToken());
		response.getWriter().flush();
		
	}
	
	public String GetAccessToken()
	{	
		String vAccessToken=System.getProperty("WeiXin.AccessToken");
		if (vAccessToken==null)
		{
			vAccessToken="";
		}
		String vAccessTokenTimeOutString=System.getProperty("WeiXin.AccessTokenTimeOut");
		if (vAccessTokenTimeOutString==null)
		{
			vAccessTokenTimeOutString="0";
		}
		long vAccessTokenTimeOut=Long.parseLong(vAccessTokenTimeOutString);		
		
		System.out.println("GetAccessToken()");
		long d=System.currentTimeMillis();
		if (d>vAccessTokenTimeOut)
		{
			String url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="+GlobalVariable.AppID+"&secret="+GlobalVariable.AppSecret;
//			System.out.println(url);
			String result=GlobalVariable.sendHttpGet(url);
//			System.out.println(result);
			try {
				JSONObject json=new JSONObject(result);				
				if (json.isNull("errcode"))
				{
					GlobalVariable.AccessToken=json.getString("access_token");
					GlobalVariable.AccessTokenTimeOut=d+json.getLong("expires_in")*1000;
	
					System.setProperty("WeiXin.AccessToken",GlobalVariable.AccessToken);
					System.setProperty("WeiXin.AccessTokenTimeOut",""+GlobalVariable.AccessTokenTimeOut);
				}
				else
				{
					System.out.println("errcode:"+json.getString("errcode"));
					System.out.println("errmsg:"+json.getString("errmsg"));
				}				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else
		{
			GlobalVariable.AccessToken=vAccessToken;
			GlobalVariable.AccessTokenTimeOut=vAccessTokenTimeOut;
		}		
		return GlobalVariable.AccessToken;
	}

}
