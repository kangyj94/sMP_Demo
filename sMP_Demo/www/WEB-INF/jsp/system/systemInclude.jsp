<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=Constances.SYSTEM_SERVICE_TITLE %></title>
<%-- <link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/redmond/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" media="screen" /> --%>
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/smoothness/jquery-ui.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/hmro_green_tree.css" rel=StyleSheet />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/button.css" rel="stylesheet" type="text/css" media="screen" />

<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/bootstrap.custom.min.css" />
<%-- <link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/bootstrap.min.css" /> --%>
<%-- <link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/assets/css/bootstrap.min.css" /> --%>
<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/font-awesome-4.5.0/css/font-awesome.min.css" />
<%-- <link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/ace/ace.min.css" id="main-ace-style" /> --%>

<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script>

<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script> --%>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.layout.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/i18n/grid.locale-kr.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.alphanumeric.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/Validation.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.ui.datepicker-ko.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.formatCurrency-1.4.0.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.maskedinput-1.3.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jshashtable-2.1.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.blockUI.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/custom.common.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jqgrid.common.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.money.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.number.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/typehead.js" type="text/javascript"></script>

<script type="text/javascript">
	var gridWidthResizePlus = 30;	//트리구조메뉴 리사이징시 width값 조정 변수
	var gridHeightResizePlus = 30;	//트리구조메뉴 리사이징시 height값 조정 변수

	$(document).ready(function() {
		$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
	});

</script>

<%	//----------------------------------------팝업 공지관련------------------------------------------
	@SuppressWarnings("unchecked")
	List<BoardDto> popup_list = (List<BoardDto>) request.getAttribute("popup_list");
%>

<%	if(popup_list!=null && popup_list.size()>0) { %>
<!-- 공지사항 팝업 -->
<script type="text/javascript">
_defaultPageOpenPopup();
function _defaultPageOpenPopup(){
<%
		int _left = 100;
		int _top = 100;
		String _board_Type = "0101";
		for(BoardDto popBoardDto : popup_list) {
			String _board_No = popBoardDto.getBoard_No();
%>
	var noticeCookie = _getCookie("frm_<%=_board_No%>");
	if(noticeCookie != <%=_board_No%>){
			var popurl = "/board/noticePop.sys?board_No=<%=_board_No%>&board_Type=<%=_board_Type%>";
			window.open(popurl, "pop_<%=_board_No%>", "left=<%=_left%>,top=<%=_top%>,width=630,height=550,history=no,resizable=yes,status=no,scrollbars=no,menubar=no");
	}
<%
			_left += 400;
			if(_left>1000) {
				_top += 400;
				_left = 100;
			}
		}
%>
}

// function setLocation() {
// 	if (window.open) {
// 		window.moveTo(0,0);
// 		window.outerLeft = screen.availLeft;
// 		window.outerTop = screen.availTop;
// 	}  
// 	left=screen.left;
// 	top=screen.top;
<%-- 	window.open(popurl,  "pop_<%=_board_No%>", "left="+left+",top ="+top+",width=630,height=510,history=no,resizable=no,status=no,scrollbars=yes,menubar=no"); --%>
// }

function _getCookie(name){                                                                                  
   	var  nameOfCookie = name+'=';                                                                              
   	var	 x=0;                                                                                                  
   	while ( x <= document.cookie.length ) {                                                                                                          
   		var y=(x+nameOfCookie.length);                                                                                                                                                                                                               
   		if ( document.cookie.substring(x,y)==nameOfCookie) {                                                                                                           
   			if (( endOfCookie=document.cookie.indexOf(';', y ))==-1 )                                                   
  				endOfCookie=document.cookie.length; 
  			return unescape( document.cookie.substring(y, endOfCookie) );                                               
   		}                                                                                                           
   		x = document.cookie.indexOf('', x )+1 ;                                                                     
   		if ( x == 0 ) 
   		break;                                                                                        
  	}                                                                                                         
  	return ''; 
}; 

</script>
<%	}	%>

<script type="text/javascript">
function commodityContractLink(contractVersion, cookie, borgType) {
	var contractForm = $("#contractForm");
	with(contractForm){
		$("#contractVersion").val(contractVersion);
		$("#contractCookie").val(cookie);
		$("#contractClassify").val(borgType);
		attr("action","/system/basicContractView.sys");
		submit();
	}
	
}
</script>
<!-- <form id="contractForm" name="contractForm" method="POST" action=""> -->
<!-- 	<input type="hidden" id="contractVersion" name ="contractVersion" value=""> -->
<!-- 	<input type="hidden" id="contractCookie" name ="contractCookie" value=""> -->
<!-- 	<input type="hidden" id="contractClassify" name ="contractClassify" value=""> -->
<!-- </form> -->
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>