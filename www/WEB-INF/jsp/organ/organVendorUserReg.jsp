<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
   LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
   //그리드의 width와 Height을 정의
   String listHeight = "50";

   @SuppressWarnings("unchecked")   //화면권한가져오기(필수)
   List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
   
   String      borgId   = (String)request.getAttribute("borgId");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<%
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp" %>
<!-- 공급사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcVendorId = "";
	String _srcVendorName = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	if("VEN".equals(loginUserDto.getSvcTypeCd())) {
		_srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
		_srcVendorId = _srcBorgScopeByRoleDto.getSrcBranchId();
		_srcVendorName = _srcBorgScopeByRoleDto.getSrcBorgNms();
	}
%>
	$("#vendorNm").val("<%=_srcVendorName %>");
	$("#borgId").val("<%=_srcVendorId %>");
<%	if("VEN".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#vendorNm").attr("disabled", true);
	$("#srcVendorBtn").css("display","none");
<%	}	%>
	
	$("#srcVendorBtn").click(function(){
		var vendorNm = $("#vendorNm").val();
		fnVendorDialog(vendorNm, "fnCallBackVendor"); 
	});
	$("#vendorNm").keydown(function(e){ if(e.keyCode==13) { $("#srcVendorBtn").click(); } });
	$("#vendorNm").change(function(e){
		if($("#vendorNm").val()=="") {
			$("#borgId").val("");
		}
	});
});	
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackVendor(vendorId, vendorNm, areaType) {
	$("#borgId").val(vendorId);
	$("#vendorNm").val(vendorNm);
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
   $("#srcUserNm").keydown(function(e){
      if(e.keyCode==13) {
         $("#srcButton").click();
      }
   });

   $("#saveButton").click(function(){
      fnApply();
   });   
   $("#loginIdConfirm").click( function() {
	  fnLoginIdConfirm(); 
   });   
   $("#loginId").keydown(function(e){ 
	  if(e.keyCode==13) { 
		  $("#loginIdConfirm").click(); 
	  } 
   });   

	//기본적으로 사용자 등록시 SMS 발송이 기본이 되도록. 옵션도 모두 다 체크.
	$("#smsByPurchaseOrder").val("1");
	$("#smsByOrdrtReceive").val("1");
	$("#smsByNotiAuction").val("1");               
	$("#smsByNotiSuccessBid").val("1");               
	
	$("#smsByPurchaseOrder").attr("checked", true);
	$("#smsByOrdrtReceive").attr("checked", true);
	$("#smsByNotiAuction").attr("checked", true);             
	$("#smsByNotiSuccessBid").attr("checked", true);
});

