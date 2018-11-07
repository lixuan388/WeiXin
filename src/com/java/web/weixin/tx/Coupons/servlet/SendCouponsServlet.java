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
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;

@WebServlet("/Coupons/SendCoupons")
public class SendCouponsServlet extends HttpServlet {

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
    String MemberID;
    try {
      MemberID = DataJson.getString("MemberID");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(MemberID)");
      return;
    }
    String CouponsID;
    try {
      CouponsID = DataJson.getString("CouponsID");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(MemberID)");
      return;
    }

    net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();
    MySQLUpdate update = new MySQLUpdate();
    String sql="INSERT INTO amc_member_coupons(amc_id_amb,amc_id_ac,amc_Name,amc_TimeValidity,amc_Date_Send,amc_id_amp,\r\n" +
        "amc_UseFlag,amc_Flag,_Status,_User_Ins,_Date_Ins,_SyncFlag)\r\n" + 
        "select '"+MemberID+"',ac_id,ac_Name,DATE_ADD(now(),INTERVAL  ac_TimeValidity DAY),now(),ac_id_amp,\r\n" + 
        "0,1,'I','"+GlobalVariable.GetMemberID(req)+"',now(),0 from ac_Coupons where ac_id='"+CouponsID+"'";
    System.out.println(sql);
    if (update.Update(sql))
    {
      ResultXml.put("MsgID", 1);
      ResultXml.put("MsgText", "数据保存成功！");
    }
    else {

      ResultXml.put("MsgID", -1);
      ResultXml.put("MsgText", "数据保存失败！请重试！");
    }
    update.Close();

      

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
