package com.java.web.weixin.jssdk;

import java.io.IOException;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.digest.DigestUtils;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.xml.sax.InputSource;

import com.java.sql.SQLConnect;
import com.java.web.weixin.base.GlobalVariable;

public class WXUnifiedorder {

//
//	
////	字段名	变量名	必填	类型	示例值	描述
////	返回状态码	return_code	是	String(16)	SUCCESS	SUCCESS/FAIL	此字段是通信标识，非交易标识，交易是否成功需要查看result_code来判断
//	public String return_code="";
////	返回信息	return_msg	否	String(128)	签名失败	返回信息，如非空，为错误原因 	签名失败 	参数格式校验错误
//	public String return_msg="";
////	以下字段在return_code为SUCCESS的时候有返回 
////	字段名	变量名	必填	类型	示例值	描述
////	公众账号ID	appid	是	String(32)	wx8888888888888888	调用接口提交的公众账号ID
//	public String appid="";
////	商户号	mch_id	是	String(32)	1900000109	调用接口提交的商户号
//	public String mch_id="";
////	设备号	device_info	否	String(32)	013467007045764	自定义参数，可以为请求支付的终端设备号等
//	public String device_info="";
////	随机字符串	nonce_str	是	String(32)	5K8264ILTKCH16CQ2502SI8ZNMTM67VS	微信返回的随机字符串
//	public String nonce_str="";
////	签名	sign	是	String(32)	C380BEC2BFD727A4B6845133519F3AD6	微信返回的签名值，详见签名算法
//	public String returnSign="";
////	业务结果	result_code	是	String(16)	SUCCESS	SUCCESS/FAIL
//	public String result_code="";
////	错误代码	err_code	否	String(32)	SYSTEMERROR	详细参见下文错误列表
//	public String err_code="";	
////	错误代码描述	err_code_des	否	String(128)	系统错误	错误信息描述
//	public String err_code_des="";
////	以下字段在return_code 和result_code都为SUCCESS的时候有返回 
////	字段名	变量名	必填	类型	示例值	描述
////	交易类型	trade_type	是	String(16)	JSAPI	交易类型，取值为：JSAPI，NATIVE，APP等，说明详见参数规定
//	public String trade_type="";
//	
////	预支付交易会话标识	prepay_id	是	String(64)	wx201410272009395522657a690389285100	微信生成的预支付会话标识，用于后续接口调用中使用，该值有效期为2小时
//	public String prepay_id="";
////	二维码链接	code_url	否	String(64)	URl：weixin：//wxpay/s/An4baqw	trade_type为NATIVE时有返回，用于生成二维码，展示给用户进行扫码支付
//	public String code_url="";
	
	
	
//	public String appid;
//	public String mch_id;
//	public String device_info;
//	public String nonce_str;
//	public String sign;
//	public String sign_type;
//	public String body;
//	public String detail;
//	public String attach;
//	public String out_trade_no;
//	public String fee_type;
//	public int total_fee;
//	public String spbill_create_ip;
//	public String time_start;
//	public String time_expire;
//	public String goods_tag;
//	public String notify_url;
//	public String trade_type;
//	public String product_id;
//	public String limit_pay;
//	public String openid;
//	public String scene_info;
	
	
	

	
	
	


	public HashMap<String,String> ReturnList=new HashMap<String,String>();

