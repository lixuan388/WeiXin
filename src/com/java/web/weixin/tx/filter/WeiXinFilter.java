package com.java.web.weixin.tx.filter;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.Base64;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.java.web.weixin.base.GlobalVariable;

public class WeiXinFilter implements Filter {

  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {
    // 获得在下面代码中要用的request,response,session对象
    HttpServletRequest servletRequest = (HttpServletRequest) request;
    HttpServletResponse servletResponse = (HttpServletResponse) response;
    HttpSession session = servletRequest.getSession();

    // 获得用户请求的URI
    String path = servletRequest.getRequestURI();
    System.out.println("--session:"+session.getId());
    System.out.println("--Scheme:"+request.getScheme());
    System.out.println("WeiXinFilter:" + path);
    String Parameter = "";
    String TempStr1 = "";

    Map<String, String[]> map = servletRequest.getParameterMap();
    for (Iterator iter = map.entrySet().iterator(); iter.hasNext();) {
      Map.Entry element = (Map.Entry) iter.next();
      String strKey = (String) element.getKey();
      String strValue = servletRequest.getParameter(strKey);
      Parameter = Parameter + TempStr1 + strKey + "=" + strValue;
      TempStr1 = "&";
    }
    if (!Parameter.equals("")) {
      Parameter = "?" + Parameter;
    }

    System.out.println("WeiXinFilter_Parameter:" + Parameter);

    // 从session里取员工工号信息
    String OpenID = session.getAttribute("openid") == null ? "" : (String) session.getAttribute("openid");

    // 判断如果没有取到员工信息,就跳转到登陆页面
    if (OpenID.equals("")) {
      //String WebUrl = request.getScheme()+"://" + request.getServerName(); // 服务器地址
      String WebUrl = request.getScheme()+"://" + request.getServerName(); // 服务器地址
//			if (request.getServerPort()!=80)
//			{
//				WebUrl=WebUrl + ":" + request.getServerPort();           //端口号
//			}

      String RedirectUrl = WebUrl + path + Parameter;
      Base64.Encoder Base64Encoder = Base64.getEncoder();
      byte[] Base64TextByte = RedirectUrl.getBytes("UTF-8");
      String Base64EncodedText = Base64Encoder.encodeToString(Base64TextByte);

      WebUrl = WebUrl + servletRequest.getContextPath() + "/Authorize?url=" + Base64EncodedText;

      System.out.println("WeiXinFilter_WebUrl:" + WebUrl);

      WebUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + GlobalVariable.AppID + "&redirect_uri="
          + URLEncoder.encode(WebUrl, "utf-8")
          + "&response_type=code&scope=snsapi_base&state=1&connect_redirect=1#wechat_redirect";

      System.out.println("authorize:" + WebUrl);
      servletResponse.sendRedirect(WebUrl);

    } else {
      // 已经登陆,继续此次请求
      chain.doFilter(request, response);
    }

  }

  public void init(FilterConfig arg0) throws ServletException {
    // TODO Auto-generated method stub

  }

  public void destroy() {
    // TODO Auto-generated method stub

  }

}
