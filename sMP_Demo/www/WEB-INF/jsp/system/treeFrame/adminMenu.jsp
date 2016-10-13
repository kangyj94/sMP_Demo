<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginMenuDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.BorgDto" %>

<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	List<BorgDto> belongBorgList = loginUserDto.getBelongBorgList();	//소속조직리스트
	String headerReturnMenuId = request.getParameter("_menuId")==null ? "" : (String)request.getParameter("_menuId");
	if("".equals(headerReturnMenuId)) headerReturnMenuId = request.getAttribute("_menuId")==null ? "" : (String)request.getAttribute("_menuId");
	String headerReturnBigMenuId = "";
	
	List<LoginMenuDto> bigMenuList = loginUserDto.getBigMenuList();
	boolean headerIsBreak = false;
	if(!"".equals(headerReturnMenuId)) {
		for(LoginMenuDto bigMenuDto : bigMenuList) {
			if("0".equals(headerReturnMenuId)) {
				headerReturnBigMenuId = "0";
				break;
			}
			if(headerReturnMenuId.equals(bigMenuDto.getMenuId())) {
				headerReturnBigMenuId = bigMenuDto.getMenuId();
				break;
			}
			List<LoginMenuDto> subMiddleMenuList = bigMenuDto.getSubMenuList();
			for(LoginMenuDto middleMenuDto : subMiddleMenuList) {
				if(headerReturnMenuId.equals(middleMenuDto.getMenuId())) {
					headerReturnBigMenuId = bigMenuDto.getMenuId();
					headerIsBreak = true;
					break;
				}
				List<LoginMenuDto> subSmallMenuList = middleMenuDto.getSubMenuList();
				for(LoginMenuDto smallMenuDto : subSmallMenuList) {
					if(headerReturnMenuId.equals(smallMenuDto.getMenuId())) {
						headerReturnBigMenuId = bigMenuDto.getMenuId();
						headerIsBreak = true;
						break;
					}
				}
				if(headerIsBreak) break;
			}
			if(headerIsBreak) break;
		}
	}
	String headerLoginId = loginUserDto.getLoginId();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<meta charset="utf-8" />
	<title><%=Constances.SYSTEM_SERVICE_TITLE%></title>
	<meta name="description" content="top menu &amp; navigation" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
	
	<!-- bootstrap & fontawesome -->
<%-- 	<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/bootstrap.min.css" /> --%>
<%-- 	<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/assets/css/bootstrap.min.css" /> --%>
	<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/font-awesome-4.2.0/css/font-awesome.min.css" />
	
	<!-- text fonts -->
	<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Global.css">
	<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Default.css">

	<!-- ace styles -->
	<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/assets/css/ace.custom.min.css" id="main-ace-style" />

	<!--[if lte IE 9]>
		<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/assets/css/ace-part2.min.css" />
	<![endif]-->
	<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/assets/css/ace-skins.custom.min.css" />
	<link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/assets/css/ace-rtl.min.css" />

	<!--[if lte IE 9]>
	  <link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/assets/css/ace-ie.min.css" />
	<![endif]-->

	<!-- inline styles related to this page -->

	<!-- ace settings handler -->
	<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/assets/js/ace-extra.min.js"></script>

	<!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->
	<!--[if lte IE 8]>
	<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/assets/js/html5shiv.min.js"></script>
	<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/assets/js/respond.min.js"></script>
	<![endif]-->
</head>
<style>
#navbar #search {
    position: absolute !important;
    left: 340px !important;
    top: 8px !important;
    width: 400px !important;
    height: 35px !important;
/*     background: #696969 !important; */
    border: solid 2px #ea0001 !important;
    text-align: right !important;
}
.searchTxt {
    color: #ea0001 !important;
    font-weight: bold !important;
    vertical-align: middle !important;
    font-family: Nanum Gothic;
    line-height:1.5;
    font-size: 13px;
}
#srcProductInput {
    line-height: 1 !important;
