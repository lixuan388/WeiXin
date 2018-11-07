package com.java.web.weixin.jssdk;

import org.json.JSONException;
import org.json.JSONObject;

import com.java.web.weixin.base.GlobalVariable;

public class WXSnsapiBaseCode {
	
//	access_token	��ҳ��Ȩ�ӿڵ���ƾ֤,ע�⣺��access_token���֧�ֵ�access_token��ͬ
//	expires_in	access_token�ӿڵ���ƾ֤��ʱʱ�䣬��λ���룩
//	refresh_token	�û�ˢ��access_token
//	openid	�û�Ψһ��ʶ����ע�⣬��δ��ע���ں�ʱ���û����ʹ��ںŵ���ҳ��Ҳ�����һ���û��͹��ں�Ψһ��OpenID
//	scope	�û���Ȩ��������ʹ�ö��ţ�,���ָ�
	
	//{"errcode":40029,"errmsg":"invalid code"} 
	
	JSONObject SnsapiBaseCodeJson;
	
	public WXSnsapiBaseCode(String Code)
	{
			String url=" https://api.weixin.qq.com/sns/oauth2/access_token?appid="+GlobalVariable.AppID+"&secret="+GlobalVariable.AppSecret+"&code="+Code+"&grant_type=authorization_code";			
			String result=GlobalVariable.sendHttpGet(url);

			System.out.println("WXSnsapiBaseCode");
			System.out.println("url:"+url);
			System.out.println("result:"+result);

			try {
				SnsapiBaseCodeJson=new JSONObject(result);				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
	
	public String GetValue(String key)
	{
		if (SnsapiBaseCodeJson.isNull(key))
		{
			return "";
		}
		else
		{
			try {
				return SnsapiBaseCodeJson.getString(key);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return "";
	}

}