	public HashMap<String,String> ParameterList=new HashMap<String,String>();

//字段名    变量名    必填    类型    示例值    描述    
//公众账号ID    appid    是    String(32)    wxd678efh567hg6787   微信支付分配的公众账号ID（企业号corpid即为此appId）
//商户号    mch_id    是    String(32)    1230000109    微信支付分配的商户号
//备号    device_info    否    String(32)    013467007045764    自定义参数，可以为终端设备号(门店号或收银设备ID)，PC网页或公众号内支付可以传"WEB"
//随机字符串    nonce_str    是    String(32)    5K8264ILTKCH16CQ2502SI8ZNMTM67VS    随机字符串，长度要求在32位以内。推荐随机数生成算法
//签名    sign    是    String(32)    C380BEC2BFD727A4B6845133519F3AD6    通过签名算法计算得出的签名值，详见签名生成算法
//签名类型    sign_type    否    String(32)    MD5    签名类型，默认为MD5，支持HMAC-SHA256和MD5。
//商品描述    body    是    String(128)    腾讯充值中心-QQ会员充值    商品简单描述，该字段请按照规范传递，具体请见参数规定
//商品详情    detail    否    String(6000)         商品详细描述，对于使用单品优惠的商户，改字段必须按照规范上传，详见“单品优惠参数说明”
//附加数据    attach    否    String(127)    深圳分店    附加数据，在查询API和支付通知中原样返回，可作为自定义参数使用。
//商户订单号    out_trade_no    是    String(32)    20150806125346    商户系统内部订单号，要求32个字符内，只能是数字、大小写字母_-|*@ ，且在同一个商户号下唯一。详见商户订单号
//标价币种    fee_type    否    String(16)    CNY    符合ISO 4217标准的三位字母代码，默认人民币：CNY，详细列表请参见货币类型
//标价金额    total_fee    是    Int    88    订单总金额，单位为分，详见支付金额
//终端IP    spbill_create_ip    是    String(16)    123.12.12.123    APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
//交易起始时间    time_start    否    String(14)    20091225091010    订单生成时间，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。其他详见时间规则
//交易结束时间    time_expire    否    String(14)    20091227091010    订单失效时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。其他详见时间规则
//注意：最短失效时间间隔必须大于5分钟
//订单优惠标记    goods_tag    否    String(32)    WXG    订单优惠标记，使用代金券或立减优惠功能时需要的参数，说明详见代金券或立减优惠
//通知地址    notify_url    是    String(256)    http://www.weixin.qq.com/wxpay/pay.php    异步接收微信支付结果通知的回调地址，通知url必须为外网可访问的url，不能携带参数。
//交易类型    trade_type    是    String(16)    JSAPI    取值如下：JSAPI，NATIVE，APP等，说明详见参数规定
//商品ID    product_id    否    String(32)    12235413214070356458058    trade_type=NATIVE时（即扫码支付），此参数必传。此参数为二维码中包含的商品ID，商户自行定义。
//指定支付方式    limit_pay    否    String(32)    no_credit    上传此参数no_credit--可限制用户不能使用信用卡支付
//用户标识    openid    否    String(128)    oUpF8uMuAJO_M2pxb1Q9zNjWeS6o    trade_type=JSAPI时（即公众号支付），此参数必传，此参数为微信用户在商户对应appid下的唯一标识。openid如何获取，可参考【获取openid】。企业号请使用【企业号OAuth2.0接口】获取企业号内成员userid，再调用【企业号userid转openid接口】进行转换
//+场景信息    scene_info    否    String(256)
//    {"store_info" : {
//    "id": "SZTX001",
//    "name": "腾大餐厅",
//    "area_code": "440305",
//    "address": "科技园中一路腾讯大厦" }}
//    该字段用于上报场景信息，目前支持上报实际门店信息。该字段为JSON对象数据，对象格式为{"store_info":{"id": "门店ID","name": "名称","area_code": "编码","address": "地址" }} ，字段详细说明请点击行前的+展开
//    
    

  
  public WXUnifiedorder(HttpServletRequest request,String body,String out_trade_no,
        int total_fee,String product_id,String openid)
  {
    this(request,body,out_trade_no,total_fee,product_id,openid,GlobalVariable.AppID);
    
  }
    public WXUnifiedorder(HttpServletRequest request,String body,String out_trade_no,
    			int total_fee,String product_id,String openid,String AppID)
    {

		System.out.println("WXUnifiedorder()");
		ParameterList.put("appid",GlobalVariable.AppID);
		ParameterList.put("mch_id",GlobalVariable.mch_id);
		ParameterList.put("device_info","公众号支付");



		ParameterList.put("nonce_str",GlobalVariable.GUIDString());
		ParameterList.put("sign_type","MD5");
		ParameterList.put("body",body);
		ParameterList.put("detail","");
		ParameterList.put("attach","");

		ParameterList.put("out_trade_no",out_trade_no);
		ParameterList.put("fee_type","CNY");
		ParameterList.put("total_fee",""+total_fee);
		ParameterList.put("spbill_create_ip",request.getRemoteAddr());

		
		Date now=new Date();
		SimpleDateFormat formatter; 
		formatter = new SimpleDateFormat ("yyyyMMddHHmmss");
		String StringDate =formatter.format(now);
		ParameterList.put("time_start",StringDate);
		
		now.setTime(now.getTime()+1000*60*5);
		StringDate =formatter.format(now);
		ParameterList.put("time_expire",StringDate);
		ParameterList.put("goods_tag","");
		
	    String WebUrl = request.getScheme()+"://" + request.getServerName(); //服务器地址
//	    if (request.getServerPort()!=80)
//	    {
//	    	WebUrl=WebUrl + ":" + request.getServerPort();           //端口号
//	    }
	    WebUrl=WebUrl+request.getContextPath()+"/PayResult";

		ParameterList.put("notify_url",WebUrl);
		ParameterList.put("trade_type","JSAPI");
		ParameterList.put("product_id",product_id);
		ParameterList.put("limit_pay","");
		ParameterList.put("openid",openid);
		ParameterList.put("scene_info","");
		
		
		List<String> SortList=new ArrayList<String>();		
		Iterator iter = ParameterList.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();			
			String key = (String)entry.getKey();
			SortList.add(key);
		}
		Collections.sort(SortList);
		
