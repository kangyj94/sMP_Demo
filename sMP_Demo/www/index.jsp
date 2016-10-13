<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%
	/*######################## Important(사이트 첫 페이지에서 아래 3변수을 초기화)  ########################*/
	/*###########만약 framework.properties 에서 아래 3변수에 대해 초기화 되어 있으면 초기화된 변수을 읽어 들임###########*/
	if(Constances.SYSTEM_CONTEXT_PATH==null || "".equals(Constances.SYSTEM_CONTEXT_PATH))
		Constances.SYSTEM_CONTEXT_PATH = request.getContextPath();
	if(Constances.SYSTEM_IMAGE_URL==null || "".equals(Constances.SYSTEM_IMAGE_URL))
		Constances.SYSTEM_IMAGE_URL = request.getContextPath();
	if(Constances.SYSTEM_JSCSS_URL==null || "".equals(Constances.SYSTEM_JSCSS_URL))
		Constances.SYSTEM_JSCSS_URL = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<title>유앤팜스뱅크에 오신것을 환영합니다.</title>
<link href="<%=Constances.SYSTEM_JSCSS_URL%>/css/homepage_style.css" rel="stylesheet" type="text/css" />
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/cc/js/CC_Object.js" type="text/javascript"></script> --%>
<%
	if(Constances.COMMON_ISREAL_SERVER) {
%>
<%-- <%@ include file="/WEB-INF/jsp/common/auth/guestAuthDiv.jsp" %> --%>
<%@ include file="/WEB-INF/jsp/common/auth/authBusinessNumberDiv.jsp" %>
<%
	}
%>
<style type="text/css">
.jqmVendorWindow {
	display: none;
	position: fixed;
	top: 17%;
	left: 50%;
	margin-left: -350px;
	width: 650px;
	background-color: #EEE;
	color: #333;
	border: 1px solid black;
	padding: 12px;
}

.contract_contents{
	font-weight:bold;
	padding-left:20px;
	padding-right:20px;
	height:30px;
	padding-top:4px;
	border-left: solid 1px #ccc;
	border-right: solid 1px #ccc;
	border-bottom: solid 1px #ccc;
	font-size: 1.2em;
	vertical-align: middle;
}
</style>
<script type="text/javascript">
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

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

