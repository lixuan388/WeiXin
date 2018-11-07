package com.java.web.weixin.tx.servlet.pay;



import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
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

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.xml.sax.InputSource;

import com.java.sql.SQLConnect;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.tx.Class.booking.TBookingSuccessSendMessage;

/**
 * Servlet implementation class PDFSign
 */
@WebServlet("/PayResult")
public class PayResultServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PayResultServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub	    
		System.out.println("----------PayResult---------------");

		String return_code="ERROR";
		String return_msg;

//		request.setCharacterEncoding("utf-8");

	    BufferedReader bufferReader = new BufferedReader(new InputStreamReader(request.getInputStream(),"utf-8"));

	    StringBuffer buffer = new StringBuffer();
	    String line = "";
	    while ((line = bufferReader.readLine()) != null) {
	        buffer.append(line);
	    }
	    String XmlData=new String(buffer.toString());
//		System.out.println("XmlData:"+XmlData);

		HashMap<String,String> ReturnList=new HashMap<String,String>();

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

				Date now=new Date();
				SimpleDateFormat formatter; 
				formatter = new SimpleDateFormat ("yyyyMMddHHmmss");
				String and_TimeExpire =formatter.format(now);
				
				
				ResultSet rs = null;  
			    try {
			    	String sql="select and_id,and_TimeExpire,and_PayID,and_Type,and_Key,and_Value from and_notifyurl_data where 1<>1";
					rs = stmt.executeQuery(sql);
					UpdateData(rs,and_TimeExpire,and_TimeExpire,"PayResult_getPost","Xml",XmlData);
					
					StringReader sr = new StringReader(XmlData);
					InputSource is = new InputSource(sr);
					try {
						SAXBuilder builder = new SAXBuilder();
						builder.setFeature("http://apache.org/xml/features/disallow-doctype-decl",true);
						builder.setFeature("http://xml.org/sax/features/external-general-entities", false);
						builder.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
						
						Document doc = builder.build(is);						
//						字段名						变量名						必填						类型						示例值						描述
//						返回状态码						return_code						是						String(16)						SUCCESS						SUCCESS/FAIL						此字段是通信标识，非交易标识，交易是否成功需要查看result_code来判断
//						返回信息						return_msg						否						String(128)						签名失败						返回信息，如非空，为错误原因						签名失败						参数格式校验错误
//						以下字段在return_code为SUCCESS的时候有返回 
//						字段名						变量名	;/					必填						类型						示例值						描述
//						公众账号ID						appid						是						String(32)						wx8888888888888888						微信分配的公众账号ID（企业号corpid即为此appId）
//						商户号						mch_id						是						String(32)						1900000109						微信支付分配的商户号
//						设备号						device_info						否						String(32)						013467007045764						微信支付分配的终端设备号，
//						随机字符串						nonce_str						是						String(32)						5K8264ILTKCH16CQ2502SI8ZNMTM67VS						随机字符串，不长于32位
//						签名						sign						是						String(32)						C380BEC2BFD727A4B6845133519F3AD6						签名，详见签名算法
//						签名类型						sign_type						否						String(32)						HMAC-SHA256						签名类型，目前支持HMAC-SHA256和MD5，默认为MD5
//						业务结果						result_code						是						String(16)						SUCCESS						SUCCESS/FAIL						
//						错误代码						err_code						否						String(32)						SYSTEMERROR						错误返回的信息描述
//						错误代码描述						err_code_des						否						String(128)						系统错误						错误返回的信息描述
//						用户标识						openid						是						String(128)						wxd930ea5d5a258f4f						用户在商户appid下的唯一标识
//						是否关注公众账号						is_subscribe						否						String(1)						Y						用户是否关注公众账号，Y-关注，N-未关注，仅在公众账号类型支付有效
//						交易类型						trade_type						是						String(16)						JSAPI						JSAPI、NATIVE、APP
//						付款银行						bank_type						是						String(16)						CMC						银行类型，采用字符串类型的银行标识，银行类型见银行列表
//						订单金额						total_fee						是						Int						100						订单总金额，单位为分
//						应结订单金额						settlement_total_fee						否						Int						100						应结订单金额=订单金额-非充值代金券金额，应结订单金额<=订单金额。 
//						货币种类						fee_type						否						String(8)						CNY						货币类型，符合ISO4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
//						现金支付金额						cash_fee						是						Int						100						现金支付金额订单现金支付金额，详见支付金额
//						现金支付货币类型						cash_fee_type						否						String(16)						CNY						货币类型，符合ISO4217标准的三位字母代码，默认人民币：CNY，其他值列表详见货币类型
//						总代金券金额						coupon_fee						否						Int						10						代金券金额<=订单金额，订单金额-代金券金额=现金支付金额，详见支付金额
//						代金券使用数量						coupon_count						否						Int						1						代金券使用数量
//						代金券类型						coupon_type_$n						否						String						CASH						CASH--充值代金券						NO_CASH---非充值代金券 
//						并且订单使用了免充值券后有返回（取值：CASH、NO_CASH）。$n为下标,从0开始编号，举例：coupon_type_0
//						代金券ID						coupon_id_$n						否						String(20)						10000						代金券ID,$n为下标，从0开始编号
//						单个代金券支付金额						coupon_fee_$n						否						Int						100						单个代金券支付金额,$n为下标，从0开始编号
//						微信支付订单号						transaction_id						是						String(32)						1217752501201407033233368018						微信支付订单号
//						商户订单号						out_trade_no						是						String(32)						1212321211201407033568112322
//						商户系统内部订单号，要求32个字符内，只能是数字、大小写字母_-|*@ ，且在同一个商户号下唯一。
//						商家数据包						attach						否						String(128)						123456						商家数据包，原样返回
//						支付完成时间						time_end						是						String(14)						20141030133525
//						支付完成时间，格式为yyyyMMddHHmmss，如2009年12月25日9点10分10秒表示为20091225091010。其他详见时间规则
						
						List<Element> xmlList=doc.getRootElement().getChildren();
						for (int i=0;i<xmlList.size();i++)
						{
							Element e=xmlList.get(i);

							String Key=e.getName();
							String Value=e.getText();
							ReturnList.put(Key,Value);
//							System.out.println(Key+":"+Value);
							UpdateData(rs,and_TimeExpire,and_TimeExpire,"PayResult_getPost",Key,Value);							
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

					List<String> SortList=new ArrayList<String>();		
					Iterator iter = ReturnList.entrySet().iterator();
					while (iter.hasNext()) {
						Map.Entry entry = (Map.Entry) iter.next();			
						String key = (String)entry.getKey();
						SortList.add(key);
					}
					Collections.sort(SortList);
					
					String KeyString="";
					for (int i =0;i<SortList.size();i++)
					{
						String Key=SortList.get(i);
						String KeyValue=ReturnList.get(Key);
						if (!KeyValue.equals("") && !Key.equals("sign"))
						{
							KeyString=KeyString+Key+"="+KeyValue+"&";
						}
					}
					KeyString=KeyString+"key="+GlobalVariable.APIKey;

					String sign;
					sign=DigestUtils.md5Hex(KeyString.getBytes("utf-8")).toUpperCase();

//					System.out.println("---sign---");
//					System.out.println("Key:"+KeyString);
//					System.out.println("old:"+ReturnList.get("sign"));
//					System.out.println("new:"+sign);
					if (!sign.equals(ReturnList.get("sign")))
					{
						System.out.println("---sign---");
						System.out.println("Key:"+KeyString);
						System.out.println("old:"+ReturnList.get("sign"));
						System.out.println("new:"+sign);
		           		System.out.println("签名校验失败");

						UpdateData(rs,and_TimeExpire,and_TimeExpire,"PayResult_getPost","签名校验","Key:"+KeyString+"/old:"+ReturnList.get("sign")+"new:"+sign);		

		        		return_code="ERROR";
		        		return_msg="签名校验失败";
		        		
		           		
					}
					else
					{
						System.out.println("签名校验成功");
						return_code="SUCCESS";
		        		return_msg="OK";
						UpdateData(rs,and_TimeExpire,and_TimeExpire,"PayResult_getPost","签名校验","签名校验成功");
					}
					
					if (ReturnList.get("return_code").equals("SUCCESS"))
//					if (ReturnList.get("trade_state").equals("SUCCESS"))
					{
						sql="update abdp_bookingdatetime_pay set abdp_statustype='已付款',abdp_paydate=getdate(),abdp_PayCode='"+and_TimeExpire+"',abdp_TransactionID='"+ReturnList.get("transaction_id")+"',abdp_status='E',_status='E',_SyncFlag=0 where abdp_statustype<>'已付款' and  abdp_UrlCode='"+ReturnList.get("out_trade_no")+"'";	
					}
					else
					{
						sql="update abdp_bookingdatetime_pay set abdp_statustype='付款失败',abdp_paydate=getdate(),abdp_PayCode='"+and_TimeExpire+"'，abdp_remark='"+ReturnList.get("return_msg")+"',abdp_status='D',_SyncFlag=0 where abdp_UrlCode='"+ReturnList.get("out_trade_no")+"'";
					}
					stmt.executeUpdate(sql);

          if (ReturnList.get("return_code").equals("SUCCESS"))
					//if (ReturnList.get("trade_state").equals("SUCCESS"))
					{						
						new TBookingSuccessSendMessage(ReturnList.get("out_trade_no"));	
					}

			    	
					
					
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
			    return ;
				}
				finally {
					if (rs != null) try { rs.close(); } catch(Exception e) {}
			    }     			    			    
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
	    
	    response.setContentType("application/xml;charset=utf-8"); 
	    response.setCharacterEncoding("UTF-8");  
	    response.setHeader("Cache-Control", "no-cache");  
	    response.getWriter().print("<xml><return_code><![CDATA["+return_code+"]]></return_code><return_msg><![CDATA["+return_msg+"]]></return_msg></xml> ");
	    response.getWriter().flush();
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	{
		try {
			this.doGet(request, response);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public void UpdateData(ResultSet rs,String and_TimeExpire,String and_PayID,String and_Type,String and_Key,String and_Value)
	{
		try {

//			System.out.println("-----UpdateData----");
			
			rs.moveToInsertRow();
			rs.updateString("and_TimeExpire",and_TimeExpire);
			rs.updateString("and_PayID",and_PayID);
			rs.updateString("and_Type",and_Type);
			rs.updateString("and_Key",and_Key);
			rs.updateString("and_Value",and_Value);
			rs.insertRow();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}


}
