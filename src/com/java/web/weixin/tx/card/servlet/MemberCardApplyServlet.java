package com.java.web.weixin.tx.card.servlet;



import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.SQLConnect;
import com.java.sql.table.MySQLTable;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.jssdk.WXSnsapiBaseCode;
import com.java.web.weixin.jssdk.WXUserInfo;
import com.java.web.weixin.tx.Class.booking.TMedicalProjectList.TMedicalProjectListItem;
import com.java.web.weixin.tx.Class.message.TMessageMemberCard;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/card/MemberCardApply")
public class MemberCardApplyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberCardApplyServlet() {
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
		String GuestName =params.get("GuestName")==null?"":(String)(params.get("GuestName")[0]);
		String GuestTel =params.get("GuestTel")==null?"":(String)(params.get("GuestTel")[0]);		

		GuestName=URLDecoder.decode(GuestName, "utf-8");
		
		try
		{
			if (GuestName.equals(""))
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","无【购买姓名】信息！");				
				return;
			}
			if (GuestTel.equals(""))
			{
				ReturnJson.put("MsgID","-1");
				ReturnJson.put("MsgTest","无【手机号码】信息！");
				return;
			}		
			String MemberID=request.getSession().getAttribute("MemberID")==null?"":(String)request.getSession().getAttribute("MemberID");
			String openid=request.getSession().getAttribute("openid")==null?"":(String)request.getSession().getAttribute("openid");
			
			MySQLTable apply=new MySQLTable("select *from amca_member_card_apply where amca_id_amb='"+MemberID+"'");
			try
			{
				apply.Open();
				if (!apply.next())
				{
					apply.moveToInsertRow();
					apply.updateString("_Status", "I");
					apply.updateString("amca_id", GlobalVariable.GUIDString());
					apply.updateString("amca_id_amb", MemberID);
				}
				
				apply.updateString("amca_GuestName", GuestName);
				apply.updateString("amca_GuestTel", GuestTel);
				apply.updateDateTime("amca_CreateDate", new Date());
				
				String AmcaID=apply.getString("amca_id");
					
				apply.PostRow();
				ReturnJson.put("MsgID","1");
				ReturnJson.put("MsgTest","申请提交成功！");
				
				
		
	    		
				String touser=openid;
				String url=GlobalVariable.WebUrl+"/tx/card/MemberCard.jsp";
				String keyword1="次卡";
				String keyword3="申请次卡";
				String keyword4="首次申请开通次卡功能";
				String remark="您的次卡办理申请已提交 ，请与客服联系。";

				TMessageMemberCard MessageMemberCard=new TMessageMemberCard(touser,url,keyword1,keyword3,keyword4,remark);
				MessageMemberCard.Send();

				touser=GlobalVariable.AdminWeiXinOpenID;
				url=GlobalVariable.WebUrl+"/tx/card/MemberCardCreate.jsp?ID="+AmcaID;
				remark="有客人发起了购买次卡的申请，请及时处理！\r\n客人名姓："+GuestName+"\r\n手机号码："+GuestTel;
				TMessageMemberCard MessageMemberCard2=new TMessageMemberCard(touser,url,keyword1,keyword3,keyword4,remark);
				MessageMemberCard2.Send();
				  
				
				
				
			}
			finally
			{
				apply.Close();
			}
			
		}
		finally
		{
			response.getWriter().print(ReturnJson.toString());
			response.getWriter().flush();	
		}
	}
}
