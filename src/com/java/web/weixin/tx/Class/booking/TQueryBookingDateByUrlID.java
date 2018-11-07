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


public class TQueryBookingDateByUrlID {
	
	List<TQueryBookingDateListItem> Item =new ArrayList<TQueryBookingDateListItem>();
	public int ErrCode;
	public String ErrText;
	public TQueryBookingDateByUrlID(String UrlID)
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
			    	String sql=" select abdp_id,abd_id,abdp_GuestName,abdp_GuestTel,abdp_CheckIn,abdp_StatusType,abdp_money,"+
			    			" abdp_UrlCode,abdp_PayDate,abdp_CheckInDate,abd_BookingDateTime ,amp_id,amp_Name,amp_remark,ifnull(abdp_prepayID,'') as abdp_prepayID"+
			    			" from abdp_BookingDatetime_Pay,amb_member,abd_BookingDatetime,amp_Medical_Project "+
			    			" where abdp_id_amb=amb_id "+
			    			" and abd_id_amp=amp_id "+
			    			" and abdp_id_abd=abd_id "+
			    			" and abdp_UrlCode='"+UrlID+"'"+
			    			" order by abd_BookingDateTime desc";

			    	//System.out.println(sql);
			    	
					rs = stmt.executeQuery(sql);   
					while (rs.next())
					{						
						//int ID,Date BookingDateTime,String MemberName,String MemberTel,Float Money
						TQueryBookingDateListItem item=new TQueryBookingDateListItem(rs.getInt("abdp_id"),rs.getInt("abd_id"),rs.getTimestamp("abd_BookingDateTime"),
								rs.getString("abdp_GuestName"),rs.getString("abdp_GuestTel"),rs.getFloat("abdp_money"),rs.getBoolean("abdp_CheckIn"),
								rs.getString("abdp_UrlCode"),rs.getTimestamp("abdp_PayDate"),rs.getTimestamp("abdp_CheckInDate"),rs.getString("abdp_StatusType"),
								rs.getInt("amp_id"),rs.getString("amp_Name"),rs.getString("amp_remark"),rs.getString("abdp_prepayID"));
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
	
	public TQueryBookingDateListItem GetItem(int index)
	{
		return Item.get(index);
	}
	 
	public class TQueryBookingDateListItem{
		public String BookingDateTime;
		public String Week;
		public String MemberName;
		public String MemberTel;
		public Float Money;
		public int PayID;
		public int OrderID;
		public Boolean CheckIn;
		public String UrlCode;
		public String PayDate;
		public String CheckInDate;
		public String StatusType;
		public String MedicalProject;
		public int MedicalProjectID;
		public String MedicalProjectRemark;
		public String PrepayID;
		
		
		
		public TQueryBookingDateListItem(int PayID,int OrderID,Date BookingDateTime,String MemberName,String MemberTel,Float Money,Boolean CheckIn,String UrlCode,
					Date PayDate,Date CheckInDate,String StatusType,int MedicalProjectID,String MedicalProject,String MedicalProjectRemark,String PrepayID)
		{
			SimpleDateFormat formatter; 
			formatter = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
			String StringDate =formatter.format(BookingDateTime);	

			this.PayID=PayID;
			this.OrderID=OrderID;
			this.MemberName=MemberName;
			this.MemberTel=MemberTel;
			this.Money=Money;
			
			this.Week=GlobalVariable.getWeekOfDate(BookingDateTime);
			this.BookingDateTime=StringDate;
			this.CheckIn=CheckIn;
			this.UrlCode=UrlCode;

			if (PayDate!=null)
			{
				StringDate =formatter.format(PayDate);
			}
			else
			{
				StringDate="";
			}
			this.PayDate=StringDate;
			if (CheckInDate!=null)
			{
				StringDate =formatter.format(CheckInDate);
			}
			else
			{
				StringDate="";
			}
			this.CheckInDate=StringDate;
			this.StatusType=StatusType;
			this.MedicalProject=MedicalProject;
			this.MedicalProjectID=MedicalProjectID;
			this.MedicalProjectRemark=MedicalProjectRemark;
			this.PrepayID=PrepayID;
			
		}
	}

}
