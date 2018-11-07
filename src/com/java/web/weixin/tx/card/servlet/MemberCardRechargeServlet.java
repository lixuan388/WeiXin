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
@WebServlet("/card/MemberCardRecharge")
public class MemberCardRechargeServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;

  /**
   * @see HttpServlet#HttpServlet()
   */
  public MemberCardRechargeServlet() {
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
    String AmcID = params.get("ID") == null ? "" : (String) (params.get("ID")[0]);
    String Count = params.get("Count") == null ? "" : (String) (params.get("Count")[0]);
    String Money = params.get("Money") == null ? "" : (String) (params.get("Money")[0]);
    String EndDate = params.get("EndDate") == null ? "" : (String) (params.get("EndDate")[0]);
    String acid = params.get("acid") == null ? "" : (String) (params.get("acid")[0]);

    String CountAmcID = request.getSession().getAttribute("CountAmcID") == null ? ""
        : (String) request.getSession().getAttribute("CountAmcID");
    String CountMemberID = request.getSession().getAttribute("CountMemberID") == null ? ""
        : (String) request.getSession().getAttribute("CountMemberID");

    String groupid = request.getSession().getAttribute("groupid") == null ? ""
        : (String) request.getSession().getAttribute("groupid");

    if ((!groupid.equals("101")) && (!groupid.equals("100"))) {
      ReturnJson.put("MsgID", "-1");
      ReturnJson.put("MsgTest", "无权限操作");
      return;
    }

    try {
      if (AmcID.equals("")) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "无【卡号】信息！");
        return;
      }
      if (!AmcID.equals(CountAmcID)) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "【卡号】信息异常,不可操作！");
        return;
      }
      if (Count.equals("")) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "无【次数】信息！");
        return;
      }
      if (Money.equals("")) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "无【金额】信息！");
        return;
      }
      if (EndDate.equals("")) {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "无【延期】信息！");
        return;
      }

      String UserID = request.getSession().getAttribute("MemberID") == null ? ""
          : (String) request.getSession().getAttribute("MemberID");

      if (MemberCardFunction.UpdateCount(UserID, CountMemberID, AmcID, "充值", Count, Money, EndDate)) {
        int TicketCount=0;
        if (!acid.equals("")) {
          TicketCount=MemberCardFunction.SendCoupons(CountMemberID,AmcID, acid, UserID);
        }
        int count = MemberCardFunction.GetCardCount(AmcID);
        ReturnJson.put("MsgID", "1");
        ReturnJson.put("MsgTest", "充值成功！");
        ReturnJson.put("Count", count);
        MySQLTable member = new MySQLTable(
            "select amb_WXID,amc_GuestName,amc_GuestTel from amb_member,amc_member_card  where amc_id_amb=amb_id and amb_id='"
                + CountMemberID + "'");
        try {
          member.Open();
          if (member.next()) {
            String touser = member.getString("amb_WXID");
            String url = GlobalVariable.WebUrl + "/tx/card/MemberCard.jsp";
            String keyword1 = "次卡";
            String keyword3 = "充值";
            String keyword4 = "充值成功";
            String remark = "您的次卡已充值成功。\r\n姓名：" + member.getString("amc_GuestName") + "\r\n手机："
                + member.getString("amc_GuestTel") + "\r\n充值次数：" + Count + "\r\n充值金额：" + Money;
            if (TicketCount>0) {
              remark=remark+"\r\n赠券"+TicketCount+"张";
            }

            TMessageMemberCard MessageMemberCard = new TMessageMemberCard(touser, url, keyword1, keyword3, keyword4,
                remark);
            MessageMemberCard.Send();

            touser = GlobalVariable.AdminWeiXinOpenID;
            url = GlobalVariable.WebUrl + "/tx/card/MemberCardEdit.jsp?ID=" + AmcID;
            remark = "客人次卡已充值成功。\r\n姓名：" + member.getString("amc_GuestName") + "\r\n手机："
                + member.getString("amc_GuestTel") + "\r\n充值次数：" + Count + "\r\n充值金额：" + Money;
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
      } else {
        ReturnJson.put("MsgID", "-1");
        ReturnJson.put("MsgTest", "充值失败！");
      }

    } finally {
      response.getWriter().print(ReturnJson.toString());
      response.getWriter().flush();
    }
  }
}
