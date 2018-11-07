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
import com.java.sql.table.MySQLTable;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.tx.Class.message.TMessageBookingSuccess;


public class TBookingSuccessSendMessage {
	
	public TBookingSuccessSendMessage(String UrlCode)
	{
		MySQLTable table=new MySQLTable("select abd_bookingdatetime,amp_name,amb_wxid,amb_name,amb_tel from abdp_bookingdatetime_pay,amb_member,abd_bookingdatetime,amp_medical_project where amb_id=abdp_id_amb and abdp_id_abd=abd_id and abd_id_amp=amp_id and  abdp_urlcode='"+UrlCode+"'");
		table.Open();
		if (table.next())
		{
    		SimpleDateFormat formatter2 = new SimpleDateFormat ("yyyy-MM-dd HH:mm");
    		String touser=table.getString("amb_wxid");
    		String url=GlobalVariable.WebUrl+"/tx/QueryMemberBookingDate.jsp";
    		String first="恭喜您已经预约成功";
    		String keyword1=table.getString("amb_name");
 			String keyword2=table.getString("amb_tel");
 			String keyword3=formatter2.format(table.getDateTime("abd_bookingdatetime"));
 			String keyword4=table.getString("amp_name");
 			String remark="如有任何疑问，欢迎营业时间添加微信号：gz81073559，或致电：020-81073559";
 			
 			
			TMessageBookingSuccess msg=new TMessageBookingSuccess(touser,url,first,keyword1,keyword2,keyword3,keyword4,remark);
//			TMessageBookingSuccess msg=new TMessageBookingSuccess(table.getString("amb_wxid"),"http://www.jackiehor.org/WeiXin/tx/QueryMemberBookingDate.jsp","今日您有预约项目，请准时到店报到", table.getString("amp_name"),formatter2.format(table.getDateTime("abd_bookingdatetime")),"如有任何疑问，欢迎您随时咨询");
			msg.Send();
			System.out.println("预约成功短信"); 
		}
	}
}
