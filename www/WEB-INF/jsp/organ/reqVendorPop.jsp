<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-215 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	String file_biz_reg_list = "";
	String file_app_sal_list = "";
	String file_list1 = "";
	String file_list2 = "";
	String file_list3 = "";
	
	String attach_file_biz_reg_name = "";
	String attach_file_app_sal_name = "";
	String attach_file_name1 = "";
	String attach_file_name2 = "";
	String attach_file_name3 = "";
	
	String attach_file_biz_reg_path = "";
	String attach_file_app_sal_path = "";
	String attach_file_path1 = "";
	String attach_file_path2 = "";
	String attach_file_path3 = "";
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<%
/**------------------------------------사용방법---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
------------------------------------------------------------------------------*/
%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnBizRegAttach").click(function(){ fnUploadDialog("사업자등록첨부", $("#file_biz_reg_list").val(), "fnCallBackAttachBizReq"); });
	$("#btnAppSalAttach").click(function(){ fnUploadDialog("신용평가서첨부", $("#file_app_sal_list").val(), "fnCallBackAttachAppSal"); });
	$("#btnAttach1").click(function(){ fnUploadDialog("통장사본첨부", $("#file_list1").val(), "fnCallBackAttach1"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("기타첨부1", $("#file_list2").val(), "fnCallBackAttach2"); });
	$("#btnAttach3").click(function(){ fnUploadDialog("기타첨부2", $("#file_list3").val(), "fnCallBackAttach3"); });
});

/**
 * 사업자등록첨부 파일관리
 */
function fnCallBackAttachBizReq(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_biz_reg_list").val(rtn_attach_seq);
	$("#attach_file_biz_reg_name").text(rtn_attach_file_name);
	$("#attach_file_biz_reg_path").val(rtn_attach_file_path);
}

/**
 * 사업자등록첨부 파일관리
 */
function fnCallBackAttachAppSal(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_app_sal_list").val(rtn_attach_seq);
	$("#attach_file_app_sal_name").text(rtn_attach_file_name);
	$("#attach_file_app_sal_path").val(rtn_attach_file_path);
}

/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list1").val(rtn_attach_seq);
	$("#attach_file_name1").text(rtn_attach_file_name);
	$("#attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list2").val(rtn_attach_seq);
	$("#attach_file_name2").text(rtn_attach_file_name);
	$("#attach_file_path2").val(rtn_attach_file_path);
}
/**
 * 첨부파일3 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list3").val(rtn_attach_seq);
	$("#attach_file_name3").text(rtn_attach_file_name);
	$("#attach_file_path3").val(rtn_attach_file_path);
}

/**
 * 파일다운로드
 */
