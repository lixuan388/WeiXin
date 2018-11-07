package com.java.web.weixin.tx.notice;

import javax.servlet.http.HttpServletRequest;
import com.java.sql.table.MySQLTable;
import com.java.web.weixin.base.GlobalVariable;



public class NoticeUserInfo {

	
	public NoticeUserInfo(HttpServletRequest request)
	{
		
		for (int i =1;i<=3;i++)
		{
				request.getSession().setAttribute("Notice"+i,"");
		}
		
		
		MySQLTable table=new MySQLTable("select anl_id,anl_type from anl_noticelist where datediff(anl_time,now())>=0 and anl_flag=1 order by anl_time desc" );
		try
		{
			table.Open();
			while (table.next())
			{
				request.getSession().setAttribute("Notice"+table.getString("anl_type"),table.getString("anl_id"));
			}
		}
		finally
		{
			table.Close();
		}
		String UserID=GlobalVariable.GetMemberID(request);
		
		MySQLTable table2=new MySQLTable("select anr_id_anl,anl_type from anr_noticeread,anl_noticelist where anl_id=anr_id_anl and  anr_id_amb='"+UserID+"'" );
		try
		{
			table2.Open();
			while (table2.next())
			{
				String anl_id=table2.getString("anr_id_anl");
				String anl_id2=request.getSession().getAttribute("Notice"+table2.getString("anl_type"))==null?"":(String)request.getSession().getAttribute("Notice"+table2.getString("anl_type"));
				if (anl_id.equals(anl_id2))
				{
					request.getSession().setAttribute("Notice"+table2.getString("anl_type"),"");
				}
			}
		}
		finally
		{
			table2.Close();
		}
	}
}
