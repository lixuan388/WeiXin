package com.java.web.weixin.base;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.CharBuffer;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;


public class GlobalVariable {
	public static String AppID="XXX";
	public static String AppSecret="XXX";
	public static String AccessToken="XXX";
	public static long AccessTokenTimeOut=0;
	public static String jsapi_ticket="";
	public static long jsapi_ticket_TimeOut=0;
	
	public static String APIKey="XXX";
	public static String SystemServerUrl="XXX";
	public static String mch_id="XXX";

  public static String WebUrl="XXX";



//	public static String AdminWeiXinOpenID="oziEnwXc5eWwN9HOIn8AxV7eFDfE";
//	public static String AdminWeiXinOpenID="oziEnwSB4iPWWppifL_nlgL4PLn0";
	public static String AdminWeiXinOpenID="oziEnwUCkSYDoZDd8lCUOm3hLg0w";
	
	
	
	
		
	//17ecity
	//wxb8cac7056400af58
	//8274aacfedda0ccd7eb542603ba0e9fe
	
	
	public static String GetMemberID(HttpServletRequest request)
	{
		String MemberID=(String)request.getSession().getAttribute("MemberID");
		return MemberID==null?"":MemberID;
	}
	public static String GetAccessToken()
	{	
		long d=System.currentTimeMillis();
		String url=SystemServerUrl+"/WeiXin/System/GetAccessToken?d="+d;
		String result=sendHttpGet(url);
		return result;
	}
	

	
	public static String GetJsapi_ticket()
	{	
		long d=System.currentTimeMillis();
		String url=SystemServerUrl+"/WeiXin/System/GetJsapiTicket?d="+d;
		String result=sendHttpGet(url);
//		System.out.println(url);
		return result;
	}
	
	