function fnIsValidation(){
	var branchId = $.trim($("#borgId").val());
	var userNm = $.trim($("#userNm").val());
	var loginId = $.trim($("#loginId").val());
	var pwd = $.trim($("#pwd").val());
	var pwdConfirm = $.trim($("#pwdConfirm").val());
	var tel = $.trim($("#tel").val());
	var mobile = $.trim($("#mobile").val());
	var eMail = $.trim($("#eMail").val());
	var isUse = $.trim($("#isUse").val());
	var roleCnt = $("#list").getGridParam('reccount');
	
	if(branchId == ""){
		 $("#dialog").html("<font size='2'>사업장을 선택해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }

	 if(userNm == ""){
		 $("#dialog").html("<font size='2'>성명을 입력해주세요.</font>");
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
	
	 if(!isLoginIdCheck){
		 $("#dialog").html("<font size='2'>로그인ID 중복체크가 필요합니다.</font>");
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

	 if(tel == ""){
		 $("#dialog").html("<font size='2'>전화번호를 입력해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }

	 if(mobile == ""){
		 $("#dialog").html("<font size='2'>이동전화번호를 입력해주세요.</font>");
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
	 
	 if(isUse == ""){
		 $("#dialog").html("<font size='2'>상태를 선택해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }	 
	 
	 if(roleCnt == 0) {
		 $("#dialog").html("<font size='2'>1개 이상의 권한을 설정해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;		 
	 }
	 
	return true;
}

function fnApply(){
	var isValidation = fnIsValidation();
	if(isValidation == true){
		if(!confirm("작성한 내용을 저장하시겠습니까?")) return;
	    $.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveUserDetail.sys", 
		{  
			oper:"add",
	        borgId:$.trim($("#borgId").val()),
	        userId:$.trim($("#userId").val()),
	        userNm:$.trim($("#userNm").val()),
	        loginId:$.trim($("#loginId").val()),
	        pwd:$.trim($("#pwd").val()),
	        tel:$.trim($("#tel").val()),
	        mobile:$.trim($("#mobile").val()),
	        eMail:$.trim($("#eMail").val()),
	        isUse:$.trim($("#isUse").val()),
	        endCauseDesc:$.trim($("#endCauseDesc").val()),
	        userNote:$.trim($("#userNote").val()),
	         
	         
			isEmail:$.trim($("#isEmail").val()),
            isSms:$.trim($("#isSms").val()),
            emailByPurchaseOrder:$.trim($("#emailByPurchaseOrder").val()),
            emailByOrdrtReceive:$.trim($("#emailByOrdrtReceive").val()),
            emailByNotiAuction:$.trim($("#emailByNotiAuction").val()),
            emailByNotiSuccessBid:$.trim($("#emailByNotiSuccessBid").val()),
            smsByPurchaseOrder:$.trim($("#smsByPurchaseOrder").val()),
            smsByOrdrtReceive:$.trim($("#smsByOrdrtReceive").val()),
            smsByNotiAuction:$.trim($("#smsByNotiAuction").val()),         
            smsByNotiSuccessBid:$.trim($("#smsByNotiSuccessBid").val()),
            roleIdArr: new Array('13087'),  
	      	isDefaultArr: new Array('1')
	         
// 	         isEmail:"0",
// 	         isSms:"1",
	         
	         
//              emailByPurchaseOrder:"0",
//              emailByOrdrtReceive:"0",
//              emailByNotiAuction:"0",
//              emailByNotiSuccessBid:"0",
//              smsByPurchaseOrder:"1",
//              smsByOrdrtReceive:"1",
//              smsByNotiAuction:"1",         
//              smsByNotiSuccessBid:"1",    
//              roleIdArr: new Array('13087'),  
// 	      	 isDefaultArr: new Array('1')
	      },
	      function(arg){
	         if(fnAjaxTransResult(arg)) {
// 					var opener = window.dialogArguments;
					window.opener.fnSearch();
					window.close();
	         }
	      }
	   ); 		
	} 	
}

var isLoginIdCheck = false;
function fnLoginIdConfirm(){
	if($.trim($("#loginId").val()) == ""){
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

function fnChangeChkValue(obj){
	var chgObj = "$('#" + obj + "')";
   
   	if(obj == "isEmail"){
    	if(eval(chgObj).val() == "0"){
        	$("#emailByPurchaseOrder").val("0");
         	$("#emailByOrdrtReceive").val("0");
         	$("#emailByNotiAuction").val("0");       
         	$("#emailByNotiSuccessBid").val("0");       
         
         	$("#emailByPurchaseOrder").attr("checked", false);
         	$("#emailByOrdrtReceive").attr("checked", false);
         	$("#emailByNotiAuction").attr("checked", false);           
         	$("#emailByNotiSuccessBid").attr("checked", false);           
      	} else {
      		$("#emailByPurchaseOrder").val("1");
         	$("#emailByOrdrtReceive").val("1");
         	$("#emailByNotiAuction").val("1");       
         	$("#emailByNotiSuccessBid").val("1");       
         
         	$("#emailByPurchaseOrder").attr("checked", true);
         	$("#emailByOrdrtReceive").attr("checked", true);
         	$("#emailByNotiAuction").attr("checked", true);           
         	$("#emailByNotiSuccessBid").attr("checked", true);	
      	}
   	}else if(obj == "isSms") {
    	if(eval(chgObj).val() == "0"){
        	$("#smsByPurchaseOrder").val("0");
         	$("#smsByOrdrtReceive").val("0");
         	$("#smsByNotiAuction").val("0");               
         	$("#smsByNotiSuccessBid").val("0");               

	        $("#smsByPurchaseOrder").attr("checked", false);
         	$("#smsByOrdrtReceive").attr("checked", false);
         	$("#smsByNotiAuction").attr("checked", false);             
         	$("#smsByNotiSuccessBid").attr("checked", false);             
      	} else {
        	$("#smsByPurchaseOrder").val("1");
         	$("#smsByOrdrtReceive").val("1");
         	$("#smsByNotiAuction").val("1");               
         	$("#smsByNotiSuccessBid").val("1");               

	        $("#smsByPurchaseOrder").attr("checked", true);
         	$("#smsByOrdrtReceive").attr("checked", true);
         	$("#smsByNotiAuction").attr("checked", true);             
         	$("#smsByNotiSuccessBid").attr("checked", true);             
      	}      
   	}

   	if(obj.indexOf("email") != -1) {
   		if(eval(chgObj).val()=="0") eval(chgObj).val("1");
  		else if(eval(chgObj).val()=="1") eval(chgObj).val("0");
      	
  		if($("#isEmail").val() == "0"){
      		$("#isEmail").val("1");
      	}else{
      		if($("#emailByPurchaseOrder").val() == "0" 
      		&& $("#emailByOrdrtReceive").val() == "0" 
      		&& $("#emailByNotiAuction").val() == "0" 
      		&& $("#emailByNotiSuccessBid").val() == "0"){
      			$("#isEmail").val("0");
      		}
      	}     
   	}else if(obj.indexOf("sms") != -1) {
   		if(eval(chgObj).val()=="0") eval(chgObj).val("1");
  		else if(eval(chgObj).val()=="1") eval(chgObj).val("0");
      	
  		if($("#isSms").val() == "0"){
      		$("#isSms").val("1");
      	}else{
      		if($("#smsByPurchaseOrder").val() == "0" 
      		&& $("#smsByOrdrtReceive").val() == "0" 
      		&& $("#smsByNotiAuction").val() == "0" 
      		&& $("#smsByNotiSuccessBid").val() == "0"){
      			$("#isSms").val("0");
      		}
      	}
   	}
}

</script>

</head>
<body>
   <form id="frm" name="frm" onsubmit="return false;">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
                     </td>
                     <td height="29" class='ptitle'>사용자 상세</td>
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
                        <img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">사용자 정보</td>
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
                     <td class="table_td_subject9">공급사</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="vendorNm" name="vendorNm" type="text" value="" size="" maxlength="50" style="width: 80%" class="input_text_none" disabled="disabled"/>
                        <input id="borgId" name="borgId" type="hidden" value="" size="" maxlength="50" style="width: 80%" class="input_text_none" />
                        <a href="#"> 
                           <img id="srcVendorBtn" name="srcVendorBtn" src="/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search'style="border: 0px; vertical-align: middle;" />
                        </a>                     
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9">성명</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="userId" name="userId" type="hidden" value="0" size="20" maxlength="30" />
                        <input id="userNm" name="userNm" type="text" value="" size="20" maxlength="30" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">아이디</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="loginId" name="loginId" type="text" value="" size="20" maxlength="30"/>
                        <a href="#">
                           <button id='loginIdConfirm' class="btn btn-darkgray btn-xs">중복확인</button>
                        </a>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">비밀번호</td>
                     <td class="table_td_contents">
                        <input id="pwd" name="pwd" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;"/>
                     </td>
                     <td class="table_td_subject9" width="100">비밀번호 확인</td>
                     <td class="table_td_contents">
                        <input id="pwdConfirm" name="pwdConfirm" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">전화번호</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="tel" name="tel" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">이동전화번호</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="mobile" name="mobile" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9">이메일</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="eMail" name="eMail" type="text" value="" size="30" maxlength="30" style="ime-mode: disabled;"/> ex)admin@unpamsbank.com
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9">상태</td>
                     <td colspan="3" class="table_td_contents">
                        <select class="select" id="isUse" name="isUse" disabled="disabled">
                           <option value="1"  selected="selected">정상</option>
                           <option value="0" >종료</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">참고사항</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="userNote" name="userNote" type="text" value="" size="20" maxlength="30" style="width: 98%" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
<%if(true){ //hidden 처리 %>
                  <tr>
                     <td class="table_td_subject">종료사유</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="endCauseDesc" name="endCauseDesc" type="text" value="" size="20" maxlength="30" style="width: 98%" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject"  >
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 15px;">
                           <tr>
                              <td width="50%">이메일 발송</td>
                              <td>&nbsp;</td>
                              <td>
                               	<select class="select" id="isEmail" name="isEmail" onchange="fnChangeChkValue('isEmail')">
                               		<option value="1" >발송</option>
                               		<option value="0" selected="selected">미발송</option>
                               	</select>
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td colspan="3" class="table_td_contents">  
                        <label>
                           <input id="emailByPurchaseOrder" name="emailByPurchaseOrder" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onchange="javaScript:fnChangeChkValue('emailByPurchaseOrder');"/> 발주의뢰
                        </label> 
                        <label>
                           <input id="emailByOrdrtReceive" name="emailByOrdrtReceive" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onchange="javaScript:fnChangeChkValue('emailByOrdrtReceive');"/> 인수확인
                        </label> 
                        <label>
                           <input id="emailByNotiAuction" name="emailByNotiAuction" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onchange="javaScript:fnChangeChkValue('emailByNotiAuction');"/> 입찰통보
                        </label> 
                        <label>
                           <input id="emailByNotiSuccessBid" name="emailByNotiSuccessBid" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onchange="javaScript:fnChangeChkValue('emailByNotiSuccessBid');"/> 낙찰통보
                        </label> 
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 15px;">
                           <tr>
                              <td width="50%">SMS 발송</td>
                              <td>&nbsp;</td>
                              <td>
                               	<select class="select" id="isSms" name="isSms" onchange="fnChangeChkValue('isSms')">
                               		<option value="1" selected="selected">발송</option>
                               		<option value="0">미발송</option>
                               	</select>
                              </td>
                           </tr>
                        </table>                          
                     </td>
                     <td colspan="3" class="table_td_contents">
                       <label>
                           <input id="smsByPurchaseOrder" name="smsByPurchaseOrder" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onchange="javaScript:fnChangeChkValue('smsByPurchaseOrder');"/> 발주의뢰
                        </label> 
                        <label>
                           <input id="smsByOrdrtReceive" name="smsByOrdrtReceive" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onchange="javaScript:fnChangeChkValue('smsByOrdrtReceive');"/> 인수확인
                        </label> 
                        <label>
                           <input id="smsByNotiAuction" name="smsByNotiAuction" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onchange="javaScript:fnChangeChkValue('smsByNotiAuction');"/> 입찰통보
                        </label> 
                        <label>
                           <input id="smsByNotiSuccessBid" name="smsByNotiSuccessBid" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onchange="javaScript:fnChangeChkValue('smsByNotiSuccessBid');"/> 낙찰통보
                        </label> 
                     </td>
                  </tr>
<%} %>
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
            <td align="center">
               <button id='saveButton' class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
               <button id='closeButton' class="btn btn-default btn-sm" onclick="javaScript:window.close();"><i class="fa fa-times"></i> 닫기</button>
            </td>
         </tr>
      </table>
      <div id="dialog" title="Feature not supported" style="display:none;">
         <p>That feature is not supported.</p>
      </div>      
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>처리할 데이터를 선택 하십시오!</p>
      </div>
      <%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp"%>
   </form>
</body>
</html>