package com.java;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/version")

public class version extends HttpServlet {

  /**
   * 
   */
  private static final long serialVersionUID = 1L;

  public static String Version = "weixin.2019.09.29.0165";

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    // TODO Auto-generated method stub
    resp.setContentType("text/html;charset=utf-8");
    resp.setHeader("Cache-Control", "no-cache");
    resp.getWriter().println(Version);
    resp.getWriter().println("<br>"+req.getScheme());
    System.out.println(Version);
    resp.getWriter().flush();
  }
}
