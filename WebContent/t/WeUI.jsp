<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/head.jsp" />
</head>
<body>
<button onclick="SaveCoupons()">SaveCoupons</button>
<button onclick="confirm2()">confirm2</button>
<button onclick="SaveCoupons2()">SaveCoupons2</button>
<script type="text/javascript">
function SaveCoupons()
{

    var Str="是否确认<br>发放赠券【<span style='color:blue'></span>】一张?";
    
    var confirm=weui.confirm(Str, function (){
      console.log('confirm1');
      

      console.log('confirm11');
      confirm.hide(function(){

        console.log('confirm111');
        weui.alert('赠券发放成功！', {
          title: '赠券',
          buttons: [{
              label: '确认',
              type: 'primary',
              onClick: function(){ 
                console.log('confirm112');
              }
          }]
        });
      })
    }, function (){

      console.log('confirm2');
    });
    
}

function SaveCoupons2()
{

    var Str="是否确认<br>发放赠券【<span style='color:blue'></span>】一张?";
    
    var confirm=weui.confirm(Str, function (){
      console.log('confirm1');
      

      console.log('confirm11');
      confirm.hide();

        weui.alert('赠券发放成功！', {
          title: '赠券',
          buttons: [{
              label: '确认',
              type: 'primary',
              onClick: function(){ 
                console.log('confirm112');
              }
          }]
        });
    }, function (){

      console.log('confirm2');
    });
    
}

function confirm2(){
  var cc = weui.confirm(confirm, {
    buttons: [{
    label: '取消',
    type: 'default',
    onClick: null
    }, {
    label: '确定',
    type: 'primary',
    onClick: function () {
    cc.hide(function () {
    weui.alert("这样可以弹");
    });
    }
    }]
    });
}
</script>

</body>
</html>