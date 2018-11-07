package com.java.web.weixin.tx.Coupons.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;
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

import com.java.sql.table.MySQLTable;
import com.java.web.weixin.base.GlobalVariable;

@WebServlet("/Coupons/PostCouponsInfo")
public class PostCouponsInfoServlet extends HttpServlet {

  /**
   * 
   */
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    // TODO Auto-generated method stub
    super.doGet(req, resp);

  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    // TODO Auto-generated method stub

    System.out.println("PostCouponsInfo");

    BufferedReader bufferReader = req.getReader();

    StringBuffer buffer = new StringBuffer();
    String line = " ";
    while ((line = bufferReader.readLine()) != null) {
      buffer.append(line);
    }

    System.out.println(buffer.toString());
    JSONObject DataJson = null;
    try {
      DataJson = new JSONObject(buffer.toString());
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json错误！");
      return;
    }
    String ac_ID;
    try {
      ac_ID = DataJson.getJSONArray("DataRows").getJSONObject(0).getString("id");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(id)");
      return;
    }
    String ac_Name;
    try {
      ac_Name = DataJson.getJSONArray("DataRows").getJSONObject(0).getString("Name");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(Name)");
      return;
    }
    String ac_ShtName;
    try {
      ac_ShtName = DataJson.getJSONArray("DataRows").getJSONObject(0).getString("ShtName");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(ShtName)");
      return;
    }
    String ac_Remark;
    try {
      ac_Remark = DataJson.getJSONArray("DataRows").getJSONObject(0).getString("Remark");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(Remark)");
      return;
    }
    boolean ac_flag;
    try {
      ac_flag = DataJson.getJSONArray("DataRows").getJSONObject(0).getBoolean("Useflag");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(Useflag)");
      return;
    }
    String ac_TimeValidity;
    try {
      ac_TimeValidity = DataJson.getJSONArray("DataRows").getJSONObject(0).getString("TimeValidity");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(TimeValidity)");
      return;
    }
    String ac_TicketCount;
    try {
      ac_TicketCount = DataJson.getJSONArray("DataRows").getJSONObject(0).getString("TicketCount");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(TicketCount)");
      return;
    }

    net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();
    MySQLTable table = new MySQLTable("select * from ac_coupons where ac_id='" + ac_ID+"'");
    try {
      table.Open();
      if (table.next()) {
        table.updateString("_Status", "E");
        table.updateString("_User_Lst", GlobalVariable.GetMemberID(req));
        table.updateDateTime("_Date_Lst", new java.sql.Date(new Date().getTime()));
      } 
      else{
        table.moveToInsertRow();
        table.updateString("ac_ID", GlobalVariable.GUIDString());
        table.updateString("_Status", "I");
        table.updateString("_User_Ins", GlobalVariable.GetMemberID(req));
        table.updateDateTime("_Date_Ins", new java.sql.Date(new Date().getTime()));

      } 
      table.updateString("ac_Name", ac_Name);
      table.updateString("ac_ShtName", ac_ShtName);
      table.updateString("ac_Remark", ac_Remark);
      table.updateInt("ac_id_amp", 2);
      table.updateString("ac_TimeValidity", ac_TimeValidity);
      table.updateString("ac_TicketCount", ac_TicketCount);
      table.updateBoolean("ac_flag", ac_flag);
      table.updateBoolean("_SyncFlag", false);
      table.PostData();

      ResultXml.put("MsgID", 1);
      ResultXml.put("MsgText", "数据保存成功！");
      
    }catch (SQLException e) {
      // TODO: handle exception
      e.printStackTrace();
      ResultXml.put("MsgID", -1);
      ResultXml.put("MsgText", "数据保存失败！请重试！<br>"+e.getMessage());
    }
    finally {
      // TODO: handle finally clause
      table.Close();
    }

    try {
      resp.setContentType("application/json;charset=utf-8");
      resp.setCharacterEncoding("UTF-8");
      resp.setHeader("Cache-Control", "no-cache");
      resp.getWriter().print(ResultXml.toString());
      resp.getWriter().flush();
    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }

  }

}
