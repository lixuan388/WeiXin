package com.java.web.weixin.tx.filter;

import java.io.IOException;

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

public class LoginFilter implements Filter {

	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub

        // 获得在下面代码中要用的request,response,session对象
        HttpServletRequest servletRequest = (HttpServletRequest) request;
        HttpServletResponse servletResponse = (HttpServletResponse) response;
        

        if (servletRequest.getHeader("user-agent").indexOf("MicroMessenger") <0)
        {
			String ErrText="请用微信打开！";
			GlobalVariable.GoErrerHtml(servletRequest,servletResponse,ErrText);
			return; 
            
        } 
        HttpSession session = servletRequest.getSession();

        // 获得用户请求的URI
        String path = servletRequest.getRequestURI();
        //System.out.println(path);
        String openid=servletRequest.getSession().getAttribute("openid")==null?"":(String)servletRequest.getSession().getAttribute("openid");

        /*创建类Constants.java，里面写的是无需过滤的页�?
        for (int i = 0; i < Constants.NoFilter_Pages.length; i++) {

            if (path.indexOf(Constants.NoFilter_Pages[i]) > -1) {
                chain.doFilter(servletRequest, servletResponse);
                return;
            }
        }*/

        // 登陆页面无需过滤
        if(path.indexOf("/tx/index.jsp") > -1) {
            chain.doFilter(servletRequest, servletResponse);
            return;
        }

        // 预约管理无需过滤
        if(path.indexOf("/tx/QueryBookingDateList.jsp") > -1) {
            chain.doFilter(servletRequest, servletResponse);
            return;
        }

        // 判断如果没有取到员工信息,就跳转到登陆页面
        if ("".equals(openid) && (path.indexOf(".jsp") > -1) ) {

			String ErrText="用户未登录！";
			GlobalVariable.GoErrerHtml(servletRequest,servletResponse,ErrText);
            
        } else {
            // 已经登陆,继续此次请求
            chain.doFilter(request, response);
        }

	}

	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		
	}

}
