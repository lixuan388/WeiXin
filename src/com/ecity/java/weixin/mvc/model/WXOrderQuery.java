package com.ecity.java.weixin.mvc.model;

import com.ecity.java.mvc.model.ECityModel;

public class WXOrderQuery extends ECityModel {
	/**
   * 
   */
  private static final long serialVersionUID = -6230830445936684770L;
  private String appid;// 	是 	String(32) 	wx8888888888888888 	微信分配的公众账号ID（企业号corpid即为此appId）
	private String mch_id;// 	是 	String(32) 	1900000109 	微信支付分配的商户号
	private String out_trade_no;//商户系统内部订单号，要求32个字符内，只能是数字、大小写字母_-|*@ ，且在同一个商户号下唯一。 详见商户订单号
	private String nonce_str;// 	是 	String(32) 	5K8264ILTKCH16CQ2502SI8ZNMTM67VS 	随机字符串，不长于32位。推荐随机数生成算法
//	private String sign;// 	是 	String(32) 	C380BEC2BFD727A4B6845133519F3AD6 	签名，详见签名生成算法
	private String sign_type;// 	否 	String(32) 	HMAC-SHA256 	签名类型，目前支持HMAC-SHA256和MD5，默认为MD5
  public String getAppid() {
    return appid;
  }
  public void setAppid(String appid) {
    this.appid = appid;
  }
  public String getMch_id() {
    return mch_id;
  }
  public void setMch_id(String mch_id) {
    this.mch_id = mch_id;
  }
  public String getOut_trade_no() {
    return out_trade_no;
  }
  public void setOut_trade_no(String out_trade_no) {
    this.out_trade_no = out_trade_no;
  }
  public String getNonce_str() {
    return nonce_str;
  }
  public void setNonce_str(String nonce_str) {
    this.nonce_str = nonce_str;
  }
  public String getSign_type() {
    return sign_type;
  }
  public void setSign_type(String sign_type) {
    this.sign_type = sign_type;
  }


	
	
}