		String KeyString="";
		String XMLString="";
		for (int i =0;i<SortList.size();i++)
		{
			String Key=SortList.get(i);
			XMLString=XMLString+"<"+Key+">";
			String KeyValue=ParameterList.get(Key);
			if (!KeyValue.equals(""))
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

		XMLString="<xml>"+XMLString+"<sign>"+sign+"</sign></xml>";

		System.out.println("KeyString:"+KeyString);
		System.out.println("XMLString GBK:"+XMLString);
		try {
			System.out.println("XMLString:"+new String(XMLString.getBytes("UTF-8"),"UTF-8"));
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
//		System.out.println("sign:"+sign);
		
		
		String Result=GlobalVariable.sendHttpPost("https://api.mch.weixin.qq.com/pay/unifiedorder", XMLString);

//		System.out.println("Result:"+Result);
		
		
		StringReader sr = new StringReader(Result);
		InputSource is = new InputSource(sr);
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
			if (ReturnList.get("return_code").equals("SUCCESS"))
			{
				if (ReturnList.get("result_code").equals("SUCCESS"))
				{					
					String PrepayID=ReturnList.get("prepay_id");
					String CodeUrl=ReturnList.get("code_url");
					UpdatePrepayID(out_trade_no, PrepayID, CodeUrl);
				}
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
    }
    
    public HashMap<String,String> GetParameterList()
    {
    	return ParameterList;    	
    }
    
    public HashMap<String,String> GetReturnList()
    {
    	return ReturnList;
    }
    

    public void UpdatePrepayID(String UrlCode,String PrepayID,String CodeUrl)
    {

		Statement stmt = null;
	    Connection con = null;
 		
	    try {       	
        	con=SQLConnect.GetConnect();
           	if (con==null)
           	{
           		System.out.println("数据库连接异常");
           		return ;
           	}    	     
			try {
				stmt = con.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
			    String sql="update abdp_BookingDatetime_Pay set abdp_prepayID='"+PrepayID+"',abdp_CodeUrl='"+CodeUrl+"',abdp_date_lst=getdate() where abdp_urlcode='"+UrlCode+"'" ;
				stmt.executeUpdate(sql);			    
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
		        return ;
			}	
			finally {
		        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
		    }     
		} 
       finally {
           if (con != null) try { con.close(); } catch(Exception e) {}
       }      
    }
}
