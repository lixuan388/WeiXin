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


public class TBookingDateTimeList {
	
	List<TBookingDateTimeListItem> Item =new ArrayList<TBookingDateTimeListItem>();
	public int ErrCode;
	public String ErrText;
	
	public TBookingDateTimeList(String MPType,String StartDate,Boolean IsAll)
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
			    	String sql="select abd_id, abd_bookingdatetime,abd_maxbooking,ifnull(abd_hasBooking,0) as abd_hasbooking,abd_ModifyBooking ,amps_flag"+
			    				"  from abd_BookingDatetime ,amps_medical_project_schedule "+
			    				"  where  abd_BookingDatetime._status<>'D' and amps_medical_project_schedule._status<>'D' "+
			    				" and abd_id_amp=amps_id_amp and abd_bookingdate=amps_date "+
			    				" and abd_bookingdatetime>now() "+
			    				" and  abd_bookingdate='"+StartDate+"' and abd_id_amp="+MPType;
			    	if (!IsAll)
			    	{
			    		sql=sql+" and abd_maxbooking>0  ";
			    	}
			    	sql=sql+	" order by abd_bookingdatetime";
			    	//System.out.println(sql);
			    	
					rs = stmt.executeQuery(sql);   
					while (rs.next())
					{						
						TBookingDateTimeListItem item=new TBookingDateTimeListItem(rs.getInt("abd_id"),rs.getTime("abd_bookingdatetime"), rs.getInt("abd_maxbooking"), rs.getInt("abd_hasbooking"),rs.getInt("abd_ModifyBooking"), rs.getBoolean("amps_flag"));
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
	
	public TBookingDateTimeListItem GetItem(int index)
	{
		return Item.get(index);
	}
	 
	public class TBookingDateTimeListItem{
		public int ID;
		public String BookingDateTime;
		public int MaxBooking;
		public int HasBooking;
		public int ModifyBooking;
		public boolean Flag;
		
		public TBookingDateTimeListItem(int ID,Date BookingDateTime,int MaxBooking,int HasBooking,int ModifyBooking,boolean Flag)
		{
			SimpleDateFormat formatter; 
			formatter = new SimpleDateFormat ("HH:mm:ss");
			String StringDate =formatter.format(BookingDateTime);	
//			System.out.println("dateString:"+StringDate);
			
			this.ID=ID;			
			this.BookingDateTime=StringDate;
			this.MaxBooking=MaxBooking;
			this.HasBooking=HasBooking;
			this.ModifyBooking=ModifyBooking;
			this.Flag=Flag;
		}
	}

}