    public static String sendHttpGet(String url) {
        String result="";
        BufferedReader in = null;
//        InputStream in = null;
        try {
            String urlNameString = url ;
            URL realUrl = new URL(urlNameString);
            URLConnection connection = realUrl.openConnection();
            connection.setRequestProperty("accept", "*/*");
//            connection.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

            connection.setRequestProperty("Accept-Charset", "UTF-8");
            connection.setRequestProperty("contentType", "UTF-8");
            connection.setRequestProperty("connection", "Keep-Alive");
            connection.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");

            connection.connect();

            in = new BufferedReader(
                    new InputStreamReader(connection.getInputStream(), "UTF-8"));
//            		new InputStreamReader(connection.getInputStream(), "ISO-8859-1"));
            String line;
            while ((line = in.readLine()) != null) {

//                System.out.println("line:"+line);
                result += line;
            }
        } catch (Exception e) {
            System.out.println("发送 Get 请求出现异常！"+e);
            e.printStackTrace();
        }
        finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return result;
    }
    public static String sendHttpPost(String url,String param) {
    	BufferedWriter out = null;
    	
        BufferedReader in = null;
        String result = "";
        try {
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            // 设置通用的请求属性
            conn.setRequestProperty("accept", "*/*");

            conn.setRequestProperty("Accept-Charset", "UTF-8");
            conn.setRequestProperty("contentType", "UTF-8");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            // 发送POST请求必须设置如下两行
            conn.setDoOutput(true);
            conn.setDoInput(true);
            // 获取URLConnection对象对应的输出流
            out=new BufferedWriter(new OutputStreamWriter(conn.getOutputStream(),"UTF-8"));
            // 发送请求参数
            out.write(param.toCharArray());
            //out.print(param);
            // flush输出流的缓冲
            out.flush();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "utf-8"));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            System.out.println("发送 POST 请求出现异常！"+e);
            e.printStackTrace();
        }
        //使用finally块来关闭输出流、输入流
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return result;
    }
    
	public static String getWeekOfDate(Date dt) {
        String[] weekDays = {"星期日","星期一","星期二","星期三","星期四","星期五","星期六"};
        Calendar cal = Calendar.getInstance();
        cal.setTime(dt);

        int w = cal.get(Calendar.DAY_OF_WEEK) - 1;
        if (w < 0)
            w = 0;

        return weekDays[w];
    }
	static public String GUIDString()
	{
		UUID uuid = UUID.randomUUID();
		return uuid.toString().replaceAll("-","").substring(0, 31);
		
	}

	public static void GoErrerHtml(HttpServletRequest request, HttpServletResponse response,String ErrText)
	{
		String ErrUrlText;
			try {
				ErrUrlText = URLEncoder.encode(ErrText,"utf-8");

				try {
					response.sendRedirect("/WeiXin/ErrerHtml.jsp?ErrText="+ErrUrlText);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}			
			} catch (UnsupportedEncodingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
	}
	public static void GoSuccessHtml(HttpServletRequest request, HttpServletResponse response,String ErrText)
	{
		String ErrUrlText;
			try {
				ErrUrlText = URLEncoder.encode(ErrText,"utf-8");

				try {
					response.sendRedirect("/WeiXin/SuccessHtml.jsp?ShowText="+ErrUrlText);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}			
			} catch (UnsupportedEncodingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
	}
	
	public static void WriteMsgText(HttpServletResponse resp,int MsgID,String MsgText)
	{
		net.sf.json.JSONObject ResultXml = new net.sf.json.JSONObject();      
        ResultXml.put("MsgID",""+MsgID);
        ResultXml.put("MsgText",MsgText);
        try {
            resp.setContentType("application/json;charset=utf-8"); 
            resp.setCharacterEncoding("UTF-8");  
            resp.setHeader("Cache-Control", "no-cache");  
			resp.getWriter().print(ResultXml.toString());
	        resp.getWriter().flush();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static boolean CheckIsManager(HttpServletRequest request, HttpServletResponse response)
	{
		String openid=request.getSession().getAttribute("openid")==null?"0":(String)request.getSession().getAttribute("openid");
		if (openid.equals(""))
		{
			String ErrText="用户信息错误，无法操作！(openid)";

			GlobalVariable.GoErrerHtml(request, response, ErrText);
			return false;
		}
		
		String groupid=request.getSession().getAttribute("groupid")==null?"0":(String)request.getSession().getAttribute("groupid");
		if (!groupid.equals("100") && !groupid.equals("101"))
		{
			String ErrText="权限错误，无法操作！"+groupid;
			GlobalVariable.GoErrerHtml(request, response, ErrText);
			return false;
		}
		
		return true;
		
	}

	public static boolean CheckIfNoLoginToLogin(HttpServletRequest request, HttpServletResponse response,String state)
	{
		String openid=request.getSession().getAttribute("openid")==null?"":(String)request.getSession().getAttribute("openid");
		if (openid.equals(""))
		{
		    HttpServletRequest httpRequest=(HttpServletRequest)request;  
		    String WebUrl = request.getScheme()+"://" + request.getServerName(); //服务器地址
//		    if (request.getServerPort()!=80)
//		    {
//		    	WebUrl=WebUrl + ":" + request.getServerPort();           //端口号
//		    }
		    WebUrl=WebUrl+httpRequest.getContextPath()+"/Authorize";
		    try {
				WebUrl="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+GlobalVariable.AppID+"&redirect_uri="+ URLEncoder.encode(WebUrl, "utf-8") +"&response_type=code&scope=snsapi_base&state="+state+"&connect_redirect=1#wechat_redirect";
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				response.sendRedirect(WebUrl);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
			return false;
		}
		
		return true;
		
	}
	private static boolean isNotEmojiCharacter(char codePoint)
	{
		return (codePoint == 0x0) ||
			(codePoint == 0x9) ||
			(codePoint == 0xA) ||
			(codePoint == 0xD) ||
			((codePoint >= 0x20) && (codePoint <= 0xD7FF)) ||
			((codePoint >= 0xE000) && (codePoint <= 0xFFFD)) ||
			((codePoint >= 0x10000) && (codePoint <= 0x10FFFF));
	}

	/**
	 * 过滤emoji 或者 其他非文字类型的字符
	 * @param source
	 * @return
	 */
	public static String filterEmoji(String source)
	{
		int len = source.length();
		StringBuilder buf = new StringBuilder(len);
		for (int i = 0; i < len; i++)
		{
			char codePoint = source.charAt(i);
			if (isNotEmojiCharacter(codePoint))
			{
				buf.append(codePoint);
			}
		}
		return buf.toString();
	}
	
}
