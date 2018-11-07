package com.java.web.weixin.tx.Class.booking;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.security.KeyStore;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.net.ssl.SSLContext;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLContexts;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import net.sf.json.JSONObject;
import org.xml.sax.InputSource;

import com.java.sql.table.MySQLTable;
import com.java.sql.table.MySQLUpdate;
import com.java.web.weixin.base.GlobalVariable;

public class TCancelBooking {

	public int abdp_id=-1;
	public int abdp_id_abd=-1;
	public String abdp_statustype="";
	public Float abdp_money=0f;
	public String abdp_UrlCode="";
	public Date abd_BookingDateTime=null;
	public int abdp_CheckIn;
	
	static public int TimeOoutValue=5;
	
	public boolean OpenTable(String Url)
	{

		MySQLTable table=new MySQLTable("select abdp_id,abdp_id_abd,abdp_statustype,abdp_money,abdp_UrlCode,abdp_CheckIn , abd_BookingDateTime\r\n" + 
				"				from abdp_bookingdatetime_pay ,abd_bookingdatetime\r\n" + 
				"				where abdp_id_abd=abd_id and abdp_urlcode='"+Url+"'");
		try
		{
			table.Open();
			if (!table.next())
			{
				return false;
			}
			else
			{
				abdp_id=table.getInt("abdp_id");
				abdp_id_abd=table.getInt("abdp_id_abd");
				abdp_statustype=table.getString("abdp_statustype");
				abdp_money=(float) table.getDouble("abdp_money");
				abdp_UrlCode=table.getString("abdp_UrlCode");
				abd_BookingDateTime=table.getDateTime("abd_BookingDateTime");
				abdp_CheckIn=table.getInt("abdp_CheckIn");
				return true;
			}
		}
		finally
		{
			table.Close();
		}

	}

	public boolean CheckTimeOut(Date BookingDateTime)
	{
		Long BookingDateTime2=BookingDateTime.getTime();
		Long now=new Date().getTime();
		Long sub=(BookingDateTime2-now) /(1000*60*60);
		return sub>=TimeOoutValue;
	}

	public boolean CheckTimeOut()
	{
		return CheckTimeOut(this.abd_BookingDateTime);
	}

	public Long TimeOut(Date BookingDateTime)
	{
		Long BookingDateTime2=BookingDateTime.getTime();
		Long now=new Date().getTime();
		Long sub=(BookingDateTime2-now) /(1000*60*60) -TimeOoutValue;
		return sub;
	}
	
	public Long TimeOut()
	{
		return TimeOut(this.abd_BookingDateTime);
	}
	
	public boolean CancelBooking()
	{
		MySQLTable table=new MySQLTable("select * from abdp_bookingdatetime_pay where abdp_id="+abdp_id+"");
		try
		{
			table.Open();
			if (!table.next())
			{
				return false;
			}
			else
			{
				table.updateString("abdp_statustype", "客人取消");
				table.updateString("_status", "D");
				table.updateInt("_syncflag",0);
				table.PostRow();
				UpdateCount();
				return true;
			}
		}
		finally
		{
			table.Close();
		}
	}

	public void UpdateCount()
	{
		UpdateCount(this.abdp_id_abd);
	}
	public void UpdateCount(int abdID)
	{
		MySQLTable tableList=new MySQLTable();
		MySQLUpdate tableUpdate=new MySQLUpdate();
		
		String sqlStr="select count(0) as c  from abdp_bookingdatetime_pay\r\n" + 
				"where abdp_bookingdatetime_pay._Status<>'D'\r\n" + 
				"and abdp_id_abd ="+abdID ;


		try
		{
			tableList.SQL(sqlStr);
			tableList.Open();
			while (tableList.next())
			{
				int c=tableList.getInt("c");
				tableUpdate.Update("update abd_bookingdatetime set abd_HasBooking="+c+",_Date_Lst=now(),_User_Lst='整理人数',_SyncFlag=0 where abd_HasBooking<>"+c+" and  abd_id="+abdID);
			}
		}
		finally
		{
			tableList.Close();
			tableUpdate.Close();
		}	
		System.out.println("UpdateCount:"+abdID);
	}
	public boolean PayRefund()
	{
		JSONObject resultXml=DoPayRefund();
		System.out.println("PayRefund");

		System.out.println(resultXml.toString());
		if (resultXml.getString("return_code").equals("SUCCESS"))
		{
			if (resultXml.getString("result_code").equals("SUCCESS"))
			{
				MySQLTable table=new MySQLTable("select * from abdp_bookingdatetime_pay where abdp_id="+abdp_id+"");
				try
				{
					table.Open();
					if (!table.next())
					{
						return false;
					}
					else
					{
						table.updateString("abdp_statustype", "已退款");
						table.updateString("_status", "D");
						table.updateInt("_syncflag",0);
						table.PostRow();
						return true;
					}
				}
				finally
				{
					table.Close();
				}
			}
			else
			{
				System.out.println("err_code:"+resultXml.getString("err_code"));
				System.out.println("err_code_des:"+resultXml.getString("err_code_des"));
				return false;
			}
		}
		else
		{
			System.out.println("PayRefund");
			System.out.println(resultXml.getString("return_msg"));
			return false;
		}


	}
	
