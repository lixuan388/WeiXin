function GetParentBody(w)
{
	if (w!=w.parent)
	{
		return GetParentBody(w.parent)
	}
	else
	{
		return $("body",w.document);
	}
}

function alertLayer(Test,DoAfter)
{
	layer.confirm(Test, {
	  btn: ['确认'] //按钮
	}, function(index, layero){
		//console.log(f);
		layer.close(index);
		if (DoAfter){
			DoAfter();
		}
	});
}

function confirmLayer(Test,DoYes,DoNo)
{
	layer.confirm(Test, {
	  btn: ['是','否'] //按钮
	}, function(index, layero){
		layer.close(index);
		if (DoYes){
			DoYes();
		}
	}, function(index, layero){
		layer.close(index);
		if (DoNo){
			DoNo();
		}
	});
}

function OpenWindowLayer(title,url,DoAfter)
{
	layer.open({
	  type: 2,
	  title: title,
	  shadeClose: false,
	  shade: 0.8,
	  area: ['90%', '60%'],
	  content: url,//iframe的url
	  end: function(){ 
			if (DoAfter){
				DoAfter();
			}
	  }
	}); 	
}

var AlertConfirm="<div class=\"modal \" id=\"AlertConfirm\" tabindex=\"-1\" role=\"dialog\" style=\"/*z-index:99999*/\" aria-labelledby=\"myModalLabel\">\r\n" + 
					"          <div class=\"modal-dialog\" role=\"document\" style=\"max-width: 360px;margin-left: auto;margin-right: auto;margin-top: 100px;\">\r\n" + 
					"            <div class=\"modal-content\">\r\n" + 
					"\r\n" + 
					"              <div class=\"modal-body\" style=\"min-height: 50px\" >\r\n" + 
					"                <span class=\"AlertConfirmText\"></span>\r\n" + 
					"              </div>\r\n" + 
					"              <div class=\"modal-footer\" style=\"padding: 5px;\">\r\n" + 
					"                <button type=\"button\" class=\"btn btn-default\"  data-dismiss=\"modal\">确定</button>\r\n" + 
					"              </div>\r\n" + 
					"            </div>\r\n" + 
					"          </div>\r\n" + 
					"        </div>  "


function alert(Text)
{
	var AlertConfirmTemp=$(AlertConfirm).clone();

	
	$("body").append(AlertConfirmTemp);

	$(AlertConfirmTemp).find(".AlertConfirmText").html(Text);

	$(AlertConfirmTemp).modal("show");
	var height=$(AlertConfirmTemp).find(".modal-dialog").off().height()*1;
	var Wheight=window.innerHeight;
	var h=(Wheight-height)/2;
	if (h<0)
	{
		h=0;
	}
//	console.log(height);
//	console.log(Wheight);
//	console.log(h);

	$(AlertConfirmTemp).find(".modal-dialog").css("margin-top",""+(h)+"px")
	$(AlertConfirmTemp).on('hidden.bs.modal', function (e) {
		$(AlertConfirmTemp).remove();
		//console.log(AlertConfirmTemp);
		//console.log('hidden.bs.modal');
	})
		
	
//	if ($("#AlertConfirm").length==0)
//	{
//		$("body").append(AlertConfirm);
//	}
//	$("#AlertConfirm .AlertConfirmText").html(Text);
//
//	$("#AlertConfirm").modal("show");
//	var height=$("#AlertConfirm>.modal-dialog").off().height()*1;
//	var Wheight=window.innerHeight;
//	var h=(Wheight-height)/2;
//	if (h<0)
//	{
//		h=0;
//	}
////	console.log(height);
////	console.log(Wheight);
////	console.log(h);
//
//	$("#AlertConfirm>.modal-dialog").css("margin-top",""+(h)+"px")
//	$('#AlertConfirm').on('hidden.bs.modal', function (e) {
//		$("#AlertConfirm").remove();
//	})
}


function OpenWindows(href,title,onClose,width,height)
{

	var ModalWidth=width==undefined?"calc( 100% - 60px)":width;
	var ModalHeight=height==undefined?"calc( 100% - 60px)":height;
		//console.log("width:"+width);
		//console.log("ModalWidth:"+ModalWidth);
		var modalID=Math.round(Math.random()*10000000);
		var OpenModal=$("	<div id=\"ModalID"+modalID+"\" class=\"modal\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"myModalLabel\" style=\"background-color: #ccccccb3;\"> \r\n" + 
				"		<div class=\"modal-dialog\" role=\"document\" style=\"width: "+ModalWidth+";height:"+ModalHeight+";margin-left: auto;margin-right: auto;margin-top: 30px;\">\r\n" + 
				"			<div class=\"modal-content\" style=\"width: 100%;height:100%;\">\r\n" + 
				"				<div class=\"modal-header\">\r\n" + 
				"					<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>\r\n" + 
				"					<h4 class=\"modal-title\">"+title+"</h4>\r\n" + 
				"				</div>\r\n" + 
				"				<div class=\"modal-body\" style=\"width:100%;height:calc(100% - 60px);overflow: hidden;padding: 0px;\">\r\n" + 
				"					<iframe  name=\"ModalID"+modalID+"\" src=\""+href+"\" scrolling=\"auto\" frameborder=\"0\" width=\"100%\" height=\"100%\" ></iframe>\r\n" + 
				"				</div>\r\n" + 
				"			</div> \r\n" + 
				"		</div> \r\n" + 
				"	</div>");
//		$(OpenModal).find("iframe").attr("src",href)
		$(OpenModal).on('hidden.bs.modal', function (e) {
		  //console.log(e);
		  $(OpenModal).remove();
		  if (onClose){onClose();}
//			if (onClose)
//			{
//			}
		}).on('shown.bs.modal', function (e) {
		  //console.log(e);
			var iframe = iframe=OpenModal.find("iframe");
			console.log(iframe);
				iframe[0].onload= function(){
					console.log("Local iframe is now loaded.");
					$($(iframe[0]).contents()).find("body").append("<input type=\"hidden\" OpenWindowsModuleID=\"ModalID"+modalID+"\">");
				};
				iframe[0].onclose=function(){
					console.log("onclose.");
					OpenModal.modal("hide");
				}		
//			var iframe=OpenModal.find("iframe");
//			
//			$($(iframe).contents()).find("body").data("frame","22123123");
//			console.log($($(iframe).contents()).find("body"));
		})
		.modal({
			keyboard: false,
			backdrop:false
		})
		.modal("show");
		return OpenModal.find("iframe");

}

function loadingToast(text,onClose)
{
	var content=text?text:"数据加载中"
	var loading=$('<div id="loadingToast" style=" display: none;">'+
									'<div class="weui-mask_transparent"></div>'+
									'<div class="weui-toast">'+
										'<i class="weui-loading weui-icon_toast"></i>'+
										'<p class="weui-toast__content">'+content+'</p>'+
									'</div>'+
								'</div>');
	var Body=GetParentBody(window.parent);
	$(Body).append(loading);
	$(loading).on('hidden.bs.modal', function (e) {
	  //console.log(e);
	  $(loading).remove();
	  if (onClose){onClose();}
	})
	.modal({
		keyboard: false,
		backdrop:false
	})
	.modal("show");
	return loading;
}
