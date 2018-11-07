package com.ecity.java.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;

import java.util.Base64;
import java.util.Date;

public class WebFunction {

  static public String GUIDString() {
    UUID uuid = UUID.randomUUID();
    return uuid.toString().replaceAll("-", "").substring(0, 31);

  }

  public static String sendHttpGet(String url) {
    String result = "";
    BufferedReader in = null;
    // InputStream in = null;
    try {
      String urlNameString = url;
      URL realUrl = new URL(urlNameString);
      URLConnection connection = realUrl.openConnection();
      connection.setRequestProperty("accept", "*/*");
      // connection.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
      connection.setRequestProperty("Accept-Charset", "UTF-8");
      connection.setRequestProperty("contentType", "UTF-8");
      connection.setRequestProperty("connection", "Keep-Alive");
      connection.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
      connection.connect();

      in = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
      // new InputStreamReader(connection.getInputStream(), "ISO-8859-1"));
      String line;
      while ((line = in.readLine()) != null) {
        result += line;
//				System.out.println("readLine:"+line);
      }
    } catch (Exception e) {
      System.out.println("发送 Get 请求出现异常！" + e);
      e.printStackTrace();
    } finally {
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

  public static String sendHttpPost(String url, String param) {
    BufferedWriter out = null;

    BufferedReader in = null;
    String result = "";

//		System.out.println("sendHttpPost:");

    try {
      URL realUrl = new URL(url);
      // 打开和URL之间的连接
      URLConnection conn = realUrl.openConnection();
      // 设置通用的请求属性
      conn.setRequestProperty("accept", "*/*");
      conn.setRequestProperty("Accept-Charset", "UTF-8");
      conn.setRequestProperty("contentType", "UTF-8");
      conn.setRequestProperty("connection", "Keep-Alive");
      conn.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
      // 发送POST请求必须设置如下两行
      conn.setDoOutput(true);
      conn.setDoInput(true);
      // 获取URLConnection对象对应的输出流
      out = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream(), "UTF-8"));
      // 发送请求参数
      out.write(param.toCharArray());
      // out.print(param);
      // flush输出流的缓冲
      out.flush();
      // 定义BufferedReader输入流来读取URL的响应
      in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));

//			in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
      String line;
      while ((line = in.readLine()) != null) {
        result += line;
//				System.out.println("readLine:"+line);
      }
    } catch (Exception e) {
      System.out.println("发送 POST 请求出现异常！" + e);
      e.printStackTrace();
    }
    // 使用finally块来关闭输出流、输入流
    finally {
      try {
        if (out != null) {
          out.close();
        }
        if (in != null) {
          in.close();
        }
      } catch (IOException ex) {
        ex.printStackTrace();
      }
    }
    return result;
  }

}
