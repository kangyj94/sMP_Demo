if (navigator.userAgent.toLowerCase().indexOf("msie") > -1) {
	document.write("<OBJECT ID='MAWS_CUSTRP' width='5' height='5' CLASSID='CLSID:642649BF-EC80-4E1D-A99C-BB1CEE620A72' CODEBASE='/RexServer30/plugin/markany/cab/MAOnFPS_CUSTRP.cab#version=2,5,0,1'></OBJECT>");
} else {
	navigator.plugins.refresh(false);
	if(!navigator.mimeTypes["application/markany_fps_rp_plugin/version=1,0,0,1"]) {
		window.location = "/RexServer30/plugin/markany/download/Install_Page.html";
	} else {
		
	}
}