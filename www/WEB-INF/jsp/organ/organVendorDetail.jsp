<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpVendorsDto"%>
<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%
	LoginUserDto        userInfoDto              = CommonUtils.getLoginUserDto(request);
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList                 = (List<ActivitiesDto>) request.getAttribute("useActivityList"); //화면권한가져오기(필수)
	List<LoginRoleDto>  loginRoleList            = userInfoDto.getLoginRoleList();
	LoginRoleDto        loginRoleDto             = null;
	SmpVendorsDto       detailInfo               = (SmpVendorsDto)request.getAttribute("detailInfo");
	String              listHeight               = "$(window).height()-215 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
	String              file_biz_reg_list        = detailInfo.getBusinessAttachFileSeq() == null ? "" : detailInfo.getBusinessAttachFileSeq();
	String              file_app_sal_list        = detailInfo.getAppraisalAttachFileSeq() == null ? "" : detailInfo.getAppraisalAttachFileSeq();
	String              file_list1               = detailInfo.getEtcFirstAttachSeq() == null ? "" : detailInfo.getEtcFirstAttachSeq();
	String              file_list2               = detailInfo.getEtcSecondAttachSeq() == null ? "" : detailInfo.getEtcSecondAttachSeq();
	String              file_list3               = detailInfo.getEtcThirdAttachSeq() == null ? "" : detailInfo.getEtcThirdAttachSeq();
	String              attach_file_biz_reg_name = detailInfo.getBusinessAttachFileNm() == null ? "" : detailInfo.getBusinessAttachFileNm();
	String              attach_file_app_sal_name = detailInfo.getAppraisalAttachFileNm() == null ? "" : detailInfo.getAppraisalAttachFileNm();
	String              attach_file_name1        = detailInfo.getEtcFirstAttachNm() == null ? "" : detailInfo.getEtcFirstAttachNm();
	String              attach_file_name2        = detailInfo.getEtcSecondAttachNm() == null ? "" : detailInfo.getEtcSecondAttachNm();
	String              attach_file_name3        = detailInfo.getEtcThirdAttachNm() == null ? "" : detailInfo.getEtcThirdAttachNm();
	String              attach_file_biz_reg_path = detailInfo.getBusinessAttachFilePath() == null ? "" : detailInfo.getBusinessAttachFilePath();
	String              attach_file_app_sal_path = detailInfo.getAppraisalAttachFilePath() == null ? "" : detailInfo.getAppraisalAttachFilePath();
	String              attach_file_path1        = detailInfo.getEtcFirstAttachPath()== null ? "" : detailInfo.getEtcFirstAttachPath();
	String              attach_file_path2        = detailInfo.getEtcSecondAttachPath()== null ? "" : detailInfo.getEtcSecondAttachPath();
	String              attach_file_path3        = detailInfo.getEtcThirdAttachPath()== null ? "" : detailInfo.getEtcThirdAttachPath();
	String              sharpMail                = detailInfo.getSharp_mail() == null ? "" : detailInfo.getSharp_mail();
	String              file_list4               = detailInfo.getEtcFourthAttachSeq() == null ? "" : detailInfo.getEtcFourthAttachSeq();
	String              attach_file_name4        = detailInfo.getEtcFourthAttachNm() == null ? "" : detailInfo.getEtcFourthAttachNm();
	String              attach_file_path4        = detailInfo.getEtcFourthAttachPath()== null ? "" : detailInfo.getEtcFourthAttachPath();
	String              loginRoleDtoRoleCd       = null;
	boolean             roleCd                   = false;
	int                 loginRoleListSize        = 0;
	
	if(loginRoleList != null){
		loginRoleListSize = loginRoleList.size();
	}
	
	for(int i = 0; i < loginRoleListSize; i++){
		loginRoleDto       = loginRoleList.get(i);
		loginRoleDtoRoleCd = loginRoleDto.getRoleCd();
		
		if("MRO_ADMIN002".equals(loginRoleDtoRoleCd) || "ADM_ACC_MAN".equals(loginRoleDtoRoleCd)){
			roleCd = true;
		}
	}
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
   venDisabled();
   admDisabled();
});


