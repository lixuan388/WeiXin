package com.java.web.weixin.tx.card;

import java.io.IOException;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class MemberCardFunction {

  public static boolean InsertHistory(String UserID, String MemberID, String AmcID, String OpType, String Count,
      String Money, String EndDate) {

    MySQLUpdate update = new MySQLUpdate();
    if (!EndDate.equals("")) {
      String SqlString = "INSERT INTO amch_member_card_history\r\n"
          + "(amch_id,_Status,_User_Ins,_Date_Ins,amch_id_amb,amch_id_amc,amch_Type,amch_Date,amch_Count,amch_Money,amch_NewDate)\r\n"
          + "VALUES\r\n" + "('" + GlobalVariable.GUIDString() + "','I','" + UserID + "',now(),'" + MemberID + "','"
          + AmcID + "','" + OpType + "',now()," + Count + "," + Money + ",'" + EndDate + "');\r\n";

      return update.Update(SqlString);
    } else {
      String SqlString = "INSERT INTO amch_member_card_history\r\n"
          + "(amch_id,_Status,_User_Ins,_Date_Ins,amch_id_amb,amch_id_amc,amch_Type,amch_Date,amch_Count,amch_Money)\r\n"
          + "VALUES\r\n" + "('" + GlobalVariable.GUIDString() + "','I','" + UserID + "',now(),'" + MemberID + "','"
          + AmcID + "','" + OpType + "',now()," + Count + "," + Money + ");\r\n";

      return update.Update(SqlString);
    }

  }

  public static boolean UpdateCount(String UserID, String MemberID, String AmcID, String OpType, String Count,
      String Money, String EndDate) {
    MySQLUpdate update = new MySQLUpdate();
    String SqlString = "update amc_member_card set _SyncFlag=0, _User_Lst ='" + UserID
        + "',_Date_Lst=now(),amc_Count=amc_Count + " + Count + "\r\n";
    if (!Money.equals("0")) {
      SqlString = SqlString + " ,amc_Money=" + Money + "\r\n";
      SqlString = SqlString + " ,amc_CreateDate=now()\r\n";
    }
    if (!EndDate.equals("")) {
      SqlString = SqlString + " ,amc_EndDate='" + EndDate + "'\r\n";
    }
    SqlString = SqlString + " where amc_id='" + AmcID + "';";
    if (update.Update(SqlString)) {
      InsertHistory(UserID, MemberID, AmcID, OpType, Count, Money, EndDate);
      return true;
    } else {
      return false;
    }

  }

  public static boolean UpdateEndDate(String UserID, String MemberID, String AmcID, String OpType, String EndDate) {

    MySQLUpdate update = new MySQLUpdate();
    String SqlString = "update amc_member_card set _SyncFlag=0,_User_Lst ='" + UserID
        + "',_Date_Lst=now(),amc_EndDate='" + EndDate + "' \r\n" + " where amc_id='" + AmcID + "';";
    if (update.Update(SqlString)) {
      InsertHistory(UserID, MemberID, AmcID, OpType, "0", "0", EndDate);
      return true;
    } else {
      return false;
    }

  }

  public static int GetCardCount(String AmcID) {
    MySQLTable card = new MySQLTable("select amc_Count from amc_member_card where amc_id='" + AmcID + "';");
    try {
      card.Open();
      if (!card.next()) {
        return 0;
      } else {
        return card.getInt("amc_Count");
      }

    } finally {
      card.Close();
    }
  }

  public static String GetCardEndDate(String AmcID) {
    MySQLTable card = new MySQLTable("select amc_EndDate from amc_member_card where amc_id='" + AmcID + "';");
    try {
      card.Open();
      if (!card.next()) {
        return "";
      } else {
        java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String EndDate = format.format(card.getDateTime("amc_EndDate"));
        return EndDate;
      }
    } finally {
      card.Close();
    }
  }

  public static void GetCouponsListJson(PageContext page) {
    MySQLTable coupons = new MySQLTable("select ac_id,ac_name,ac_shtname from ac_coupons where ac_flag=1");
    try {
      coupons.Open();

      JspWriter buffer = page.getOut();

      JSONArray jsonArray=new JSONArray();
      while (coupons.next()) {
        
        JSONObject json=new JSONObject();
        json.put("id", coupons.getString("ac_id"));
        json.put("name", coupons.getString("ac_name"));
        json.put("shtname", coupons.getString("ac_shtname"));
        jsonArray.add(json);
      }
      try {
        buffer.append(jsonArray.toString());
      } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
      
    } finally {
      coupons.Close();
    }
  }
  public static void GetCouponsNameListJson(PageContext page) {
    MySQLTable coupons = new MySQLTable("select ac_id,ac_name from ac_coupons where ac_flag=1");
    try {
      coupons.Open();

      JspWriter buffer = page.getOut();

      JSONObject json=new JSONObject();
      while (coupons.next()) {
        
        json.put(coupons.getString("ac_id"), coupons.getString("ac_name"));
      }
      try {
        buffer.append(json.toString());
      } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
      
    } finally {
      coupons.Close();
    }
  }
  public static void GetCouponsShtNameListJson(PageContext page) {
    MySQLTable coupons = new MySQLTable("select ac_id,ac_shtname from ac_coupons where ac_flag=1");
    try {
      coupons.Open();

      JspWriter buffer = page.getOut();

      JSONObject json=new JSONObject();
      while (coupons.next()) {
        
        json.put(coupons.getString("ac_id"), coupons.getString("ac_shtname"));
      }
      try {
        buffer.append(json.toString());
      } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
      
    } finally {
      coupons.Close();
    }
  }
  
  


  public static int SendCoupons(String MemberID,String AmcID,String CouponsID,String UserID) {    
    int TicketCount=0;
    String CouponsShtName="";
    String CouponsName="";    
    MySQLTable coupons = new MySQLTable("select ac_id,ac_shtname,ac_name,ac_TicketCount from ac_coupons where ac_flag=1 and ac_id='"+CouponsID+"'");
    try {
      coupons.Open();
      
      if (coupons.next()) {
        TicketCount=coupons.getInt("ac_TicketCount");
        CouponsShtName=coupons.getString("ac_shtname");
        CouponsName=coupons.getString("ac_name");
      }
      
    } finally {
      coupons.Close();
    }
    if (TicketCount==0) {
      return 0;
    }
    MySQLUpdate update = new MySQLUpdate();
    try {
      String sql="INSERT INTO amc_member_coupons(amc_id_amb,amc_id_ac,amc_Name,amc_TimeValidity,amc_Date_Send,amc_id_amp,\r\n" +
          "amc_UseFlag,amc_Flag,_Status,_User_Ins,_Date_Ins,_SyncFlag)\r\n" + 
          "select '"+MemberID+"',ac_id,ac_Name,DATE_ADD(now(),INTERVAL  ac_TimeValidity DAY),now(),ac_id_amp,\r\n" + 
          "0,1,'I','"+UserID+"',now(),0 from ac_Coupons where ac_id='"+CouponsID+"'";
      System.out.println(sql);
      for (int i =0;i<TicketCount;i++) {
        update.Update(sql);
      }      
    } finally {
      update.Close();
    }
    InsertHistory(UserID, MemberID, AmcID, "赠券", ""+TicketCount, "0", "");
    
    
    return TicketCount;
  }
  
  
}
