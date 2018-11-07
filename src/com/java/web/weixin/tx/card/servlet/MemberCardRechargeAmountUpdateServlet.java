package com.java.web.weixin.tx.card.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

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

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/card/MemberCardRechargeAmountPost.json")
public class MemberCardRechargeAmountUpdateServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;

  /**
   * @see HttpServlet#HttpServlet()
   */
  public MemberCardRechargeAmountUpdateServlet() {
    super();
    // TODO Auto-generated constructor stub
  }

  /**
   * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
   *      response)
   */
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // TODO Auto-generated method stub

    String groupid = request.getSession().getAttribute("groupid") == null ? "0"
        : (String) request.getSession().getAttribute("groupid");
    if (!groupid.equals("100") && !groupid.equals("101")) {
      String ErrText = "权限错误，无法操作！";
      GlobalVariable.WriteMsgText(response, -100, ErrText);
      return;
    }

    BufferedReader bufferReader = request.getReader();

    StringBuffer buffer = new StringBuffer();
    String line = " ";
    while ((line = bufferReader.readLine()) != null) {
      buffer.append(line);
    }

//	    System.out.println(buffer.toString());
    JSONObject DataJson = null;
    try {
      DataJson = new JSONObject(buffer.toString());
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(response, -1, "json错误！");
      return;
    }

    MySQLTable table = new MySQLTable();

    int Length = 0;
    try {
      Length = DataJson.getJSONArray("DataRows").length();
    } catch (JSONException e2) {
      // TODO Auto-generated catch block
      e2.printStackTrace();
    }

    for (int i = 0; i < Length; i++) {
      JSONObject DataJsonChild = null;
      try {
        DataJsonChild = DataJson.getJSONArray("DataRows").getJSONObject(i);
      } catch (JSONException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }

      int amcra_id;
      try {
        amcra_id = DataJsonChild.getInt("ID");
      } catch (JSONException e1) {
        // TODO Auto-generated catch block
        e1.printStackTrace();
        GlobalVariable.WriteMsgText(response, -1, "json数据错误！(ID)");
        return;
      }

      int amcra_Count;
      try {
        amcra_Count = DataJsonChild.getInt("Count");
      } catch (JSONException e1) {
        // TODO Auto-generated catch block
        e1.printStackTrace();
        GlobalVariable.WriteMsgText(response, -1, "json数据错误！(Count)");
        return;
      }
      int amcra_Money;
      try {
        amcra_Money = DataJsonChild.getInt("Money");
      } catch (JSONException e1) {
        // TODO Auto-generated catch block
        e1.printStackTrace();
        GlobalVariable.WriteMsgText(response, -1, "json数据错误！(Money)");
        return;
      }
      int amcra_flag;
      try {
        amcra_flag = DataJsonChild.getInt("Flag");
      } catch (JSONException e1) {
        // TODO Auto-generated catch block
        e1.printStackTrace();
        GlobalVariable.WriteMsgText(response, -1, "json数据错误！(Flag)");
        return;
      }
      String amcra_id_ac;
      try {
        amcra_id_ac = DataJsonChild.getString("Coupons");
      } catch (JSONException e1) {
        // TODO Auto-generated catch block
        e1.printStackTrace();
        GlobalVariable.WriteMsgText(response, -1, "json数据错误！(Coupons)");
        return;
      }

      table.SQL("select * from  amcra_member_card_recharge_amount where amcra_id=" + amcra_id);
      try {
        table.Open();
        if (!table.next()) {
          table.moveToInsertRow();
          table.updateString("_Status", "I");
          table.updateString("_User_Ins", GlobalVariable.GetMemberID(request));
          table.updateDateTime("_Date_Ins", new Date());
          table.updateBoolean("amcra_Flag", true);

        } else {
          table.updateString("_Status", "E");
          table.updateString("_User_Lst", GlobalVariable.GetMemberID(request));
          table.updateDateTime("_Date_Lst", new Date());
        }
        table.updateBoolean("_SyncFlag", false);
        table.updateInt("amcra_Count", amcra_Count);
        table.updateInt("amcra_Money", amcra_Money);
        table.updateInt("amcra_flag", amcra_flag);
        table.updateString("amcra_id_ac", amcra_id_ac);
        table.PostRow();
      } finally {
        table.Close();
      }

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
