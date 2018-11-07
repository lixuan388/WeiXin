package com.java.sql.table;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import com.java.sql.SQLConnect;
import com.java.web.weixin.base.GlobalVariable;

public class MySQLTable {
  
  private Statement stmt = null;
  private Connection con = null;
  private ResultSet rs = null;
  private String TableSql = "";
  
  private int EditMode = 0;
  private static final int EM_Edit = 0;
  private static final int EM_Insert = 1;
  
  public MySQLTable() {
    
  }
  
  public MySQLTable(String sql) {
    this.SQL(sql);
  }
  
  public void SQL(String sql) {
    this.TableSql = sql;
  }
  
  public boolean Open() {
    Close();
    EditMode = EM_Edit;
    if (this.TableSql.equals("")) {
      System.out.println("无SQL语句 ");
      return false;
    }
    this.con = SQLConnect.GetConnect();
    if (this.con == null) {
      System.out.println("数据库连接异常");
      return false;
    }
    try {
      this.stmt = this.con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
      try {
        this.rs = this.stmt.executeQuery(this.TableSql);
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
        return false;
      }
    } catch (SQLException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      return false;
    }
    return true;
  }
  
  public void Close() {
    if (this.rs != null)
      try {
        this.rs.close();
      } catch (Exception e) {
      }
    if (this.stmt != null)
      try {
        this.stmt.close();
      } catch (Exception e) {
      }
    if (this.con != null)
      try {
        this.con.close();
      } catch (Exception e) {
      }
  }
  
  public boolean next() {
    if (rs != null) {
      try {
        return rs.next();
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    } else {
      System.out.println("rs=null");
    }
    return false;
  }
  
  public void updateString(String columnLabel, String value) {
    if (rs != null) {
      try {
        rs.updateString(columnLabel, value);
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    
  }
  
  public String getString(String columnLabel) {
    if (rs != null) {
      try {
        String value = rs.getString(columnLabel);
        if (rs.wasNull()) {
          return "";
        } else {
          return value;
        }
        
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    
    return "";
    
  }
  
  public void updateInt(String columnLabel, int value) {
    if (rs != null) {
      try {
        rs.updateInt(columnLabel, value);
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    
  }
  
  public int getInt(String columnLabel) {
    if (rs != null) {
      try {
        return rs.getInt(columnLabel);
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    return 0;
  }
  
  public void updateDouble(String columnLabel, double value) {
    if (rs != null) {
      try {
        rs.updateDouble(columnLabel, value);
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
  }
  
  public double getDouble(String columnLabel) {
    if (rs != null) {
      try {
        return rs.getDouble(columnLabel);
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    return 0;
    
  }
  
  public void updateBoolean(String columnLabel, boolean value) {
    if (rs != null) {
      try {
        rs.updateBoolean(columnLabel, value);
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
  }
  
  public boolean getBoolean(String columnLabel) {
    if (rs != null) {
      try {
        return rs.getBoolean(columnLabel);
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    return false;
  }
  
  public void updateDateTime(String columnLabel, java.util.Date value) {
    if (rs != null) {
      try {
        rs.updateTimestamp(columnLabel, new Timestamp(value.getTime()));
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
  }
  
  public Timestamp getDateTime(String columnLabel) {
    
    if (rs != null) {
      try {
        return rs.getTimestamp(columnLabel);
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    return null;
  }
  
  public void moveToInsertRow() {
    if (rs != null) {
      try {
        rs.moveToInsertRow();
        EditMode = EM_Insert;
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
  }
  
  public void insertRow() {
//		if (rs!=null)
//		{
//			try {
//				rs.insertRow();
//			} catch (SQLException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//		}
    moveToInsertRow();
  }
  
  public void updateRow() {
    if (rs != null) {
      try {
        rs.updateRow();
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
  }

  public void PostRow() {
    if (rs != null) {
      try {
        switch (EditMode) {
        case EM_Edit:
          rs.updateRow();
          break;
        case EM_Insert:
          rs.insertRow();
          break;
        }
      } catch (SQLException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
  }
  public void PostData() throws SQLException {
    if (rs != null) {
        switch (EditMode) {
        case EM_Edit:
          rs.updateRow();
          break;
        case EM_Insert:
          rs.insertRow();
          break;
        }
    }
  }
  
}
