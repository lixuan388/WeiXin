package com.java.web.weixin.TimeTask;

import java.util.Date;
import java.util.TimerTask;

import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.tx.card.MemberCardFunction;

public class ClearTimeOutTimeTask extends TimerTask {
	public int RunTime;

	@Override
	public void run() {
		// TODO Auto-generated method stub
		int t=new Date().getHours();

		System.out.println("UpdateCheckInTimeTask");
		if ((RunTime==1) || ((t<2) && (RunTime>60*6)))
		{
			System.out.println("UpdateCheckInTimeTask");
			System.out.println("过期2年，次数清0");
			//记录30天内的爽约记录
			MySQLTable tableAll=new MySQLTable("select amc_count,amc_id_amb,amc_id from amc_member_card where datediff(amc_enddate,now())<-365*1 and amc_Count>0");

			MySQLUpdate tableUpdate=new MySQLUpdate();

			
			try
			{
				tableAll.Open();
				while (tableAll.next())
				{
					String UserID="过期清0";
					String MemberID=tableAll.getString("amc_id_amb");
					String AmcID=tableAll.getString("amc_id");
					String OpType="过期清0";
					String Count=" - "+tableAll.getString("amc_count");
					String Money="0";
					String EndDate="";
					MemberCardFunction.UpdateCount(UserID, MemberID, AmcID, OpType, Count, Money, EndDate);
				}
				System.out.println("过期2年，次数清0更新完成");
				
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