$(document).ready(function() {
	$('form').on('submit',function(){
		return false;
	});
	
	//초기 팝업 호출 Script
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/noticePopBoardMain.sys',
		function(arg){
			var boardList = eval('(' + arg + ')').boardList;
			var _board_no = "";
			
			for(var i=0;i<boardList.length;i++) {
				_board_No = boardList[i].board_No;
				
				var noticeCookie = _getCookie("frm_"+_board_No);
				
				if(noticeCookie != _board_No){
					var popurl = "/common/noticePop.sys?board_No="+_board_No;
					window.open(popurl, "pop_"+_board_No, "left=100,top=100,width=630,height=550,history=no,resizable=yes,status=no,scrollbars=no,menubar=no");
				}
			}
		}
	);
	
	$("#userTb").show();
	$("#findIdTb").show();

	$("#loginType1").click(function(){
		$("#userTb").show();
		$("#findIdTb").show();
		$("#loginType1").attr("checked", "checked");
	});	

	$("#imgLoginType1").click(function(){
		$("#userTb").show();
		$("#findIdTb").show();
		$("#loginType1").attr("checked", "checked");
	});	
	
	$("#loginType2").click(function(){
		$("#userTb").hide();
		$("#findIdTb").hide();
		$("#loginType2").attr("checked", "checked");
	});	
	
	$("#imgLoginType2").click(function(){
		$("#userTb").hide();
		$("#findIdTb").hide();
		$("#loginType2").attr("checked", "checked");
	});	
	
	$("#gotoGuestLogin").click(function(){
		$("#userTb").hide();
		$("#findIdTb").hide();
		$("#loginType2").attr("checked", "checked");
	});	
	
	$("#businessNum1").keyup(function(){
		if(($("#businessNum1").val()).length==3) {
			$("#businessNum2").focus();
		}
	});
	$("#businessNum2").keyup(function(){
		if(($("#businessNum2").val()).length==2) {
			$("#businessNum3").focus();
		}
	});
	
	$('#loginDialogPop').jqm();	//loginDialog 초기화
	
	$("#loginId").focus(); 
	$("#loginId").css("ime-mode", "disabled");
	$("#password").css("ime-mode", "disabled");
	$("#loginId").keydown(function(e){
		if(e.keyCode==13) {
			$("#password").focus();
			return false;
		}
	});
	$("#password").keydown(function(e){
		if(e.keyCode==13) {
			$("#enter").click();
		}
	});
	$("#enter").click(function(){
		fnEnterOnClick();
	});
	
	//비회원 로그인
	$("#guestEnter").click(function(){
		var bussName = $.trim($("#bussName").val());
		var businessNum = $.trim($("#businessNum1").val()) + $.trim($("#businessNum2").val()) + $.trim($("#businessNum3").val());
		var userNm = $.trim($("#bussName").val());
		if(bussName.length<=0) { alert("사업자명을 입력해 주십시오!"); $("#bussName").focus(); return; }
		if(businessNum.length!=10) { alert("사업자번호를 확인해 주십시오!"); $("#businessNum1").focus(); return; }
		$.post(
			"/system/guestCheckPop.sys", 
			{	bussName:bussName, 
				businessNum:businessNum, 
				userNm:userNm 
			},
			function(arg){
				var result = eval('(' + arg + ')').customResponse;
				if(result.success == false){
					var errors = "";
					for(var i = 0; i < result.message.length; i++) { errors += result.message[i] + "\n"; }
					
					$("#dialog").html("<font size='2'>"+errors+"</font>");
					$("#dialog").dialog({
						title: '기존업체',modal: true,
						buttons: {"Ok": function(){$(this).dialog("close");} }
					});
				} else {
					var noneFlag = result.newIdx;
					guestPassCheck(noneFlag);
				}
			}
		);
	});
	function guestPassCheck(noneFlag) {
		if(noneFlag==0) {	//신규 비회원
			$('#guestPassRegDialogPop').jqm();
			$('#guestPassRegDialogPop').jqmShow();
		} else if(noneFlag==1) {	//기존 비회원
			$('#guestPassConfirmDialogPop').jqm();	//Dialog 초기화
			$('#guestPassConfirmDialogPop').jqmShow();
		}
		
	}
	
	//사업자등록번호 체크
	function checkCompanyNumber(strNumb){
		if(strNumb.length != 10){
			alert('사업자 등록번호가 잘못되었습니다.');
			return false;
		}
		var sumMod = 0;
		sumMod += parseInt(strNumb.substring(0, 1), 10);
		sumMod += parseInt(strNumb.substring(1, 2), 10) * 3 % 10;
		sumMod += parseInt(strNumb.substring(2, 3), 10) * 7 % 10;
		sumMod += parseInt(strNumb.substring(3, 4), 10) * 1 % 10;
		sumMod += parseInt(strNumb.substring(4, 5), 10) * 3 % 10;
		sumMod += parseInt(strNumb.substring(5, 6), 10) * 7 % 10;
		sumMod += parseInt(strNumb.substring(6, 7), 10) * 1 % 10;
		sumMod += parseInt(strNumb.substring(7, 8), 10) * 3 % 10;
		sumMod += Math.floor(parseInt(strNumb.substring(8, 9), 10) * 5 / 10);
		sumMod += parseInt(strNumb.substring(8, 9), 10) * 5 % 10;
		sumMod += parseInt(strNumb.substring(9, 10), 10);
		if(sumMod % 10 != 0){
			alert('사업자등록번호가 잘못되었습니다.');
			return false;
		}
		return true;
	}
	
	$("#reqBorg").click(function(){
		var popurl = "/organ/reqBranchPop.sys";
		var popproperty = "dialogWidth:970px;dialogHeight=900px;scroll=auto;status=no;resizable=no;";
		window.open(popurl, 'okplazaPop', 'width=970, height=900, scrollbars=yes, status=no, resizable=no');
	});

	$("#reqVen").click(function(){
		var popurl = "/organ/reqVendorPop.sys";
		var popproperty = "dialogWidth:910px;dialogHeight=750px;scroll=auto;status=no;resizable=no;";
		window.open(popurl, 'okplazaPop', 'width=910, height=750, scrollbars=yes, status=no, resizable=no');
	});
	
	<%-- 구매사 계약서 팝업 초기화 --%>
	$('#popBranchContract').jqm();
	
	$("#nanumButton").click(function(){
		window.location.href = "/css/NanumFontSetup_TTF_ALL_hangeulcamp.exe";
	});
});

