package com.java.web.weixin.TimeTask;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimerTask;

import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.tx.Class.message.TMessageBookingSuccess;

public class SendBookingDateMsgTimeTask extends TimerTask {
	int RunTime=2;

	@Override
	public void run() {
		// TODO Auto-generated method stub
		int t=new Date().getHours();

		System.out.println("SendBookingDateMsgTimeTask");
		if ((RunTime==1) || ((t==7) && (RunTime>60*2)))
		{
			System.out.println("SendBookingDateMsgTimeTask");
			System.out.println("预约提醒");
			MySQLTable table=new MySQLTable("select abd_bookingdatetime,amp_name,amb_wxid,amb_name,amb_tel from abdp_bookingdatetime_pay,amb_member,abd_bookingdatetime,amp_medical_project"+			
					" where amb_id=abdp_id_amb and abdp_id_abd=abd_id and abd_id_amp=amp_id "+
					" and abdp_bookingdatetime_pay._status<>'D' "+
					" and abdp_StatusType='已付款' "+
					" and abd_bookingdate=date(now()) ");
			try
			{
				table.Open();
				int count=0;
				while (table.next())
				{
					count=count+1;
		    		SimpleDateFormat formatter2 = new SimpleDateFormat ("yyyy-MM-dd HH:mm");
					TMessageBookingSuccess msg=new TMessageBookingSuccess(table.getString("amb_wxid"),
								"http://www.jackiehor.cn/WeiXin/tx/QueryMemberBookingDate.jsp",
								"今日您有预约项目，请准时到店报到",
								table.getString("amb_name"),
								table.getString("amb_tel"),
								formatter2.format(table.getDateTime("abd_bookingdatetime")),
								table.getString("amp_name"),
								"如有任何疑问，欢迎营业时间添加微信号：gz81073559，或致电：020-81073559");
					msg.Send();
//					System.out.println("预约成功短信");
				}

	    		SimpleDateFormat formatter2 = new SimpleDateFormat ("yyyy-MM-dd HH:mm");
				TMessageBookingSuccess msg=new TMessageBookingSuccess("oziEnwXc5eWwN9HOIn8AxV7eFDfE",
							"http://www.jackiehor.cn/WeiXin/tx/index.jsp",
							"发送预约记录："+count, 
							"预约记录",
							"",
							formatter2.format(new Date()),
							"",
							"如有任何疑问");
				msg.Send();
				
				System.out.println("预约提醒完成");
				RunTime=2;
			}
			finally
			{
				table.Close();
			}
		}
		else
		{
//			System.out.println("t="+t+";RunTime="+RunTime);
		}
		RunTime++;
	}

}