function fnJqmAddRole() {
   fnJqmAddRoleListInit("VEN","fnAddRoleCallBack");
}

function fnRoleDel(){
   var rowid = $("#list").jqGrid('getGridParam', "selrow" );
   var selrowContent = jq("#list").jqGrid('getRowData',rowid);

      if(rowid == null){
      $("#dialog").html("<font size='2'>삭제할 항목을 선택해주세요.</font>");
         $("#dialog").dialog({
         title: 'fail',modal: true,
            buttons: {"Ok": function(){$(this).dialog("close");} }
         });      
         return;
      }
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveUserRoles.sys", 
      { oper:'del', userId:selrowContent.userId, roleId:selrowContent.roleId, borgId:selrowContent.borgId },
      function(arg){
         if(fnAjaxTransResult(arg)) {
            jq("#list").trigger("reloadGrid");  
         }
      }
   );
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
   $("#btnAttach3").click(function(){ fnUploadDialog("회사소개서", $("#file_list3").val(), "fnCallBackAttach3"); });
   $("#btnAttach4").click(function(){ fnUploadDialog("기타첨부2", $("#file_list4").val(), "fnCallBackAttach4"); });
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
 * 첨부파일4 파일관리
 */
function fnCallBackAttach4(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list4").val(rtn_attach_seq);
	$("#attach_file_name4").text(rtn_attach_file_name);
	$("#attach_file_path4").val(rtn_attach_file_path);
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
     

 	//전화번호 형식으로 변경
 	$("#phoneNum").val( fnSetTelformat( $("#phoneNum").val() ) );
 	$("#faxNum").val( fnSetTelformat( $("#faxNum").val() ) );
 	$("#accountTelNum").val( fnSetTelformat( $("#accountTelNum").val() ) );
 	$("#trustBillUserTel").val( fnSetTelformat( $("#trustBillUserTel").val() ) );
     
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
       var trustBillUserEmail = $.trim($("#trustBillUserEmail").val());
       
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

		return true;
	}
 
	function fnSave(){
		if(fnIsValidation()){
			if(!confirm("수정한 내용을 저장하시겠습니까?")) return;
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveVendorReg.sys", 
				{
					oper:"upd",
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
					isUse:$.trim($("#isUse").val()),
					vendorId:$.trim($("#vendorId").val()),
					trustBillUserId:$.trim($("#trustBillUserId").val()),
					trustBillUserNm:$.trim($("#trustBillUserNm").val()),
					trustBillUserEmail:$.trim($("#trustBillUserEmail").val()),
					trustBillUserTel:$.trim($("#trustBillUserTel").val()),
					sharpMail:$.trim($("#sharpMail").val()),
					file_list4:$.trim($("#file_list4").val())
				},
				function(arg){ 
					if(fnAjaxTransResult(arg)) {  //성공시
						try{
							window.opener.fnSearch();
						}
						catch(e){}
						
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
			{
				loginId:$("#loginId").val() 
			},
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

/**
 * 공급사의 경우 정보수정 안되게
 */
function venDisabled(){
	var svcTypeCd = "<%=userInfoDto.getSvcTypeCd()%>";
	
	if(svcTypeCd == "VEN"){
		$("#vendorNm").attr("disabled", true);//공급사명
		$("#businessNum1").attr("disabled", true);//사업자등록번호1
		$("#businessNum2").attr("disabled", true);//사업자등록번호2
		$("#businessNum3").attr("disabled", true);//사업자등록번호3
		$("#registNum1").attr("disabled", true);//법인등록번호1
		$("#registNum2").attr("disabled", true);//법인등록번호2
		$("#vendorBusiType").attr("disabled", true);//업종
		$("#vendorBusiClas").attr("disabled", true);//업태
		$("#pressentNm").attr("disabled", true);//대표자명
		$("#btnBizRegAttach").hide();//사업자등록첨부
		$("#btnAttach1").hide();//통장사본첨부
		$("#isUse").attr("disabled", true);//사용여부
		$("#payBillType").attr("disabled", true);//결제조건
	}
}

/**
 * 운영사의 경우의 회계운영자와 파워운영담당자만 수정가능하게 처리
 */
function admDisabled(){
	var roleCd = <%=roleCd%>;
	
	if(!roleCd){
		$("#vendorNm").attr("disabled", true);//공급사명
		$("#businessNum1").attr("disabled", true);//사업자등록번호1
		$("#businessNum2").attr("disabled", true);//사업자등록번호2
		$("#businessNum3").attr("disabled", true);//사업자등록번호3
		$("#registNum1").attr("disabled", true);//법인등록번호1
		$("#registNum2").attr("disabled", true);//법인등록번호2
		$("#vendorBusiType").attr("disabled", true);//업종
		$("#vendorBusiClas").attr("disabled", true);//업태
		$("#pressentNm").attr("disabled", true);//대표자명
		$("#btnBizRegAttach").hide();//사업자등록첨부
		$("#btnAttach1").hide();//통장사본첨부
		$("#isUse").attr("disabled", true);//사용여부
	}
}
</script>

</head>
<body>
<form id="frm" name="frm" method="post" onsubmit="return false;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>공급사상세</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
				<tr>
					<td width="20" valign="top">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
					</td>
					<td class="stitle">공급사 일반정보</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<col width="13%"></col>   
				<col width="37%"></col>
				<col width="13%"></col>
				<col width="37%"></col>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="80">공급사명</td>
					<td colspan="5" class="table_td_contents">
						<input id="vendorNm" name="vendorNm" type="text"   value="<%=detailInfo.getVendorNm() %>" style="width:90%" maxlength="50" />
						<input id="vendorId" name="vendorId" type="hidden" value="<%=detailInfo.getVendorId() %>"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					 <td class="table_td_subject9" width="100">사업자등록번호</td>
					<td class="table_td_contents">
						<input id="businessNum1" name="businessNum1" type="text" value="<%=detailInfo.getBusinessNum().substring(0, 3) %>" style="width:20%" maxlength="3" onkeydown="return onlyNumber(event)" />
						-
						<input id="businessNum2" name="businessNum2" type="text" value="<%=detailInfo.getBusinessNum().substring(3, 5) %>" style="width:10%" maxlength="2" onkeydown="return onlyNumber(event)" />
						-
						<input id="businessNum3" name="businessNum3" type="text" value="<%=detailInfo.getBusinessNum().substring(5) %>" style="width:30%" maxlength="5" onkeydown="return onlyNumber(event)" />
					</td>
					<td class="table_td_subject" width="80">법인등록번호</td>
<%
	String registNum = CommonUtils.getString(detailInfo.getRegistNum());
	String registNum1 = "";
	String registNum2 = "";
	if(registNum.length() > 10) {
		registNum = registNum.replace("-", "");    
		registNum1 = registNum.substring(0, 6) ;
		registNum2 = registNum.substring(6) ;
	}
%>
					<td class="table_td_contents">
						<input id="registNum1" name="registNum1" type="text" value="<%=CommonUtils.getString(registNum1) %>" style="width:45%" maxlength="6" onkeydown="return onlyNumber(event)" />
						-
						<input id="registNum2" name="registNum2" type="text" value="<%=CommonUtils.getString(registNum2 )%>" style="width:45%" maxlength="7" onkeydown="return onlyNumber(event)" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="80">업종</td>
					<td class="table_td_contents">
						<input id="vendorBusiType" name="vendorBusiType" type="text" value="<%=detailInfo.getVendorBusiType() %>" style="width:90%" maxlength="30"  />
					</td>
					<td class="table_td_subject9" width="80">업태</td>
					<td class="table_td_contents">
						<input id="vendorBusiClas" name="vendorBusiClas" type="text" value="<%=detailInfo.getVendorBusiClas() %>" style="width:90%" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="80">대표자명</td>
					<td class="table_td_contents">
						<input id="pressentNm" name="pressentNm" type="text" value="<%=detailInfo.getPressentNm() %>" style="width:90%" maxlength="30"/>
					</td>
					<td class="table_td_subject9" width="80">대표전화번호</td>
					<td class="table_td_contents">
						<input id="phoneNum" name="phoneNum" type="text" value="<%=detailInfo.getPhoneNum() %>" style="width:90%" maxlength="15" onkeydown="return onlyNumberForSum(event)" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="80">회사이메일</td>
					<td class="table_td_contents">
						<input id="eMail" name="eMail" type="text" value="<%=detailInfo.getE_mail() %>" size="28" maxlength="30" style="ime-mode: disabled;" /> ex)admin@unpamsbank.com
					</td>
					<td class="table_td_subject" width="80">주요상품</td>
					<td class="table_td_contents">
						<input id="homePage" name="homePage" type="text" value="<%=CommonUtils.getString(detailInfo.getHomePage())%>" style="width:90%" maxlength="30" style="ime-mode: disabled;" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">회사샵(#)메일000</td>
					<td colspan="3" class="table_td_contents">
						<input id="sharpMail" name="sharpMail" type="text" value="<%=sharpMail %>" size="50" maxlength="30" style="ime-mode: disabled;"/>
						ex)법인사업자 : 대표#unpamsbank.법인, 개인사업자 : 대표#unpamsbank.사업
						<button class="btn btn-darkgray btn-xs" onclick="window.open('https://www.docusharp.com/member/join.jsp')">회원가입하기</button>
						</td>
					</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="80">주소</td>
					<td colspan="3" class="table_td_contents">
						<input id="postAddrNum" name="postAddrNum" type="text" value="<%=detailInfo.getPostAddrNum() %>" style="width:10%" maxlength="7" onkeydown="return onlyNumberForSum(event)"/>
						<a href="#"> 
							<img id="btnPost" name="btnPost" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search'style="vertical-align: middle; border: 0px;" />
						</a>
						<input id="addres" name="addres" type="text" value="<%=detailInfo.getAddres() %>" style="width:76%" maxlength="50" class="input_text_none" disabled="disabled" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="80">상세주소</td>
					<td class="table_td_contents" colspan="3">
						<input id="addresDesc" name="addresDesc" type="text" value="<%=CommonUtils.getString(detailInfo.getAddresDesc()) %>" style="width:90%" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="80">팩스번호</td>
					<td class="table_td_contents">
						<input id="faxNum" name="faxNum" type="text" value="<%=CommonUtils.getString(detailInfo.getFaxNum()) %>" style="width:90%" maxlength="15" onkeydown="return onlyNumberForSum(event)" />
					</td>
					<td class="table_td_subject9" width="80">구분</td>
					<td class="table_td_contents">
						<input type="text" id="" name="" style="width:90%"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="80">참고사항</td>
					<td colspan="3" class="table_td_contents">
						<input id="refereceDesc" name="refereceDesc" type="text" value="<%=CommonUtils.getString(detailInfo.getRefereceDesc()) %>" style="width:90%" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="80">사업자등록첨부</td>
					<td class="table_td_contents">
						<a href="#"> 
 							<img id="btnBizRegAttach" name="btnBizRegAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
						<input type="hidden" id="file_biz_reg_list" name="file_biz_reg_list" value="<%=file_biz_reg_list%>" />
						<input type="hidden" id="attach_file_biz_reg_path" name="attach_file_biz_reg_path" value="<%=attach_file_biz_reg_path%>" />
						<a href="javascript:fnAttachFileDownload(($('#attach_file_biz_reg_path').val()).replace(/\\/g,'\\\\'));"> 
							<span id="attach_file_biz_reg_name"><%=attach_file_biz_reg_name%></span>
						</a>
					</td>
					<td class="table_td_subject9" width="80">신용평가서첨부</td>
					<td class="table_td_contents">
						<a href="#"> 
							<img id="btnAppSalAttach" name="btnAppSalAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
						<input type="hidden" id="file_app_sal_list" name="file_app_sal_list" value="<%=file_app_sal_list%>" />
						<input type="hidden" id="attach_file_app_sal_path" name="attach_file_app_sal_path" value="<%=attach_file_app_sal_path%>" />
						<a href="javascript:fnAttachFileDownload(($('#attach_file_app_sal_path').val()).replace(/\\/g,'\\\\'));"> 
							<span id="attach_file_app_sal_name"><%=attach_file_app_sal_name%></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="80">통장사본첨부</td>
					<td class="table_td_contents">
						<a href="#"> 
							<img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
						<input type="hidden" id="file_list1" name="file_list1" value="<%=file_list1%>" />
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1%>" />
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path1').val()).replace(/\\/g,'\\\\'));"> 
							<span id="attach_file_name1"><%=attach_file_name1%></span>
						</a>
					</td>
					<td class="table_td_subject9" width="80">회사소개서</td>
					<td class="table_td_contents">
						<a href="#"> 
							<img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
						<input type="hidden" id="file_list3" name="file_list3" value="<%=file_list3%>" />
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3%>" />
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path3').val()).replace(/\\/g,'\\\\'));"> 
							<span id="attach_file_name3"><%=attach_file_name3%></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="80">기타첨부1</td>
					<td class="table_td_contents" >
						<a href="#"> 
							<img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
						<input type="hidden" id="file_list2" name="file_list2" value="<%=file_list2%>" />
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2%>" />
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path2').val()).replace(/\\/g,'\\\\'));"> 
							<span id="attach_file_name2"><%=attach_file_name2%></span>
						</a>
					</td>
					<td class="table_td_subject" width="80">기타첨부2</td>
					<td class="table_td_contents">
						<a href="#"> 
							<img id="btnAttach4" name="btnAttach4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
						<input type="hidden" id="file_list4" name="file_list4" value="<%=file_list4%>" />
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=attach_file_path4%>" />
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path4').val()).replace(/\\/g,'\\\\'));"> 
							<span id="attach_file_name4"><%=attach_file_name4%></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">소재지</td>
					<td class="table_td_contents">
						<select class="select" id="areaType" name="areaType">
							<option value="">선택하세요</option>
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> areaCode = (List<CodesDto>) request.getAttribute("areaCode");
	for (CodesDto areaCd : areaCode) {
%>
							<option value="<%=areaCd.getCodeVal1()%>" <%=CommonUtils.getString(detailInfo.getAreaType()).equals(areaCd.getCodeVal1()) ? "selected" : "" %>><%=areaCd.getCodeNm1()%></option>
<%
   }
%>
						</select>
					</td>
					<td class="table_td_subject" width="100">사용여부</td>
					<td class="table_td_contents">
						<select class="select" id="isUse" name="isUse">
							<option value="1" <%=CommonUtils.getString(detailInfo.getIsUse()).equals("1") ? "selected" : "" %> >정상</option>
							<option value="0" <%=CommonUtils.getString(detailInfo.getIsUse()).equals("0") ? "selected" : "" %>>종료</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">기본계약일</td>
					<td class="table_td_contents">
                     	<%= CommonUtils.getString(detailInfo.getFirstContractDate()) %>
                     	<%if(detailInfo.getFirstContractVersion() != null && "".equals(detailInfo.getFirstContractVersion()) == false ) { out.print("(<b>"+detailInfo.getFirstContractVersion()+"</b>)"); }%>
					</td>
					<td class="table_td_subject" width="100">개인정보제공동의일</td>
					<td class="table_td_contents">
                     	<%= CommonUtils.getString(detailInfo.getBasicContractDate()) %>
                     	<%if(detailInfo.getBasicContractVersion() != null && "".equals(detailInfo.getBasicContractVersion()) == false ) { out.print("(<b>"+detailInfo.getBasicContractVersion()+"</b>)"); }%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">품질계약일</td>
					<td class="table_td_contents">
                     	<%= CommonUtils.getString(detailInfo.getIndividualContractDate()) %>
                     	<%if(detailInfo.getIndividualContractVersion() != null && "".equals(detailInfo.getIndividualContractVersion()) == false ) { out.print("(<b>"+detailInfo.getIndividualContractVersion()+"</b>)"); }%>
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
				<col width="13%"></col>   
				<col width="37%"></col>
				<col width="13%"></col>
				<col width="37%"></col>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">결제조건</td>
					<td class="table_td_contents">
						<select class="select" id="payBillType" name="payBillType" >
							<option value="">선택하세요</option>
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> payCondCode = (List<CodesDto>) request.getAttribute("payCondCode");
	for (CodesDto payCondCd : payCondCode) {

%>
							<option value="<%=payCondCd.getCodeVal1()%>" <%=CommonUtils.getString(detailInfo.getPayBilltype()).equals(payCondCd.getCodeVal1()) ? "selected" : "" %>>
								<%=payCondCd.getCodeNm1()%>
							</option>
<%
	}
%>
						</select>
<%--                         <input id="payBillDay" name="payBillDay" type="text" value="<%= CommonUtils.getString(detailInfo.getPayBillDay()) %>" size="20" maxlength="2" style="width: 20px" onkeydown="return onlyNumber(event)" />일 --%>
					</td>
					<td class="table_td_subject9" width="100">회계담당자명</td>
					<td class="table_td_contents">
						<input id="accountManagerNm" name="accountManagerNm" type="text" value="<%=detailInfo.getAccountManageNm() %>" style="width:90%" maxlength="30"  />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">회계이동전화</td>
					<td class="table_td_contents">
						<input id="accountTelNum" name="accountTelNum" type="text" value="<%=detailInfo.getAccountTelNum() %>" style="width:90%" maxlength="30" onkeydown="return onlyNumberForSum(event)" />
					</td>
					<td class="table_td_subject9" width="100">은행코드</td>
					<td class="table_td_contents">
						<select class="select" id="bankCd" name="bankCd">
							<option value="">선택하세요</option>
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> bankCode = (List<CodesDto>) request.getAttribute("bankCode");
	for (CodesDto bankCd : bankCode) {
%>
							<option value="<%=bankCd.getCodeVal1()%>" <%=CommonUtils.getString(detailInfo.getBankCd()).equals(bankCd.getCodeVal1()) ? "selected" : "" %>>
								<%=bankCd.getCodeNm1()%>
							</option>
<%
	}
%>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">예금주명</td>
					<td class="table_td_contents">
						<input id="recipient" name="recipient" type="text" value="<%=detailInfo.getRecipient() %>" style="width:90%" maxlength="30"  />
					</td>
					<td class="table_td_subject9" width="100">계좌번호</td>
					<td class="table_td_contents">
						<input id="accountNum" name="accountNum" type="text" value="<%=detailInfo.getAccountNum() %>" style="width:85%" maxlength="20" onkeydown="return onlyNumber(event)" />
						(-없이)
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
				<col width="13%"></col>   
				<col width="37%"></col>
				<col width="13%"></col>
				<col width="37%"></col>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">세금계산서 ID</td>
					<td class="table_td_contents" >
						<input id="trustBillUserId" name="trustBillUserId" type="text" value="<%=CommonUtils.getString(detailInfo.getTrustBillUserId()) %>" style="width:90%" maxlength="30" />
					</td>
					<td class="table_td_subject" width="100">이름</td>
					<td class="table_td_contents">
						<input id="trustBillUserNm" name="trustBillUserNm" type="text" value="<%=CommonUtils.getString(detailInfo.getTrustBillUserNm()) %>" style="width:90%" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">전화번호</td>
					<td class="table_td_contents" >
						<input id="trustBillUserTel" name="trustBillUserTel" type="text" value="<%=CommonUtils.getString(detailInfo.getTrustBillUserTel()) %>" style="width:90%" maxlength="30" onkeydown="return onlyNumberForSum(event)" />
					</td>
					<td class="table_td_subject" width="100">이메일</td>
					<td class="table_td_contents">
						<input id="trustBillUserEmail" name="trustBillUserEmail" type="text" value="<%=CommonUtils.getString(detailInfo.getTrustBillUserEmail()) %>" style="width:50%" maxlength="30" style="ime-mode: disabled;" />
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
		<td align="center">
			<button id='btnSave' class="btn btn-darkgray btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
				<i class="fa fa-floppy-o"></i> 저장
			</button> 
			<button id='btnClose' class="btn btn-default btn-sm" onclick="javaScript:window.close();"><i class="fa fa-remove"></i> 닫기</button>
		</td>
	</tr>
</table>
</form>
</body>
</html>