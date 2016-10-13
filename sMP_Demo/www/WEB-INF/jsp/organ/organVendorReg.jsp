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
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>

<%
/**------------------------------------권한팝업 사용방법 시작---------------------------------
* fnJqmAddRoleListInit(svcTypeCd, callbackString) 을 호출하여 Div팝업을 Display ===
* svcTypeCd : 서비스코드("BUY":고객사, "VEN":공급사, "ADM":운영자, "CEN":물류센타)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(권한ID, 권한코드, 권한명, 기본권한여부, 권한조직범위코드, 권한설명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/addRoleListDiv.jsp"%>
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#roleAddButton").click(function(){
		fnJqmAddRole();
	});   
	$("#roleDelButton").click(function(){
		fnRoleDel();
	});      
});


function fnJqmAddRole() {
   fnJqmAddRoleListInit("VEN","fnAddRoleCallBack");
}

function fnAddRoleCallBack(roleId, roleCd, roleNm, isDefault, borgScopeCd, roleDesc) {
	var rowCnt = $("#list").getGridParam('reccount');
	var maxId = new Array();
	for(var i=0;i<rowCnt;i++) {
		var rowid = $("#list").getDataIDs()[i];
		maxId[i] = parseInt(rowid); 
		var selrowContent = $("#list").jqGrid('getRowData',rowid);
		if(roleId == selrowContent.roleId || roleCd == selrowContent.roleCd) { 
			alert("이미 등록된 권한입니다."); 
			return; 
		}
	}
// 	var setIsDefault    = "0";
// 	var setIsDefaultStr  = "아니요";
// 	if(rowCnt == 0){
// 		setIsDefault = "1";
// 		setIsDefaultStr  = "예";
// 	}
// 	var borgScopeCdStr = "";

// 	for(var i = 0 ; i < codeList.length ; i++){
// 		if(codeList[i].codeVal1 == borgScopeCd){
// 			borgScopeCdStr = codeList[i].codeNm1;
// 			break;
// 		}
// 	}
	var setRow = rowCnt == 0 ? 1 : parseInt (maxId.reverse()[0]) + 1;
	jq("#list").addRowData(setRow, { roleCd:roleCd, roleNm:roleNm, roleDesc:roleDesc, roleId:roleId });   
}

function fnRoleDel(){
	var id = $("#list").jqGrid('getGridParam', "selrow" );

	if(id == null){
		$("#dialog").html("<font size='2'>삭제할 항목을 선택해주세요.</font>");
		$("#dialog").dialog({
			title: 'fail',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});      
		return;
	}
   jQuery("#list").delRowData(id);
}
</script>

<%//----------------------------------권한팝업 사용방법 끝----------------------------------------%>

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
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp"%>
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
* 1. 우편번호 검색 버튼 클릭 시 발생할 이벤트 적용
* 2. 콜백 후 처리 되는 부분 참조 (그대로 복사)
* 3. 우편번호,주소,상세주소 input 태그에 맞는 id 변경만 처리하면 적용
*/
%>
<!-- 고객사검색관련 스크립트 -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	/*****  1.이벤트 적용*****/
	$("#btnPost").click(function(){	fnSetPostCode();	});
});