function fnAttachFileDownload(attach_file_path) {
	
	var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
	var data = "attachFilePath="+attach_file_path;
	$.download(url,data,'post');
}
jQuery.download = function(url, data, method){
    // url과 data를 입력받음
    if( url && data ){ 
        // data 는  string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의  input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function(){ 
            var pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};
</script>

<!--버튼 이벤트 스크립트-->
<script type="text/javascript">
 $(document).ready(function(){
     $("#closeButton").click( function() { fnClose(); });
     $("#btnSave").click( function() { fnSave(); });
     $("#clientCdConfirm").click( function() { fnClientCdConfirm(); });
     $("#loginIdConfirm").click( function() { fnLoginIdConfirm(); });
     
 });
</script>

<%
/**------------------------------------우편번호검색 사용방법---------------------------------
* fnPostSearchDialog(callbackString) 을 호출하여 Div팝업을 Display ===
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 2개(우편번호, 기본주소) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/postSearchDiv.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnPost").click(function(){
		fnPostSearchDialog("fnCallBackPostAddress"); 
	});
});
/**
 * 우편번호팝업검색후 선택한 값 세팅
 */
function fnCallBackPostAddress(post, postAddress) {
	$("#postAddrNum").val(post);
	$("#addres").val(postAddress);
	$("#addresDesc").focus();
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 그리드 이벤트 스크립트-->
<script type="text/javascript">
	function fnClose(){
	// 	window.dialogArguments.fnReloadGrid();
	 	window.close();
	}
	
	function fnDupCheck(event) {
		var key = window.event ? event.keyCode : event.which;  
		
		if(key == 13){
			fnLoginIdConfirm();
		}
	}
	 
	function fnIsValidation(){
		 
		 var vendorNm = $.trim($("#vendorNm").val());
		 var businessNum1 = $.trim($("#businessNum1").val());
		 var businessNum2 = $.trim($("#businessNum2").val());
		 var businessNum3 = $.trim($("#businessNum3").val());
		 var registNum1 = $.trim($("#registNum1").val());
		 var registNum2 = $.trim($("#registNum2").val());
		 var vendorBustType = $.trim($("#vendorBustType").val());
		 var vendorBustClas = $.trim($("#vendorBustClas").val());
		 var pressentNm = $.trim($("#pressentNm").val());
		 var phoneNum = $.trim($("#phoneNum").val());
		 var eMail = $.trim($("#eMail").val());
		 var postAddrNum = $.trim($("#postAddrNum").val());
		 var addres = $.trim($("#addres").val());
		 var file_biz_reg_list = $.trim($("#file_biz_reg_list").val());
		 var areaType = $.trim($("#areaType").val());
		 var payBillType = $.trim($("#payBillType").val());
		 var payBillDay = $.trim($("#payBillDay").val());
		 var accountManagerNm = $.trim($("#accountManagerNm").val());
		 var accountTelNum = $.trim($("#accountTelNum").val());
		 var bankCd = $.trim($("#bankCd").val());
		 var recipient  = $.trim($("#recipient").val());
		 var accountNum  = $.trim($("#accountNum").val());
		 var loginId    = $.trim($("#loginId").val());   
		 var pwd        = $.trim($("#pwd").val());       
		 var pwdConfirm = $.trim($("#pwdConfirm").val());
		 var userNm     = $.trim($("#userNm").val());    
		 var tel        = $.trim($("#tel").val());       
		 var mobile     = $.trim($("#mobile").val());    
		 var userEmail  = $.trim($("#userEmail").val()); 

		 
		 if(vendorNm == ""){
			$("#dialog").html("<font size='2'>공급사명을 입력해주세요.</font>");
			$("#dialog").dialog({
				title: 'Success',modal: true,
				buttons: {"Ok": function(){$(this).dialog("close");} }
			});					 
			return false;
		 }
	
		 if(businessNum1 == "" || businessNum2 == "" || businessNum3 == ""){
	 		 $("#dialog").html("<font size='2'>사업자 등록번호를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
// 		 if(registNum1 == "" || registNum2 == ""){
// 	 		 $("#dialog").html("<font size='2'>법인 등록번호를 입력해주세요.</font>");
// 			 $("#dialog").dialog({
// 				 title: 'Success',modal: true,
// 				 buttons: {"Ok": function(){$(this).dialog("close");} }
// 			 });			 
// 			 return false;
// 		 }	 
		 
		 if(vendorBustType == ""){
	 		 $("#dialog").html("<font size='2'>업종을 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		
		 if(vendorBustClas == ""){
	 		 $("#dialog").html("<font size='2'>업태를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
		 if(pressentNm == ""){
	 		 $("#dialog").html("<font size='2'>대표자명을 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
		 if(phoneNum == ""){
	 		 $("#dialog").html("<font size='2'>대표 전화번호를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
		 if(eMail == ""){
	 		 $("#dialog").html("<font size='2'>E-MAIL을 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }else{
			 email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
			 if(!email_regex.test(eMail)){
		 		 $("#dialog").html("<font size='2'>E-MAIL 유형을 확인해주세요.</font>");
				 $("#dialog").dialog({
					 title: 'Success',modal: true,
					 buttons: {"Ok": function(){$(this).dialog("close");} }
				 });				 
			 	 return false; 
			 }
		 }
		 
		 if(postAddrNum == "" || addres == ""){
	 		 $("#dialog").html("<font size='2'>주소를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
		 if(file_biz_reg_list == ""){
			 
	 		 $("#dialog").html("<font size='2'>사업자등록첨부를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
	
		 if(areaType == ""){
	 		 $("#dialog").html("<font size='2'>소재지를 선택해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }

		 if(payBillType == ""){
	 		 $("#dialog").html("<font size='2'>결제조건을 선택해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
		 if(accountManagerNm == ""){
	 		 $("#dialog").html("<font size='2'>회계담당자명을 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
		 if(accountTelNum == ""){
	 		 $("#dialog").html("<font size='2'>회계이동전화번호를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
		 if(bankCd == ""){
	 		 $("#dialog").html("<font size='2'>은행코드를 선택해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
		 if(recipient == ""){
	 		 $("#dialog").html("<font size='2'>예금주명을 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
		 if(accountNum == ""){
	 		 $("#dialog").html("<font size='2'>계좌번호를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
	
		 if(loginId == ""){
	 		 $("#dialog").html("<font size='2'>로그인ID를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }

		 if(pwd == ""){
	 		 $("#dialog").html("<font size='2'>비밀번호를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }

		 if(pwdConfirm == ""){
	 		 $("#dialog").html("<font size='2'>비밀번호확인을 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }else{
			 if(pwd != pwdConfirm){
		 		 $("#dialog").html("<font size='2'>입력하신 비밀번호가 다릅니다. \n다시확인해주세요.</font>");
				 $("#dialog").dialog({
					 title: 'Success',modal: true,
					 buttons: {"Ok": function(){$(this).dialog("close");} }
				 });						 
				 
				 return false;
			 }
		 }

		 if(userNm == ""){
	 		 $("#dialog").html("<font size='2'>담당자명을 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }

		 if(tel == ""){
	 		 $("#dialog").html("<font size='2'>담당자 전화번호를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }

		 if(mobile == ""){
	 		 $("#dialog").html("<font size='2'>담당자 이동전화번호를 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		 
		 if(userEmail == ""){
	 		 $("#dialog").html("<font size='2'>E-MAIL을 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }else{
			 email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
			 if(!email_regex.test(userEmail)){
		 		 $("#dialog").html("<font size='2'>담당자 E-MAIL 유형을 확인해주세요.</font>");
				 $("#dialog").dialog({
					 title: 'Success',modal: true,
					 buttons: {"Ok": function(){$(this).dialog("close");} }
				 });				 
			 	 return false; 
			 }
		 }		
		 
		 if(!isLoginIdCheck){
	 		 $("#dialog").html("<font size='2'>로그인ID 중복체크가 필요합니다.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });				 
		 	 return false; 			 
		 }
		 
		 return true;
	}
 
	function fnSave(){
	 	var isValidation = fnIsValidation();
	 	if(!confirm("공급사 가입신청을 진행하시겠습니까?")) return;
		if(isValidation){
			
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveVendorPop.sys", 
				{
					vendorNm:$.trim($("#vendorNm").val()),
					businessNum1:$.trim($("#businessNum1").val()),
					businessNum2:$.trim($("#businessNum2").val()),
					businessNum3:$.trim($("#businessNum3").val()),
					registNum1:$.trim($("#registNum1").val()),
					registNum2:$.trim($("#registNum2").val()),
					vendorBustType:$.trim($("#vendorBustType").val()),
					vendorBustClas:$.trim($("#vendorBustClas").val()),
					pressentNm:$.trim($("#pressentNm").val()),
					phoneNum:$.trim($("#phoneNum").val()),
					eMail:$.trim($("#eMail").val()),
					homePage:$.trim($("#homePage").val()),
					postAddrNum:$.trim($("#postAddrNum").val()),
					addres:$.trim($("#addres").val()),
					addresDesc:$.trim($("#addresDesc").val()),
					faxNum:$.trim($("#faxNum").val()),
					refereceDesc:$.trim($("#refereceDesc").val()),
					file_biz_reg_list:$.trim($("#file_biz_reg_list").val()),
					file_app_sal_list:$.trim($("#file_app_sal_list").val()),
					file_list1:$.trim($("#file_list1").val()),
					file_list2:$.trim($("#file_list2").val()),
					file_list3:$.trim($("#file_list3").val()),
					areaType:$.trim($("#areaType").val()),
					payBillType:$.trim($("#payBillType").val()),
					payBillDay:$.trim($("#payBillDay").val()),
					accountManagerNm:$.trim($("#accountManagerNm").val()),
					accountTelNum:$.trim($("#accountTelNum").val()),
					bankCd:$.trim($("#bankCd").val()),
					recipient:$.trim($("#recipient").val()),
					accountNum:$.trim($("#accountNum").val()),
					loginId:$.trim($("#loginId").val()),
					pwd:$.trim($("#pwd").val()),
					userNm:$.trim($("#userNm").val()),
					tel:$.trim($("#tel").val()),
					mobile:$.trim($("#mobile").val()),
					userEmail:$.trim($("#userEmail").val())
				},			
				
				function(arg){ 
					if(fnAjaxTransResult(arg)) {	//성공시
						window.close();
					}
				}
			);		
		}
	}
	var isLoginIdCheck = false;
	function fnLoginIdConfirm(){
		if($("#loginId").val() == ""){
			$("#dialog").html("<font size='2'>로그인ID를 입력해주세요.</font>");
			$("#dialog").dialog({
				title: 'Success',modal: true,
				buttons: {"Ok": function(){$(this).dialog("close");} }
			});	
			return;
		}		
		
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/loginIdDupCheck.sys", 
			{ loginId:$("#loginId").val() },
			function(arg){ 
				if(fnTransResult(arg, false)) {
					isLoginIdCheck = true;
					$("#dialog").html("<font size='2'>사용가능합니다.</font>");
					$("#dialog").dialog({
						title: 'Success',modal: true,
						buttons: {"Ok": function(){$(this).dialog("close");} }
					});
				}
			}
		);		
	}
</script>
</head>
<body>

<form id="frm" name="frm" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
						<td height="29" class='ptitle'>공급사등록요청</td>
					</tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
					<tr>
						<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
						<td class="stitle">공급사 일반정보</td>
					</tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">공급사명</td>
						<td colspan="5" class="table_td_contents">
							<input id="vendorNm" name="vendorNm" type="text" value="" size="40" maxlength="50"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">사업자등록번호</td>
						<td class="table_td_contents">
							<input id="businessNum1" name="businessNum1" type="text" value="" size="3" maxlength="3" onkeydown="return onlyNumber(event)"/>-
							<input id="businessNum2" name="businessNum2" type="text" value="" size="2" maxlength="2" onkeydown="return onlyNumber(event)"/>-
							<input id="businessNum3" name="businessNum3" type="text" value="" size="5" maxlength="5" onkeydown="return onlyNumber(event)"/>
						</td>
						<td class="table_td_subject" width="100">법인등록번호</td>
						<td class="table_td_contents">
							<input id="registNum1" name="registNum1" type="text" value="" size="6" maxlength="6" onkeydown="return onlyNumber(event)"/>-
							<input id="registNum2" name="registNum2" type="text" value="" size="7" maxlength="7" onkeydown="return onlyNumber(event)"/>
						</td>
						<td class="table_td_subject9" width="100">업종</td>
						<td class="table_td_contents">
							<input id="vendorBustType" name="vendorBustType" type="text" value="" size="20" maxlength="30" style="width:98%"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">업태</td>
						<td class="table_td_contents">
							<input id="vendorBustClas" name="vendorBustClas" type="text" value="" size="20" maxlength="30"/>
						</td>
						<td class="table_td_subject9" width="100">대표자명</td>
						<td class="table_td_contents">
							<input id="pressentNm" name="pressentNm" type="text" value="" size="20" maxlength="30" style="width:98%"/>
						</td>
						<td class="table_td_subject9" width="100">대표전화번호</td>
						<td class="table_td_contents">
							<input id="phoneNum" name="phoneNum" type="text" value="" size="14" maxlength="15" onkeydown="return onlyNumberForSum(event)"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">회사이메일</td>
						<td colspan="3" class="table_td_contents">
							<input id="eMail" name="eMail" type="text" value="" size="20" maxlength="30" style="ime-mode: disabled;"/> ex)admin@unpamsbank.com
						</td>
						<td class="table_td_subject" width="100">홈페이지</td>
						<td class="table_td_contents">
							<input id="homePage" name="homePage" type="text" value="" size="20" maxlength="30" style="width:98%; ime-mode: disabled;"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">주소</td>
						<td colspan="3" class="table_td_contents">
							<input id="postAddrNum" name="postAddrNum" type="text" value="" size="7" maxlength="7" onkeydown="return onlyNumber(event)" class="input_text_none" disabled="disabled"/>
							<a href="#">
								<img id="btnPost" name="btnPost" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search' style="vertical-align: middle;border: 0px;" />
							</a>
							<input id="addres" name="addres" type="text" value="" size="56" maxlength="50" class="input_text_none" disabled="disabled"/>
						</td>
						<td class="table_td_subject" width="100">상세주소</td>
						<td class="table_td_contents">
							<input id="addresDesc" name="addresDesc" type="text" value="" size="20" maxlength="30" style="width:98%"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">팩스번호</td>
						<td class="table_td_contents">
							<input id="faxNum" name="faxNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
						</td>
						<td class="table_td_subject" width="100">참고사항</td>
						<td colspan="3" class="table_td_contents">
							<input id="refereceDesc" name="refereceDesc" type="text" value="" size="20" maxlength="30" style="width:98%"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
				
					<tr>
						<td class="table_td_subject9" width="100">사업자등록첨부
							<a href="#">
								<img id="btnBizRegAttach" name="btnBizRegAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
							</a>					
						</td>
						<td class="table_td_contents">
							<input type="hidden" id="file_biz_reg_list" name="file_biz_reg_list" value="<%=file_biz_reg_list %>"/>
							<input type="hidden" id="attach_file_biz_reg_path" name="attach_file_biz_reg_path" value="<%=attach_file_biz_reg_path %>"/>
							<a href="javascript:fnAttachFileDownload(($('#attach_file_biz_reg_path').val()).replace(/\\/g,'\\\\'));">
							<span id="attach_file_biz_reg_name"><%=attach_file_biz_reg_name %></span>
							</a>
						</td>
						<td class="table_td_subject" width="100">신용평가서첨부
							<a href="#">
								<img id="btnAppSalAttach" name="btnAppSalAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
							</a>						
						</td>
						<td class="table_td_contents">
							<input type="hidden" id="file_app_sal_list" name="file_app_sal_list" value="<%=file_app_sal_list %>"/>
							<input type="hidden" id="attach_file_app_sal_path" name="attach_file_app_sal_path" value="<%=attach_file_app_sal_path %>"/>
							<a href="javascript:fnAttachFileDownload(($('#attach_file_app_sal_path').val()).replace(/\\/g,'\\\\'));">
							<span id="attach_file_app_sal_name"><%=attach_file_app_sal_name %></span>
							</a>
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">통장사본첨부
							<a href="#">
								<img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
							</a>					
						</td>
						<td class="table_td_contents">
							<input type="hidden" id="file_list1" name="file_list1" value="<%=file_list1 %>"/>
							<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
							<a href="javascript:fnAttachFileDownload(($('#attach_file_path1').val()).replace(/\\/g,'\\\\'));">
							<span id="attach_file_name1"><%=attach_file_name1 %></span>
							</a>					
						</td>
						<td class="table_td_subject" width="100">기타첨부1
							<a href="#">
							<img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
							</a>					
						</td>
						<td class="table_td_contents">
							<input type="hidden" id="file_list2" name="file_list2" value="<%=file_list2 %>"/>
							<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2 %>"/>
							<a href="javascript:fnAttachFileDownload(($('#attach_file_path2').val()).replace(/\\/g,'\\\\'));">
							<span id="attach_file_name2"><%=attach_file_name2 %></span>
							</a>	
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">기타첨부2
							<a href="#">
								<img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
							</a>							
						</td>
						<td colspan="5" class="table_td_contents">
							<input type="hidden" id="file_list3" name="file_list3" value="<%=file_list3 %>"/>
							<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
							<a href="javascript:fnAttachFileDownload(($('#attach_file_path3').val()).replace(/\\/g,'\\\\'));">
							<span id="attach_file_name3"><%=attach_file_name3 %></span>
							</a>	
						</td>
					</tr>
				
				
				
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">소재지</td>
						<td colspan="5" class="table_td_contents">
							<select class="select" id="areaType" name="areaType">
								<option value="">선택하세요</option>
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> areaCode = (List<CodesDto>) request.getAttribute("areaCode");
	for(CodesDto areaCd : areaCode){
%>		
							<option value="<%=areaCd.getCodeVal1()%>" ><%=areaCd.getCodeNm1() %></option>
<%	
	}						
%>									
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table>
				<!-- 컨텐츠 끝 -->
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
					<tr>
						<td width="20" valign="top" >
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
						</td>
						<td class="stitle">결제정보</td>
					</tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">결제조건</td>
						<td class="table_td_contents">
						<select class="select" id="payBillType" name="payBillType" disabled="disabled">
<!-- 							<option>선택하세요</option> -->
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> payCondCode = (List<CodesDto>) request.getAttribute("payCondCode");
	for(CodesDto payCondCd: payCondCode){
		if(payCondCd.getCodeVal1().equals("1030")){
%>
							<option value="<%=payCondCd.getCodeVal1()%>">
								<%=payCondCd.getCodeNm1()%>
							</option>
<%			
		}
	}						
%>									
						</select>
							<input id="payBillDay" name="payBillDay" type="text" value="30" size="20" maxlength="2" style="width:20px" disabled="disabled" onkeydown="return onlyNumber(event)"/>일
						</td>
						<td class="table_td_subject9" width="100">회계담당자명</td>
						<td class="table_td_contents">
							<input id="accountManagerNm" name="accountManagerNm" type="text" value="" size="20" maxlength="30" style="width:98%"/>
						</td>
						<td class="table_td_subject9" width="100">회계이동전화</td>
						<td class="table_td_contents">
							<input id="accountTelNum" name="accountTelNum" type="text" value="" size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">은행코드</td>
						<td class="table_td_contents">
							<select class="select" id="bankCd" name="bankCd">
								<option value="">선택하세요</option>
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> bankCode = (List<CodesDto>) request.getAttribute("bankCode");
	for(CodesDto bankCd : bankCode){
%>		
							<option value="<%=bankCd.getCodeVal1()%>" ><%=bankCd.getCodeNm1() %></option>
<%	
	}						
%>											
							</select>
						</td>
						<td class="table_td_subject9" width="100">예금주명</td>
						<td class="table_td_contents">
							<input id="recipient" name="recipient" type="text" value="" size="20" maxlength="30" style="width:98%"/>
						</td>
						<td class="table_td_subject9" width="100">계좌번호</td>
						<td class="table_td_contents">
							<input id="accountNum" name="accountNum" type="text" value="" size="15" maxlength="20" onkeydown="return onlyNumber(event)"/> (-없이)
						</td>
					</tr>
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table>
				<!-- 컨텐츠 끝 -->
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
					<tr>
						<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
						<td class="stitle">담당자 정보</td>
					</tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="4" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">로그인ID</td>
						<td colspan="3" class="table_td_contents">
							<input id="loginId" name="loginId" type="text" value="" size="40" maxlength="50" style="ime-mode: disabled;" onkeydown="return fnDupCheck(event)"/>
							<a href="#">
								<img id="loginIdConfirm" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_check.gif" width="75" height="18" class='icon_search' style="border: 0px;vertical-align: middle;"/>
							</a>
						</td>
					</tr>
					<tr>
						<td colspan="4" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">비밀번호</td>
						<td class="table_td_contents"><input id="pwd" name="pwd" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;"/></td>
						<td class="table_td_subject9" width="100">비밀번호 확인</td>
						<td class="table_td_contents"><input id="pwdConfirm" name="pwdConfirm" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;"/></td>
					</tr>
					<tr>
						<td colspan="4" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">성명</td>
						<td class="table_td_contents"><input id="userNm" name="userNm" type="text" value="" size="20" maxlength="30"/></td>
						<td class="table_td_subject9" width="100">전화번호</td>
						<td class="table_td_contents"><input id="tel" name="tel" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/></td>
					</tr>
					<tr>
						<td colspan="4" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100">이동전화번호</td>
						<td class="table_td_contents"><input id="mobile" name="mobile" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumber(event)"/></td>
						<td class="table_td_subject9" width="100">이메일</td>
						<td class="table_td_contents"><input id="userEmail" name="userEmail" type="text" value="" size="20" maxlength="30" style="ime-mode: disabled;"/> ex)admin@unpamsbank.com</td>
					</tr>
					<tr>
						<td colspan="4" class="table_top_line"></td>
					</tr>
				</table>
				<!-- 컨텐츠 끝 -->
				<div id="dialog" title="Feature not supported" style="display:none;">
					<p>That feature is not supported.</p>
				</div>				
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="center">
				<a href="#">
					<img id="btnSave" name="btnSave" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_request.gif" width="85" height="23" style="border: 0px;vertical-align: middle;" />
				</a>
			</td>
		</tr>
	</table>
</form>
</body>
</html>