/*     height: 12px !important; */
    padding: 3px 3px 4px 3px !important;
    border: 0px solid #ddd !important;
    border-radius: 0 !important;
    -webkit-appearance: none !important;
    background: #fff !important;
    font-family: 'Nanum Gothic' !important;
    font-size: 12px !important;
    color: #4d4d4d !important;
    outline: none !important;
    width: 275px;
}

</style>

<body class="skin-2">
<!-- <div id="navbar" class="navbar navbar-default navbar-collapse" style="margin-top: 20px;"> -->
<!-- <div class="space-10"></div> -->
<table><tr><td height="10px"></td></tr></table>
<div id="navbar" class="navbar navbar-default navbar-collapse">
	<div class="navbar-container" id="navbar-container" style="padding-top:10px;padding-bottom:2px;">
		<div class="navbar-header pull-left" style="margin-bottom: 10px;">
			<a href="/system/systemHome.sys">
<!-- 				<b><font color="#DF0223">SK</font> <font color="#F7BE81">telesys</font></b> -->
				<img src = "/img/logo_sktelesys.png" height="35">
			</a>
			<button class="pull-right navbar-toggle collapsed" type="button" data-toggle="collapse" data-target=".sidebar">
				<span class="sr-only">Toggle sidebar</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
		</div>
<%	if(!"XXXXXXXXXX".equals(headerLoginId)){ %>
		<div id="search" style="margin-top:3px;">
			<span class="searchTxt">상품검색</span>
			<input id="srcProductInput" name="srcProductInput"  type="text" placeholder="검색어를 입력하세요"  class="typeahead"  />
			<a href="javascript:fnTotSearch();">
				<img src="/img/layout/btn_search.gif" class="middle" style="vertical-align: middle;" />
			</a>
		</div>
<%	} %>
		<div class="navbar-buttons navbar-header pull-right  collapse navbar-collapse" role="navigation">
			<table style="width: 100%;height: 40px;">
				<tr>
					<td width="100%" valign="bottom" style="color: gray;">
<%	if(!"XXXXXXXXXX".equals(headerLoginId)){ %>
						<a href="/system/systemHome.sys" target="_parent" style="color: gray;font-weight: bold;">
							<i class="fa fa-home fa-lg"></i> HOME
						</a>
						&nbsp;|&nbsp;
						<a id="header_smsAgentPop" name="header_smsAgentPop" href="#" style="color: gray;font-weight: bold;">
							<i class="fa fa-mobile fa-lg"></i> SMS보내기
						</a>
						&nbsp;|&nbsp;
						<a id="header_msnPop" name="header_msnPop" href="#" style="color: gray;font-weight: bold;">
							<i class="fa fa-weixin fa-lg"></i> 채팅하기
						</a>
						&nbsp;|&nbsp;
						<a id="header_selfUserPop" name="header_selfUserPop" style="color: gray;font-weight: bold; cursor: pointer;"> 
							<b><i class="fa fa-user fa-lg"></i> <%=loginUserDto.getUserNm() %></b>
						</a>
<%	}else{ %>
							<b><i class="fa fa-user fa-lg"></i> <%=loginUserDto.getUserNm() %></b>
<%	} %>
<%	
		if(belongBorgList.size()>1) {	//소속조직이 1개이상일 경우 변경가능
%>
						&nbsp;|&nbsp;
						<select id="belongBorgIdSvcTypeCd" name="belongBorgIdSvcTypeCd">
<%
			for(BorgDto belongBorgDto:belongBorgList) {
				String selectString = (belongBorgDto.getBorgId()).equals(loginUserDto.getBorgId()) ? "selected" : "";
%>
							<option value="<%=belongBorgDto.getBorgId() %>∥<%=belongBorgDto.getSvcTypeCd() %>∥<%=CommonUtils.getString(belongBorgDto.getAdminUserId()) %>" <%=selectString %>>
							<%=belongBorgDto.getBorgNm() %>
							</option>
<%			} %>
						</select>
<%	
		}	
%>
						&nbsp;|&nbsp;
						<a href="/system/systemLogout.sys" target="_parent" style="color: gray;font-weight: bold;">
							<i class="fa fa-power-off fa-lg"></i> 로그아웃
						</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
	
<div class="main-container" id="main-container">
	<div id="sidebar" class="sidebar h-sidebar navbar-collapse collapse">
		<ul class="nav nav-list">
