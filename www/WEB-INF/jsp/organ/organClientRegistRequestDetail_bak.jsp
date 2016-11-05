<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@page import="kr.co.bitcube.common.dto.BorgDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpBranchsDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "65";
	
	String branchId   = (String)request.getAttribute("branchId");
	String clientId   = (String)request.getAttribute("clientId");
	String userRoleCd    = (String)request.getAttribute("userRoleCd");
	
	@SuppressWarnings("unchecked")   //화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	SmpBranchsDto detailDto =  (SmpBranchsDto)request.getAttribute("detailInfo");
	SmpUsersDto   userDto   =  (SmpUsersDto)request.getAttribute("userInfo");
	if(userRoleCd == null){
		userRoleCd ="";
	}
	String sharpMail = detailDto.getSharp_mail() == null ? "":detailDto.getSharp_mail();
	
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	String confirmorId = detailDto.getConfirmorId() == null ? userInfoDto.getUserNm() : detailDto.getConfirmorId();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
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

<%
/**------------------------------------배송처정보 사용방법---------------------------------
* fnDeliveryAddressDialog(callbackString) 을 호출하여 Div팝업을 Display ===
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(배송지명, 전화번호, 우편번호, 기본주소, 상세주소) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/deliveryAddressDiv.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
   $("#regButton").click(function(){
      fnDeliveryAddressDialog("fnCallBackDeliveryAddressSet"); 
   });

   $("#delButton").click(function(){
      fnDeliveryDelete(); 
   });
   
   //물품공급계약서 구분 펑션
   fnContractSpecial();
});
/**
 * 우편번호팝업검색후 선택한 값 세팅
 */
function fnCallBackDeliveryAddressSet(shippingPlace, shippingPhoneNum, shippingPost, shippingAddress, shippingAddressDesc) {
   var shippingAddres = shippingPost+" "+shippingAddress+" "+shippingAddressDesc;
   
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveDeliveryInfo.sys", 
      { 
           oper:'add'
         , shippingPlace:shippingPlace
         , shippingPhoneNum:shippingPhoneNum
         , shippingAddres:shippingAddres
         , groupId:'<%=detailDto.getGroupId()%>'
         , branchId:'<%=branchId%>'
         , clientId:'<%=clientId%>'
      },
      function(arg){
         if(fnAjaxTransResult(arg)) {
            jq("#list").trigger("reloadGrid");              
         }
      }
   ); 
   //addRow(shippingPlace, shippingPhoneNum, shippingPost+" "+shippingAddress+" "+shippingAddressDesc);
}
</script>
<% //------------------------------------------------------------------------------ %>