<%
/**
 * 회원 로그인 버튼 클릭시 호출되는 메소드
 */
%>
function fnEnterOnClick(){
	var loginId  = $("#loginId").val();
	var password = $("#password").val();
	var chk_flag = $("#chk_flag").val();
	
	loginId  = $.trim(loginId); 
	password = $.trim(password);
	chk_flag = $.trim(chk_flag);
	
	$("#loginId").val(loginId); 
	$("#password").val(password);
	$("#chk_flag").val(chk_flag);
	
	if(loginId.length==0) {
		alert("아이디를 입력해 주십시오!");
		
		$("#loginId").val(loginId);
		$("#loginId").focus();
		
		return;
	}
	
	if(password.length==0) {
		alert("패스워드를 입력해 주십시오!");
		
		$("#password").val(password);
		$("#password").focus();
		
		return;
	}
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/loginCheckPop.sys", 
		{
			loginId  : loginId,
			password : password,
			chk_flag : chk_flag
		},
		function(arg){
			loginCheckPopCallback(arg);
		}
	);
}

<%
/**
 * 회원 로그인 결과 콜백 메소드
 *
 * @param arg (Object, 로그인 결과 객체)
 */
%>
function loginCheckPopCallback(arg){
	var loginId = $("#loginId").val();
	
	if(fnTransResult(arg, false)) {
		var result = eval('(' + arg + ')').customResponse;
		var mobile = result.message[0];
		
		if(result.newIdx == 0) { <%//계약서 확인%>
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/loginContractCheck.sys", 
				{
					loginId : loginId
				},
				function(arg2){
					loginContractCheckCallback(arg2);
				}
			);
		}
		else { <%//모바일인증 화면 Display%>
			$('#loginDialogPop').jqmShow();	
			
			fnJqmAuthInit(mobile);
		} 
	}
}
<%
/**
 * 계약서 확인 콜백 메소드
 *
 * @param : arg2 (Object, 계약서 결과 확인 객체)
 */
%>
function loginContractCheckCallback(arg2){
	var result2 = eval('(' + arg2 + ')').customResponse;
	var errors2 = "";
	
	if (result2.success == false) {
		for (var i = 0; i < result2.message.length; i++) {
			errors2 +=  result2.message[i];
		}
		
		alert(result2);
	}
	else {
		if(result2.newIdx) { <%// 서명 대상 계약서 존재 %>

			fnContractToDoList(result2.newIdx);

<%-- 계약서 계약 팝업 주석처리
			fnLogin();
--%>
		}
		else { <%// 로그인 처리%>
			fnLogin();
		}
	}
}

function fnGoGuestLogin(guestFlag){
	$("#guestFlag").val(guestFlag);	//0:신규상품, 1:지정자재
	$("#initDiv").hide();
	$("#chgDiv").show();

	$("#userTb").hide();
	$("#findIdTb").hide();
	$("#loginType2").attr("checked", "checked");	
}
<%
/**
 * 로그인을 처리하는 메소드
 */
%>
function fnLogin() {
	document.frm.action = "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemLogin.sys";
	document.frm.submit();
}
<%
/**
 * 계약서 리스트를 조회하는 메소드
 *
 * @param borgId (계약서 조회대상 조직아이디)
 */
%>
function fnContractToDoList(borgId){
	$("#branchContractContents").empty();
	
	$.post(
		"/common/contractToDoList.sys",
		{
			borgId : borgId
		},
		function(arg){
			fnContractToDoListCallback(arg);
		},
		"json"
	);
}

<%
/**
 * 계약서 팝업창을 구성하는 메소드
 *
 * @param arg (Object, 계약서 리스트 조회 결과 객체)
 */ 
