package com.ecity.java.weixin.mvc.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.net.URL;
import java.net.URLConnection;
import java.security.KeyStore;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
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
import org.xml.sax.InputSource;

import com.ecity.java.web.WebFunction;
import com.ecity.java.weixin.mvc.model.WXOrderQuery;

import net.sf.json.JSONObject;

import javax.net.ssl.SSLContext;

public class WXService implements IWXService {


  // 字段名 变量名 必填 类型 示例值 描述
  // 公众账号ID appid 是 String(32) wxd678efh567hg6787 微信支付分配的公众账号ID（企业号corpid即为此appId）
  // 商户号 mch_id 是 String(32) 1230000109 微信支付分配的商户号
  // 备号 device_info 否 String(32) 013467007045764
  // 自定义参数，可以为终端设备号(门店号或收银设备ID)，PC网页或公众号内支付可以传"WEB"
  // 随机字符串 nonce_str 是 String(32) 5K8264ILTKCH16CQ2502SI8ZNMTM67VS
  // 随机字符串，长度要求在32位以内。推荐随机数生成算法
  // 签名 sign 是 String(32) C380BEC2BFD727A4B6845133519F3AD6 通过签名算法计算得出的签名值，详见签名生成算法
  // 签名类型 sign_type 否 String(32) MD5 签名类型，默认为MD5，支持HMAC-SHA256和MD5。
  // 商品描述 body 是 String(128) 腾讯充值中心-QQ会员充值 商品简单描述，该字段请按照规范传递，具体请见参数规定
  // 商品详情 detail 否 String(6000)   商品详细描述，对于使用单品优惠的商户，改字段必须按照规范上传，详见“单品优惠参数说明”
  // 附加数据 attach 否 String(127) 深圳分店 附加数据，在查询API和支付通知中原样返回，可作为自定义参数使用。
  // 商户订单号 out_trade_no 是 String(32) 20150806125346
  // 商户系统内部订单号，要求32个字符内，只能是数字、大小写字母_-|*@ ，且在同一个商户号下唯一。详见商户订单号
  // 标价币种 fee_type 否 String(16) CNY 符合ISO 4217标准的三位字母代码，默认人民币：CNY，详细列表请参见货币类型
  // 标价金额 total_fee 是 Int 88 订单总金额，单位为分，详见支付金额
  // 终端IP spbill_create_ip 是 String(16) 123.12.12.123
  // APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
  // 交易起始时间 time_start 否 String(14) 20091225091010
  // 订单生成时间，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。其他详见时间规则
  // 交易结束时间 time_expire 否 String(14) 20091227091010
  // 订单失效时间，格式为yyyyMMddHHmmss，如2009年12月27日9点10分10秒表示为20091227091010。其他详见时间规则
  // 注意：最短失效时间间隔必须大于5分钟
  // 订单优惠标记 goods_tag 否 String(32) WXG 订单优惠标记，使用代金券或立减优惠功能时需要的参数，说明详见代金券或立减优惠
  // 通知地址 notify_url 是 String(256) http://www.weixin.qq.com/wxpay/pay.php
  // 异步接收微信支付结果通知的回调地址，通知url必须为外网可访问的url，不能携带参数。
  // 交易类型 trade_type 是 String(16) JSAPI 取值如下：JSAPI，NATIVE，APP等，说明详见参数规定
  // 商品ID product_id 否 String(32) 12235413214070356458058
  // trade_type=NATIVE时（即扫码支付），此参数必传。此参数为二维码中包含的商品ID，商户自行定义。
  // 指定支付方式 limit_pay 否 String(32) no_credit 上传此参数no_credit--可限制用户不能使用信用卡支付
  // 用户标识 openid 否 String(128) oUpF8uMuAJO_M2pxb1Q9zNjWeS6o
  // trade_type=JSAPI时（即公众号支付），此参数必传，此参数为微信用户在商户对应appid下的唯一标识。openid如何获取，可参考【获取openid】。企业号请使用【企业号OAuth2.0接口】获取企业号内成员userid，再调用【企业号userid转openid接口】进行转换
  // +场景信息 scene_info 否 String(256)
//		{"store_info" : {
//		"id": "SZTX001",
//		"name": "腾大餐厅",
//		"area_code": "440305",
//		"address": "科技园中一路腾讯大厦" }}
//		该字段用于上报场景信息，目前支持上报实际门店信息。该字段为JSON对象数据，对象格式为{"store_info":{"id": "门店ID","name": "名称","area_code": "编码","address": "地址" }} ，字段详细说明请点击行前的+展开
  //

