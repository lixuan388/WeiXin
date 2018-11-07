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
@WebServlet("/card/MemberCardCancel")
public class MemberCardCancelServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberCardCancelServlet() {
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
		String HistoryID =params.get("HistoryID")==null?"":(String)(params.get("HistoryID")[0]);		
		

		

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
			if (HistoryID.equals(""))
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","无【记录ID】信息！");
				return;
			}	

			String UserID=request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");
			 
			String Type="";
			String Count="";
			String Status="";
			
			MySQLTable history=new MySQLTable("select _status,amch_type,amch_count,amch_id,_User_lst,_Date_Lst,_SyncFlag  from amch_member_card_history where amch_id='"+HistoryID+"'");
			try
			{
				history.Open();
				if (!history.next())
				{
					ReturnJson.put("MsgID","-10");
					ReturnJson.put("MsgTest","记录ID不存在，不可取消！");
				}
				else
				{
					Status=history.getString("_status");
					Type=history.getString("amch_type");
					Count=""+(0-history.getInt("amch_count"));
					
					history.updateString("_status", "D");
					history.updateString("_User_lst", UserID);
					history.updateDateTime("_Date_Lst",new Date());
					history.updateBoolean("_SyncFlag", false);
					
					if (Status.equals("D"))
					{
						ReturnJson.put("MsgID","-9");
						ReturnJson.put("MsgTest","此记录已被取消，不可重复操作！");
					}
					else
					{
						if (Type.equals("充值"))
						{
							if (MemberCardFunction.UpdateCount(UserID, CountMemberID, AmcID, "充值", Count,"0",""))
							{
								int count=MemberCardFunction.GetCardCount(AmcID);
								ReturnJson.put("MsgID","1");
								ReturnJson.put("MsgTest","取消充值操作成功！");
								ReturnJson.put("Count",count);
								history.PostRow();
								MySQLTable member=new MySQLTable("select amb_WXID,amc_GuestName,amc_GuestTel from amb_member,amc_member_card  where amc_id_amb=amb_id and amb_id='"+CountMemberID+"'");
								try
								{
									member.Open();
									if (member.next())
									{
										String touser=member.getString("amb_WXID");
										String url=GlobalVariable.WebUrl+"/tx/card/MemberCard.jsp";
										String keyword1="次卡";
										String keyword3="充值";
										String keyword4="取消充值操作";
										String remark="您的次卡充值操作已被取消。\r\n姓名："+member.getString("amc_GuestName")+ "\r\n手机："+member.getString("amc_GuestTel")+ "\r\n充值次数："+Count;

										TMessageMemberCard MessageMemberCard=new TMessageMemberCard(touser,url,keyword1,keyword3,keyword4,remark);
										MessageMemberCard.Send();

										touser=GlobalVariable.AdminWeiXinOpenID;
										url=GlobalVariable.WebUrl+"/tx/card/MemberCardEdit.jsp?ID="+AmcID;
										remark="客人次卡充值操作已被取消。\r\n姓名："+member.getString("amc_GuestName")+ "\r\n手机："+member.getString("amc_GuestTel")+ "\r\n充值次数："+Count;
										TMessageMemberCard MessageMemberCard2=new TMessageMemberCard(touser,url,keyword1,keyword3,keyword4,remark);
										MessageMemberCard2.Send();
									}
								}
								finally {
									member.Close(); 
								}	
							}
							else
							{
								ReturnJson.put("MsgID","-1");
								ReturnJson.put("MsgTest","取消充值操作失败！");
							}							
						}
						else if (Type.equals("消费"))
						{
							MySQLTable member=new MySQLTable("select amb_WXID,amc_GuestName,amc_GuestTel,amc_Count,amc_EndDate from amb_member,amc_member_card  where amc_id_amb=amb_id and amb_id='"+CountMemberID+"'");
							try
							{
								member.Open();
								if (member.next())
								{
									if (MemberCardFunction.UpdateCount(UserID, CountMemberID, AmcID, "消费", Count,"0",""))
									{
										int count=MemberCardFunction.GetCardCount(AmcID);
										ReturnJson.put("MsgID","1");
										ReturnJson.put("MsgTest","取消消费操作成功！");
										ReturnJson.put("Count",count);

										history.PostRow();
										
										String touser=member.getString("amb_WXID");
										String url=GlobalVariable.WebUrl+"/tx/card/MemberCard.jsp";
										String keyword1="次卡";
										String keyword3="消费";
										String keyword4="取消消费操作";
										String remark="您的次卡消费操作已被取消。\r\n姓名："+member.getString("amc_GuestName")+ "\r\n手机："+member.getString("amc_GuestTel")+ "\r\n消费次数："+(0-Integer.parseInt(Count));

										TMessageMemberCard MessageMemberCard=new TMessageMemberCard(touser,url,keyword1,keyword3,keyword4,remark);
										MessageMemberCard.Send();

										touser=GlobalVariable.AdminWeiXinOpenID;
										url=GlobalVariable.WebUrl+"/tx/card/MemberCardEdit.jsp?ID="+AmcID;
										remark="客人次卡消费操作已被取消。\r\n姓名："+member.getString("amc_GuestName")+ "\r\n手机："+member.getString("amc_GuestTel")+ "\r\n消费次数："+(0-Integer.parseInt(Count));
										TMessageMemberCard MessageMemberCard2=new TMessageMemberCard(touser,url,keyword1,keyword3,keyword4,remark);
										MessageMemberCard2.Send();
									}
									else
									{
										ReturnJson.put("MsgID","-1");
										ReturnJson.put("MsgTest","取消消费操作失败！");
									}		
								}
							}
							finally {
								member.Close(); 
							}								
						}
						else
						{
							ReturnJson.put("MsgID","-8");
							ReturnJson.put("MsgTest","未知的操作类型（"+Type+"），不可操作！");
						}
					}
				}
				
			}
			finally {
				history.Close();
			}
			
		
		}
		finally
		{
			response.getWriter().print(ReturnJson.toString());
			response.getWriter().flush();	
		}
	}
}
