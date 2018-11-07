<%@page import="com.java.sql.table.MySQLTable"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
  response.setHeader("Pragma","No-cache");  
  response.setHeader("Cache-Control","no-cache");  
  response.setDateHeader("Expires", 0);  
%>
    
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
  <jsp:include page="/head.jsp"/>
  
<meta charset="UTF-8">
<title>赠券信息设置</title>
</head>
<body>


<jsp:include page="/res/temple/TabbarMenuBegin.jsp"/>
    <div class="weui-cells__title"><p>赠券信息设置</p></div> 
    <div id ="container" class="container"></div>
    <div id ="insertBtn">
      <a class="weui-btn weui-btn_warn" href="javascript:void(0);"onclick="InsertData()" >新增赠券</a>
    </div>
            
      <div id="Template" style="display: none;" class="Template">
        <div class="weui-form-preview">
              <div class="weui-form-preview__hd">
                  <div class="weui-form-preview__item">
                      <label class="weui-form-preview__label">赠券名称（对外显示）</label>
                      <input class="weui-input" placeholder="请输入赠券名称" type="text" style="background-color: #f8f8f8;"  id="Item_Name">
                  </div>
                  <div class="weui-form-preview__item">
                      <label class="weui-form-preview__label">赠券简称（内部显示）</label>
                      <input class="weui-input" placeholder="请输入赠券名称" type="text" style="background-color: #f8f8f8;"  id="Item_ShtName">
                  </div>
                  <div class="weui-form-preview__item">
                      <label class="weui-form-preview__label">有效天数</label>
                      <input class="weui-input" placeholder="请输入有效天数" type="number" style="background-color: #f8f8f8;"  id="Item_TimeValidity">
                  </div>
                  <div class="weui-form-preview__item">
                      <label class="weui-form-preview__label">赠券数量</label>
                      <input class="weui-input" placeholder="请输入赠券数量" type="number" style="background-color: #f8f8f8;"  id="Item_TicketCount">
                  </div>
                  <div class="weui-form-preview__item">
                      <label class="weui-form-preview__label">赠券说明</label>
                      <textarea class="weui-textarea" placeholder="请输入赠券说明" rows="2" style="background-color: #f8f8f8;color: black;" id="Item_Remark"></textarea>
                  </div>
                  <div class="weui-form-preview__item">
                      <label class="weui-form-preview__label">启用</label>
                      <label for="switchCP" class="weui-form-preview__value" style="margin-top: 10px;">
                          <input id="Item_Useflag" checked="checked" type="checkbox">                        
                      </label>
                  </div>
              </div>
              <div class="weui-form-preview__ft">
                  <a class="weui-form-preview__btn weui-form-preview__btn_primary saveBtn" href="javascript:void(0);">确认修改</a>
              </div>
          </div>
      </div>
      

  
<jsp:include page="/res/temple/TabbarMenuEnd.jsp"/>
    <script type="text/javascript">     
      $(function(){    
    
        var data=[
          <% 
          MySQLTable CouponsTable=new MySQLTable("select * from ac_Coupons where _Status<>'D' order by ac_Name");
          try
          {
            CouponsTable.Open();
            while (CouponsTable.next())
            {
              %>{"id":"<%=CouponsTable.getString("ac_id")%>","Name":"<%=CouponsTable.getString("ac_Name")%>","ShtName":"<%=CouponsTable.getString("ac_ShtName")%>","TimeValidity":"<%=CouponsTable.getString("ac_TimeValidity")%>",
              "Useflag":"<%=CouponsTable.getInt("ac_flag")%>","Remark":"<%=CouponsTable.getString("ac_Remark")%>","TicketCount":"<%=CouponsTable.getString("ac_TicketCount")%>"},
              <%
            }
          }
          finally
          {
            CouponsTable.Close();
          }
      %>
        ]
        $("#container").html("");
      for (i =0;i<data.length;i++)
      {
        var Template=$("#Template").clone();
        $(Template).attr("style","");
        $(Template).attr("id","Template"+data[i].id);
        $(Template).find("#Item_Name").val(data[i].Name);
        $(Template).find("#Item_ShtName").val(data[i].ShtName);
        $(Template).find("#Item_Remark").val(data[i].Remark);
        $(Template).find("#Item_TimeValidity").val(data[i].TimeValidity);
        $(Template).find("#Item_TicketCount").val(data[i].TicketCount);
        $(Template).find("#Item_Useflag").get(0).checked=data[i].Useflag=="1";
        $(Template).find(".saveBtn").attr("keyID",data[i].id);

        $(Template).find(".saveBtn").on("click", function(){
          SaveData($(this).attr("KeyID"));
          });

        $("#container").append($(Template));
      }   
        
      });     

      function SaveData(keyID)
      {
        var Template=$("#Template"+keyID)
        var id=$(Template).attr("id");
        var Name=$(Template).find("#Item_Name").val();
        var ShtName=$(Template).find("#Item_ShtName").val();
        var Remark=$(Template).find("#Item_Remark").val();
        var TimeValidity=$(Template).find("#Item_TimeValidity").val();
        var TicketCount=$(Template).find("#Item_TicketCount").val();
        var Useflag=$(Template).find("#Item_Useflag").get(0).checked;
        var JsonData={"DataRows":[{"Name":Name,"ShtName":ShtName,"id":keyID,"Remark":Remark,"Useflag":Useflag,"TimeValidity":TimeValidity,"TicketCount":TicketCount}]};
        //console.log(JsonData);
        
        $.ajax({
              url:"<%=request.getContextPath()%>/Coupons/PostCouponsInfo",
              type:'POST',
              data:  JSON.stringify(JsonData),
              dataType:'Json',
              success:function(data){
                if (data.MsgID!=1)
                {
                  weui.alert(data.MsgText);
                }
                else
                {
                  window.location.reload();
                }               
              }
        }); 
      }
      
      function InsertData()
      {
        var Template=$("#Template").clone();
        $(Template).attr("style","");
        $(Template).attr("id","Template-1");     
        
        $(Template).find("#Item_Name").val("新赠券");
        $(Template).find("#Item_Remark").val("");
        $(Template).find("#Item_TimeValidity").val("365");
        $(Template).find("#Item_Useflag").get(0).checked=true;
        $(Template).find(".saveBtn").attr("keyID",-1);
        $(Template).find(".saveBtn").on("click", function(){
          SaveData($(this).attr("KeyID"));
        });
      
        $("#container").append($(Template));  
        $("#insertBtn").html("");
      }
    </script>
  

</body>
</html>