package com.java.test;



import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.json.JSONException;
import org.json.JSONObject;
import org.xml.sax.InputSource;

import com.java.web.weixin.base.GlobalVariable;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/test2")
public class test2 extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public test2() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		response.setContentType("html;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");  


	    System.out.println("defaultCharset:"+java.nio.charset.Charset.defaultCharset());

		System.out.println("--------------------------------");

		String body=new String("美容预约挂号费 (2017-10-29 11:00:00)");
		System.out.println("body:"+body);

		System.out.println("body UTF-8:"+new String(body.getBytes("UTF-8")));
		System.out.println("body ISO-8859-1:"+new String(body.getBytes("ISO-8859-1"),"ISO-8859-1"));
		System.out.println("body GBK:"+new String(body.getBytes("GBK"),"GBK"));
		System.out.println("body GB2312:"+new String(body.getBytes("GB2312"),"GB2312"));
		System.out.println("body URLEncoder:"+java.net.URLEncoder.encode(body,"UTF-8"));
		
		
		
		String a = body; 
		String b=new String(a.getBytes("GBK"),"UTF-8"); 
		System.out.println(b); 
		String c=new String(b.getBytes("ISO-8859-1"),"utf-8"); 
		System.out.println(c);
		
		
		
//		StringReader sr = new StringReader(Result);
//		InputSource is = new InputSource(sr);
//		try {
//			Document doc = (new SAXBuilder()).build(is);
//			
//			List<Element> xmlList=doc.getRootElement().getChildren();
//			for (int i=0;i<xmlList.size();i++)
//			{
//				Element e=xmlList.get(i);
//
//				String Key=e.getName();
//				String Value=e.getText();
//				
//				response.getWriter().println("getName:"+e.getName()+"<br>");
//				response.getWriter().println("Key:"+Key+"/Value:"+Value+"<br>");
//				
//			}
//			
//			
//		} catch (JDOMException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//			
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//			
//		} 
		
//		response.getWriter().flush();
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
