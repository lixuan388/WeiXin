package com.java.web.weixin.TimeTask;

import java.io.IOException;
import java.util.Timer;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletException;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.version;
import com.java.sql.table.MySQLTable;
import com.java.web.weixin.base.GlobalVariable;
import com.java.web.weixin.system.Config;

public class TestServerRunServlet implements ServletContextListener {

  private Timer timer = null;

  public void contextDestroyed(ServletContextEvent event) {
    // TODO Auto-generated method stub
    // 在这里关闭监听器，所以在这里销毁定时器。
    String IsDebug = event.getServletContext().getInitParameter("ServerType") == null ? "test"
        : event.getServletContext().getInitParameter("ServerType");

    if (!IsDebug.equals("test")) {
      timer.cancel();
      event.getServletContext().log("定时器ServerRunServlet销毁");
    }
  }

  public void contextInitialized(ServletContextEvent event) {
    // TODO Auto-generated method stub
    System.out.println(
        "------------ServerType:" + event.getServletContext().getInitParameter("ServerType") + "---------------");
    System.out.println("Version:" + version.Version);
    // GlobalVariable.WebUrl="http://www.jackiehor.org"+event.getServletContext().getContextPath();

    String tomcatPath = System.getProperty("catalina.home");
    String ConfigPath = tomcatPath + "//conf//webConfig.properties";
    System.out.println(ConfigPath);
    try {
      Config c = new Config(ConfigPath);
      c.load();
      GlobalVariable.APIKey = c.getProperty("wx.weixin.appkey");
      GlobalVariable.AppID = c.getProperty("wx.weixin.appid");
      GlobalVariable.AppSecret = c.getProperty("wx.weixin.appsecret");
      GlobalVariable.mch_id = c.getProperty("wx.weixin.mch_id");
      GlobalVariable.SystemServerUrl = c.getProperty("wx.weixin.SystemServerUrl");

    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      System.err.println("-------------------");
      System.err.println("配置文件读取失败！");
      System.err.println(ConfigPath);
    }

    GlobalVariable.WebUrl = GlobalVariable.SystemServerUrl + event.getServletContext().getContextPath();
    System.out.println("WebUrl:" + GlobalVariable.WebUrl);

    String IsDebug = event.getServletContext().getInitParameter("ServerType") == null ? "test"
        : event.getServletContext().getInitParameter("ServerType");
    MySQLTable table = new MySQLTable("select * from abp_base_parameter");
    table.Open();
    while (table.next()) {
      System.setProperty("WeiXin.tx." + table.getString("abp_name"), table.getString("abp_value"));
    }

    if (!IsDebug.equals("test")) {
      timer = new Timer(true);
      // 添加日志，可在tomcat日志中查看到
      System.out.println("开启定时器ServerRunServlet");
      // 调用定时任务，0表示任务无延迟，5*1000表示每隔5秒执行任务，触发间隔以毫秒计算。
      // 1分钟后启动，每10秒一次
      System.out.println("1分钟后启动，每60秒一次");
      timer.schedule(new TestServerRunTimeTask(), 1000 * 60, 1000 * 60);
      timer.schedule(new CreateBookingDateTimeTimeTask(), 1000 * 60, 1000 * 60);
      timer.schedule(new UpdateCheckInTimeTask(), 1000 * 60, 1000 * 60);
      timer.schedule(new ClearTimeOutTimeTask(), 1000 * 60, 1000 * 60);
      timer.schedule(new CancelBookingPayTimeTask(), 1000 * 60, 1000 * 60);
      timer.schedule(new SendBookingDateMsgTimeTask(), 1000 * 60, 1000 * 60);
      timer.schedule(new UpdateBookingPayCountTimeTask(), 1000 * 60, 1000 * 60 * 60);
      System.out.println("定时器ServerRunServlet已开启");
    } else {

      System.out.println("测试服务器，不开启定时器");
    }

  }

}