<%
/**------------------------------------사용자팝업 사용방법---------------------------------
* fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString) 을 호출하여 Div팝업을 Display ===
* userNm : 찾고자하는 사용자명
* loginId : 찾고자하는 사용자 Login Id
* svcTypeCd : 찾는사용자의 서비스코드("BUY":고객사, "VEN":공급사, "ADM":운영자)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(사용자일련번호, 조직일련번호, 서비스유형명, 사용자명, 로그인아이디, 조직명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#userAddButton").click(function(){
		fnJqmUserInitSearch("", "", "ADM", "fnSelectUserCallback");
	});
	
	$("#userDelButton").click(function(){
		fnAdminUserDel();
	});
	
	$("#btnReqApp").click(function(){
		fnApply("20");
	});
	
	$("#btnApp").click(function(){
		fnApply("30");
	});
	
	$("#btnConfirm").click(function(){
		fnApply("40");
	});
	
	$("#btnCancel").click(function(){
		fnCancel();
	});
	
	$("#btnCancelApp").click(function(){
		fnCancel();
	});
	
	$("#btnRejection").click(function(){
		fnCancel();
	});
});
/**
 * 사용자검색 Callback Function
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms, mobile) {
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/insertAdminBorgs.sys", 
		{
			userId:userId,
			borgTypeCd:"CLT",
			manageBorgCd:$("#clientCd").val(),
			manageBorgId:'<%=clientId%>'
		},
		function(arg){
			if(fnAjaxTransResult(arg)) {
				jq("#list3").trigger("reloadGrid");             
			}
		}
	);
}

function fnAdminUserDel(){
	var rowid = $("#list3").jqGrid('getGridParam', "selrow" );
	var selrowContent = jq("#list3").jqGrid('getRowData',rowid);

	if(rowid == null){
		$("#dialog").html("<font size='2'>삭제할 항목을 선택해주세요.</font>");
		$("#dialog").dialog({
			title: 'fail',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
		return;
	}
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/deleteAdminBorgs.sys", 
		{ 
			adminBorgId:selrowContent.adminBorgId
		},
		function(arg){
			if(fnAjaxTransResult(arg)) {
				jq("#list3").trigger("reloadGrid"); 
			}
		}
	);
}

function fnRoleDel(){
	var rowid = $("#list2").jqGrid('getGridParam', "selrow" );
	var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
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
		{
			oper:'del',
			userId:selrowContent.userId,
			roleId:selrowContent.roleId,
			borgId:selrowContent.borgId
		},
		function(arg){
			if(fnAjaxTransResult(arg)) {
				jq("#list2").trigger("reloadGrid"); 
			}
		}
	);
}

function fnIsValidation(){
	var clientNm = $.trim($("#clientNm").val());
	var clientCd = $.trim($("#clientCd").val());
	var businessNum1 = $.trim($("#businessNum1").val());
	var businessNum2 = $.trim($("#businessNum2").val());
	var businessNum3 = $.trim($("#businessNum3").val());
	var registNum1 = $.trim($("#registNum1").val());
	var registNum2 = $.trim($("#registNum2").val());
	var branchBustType = $.trim($("#branchBustType").val());
	var branchBustClas = $.trim($("#branchBustClas").val());
	var pressentNm = $.trim($("#pressentNm").val());
	var phoneNum = $.trim($("#phoneNum").val());
	var eMail = $.trim($("#eMail").val());
	var postAddrNum = $.trim($("#postAddrNum").val());
	var addres = $.trim($("#addres").val());
	var file_biz_reg_list = $.trim($("#file_biz_reg_list").val());
	var areaType = $.trim($("#areaType").val());
	var branchGrad = $.trim($("#branchGrad").val());
	var payBillType = $.trim($("#payBillType").val());
	var payBillDay = $.trim($("#payBillDay").val());
	var accountManagerNm = $.trim($("#accountManagerNm").val());
	var accountTelNum = $.trim($("#accountTelNum").val());
	
	var bankCd = $.trim($("#bankCd").val());
	var recipient  = $.trim($("#recipient").val());
	var accountNum  = $.trim($("#accountNum").val());
	var loginId    = $.trim($("#loginId").val());
	var userNm     = $.trim($("#userNm").val());
	var tel        = $.trim($("#tel").val());
	var mobile     = $.trim($("#mobile").val());
	var userEmail  = $.trim($("#userEmail").val());
	
	var workId	= $("#workId").val();
	var accUser = $("#accUser").val();
	var refereceDesc = $("#refereceDesc").val();
	
	//계약구분
	var contractSpecial = $("#srcContractSpecial").val();
	
	//샵메일
	var sharpMail = $.trim($("#sharpMail").val());
	
	if(clientNm == ""){
		$("#dialog").html("<font size='2'>법인명을 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
		return false;
	}
	if(clientCd == ""){
		$("#dialog").html("<font size='2'>법인코드를 입력해주세요.</font>");
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
//     if(registNum1 == "" || registNum2 == ""){
//        $("#dialog").html("<font size='2'>법인 등록번호를 입력해주세요.</font>");
//        $("#dialog").dialog({
//           title: 'Success',modal: true,
//           buttons: {"Ok": function(){$(this).dialog("close");} }
//        });         
//        return false;
//     }  
	if(branchBustType == ""){
		$("#dialog").html("<font size='2'>업종을 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
		return false;
	}
	if(branchBustClas == ""){
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
		$("#dialog").html("<font size='2'>권역을 선택해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
		return false;
	}
	if(branchGrad == ""){
		$("#dialog").html("<font size='2'>회원사등급을 선택해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
	return false;
	}
	if(workId == ""){
		$("#dialog").html("<font size='2'>고객유형을 선택해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
		return false;
	}
	if(accUser == ""){
		$("#dialog").html("<font size='2'>채권담당자를 선택해주세요.</font>");
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
		$("#dialog").html("<font size='2'>회계담당자 연락처를 입력해주세요.</font>");
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
    
    var roleCnt = $("#list2").getGridParam('reccount');
    if(roleCnt == 0) {
       $("#dialog").html("<font size='2'>1개 이상의 권한을 설정해주세요.</font>");
       $("#dialog").dialog({
          title: 'Success',modal: true,
          buttons: {"Ok": function(){$(this).dialog("close");} }
       });         
       return false;     
    }
    
    if(refereceDesc == ""){
        $("#dialog").html("<font size='2'>종합의견을 입력해주세요.</font>");
        $("#dialog").dialog({
           title: 'Success',modal: true,
           buttons: {"Ok": function(){$(this).dialog("close");} }
        });         
        return false;
    }    

//     var userCnt = $("#list3").getGridParam('reccount');
//     if(userCnt == 0) {
//        $("#dialog").html("<font size='2'>운영사 담당자를 1명이상 설정해주세요.</font>");
//        $("#dialog").dialog({
//           title: 'Success',modal: true,
//           buttons: {"Ok": function(){$(this).dialog("close");} }
//        });         
//        return false;     
//     }
    if(contractSpecial == ""){
        $("#dialog").html("<font size='2'>계약구분을 입력해주세요.</font>");
        $("#dialog").dialog({
           title: 'Success',modal: true,
           buttons: {"Ok": function(){$(this).dialog("close");} }
        });         
        return false;
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

function fnApply(registerCd){
	var confirmMsg = null;	
	
	if("20" == registerCd)     	  confirmMsg = "해당법인을 승인요청 하시겠습니까?";
	else if("30" == registerCd)   confirmMsg = "해당법인을 1차 승인 하시겠습니까?";
	else if("40" == registerCd)   confirmMsg = "해당법인을 최종 승인 하시겠습니까?";
	
	if(fnIsValidation()){
		if(!confirm(confirmMsg)) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/updateBranchReq.sys", 
			{
				branchId:'<%=branchId%>',
				
				file_biz_reg_list:$("#file_biz_reg_list").val(),
				file_app_sal_list:$("#file_app_sal_list").val(),
				file_list1:$("#file_list1").val(),
				file_list2:$("#file_list2").val(),
				file_list3:$("#file_list3").val(),
				
				clientNm:$("#clientNm").val(),
				clientCd:$("#clientCd").val(),
				clientId:'<%=clientId%>',
				businessNum1:$("#businessNum1").val(),
				businessNum2:$("#businessNum2").val(),
				businessNum3:$("#businessNum3").val(),
				registNum1:$("#registNum1").val(),
				registNum2:$("#registNum2").val(),
				branchBustType:$("#branchBustType").val(),
				branchBustClas:$("#branchBustClas").val(),
				pressentNm:$("#pressentNm").val(),
				phoneNum:$("#phoneNum").val(),
				eMail:$("#eMail").val(),
				homePage:$("#homePage").val(),
				postAddrNum:$("#postAddrNum").val(),
				addres:$("#addres").val(),
				addresDesc:$("#addresDesc").val(),
				faxNum:$("#faxNum").val(),
				refereceDesc:$("#refereceDesc").val(),
				areaType:$("#areaType").val(),
				branchGrad:$("#branchGrad").val(),
				payBillType:$("#payBillType").val(),
				payBillDay:$("#payBillDay").val(),
				accountManagerNm:$("#accountManagerNm").val(),
				accountTelNum:$("#accountTelNum").val(),
				bankCd:$("#bankCd").val(),
				recipient:$("#recipient").val(),
				accountNum:$("#accountNum").val(),
				userNm:$("#userNm").val(),
				tel:$("#tel").val(),
				mobile:$("#mobile").val(),
				userEmail:$("#userEmail").val(),
				loginAuthType:$("#loginAuthType").val(),
				orderAuthType:$("#orderAuthType").val(),
				userId:$("#userId").val(),
				registerCd:registerCd,
				workId:$("#workId").val(),
				accUser:$("#accUser").val(),
				isSap:$("#isSap").val(),
				srcContractSpecial:$("#srcContractSpecial").val(),
				sharpMail:$("#sharpMail").val()
			},
			function(arg){ 
				if(fnAjaxTransResult(arg)) {  //성공시
//                		var opener = window.dialogArguments;
					window.opener.fnClientSearch();
					window.close();
				}
			}
		);
	}
}

function fnCancel() {
	var userRoleCd = '<%=userRoleCd%>';
	var registerCd = '<%=detailDto.getRegisterCd()%>';
	var confirmMsg = null;
	
	if("10" == registerCd)     	 confirmMsg = "해당법인요청 데이터가 모두 삭제됩니다. \n계속 진행하시겠습니까?";
	else if("20" == registerCd)   confirmMsg = "해당법인요청이 '등록요청' 상태로 되돌아갑니다. \n계속 진행하시겠습니까?";
	else if("30" == registerCd)   confirmMsg = "해당법인요청이 '승인요청' 상태로 되돌아갑니다. \n계속 진행하시겠습니까?";
	
	if(!confirm(confirmMsg)) return;
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/cancelBranchReq.sys", 
		{
			branchId:'<%=branchId%>',
			clientCd:$("#clientCd").val(),
			clientId:'<%=clientId%>',
			userRoleCd:userRoleCd,
			userId:$("#userId").val(),
			registerCd:registerCd
		},
		function(arg){ 
			if(fnAjaxTransResult(arg)) {  //성공시
//              var opener = window.dialogArguments;
				window.opener.fnClientSearch();
				window.close();
			}
		}
	);
}



</script>
<% //------------------------------------------------------------------------------ %>



<%
/**------------------------------------권한팝업 사용방법 시작---------------------------------
* fnJqmAddRoleListInit(svcTypeCd, callbackString) 을 호출하여 Div팝업을 Display ===
* svcTypeCd : 서비스코드("BUY":고객사, "VEN":공급사, "ADM":운영자, "CEN":물류센타)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(권한ID, 권한코드, 권한명, 기본권한여부, 권한조직범위코드, 권한설명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/addRoleListDiv.jsp" %>
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">
function fnJqmAddRole() {
   fnJqmAddRoleListInit("BUY","fnAddRoleCallBack");
}
function fnAddRoleCallBack(roleId, roleCd, roleNm, isDefault, borgScopeCd, roleDesc) {
   var rowCnt = $("#list2").getGridParam('reccount');
   for(var i=0;i<rowCnt;i++) {
      var rowid = $("#list2").getDataIDs()[i];
      var selrowContent = $("#list2").jqGrid('getRowData',rowid);
      if(roleId == selrowContent.roleId) { alert("이미 등록된 권한입니다."); return; }
   }     
   $.post(  //권한등록				   
      '<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveUserRoles.sys',
      { oper:'add', roleId:roleId, borgId:'<%=branchId %>' , userId:'<%=userDto.getUserId() %>' , isDefault:isDefault, borgScopeCd:borgScopeCd },
      function(arg){
         var result = eval('(' + arg + ')').customResponse;
         if (result.success == false) {
            var errors = "";
            for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
            alert(errors);
         } else {
            $("#list2").trigger("reloadGrid");  
         }
      }
   );
}
</script>
<%//----------------------------------권한팝업 사용방법 끝----------------------------------------%>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
   $("#srcUserNm").keydown(function(e){
      if(e.keyCode==13) {
         $("#srcButton").click();
      }
   });
   $("#roleAddButton").click(function(){
      fnJqmAddRole();
   });   
   $("#roleDelButton").click(function(){
      fnRoleDel();
   });   
});

//리사이징
// $(window).bind('resize', function() { 
//     $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
//     $("#list2").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
// }).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
jq(function() {
   jq("#list").jqGrid({
      url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/getDeliveryInfoList.sys?branchId=<%=branchId%>', 
      datatype: 'json',
      mtype: 'POST',
      colNames:['deliveryId', '배송지명', '배송지 전화번호', '배송지 주소'],
      colModel:[
         {name:'deliveryId',index:'deliveryId', width:150,align:"left",search:false,sortable:true, editable:false, hidden:true },
         {name:'shippingPlace',index:'shippingPlace', width:150,align:"left",search:false,sortable:true, editable:false },
         {name:'shippingPhoneNum',index:'shippingPhoneNum', width:200,align:"left",search:false,sortable:true, editable:false },
         {name:'shippingAddres',index:'shippingAddres', width:500,align:"left",search:false,sortable:true, editable:false }
      ],
      postData: {},
      rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
      height: <%=listHeight%>,width: 870,
      caption:"배송처 정보", 
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

jq(function() {
	jq("#list2").jqGrid({
		url:'/organ/getDefaultBorgRole.sys?',  
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
		postData: {
			borgId:'<%=branchId%>', 
			userId:'<%=userDto.getUserId()%>'
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,width: 750,
		sortname: 'a.roleId', sortorder: "asc",
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

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
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
		jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>').appendTo('body').submit().remove();
	};
};

function fnDeliveryDelete() {
   var id = $("#list").jqGrid('getGridParam', "selrow" );  
   var selrowContent = jq("#list").jqGrid('getRowData',id); 
   
   if(id == null) {
      $("#dialog").html("<font size='2'>삭제할 데이터를 선택해주세요.</font>");
      $("#dialog").dialog({
         title: 'Fail',modal: true,
         buttons: {"Ok": function(){$(this).dialog("close");} }
      });                  
      return;
   }
   
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveDeliveryInfo.sys", 
      { oper:'del', deliveryId:selrowContent.deliveryId },
      function(arg){
         if(fnAjaxTransResult(arg)) {
            jq("#list").trigger("reloadGrid");              
         }
      }
   ); 
   //addRow(shippingPlace, shippingPhoneNum, shippingPost+" "+shippingAddress+" "+shippingAddressDesc);
}
</script>

<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	$("#btnBizRegAttach").click(function(){ fnUploadDialog("사업자등록첨부", $("#file_biz_reg_list").val(), "fnCallBackAttachBizReq"); });
	$("#btnAppSalAttach").click(function(){ fnUploadDialog("신용평가서첨부", $("#file_app_sal_list").val(), "fnCallBackAttachAppSal"); });
	$("#btnAttach1").click(function(){ fnUploadDialog("통장사본첨부", $("#file_list1").val(), "fnCallBackAttach1"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("기타첨부1", $("#file_list2").val(), "fnCallBackAttach2"); });
	$("#btnAttach3").click(function(){ fnUploadDialog("기타첨부2", $("#file_list3").val(), "fnCallBackAttach3"); });
	$("#saveButton").click(function(){ updateReqSmpBranchs(); });

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
 * 신용평가서 파일관리
 */
