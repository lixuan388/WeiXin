package com.java.web.weixin.tx.Class.message;

import java.text.SimpleDateFormat;
import java.util.Date;

/*
 * 
 * {{first.DATA}}
*项目名称：{{keyword1.DATA}}
*办理时间：{{keyword2.DATA}}
*项目类型：{{keyword3.DATA}}
*项目说明：{{keyword4.DATA}}
*{{remark.DATA}}
 * 
 */
public class TMessageMemberCard extends TMessageTemplateSend {
	public TMessageMemberCard(String touser,String url, String keyword1,
			 String keyword3,String keyword4,String remark) {
		
		super(touser, "Rm79mGOQGIoEhKvss0LKhPcUiaqD9Ovn-AI2Y0caOfs", url, "", "", keyword1, new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss").format(new Date())
				, keyword3, keyword4, "", remark);		
		// TODO Auto-generated constructor stub
	}

}
