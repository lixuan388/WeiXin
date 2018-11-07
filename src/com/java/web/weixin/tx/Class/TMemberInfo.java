package com.java.web.weixin.tx.Class;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.java.sql.SQLConnect;
import com.java.web.weixin.base.GlobalVariable;


public class TMemberInfo {
	
	public int ErrCode;
	public String ErrText;
	
	public String amb_name;
	public String amb_Tel;
	public TMemberInfo(String ambID)
	{
		ErrCode=-1;
		ErrText="";

		Statement stmt = null;
	    Connection con = null;
 		
	    try {       	
        	con=SQLConnect.GetConnect();
           	if (con==null)
           	{
           		ErrText="数据库连接异常";
        		ErrCode=-100;
           		return ;
           	}    	     
			try {
				stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
			    ResultSet rs = null;  
			    try {
			    	String sql=" select amb_Name,amb_Tel from amb_member where amb_id='"+ambID+"' ";
			    	
					rs = stmt.executeQuery(sql);   
					if (rs.next())
					{						
						amb_name=rs.getString("amb_Name");
						amb_Tel=rs.getString("amb_Tel");
					}
					else
					{
						ErrText="无对应记录！";
		        		ErrCode=-1;
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
	           		ErrText=e.getMessage();
	        		ErrCode=-101;
			        return ;
				}
				finally {
					if (rs != null) try { rs.close(); } catch(Exception e) {}
			    }     		
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
           		ErrText=e.getMessage();
        		ErrCode=-102;
		        return ;
			}	
			finally {
		        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
		    }     
		} 
	    finally {
           if (con != null) try { con.close(); } catch(Exception e) {}
	    }      
	    ErrCode=1;
	}
	

	
	 

}