	public JSONObject DoPayRefund()
	{

//	公众账号ID 	appid 	是 	String(32) 	wx8888888888888888 	微信分配的公众账号ID（企业号corpid即为此appId）
//	商户号 	mch_id 	是 	String(32) 	1900000109 	微信支付分配的商户号
//	随机字符串 	nonce_str 	是 	String(32) 	5K8264ILTKCH16CQ2502SI8ZNMTM67VS 	随机字符串，不长于32位。推荐随机数生成算法
//	签名类型 	sign_type 	否 	String(32) 	HMAC-SHA256 	签名类型，目前支持HMAC-SHA256和MD5，默认为MD5
//	微信订单号 	transaction_id 	二选一 	String(32) 	1217752501201407033233368018 	微信生成的订单号，在支付通知中有返回
//	商户订单号 	out_trade_no 	String(32) 	1217752501201407033233368018 	商户系统内部订单号，要求32个字符内，只能是数字、大小写字母_-|*@ ，且在同一个商户号下唯一。
//	商户退款单号 	out_refund_no 	是 	String(64) 	1217752501201407033233368018 	商户系统内部的退款单号，商户系统内部唯一，只能是数字、大小写字母_-|*@ ，同一退款单号多次请求只退一笔。
//	订单金额 	total_fee 	是 	Int 	100 	订单总金额，单位为分，只能为整数，详见支付金额
//	退款金额 	refund_fee 	是 	Int 	100 	退款总金额，订单总金额，单位为分，只能为整数，详见支付金额
//	退款货币种类 	refund_fee_type 	否 	String(8) 	CNY 	退款货币类型，需与支付一致，或者不填。符合ISO 4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
//	退款原因 	refund_desc 	否 	String(80) 	商品已售完 	若商户传入，会在下发给用户的退款消息中体现退款原因
//	退款资金来源 	refund_account 	否 	String(30) 	REFUND_SOURCE_RECHARGE_FUNDS 	仅针对老资金流商户使用
//	REFUND_SOURCE_UNSETTLED_FUNDS---未结算资金退款（默认使用未结算资金退款）
//	REFUND_SOURCE_RECHARGE_FUNDS---可用余额退款
		
//	退款结果通知url 	notify_url 	否 	String(256) 	https://weixin.qq.com/notify/ 异步接收微信支付退款结果通知的回调地址，通知URL必须为外网可访问的url，不允许带参数 	如果参数中传了notify_url，则商户平台上配置的回调地址将不会生效。

		JSONObject payRefund=new JSONObject();
		payRefund.put("appid", GlobalVariable.AppID);
		payRefund.put("mch_id", GlobalVariable.mch_id);
		payRefund.put("nonce_str", GlobalVariable.GUIDString());
		payRefund.put("sign_type","MD5");
		payRefund.put("out_trade_no",abdp_UrlCode);
		payRefund.put("out_refund_no",abdp_UrlCode+"001");
		payRefund.put("total_fee",(int)(abdp_money*100));
		payRefund.put("refund_fee",(int)(abdp_money*100));
		payRefund.put("refund_fee_type","CNY");
		payRefund.put("refund_desc","客户取消预约");
		//payRefund.put("notify_url","");


		List<String> SortList=new ArrayList<String>();
		Iterator<String> FieldName=payRefund.keySet().iterator();
		while (FieldName.hasNext())
		{
			String key=FieldName.next();
			SortList.add(key);
		}
		Collections.sort(SortList);		
		String KeyString="";
		String XMLString="";
		for (int i =0;i<SortList.size();i++)
		{
			String Key=SortList.get(i);
			XMLString=XMLString+"<"+Key+">";
			String KeyValue = null;
			KeyValue =payRefund.getString(Key);
						

			if ((KeyValue!=null) && (!KeyValue.equals("")))
			{
				KeyString=KeyString+Key+"="+KeyValue+"&";
				XMLString=XMLString+"<![CDATA["+ KeyValue +"]]>";
			}
			XMLString=XMLString+"</"+Key+">";
		}
		KeyString=KeyString+"key="+GlobalVariable.APIKey;
		
		String sign = null;
		try {
			sign=DigestUtils.md5Hex(KeyString.getBytes("utf-8")).toUpperCase();
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

//		System.out.println("KeyString:"+KeyString);
//		System.out.println("sign:"+sign);
		XMLString="<xml>"+XMLString+"<sign>"+sign+"</sign></xml>";


//		System.out.println("XMLString:"+XMLString);

		
		String Result = null;
		try {
			Result = doRefund("https://api.mch.weixin.qq.com/secapi/pay/refund", XMLString);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
//		String Result=WebFunction.sendHttpPost("https://api.mch.weixin.qq.com/pay/refund", XMLString);

		System.out.println("Result:"+Result);
		
		StringReader sr = new StringReader(Result);
		InputSource is = new InputSource(sr);
		JSONObject ReturnList=new JSONObject();
		
		try {
			Document doc = (new SAXBuilder()).build(is);
			List<Element> xmlList=doc.getRootElement().getChildren();
			for (int i=0;i<xmlList.size();i++)
			{
				Element e=xmlList.get(i);
				String Key=e.getName();
				String Value=e.getText();
				ReturnList.put(Key,Value);
			}
		} catch (JDOMException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			ReturnList.put("return_msg",e.getMessage());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			ReturnList.put("return_msg",e.getMessage());
		}
		
		return ReturnList;
	}
	
	 public static String doRefund(String url,String data) throws Exception { 
		/**
		 * 注意PKCS12证书 是从微信商户平台-》账户设置-》 API安全 中下载的
		 */
		
		KeyStore keyStore  = KeyStore.getInstance("PKCS12");
		FileInputStream instream = new FileInputStream(new File(System.getProperty("catalina.home")+"\\cert\\apiclient_cert.p12"));//P12文件目录
		try {
			keyStore.load(instream, GlobalVariable.mch_id.toCharArray());//这里写密码..默认是你的MCHID
		} finally {
			instream.close();
		}

	 // Trust own CA and all self-signed certs
		SSLContext sslcontext = SSLContexts.custom()
				.loadKeyMaterial(keyStore, GlobalVariable.mch_id.toCharArray())
				.build();
		// Allow TLSv1 protocol only
		SSLConnectionSocketFactory sslsf = new SSLConnectionSocketFactory(
				sslcontext,
				new String[] { "TLSv1" },
				null,
				SSLConnectionSocketFactory.BROWSER_COMPATIBLE_HOSTNAME_VERIFIER);
		CloseableHttpClient httpclient = HttpClients.custom()
				.setSSLSocketFactory(sslsf)
				.build();
		try {
			HttpPost httpost = new HttpPost(url); // 设置响应头信息
			httpost.addHeader("Connection", "keep-alive");
			httpost.addHeader("Accept", "*/*");
			httpost.addHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
			httpost.addHeader("Host", "api.mch.weixin.qq.com");
			httpost.addHeader("X-Requested-With", "XMLHttpRequest");
			httpost.addHeader("Cache-Control", "max-age=0");
			httpost.addHeader("User-Agent", "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0) ");
			httpost.setEntity(new StringEntity(data, "UTF-8"));
			CloseableHttpResponse response = httpclient.execute(httpost);
			try {
				HttpEntity entity = response.getEntity();

				String jsonStr = EntityUtils.toString(response.getEntity(), "UTF-8");
				EntityUtils.consume(entity);
			   return jsonStr;
			} finally {
				response.close();
			}
		} finally {
			httpclient.close();
		}
	}
	 
	 
}