%>
function fnContractToDoListCallback(arg){
	var svcTypeCd	      = arg.svcTypeCd;
	var list		      = arg.list;
	var limitContractDate = arg.limitContractDate;
	var listLength	      = list.length;
	var endLength	      = 1;
	var chkBoxCnt	      = 1;
	var i                 = 0;
	var info              = null;
	var str			      = "";
	var contractNm        = null;
	var contractVersion   = null;
	var infoSvcTypeCd     = null;
	var contractSignYn    = null;
	var isOldContract     = false;
	var isOld             = null;
	var borgId            = null;
	var contractSpecial   = null;
	
	if(listLength > 0){
		$("#branchContractTitle").empty();
		//$("#branchContractTitle").append("아래의 계약 내용을 확인해 주십시오.<br/>계약 기간은 " + limitContractDate + "일까지 입니다.<br/>계약을 위해서는 공인인증서가 필요합니다.<br/>* 계약 관련 문의 (02-2090-2722)");
		$("#branchContractTitle").append("아래의 계약 내용을 확인해 주십시오.<br/>계약을 위해서는 공인인증서가 필요합니다.<br/>* 계약 관련 문의 (02-2090-2722)");
		
		for(i = 0; i < listLength; i++){
			info            = list[i];
			contractNm      = info.CONTRACT_NM;
			contractVersion = info.CONTRACT_VERSION;
			infoSvcTypeCd   = info.SVCTYPECD;
			contractSignYn  = info.CONTRACT_SIGN_YN;
			isOld           = info.IS_OLD;
			borgId          = info.BORG_ID;
			contractSpecial = info.CONTRACT_SPECIAL;
			str             = "";
			
			str += "<tr>";
			str +=	"<td class='contract_contents' colspan='2'>";
			str +=		contractNm + "&nbsp;(&nbsp;"+ contractVersion +"&nbsp;)";
			
			if(contractSignYn == 'N'){
				str +=	"&nbsp;<input type='checkbox' id='contractSignChk_" + chkBoxCnt + "' name='contractSignChk' value='" + contractVersion + "' style='margin-bottom:-4px;border:none;border-right:0px; border-top:0px; boder-left:0px; boder-bottom:0px;' onclick='javascript:fnContractSignChk();'>";
				str +=	"&nbsp;<input type='hidden'   id='contractSpecial_" + chkBoxCnt + "' value='" + contractSpecial + "'/>";
				
				chkBoxCnt++;
				
				if("Y" == isOld){
					isOldContract = true;
				}
			}
			
			str +=		"<button id='contractDetailBtn' class='btn btn-primary btn-xs' align='rigth' style='float: right;' onclick='fnPopContractDetail(\"" + infoSvcTypeCd + "\",\""+contractVersion+"\", \"" + borgId + "\");'>";
			str +=			"보기";
			str +=		"</button>";
			str +=	"</td>";
			str += "</tr>";
			
			if(listLength == endLength){
				str += "<tr>";
				str +=	"<td colspan='2' height='5px'></td>";
				str += "</tr>";
				str += "<tr>";
				str +=	"<td style='text-align: left;font-size:1.3em;padding-left:20px; padding-right:20px; height:30px; padding-top:4px;font-weight:bold;vertical-align: middle;'>";
				str +=		"모두 동의&nbsp;";
				str +=		"<input type='checkbox' id='contractSignAllChk' name='contractSignAllChk' style='margin-bottom:2px;border:none;border-right:0px; border-top:0px; boder-left:0px; boder-bottom:0px;' onclick='fnContractSignAllChk();'>";
				str +=	"</td>";
				str +=	"<td style='text-align: right;padding-left:20px; padding-right:20px; height:30px; padding-top:4px;'>";
				str +=		"<button id='vendorSignBtn' class='btn btn-danger btn-sm' onclick='fnContractSign(\"" + borgId + "\", \"" + svcTypeCd + "\")'>";
				str +=			"계약";
				str +=		"</button>";
				
				if(isOldContract == false){
					str +=	"&nbsp;&nbsp;";
					str +=	"<button id='vendorDelayBtn' class='btn btn-darkgray btn-sm' onclick='javascript:fnDelayContract(\"" + borgId + "\");'>";
					str +=		"닫기";
					str +=	"</button>";
				}
				
				str +=		"<input type=\"hidden\" id='isOldContract' value=\"" + isOldContract + "\"/>";
				str +=		"<input type=\"hidden\" id='authBorgId'    value=\"\"/>";
				str +=		"<input type=\"hidden\" id='authSvcTypeCd' value=\"\"/>";
				str +=	"</td>";
				str += "</tr>";
			}
			
			$("#branchContractContents").append(str);
			
			endLength++;
		}
	}
	
	$("#popBranchContract").jqmShow();
}

