// JavaScript Document for Web Browser update
function setCookie( name, value, expirehours ) { 
 var todayDate = new Date(); 
 todayDate.setHours( todayDate.getHours() + expirehours ); 
 document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
}
function closeWin() { 
 setCookie( "browser_update_cookie", "done" , 168 ); 
 document.getElementById('browser_update').style.display = "none";
}
function xcloseWin() {  
 document.getElementById('browser_update').style.display = "none";
}
document.write (' \
<div id="browser_update" style="position:absolute; top:240px; left:50%; margin-left:-200px; width:400px; height:360px; z-index:9999;"> <img src="/img/browser_update.jpg" border="0" usemap="#browser_update_map">\
  <map name="browser_update_map">\
    <area shape="rect" coords="162,228,238,312" href="http://windows.microsoft.com/ie" target="_blank" title="Microsoft Internet Explorer �ٿ�ε�">\
  <area shape="rect" coords="347,325,390,350" href="javascript:closeWin();">\
  <area shape="rect" coords="369,9,390,31" href="javascript:xcloseWin();">\
  </map>\
  <div style="position:absolute; top:219; left:225; width:10px; height:10px; display:none;">\
    <form name="notice_form">\
      <input type="checkbox" name="chkbox" value="checkbox" onclick="javascript:closeWin();">\
    </form>\
  </div>\
</div>\
');
var _browser=navigator.appName;
cookiedata = document.cookie;
if (navigator.appVersion.indexOf("MSIE") != -1) {
	var _version=parseFloat(navigator.appVersion.split("MSIE")[1]);

//	if ( cookiedata.indexOf("browser_update_cookie=done") < 0 ) {
//		document.getElementById('browser_update').style.display = "none";
	if ( (cookiedata.indexOf("browser_update_cookie=done") < 0) &&
			((_browser=="Microsoft Internet Explorer" && _version <= 7)
			|| (navigator.userAgent.indexOf("NT 6.") != -1 && _version <= 8)) ){
		document.getElementById('browser_update').style.display = "block";
	} else {
		document.getElementById('browser_update').style.display = "none"; 
	}
} else {
	document.getElementById('browser_update').style.display = "none";
}