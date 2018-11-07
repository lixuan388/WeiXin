package com.java.web.weixin.tx.Class.message;



import org.json.JSONException;
import org.json.JSONObject;
import com.java.web.weixin.base.GlobalVariable;


public class TMessageTemplateSend {
	
	public static String SendUrl="https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=";
	
	public String touser;
	public String template_id;
	public String url;
	public String miniprogram;

			
	public String first;
	public String keyword1;
	public String keyword2;
	public String keyword3;
	public String keyword4;
	public String keyword5;
	public String remark;
	
	
	public TMessageTemplateSend(String touser,String template_id,String url,String miniprogram,String first,String keyword1,
			String keyword2,String keyword3,String keyword4,String keyword5,String remark)
	{
		this.touser=touser;
		this.url=url;
		this.template_id=template_id;
		this.miniprogram=miniprogram;
		this.first=first;
		this.keyword1=keyword1;
		this.keyword2=keyword2;
		this.keyword3=keyword3;
		this.keyword4=keyword4;
		this.keyword5=keyword5;
		this.remark=remark;		
	}
	public org.json.JSONObject  Send(){		
		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();
		

        ResultXml.put("touser",touser);
        ResultXml.put("template_id",template_id);
        ResultXml.put("url",url);
		
        net.sf.json.JSONObject miniprogramJson = new net.sf.json.JSONObject();		
        ResultXml.put("miniprogram",miniprogramJson);

        

        net.sf.json.JSONObject firstJson = new net.sf.json.JSONObject();
        firstJson.put("value", first);
        firstJson.put("color", "#173177");
        
        net.sf.json.JSONObject keyword1Json = new net.sf.json.JSONObject();
        keyword1Json.put("value", keyword1);
        keyword1Json.put("color", "#173177");
        
        net.sf.json.JSONObject keyword2Json = new net.sf.json.JSONObject();		
        keyword2Json.put("value", keyword2);
        keyword2Json.put("color", "#173177");
        
        net.sf.json.JSONObject keyword3Json = new net.sf.json.JSONObject();		
        keyword3Json.put("value", keyword3);
        keyword3Json.put("color", "#173177");
        
        net.sf.json.JSONObject keyword4Json = new net.sf.json.JSONObject();		
        keyword4Json.put("value", keyword4);
        keyword4Json.put("color", "#173177");
        
        net.sf.json.JSONObject keyword5Json = new net.sf.json.JSONObject();		
        keyword5Json.put("value", keyword5);
        keyword5Json.put("color", "#173177");        
        
        net.sf.json.JSONObject remarkJson = new net.sf.json.JSONObject();		
        remarkJson.put("value", remark);
        remarkJson.put("color", "#173177");


        net.sf.json.JSONObject dataJson = new net.sf.json.JSONObject();	
        dataJson.put("first", firstJson);
        dataJson.put("keyword1", keyword1Json);
        dataJson.put("keyword2", keyword2Json);
        dataJson.put("keyword3", keyword3Json);
        dataJson.put("keyword4", keyword4Json);
        dataJson.put("keyword5", keyword5Json);
        dataJson.put("remark", remarkJson);
        		
        ResultXml.put("data",dataJson);
        
        org.json.JSONObject UserJson=null;

        String sendUrl=SendUrl+GlobalVariable.GetAccessToken();
        System.out.println("AccessToken:"+GlobalVariable.GetAccessToken());
        System.out.println(ResultXml.toString());
		String result=GlobalVariable.sendHttpPost(sendUrl,ResultXml.toString());
		System.out.println("result:"+result);
		try {
			UserJson=new org.json.JSONObject(result);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return UserJson;
	}
	
	
	

	
	
}
