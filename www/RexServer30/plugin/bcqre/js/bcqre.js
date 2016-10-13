if (navigator.userAgent.toLowerCase().indexOf("msie") > -1) {
	document.write("<OBJECT ID='InstallBCQRE' width='5' height='5' CLASSID='CLSID:D29817D1-3DC7-439B-9ED5-D836C6DDBBF0'' CODEBASE='/RexServer30/plugin/bcqre/cab/BCQREConRX.cab#version=1,0,0,1'></OBJECT>");
} else {
	navigator.plugins.refresh(false);
	if(!navigator.mimeTypes["application/bcqure......_fps_rp_plugin/version=1,0,0,1"]) {
		window.location = "/RexServer30/plugin/bcqre/download/Install_Page.html";
	} else {
		
	}
}