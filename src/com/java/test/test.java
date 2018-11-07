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
@WebServlet("/test")
public class test extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public test() {
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

		
	    BufferedReader bufferReader = new BufferedReader(new InputStreamReader(request.getInputStream(),"utf-8"));

	    StringBuffer buffer = new StringBuffer();
	    String line = "";
	    while ((line = bufferReader.readLine()) != null) {
	        buffer.append(line);
	    }
	    String XmlData=new String(buffer.toString());
		System.out.println("XmlData:"+XmlData);
		
		
		
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