<%
	if(!"XXXXXXXXXX".equals(headerLoginId)){	//운영자
		String headerHover = "hover";
		if("0".equals(headerReturnBigMenuId)) headerHover = "active open hover";
%>
			<li class="<%=headerHover %>">
				<a href="/system/systemHome.sys" target="_parent">
					<span class="menu-text" style="font-size: 15px;"> Dashboard
					</span>
				</a>
				<b class="arrow"></b>
			</li>
<%
		int headerLeafCnt = 0;
		String headerForwardUrl = "";
		String headerToggle = "";
		String headerArrowDown = "";
		for(LoginMenuDto bigMenuDto : bigMenuList) {
			headerHover = "hover";
			headerToggle = "";
			headerForwardUrl = "";
			headerArrowDown = "";
			if(headerReturnBigMenuId.equals(bigMenuDto.getMenuId())) {
				headerHover = "active open hover";
			}
			List<LoginMenuDto> subMiddleMenuList = bigMenuDto.getSubMenuList();
			headerLeafCnt = subMiddleMenuList.size();
			if(headerLeafCnt>0) {
				headerToggle = "class='dropdown-toggle'";
				headerArrowDown = "<b class='arrow fa fa-angle-down'></b>";
			} else {
				headerForwardUrl = bigMenuDto.getFwdPath()+"?_menuId="+bigMenuDto.getMenuId();
			}
%>
			<li class="<%=headerHover %>">
				<a href="<%=headerForwardUrl %>" <%=headerToggle %>>
					<span class="menu-text" style="font-size: 15px;"> <%=bigMenuDto.getMenuNm() %> </span>
					<%=headerArrowDown %>
				</a>
				<b class="arrow"></b>
<%			if(headerLeafCnt>0) { %>
				<ul class="submenu" style="background-color: #eaeae1;">
<%			
				for(LoginMenuDto middleMenuDto : subMiddleMenuList) {
					headerToggle = "";
					headerForwardUrl = "";
					headerArrowDown = "";
					List<LoginMenuDto> subSmallMenuList = middleMenuDto.getSubMenuList();
					headerLeafCnt = subSmallMenuList.size();
					if(headerLeafCnt>0) {
						headerToggle = "class='dropdown-toggle'";
						headerArrowDown = "<b class='arrow fa fa-angle-down'></b>";
					} else {
						headerForwardUrl = middleMenuDto.getFwdPath()+"?_menuId="+middleMenuDto.getMenuId();
					}
%>
					<li class="hover" style="background-color: white">
						<a href="<%=headerForwardUrl %>" <%=headerToggle %>>
							<span class="menu-text" style="font-weight:bold;font-size: 14px; color: #87875f"> <%=middleMenuDto.getMenuNm() %> </span>
							<%=headerArrowDown %>
						</a>
						<b class="arrow"></b>
<%					if(headerLeafCnt>0) { %>
						<ul class="submenu">
<%
						for(LoginMenuDto smallMenuDto : subSmallMenuList) {
							headerToggle = "";
							headerForwardUrl = "";
							headerArrowDown = "";
							headerLeafCnt = 0;
							if(headerLeafCnt>0) {
								headerToggle = "class='dropdown-toggle'";
								headerArrowDown = "<b class='arrow fa fa-angle-down'></b>";
							} else {
								headerForwardUrl = smallMenuDto.getFwdPath()+"?_menuId="+smallMenuDto.getMenuId();
							}
%>
							<li class="hover">
								<a href="<%=headerForwardUrl %>" <%=headerToggle %>>
									<span class="menu-text" style="font-weight:bold; font-size: 14px; color: #87875f"> <%=smallMenuDto.getMenuNm() %> </span>
									<%=headerArrowDown %>
								</a>
								<b class="arrow"></b>
							</li>
<%						} %>
						</ul>
<%					} %>
					</li>
<%				} %>
				</ul>
<%			} %>
			</li>
<%		
		}
	} else {	//비회원
%>
			<li class="hover">
				<a href="/evaluation/evaluateApplication.sys">
					<span class="menu-text"> 지정자재 신규업체 신청 </span>
				</a>
				<b class="arrow"></b>
			</li>
			<li class="hover">
				<a href="/proposal/viewProposalList.sys">
					<span class="menu-text"> 신규자재 제안하기 </span>
				</a>
				<b class="arrow"></b>
			</li>
			<li class="hover">
				<a href="/menu/board/participation/participationList.sys">
					<span class="menu-text"> 참여게시판 </span>
				</a>
				<b class="arrow"></b>
			</li>
<%	}	%>
		</ul>
		
		<div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
			<i class="ace-icon fa fa-angle-double-left" data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
			
		</div>

		<script type="text/javascript">
			try{ace.settings.check('sidebar' , 'collapsed')}catch(e){}
		</script>
	</div>
