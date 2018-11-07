package com.java.web.weixin.tx.card.servlet;



import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
@WebServlet("/card/MemberCardUse")
public class MemberCardUseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberCardUseServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("application/json;charset=utf-8"); 
		response.setCharacterEncoding("UTF-8");  
		response.setHeader("Cache-Control", "no-cache");

		net.sf.json.JSONObject ReturnJson = new net.sf.json.JSONObject();		

		Map<String, String[]> params = request.getParameterMap();
		String AmcID =params.get("ID")==null?"":(String)(params.get("ID")[0]);		
		String Count =params.get("Count")==null?"":(String)(params.get("Count")[0]);		

		

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
			if (Count.equals(""))
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","无【次数】信息！");
				return;
			}		

			String UserID=request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");
			
			MySQLTable member=new MySQLTable("select amb_WXID,amc_GuestName,amc_GuestTel,amc_Count,amc_EndDate from amb_member,amc_member_card  where amc_id_amb=amb_id and amb_id='"+CountMemberID+"'");
			try
			{
				member.Open();
				if (member.next())
				{
					System.out.println("amc_Count:"+member.getInt("amc_Count"));
					System.out.println("Count:"+Integer.parseInt(Count));
					if (member.getInt("amc_Count")+Integer.parseInt(Count)<0)
					{
						ReturnJson.put("MsgID","-1");
						ReturnJson.put("MsgTest","可消费次数（"+member.getInt("amc_Count")+"）不足！");
					}
//					else if (member.getDateTime("amc_EndDate").getTime()<=new Date().getTime())
//					{
//						ReturnJson.put("MsgID","-1");
//						ReturnJson.put("MsgTest","已超过有效期，不可消费！");
//					}
					else if (MemberCardFunction.UpdateCount(UserID, CountMemberID, AmcID, "消费", Count,"0",""))
					{
						int count=MemberCardFunction.GetCardCount(AmcID);
						ReturnJson.put("MsgID","1");
						ReturnJson.put("MsgTest","消费成功！");
						ReturnJson.put("Count",count);
						
						String touser=member.getString("amb_WXID");
						String url=GlobalVariable.WebUrl+"/tx/card/MemberCard.jsp";
						String keyword1="次卡";
						String keyword3="消费";
						String keyword4="消费成功";
						String remark="您的次卡已消费成功。\r\n姓名："+member.getString("amc_GuestName")+ "\r\n手机："+member.getString("amc_GuestTel")+ "\r\n消费次数："+(0-Integer.parseInt(Count));

						TMessageMemberCard MessageMemberCard=new TMessageMemberCard(touser,url,keyword1,keyword3,keyword4,remark);
						MessageMemberCard.Send();

						touser=GlobalVariable.AdminWeiXinOpenID;
						url=GlobalVariable.WebUrl+"/tx/card/MemberCardEdit.jsp?ID="+AmcID;
						remark="客人次卡已消费成功。\r\n姓名："+member.getString("amc_GuestName")+ "\r\n手机："+member.getString("amc_GuestTel")+ "\r\n消费次数："+(0-Integer.parseInt(Count));
						TMessageMemberCard MessageMemberCard2=new TMessageMemberCard(touser,url,keyword1,keyword3,keyword4,remark);
						MessageMemberCard2.Send();
					}
					else
					{
						ReturnJson.put("MsgID","-1");
						ReturnJson.put("MsgTest","消费失败！");
					}		
				}
			}
			finally {
				member.Close(); 
			}	

		
		}
		finally
		{
			response.getWriter().print(ReturnJson.toString());
			response.getWriter().flush();	
		}
	}
}
