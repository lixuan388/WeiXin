package com.java.web.weixin.tx.Class.booking;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Currency;
import java.util.Date;
import java.util.List;

import com.java.sql.SQLConnect;
import com.java.web.weixin.base.GlobalVariable;

public class TMedicalProjectList {

  List<TMedicalProjectListItem> Item = new ArrayList<TMedicalProjectListItem>();
  public int ErrCode;
  public String ErrText;

  public TMedicalProjectList() {
    ErrCode = -1;
    ErrText = "";

    Statement stmt = null;
    Connection con = null;

    try {
      con = SQLConnect.GetConnect();
      if (con == null) {
        ErrText = "数据库连接异常";
        ErrCode = -100;
        return;
      }
      try {
        stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = null;
        try {
          String sql = "select amp_id,amp_name,amp_remark,amp_image,amp_money,amp_money2,amp_NameSht from amp_Medical_Project where amp_Useflag=1 order by amp_id";

          rs = stmt.executeQuery(sql);
          while (rs.next()) {
            TMedicalProjectListItem item = new TMedicalProjectListItem(rs.getInt("amp_id"), rs.getString("amp_name"),
                rs.getString("amp_NameSht"), rs.getString("amp_remark"), rs.getString("amp_image"),
                rs.getFloat("amp_money"), rs.getFloat("amp_money2"));
            Item.add(item);
          }

        } catch (SQLException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();

          ErrText = e.getMessage();
          ErrCode = -101;
          return;
        } finally {
          if (rs != null)
            try {
              rs.close();
            } catch (Exception e) {
            }
        }

      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
        ErrText = e.getMessage();
        ErrCode = -102;
        return;
      } finally {
        if (stmt != null)
          try {
            stmt.close();
          } catch (Exception e) {
          }
      }
    } finally {
      if (con != null)
        try {
          con.close();
        } catch (Exception e) {
        }
    }
    ErrCode = 1;
  }

  public int Length() {
    return Item.size();
  }

  public TMedicalProjectListItem GetItem(int index) {
    return Item.get(index);
  }

  public class TMedicalProjectListItem {
    public int ID;
    public String Name;
    public String NameSht;
    public String Remark;
    public String ImageUrl;
    public Float Money;
    public Float Money2;

    public TMedicalProjectListItem(int ID, String Name, String NameSht, String Remark, String ImageUrl, Float Money,
        Float Money2) {
      this.ID = ID;
      this.Name = Name;
      this.NameSht = NameSht;
      this.Remark = Remark;
      this.ImageUrl = ImageUrl;
      this.Money = Money;
      this.Money2 = Money2;
    }
  }

}