function fnSetPostCode() {
	new daum.Postcode({
		oncomplete: function(data) {
			/*****  2. 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.(콜백)*****/

			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var fullAddr = ''; // 최종 주소 변수
			var extraAddr = ''; // 조합형 주소 변수

			// 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
				fullAddr = data.roadAddress;
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
				fullAddr = data.jibunAddress;
			}

			// 사용자가 선택한 주소가 도로명 타입일때 조합한다.
			if(data.userSelectedType === 'R'){
				//법정동명이 있을 경우 추가한다.
				if(data.bname !== ''){
					extraAddr += data.bname;
				}
				// 건물명이 있을 경우 추가한다.
				if(data.buildingName !== ''){
					extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				// 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
				fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
			}
			
			/*****  3. 우편번호와 주소 정보를 해당 필드에 넣는다 (ID매칭 확인) *****/
			document.getElementById('postAddrNum').value = data.zonecode; //5자리 새우편번호 사용
			document.getElementById('addres').value = fullAddr;
			document.getElementById('addresDesc').focus();
		}
	}).open();
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
		 var vendorBusiType = $.trim($("#vendorBusiType").val());
		 var vendorBusiClas = $.trim($("#vendorBusiClas").val());
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
		 var trustBillUserEmail = $.trim($("#trustBillUserEmail").val()); 
		 var sharpMail = $.trim($("#sharpMail").val());//회시샵메일
		 
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
		 
		 if(vendorBusiType == ""){
	 		 $("#dialog").html("<font size='2'>업종을 입력해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });			 
			 return false;
		 }
		
		 if(vendorBusiClas == ""){
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
		 
		 if(trustBillUserEmail != ""){
			 email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
			 if(!email_regex.test(trustBillUserEmail)){
		 		 $("#dialog").html("<font size='2'>세금계산서 E-MAIL 유형을 확인해주세요.</font>");
				 $("#dialog").dialog({
					 title: 'Success',modal: true,
					 buttons: {"Ok": function(){$(this).dialog("close");} }
				 });				 
			 	 return false; 
			 }
		 }			 
		 
		 if(sharpMail == ""){
			$("#dialog").html("<font size='2'>SHARP-MAIL을 입력해주세요.</font>");
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
		
		if(isValidation){
	         var roleCdArr    	= Array();
	         var roleNmArr   	= Array();
	         var roleDescArr 	= Array();
	         var roleIdArr 		= Array();
	         var roleCnt        = jq("#list").getGridParam('reccount');
	         
	         for(var i = 0 ; i < roleCnt ; i++){
	            var rowid = $("#list").getDataIDs()[i];   
	            var selrowContent    = jq("#list").jqGrid('getRowData',rowid);
	            
	            roleCdArr[i]    = selrowContent.roleCd;
	            roleNmArr[i]   	= selrowContent.roleNm;
	            roleDescArr[i] 	= selrowContent.roleDesc;
	            roleIdArr[i] 	= selrowContent.roleId;
	         }      
			
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveVendorReg.sys", 
				{
					oper:"add",
					vendorNm:$.trim($("#vendorNm").val()),
					businessNum1:$.trim($("#businessNum1").val()),
					businessNum2:$.trim($("#businessNum2").val()),
					businessNum3:$.trim($("#businessNum3").val()),
					registNum1:$.trim($("#registNum1").val()),
					registNum2:$.trim($("#registNum2").val()),
					vendorBusiType:$.trim($("#vendorBusiType").val()),
					vendorBusiClas:$.trim($("#vendorBusiClas").val()),
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
					userEmail:$.trim($("#userEmail").val()),
					roleCdArr:roleCdArr,
					roleNmArr:roleNmArr,
					roleDescArr:roleDescArr,
					roleIdArr:roleIdArr,
					vendorId:"0",
					userId:"0",
					trustBillUserId:$.trim($("#trustBillUserId").val()),
					trustBillUserNm:$.trim($("#trustBillUserNm").val()),
					trustBillUserEmail:$.trim($("#trustBillUserEmail").val()),
					trustBillUserTel:$.trim($("#trustBillUserTel").val()),
					sharpMail:$.trim($("#sharpMail").val())
				},			
				
				function(arg){ 
					if(fnAjaxTransResult(arg)) {	//성공시
// 						var opener = window.dialogArguments;
						window.opener.fnSearch();
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

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
jq(function() {
   jq("#list").jqGrid({
	  url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',  
      datatype: 'json',
      mtype: 'POST',
      colNames:['권한코드', '권한명', '권한설명', 'userId', 'roleId', 'borgId'],
      colModel:[
         {name:'roleCd',index:'roleCd', width:90,align:"left",search:false,sortable:true, editable:false },
         {name:'roleNm',index:'roleNm', width:200,align:"left",search:false,sortable:true, editable:false },
         {name:'roleDesc',index:'roleDesc', width:370,align:"left",search:false,sortable:true, editable:false },
         {name:'userId',index:'userId', width:200,align:"left",search:false,sortable:true, editable:false, hidden:true },
         {name:'roleId',index:'roleId', width:200,align:"left",search:false,sortable:true, editable:false, hidden:true },
         {name:'borgId',index:'borgId', width:200,align:"left",search:false,sortable:true, editable:false, hidden:true }
      ],
      postData: {},
      rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
      height: 80,autowidth: true,
      caption:"권한정보", 
      viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete: function() {},
      onSelectRow: function (rowid, iRow, iCol, e) {},
      ondblClickRow: function (rowid, iRow, iCol, e) {
         <%-- // 추후 개발시 참조. CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();")--%>
      },
      onCellSelect: function(rowid, iCol, cellcontent, target){},
      loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
      jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
   }); 
});
</script>

</head>
<body>
<div style='position:absolute;top:0;left:0;width:980px;height:880px;overflow:auto;'>

   <form id="frm" name="frm" method="post">
      <table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                     </td>
                     <td height="29" class='ptitle'>공급사등록</td>
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
                     <td width="20" valign="top">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">공급사 일반정보</td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <!-- 컨텐츠 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="80">공급사명</td>
                     <td colspan="5" class="table_td_contents">
                        <input id="vendorNm" name="vendorNm" type="text" value="" size="40" maxlength="50" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
	                  <td class="table_td_subject9" width="100">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 15px;">
							<tr>
								<td>사업자등록번호</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
									<input type="button" value="국세청조회" style=cursor:pointer; onClick="window.open('http://www.nts.go.kr/cal/cal_check_02.asp')"></input>
								</td>
							</tr>
						</table>
					  </td>
                     <td class="table_td_contents">
                        <input id="businessNum1" name="businessNum1" type="text" value="" size="3" maxlength="3" onkeydown="return onlyNumber(event)" />
                        -
                        <input id="businessNum2" name="businessNum2" type="text" value="" size="2" maxlength="2" onkeydown="return onlyNumber(event)" />
                        -
                        <input id="businessNum3" name="businessNum3" type="text" value="" size="5" maxlength="5" onkeydown="return onlyNumber(event)" />
                     </td>
                     <td class="table_td_subject" width="80">법인등록번호</td>
                     <td class="table_td_contents">
                        <input id="registNum1" name="registNum1" type="text" value="" size="6" maxlength="6" onkeydown="return onlyNumber(event)" />
                        -
                        <input id="registNum2" name="registNum2" type="text" value="" size="7" maxlength="7" onkeydown="return onlyNumber(event)" />
                     </td>
                     <td class="table_td_subject9" width="80">업종</td>
                     <td class="table_td_contents">
                        <input id="vendorBusiType" name="vendorBusiType" type="text" value="" size="20" maxlength="30" style="width: 98%" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="80">업태</td>
                     <td class="table_td_contents">
                        <input id="vendorBusiClas" name="vendorBusiClas" type="text" value="" size="20" maxlength="30" />
                     </td>
                     <td class="table_td_subject9" width="80">대표자명</td>
                     <td class="table_td_contents">
                        <input id="pressentNm" name="pressentNm" type="text" value="" size="20" maxlength="30"/>
                     </td>
                     <td class="table_td_subject9" width="80">대표전화번호</td>
                     <td class="table_td_contents">
                        <input id="phoneNum" name="phoneNum" type="text" value="" size="14" maxlength="15" onkeydown="return onlyNumberForSum(event)" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="80">회사이메일</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="eMail" name="eMail" type="text" value="" size="20" maxlength="30" style="ime-mode: disabled;" />
                        ex)admin@unpamsbank.com
                     </td>
                     <td class="table_td_subject" width="80">홈페이지</td>
                     <td class="table_td_contents">
                        <input id="homePage" name="homePage" type="text" value="" size="20" maxlength="30" style="width: 98%; ime-mode: disabled;" />
                     </td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">
                        <table>
                           <tr>
                              <td>회사샵메일</td>
                           </tr>
                           <tr>
                              <td>
                                 <input type="button" value="회원가입하기" style=cursor:pointer; onclick="window.open('https://www.docusharp.com/member/join.jsp')"></input>
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td colspan="5" class="table_td_contents">
                        <input id="sharpMail" name="sharpMail" type="text" value="" size="20" maxlength="30" style="ime-mode: disabled;"/> ex)법인사업자 : 대표#unpamsbank.법인, 개인사업자 : 대표#unpamsbank.사업</td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="80">주소</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="postAddrNum" name="postAddrNum" type="text" value="" size="7" maxlength="7" onkeydown="return onlyNumber(event)" class="input_text_none" disabled="disabled" />
                        <a href="#"> <img id="btnPost" name="btnPost" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search'
                              style="vertical-align: middle; border: 0px;" />
                        </a>
                        <input id="addres" name="addres" type="text" value="" size="56" maxlength="50" class="input_text_none" disabled="disabled" />
                     </td>
                     <td class="table_td_subject" width="80">상세주소</td>
                     <td class="table_td_contents">
                        <input id="addresDesc" name="addresDesc" type="text" value="" size="20" maxlength="30" style="width: 98%" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="80">팩스번호</td>
                     <td class="table_td_contents">
                        <input id="faxNum" name="faxNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)" />
                     </td>
                     <td class="table_td_subject" width="80">참고사항</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="refereceDesc" name="refereceDesc" type="text" value="" size="20" maxlength="30" style="width: 98%" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>

                  <tr>
                     <td class="table_td_subject9" width="80">
						사업자등록첨부<br/><a href="#"> 
						<img id="btnBizRegAttach" name="btnBizRegAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                        </a>
                     </td>
                     <td class="table_td_contents" colspan="2">
                        <input type="hidden" id="file_biz_reg_list" name="file_biz_reg_list" value="<%=file_biz_reg_list%>" />
                        <input type="hidden" id="attach_file_biz_reg_path" name="attach_file_biz_reg_path" value="<%=attach_file_biz_reg_path%>" />
                        <a href="javascript:fnAttachFileDownload(($('#attach_file_biz_reg_path').val()).replace(/\\/g,'\\\\'));"> <span id="attach_file_biz_reg_name"><%=attach_file_biz_reg_name%></span>
                        </a>
                     </td>
                     <td class="table_td_subject" width="80">
						신용평가서첨부 <br/><a href="#"> 
						<img id="btnAppSalAttach" name="btnAppSalAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                        </a>
                     </td>
                     <td class="table_td_contents" colspan="2">
                        <input type="hidden" id="file_app_sal_list" name="file_app_sal_list" value="<%=file_app_sal_list%>" />
                        <input type="hidden" id="attach_file_app_sal_path" name="attach_file_app_sal_path" value="<%=attach_file_app_sal_path%>" />
                        <a href="javascript:fnAttachFileDownload(($('#attach_file_app_sal_path').val()).replace(/\\/g,'\\\\'));"> <span id="attach_file_app_sal_name"><%=attach_file_app_sal_name%></span>
                        </a>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="80">
						 통장사본첨부<br/><a href="#"> 
						 <img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                        </a>
                     </td>
                     <td class="table_td_contents" colspan="2">
                        <input type="hidden" id="file_list1" name="file_list1" value="<%=file_list1%>" />
                        <input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1%>" />
                        <a href="javascript:fnAttachFileDownload(($('#attach_file_path1').val()).replace(/\\/g,'\\\\'));"> <span id="attach_file_name1"><%=attach_file_name1%></span>
                        </a>
                     </td>
                     <td class="table_td_subject" width="80">
						 기타첨부1<br/><a href="#"> 
						 <img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                        </a>
                     </td>
                     <td class="table_td_contents" colspan="2">
                        <input type="hidden" id="file_list2" name="file_list2" value="<%=file_list2%>" />
                        <input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2%>" />
                        <a href="javascript:fnAttachFileDownload(($('#attach_file_path2').val()).replace(/\\/g,'\\\\'));"> <span id="attach_file_name2"><%=attach_file_name2%></span>
                        </a>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="80">
						 기타첨부2<br/><a href="#"> 
						 <img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                        </a>
                     </td>
                     <td colspan="5" class="table_td_contents">
                        <input type="hidden" id="file_list3" name="file_list3" value="<%=file_list3%>" />
                        <input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3%>" />
                        <a href="javascript:fnAttachFileDownload(($('#attach_file_path3').val()).replace(/\\/g,'\\\\'));"> <span id="attach_file_name3"><%=attach_file_name3%></span>
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
                           	List<CodesDto> areaCode = (List<CodesDto>) request
                           			.getAttribute("areaCode");
                           	for (CodesDto areaCd : areaCode) {
                           %>
                           <option value="<%=areaCd.getCodeVal1()%>"><%=areaCd.getCodeNm1()%></option>
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
                     <td width="20" valign="top">
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
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">결제조건</td>
                     <td class="table_td_contents">
                        <select class="select" id="payBillType" name="payBillType" disabled="disabled">
<!-- 							<option value="">선택하세요</option> -->
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> payCondCode = (List<CodesDto>) request.getAttribute("payCondCode");
	for (CodesDto payCondCd : payCondCode) {
		if (payCondCd.getCodeVal1().equals("1030")) {
%>
                           <option value="<%=payCondCd.getCodeVal1()%>"><%=payCondCd.getCodeNm1()%></option>
<%
	    }
	}
%>
                        </select>
<!--                         <input id="payBillDay" name="payBillDay" type="text" value="30" size="20" maxlength="2" style="width: 20px" disabled="disabled" onkeydown="return onlyNumber(event)" />일 -->
                     </td>
                     <td class="table_td_subject9" width="100">회계담당자명</td>
                     <td class="table_td_contents">
                        <input id="accountManagerNm" name="accountManagerNm" type="text" value="" size="20" maxlength="30" style="width: 98%" />
                     </td>
                     <td class="table_td_subject9" width="100">회계이동전화</td>
                     <td class="table_td_contents">
                        <input id="accountTelNum" name="accountTelNum" type="text" value="" size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)" />
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
                           	List<CodesDto> bankCode = (List<CodesDto>) request
                           			.getAttribute("bankCode");
                           	for (CodesDto bankCd : bankCode) {
                           %>
                           <option value="<%=bankCd.getCodeVal1()%>"><%=bankCd.getCodeNm1()%></option>
                           <%
                           	}
                           %>
                        </select>
                     </td>
                     <td class="table_td_subject9" width="100">예금주명</td>
                     <td class="table_td_contents">
                        <input id="recipient" name="recipient" type="text" value="" size="20" maxlength="30" style="width: 98%" />
                     </td>
                     <td class="table_td_subject9" width="100">계좌번호</td>
                     <td class="table_td_contents">
                        <input id="accountNum" name="accountNum" type="text" value="" size="15" maxlength="20" onkeydown="return onlyNumber(event)" />
                        (-없이)
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
                     <td width="20" valign="top">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">담당자 정보</td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <!-- 컨텐츠 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="4" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">로그인ID</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="loginId" name="loginId" type="text" value="" size="40" maxlength="50" style="ime-mode: disabled;" onkeydown="return fnDupCheck(event)" />
                        <a href="#"> <img id="loginIdConfirm" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_check.gif" width="75" height="18" class='icon_search'
                              style="border: 0px; vertical-align: middle;" />
                        </a>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">비밀번호</td>
                     <td class="table_td_contents">
                        <input id="pwd" name="pwd" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;" />
                     </td>
                     <td class="table_td_subject9" width="100">비밀번호 확인</td>
                     <td class="table_td_contents">
                        <input id="pwdConfirm" name="pwdConfirm" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">성명</td>
                     <td class="table_td_contents">
                        <input id="userNm" name="userNm" type="text" value="" size="20" maxlength="30" />
                     </td>
                     <td class="table_td_subject9" width="100">전화번호</td>
                     <td class="table_td_contents">
                        <input id="tel" name="tel" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">이동전화번호</td>
                     <td class="table_td_contents">
                        <input id="mobile" name="mobile" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)" />
                     </td>
                     <td class="table_td_subject9" width="100">이메일</td>
                     <td class="table_td_contents">
                        <input id="userEmail" name="userEmail" type="text" value="" size="20" maxlength="30" style="ime-mode: disabled;" />
                        ex)admin@unpamsbank.com
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" class="table_top_line"></td>
                  </tr>
               </table>
               <!-- 컨텐츠 끝 -->
               <div id="dialog" title="Feature not supported" style="display: none;">
                  <p>That feature is not supported.</p>
               </div>
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
                     <td width="20" valign="top">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">전자세금계산서 정보</td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>         
         <tr>
            <td>
               <!-- 컨텐츠 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="4" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">세금계산서 ID</td>
                     <td class="table_td_contents">
                        <input id="trustBillUserId" name="trustBillUserId" type="text" value="" size="20" maxlength="30" />
                     </td>
                     <td class="table_td_subject" width="100">이름</td>
                     <td class="table_td_contents">
                        <input id="trustBillUserNm" name="trustBillUserNm" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumber(event)" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">전화번호</td>
                     <td class="table_td_contents">
                        <input id="trustBillUserTel" name="trustBillUserTel" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)" />
                     </td>
                     <td class="table_td_subject" width="100">이메일</td>
                     <td class="table_td_contents">
                        <input id="trustBillUserEmail" name="trustBillUserEmail" type="text" value="" size="20" maxlength="30" style="ime-mode: disabled;" />
                        ex)admin@unpamsbank.com
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" class="table_top_line"></td>
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
                     <td width="20" valign="top">
                        <img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">권한정보</td>
                     <td width="50" class="stitle" style="vertical-align: middle;">
                        <a href="#"> 
                           <img id="roleAddButton" name="roleAddButton" src="/img/system/btn_icon_plus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;" />
                        </a> 
                        <a href="#"> 
                           <img id="roleDelButton" name="roleDelButton" src="/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;" />
                        </a>
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <div id="jqgrid">
                  <table id="list"></table>
               </div>
            </td>
         </tr>
         <tr>
            <td>&nbsp;</td>
         </tr>
         <tr>
            <td align="center">
               <a href="#">
                  <img id="btnSave" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_save.gif" width="65" height="23" style="border: 0px; vertical-align: middle;" />
               </a> 
               <a href="#"> 
                  <img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style="border: 0px; vertical-align: middle;" />
               </a>
            </td>
         </tr>
         <tr>
            <td>
               <br></br>
            </td>
         </tr>
      </table>
   </form>
</div>
</body>
</html>