  public String OrderQuery(String appid,String mch_id,String APIKey,String out_trade_no)
  {
//    公众账号ID  appid   是   String(32)  wxd678efh567hg6787  微信支付分配的公众账号ID（企业号corpid即为此appId）
//    商户号   mch_id  是   String(32)  1230000109  微信支付分配的商户号
//    微信订单号   transaction_id  二选一   String(32)  1009660380201506130728806387  微信的订单号，建议优先使用
//    商户订单号   out_trade_no  String(32)  20150806125346  商户系统内部订单号，要求32个字符内，只能是数字、大小写字母_-|*@ ，且在同一个商户号下唯一。 详见商户订单号
//    随机字符串   nonce_str   是   String(32)  C380BEC2BFD727A4B6845133519F3AD6  随机字符串，不长于32位。推荐随机数生成算法
//    签名  sign  是   String(32)  5K8264ILTKCH16CQ2502SI8ZNMTM67VS  通过签名算法计算得出的签名值，详见签名生成算法
//    签名类型  sign_type   否   String(32)  HMAC-SHA256   签名类型，目前支持HMAC-SHA256和MD5，默认为MD5
    
    
    WXOrderQuery orderQuery = new WXOrderQuery();
    orderQuery.setAppid(appid);
    orderQuery.setMch_id(mch_id);
    orderQuery.setNonce_str(WebFunction.GUIDString());
    orderQuery.setSign_type("MD5");
    orderQuery.setOut_trade_no(out_trade_no);
    

    List<String> SortList = new ArrayList<String>();
    HashMap<String, Field> Fields = orderQuery.getFields();
    Iterator<String> FieldName = Fields.keySet().iterator();
    while (FieldName.hasNext()) {
      String key = FieldName.next();
      SortList.add(key);
    }
    Collections.sort(SortList);
    String KeyString = "";
    String XMLString = "";
    for (int i = 0; i < SortList.size(); i++) {
      String Key = SortList.get(i);
      XMLString = XMLString + "<" + Key + ">";
      String KeyValue = null;
      try {
        KeyValue = (String) BeanUtils.getProperty(orderQuery, Key);
      } catch (IllegalAccessException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      } catch (InvocationTargetException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      } catch (NoSuchMethodException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }

      if ((KeyValue != null) && (!KeyValue.equals(""))) {
        KeyString = KeyString + Key + "=" + KeyValue + "&";
        XMLString = XMLString + KeyValue;
      } else {
//        System.out.println("Key:"+Key+";is null ");
      }
      XMLString = XMLString + "</" + Key + ">";
    }
    KeyString = KeyString + "key=" + APIKey;

    String sign = null;
    try {
      sign = DigestUtils.md5Hex(KeyString.getBytes("utf-8")).toUpperCase();
    } catch (UnsupportedEncodingException e1) {
      // TODO Auto-generated catch block
      e1.printStackTrace();
    }

    XMLString = "<xml>" + XMLString + "<sign>" + sign + "</sign></xml>";


    String Result = WebFunction.sendHttpPost("https://api.mch.weixin.qq.com/pay/orderquery", XMLString);
    System.out.println("Result:" + Result);
    return Result;
    
    
    


//    System.out.println("Result:" + Result);
//
//    StringReader sr = new StringReader(Result);
//    InputSource is = new InputSource(sr);
//    JSONObject ReturnList = new JSONObject();
//
//    try {
//      Document doc = (new SAXBuilder()).build(is);
//      List<Element> xmlList = doc.getRootElement().getChildren();
//      for (int i = 0; i < xmlList.size(); i++) {
//        Element e = xmlList.get(i);
//        String Key = e.getName();
//        String Value = e.getText();
//        ReturnList.put(Key, Value);
//      }
//    } catch (JDOMException e) {
//      // TODO Auto-generated catch block
//      e.printStackTrace();
//      ReturnList.put("return_msg", e.getMessage());
//    } catch (IOException e) {
//      // TODO Auto-generated catch block
//      e.printStackTrace();
//      ReturnList.put("return_msg", e.getMessage());
//    }
//
//    return ReturnList;
    
  }

}
