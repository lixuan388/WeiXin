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
import com.java.sql.table.MySQLTable;
import com.java.web.weixin.base.GlobalVariable;


public class TBookingDatePay {
	
	public int ErrCode;
	public String ErrText;
	
	
	public int abdid;
	public int ampid;
	public String name;
	public String remark;
	public String bookingdatetime;
	public String bookingDate;
	public int MaxBooking;
	public int HasBooking;
	public Float Money;
	
	public TBookingDatePay(String ID,String MemberID,String Level)
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
			    	String sql="select abd_id,amp_id,amp_name,amp_remark,amp_money,amp_money2,abd_bookingdatetime,abd_MaxBooking,abd_HasBooking,abd_bookingDate "+
			    				" from abd_bookingdatetime,amp_Medical_Project where abd_status<>'D' and abd_id_amp=amp_id and   abd_id="+ID;
			    	
					rs = stmt.executeQuery(sql);   
					if (rs.next())
					{		
						abdid=rs.getInt("abd_id");
						ampid=rs.getInt("amp_id");
						name=rs.getString("amp_name");
						remark=rs.getString("amp_remark");
						
						SimpleDateFormat formatter; 
						formatter = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
						String StringDate =formatter.format(rs.getTimestamp("abd_bookingdatetime"));	
						
						bookingDate =formatter.format(rs.getTimestamp("abd_bookingDate"));
						
						bookingdatetime=StringDate;
						MaxBooking=rs.getInt("abd_MaxBooking");
						HasBooking=rs.getInt("abd_HasBooking");
						if (Level.equals("2"))
						{
							Money=rs.getFloat("amp_money2");
						}
						else
						{
							Money=rs.getFloat("amp_money");
						}
						
					}
					else
					{
						ErrText="无对应的记录！";
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
	    String SqlCheck="select 0  from abdp_bookingdatetime_pay,abd_bookingdatetime "+
	    			" where abdp_id_abd=abd_id and abdp_id_amb='"+MemberID+"' "+
	    			" and abd_bookingdate='"+bookingDate+"' "+
	    			" and abd_id_amp= "+ampid+
	    			" and abdp_bookingdatetime_pay._Status<>'D' "+
	    			" and abdp_money=0 ";
	    MySQLTable tableCheck=new MySQLTable(SqlCheck);
	    tableCheck.Open();
		if (tableCheck.next())
		{
			ErrText="此微信号，同一天内，已预订了其它时间段，不可重复预订！";
			ErrCode=-103;
			return ;
		}
	}
	

}
