package com.java.web.weixin.tx.card.servlet;

import java.io.BufferedReader;
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

import org.json.JSONException;
import org.json.JSONObject;

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
@WebServlet("/card/MemberCardEditRemark")
public class MemberCardEditRemarkServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;

  /**
   * @see HttpServlet#HttpServlet()
   */
  public MemberCardEditRemarkServlet() {
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

    BufferedReader bufferReader = request.getReader();

    StringBuffer buffer = new StringBuffer();
    String line = " ";
    while ((line = bufferReader.readLine()) != null) {
      buffer.append(line);
    }
    JSONObject DataJson = null;
    try {
      DataJson = new JSONObject(buffer.toString());
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(response, -1, "json错误！");
      return;
    }

    String amc_id;
    try {
      amc_id = DataJson.getString("ID");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(response, -1, "json数据错误！(ID)");
      return;
    }

    String amc_Remark;
    try {
      amc_Remark = DataJson.getString("Remark");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(response, -1, "json数据错误！(Remark)");
      return;
    }
    

    MySQLTable table = new MySQLTable();
    table.SQL("select * from  amc_member_card where amc_id='"+amc_id+"'"  );
    try {
      table.Open();
      if (table.next()) {
        table.updateString("_Status", "E");
        table.updateString("_User_Lst", GlobalVariable.GetMemberID(request));
        table.updateDateTime("_Date_Lst", new Date());
        table.updateBoolean("_SyncFlag", false);
        table.updateString("amc_Remark", amc_Remark);
        table.PostRow();
      }
    } finally {
      table.Close();
    }

    net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();
    ResultXml.put("MsgID", "" + 1);
    ResultXml.put("MsgText", "数据保存成功！");
    try {
      response.setContentType("application/json;charset=utf-8");
      response.setCharacterEncoding("UTF-8");
      response.setHeader("Cache-Control", "no-cache");
      response.getWriter().print(ResultXml.toString());
      response.getWriter().flush();
    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
  }
}
