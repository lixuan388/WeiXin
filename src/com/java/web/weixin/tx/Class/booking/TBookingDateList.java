package com.java.web.weixin.tx.Class.booking;

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


public class TBookingDateList {
	
	List<TBookingDateListItem> Item =new ArrayList<TBookingDateListItem>();
	public int ErrCode;
	public String ErrText;
	public TBookingDateList(String MPType,String StartDate)
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
			    	String sql=" select abd_bookingdate,sum(abd_maxbooking) as abd_maxbooking,sum(ifnull(abd_hasBooking,0)) as abd_hasbooking ,amps_flag "+
			    				" from abd_BookingDatetime,amps_medical_project_schedule,amp_medical_project   "+
			    				" where abd_BookingDatetime._status<>'D' and amps_medical_project_schedule._status<>'D'  and  abd_bookingdate>='"+StartDate+"' and abd_id_amp="+MPType+" "+
			    				" and abd_id_amp=amps_id_amp  and amps_id_amp=amp_id  and abd_bookingdate=amps_date and datediff(abd_bookingdatetime,'"+StartDate+"')<amp_MaxDay and  abd_bookingdatetime>now() "+
			    				" and amps_flag=1"+
			    				" group by abd_bookingdate "+
			    				" order by abd_bookingdate ";
			    	//System.out.println(sql);
					rs = stmt.executeQuery(sql);   
					while (rs.next())
					{						
						TBookingDateListItem item=new TBookingDateListItem(rs.getDate("abd_bookingdate"), rs.getInt("abd_maxbooking"), rs.getInt("abd_hasbooking"),rs.getBoolean("amps_flag"));
						Item.add(item);
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
	

	
	
	public int Length()
	{
		return Item.size();
	}
	
	public TBookingDateListItem GetItem(int index)
	{
		return Item.get(index);
	}
	 
	public class TBookingDateListItem{
		public String BookingDate;
		public String Week;
		public int MaxBooking;
		public int HasBooking;
		public boolean Flag;
		
		public TBookingDateListItem(Date BookingDate,int MaxBooking,int HasBooking,boolean Flag)
		{
			SimpleDateFormat formatter; 
			formatter = new SimpleDateFormat ("yyyy-MM-dd");
			String StringDate =formatter.format(BookingDate);	
			
			
			this.Week=GlobalVariable.getWeekOfDate(BookingDate);
			this.BookingDate=StringDate;
			this.MaxBooking=MaxBooking;
			this.HasBooking=HasBooking;
			this.Flag=Flag;
		}
	}

}