</div>
<div class="space-4"></div>

<form id="header_frm" name="header_frm" method="post">
	<input type="hidden" id="belongBorgId" name="belongBorgId"/>
	<input type="hidden" id="belongSvcTypeCd" name="belongSvcTypeCd"/>
	<input type="hidden" id="moveUserId" name="moveUserId"/>
</form>
</body>

<script type="text/javascript">
	window.jQuery || document.write("<script src='/jq/assets/js/jquery.min.js'>"+"<"+"/script>");
</script>

<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqGrid.min.js" type="text/javascript"></script> --%>
<script src="/jq/assets/js/bootstrap.min.js"></script>
<script src="/jq/assets/js/ace-elements.min.js"></script>
<script src="/jq/assets/js/ace.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	$("#admUserInfo").on("click",function(e){
		var popurl = "/system/treeFrame/admUserInfo.home";
		window.open(popurl, 'admUserInfoPop', 'width=810, height=520, scrollbars=yes, status=no, resizable=no');	
	});
	$("#header_smsAgentPop").on("click",function(e){
		var popurl = "/common/smsTransAgentPop.sys";
		window.open(popurl, 'okplazaSmsPop', 'width=980px, height=600, scrollbars=no, status=no, resizable=yes');
	});
	$("#header_msnPop").on("click",function(e){
		window.open("/webChat/moveWebChatPop.sys", "webChat", "width=320,height=475,scrollbars=no,resizable=no");
	});
	$("#belongBorgIdSvcTypeCd").on("change",function(e){
		var belongBorgId = $("#belongBorgIdSvcTypeCd").val().split("∥")[0];
		var belongSvcTypeCd = $("#belongBorgIdSvcTypeCd").val().split("∥")[1];
		var moveUserId = $("#belongBorgIdSvcTypeCd").val().split("∥")[2];
		$("#belongBorgId").val(belongBorgId);
		$("#belongSvcTypeCd").val(belongSvcTypeCd);
		$("#moveUserId").val(moveUserId);
		var frm = document.header_frm;
		frm.action = "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/belongSystemLogin.sys";
		frm.target = "_parent";
		frm.submit();
	});
	$("#header_selfUserPop").on("click",function(e){
		window.open("", 'admUserDetail', 'width=400px, height=370, scrollbars=no, status=no, resizable=yes');
		fnDynamicForm("/system/admUserDetail.sys", "","admUserDetail");
	});
	
	//chat 관련
	$('#loginDialogPop').jqm();	//loginDialog 초기화
