package com.java.web.weixin.TimeTask;

import java.util.Date;
import java.util.TimerTask;

import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;

public class UpdateBookingPayCountTimeTask extends TimerTask {

	@Override
	public void run() {
		// TODO Auto-generated method stub
		int t=new Date().getHours();

		System.out.println("UpdateBookingPayCountTimeTask");

		System.out.println("整理预定人数");

		MySQLTable tableList=new MySQLTable();
		MySQLUpdate tableUpdate=new MySQLUpdate();
		
		String sqlStr=" select abdp_id_abd,sum(c) as c  from "+ 
						" ( "+
						" select abdp_id_abd,count(0) as c  from abdp_bookingdatetime_pay,abd_bookingdatetime "+ 
						" where abd_bookingdatetime._Status<>'D' and abdp_bookingdatetime_pay._Status<>'D' "+
						" and abd_bookingdatetime>now() "+
						" and abd_id=abdp_id_abd "+
						" group  by abdp_id_abd "+
						" union all  "+
						" select abd_id,0 from abd_bookingdatetime where _Status<>'D' and abd_bookingdatetime>now() "+
						" ) a group by abdp_id_abd " ;


		try
		{
			tableList.SQL(sqlStr);
			tableList.Open();
			while (tableList.next())
			{
				int c=tableList.getInt("c");
				tableUpdate.Update("update abd_bookingdatetime set abd_HasBooking="+c+",_Date_Lst=now(),_User_Lst='整理人数',_SyncFlag=0 where abd_HasBooking<>"+c+" and  abd_id="+tableList.getInt("abdp_id_abd"));
			}
		}
		finally
		{
			tableList.Close();
			tableUpdate.Close();
		}	
		System.out.println("查检完成");
	}

}
