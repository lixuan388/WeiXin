package com.java.web.weixin.tx.servlet.booking;

import java.io.IOException;
import java.util.Date;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.table.MySQLTable;
import com.java.web.weixin.tx.Class.booking.TCancelBooking;

import net.sf.json.JSONObject;

/**
 * Servlet implementation class CancelBookingServlet
 */
@WebServlet("/booking/CancelBooking")
public class CancelBookingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CancelBookingServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("application/json;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");
		
		Map<String, String[]> params = request.getParameterMap();	

		JSONObject ResultXml = new JSONObject();      
		
		String url =params.get("url")==null?"":(String)(params.get("url")[0]);		
		if (url.equals(""))
		{
			ResultXml.put("MsgID", -1);
			ResultXml.put("MsgTest", "缺少参数（url）");
			response.getWriter().println(ResultXml.toString());
			response.getWriter().flush();
			return;
		}
		System.out.println("url:"+url);

		TCancelBooking CancelBooking= new TCancelBooking();
		
		if (CancelBooking.OpenTable(url))
		{
			String abdp_statustype=CancelBooking.abdp_statustype;
			if (CancelBooking.abdp_CheckIn!=0)
			{
				ResultXml.put("MsgID", -1);
				ResultXml.put("MsgTest", "已报到，不可取消！");
				response.getWriter().println(ResultXml.toString());
				response.getWriter().flush();
				return;
			}
			
			if (abdp_statustype.equals("已付款") && (!CancelBooking.CheckTimeOut()))
			{
				ResultXml.put("MsgID", -1);
				ResultXml.put("MsgTest", "已过期，不可取消预约！");
				response.getWriter().println(ResultXml.toString());
				response.getWriter().flush();
				return;
			}
			if (abdp_statustype.equals("已付款"))
			{
				if (!CancelBooking.CancelBooking())
				{
					ResultXml.put("MsgID", -1);
					ResultXml.put("MsgTest", "预约取消失败，请重试！");
					response.getWriter().println(ResultXml.toString());
					response.getWriter().flush();
					return;
				}
				if ((CancelBooking.abdp_money>0) && (!CancelBooking.PayRefund()))
				{

					ResultXml.put("MsgID", -1);
					ResultXml.put("MsgTest", "退款失败，请稍后再重试！");
					response.getWriter().println(ResultXml.toString());
					response.getWriter().flush();
					return;
				}

				ResultXml.put("MsgID", 1);
				ResultXml.put("MsgTest", "预约取消成功！");
				response.getWriter().println(ResultXml.toString());
				response.getWriter().flush();
				return;
			}
			else if (abdp_statustype.equals("客人取消"))
			{
				if ((CancelBooking.abdp_money>0) && (!CancelBooking.PayRefund()))
				{
					ResultXml.put("MsgID", -1);
					ResultXml.put("MsgTest", "退款失败，请稍后再重试！");
					response.getWriter().println(ResultXml.toString());
					response.getWriter().flush();
					return;
				}
				ResultXml.put("MsgID", 1);
				ResultXml.put("MsgTest", "退款成功！");
				response.getWriter().println(ResultXml.toString());
				response.getWriter().flush();
				return;
			}
		}
		else
		{
			ResultXml.put("MsgID", -1);
			ResultXml.put("MsgTest", "无对应的预约记录！");
			response.getWriter().println(ResultXml.toString());
			response.getWriter().flush();
			return;
		}
			

		ResultXml.put("MsgID", 1);
		ResultXml.put("MsgTest", "Success");
		response.getWriter().println(ResultXml.toString());
		response.getWriter().flush();
		
		
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