function fnCallBackAttachAppSal(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#file_app_sal_list").val(rtn_attach_seq);
   $("#attach_file_app_sal_name").text(rtn_attach_file_name);
   $("#attach_file_app_sal_path").val(rtn_attach_file_path);
}

/**
 * 통장사본 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#file_list1").val(rtn_attach_seq);
   $("#attach_file_name1").text(rtn_attach_file_name);
   $("#attach_file_path1").val(rtn_attach_file_path);
}

/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#file_list2").val(rtn_attach_seq);
   $("#attach_file_name2").text(rtn_attach_file_name);
   $("#attach_file_path2").val(rtn_attach_file_path);
}

/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list3").val(rtn_attach_seq);
	$("#attach_file_name3").text(rtn_attach_file_name);
	$("#attach_file_path3").val(rtn_attach_file_path);
}

/**
 * 구매사 저장
 */
function updateReqSmpBranchs(){
	if(!confirm("수정한 내용을 저장하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/updateReqSmpBranchs.sys", 
			{
				branchId:'<%=branchId%>',
				file_biz_reg_list:$("#file_biz_reg_list").val(),
				file_app_sal_list:$("#file_app_sal_list").val(),
				file_list1:$("#file_list1").val(),
				file_list2:$("#file_list2").val(),
				file_list3:$("#file_list3").val()
			},
			function(arg){ 
				if(fnAjaxTransResult(arg)) {  //성공시
				}
			}
		);
	}

//물품공급계약서 구분 셀렉트박스
function fnContractSpecial(){
	$.post(
		'/organ/contractSpecialList.sys',
		function(arg){
			var result = eval("("+arg+")");
			for(var i=0; i<result.list.length; i++){
				$("#srcContractSpecial").append("<option value='"+result.list[i].codeVal1+"'>"+result.list[i].codeNm1+"</option>");
			}
			var contractSpecial = '<%=detailDto.getContractSpecial()%>';
			$("#srcContractSpecial").val(contractSpecial);
		}
	);
}
</script>
</head>
<body>
<form id="frm" name="frm">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
					<td height="29" class='ptitle'>고객법인등록요청 상세승인요청</td>
				</tr>
			</table> <!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;" >
				<tr>
					<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
					<td class="stitle">회원사 일반정보</td>
				</tr>
			</table> <!-- 타이틀 끝 -->
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
					<td class="table_td_subject9" width="90">법인명</td>
					<td class="table_td_contents">
						<input id="clientNm" name="clientNm" type="text" value="<%=detailDto.getClientNm() %>" size="40" maxlength="50" />
					</td>
					<td class="table_td_subject9" width="90">법인코드</td>
					<td class="table_td_contents">
						<input id="clientCd" name="clientCd" type="text" value="<%=detailDto.getClientCd() %>" size="20" maxlength="3" style="ime-mode: disabled;text-transform:uppercase;" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="90">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 15px;">
							<tr>
								<td>사업자등록번호</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
										<input type="button" value="국세청조회" style="cursor:pointer;" onclick="window.open('http://www.nts.go.kr/cal/cal_check_02.asp')"></input>
								</td>
							</tr>
						</table>
					 </td>
					<td class="table_td_contents">
						<input id="businessNum1" name="businessNum1" type="text" value="<%=detailDto.getBusinessNum().substring(0, 3) %>" size="3" maxlength="3" onkeydown="return onlyNumber(event)"/> - 
						<input id="businessNum2" name="businessNum2" type="text" value="<%=detailDto.getBusinessNum().substring(3, 5) %>" size="2" maxlength="2" onkeydown="return onlyNumber(event)"/> - 
						<input id="businessNum3" name="businessNum3" type="text" value="<%=detailDto.getBusinessNum().substring(5) %>" size="5" maxlength="5" onkeydown="return onlyNumber(event)"/>
					</td>
					<td class="table_td_subject" width="90">법인등록번호</td>
<%
	String registNum = CommonUtils.getString(detailDto.getRegistNum());
	String registNum1 = "";
	String registNum2 = "";
	if(registNum.length() > 10) {
		registNum = registNum.replace("-", "");    
		registNum1 = registNum.substring(0, 6) ;
		registNum2 = registNum.substring(6) ;
	}
%>
					<td class="table_td_contents">
						<input id="registNum1" name="registNum1" type="text" value="<%=registNum1 %>" size="6" maxlength="6" onkeydown="return onlyNumber(event)"/> - 
						<input id="registNum2" name="registNum2" type="text" value="<%=registNum2 %>" size="7" maxlength="7"onkeydown="return onlyNumber(event)" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="90">업종</td>
					<td class="table_td_contents">
						<input id="branchBustType" name="branchBustType" type="text" value="<%=detailDto.getBranchBusiType()%>" size="20" maxlength="30" style="width: 98%" />
					</td>
					<td class="table_td_subject9" width="90">업태</td>
					<td class="table_td_contents"><input id="branchBustClas" name="branchBustClas" type="text" value="<%=detailDto.getBranchBusiClas()%>" size="20" maxlength="30" /></td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="90">대표자명</td>
					<td class="table_td_contents">
						<input id="pressentNm" name="pressentNm" type="text" value="<%=detailDto.getPressentNm() %>" size="20" maxlength="30" style="width: 98%" />
					</td>
					<td class="table_td_subject9" width="90">대표전화번호</td>
					<td class="table_td_contents">
						<input id="phoneNum" name="phoneNum" type="text" value="<%=detailDto.getPhoneNum() %>" size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="90">회사이메일</td>
					<td class="table_td_contents">
						<input id="eMail" name="eMail" type="text" value="<%=detailDto.getE_mail() %>" size="20" maxlength="30" />
					</td>
					<td class="table_td_subject" width="90">홈페이지</td>
					<td class="table_td_contents">
						<input id="homePage" name="homePage" type="text" value="<%=detailDto.getHomePage() %>" size="20" maxlength="30" style="width: 98%" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="90">
						<table>
							<tr>
								<td>회사샵(#)메일</td>
							</tr>
							<tr>
								<td>
									<input type="button" value="회원가입하기" style="cursor:pointer;" onclick="window.open('https://www.docusharp.com/member/join.jsp')"></input>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents" colspan="3">
						<input id="sharpMail" name="sharpMail" type="text" value="<%=sharpMail %>" size="20" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="90">주소</td>
					<td colspan="3" class="table_td_contents">
						<input id="postAddrNum" name="postAddrNum" type="text" value="<%=detailDto.getPostAddrNum() %>" size="7" maxlength="7" onkeydown="return onlyNumber(event)" class="input_text_none" disabled="disabled"/>
						<a href="#">
							<img id="btnPost" src="/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search' style="border: 0px; vertical-align: middle;" />
						</a>
						<input id="addres" name="addres" type="text" value="<%=detailDto.getAddres() %>" size="56" maxlength="50" class="input_text_none" disabled="disabled"/> 
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="90">상세주소</td>
					<td class="table_td_contents" colspan="3">
						<input id="addresDesc" name="addresDesc" type="text" value="<%=detailDto.getAddresDesc() %>" size="20" maxlength="30" style="width: 60%" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="90">팩스번호</td>
					<td class="table_td_contents" colspan="3">
						<input id="faxNum" name="faxNum" type="text" value="<%=detailDto.getFaxNum() %>" size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="90">로그인인증</td>
					<td class="table_td_contents">
						<select class="select" id="loginAuthType" name="LoginAuthType"> 
							<option value="">선택하세요</option> 
							<option value="10" <%= detailDto.getLoginAuthType().equals("10") ? "selected" : "" %>>모바일인증</option> 
							<option value="20" <%= detailDto.getLoginAuthType().equals("20") ? "selected" : "" %>>일반</option> 
						</select>
					</td>
					<td class="table_td_subject9" width="90">주문요청인증</td>
					<td class="table_td_contents">
						<select class="select" id="orderAuthType" name="orderAuthType"> 
							<option value="">선택하세요</option>
							<option value="10" <%= detailDto.getOrderAuthType().equals("10") ? "selected" : "" %>>공인인증</option> 
							<option value="20" <%= detailDto.getOrderAuthType().equals("20") ? "selected" : "" %>>일반</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100" id="tdId1">
						<table>
							<tr>
								<td>사업자등록첨부</td>
							</tr>
							<tr>
								<td>
			<%if(userRoleCd.equals("MRO_ADMIN002") || userRoleCd.equals("ADM_B2B_MAN")){%>
									<a href="#">
										<img id="btnBizRegAttach" name="btnBizRegAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
									</a>
			<%}%>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_biz_reg_list" name="file_biz_reg_list" value="<%=detailDto.getBusinessAttachFileSeq() %>"/>
						<input type="hidden" id="attach_file_biz_reg_path" name="attach_file_biz_reg_path" value="<%=detailDto.getBusinessAttachFilePath() %>"/>
							<a href="javascript:fnAttachFileDownload($('#attach_file_biz_reg_path').val());">
								<span id="attach_file_biz_reg_name"><%=detailDto.getBusinessAttachFileNm() == null || detailDto.getBusinessAttachFileNm().equals("") ? "" : detailDto.getBusinessAttachFileNm() %></span>
							</a>
					</td>
					<td class="table_td_subject" width="90">
						<table>
							<tr>
								<td>신용평가서첨부</td>
							</tr>
							<tr>
								<td>
			<%if(userRoleCd.equals("MRO_ADMIN002") || userRoleCd.equals("ADM_B2B_MAN")){%>
									<a href="#">
										<img id="btnAppSalAttach" name="btnAppSalAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
									</a>
			<%} %>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">&nbsp;
						<input type="hidden" id="file_app_sal_list" name="file_app_sal_list" value="<%=detailDto.getAppraisalAttachFileSeq() %>"/>
						<input type="hidden" id="attach_file_app_sal_path" name="attach_file_app_sal_path" value="<%=detailDto.getAppraisalAttachFilePath() %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_app_sal_path').val());">
							<span id="attach_file_app_sal_name"><%=detailDto.getAppraisalAttachFileNm() == null || detailDto.getAppraisalAttachFileNm().equals("") ? "" : detailDto.getAppraisalAttachFileNm() %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="90">
						<table>
							<tr>
								<td>통장사본첨부</td>
							</tr>
							<tr>
								<td>
			<%if(userRoleCd.equals("MRO_ADMIN002") || userRoleCd.equals("ADM_B2B_MAN")){%>
									<a href="#">
										<img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
									</a>
			<%}%>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list1" name="file_list1" value="<%=detailDto.getEtcFirstSeq() %>"/>
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=detailDto.getEtcFirstPath() %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
							<span id="attach_file_name1"><%=detailDto.getEtcFirstNm() == null || detailDto.getEtcFirstNm().equals("") ? "" : detailDto.getEtcFirstNm() %></span>
						</a>
					</td>
					<td class="table_td_subject" width="90">
						<table>
							<tr>
								<td>공사계약서<br/>(Home 고객센터 계약서 포함)</td>
							</tr>
							<tr>
								<td>
			<%if(userRoleCd.equals("MRO_ADMIN002") || userRoleCd.equals("ADM_B2B_MAN")){%>
									<a href="#">
										<img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
									</a>
			<%}%>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list2" name="file_list2" value="<%=detailDto.getEtcSecondSeq() %>"/>
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=detailDto.getEtcSecondPath() %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
							<span id="attach_file_name2"><%=detailDto.getEtcSecondNm() == null || detailDto.getEtcSecondNm().equals("") ? "" : detailDto.getEtcSecondNm() %></span>
						</a>  
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="90">
						<table>
							<tr>
								<td>회사소개서</td>
							</tr>
							<tr>
								<td>
			<%if(userRoleCd.equals("MRO_ADMIN002") || userRoleCd.equals("ADM_B2B_MAN")){%>
									<a href="#">
										<img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
									</a>
			<%} %>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list3" name="file_list3" value="<%=detailDto.getEtcThirdSeq() %>"/>
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=detailDto.getEtcThirdPath() %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
							<span id="attach_file_name3"><%=detailDto.getEtcThirdNm() == null || detailDto.getEtcThirdNm().equals("") ? "" : detailDto.getEtcThirdNm()%></span>
						</a>
					</td>
					<td width="90" class="table_td_subject9">
						<table>
							<tr>
								<td>계약구분</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</td>
					<td class="table_td_contents">
						<select id="srcContractSpecial" name="srcContractSpecial" class="select">
							<option value="">선택하세요</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="90">권역</td>
					<td class="table_td_contents">
						<select class="select" id="areaType" name="areaType"> 
							<option value="">선택하세요</option> 
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> areaCode = (List<CodesDto>) request.getAttribute("areaCode");
	for(CodesDto areaCd : areaCode){
		if(!"99".equals(areaCd.getCodeVal1())){
%>
							<option value="<%=areaCd.getCodeVal1()%>" <%=areaCd.getCodeVal1().equals(detailDto.getAreaType()) ? "selected" : "" %> ><%=areaCd.getCodeNm1() %></option>
<% 
		}
	}
%>
						</select>
					</td>
					<td class="table_td_subject9" width="90">회원사등급</td>
					<td class="table_td_contents">
						<select class="select" id="branchGrad" name="branchGrad"> 
							<option value="">선택하세요</option> 
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> mGradeCode = (List<CodesDto>) request.getAttribute("mGradeCode");
	for(CodesDto mGradeCd : mGradeCode){
%>
							<option value="<%=mGradeCd.getCodeVal1()%>" <%=mGradeCd.getCodeVal1().equals(detailDto.getBranchGrad()) ? "selected" : "" %> ><%=mGradeCd.getCodeNm1() %></option>
<% 
	}
%>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td width="90" class="table_td_subject9">고객유형</td>
					 <td class="table_td_contents">
						<select id="workId" name="workId" class="select">
							<option value="">전체</option>
<%
	@SuppressWarnings("unchecked")
	List<WorkInfoDto> workInfoList = (List<WorkInfoDto>) request.getAttribute("workInfoList");
	if(workInfoList != null && workInfoList.size() > 0){

		for(WorkInfoDto workInfoDto : workInfoList){
%>
							<option value="<%=workInfoDto.getWorkId()%>" <%=workInfoDto.getWorkId().equals(detailDto.getWorkId()) ? "selected" : "" %>><%=workInfoDto.getWorkNm()%></option>
<%
		}
	}
%>
						</select>
					</td>
					<td width="80" class="table_td_subject9">채권담당자</td>
					<td class="table_td_contents">
						<select id="accUser" name="accUser" class="select" style="width: 120px;">
							<option value="">전체</option>
<%
	@SuppressWarnings("unchecked")
	List<UserDto> admUserList = (List<UserDto>) request.getAttribute("admUserList");
	if(admUserList != null && admUserList.size() > 0){
		for(UserDto accUserDto : admUserList){
%>
							<option value="<%=accUserDto.getUserId()%>" <%=accUserDto.getUserId().equals(detailDto.getUserId()) ? "selected" : "" %>><%=accUserDto.getUserNm()%></option>
<%
		}
	}
%>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr> 
					<td> &nbsp; </td> 
				</tr>
<%if(userRoleCd.equals("MRO_ADMIN002") || userRoleCd.equals("ADM_B2B_MAN")){%>
				<tr>
					<td align="center" colspan="6">
						<a href="#"> 
<!-- 							<img id="saveButton" name="saveButton" src="/img/system/btn_type5_save.gif" width="65" height="23" style="border: 0px; vertical-align: middle;"/>  -->
						</a>
						<a href="#"> 
<!-- 							<img id="closeButton" name="closeButton" src="/img/system/btn_type5_close.gif" width="65" height="23" style="border: 0px; vertical-align: middle;" onclick="javaScript:window.close();"/> -->
						</a>
					</td>
				</tr>
<%} %>
			</table> <!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;" >
				<tr>
					<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
					<td class="stitle">결제정보</td>
				</tr>
			</table> <!-- 타이틀 끝 -->
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
					<td class="table_td_subject9" width="110">결제조건</td>
					<td class="table_td_contents">
						<select class="select" id="payBillType" name="payBillType" style="width: 125px;"> 
							<option value="">선택하세요</option>
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> payCondCode = (List<CodesDto>) request.getAttribute("payCondCode");
	for(CodesDto payCondCd: payCondCode){
%>
							<option value="<%=payCondCd.getCodeVal1()%>" <%=payCondCd.getCodeVal1().equals(detailDto.getPayBilltype()) ? "selected" : "" %>>
								<%=payCondCd.getCodeNm1()%>
							</option>
<%
	}
%>
						</select> 
<%-- 						<input id="payBillDay" name="payBillDay" type="text" value="<%=detailDto.getPayBillDay() %>" size="20" maxlength="2" style="width: 20px" onkeydown="return onlyNumber(event)"/> 일</td> --%>
					</td>
					<td class="table_td_subject9" width="100">회계담당자명</td>
					<td class="table_td_contents">
						<input id="accountManagerNm" name="accountManagerNm" type="text" value="<%=detailDto.getAccountManageNm() %>" size="16" maxlength="30" style="width: 90%" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="110">회계담당자 연락처</td>
					<td class="table_td_contents">
						<input id="accountTelNum" name="accountTelNum" type="text" value=<%=detailDto.getAccountTelNum() %> size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
					</td>
					<td class="table_td_subject9" width="100">은행코드</td>
					<td class="table_td_contents">
						<select class="select" id="bankCd" name="bankCd"> 
							<option value="">선택하세요</option> 
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> bankCode = (List<CodesDto>) request.getAttribute("bankCode");
	for(CodesDto bankCd : bankCode){
%>
							<option value="<%=bankCd.getCodeVal1()%>" <%=bankCd.getCodeVal1().equals(detailDto.getBankCd()) ? "selected" : "" %> ><%=bankCd.getCodeNm1() %></option>
<% 
	}
%>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="110">예금주명</td>
					<td class="table_td_contents">
						<input id="recipient" name="recipient" type="text" value="<%=detailDto.getRecipient() %>" size="18" maxlength="30" style="width: 98%" />
					</td>
					<td class="table_td_subject9" width="100">계좌번호</td>
					<td class="table_td_contents">
						<input id="accountNum" name="accountNum" type="text" value="<%=detailDto.getAccountNum() %>" size="15" maxlength="20" onkeydown="return onlyNumber(event)"/> (-없이)
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
			</table> <!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;" >
				<tr>
					<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
					<td class="stitle">배송처 정보<a href="#" onclick="javaScript:$('#isSap').val('1');"><font color="white">-</font></a>
						<input type="hidden" id="isSap" name="isSap" value="0"/>
					</td>
					<td width="50" class="stitle">
						<a href="#"> <img id="regButton" name="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_plus.gif" width="20" height="18" style="border: 0px;vertical-align: middle;"/> </a>
						<a href="#"> <img id="delButton" name="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px;vertical-align: middle;"/> </a>
					</td>
				</tr>
			</table> <!-- 타이틀 끝 -->
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
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
				<tr>
					<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
					<td class="stitle">담당자 정보</td>
				</tr>
			</table> <!-- 타이틀 끝 -->
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
					<td class="table_td_contents">
						<input id="userId" name="userId" type="hidden" value="<%=userDto.getUserId() %>" size="40" maxlength="50" class="input_text_none" readonly="readonly"/> 
						<input id="loginId" name="loginId" type="text" value="<%=userDto.getLoginId() %>" size="40" maxlength="50" class="input_text_none" readonly="readonly" disabled="disabled"/> 
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">성명</td>
					<td class="table_td_contents">
						<input id="userNm" name="userNm" type="text" value="<%=userDto.getUserNm() %>" size="20" maxlength="30" class="input_text_none" readonly="readonly" disabled="disabled"/>
					</td>
					<td class="table_td_subject9" width="100">전화번호</td>
					<td class="table_td_contents">
						<input id="tel" name="tel" type="text" value="<%=userDto.getTel() %>" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">이동전화번호</td>
					<td class="table_td_contents">
						<input id="mobile" name="mobile" type="text" value="<%=userDto.getMobile() %>" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
					</td>
					<td class="table_td_subject9" width="100">이메일</td>
					<td class="table_td_contents">
						<input id="userEmail" name="userEmail" type="text" value="<%=userDto.geteMail() %>" size="20" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">권한정보</td>
					<td colspan="3" class="table_td_contents4">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="50" valign="top" align="right">
									<a href="#">
										<img id="roleAddButton" name="roleAddButton" src="/img/system/btn_icon_plus.gif" width="20" height="18" style="border: 0px;"/> 
									</a>
									<a href="#">
										<img id="roleDelButton" name="roleDelButton" src="/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px;"/>
									</a>
								</td>
							</tr>
							<tr>
								<td height="50" valign="top">
									<div id="jqgrid">
										<table id="list2"></table>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
<!--                   <tr> -->
<!--                      <td class="table_td_subject9">운영사 담당자</td> -->
<!--                      <td colspan="3" class="table_td_contents4"><table width="100%" border="0" cellspacing="0" cellpadding="0"> -->
<!--                            <tr> -->
<!--                               <td height="50" valign="top"> -->
<!--                                  <div id="jqgrid"> -->
<!--                                     <table id="list3"></table> -->
<!--                                  </div> -->
<!--                               </td> -->
<!--                               <td width="50" valign="top"> -->
<!--                                  <a href="#"> -->
<!--                                     <img id="userAddButton" src="/img/system/btn_icon_plus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;"/>  -->
<!--                                  </a> -->
<!--                                  <a href="#"> -->
<!--                                     <img id="userDelButton" src="/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;"/>  -->
<!--                                  </a> -->
<!--                               </td> -->
<!--                            </tr> -->
<!--                         </table> -->
<!--                      </td> -->
<!--                   </tr> -->
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
			</table> <!-- 컨텐츠 끝 -->
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
					<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
					<td class="stitle">종합의견</td>
				</tr>
			</table> <!-- 타이틀 끝 -->
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
					<td class="table_td_subject9" width="100">
						&nbsp;<%=confirmorId%>
					</td>
					<td colspan="3" class="table_td_contents">
						<input id="refereceDesc" name="refereceDesc" type="text" value="<%=detailDto.getRefereceDesc() %>" size="20" maxlength="1000" style="width: 98%" />
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
			</table> <!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center">
			<!-- 승인요청 -->
<% if(!"40".equals(detailDto.getRegisterCd())){%>
	<%if("10".equals(detailDto.getRegisterCd())){%>
			<a href="#">
				<img id="btnReqApp" name="btnReqApp" src="/img/system/btn_type5_approve2.gif" width="118" height="23" style="border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_CONFIRM")%>" />
			</a>
			<a href="#">
				<img id="btnCancelApp" name="btnCancelApp" src="/img/system/btn_type5_cancel.gif" width="65" height="23" style="border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_CONFIRM")%>" />
			</a>
	<%}else if("20".equals(detailDto.getRegisterCd())){%>
			<!-- 승인 -->
			<a href="#">
				<img id="btnApp" name="btnApp" src="/img/system/btn_type5_1_confirm.gif" width="65" height="23" style="border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP_REQ")%>" />
			</a>
			<a href="#">
				<img id="btnCancel" name="btnCancel" src="/img/system/btn_type5_1_den.gif" width="65" height="23" style="border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP_REQ")%>" />                   
			</a>
	<%}else if("30".equals(detailDto.getRegisterCd())){%>
			<!-- 등록(승인) -->
			<a href="#">
				<img id="btnConfirm" name="btnConfirm" src="/img/system/btn_type5_1_confirm.gif" width="65" height="23" style="border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>"/>
			</a>
	<%}%>
<!--                <a href="#"> -->
<%--                   <img id="btnRejection" name="btnRejection" src="/img/system/btn_type5_rejection.gif" width="65" height="23" style="border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>"/>  --%>
<!--                </a> -->
<% }%>               
			<a href="#">
				<img id="btnClose" name="btnClose" src="/img/system/btn_type5_close.gif" width="65" height="23" style="border: 0px;" onclick="javaScript:window.close();"/>
			</a>
			<div id="dialog" title="Feature not supported" style="display:none;">
				<p>That feature is not supported.</p>
			</div>
		</td>
	</tr>
</table>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</form>
</body>
</html>