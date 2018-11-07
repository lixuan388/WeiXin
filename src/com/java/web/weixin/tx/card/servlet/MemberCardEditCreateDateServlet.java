package com.java.web.weixin.tx.card.servlet;



import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.util.Date;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.SQLConnect;
import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.jssdk.WXSnsapiBaseCode;
import com.java.web.weixin.jssdk.WXUserInfo;
import com.java.web.weixin.tx.Class.booking.TMedicalProjectList.TMedicalProjectListItem;
import com.java.web.weixin.tx.Class.message.TMessageMemberCard;
import com.java.web.weixin.tx.card.MemberCardFunction;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/card/MemberCardEditCreateDate")
public class MemberCardEditCreateDateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberCardEditCreateDateServlet() {
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

		net.sf.json.JSONObject ReturnJson = new net.sf.json.JSONObject();		

		Map<String, String[]> params = request.getParameterMap();
		String AmcID =params.get("ID")==null?"":(String)(params.get("ID")[0]);		
		String CreateDate =params.get("CreateDate")==null?"":(String)(params.get("CreateDate")[0]);

		CreateDate=URLDecoder.decode(CreateDate);
		System.out.println("AmcID:"+AmcID);
		System.out.println("CreateDate:"+CreateDate);
		

		String CountAmcID=request.getSession().getAttribute("CountAmcID")==null?"":(String)request.getSession().getAttribute("CountAmcID");
		String CountMemberID=request.getSession().getAttribute("CountMemberID")==null?"":(String)request.getSession().getAttribute("CountMemberID");
		
		String groupid=request.getSession().getAttribute("groupid")==null?"":(String)request.getSession().getAttribute("groupid");
		
		if ((!groupid.equals("101")) && (!groupid.equals("100")))
		{
			ReturnJson.put("MsgID","-1");
			ReturnJson.put("MsgTest","无权限操作");				
			return;
		}
		
		try
		{
			if (AmcID.equals(""))
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","无【卡号】信息！");				
				return;
			}
			if (!AmcID.equals(CountAmcID))
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","【卡号】信息异常,不可操作！");				
				return;
			}
			if (CreateDate.equals(""))
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","无【开卡日期】信息！");
				return;
			}		

			String UserID=request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");
			


//			java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");
//			java.util.Date ss = new Date();
//			try {
//				ss = format.parse(CreateDate);
//			} catch (ParseException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//
//			java.util.Calendar rightNow = java.util.Calendar.getInstance();
//			rightNow.setTime(ss);
//			rightNow.add(java.util.Calendar.YEAR,1);//日期减1年
//			
//			String EndDate=format.format(rightNow.getTime());
			
			MySQLUpdate update=new MySQLUpdate();
			//String SqlString="update amc_member_card set _User_Lst ='"+UserID+"',_Date_Lst=now(),amc_CreateDate='"+CreateDate+"',amc_EndDate='"+EndDate+"' \r\n" + 
			String SqlString="update amc_member_card set _User_Lst ='"+UserID+"',_Date_Lst=now(),amc_CreateDate='"+CreateDate+"',_SyncFlag=0 \r\n" + 
					" where amc_id='"+AmcID+"';"; 
			if (update.Update(SqlString))
			{
				MemberCardFunction.InsertHistory(UserID,CountMemberID,AmcID,"修改开卡日期","0","0","");
				ReturnJson.put("MsgID","1");
				ReturnJson.put("MsgTest","开卡日期修改成功！");
				

				String touser="";
				String url=GlobalVariable.WebUrl+"/tx/card/MemberCard.jsp";
				String keyword1="次卡";
				String keyword3="修改资料";
				String keyword4="";
				String remark="";



				touser=GlobalVariable.AdminWeiXinOpenID;
				url=GlobalVariable.WebUrl+"/tx/card/MemberCardEdit.jsp?ID="+AmcID;
//						remark="客人开卡日期已修改成功。\r\n新开卡日期："+CreateDate+"\r\n有效日期："+EndDate;
				remark="客人开卡日期已修改成功。\r\n新开卡日期："+CreateDate;
				TMessageMemberCard MessageMemberCard2=new TMessageMemberCard(touser,url,keyword1,keyword3,keyword4,remark);
				MessageMemberCard2.Send();
				
				
				
				return ;
			}
			else
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","开卡日期修改失败！");
				return ;
			}
		}
		finally
		{
			response.getWriter().print(ReturnJson.toString());
			response.getWriter().flush();	
		}
	}
}