<%
/**
 * 계약서 체크 이벤트
 */
%>
function fnContractSignChk(){
	var contractSignChk = $("input[name=contractSignChk]:checkbox:checked").length;
	
	if(contractSignChk == 0){
		$("#contractSignAllChk").prop("checked", false);
	}
}

<%
/**
 * 계약서 모두동의 체크 이벤트
 */
%>
function fnContractSignAllChk(){
	var contractSignAllChk = $("#contractSignAllChk").prop("checked");
	
	if(contractSignAllChk == true){
		$("input[name=contractSignChk]").prop("checked", true);
	}
	else{
		$("input[name=contractSignChk]").prop("checked", false);
	}
}

<%
/**
 * 계약서 상세 내용
 */
%>
function fnPopContractDetail(svcTypeCd, contractVersion, borgId){
	var param = 'svcTypeCd=' + svcTypeCd;
	
	param = param + '&contractVersion=' + contractVersion;
	param = param + '&borgId=' + borgId;
	
	window.open('', 'popContractDetail', 'width=917, height=720, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/common/popContractDetail.sys", param, 'popContractDetail');
}
<%
/**
 * 계약서 서명 처리하는 메소드
 *
 * @param borgId (String, 사용자 조직 아이디)
 * @param svcTypeCd (String, 사용자 유형코드)
 */
%>
function fnContractSign(borgId, svcTypeCd){
	var contractSignChk = $("input[name=contractSignChk]:checkbox:checked").length;
	
	if(contractSignChk == 0){
		alert("계약서를 선택해 주세요.");
		
		return;
	}
    $('#popBranchContract').jqmHide();
<%
	if(Constances.COMMON_ISREAL_SERVER) {
%>
	$.post(
		"/common/authUserInfo.sys",
		{
			borgId : borgId
		},
		function(arg){
			fnAuthUserInfoCallback(arg);
		}
	);
<%
	}
	else{
%>
	fnContractSignProcess(borgId, svcTypeCd);
<%
	}
%>
}

var authStep = ""; <%// 공인인증 모듈 관련 변수%>

<%
/**
 * 공인인증을 처리하는 메소드
 */
%>
function fnAuthUserInfoCallback(arg){
	var result      = null;
	var svcTypeCd   = null;
	var success     = null;
	var borgId      = null;
	var businessNum = null;
	var clientId    = null;
	
	arg     = eval('(' + arg + ')');
	result  = arg.customResponse;
	success = result.success;
	
	if(success == false){
		alert("공인인증관련하여 문제가 발생하였습니다.");
	}
	else{
		svcTypeCd     = arg.svcTypeCd;
		borgId        = arg.borgId;
		businessNum   = arg.businessNum;
		clientId      = arg.clientId;
		authStep      = fnGetIsExistPublishAuth(svcTypeCd, borgId); <%// 공인인증 등록여부 판단 %>
		
		$("#authBorgId").val(arg.borgId);
		$("#authSvcTypeCd").val(arg.svcTypeCd);
		
		if("BUY" == svcTypeCd){
			svcTypeCd = "CLT";
		} else if("VEN" == svcTypeCd){
			clientId = borgId;
		}
		
		fnAuthBusinessNumberDialog(svcTypeCd, "ETC", authStep, businessNum, "fnAuthBusinessNumberDialogCallback", clientId); <%//공인인증 모듈 호출 %>
	}
}
<%
/**
 * 공인인증 결과를 받아 처리하는 메소드
 *
 * @param userDn (Object, 공인인증 결과)
 */
%>
function fnAuthBusinessNumberDialogCallback(userDn) {
	var authBorgId    = $("#authBorgId").val();
	var authSvcTypeCd = $("#authSvcTypeCd").val();
	
	if((userDn != "" && userDn != null) || authStep == "2"){ // 인증통과
		fnContractSignProcess(authBorgId, authSvcTypeCd);
	}
}
<%
/**
 * 계약서 서명을 처리하는 메소드
 */
%>
function fnContractSignProcess(borgId, svcTypeCd){
	var contractVirsion_array = new Array();
	var loginId               = $("#loginId").val();
	var contractSignCnt	      = 1;
	var signChkCnt		      = 0;
	var contractSignLength    = $("input[name=contractSignChk]").length;
	var url                   = null;
	
	if("BUY" == svcTypeCd){
		url = "/common/branchContractSign.sys";
	}
	else{
		url = "/common/vendorContractSign.sys";
	}
	
	for(var i=0; i<contractSignLength; i++){
		var signChk = $("#contractSignChk_"+contractSignCnt).prop("checked");
		
		if(signChk){
			var contractVersion = $("#contractSignChk_"+contractSignCnt).val();
			
			contractVirsion_array[signChkCnt] = contractVersion;
			
			signChkCnt++;
		}
		
 		contractSignCnt++;
	}
	
	$.post(
		url,
		{
			contractVirsion_array : contractVirsion_array,
			borgId                : borgId,
			loginId               : loginId
		},
		function(arg){
			var customResponse = eval('(' + arg + ')').customResponse;
			
			if(customResponse.success == false) {
				alert(customResponse.message);
			}
			else {
				fnLogin();
			}
		}
	);
}
<%
/**
 * 계약서 연기 버튼 클릭시 호출되는 메소드
 *
 * @param borgId (String, 계약서 리스트 조회 대상 조직 아이디)
 */
%>
function fnDelayContract(borgId){
	var isOldContract = document.getElementById("isOldContract").value;
	
	if("true" == isOldContract){
		alert("로그인을 계속 하시려면 아래의 계약내용에 동의 하셔야 합니다.");
		

		fnContractToDoList(borgId);
<%-- 계약서 계약 팝업 주석처리
--%>
	}
	else{
		fnLogin();
	}
}

<%
/**
 * 메인화면 개인정보 취급방침 팝업 호출
 */
%>
function contractDetail() {
	window.open("/common/individualContractPopup.sys", 'okplazaPop', 'width=760, height=800, scrollbars=yes, status=no, resizable=no');
}

function fnJoinPop(){
	window.open("/homepage/user/user_02_pop.home", 'okplazaPop', 'width=830, height=500, scrollbars=no, status=no, resizable=no');
}
</script>
<%-- <script type="text/javascript" src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/browser_update.js"></script> --%>
<style type="text/css">  
table.events {
        width: 320px;
        border: solid 7px #ffe0c2;
      }
</style>
</head>
<body style="border:none">
<form id="frm" name="frm" method="post" onsubmit="return false;">
<input type="hidden" name="chk_flag" id="chk_flag" value="0"/>
<input type="hidden" name="guestFlag" id="guestFlag" value="0"/>

<table width="977px" border="0" align="center" cellpadding="0" cellspacing="0" style="height: 700px">
<tr>
	<td>
		<table width="977px" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td height="101px" valign="top">
				
<%-- 				<!-- 상단메뉴 레이아웃 시작 --><%@include file="/WEB-INF/jsp/homepage/inc/top.jsp"%><!-- 상단메뉴 레이아웃 끝 --> --%>
				</td>
			</tr>
			<tr>
				<td align="center">
				<!-- 메인 컨텐츠 시작-->
					<table width="977" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="575" rowspan="2">
								<!-- 이미지 랜덤 변경 시작-->
								<!-- 
								<script type="text/javascript">
									var mb=new Array();
									mb[0]="<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/main_big_img1.jpg' border='0'>";
									mb[1]="<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/main_big_img2.jpg' border='0'>";
									var whichquote=Math.floor(Math.random()*(mb.length));
									document.write(mb[whichquote]);
								</script>
								 -->
								<!-- 이미지 랜덤 변경 끝-->
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/logo.gif" border="0"/>
							</td>
							<td height="155">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/main_big_txt_20140314.jpg" alt="고객의 경쟁력 제고에 기여하는 구매대행전문회사-합리적인 가격 실현과 품질 및 납기보장으로 고객의 경쟁력 강화에 도움이 되고자 합니다." width="402" height="155"/>
							</td>
						</tr>
						<tr>
							<td height="242" valign="top" background="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/main_big_img_02.jpg" style="padding-left:40px;"><p>&nbsp;</p>
								<table width="320" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td align="left">
											<!-- 로그인 박스 시작 -->
											<table width="310" class="events">
												<tr>
													<td bgcolor="#FFFFFF" >
														
														<div id="initDiv" style="height: 22px;" ></div>
														<div id="chgDiv" style="display: none;" >
															<input type="radio" id="loginType1" name="loginType" style="border: 0;vertical-align: middle;" checked="checked"/>
															<img id="imgLoginType1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/user_txt.gif" width="36" height="20" style="vertical-align: middle; cursor:pointer;"/>
															<input type="radio" id="loginType2" name="loginType" style="border: 0;vertical-align: middle;"/>
															<img id="imgLoginType2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/guest_txt.gif" width="36" height="20" style="vertical-align: middle; cursor:pointer;"/>
														</div>
													
														<table id="userTb" width="284" border="0" cellspacing="0" cellpadding="0">
															<tr>
																<td width="65">
																	<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/login_txt_id.gif" width="65" height="20"/>
																</td>
																<td>
																	<font face="verdana,arial" size=-1>
																		<input id="loginId" name="loginId" type="text" value="" size="" maxlength="50" class="text_id" style="width:98%; ime-mode:disabled" tabindex="1"/>
																	</font>
																</td>
																<td width="63" rowspan="3">
																	<a href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_login.gif" width="63" height="45" border="0" id="enter" value="Enter" /></a>
																</td>
															</tr>
															<tr>
																<td colspan="2" height="3px"></td>
															</tr>
															<tr>
																<td width="65">
																	<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/login_txt_pw.gif" width="65" height="20" />
																</td>
																<td>
																	<font face="verdana,arial" size=-1>
																		<input id="password" name="password" type="password" size="" maxlength="50" class="text_pw" style="width:98%" tabindex="2"/>
																	</font>
																</td>
															</tr>
														</table>
														<br/>
														
														<table border="0" align="center" id="findIdTb"> 
															<tr>
																<td>
																	<a href="#" onclick="window.open('/findId.jsp','findId','width=415, height=220')"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_find_id.jpg" style="border: 0"/></a>
																</td>
																<td>
																	<a href="#" onclick="window.open('/findPw.jsp','findPw','width=415, height=250')"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_find_pw.jpg" style="border: 0"/></a>
																</td>
																<td>
<%-- 																	<a href="/homepage/member/join.home"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_memberRegist.jpg" style="border: 0"/></a> --%>
																	<a href="#" onclick="javascript:fnJoinPop();"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_memberRegist.jpg" style="border: 0"/></a>
																</td>
															</tr>
														</table>   														
													</td>
												</tr>
											</table>
											<!-- 로그인 박스 끝 -->
										</td>
									</tr>
									<tr>
									  <td height="6"></td>
									</tr>
									<%--
									<tr>
										<td>
											<table width="310" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td align="left" colspan="3">
														<a href="#" onclick="javascript:fnGoGuestLogin(1);">
															<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/index_jijung.gif" width="320" height="35" border="0"/>
<!-- 															<input type='button' value='지정자재 공급업체 신청' style="width: 320px;"/> -->
														</a>
													</td>
												</tr>
												<tr>
													<td colspan="2" height="4px"></td>
												</tr>
												<tr>
													<td align="left"><a href="#" onclick="javascript:fnGoGuestLogin(0);"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/index_btn_guide_01_bak.gif" width="101" height="40" border="0"/></a></td>
													<td align="center"><a href="/homepage/user/user_01.home"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/index_btn_guide_01.gif" width="101" height="40" border="0"/></a></td>
													<td align="right"><a href="/homepage/user/user_04.home"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/index_btn_guide_03.gif" width="101" height="40" border="0"/></a></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td>
											<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/index_rollBanner.gif" width="309" height="41" border="0" usemap="#MapMap"/>
										</td>
									</tr>
									 --%>
								</table>
								<map name="MapMap"><area shape="rect" coords="130,3,211,39" href="http://www.skbroadband.com/" target="_blank" alt="skbroadband" onFocus="this.blur()"/>
									<area shape="rect" coords="211,2,309,41" href="http://www.networkons.com/" target="_blank" alt="ONS" onFocus="this.blur()"/>
									<area shape="rect" coords="76,3,130,39" href="http://www.skec.co.kr/" target="_blank" alt="skec" onFocus="this.blur()"/>
									<area shape="rect" coords="3,3,76,39" href="http://www.sktelecom.com/" target="_blank" alt="sktelecom.com" onFocus="this.blur()"/>
							</map>
							</td>
						</tr>
					</table>
					<!-- 메인 컨텐츠 끝-->
				</td>
			</tr>
			<%--
			<tr>
				<td height="20" align="left" valign="bottom" style="padding-left:100px;">
					<img src="/img/homepage/version_limit_txt.gif" style="vertical-align: bottom;">
					<button id='nanumButton' class="btn btn-success btn-xs"  style="width: 81px;padding: 0px; vertical-align: bottom;background-color:#295B86;border-color: #255882; font-size: 11px;  ">
							나눔글꼴설치
					</button>				
				</td>
			</tr>
			<tr>
				<td height="58" align="center">
					<!-- 푸터 시작-->
						<%@include file="/WEB-INF/jsp/homepage/inc/footer.jsp"%>
					<!-- 푸터 끝-->
				</td>
			</tr>
			 --%>
		</table>
	</td>
<!-- 	<td> -->
<%-- 		<a href="http://mmcorp.opesmall.com" target="_blank" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/opesm_2.gif" width="81" height="125" border="0"  alt="사무용품 일괄 DC 구매"/></a> --%>
<!-- 	</td> -->
</tr>
</table>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>

<%@ include file="/loginCheckPup.jsp" %>
<map name="Map">
	<area shape="rect" coords="161,3,305,40" href="http://www.networkons.com/" target="_blank" alt="ONS" onFocus="this.blur()"/>
	<area shape="rect" coords="96,3,161,39" href="http://www.skec.co.kr/" target="_blank" alt="skec" onFocus="this.blur()"/>
	<area shape="rect" coords="4,3,95,39" href="http://www.sktelecom.com/" target="_blank" alt="sktelecom.com" onFocus="this.blur()"/>
</map>
</form>
</body>
<%-- 비회원 암호등록 --%>
<jsp:include page="/WEB-INF/jsp/common/guestPassRegDialogPopDiv.jsp" flush="false" />
<%-- 회원 확인 --%>
<jsp:include page="/WEB-INF/jsp/common/guestPassConfirmDialogPopDiv.jsp" flush="false" />

<div id="popBranchContract" name="popBranchContract" class="jqmVendorWindow">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="vendorDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
						<tr>
							<td width="21"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" /></td>
							<td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td>
							<td class="popup_title">계약서 서명</td>
							<td width="22" align="right">
								<a href="javascript:void(0);" class="jqmClose">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;"  onclick="javascript:fnDelayContract();"/>
								</a>
							</td>
							<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
						</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							<table width="100%" style="height: 27px;border-top:solid 1px #ccc;" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td class="table_td_subject" style="line-height: 1.7em; padding-bottom: 4px; font-size: 1.7em;" id="branchContractTitle">
										아래의 계약 내용을 확인해 주십시오.<br/>
										계약 기간은 2/28일까지 입니다. <br/>계약을 위해서는 공인인증서가 필요합니다.
									</td>
								</tr>
								<tr>
									<td height="5px"></td>
								</tr>
								<tr>
									<td>
										<table id="branchContractContents" width="100%" style="height: 27px;border-top:solid 1px #ccc;" border="0" cellpadding="0" cellspacing="0">
										</table>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</html>
