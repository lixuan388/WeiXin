package com.java.web.weixin.jssdk;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.digest.DigestUtils;

import com.java.web.weixin.base.GlobalVariable;

public class WXConfig {
  public String appId;
  public String timestamp;
  public String nonceStr;
  public String signature;
  public String sha1;

  // ����1. �����д�ǩ��������ֶ����ASCII
  // ���С���������ֵ��򣩺�ʹ��URL��ֵ�Եĸ�ʽ����key1=value1&key2=value2����ƴ�ӳ��ַ�string1��
  // jsapi_ticket=sM4AOVdWfPE4DxkXGEs8VMCPGGVi4C3VM0P37wVUCFvkVAy_90u5h9nbSlYy3-Sl-HhTdfl2fzFy1AOcHKP7qg&noncestr=Wm3WZYTPz0wzccnW&timestamp=1414587457&url=http://mp.weixin.qq.com?params=value
  // ����2. ��string1����sha1ǩ��õ�signature��
  // 0f9de62fce790f9a083d5c99e95740ceb90c27ed
  public WXConfig(HttpServletRequest request, String url) {

    System.out.println("WXConfig()");

    System.out.println(request.getScheme());
    String WebUrl = request.getScheme()+"://" + request.getServerName(); // 服务器地址
//    if (request.getServerPort() != 80) {
//      WebUrl = WebUrl + ":" + request.getServerPort(); // 端口号
//    }

    WebUrl = WebUrl + request.getContextPath() + url;

     System.out.println("WebUrl:"+WebUrl);

    appId = GlobalVariable.AppID;
    timestamp = "" + new Date().getTime();

    nonceStr = GlobalVariable.GUIDString();

    sha1 = "jsapi_ticket=" + GlobalVariable.GetJsapi_ticket() + "&noncestr=" + nonceStr + "&timestamp=" + timestamp
        + "&url=" + WebUrl;

    // System.out.println("sha1:"+sha1);
    signature = DigestUtils.shaHex(sha1);

  }

}
