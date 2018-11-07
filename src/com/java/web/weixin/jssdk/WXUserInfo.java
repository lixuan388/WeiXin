package com.java.web.weixin.jssdk;

import org.json.JSONException;
import org.json.JSONObject;

import com.java.web.weixin.base.GlobalVariable;

public class WXUserInfo {
	
//	public String errcode;
//	public String errmsg;
//	public String subscribe;//	�û��Ƿ��ĸù��ںű�ʶ��ֵΪ0ʱ�������û�û�й�ע�ù��ںţ���ȡ����������Ϣ��
//	public String openid;//	�û��ı�ʶ���Ե�ǰ���ں�Ψһ
//	public String nickname;//	�û����ǳ�
//	public String sex;//	�û����Ա�ֵΪ1ʱ�����ԣ�ֵΪ2ʱ��Ů�ԣ�ֵΪ0ʱ��δ֪
//	public String city;//	�û����ڳ���
//	public String country;//	�û����ڹ��
//	public String province;//	�û�����ʡ��
//	public String language;//	�û������ԣ���������Ϊzh_CN
//	public String headimgurl;//	�û�ͷ�����һ����ֵ�������ͷ���С����0��46��64��96��132��ֵ��ѡ��0���640*640����ͷ�񣩣��û�û��ͷ��ʱ����Ϊ�ա����û���ͷ��ԭ��ͷ��URL��ʧЧ��
//	public String subscribe_time;//	�û���עʱ�䣬Ϊʱ���������û����ι�ע����ȡ����עʱ��
//	public String unionid;//	ֻ�����û������ںŰ󶨵�΢�ſ���ƽ̨�ʺź󣬲Ż���ָ��ֶΡ�
//	public String remark;//	���ں���Ӫ�߶Է�˿�ı�ע�����ں���Ӫ�߿���΢�Ź���ƽ̨�û��������Է�˿��ӱ�ע
//	public String groupid;//	�û����ڵķ���ID�����ݾɵ��û�����ӿڣ�
//	public String tagid_list;//�û������ϵı�ǩID�б�
	
	JSONObject UserJson;
	
	public WXUserInfo(String OpenID)
	{

			System.out.println("WXUserInfo()");
			String url=" https://api.weixin.qq.com/cgi-bin/user/info?access_token="+GlobalVariable.GetAccessToken()+"&openid="+OpenID+"&lang=zh_CN ";
//			String url="https://api.weixin.qq.com/cgi-bin/user/info?access_token=OsCK0WXnMIlseO3X-JhXZvzWtwUPYvTKkv3XqppJh26CZWe2BzSYnb_AC0TLWobspIhrGo7n6eMDXwWE_d5uEiR1AK0tHd0QM-atx870qijXxKjaCKMGATj-U4zl0DsuSWWfABAKOO&openid=oziEnwd_hgNyll1GRCvnq36-8Fcs&lang=zh_CN ";
//			String url="https://api.weixin.qq.com/cgi-bin/user/info?access_token=OsCK0WXnMIlseO3X-JhXZvzWtwUPYvTKkv3XqppJh26CZWe2BzSYnb_AC0TLWobspIhrGo7n6eMDXwWE_d5uEiR1AK0tHd0QM-atx870qijXxKjaCKMGATj-U4zl0DsuSWWfABAKOO&openid=oziEnwcnWxymyfcaVtkXOoo49KjM&lang=zh_CN ";
			
			
//			System.out.println("url:"+url);
			String result=GlobalVariable.sendHttpGet(url);

			System.out.println("result:"+result);
			try {
				UserJson=new JSONObject(result);

				
//				errcode=json.getString("errcode")==null?"1":json.getString("errcode");
//				errmsg=json.getString("errmsg")==null?"":json.getString("errmsg");		
//				subscribe=json.getString("subscribe")==null?"":json.getString("subscribe");
//				openid=json.getString("openid")==null?"":json.getString("openid");
//				nickname=json.getString("nickname")==null?"":json.getString("nickname");
//				sex=json.getString("sex")==null?"":json.getString("sex");
//				city=json.getString("city")==null?"":json.getString("city");
//				country=json.getString("country")==null?"":json.getString("country");
//				province=json.getString("province")==null?"":json.getString("province");
//				language=json.getString("language")==null?"":json.getString("language");
//				headimgurl=json.getString("headimgurl")==null?"":json.getString("headimgurl");
//				subscribe_time=json.getString("subscribe_time")==null?"":json.getString("subscribe_time");
//				unionid=json.getString("unionid")==null?"":json.getString("unionid");
//				remark=json.getString("remark")==null?"":json.getString("remark");
//				groupid=json.getString("groupid")==null?"":json.getString("groupid");
//				tagid_list=json.getString("tagid_list")==null?"":json.getString("tagid_list");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
	
	public String GetValue(String key)
	{
		if (UserJson.isNull(key))
		{
			return "";
		}
		else
		{
			try {
				return UserJson.getString(key);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return "";
	}

}
