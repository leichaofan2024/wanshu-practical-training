

function showPlayer(obj,url) {
	var videostar='<video width="100%" height="auto" controls="controls" poster="assets/javascripts//player/play1.png" src="';
	var videoend= '"></video>';
	document.getElementById(obj).innerHTML=videostar+url+videoend;

//	var sUserAgent= navigator.userAgent.toLowerCase();
//
//	var bIsIpad= sUserAgent.match(/ipad/i) == "ipad";
//
//	var bIsIphoneOs= sUserAgent.match(/iphone os/i) == "iphone os";
//
//	var bIsMidp= sUserAgent.match(/midp/i) == "midp";
//
//	var bIsUc7= sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
//
//	var bIsUc= sUserAgent.match(/ucweb/i) == "ucweb";
//
//	var bIsAndroid= sUserAgent.match(/android/i) == "android";
//
//	var bIsCE= sUserAgent.match(/windows ce/i) == "windows ce";
//
//	var bIsWM= sUserAgent.match(/windows mobile/i) == "windows mobile";
//
//	var isWeiXin=sUserAgent.match(/MicroMessenger/i) == "micromessenger";
//
//	if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM||isWeiXin) {
//		var videostar='<video width="100%" height="auto" controls="controls" poster="js/player/play1.png" src="';
//		var videoend= '"></video>';
//		document.getElementById(obj).innerHTML=videostar+url+videoend;
//	} else {
//	   if(navigator.userAgent.indexOf("iPhone") != -1||navigator.userAgent.indexOf("iPad") != -1 ||navigator.platform.indexOf("iPhone") != -1||navigator.platform.indexOf("iPod") != -1) {
//		   var videostar='<video width="100%" height="auto" controls="controls" poster="js/player/play1.png" src="';
//			var videoend= '"></video>';
//			document.getElementById(obj).innerHTML=videostar+url+videoend;
//	   }else{
//		   if(window.applicationCache){
//			    alert('support video');
//			   var videostar='<video width="100%" height="auto" controls="controls" poster="js/player/play1.png" src="';
//				var videoend= '"></video>';
//				document.getElementById(obj).innerHTML=videostar+url+videoend;
//		   }else{
//			   alert('not support video');
//				flowplayer("player", "flowplayer.commercial-3.2.6-dev.swf");
//		   }
//	   }
//	}
}
