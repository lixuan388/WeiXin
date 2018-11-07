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
import com.java.web.weixin.tx.card.MemberCardFunction;

@WebServlet("/Coupons/UseCoupons")
public class UseCouponsServlet extends HttpServlet {

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
    String ticketID;
    try {
      ticketID = DataJson.getString("ticketID");
    } catch (JSONException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
      GlobalVariable.WriteMsgText(resp, -1, "json数据错误！(ticketID)");
      return;
    }

    net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();
    MySQLUpdate update = new MySQLUpdate();
    String sql="UPDATE amc_member_coupons SET amc_Date_Use =now(),amc_UseFlag =1,_User_Lst = '"+GlobalVariable.GetMemberID(req)+"',_Date_Lst =now(),_SyncFlag =0 WHERE amc_id ='"+ticketID+"'";
    System.out.println(sql);
    if (update.Update(sql))
    {
      ResultXml.put("MsgID", 1);
      ResultXml.put("MsgText", "数据保存成功！");

      String AmcID=(String)req.getSession().getAttribute("CountAmcID");
      String MemberID=(String)req.getSession().getAttribute("CountMemberID");

      MemberCardFunction.InsertHistory(GlobalVariable.GetMemberID(req), MemberID, AmcID, "用券", "-1", "0", "");
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
