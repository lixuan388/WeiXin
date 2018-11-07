package com.java.web.weixin.TimeTask;

import java.util.Date;
import java.util.TimerTask;

import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;

public class CreateBookingDateTimeTimeTask extends TimerTask {
	int RunTime;

	@Override
	public void run() {
		// TODO Auto-generated method stub
		int t=new Date().getHours();

		System.out.println("CreateBookingDateTimeTimeTask");
		if ((RunTime==1) || ((t<2) && (RunTime>60*6)))
		{
			System.out.println("CreateBookingDateTimeTimeTask");
			System.out.println("创建7日内的排班表");
			MySQLTable tableList=new MySQLTable();
			MySQLTable tableAll=new MySQLTable("select atn_number,amps_date,atn_time,atn_id_amp,amps_flag "+
											" from atn_time_number,amps_medical_project_schedule,amp_medical_project "+ 
											" where datediff(amps_date,now())>=0 and datediff(amps_date,now())<=amp_MaxDay "+
											" and amp_id=atn_id_amp "+
											" and atn_time_number._Status<>'D' "+
											" and date_format(amps_date,'%w')=atn_week and atn_id_amp=amps_id_amp"+
											" and amps_medical_project_schedule._Status<>'D'");
			try
			{
				tableAll.Open();
				while (tableAll.next())
				{
					String sqlStr="select * from abd_bookingdatetime where abd_bookingdatetime='"+tableAll.getString("amps_date")+" "+tableAll.getString("atn_time")+"' and abd_id_amp="+
							tableAll.getString("atn_id_amp")+" and _Status<>'D'";

//					System.out.println(sqlStr);
					tableList.SQL(sqlStr);
					tableList.Open();
					if (!tableList.next())
					{
						tableList.insertRow();
						tableList.updateString("_Status", "I");
						tableList.updateString("_User_Ins", "定时");
						tableList.updateDateTime("_Date_Ins",new Date());
						tableList.updateString("abd_status", "I");
						tableList.updateDateTime("abd_Date_Ins",new Date());

						tableList.updateInt("abd_maxbooking", tableAll.getInt("atn_number"));
						tableList.updateInt("abd_number", tableAll.getInt("atn_number"));
						tableList.updateInt("abd_hasbooking", 0);
						tableList.updateInt("abd_ModifyBooking", 0);
						tableList.updateInt("abd_id_amp", tableAll.getInt("atn_id_amp"));
						tableList.updateString("abd_BookingDate", tableAll.getString("amps_date"));
						tableList.updateString("abd_BookingDateTime", tableAll.getString("amps_date")+" "+tableAll.getString("atn_time"));

						tableList.PostRow();
					}
					else
					{
						if (tableAll.getInt("atn_number")!=tableList.getInt("abd_number"))
						{	
							tableList.updateString("_Status", "E");
							tableList.updateString("_User_Lst", "定时");
							tableList.updateDateTime("_Date_Lst",new Date());
							tableList.updateInt("abd_maxbooking", tableAll.getInt("atn_number")+tableList.getInt("abd_ModifyBooking"));
							tableList.updateInt("abd_number", tableAll.getInt("atn_number"));
							tableList.PostRow();
						}
					}
					tableList.Close();
				}
				System.out.println("排班表创建完成");
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
