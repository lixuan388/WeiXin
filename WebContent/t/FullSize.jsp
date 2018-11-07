<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.java.web.weixin.jssdk.WXUserInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	<jsp:include page="/head.jsp"/>
	
    <link rel="stylesheet" href="/dist/example/example.css"/>
    
	
</head>
<body style="">
<div class="TabbarPage">    
    <div>
    	<div class="weui-cells__title"><p>时间段人数设置</p></div>   
    </div>
    <div class="weui-cells">
            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">项目</label>
                </div>
                <div class="weui-cell__bd">
        
        
    	
                    <select class="weui-select" id="selectMP">
					 	
						<option value="1">中医
						</option>
						 	
						<option value="2">美容预约
						</option>
						 	
						<option value="3">美容闲时预约（免费）
						</option>
						
					</select>
					
                </div>
            </div>
			
            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">星期</label>
                </div>
                <div class="weui-cell__bd">
                 <select class="weui-select" id="selectWeek">
                  
                 		<option value="0">星期日</option>
                 		
                 		<option value="1">星期一</option>
                 		
                 		<option value="2">星期二</option>
                 		
                 		<option value="3">星期三</option>
                 		
                 		<option value="4">星期四</option>
                 		
                 		<option value="5">星期五</option>
                 		
                 		<option value="6">星期六</option>
                 		
						
					</select>
                </div>
            </div>
			
            
            <div class="weui-form-preview__ft">
                <a class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:doloaddate();">查询</a>
            </div>
    </div>
    


<div class="weui-cells" style="height: 100%">
	<div style="overflow: auto;position: absolute;top: 0;bottom: 0;right: 0;left: 0;padding-bottom: 270px;box-sizing: border-box;">
	<div class="weui-cell timenumber" id="timenumber146" style="" keyid="146" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">09:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber147" style="" keyid="147" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">09:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber148" style="" keyid="148" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">10:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber149" style="" keyid="149" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">10:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber150" style="" keyid="150" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">11:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber151" style="" keyid="151" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">11:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber152" style="" keyid="152" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">12:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber153" style="" keyid="153" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">12:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber154" style="" keyid="154" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">13:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber155" style="" keyid="155" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">13:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber156" style="" keyid="156" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">14:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber157" style="" keyid="157" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">14:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber158" style="" keyid="158" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">15:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber159" style="" keyid="159" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">15:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber160" style="" keyid="160" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">16:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber161" style="" keyid="161" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">16:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber162" style="" keyid="162" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">17:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber163" style="" keyid="163" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">17:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber164" style="" keyid="164" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">18:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber165" style="" keyid="165" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">18:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber166" style="" keyid="166" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">19:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber167" style="" keyid="167" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">19:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber168" style="" keyid="168" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">20:00:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div><div class="weui-cell timenumber" id="timenumber169" style="" keyid="169" mp="1" week="0">
        <div class="weui-cell__hd"><label for="" class="weui-label " id="timelabel">20:30:00</label></div>
        <div class="weui-cell__bd">
            <input class="weui-input " value="" placeholder="" type="number" id="inputnumber">
        </div>
    </div></div>
</div>    

    



<div class="weui-tabbar">
	<div class="" >
		<a class="weui-btn weui-btn_warn" href="javascript:SaveData();" style="width: 100%;">保存</a>
	</div>
</div>


</div>    
</body>
</html>