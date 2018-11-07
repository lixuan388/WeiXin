package com.java.web.weixin.TimeTask;

import java.util.Date;
import java.util.TimerTask;

import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;

public class UpdateCheckInTimeTask extends TimerTask {
	public int RunTime;

	@Override
	public void run() {
		// TODO Auto-generated method stub
		int t=new Date().getHours();

		System.out.println("UpdateCheckInTimeTask");
		if ((RunTime==1) || ((t<2) && (RunTime>60*6)))
		{
			System.out.println("UpdateCheckInTimeTask");
			System.out.println("更新爽约次数");
			//记录30天内的爽约记录
			MySQLTable tableAll=new MySQLTable("select abdp_id_amb,count(0) as c\r\n" + 
					"from abdp_bookingdatetime_pay,abd_bookingdatetime,amb_member\r\n" + 
					"where abd_id=abdp_id_abd and  abdp_checkIn=3 and abdp_id_amb=amb_id and abdp_statustype='已付款'\r\n" + 
					"and abdp_status<>'D' and abd_id_amp=3 and abdp_money=0\r\n" + 
					"and datediff(abd_bookingdate,now())>=-30\r\n" + 
					"and abd_bookingdate>='2018-12-11' and abdp_status in ('I','E') \r\n"+
					"group by abdp_id_amb");

			MySQLUpdate tableUpdate=new MySQLUpdate();

			
			try
			{
				tableAll.Open();
				while (tableAll.next())
				{
					tableUpdate.Update("update amb_member set  amb_MissCount=amb_MissCount + "+tableAll.getString("c")+",_SyncFlag=0,_Date_Lst=now(),_User_Lst='更新爽约次数' where amb_id='"+tableAll.getString("abdp_id_amb")+"'");
					tableUpdate.Update("update abdp_bookingdatetime_pay set  abdp_status='S' ,_SyncFlag=0,_Date_Lst=now(),_User_Lst='更新爽约次数' where abdp_checkIn=3 and abdp_status in ('I','E') and  abdp_id_amb='"+tableAll.getString("abdp_id_amb")+"'");
				}

				tableUpdate.Update("update amb_member set  amb_Level=2,_SyncFlag=0,_Date_Lst=now(),_User_Lst='更新爽约次数' where amb_MissCount>=2");
				
				System.out.println("更新爽约标记完成");

				//检查所有低级用户，最近一次的爽约日期，是否已过30天
				tableAll.SQL("select amb_id from amb_member where amb_level=2 ");
				tableAll.Open();
				while (tableAll.next())
				{
					String amb_id=tableAll.getString("amb_id");
					MySQLTable ambTable=new MySQLTable("select ifnull(min(datediff(now(),abd_bookingdate)),100) as abd_bookingdate\r\n" + 
							"from abdp_bookingdatetime_pay,abd_bookingdatetime,amb_member\r\n" + 
							"where abd_id=abdp_id_abd and  abdp_checkIn=3 and abdp_id_amb=amb_id  and abdp_statustype='已付款'\r\n" + 
							"and abdp_status<>'D' and abd_id_amp=3 and abdp_money=0\r\n" +
							"and abd_bookingdate>='2018-12-11'\r\n"+
							"and abdp_id_amb='"+amb_id+"'");
					try
					{
						ambTable.Open();
						ambTable.next();
						int abd_bookingdate=ambTable.getInt("abd_bookingdate");
						if (abd_bookingdate>=30)
						{
							tableUpdate.Update("update amb_member set  amb_Level=1,amb_MissCount=0,_SyncFlag=0,_Date_Lst=now(),_User_Lst='更新爽约次数' where amb_id='"+amb_id+"'");
						}
						else
						{
							abd_bookingdate=30-abd_bookingdate;
							tableUpdate.Update("update amb_member set  amb_Level=2,amb_LevelValue="+abd_bookingdate+",_SyncFlag=0,_Date_Lst=now(),_User_Lst='更新爽约次数' where amb_id='"+amb_id+"'");
						}
					}
					finally
					{
						ambTable.Close();
					}
				}

				System.out.println("更新爽约期限更新完成");
				
				RunTime=2;
			}
			finally
			{
				tableAll.Close();
			}
			
			
		}
		else
		{
			System.out.println("t="+t+";RunTime="+RunTime);
		}
		RunTime++;
	}

}
