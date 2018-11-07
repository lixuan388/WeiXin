package com.java.sql.table;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import com.java.sql.SQLConnect;
import com.java.web.weixin.base.GlobalVariable;

public class MySQLUpdate {
	
	
	private Statement stmt = null;
	private Connection con = null;

	public MySQLUpdate()
	{
		
	}
	
	public boolean Update(String sql)
	{
		Close();
		this.con=SQLConnect.GetConnect();
       	if (this.con==null)
       	{
       		System.out.println("数据库连接异常");
       		return false;
       	}    	     
		try {
			this.stmt = this.con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
		    	
			this.stmt.executeUpdate(sql);					

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
	        return false;
		}			
	    return true;
	}
	
	public void Close()
	{
		if (this.stmt != null) try { this.stmt.close(); } catch(Exception e) {}
		if (this.con != null) try { this.con.close(); } catch(Exception e) {}
	}	

}
