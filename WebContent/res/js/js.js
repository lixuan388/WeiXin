
$(function ()
		{		
	        $('a.weui-tabbar__item').on('click', function(){
	        		$('#loadingToast').show();					
	        });
		});		
//ios网页返回，不会刷新的问题
$(function () {
	var isPageHide = false; 
	window.addEventListener('pageshow', function () { 
		if (isPageHide) { 
			window.location.reload(); 
		}
	}); 
	window.addEventListener('pagehide', function () { 
		isPageHide = true; 
	}); 
})