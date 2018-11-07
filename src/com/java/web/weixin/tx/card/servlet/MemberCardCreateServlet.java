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
@WebServlet("/card/MemberCardCreate")
public class MemberCardCreateServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;

  /**
   * @see HttpServlet#HttpServlet()
   */
  public MemberCardCreateServlet() {
    super();
    // TODO Auto-generated constructor stub
  }

  /**
   * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
   *      response)
   */
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // TODO Auto-generated method stub
    response.setContentType("application/json;charset=utf-8");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache");

    net.sf.json.JSONObject ReturnJson = new net.sf.json.JSONObject();

    Map<String, String[]> params = request.getParameterMap();
    String GuestName = params.get("GuestName") == null ? "" : (String) (params.get("GuestName")[0]);
    String GuestTel = params.get("GuestTel") == null ? "" : (String) (params.get("GuestTel")[0]);
    String Count = params.get("Count") == null ? "" : (String) (params.get("Count")[0]);
    String Money = params.get("Money") == null ? "" : (String) (params.get("Money")[0]);
    String EndDate = params.get("EndDate") == null ? "" : (String) (params.get("EndDate")[0]);
    String AmcaID = params.get("ID") == null ? "" : (String) (params.get("ID")[0]);
    String MemberID = params.get("MemberID") == null ? "" : (String) (params.get("MemberID")[0]);
    String CreateDate = params.get("CreateDate") == null ? "" : (String) (params.get("CreateDate")[0]);
    String acid = params.get("acid") == null ? "" : (String) (params.get("acid")[0]);

    GuestName = URLDecoder.decode(GuestName, "utf-8");

    try {
      if (GuestName.equals("")) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "无【购买姓名】信息！");
        return;
      }
      if (GuestTel.equals("")) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "无【手机号码】信息！");
        return;
      }
      if (Count.equals("")) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "无【使用次数】信息！");
        return;
      }
      if (Money.equals("")) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "无【充值金额】信息！");
        return;
      }
      if (EndDate.equals("")) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "无【有效期限】信息！");
        return;
      }
      if (MemberID.equals("")) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "无【微信号码】信息！");
        return;
      }
      String UserID = request.getSession().getAttribute("MemberID") == null ? ""
          : (String) request.getSession().getAttribute("MemberID");

      if (CreateDate.equals("")) {
        CreateDate = "now()";
      } else {
        CreateDate = "'" + CreateDate + "'";
      }
      String AmcID = GlobalVariable.GUIDString();
      String SqlString = "INSERT INTO amc_member_card\r\n"
          + "(amc_id,_Status,_User_Ins,_Date_Ins,amc_id_amb,amc_GuestName,amc_GuestTel,amc_CreateDate,amc_Count,amc_Money,amc_EndDate)\r\n"
          + "VALUES('" + AmcID + "','I','" + UserID + "',now(),\r\n" + "'" + MemberID + "','" + GuestName + "','"
          + GuestTel + "'," + CreateDate + "," + Count + "," + Money + ",'" + EndDate + "');\r\n";
//			System.out.println(SqlString);
      MySQLUpdate update = new MySQLUpdate();
      if (update.Update(SqlString)) {
        ReturnJson.put("MsgID", "1");
        ReturnJson.put("MsgTest", "发卡成功！");
      } else {

        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "发卡失败！");
      }
      int TicketCount=0;
      if (!acid.equals("")) {
        TicketCount=MemberCardFunction.SendCoupons(MemberID,AmcID, acid, UserID);
      }
      

      MemberCardFunction.InsertHistory(UserID, MemberID, AmcID, "开卡", Count, Money, EndDate);

      SqlString = "update amca_member_card_apply set _Status='E', _User_Lst='" + UserID
          + "',_Date_Lst=now() where amca_id='" + AmcaID + "';";
      update.Update(SqlString);

      MySQLTable member = new MySQLTable("select amb_WXID from amb_member where amb_id='" + MemberID + "'");
      try {
        member.Open();
        if (member.next()) {
          String touser = member.getString("amb_WXID");
          String url = GlobalVariable.WebUrl + "/tx/card/MemberCard.jsp";
          String keyword1 = "次卡";
          String keyword3 = "申请次卡";
          String keyword4 = "办理成功";
          String remark = "您的次卡已成功办理。\r\n客人名姓：" + GuestName + "\r\n手机号码：" + GuestTel + "\r\n充值次数：" + Count + "\r\n充值金额："
              + Money;
          if (TicketCount>0) {
            remark=remark+"\r\n赠券"+TicketCount+"张";
          }
          TMessageMemberCard MessageMemberCard = new TMessageMemberCard(touser, url, keyword1, keyword3, keyword4,
              remark);
          MessageMemberCard.Send();
          touser = GlobalVariable.AdminWeiXinOpenID;
          url = GlobalVariable.WebUrl + "/tx/card/MemberCardEdit.jsp?ID="+AmcID+"&d="+new Date().getTime();
          remark = "次卡发卡成功！\r\n客人名姓：" + GuestName + "\r\n手机号码：" + GuestTel + "\r\n充值次数：" + Count + "\r\n充值金额：" + Money+"\r\n点击记录可直接跳转至【次卡操作】";

          if (TicketCount>0) {
            remark=remark+"\r\n赠券"+TicketCount+"张";
          }
          TMessageMemberCard MessageMemberCard2 = new TMessageMemberCard(touser, url, keyword1, keyword3, keyword4,
              remark);
          MessageMemberCard2.Send();
        }
      } finally {
        member.Close();
      }
    } finally {
      response.getWriter().print(ReturnJson.toString());
      response.getWriter().flush();
    }
  }
}
