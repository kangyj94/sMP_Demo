<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>

<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta charset="utf-8" />
<title><%=Constances.SYSTEM_SERVICE_TITLE%></title>
<meta name="description" content="top menu &amp; navigation" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/smoothness/jquery-ui.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/button.css" rel="stylesheet" type="text/css" media="screen" />
<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/bootstrap.custom.min.css" />
<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/font-awesome-4.5.0/css/font-awesome.min.css" />
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Global.css">
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Default.css">

<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script>
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
<%
	//----------------------------------------팝업 공지관련------------------------------------------
	@SuppressWarnings("unchecked")
	List<BoardDto> popup_list = (List<BoardDto>) request.getAttribute("popup_list");
%>
<script type="text/javascript">
var gridHeightResizePlus = 30;	//트리구조메뉴 리사이징시 height값 조정 변수

$(document).ready(function() {
	_defaultPageOpenPopup();	
});

function _defaultPageOpenPopup(){
<%
	if(popup_list!=null && popup_list.size()>0) {
		int    _left       = 100;
		int    _top        = 100;
		String _board_Type = "0101";
		
		for(BoardDto popBoardDto : popup_list) {
			String _board_No = popBoardDto.getBoard_No();
%>
	var noticeCookie = _getCookie("frm_<%=_board_No%>");
	
	if(noticeCookie != <%=_board_No%>){
		var popurl = "/board/noticePop.sys";
		var param  = "board_No=<%=_board_No%>";
		
		param = param + "&board_Type=<%=_board_Type%>";
		
		window.open("", "pop_<%=_board_No%>", "left=<%=_left%>,top=<%=_top%>,width=630,height=550,history=no,resizable=yes,status=no,scrollbars=no,menubar=no");
		
		fnDynamicForm(popurl, param, "pop_<%=_board_No%>");
	}
<%
			_left += 400;
			
			if(_left>1000) {
				_top += 400;
				_left = 100;
			}
		}
	}
%>
}

function _getCookie(name){                                                                                  
   	var  nameOfCookie = name+'=';                                                                              
   	var	 x            = 0;
   	
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

//jqgrid pager icon setting
function FnUpdatePagerIcons(table) {
	var replacement = 
	{
		'ui-icon-seek-first' : 'ace-icon fa fa-angle-double-left bigger-140',
		'ui-icon-seek-prev' : 'ace-icon fa fa-angle-left bigger-140',
		'ui-icon-seek-next' : 'ace-icon fa fa-angle-right bigger-140',
		'ui-icon-seek-end' : 'ace-icon fa fa-angle-double-right bigger-140'
	};
	$('.ui-pg-table:not(.navtable) > tbody > tr > .ui-pg-button > .ui-icon').each(function(){
		var icon = $(this);
		var $class = $.trim(icon.attr('class').replace('ui-icon', ''));
		
		if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
	})
}
</script>