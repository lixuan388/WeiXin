package com.java.web.weixin.jssdk;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.Date;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspWriter;

import org.apache.commons.codec.digest.DigestUtils;

import com.java.web.weixin.base.GlobalVariable;

public class WXChooseWXPay {
	public String timestamp; // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
	public String nonceStr;// 支付签名随机串，不长于 32 位
	public String Package; // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=***）
	public String signType; // 签名方式，默认为'SHA1'，使用新版支付需传入'MD5'
	public String paySign; // 支付签名


    public WXChooseWXPay(String prepay_id)
    {
		System.out.println("WXChooseWXPay()");
    	timestamp=""+new Date().getTime();		
    	UUID uuid = UUID.randomUUID();
		nonceStr= uuid.toString().replaceAll("-","").substring(1, 32);
		Package="prepay_id="+prepay_id;
		signType="MD5";
		String KeyString="appId="+GlobalVariable.AppID+"&nonceStr="+nonceStr+"&package="+Package+"&signType="+signType+"&timeStamp="+timestamp+"&key="+GlobalVariable.APIKey;

		paySign=DigestUtils.md5Hex(KeyString.getBytes()).toUpperCase();
    	
    }
    
    public String urlhttp(String WXAppID,String prepay_id) throws IOException
    {
      System.out.println("WXRequestPayment()");
      timestamp=""+new Date().getTime();
      UUID uuid = UUID.randomUUID();
      nonceStr= uuid.toString().replaceAll("-","").substring(1, 32);
      Package="prepay_id="+prepay_id;
      signType="MD5";
      String KeyString="appId="+WXAppID+"&nonceStr="+nonceStr+"&package="+Package+"&signType="+signType+"&timeStamp="+timestamp+"&key="+GlobalVariable.APIKey;
    
      paySign=DigestUtils.md5Hex(KeyString.getBytes()).toUpperCase();

      return "timestamp="+timestamp+"&nonceStr="+nonceStr+"&package="+URLEncoder.encode(Package)+"&signType="+signType+"&paySign="+paySign;
    }

    
    

}