<%	if(Constances.CHAT_ISUSE) {	%>
// 	$("#staticMenu2").show();
	setInterval(fnChatContinue,1000*<%=Constances.CHAT_LOGIN_SECOND %>);	//10초마다 한번씩 채팅 로그인(만약 시간을 고치면 체팅 로그아웃 스케줄러의 시간도 수정해야 함)
<%	}	%>
});
//채팅사용자 연속성
function fnChatContinue() {
// 	$.post(
<%-- 		"<%=Constances.SYSTEM_CONTEXT_PATH %>/webChat/chatContinue.sys",  --%>
// 		{},
// 		function(arg){
// 			var result = eval('(' + arg + ')').chatLoginDto;
// 			if(result != undefined){
// 				if(result.userId != '') {
// 					_getWebChatPop(result.userId, result.branchId, result.userNm);
// 				}
// 			}
// 		}
// 	);
	top.frames['topFrame'].fnChatContinue();
}
//채팅창 호출
function _getWebChatPop(userId, branchId, userNm) {
	var chatTarget = userId+"_"+branchId;
	var chatFrm = document.createElement("form");
	chatFrm.name="chatForm";
	chatFrm.method="post";
	chatFrm.action="<%=Constances.SYSTEM_CONTEXT_PATH %>/webChat/talkWebChatPop.sys";
	chatFrm.target=chatTarget;
	
	var userIdObj = document.createElement("input");
	userIdObj.type = "hidden";
	userIdObj.name = "userId";
	userIdObj.value = userId;
	chatFrm.insertBefore(userIdObj, null);
	
	var branchIdObj = document.createElement("input");
	branchIdObj.type = "hidden";
	branchIdObj.name = "branchId";
	branchIdObj.value = branchId;
	chatFrm.insertBefore(branchIdObj, null);
	
	var userNmObj = document.createElement("input");
	userNmObj.type = "hidden";
	userNmObj.name = "userNm";
	userNmObj.value = userNm;
	chatFrm.insertBefore(userNmObj, null);
	
	window.open("", chatTarget, "width=322,height=400,scrollbars=no,resizable=no");
	document.body.insertBefore(chatFrm, null);
	chatFrm.submit();
}
</script>
<%-------------------   상품검색 관련 이벤트   --------------------%>
<style type="text/css">
.typeahead,
.tt-query,
.tt-hint {
	width: 200px;
	height: 16px;
	padding: 1px 1px;
	line-height: 15px;
/*   border: 1px solid #ccc; */
	outline: none;
}

.typeahead {
	background-color: #fff;
}

.typeahead:focus { */
	border: 1px solid #0097cf; */
}

.tt-query {
  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
     -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
          box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
}

.tt-hint {
  color: #999
}

.tt-menu {
  background-color: #fff;
  border: 1px solid #ccc;
  border: 1px solid rgba(0, 0, 0, 0.2);
  height:400px;
  width:281px;
  z-index: 9999 !important;
}

.tt-suggestion {
  padding: 3px 20px;
  line-height: 24px;
}

.tt-suggestion:hover {
  cursor: pointer;
  color: #fff;
  background-color: #0097cf;
}

.tt-suggestion.tt-cursor {
  color: #fff;
  background-color: #0097cf;

}

.tt-suggestion p {
  margin: 0;
}
</style>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/typehead.js" type="text/javascript"></script>
<script type="text/javascript">
$(document).ready(function(){

//자동완성기능을 제거
/*
	var rtnStr = new Bloodhound({
		datumTokenizer: function (datum) {
			alert(datum.value);
			return Bloodhound.tokenizers.whitespace(datum.value);
		},
		queryTokenizer:Bloodhound.tokenizers.whitespace,
		remote: {
			url		: '/product/pdtAutoComplete.sys?srcProductInput=%param',
			wildcard: '%param',
			filter  : function(response) {
				return response.resultList; 
			}
		}
	});
	
	rtnStr.initialize();
	
	$('.typeahead').typeahead({
	  	hint: true,
	  	highlight: true,
	  	minLength: 1
	}, {
	  	name: 'rtnStr',
	  	source: rtnStr,
	  	limit: 100
	});
*/
	// 상품 검색 입력란 키 이벤트
	$("#srcProductInput").keydown(function(e){
		if(e.keyCode == 13){
			fnTotSearch(); //상품 검색 요청하는 메소드
		}
	}).css('vertical-align', 'middle');// label position
	
});
//상품 검색 요청하는 메소드
function fnTotSearch(){
	var srcProductInput       = $('#srcProductInput').val();
	var srcProductInputLength = 0; 
	
	srcProductInput       = $.trim(srcProductInput);
	srcProductInputLength = srcProductInput.length;
	
    if(srcProductInputLength == 0){
    	alert("검색어를 입력해주십시오.");
    }
    else{
    	fnDynamicForm("/product/productAdmList.sys", "_menuId=13212&inputWord=" + srcProductInput,"");
    }
}
</script>
</html>
