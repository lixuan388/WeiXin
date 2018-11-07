package com.java.web.weixin.TimeTask;

import java.util.Date;
import java.util.TimerTask;

import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;

public class CancelBookingPayTimeTask extends TimerTask {

	@Override
	public void run() {
		// TODO Auto-generated method stub
		int t=new Date().getHours();

		System.out.println("CancelBookingPayTimeTask");

			System.out.println("自动取消5分钟内未付款的订单");

			MySQLTable tableList=new MySQLTable();
			MySQLUpdate tableUpdate=new MySQLUpdate();
			MySQLTable tableAll=new MySQLTable("select abdp_id,abdp_id_abd,abdp_UrlCode,abdp_StatusType,abdp_remark,_Status,_Date_Lst,_User_Lst,_SyncFlag "+
											" from abdp_bookingdatetime_pay where abdp_StatusType='待付款' and _Status<>'D'"+
												" and unix_timestamp(now())-unix_timestamp(_date_ins)>5*60");
			try
			{
			
				tableAll.Open();
				while (tableAll.next())
				{
					int abdp_id_abd=tableAll.getInt("abdp_id_abd");

					System.out.println("取消订单:"+tableAll.getString("abdp_UrlCode"));
					tableAll.updateString("abdp_StatusType", "超时取消");
					tableAll.updateString("abdp_remark", "5分钟未支付，自动取消");
					tableAll.updateString("_Status", "D");
					tableAll.updateDateTime("_Date_Lst",new Date());
					tableAll.updateString("_User_Lst", "超时取消");
					tableAll.updateBoolean("_SyncFlag", false);
					tableAll.PostRow();
					
	
					
					String sqlStr="select count(0) as c  from abdp_bookingdatetime_pay where abdp_id_abd="+abdp_id_abd+" and _Status<>'D'";
					try
					{
						tableList.SQL(sqlStr);
						tableList.Open();
						if (tableList.next())
						{
							int c=tableList.getInt("c");
							tableUpdate.Update("update abd_bookingdatetime set abd_HasBooking="+c+",_SyncFlag=0 where abd_id="+abdp_id_abd);
						}
					}
					finally
					{
						tableList.Close();
						tableUpdate.Close();
					}			
				}
			}
			finally
			{
				tableAll.Close();
			}
			System.out.println("查检完成");
	}

}
