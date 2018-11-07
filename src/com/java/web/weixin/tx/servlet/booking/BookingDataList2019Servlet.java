package com.java.web.weixin.tx.servlet.booking;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.java.sql.table.MySQLTable;

/**
 * Servlet implementation class MedicalProjectListServlet
 */
@WebServlet("/booking/BookingDataList2019.json")
public class BookingDataList2019Servlet extends HttpServlet {
  private static final long serialVersionUID = 1L;
  
  /**
   * @see HttpServlet#HttpServlet()
   */
  public BookingDataList2019Servlet() {
    super();
    // TODO Auto-generated constructor stub
  }
  
  /**
   * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
   *      response)
   */
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // TODO Auto-generated method stub
    response.setContentType("application/json;charset=utf-8");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache");
    
    String amb_Level = request.getSession().getAttribute("amb_Level") == null ? "1"
        : (String) request.getSession().getAttribute("amb_Level");
    
    net.sf.json.JSONObject ReturnJson = new net.sf.json.JSONObject();
    try {
      net.sf.json.JSONArray DatasJson = new net.sf.json.JSONArray();
      MySQLTable table = new MySQLTable(
          "select amp_namesht,abd_bookingDate,abd_id_amp,amp_money,amp_money2,sum(abd_maxBooking) as abd_maxBooking,\r\n"
              + "sum(abd_Hasbooking) as abd_Hasbooking\r\n"
              + "from abd_bookingdatetime,amp_medical_project ,amps_medical_project_schedule\r\n"
              + "where abd_bookingdatetime>now() \r\n" + "and abd_id_amp=amps_id_amp and abd_bookingdate=amps_date\r\n"
              + "and abd_id_amp=amp_id\r\n" + "and amps_flag =1\r\n" + "and abd_bookingdatetime._status<>'D'\r\n"
              + "and (abd_maxBooking)>0\r\n" + "group by amp_namesht,abd_bookingDate,abd_id_amp,amp_money,amp_money2\r\n"
              + "order by abd_BookingDate,abd_id_amp ");
      try {
        table.Open();

        SimpleDateFormat DateFormat=new SimpleDateFormat("MM月dd日");
        SimpleDateFormat DateFormat2=new SimpleDateFormat("MMdd");

        SimpleDateFormat TimeFormat;
        TimeFormat = new SimpleDateFormat("HH:mm");
        
        while (table.next()) {
          // if (table.getInt("abd_maxbooking")-table.getInt("abd_hasbooking")>0)
          {
            net.sf.json.JSONObject DataJson = new net.sf.json.JSONObject();
            DataJson.put("ampID", table.getString("abd_id_amp"));
            DataJson.put("ampName", table.getString("amp_namesht"));
            DataJson.put("Date", DateFormat.format(table.getDateTime("abd_bookingdate")));
            DataJson.put("DateID", DateFormat2.format(table.getDateTime("abd_bookingdate")));
            DataJson.put("DateTime", table.getDateTime("abd_bookingdate").getTime());
            
            try {
              DataJson.put("Week",dateToWeek(table.getDateTime("abd_bookingdate")));
            } catch (ParseException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
            }
            DataJson.put("Count", table.getInt("abd_maxbooking") - table.getInt("abd_hasbooking"));
            if (amb_Level.equals("1")) {
              DataJson.put("Money", table.getInt("amp_money"));
            } else {
              DataJson.put("Money", table.getInt("amp_money2"));
            }
            DatasJson.add(DataJson);
          }
        }
      } finally {
        table.Close();
      }
      ReturnJson.put("Data", DatasJson);
      ReturnJson.put("MsgID", "1");
      ReturnJson.put("MsgText", "Success！");
      
    } finally {
      response.getWriter().print(ReturnJson.toString());
      response.getWriter().flush();
    }
  }
  
  /**
   * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
   *      response)
   */
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // TODO Auto-generated method stub
    doGet(request, response);
  }
  
  public String dateToWeek(Date datetime) throws ParseException {
    String[] weekDays = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
    Calendar cal = Calendar.getInstance(); // 获得一个日历
    cal.setTime(datetime);
    int w = cal.get(Calendar.DAY_OF_WEEK) - 1; // 指示一个星期中的某天。
    if (w < 0)
        w = 0;
    return weekDays[w];
}
  
  
  
}
