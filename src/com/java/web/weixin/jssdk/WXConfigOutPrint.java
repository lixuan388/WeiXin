package com.java.web.weixin.jssdk;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.digest.DigestUtils;

import com.java.web.weixin.base.GlobalVariable;

public class WXConfigOutPrint {
    public String appId;
    public String timestamp;
    public String nonceStr;
    public String signature;
    public String sha1;
    
    public String ReturnString=""; 

    public WXConfigOutPrint(HttpServletRequest request,String jsApiList)
    {
    	

		System.out.println("WXConfigOutPrint()");

	    String WebUrl = request.getScheme()+"://" + request.getServerName(); //服务器地址
//	    if (request.getServerPort()!=80)
//	    {
//	    	WebUrl=WebUrl + ":" + request.getServerPort();           //端口号
//	    }

	    
	    WebUrl =WebUrl+request.getRequestURI();

		System.out.println("getQueryString:"+request.getQueryString());
	    if (request.getQueryString()!=null)
	    {
	    	WebUrl=WebUrl+"?"+request.getQueryString();
	    }

		System.out.println("WebUrl:"+WebUrl);
		
	    
    	appId=GlobalVariable.AppID;
    	timestamp=""+new Date().getTime();

		nonceStr= GlobalVariable.GUIDString();
		
		sha1="jsapi_ticket="+GlobalVariable.GetJsapi_ticket()+"&noncestr="+nonceStr+"&timestamp="+timestamp+"&url="+WebUrl;

		System.out.println("sha1:"+sha1);
		signature=DigestUtils.shaHex(sha1);
		
		
		ReturnString="wx.config({";
		
		ReturnString=ReturnString+"		    debug: false,"; // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
		ReturnString=ReturnString+"appId:'"+appId+"',"; // 必填，公众号的唯一标识
		ReturnString=ReturnString+"    timestamp:"+timestamp+" ,"; // 必填，生成签名的时间戳
		ReturnString=ReturnString+"    nonceStr: '"+nonceStr+"',"; // 必填，生成签名的随机串
		ReturnString=ReturnString+"    signature: '"+signature+"',";// 必填，签名，见附录1
		ReturnString=ReturnString+"jsApiList: ["+jsApiList+"]"; // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
		ReturnString=ReturnString+"});";
		
    	
    }

}
