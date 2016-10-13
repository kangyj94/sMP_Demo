<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto"%>
<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-215 + Number(gridHeightResizePlus)";
    LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

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
});
/**
 * 우편번호팝업검색후 선택한 값 세팅
 */
function fnCallBackDeliveryAddressSet(shippingPlace, shippingPhoneNum, shippingPost, shippingAddress, shippingAddressDesc) {
   var shippingAddres = shippingPost+" "+shippingAddress+" "+shippingAddressDesc;
   var rowCnt = $("#list").getGridParam('reccount');
   jq("#list").addRowData(rowCnt + 1, {shipping_place:shippingPlace ,shipping_phonenum:shippingPhoneNum ,shipping_addres:shippingAddres});

}

function fnDeliveryDelete(){
	var id = $("#list").jqGrid('getGridParam', "selrow" );  
	if(id == null) {
		alert("삭제할 데이터를 선택해주세요.");
		return;
	}	
	jQuery("#list").delRowData(id);	
}   
   

</script>
<% //------------------------------------------------------------------------------ %>

<%
/**------------------------------------고객사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 고객사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp"%>
<!-- 고객사검색관련 스크립트 -->

<script type="text/javascript">
$(document).ready(function(){
<%
   String _srcGroupId = "";
   String _srcClientId = "";
   String _srcBranchId = "";
   String _srcBorgNms = "";
   SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
   if("BUY".equals(loginUserDto.getSvcTypeCd())) {
      _srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
      _srcGroupId = _srcBorgScopeByRoleDto.getSrcGroupId();
      _srcClientId = _srcBorgScopeByRoleDto.getSrcClientId();
      _srcBranchId = _srcBorgScopeByRoleDto.getSrcBranchId();
      _srcBorgNms = _srcBorgScopeByRoleDto.getSrcBorgNms();
      _srcBorgNms = _srcBorgNms.replaceAll("&gt;", ">");
   }
%>
   $("#clientId").val("<%=_srcClientId %>");
<% if("BUY".equals(loginUserDto.getSvcTypeCd())) { %>
   $("#clientNm").attr("disabled", true);
   $("#srcClientBtn").css("display","none");
   fnCallBackClient('<%=_srcGroupId %>', '<%=_srcClientId %>', '<%=_srcBranchId %>', '<%=_srcBorgNms %>', '');
<% }  %>
});
</script>

<script type="text/javascript">
$(document).ready(function(){
   $("#srcClientBtn").click(function(){
      fnBuyborgDialog("CLT", "1", "", "fnCallBackClient"); 
   });
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackClient(groupId, clientId, branchId, borgNm, areaType) {
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/organBranchSearch.sys", 
		{ clientId:clientId },
		function(arg){ 
			var branchInfo = eval('(' + arg + ')').data;
			if(branchInfo!=null) {
// 				$("#clientNm").val(branchInfo.clientNm.split('&gt;')[0] + " > " + branchInfo.clientNm.split('&gt;')[1]);
				$("#clientNm").val(branchInfo.clientNm.split('&gt;')[0]);
				$("#clientId").val(branchInfo.clientId);
				$("#groupId").val(branchInfo.groupId);
				$("#clientCd").val(branchInfo.branchCd.substring(0, 3));
				$("#businessNum1").val(branchInfo.businessNum.substring(0, 3));
				$("#businessNum2").val(branchInfo.businessNum.substring(3, 5));
				$("#businessNum3").val(branchInfo.businessNum.substring(5));
				$("#registNum1").val(branchInfo.registNum.substring(0, 6));
				$("#registNum2").val(branchInfo.registNum.substring(6));
				$("#branchBusiType").val(branchInfo.branchBusiType);
				$("#branchBusiClas").val(branchInfo.branchBusiClas);
				$("#pressentNm").val(branchInfo.pressentNm);
				$("#phoneNum").val( fnSetTelformat(branchInfo.phoneNum) );
				$("#eMail").val(branchInfo.e_mail);
				$("#homePage").val(branchInfo.homePage);
				$("#postAddrNum").val(branchInfo.postAddrNum);              
				$("#addres").val(branchInfo.addres);                   
				$("#addresDesc").val(branchInfo.addresDesc);               
				$("#faxNum").val( fnSetTelformat(branchInfo.faxNum) );                   
				$("#loginAuthType").val(branchInfo.loginAuthType);            
				$("#orderAuthType").val(branchInfo.orderAuthType);            
				$("#refereceDesc").val(branchInfo.refereceDesc);             
// 				$("#payBillType").val(branchInfo.payBilltype);              
// 				$("#payBillDay").val(branchInfo.payBillDay);               
				$("#prePay").val(branchInfo.prePay);               
				$("#accountManageNm").val(branchInfo.accountManageNm);          
				$("#accountTelNum").val( fnSetTelformat(branchInfo.accountTelNum) );            
				$("#bankCd").val(branchInfo.bankCd);                   
				$("#recipient").val(branchInfo.recipient);                
				$("#accountNum").val(branchInfo.accountNum);               
				$("#file_biz_reg_list").val(branchInfo.businessAttachFileSeq);
				$("#attach_file_biz_reg_name").text(branchInfo.businessAttachFileNm);     
				$("#attach_file_biz_reg_path").val(branchInfo.businessAttachFilePath);   
				$("#file_app_sal_list").val(branchInfo.appraisalAttachFileSeq);   
				$("#attach_file_app_sal_name").text(branchInfo.appraisalAttachFileNm);    
				$("#attach_file_app_sal_path").val(branchInfo.appraisalAttachFilePath);
				$("#file_list1").val(branchInfo.etcFirstSeq);
				$("#attach_file_name1").text(branchInfo.etcFirstNm);
				$("#attach_file_path1").val(branchInfo.etcSecondSeq);  
				$("#file_list2").val(branchInfo.etcSecondSeq);
				$("#attach_file_name2").text(branchInfo.etcSecondNm);
				$("#attach_file_path2").val(branchInfo.etcSecondPath);
				$("#file_list3").val(branchInfo.etcThirdSeq);
				$("#attach_file_name3").text(branchInfo.etcThirdNm);
				$("#attach_file_path3").val(branchInfo.etcThirdPath);  
				//$("#isUse").val(branchInfo.isUse);
// 				$("#branchGrad").val(branchInfo.branchGrad);
				$("#areaType").val(branchInfo.areaType);
				
				$("#loanLimit").val(fnComma(parseInt(branchInfo.clt_loan)));
				$("#cltIsOrderLimit").val(branchInfo.clt_islimit);
				$("#isOrderLimit").val(branchInfo.clt_islimit);
				
				$("#cltPrePay").val(branchInfo.clt_isprepay);
				$("#prePay").val(branchInfo.clt_isprepay);
				
//                 if(branchInfo.clt_islimit == 1){
//                     $("#isOrderLimit").prop("disabled",true);
//                     $("#isOrderLimit").val("1");
//                 }
//                 if(branchInfo.clt_isprepay == 1){
//                     $("#prePay").prop("disabled",true);
//                     $("#prePay").val("1");
//                 }
			} else {
				$("#clientNm").val(borgNm);
				$("#clientId").val(clientId);
				$("#clientCd").val("");
				$("#groupId").val(groupId);
				
                $.post(
                    "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/organBranchSearchForReg.sys", 
                    { clientId:clientId },
                    function(arg){ 
                        var branchInfo = eval('(' + arg + ')').data;
                        $("#loanLimit").val(fnComma(parseInt(branchInfo.clt_loan)));
                        $("#cltIsOrderLimit").val(branchInfo.clt_islimit);
                        $("#isOrderLimit").val(branchInfo.clt_islimit);
                        $("#cltPrePay").val(branchInfo.clt_isprepay);
                        $("#prePay").val(branchInfo.clt_isprepay);
//                         if(branchInfo.clt_islimit == 1){
// 							$("#isOrderLimit").prop("disabled",true);
//                         	$("#isOrderLimit").val("1");
//                         }
//                         if(branchInfo.clt_isprepay == 1){
//                             $("#prePay").prop("disabled",true);
//                         	$("#prePay").val("1");
//                         }
                    }
				);
				
			}
		}
	); 
}

function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
	n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}
</script>
<% //------------------------------------------------------------------------------ %>


<!-- 첨부파일관련 스크립트 -->
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
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};
</script>
<% //------------------------------------------------------------------------------ %>

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

<!--버튼 이벤트 스크립트-->
<script type="text/javascript">
$(document).ready(function(){
   $("#closeButton").click( function() { fnClose(); });
   $("#btnSave").click( function() { fnSave(); });
   //$("#delButton").click( function() { delRow(); });
   $("#clientCdConfirm").click( function() { fnClientCdConfirm(); });
   $("#loginIdConfirm").click( function() { fnLoginIdConfirm(); });
    
//    $("#postAddrNum").attr("disabled","true");
//    $("#addres").attr("disabled","true");
 });
</script>


<!-- 그리드 이벤트 스크립트-->
<script type="text/javascript">
   function fnClose(){
   //    window.dialogArguments.fnReloadGrid();
      window.close();
   }
   
   function fnDupCheck(type, event) {
      var key = window.event ? event.keyCode : event.which;  
      
      if(key == 13){
         
         if(type == "client"){
            fnClientCdConfirm();
         }
         else if(type == "login"){
            fnLoginIdConfirm();
         }
      }
   }
    
   function fnIsValidation(){
       
       var clientNm = $.trim($("#clientNm").val());
       var branchNm = $.trim($("#branchNm").val());
       var businessNum1 = $.trim($("#businessNum1").val());
       var businessNum2 = $.trim($("#businessNum2").val());
       var businessNum3 = $.trim($("#businessNum3").val());
//        var registNum1 = $.trim($("#registNum1").val());
//        var registNum2 = $.trim($("#registNum2").val());
       var branchBusiType = $.trim($("#branchBusiType").val());
       var branchBusiClas = $.trim($("#branchBusiClas").val());
       var pressentNm = $.trim($("#pressentNm").val());
       var phoneNum = $.trim($("#phoneNum").val());
       var eMail = $.trim($("#eMail").val());
       var postAddrNum = $.trim($("#postAddrNum").val());
       var addres = $.trim($("#addres").val());
       var file_biz_reg_list = $.trim($("#file_biz_reg_list").val());
       var areaType = $.trim($("#areaType").val());
       var branchGrad = $.trim($("#branchGrad").val());
       var payBillType = $.trim($("#payBillType").val());
//        var payBillDay = $.trim($("#payBillDay").val());
       var accountManageNm = $.trim($("#accountManageNm").val());
       var accountTelNum = $.trim($("#accountTelNum").val());
       var accUser = $.trim($("#accUser").val());
       var workId = $.trim($("#workId").val());
       //var bankCd = $.trim($("#bankCd").val());
       //var recipient = $.trim($("#recipient").val());
       //var accountNum = $.trim($("#accountNum").val());
       var srcContractSpecial = $("#srcContractSpecial").val();
       
       
       var loginId    = $.trim($("#loginId").val());   
       var pwd        = $.trim($("#pwd").val());       
       var pwdConfirm = $.trim($("#pwdConfirm").val());
       var userNm     = $.trim($("#userNm").val());    
       var tel        = $.trim($("#tel").val());       
       var mobile     = $.trim($("#mobile").val());    
       var userEmail  = $.trim($("#userEmail").val()); 
	   var autOrderLimitPeriod = $.trim($("#autOrderLimitPeriod").val());
	   
	   var sharpMail = $.trim($("#sharpMail").val());
//        if(clientNm == ""){
//            $("#dialog").html("<font size='2'>법인을 선택해주세요.</font>");
//            $("#dialog").dialog({
//               title: 'Success',modal: true,
//               buttons: {"Ok": function(){$(this).dialog("close");} }
//            });                         
//             return false;
//          }
       
//        if(branchBusiType == ""){
//           $("#dialog").html("<font size='2'>업종을 입력해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
       
//        if(businessNum1 == "" || businessNum2 == "" || businessNum3 == ""){
//           $("#dialog").html("<font size='2'>사업자 등록번호를 입력해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
       
//        if(branchBusiClas == ""){
//           $("#dialog").html("<font size='2'>업태를 입력해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
       
//        if(pressentNm == ""){
//           $("#dialog").html("<font size='2'>대표자명을 입력해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
       
//        if(phoneNum == ""){
//           $("#dialog").html("<font size='2'>대표 전화번호를 입력해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
       
//        if(postAddrNum == "" || addres == ""){
//           $("#dialog").html("<font size='2'>주소를 입력해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
       
//        if(eMail == ""){
//           $("#dialog").html("<font size='2'>회사이메일을 입력해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }else{
//           email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
//           if(!email_regex.test(eMail)){
//              $("#dialog").html("<font size='2'>회사이메일 유형을 확인해주세요.</font>");
//              $("#dialog").dialog({
//                 title: 'Success',modal: true,
//                 buttons: {"Ok": function(){$(this).dialog("close");} }
//              });            
//              return false; 
//           }
//        }
       
//        if(file_biz_reg_list == ""){
//           $("#dialog").html("<font size='2'>사업자등록첨부를 입력해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
       
       if(branchNm == ""){
         $("#dialog").html("<font size='2'>사업장명을 입력해주세요.</font>");
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
   
//        if(branchGrad == ""){
//           $("#dialog").html("<font size='2'>회원사등급을 선택해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
       
       
//        if(accUser == ""){
//            $("#dialog").html("<font size='2'>채권담당자를 선택해주세요.</font>");
//            $("#dialog").dialog({
//               title: 'Success',modal: true,
//               buttons: {"Ok": function(){$(this).dialog("close");} }
//            });         
//            return false;
//         }

       if(workId == ""){
           $("#dialog").html("<font size='2'>고객유형을 선택해주세요.</font>");
           $("#dialog").dialog({
              title: 'Success',modal: true,
              buttons: {"Ok": function(){$(this).dialog("close");} }
           });         
           return false;
        }
       
//        if(payBillType == ""){
//           $("#dialog").html("<font size='2'>결제조건을 선택해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
       
//        if(accountManageNm == ""){
//           $("#dialog").html("<font size='2'>회계담당자명을 입력해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
       
//        if(accountTelNum == ""){
//           $("#dialog").html("<font size='2'>회계이동전화번호를 입력해주세요.</font>");
//           $("#dialog").dialog({
//              title: 'Success',modal: true,
//              buttons: {"Ok": function(){$(this).dialog("close");} }
//           });         
//           return false;
//        }
	   if(autOrderLimitPeriod == ""){
           $("#dialog").html("<font size='2'>자재대금 결제일을 입력해주세요.</font>");
           $("#dialog").dialog({
              title: 'Success',modal: true,
              buttons: {"Ok": function(){$(this).dialog("close");} }
           });                         
            return false;
         }
      
       
		if($("#userSaveFlag").val()=="1") {	//담당자를 필수로 입력할 경우
       
			if(loginId == "") {
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
			} else {
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
			} else {
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
	       
// 			var roleCnt = $("#list2").getGridParam('reccount');
// 			if(roleCnt == 0){
// 				$("#dialog").html("<font size='2'>권한정보를 입력해주세요.</font>");
// 				$("#dialog").dialog({
// 					title: 'Success',modal: true,
// 					buttons: {"Ok": function(){$(this).dialog("close");} }
// 				});
// 				return false;          	   
// 			}
		}
// 		if(sharpMail == ""){
// 			$("#dialog").html("<font size='2'>SHARP-MAIL을 입력해주세요.</font>");
// 			$("#dialog").dialog({
// 				title: 'Success',modal: true,
// 				buttons: {"Ok": function(){$(this).dialog("close");} }
// 			});			 
// 			return false;
// 		}
			
		return true;
	}
 
   function fnSave(){
      var isValidation = fnIsValidation();
      //var isValidation = true;
      
      if(isValidation){
         var shippingPlaceArr    = Array();
         var shippingAddresArr   = Array();
         var shippingPhoneNumArr = Array();
         var deliveryCnt         = jq("#list").getGridParam('reccount');
         
         for(var i = 0 ; i < deliveryCnt ; i++){
            var rowid = $("#list").getDataIDs()[i];   
            var selrowContent    = jq("#list").jqGrid('getRowData',rowid);
            
            shippingPlaceArr[i]    =  selrowContent.shipping_place;
            shippingAddresArr[i]   =  selrowContent.shipping_addres;
            shippingPhoneNumArr[i] =  selrowContent.shipping_phonenum;
         }
         
         if(!confirm("입력한 정보를 등록 하시겠습니까?")) { return; }
         
         $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveOrganBranchReg.sys", 
            {
            	groupId:$.trim($("#groupId").val()),
            	branchNm:$.trim($("#branchNm").val()),
            	clientId:$.trim($("#clientId").val()),
            	clientCd:$.trim($("#clientCd").val()),
            	areaType:$.trim($("#areaType").val()),
            	branchGrad:$.trim($("#branchGrad").val()),
            	businessNum:$.trim($("#businessNum1").val()) + $.trim($("#businessNum2").val()) + $.trim($("#businessNum3").val()),
            	registNum:$.trim($("#registNum1").val()) + $.trim($("#registNum2").val()) + $.trim($("#registNum3").val()),
            	branchBusiType:$.trim($("#branchBusiType").val()),
            	branchBusiClas:$.trim($("#branchBusiClas").val()),
            	pressentNm:$.trim($("#pressentNm").val()),
            	phoneNum:$.trim($("#phoneNum").val()),
            	eMail:$.trim($("#eMail").val()),
            	homePage:$.trim($("#homePage").val()),
            	postAddrNum:$.trim($("#postAddrNum").val()),
            	addres:$.trim($("#addres").val()),
            	addresDesc:$.trim($("#addresDesc").val()),
            	faxNum:$.trim($("#faxNum").val()),
            	loginAuthType:$.trim($("#loginAuthType").val()),
            	orderAuthType:$.trim($("#orderAuthType").val()),
            	refereceDesc:$.trim($("#refereceDesc").val()),
            	payBillType:$.trim($("#payBillType").val()),
//             	payBillDay:$.trim($("#payBillDay").val()),
            	prePay:$.trim($("#prePay").val()),
            	accountManageNm:$.trim($("#accountManageNm").val()),
            	accountTelNum:$.trim($("#accountTelNum").val()),
            	bankCd:$.trim($("#bankCd").val()),
            	recipient:$.trim($("#recipient").val()),
            	accountNum:$.trim($("#accountNum").val()),
            	file_biz_reg_list:$.trim($("#file_biz_reg_list").val()),
            	file_app_sal_list:$.trim($("#file_app_sal_list").val()),
            	file_list1:$.trim($("#file_list1").val()),
            	file_list2:$.trim($("#file_list2").val()),
            	file_list3:$.trim($("#file_list3").val()),
                loginId:$("#loginId").val(),
                userId:$("#userId").val(),
                pwd:$("#pwd").val(),
                userNm:$("#userNm").val(),
                tel:$("#tel").val(),
                mobile:$("#mobile").val(),
                userEmail:$("#userEmail").val(),
                isUse:$("#isUse").val(),
                shippingPlaceArr:shippingPlaceArr,
                shippingAddresArr:shippingAddresArr,
                shippingPhoneNumArr:shippingPhoneNumArr,
//                 roleCdArr:roleCdArr,
//                 roleNmArr:roleNmArr,
//                 roleDescArr:roleDescArr,
                roleIdArr:new Array('13131','13081'),
                accUser:$.trim($("#accUser").val()),
                workId:$.trim($("#workId").val()),
                userSaveFlag:$("#userSaveFlag").val(),
                autOrderLimitPeriod:$("#autOrderLimitPeriod").val(),
                srcContractSpecial:$("#srcContractSpecial").val(),
                sharpMail:$("#sharpMail").val(),
                clientNm:$("#clientNm").val()//법인명
            },       
            
            function(arg){ 
               if(fnAjaxTransResult(arg)) {  //성공시
// 					var opener = window.dialogArguments;
            	    window.opener.fnSearch();
					window.close();
               }
            }
         );    
      }
   }
 
   function addRow(shipping_place, shipping_phonenum, shipping_addres) {
      var rowCnt = jq("#list").getGridParam('reccount');
      jq("#list").addRowData(rowCnt + 1, {shipping_place:shipping_place,shipping_phonenum:shipping_phonenum,shipping_addres:shipping_addres});
   }
   
   function delRow() {
      var id = $("#list").jqGrid('getGridParam', "selrow" );  
      
      if(id == null) {
         alert("삭제할 데이터를 선택해주세요.");
         return;
      }
      
      jQuery("#list").delRowData(id);
   }
   
   function fnClientCdConfirm(){
      if($.trim($("#clientCd").val()) == ""){
         $("#dialog").html("<font size='2'>법인코드를 입력해주세요.</font>");
         $("#dialog").dialog({
            title: 'Success',modal: true,
            buttons: {"Ok": function(){$(this).dialog("close");} }
         });      
         return;
      }
      
      $.post(
         "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/reqBorgDupCheck.sys", 
         { clientCd:$("#clientCd").val() },
         function(arg){ 
            if(fnTransResult(arg, false)) {
               $("#dialog").html("<font size='2'>사용가능합니다.</font>");
               $("#dialog").dialog({
                  title: 'Success',modal: true,
                  buttons: {"Ok": function(){$(this).dialog("close");} }
               });
            }
         }
      );
   }
   function fnStatChange(){
	   var isUse = $("#isUse").val();
	   
	   if(isUse == "1"){
	      $("#closeReason").attr("disabled", true);
	      $("#closeReason").val("");
	   }else if(isUse == "0"){
	      $("#closeReason").attr("disabled", false);
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
   
   //담당자 입력여부 세팅(displayFlag -> 1:필수입력, 0:담당자 none display)
   function fnUserDivDisplay(displayFlag) {
	   if(displayFlag=='0') {
		   $("#userDiv").hide();
	   } else {
		   $("#userDiv").show();
	   }
	   
   }
   
   //물품공급계약서 구분
    $(document).ready(function(){
        fnContractSpecial();
    });
       
       
    function fnContractSpecial(){
        $.post(
            '/organ/contractSpecialList.sys',
            function(arg){
                var result = eval("("+arg+")");
                for(var i=0; i<result.list.length; i++){
                $("#srcContractSpecial").append("<option value='"+result.list[i].codeVal1+"' dir='"+result.list[i].codeVal2+"'>"+result.list[i].codeNm1+"</option>");
                }
            }
        );
    }
</script>
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
	$("#userSearch").click(function(){
		var clientId = '<%=loginUserDto.getClientId()%>';	
		fnJqmUserInitSearch("", "", "BUY", "fnSelectUserCallback", clientId, '<%=loginUserDto.getBorgNms().substring(0 , loginUserDto.getBorgNms().indexOf("&gt;")).replace("&gt;", "")%>');
	});
});

/**
 * 사용자검색 Callback Function
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms, mobile) {
	$("#loginId").val( loginId );
	$("#userId").val( userId );
}
</script>
<% //------------------------------------------------------------------------------ %>
</head>
<body>

   <form id="frm" name="frm" method="post" onsubmit="return false;">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
                     </td>
                     <td height="29" class='ptitle'>법인사용자 사업장</td>
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
                     <td class="stitle"  style="width: 100px;">사업장 일반정보</td>
                     <td >
                     	<button class="btn btn-darkgray btn-xs" onclick="window.open('https://www.hometax.go.kr/websquare/websquare.wq?w2xPath=/ui/pp/index_pp.xml&tmIdx=01&tm2lIdx=0108000000&tm3lIdx=0108010000')">
							국세청조회
						</button>
					</td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="6" class="table_top_line"></td>
                    </tr>
                  <tr>
                     <td class="table_td_subject">법인</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="clientNm" name="clientNm" type="text" value="" size="40" maxlength="50" readonly="readonly" class="disabled" />
                        <input id="clientId" name="clientId" type="hidden" value=""  />
                        <input id="clientCd" name="clientCd" type="hidden" value="" />
                        <input id="groupId" name="groupId" type="hidden" value="" />
                        <a href="#"> <img id="srcClientBtn" name="srcClientBtn" src="/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search' style="border: 0px; vertical-align: middle;" /> </a>
                     </td>
                     <td class="table_td_subject">업종</td>
                     <td class="table_td_contents">
                        <input id="branchBusiType" name="branchBusiType" type="text" value="" size="20" maxlength="30" style="width: 98%" class="disabled"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
	                  <td class="table_td_subject" width="100">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 15px;">
							<tr>
								<td>사업자등록번호</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
									
									
								</td>
							</tr>
						</table>
					  </td>
                     <td class="table_td_contents">
                        <input id="businessNum1" name="businessNum1" type="text" value="" size="3" maxlength="3"  class="disabled" />
                        -
                        <input id="businessNum2" name="businessNum2" type="text" value="" size="2" maxlength="2"  class="disabled" />
                        -
                        <input id="businessNum3" name="businessNum3" type="text" value="" size="5" maxlength="5"  class="disabled" />
                     </td>
                     <td class="table_td_subject" width="100">법인등록번호</td>
                     <td class="table_td_contents">
                        <input id="registNum1" name="registNum1" type="text" value="" size="6" maxlength="6" onkeydown="return onlyNumber(event)" class="disabled" />
                        -
                        <input id="registNum2" name="registNum2" type="text" value="" size="7" maxlength="7" onkeydown="return onlyNumber(event)" class="disabled" />
                     </td>
                     <td class="table_td_subject" width="100">업태</td>
                     <td class="table_td_contents">
                        <input id="branchBusiClas" name="branchBusiClas" type="text" value="" size="23" maxlength="30"  class="disabled" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
	                  <td class="table_td_subject" width="100">대표자</td>
                     <td class="table_td_contents">
                        <input id="pressentNm" name="pressentNm" type="text" value="" size="20" maxlength="30"  class="disabled" />
                     </td>
                     <td class="table_td_subject" width="100">대표전화</td>
                     <td class="table_td_contents">
                        <input id="phoneNum" name="phoneNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)" class="disabled"  />
                     </td>
                     <td class="table_td_subject" width="100">팩스번호</td>
                     <td class="table_td_contents">
                        <input id="faxNum" name="faxNum" type="text" value="" size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)" class="disabled" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">주소</td>
                     <td colspan="5" class="table_td_contents">
                        <input id="postAddrNum" name="postAddrNum" type="text" value="" size="10" maxlength="10" class="disabled" />
                        <a href="#;" style="display: none;"> <img id="btnPost" src="/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search' style="border: 0px; vertical-align: middle;" /> </a>
                        <input id="addres" name="addres" type="text" value="" size="20" maxlength="30" style="width: 30%" class="disabled" />
                        <input id="addresDesc" name="addresDesc" type="text" value="" size="20" maxlength="30" style="width: 40%" class="disabled" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">회사이메일</td>
                     <td colspan="5" class="table_td_contents">
                        <input id="eMail" name="eMail" type="text" value="" size="63" maxlength="30" style="ime-mode: disabled;" class="disabled"  />
                        ex)admin@unpamsbank.com
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">
                        <table>
                           <tr>
                              <td>회사샵(#)메일</td>
                           </tr>
                        </table>
                     </td>
                     <td colspan="5" class="table_td_contents">
                        <input id="sharpMail" name="sharpMail" type="text" value="" size="20" maxlength="30" class="disabled"  /> ex)법인사업자 : 대표#unpamsbank.법인, 개인사업자 : 대표#unpamsbank.사업
                    </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
	                  <td class="table_td_subject" width="100">회계담당자</td>
                     <td class="table_td_contents" colspan="3">
                        <input id="accountManageNm" name="accountManageNm" type="text" value="" size="20" maxlength="30"/>
                        (<input id="accountTelNum" name="accountTelNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event);"/>)
                     </td>
                     <td class="table_td_subject" width="100">홈페이지</td>
                     <td class="table_td_contents">
                        <input id="homePage" name="homePage" type="text" value="" size="20" maxlength="30" style="ime-mode: disabled;" class="disabled"  />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
	                  <td class="table_td_subject" width="100">대금정산정보</td>
                     <td class="table_td_contents" colspan="5">
                        <select class="select" id="bankCd" name="bankCd" disabled="disabled">
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
                        </select> 은행,
                        <input id="accountNum" name="accountNum" type="text" value="" size="20" maxlength="20" onkeydown="return onlyNumber(event)" class="disabled" /> (-없이),
                        예금주 : <input id="recipient" name="recipient" type="text" value="" size="20" maxlength="30" class="disabled"  />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
	                  <td class="table_td_subject" width="100">여신금액</td>
                     <td class="table_td_contents">
                     	<input id="loanLimit" name="loanLimit" type="text" size="20" maxlength="30" style="width: 98%" value="-" readonly="readonly" class="disabled" />
                     </td>
                     <td class="table_td_subject" width="100">법인주문제한</td>
                     <td class="table_td_contents">
                     	<select id="cltIsOrderLimit" name="cltIsOrderLimit" class="select" disabled="disabled" readonly="readonly"  style="background-color: #eeeeee">
                     		<option value="">법인주문제한</option>
                     		<option value="0">아니오</option>
                     		<option value="1" >제한</option>
                     	</select>
                     </td>
                     <td class="table_td_subject" width="100">법인선입금</td>
                     <td class="table_td_contents">
                        <select class="select" id="cltPrePay" name="cltPrePay" disabled="disabled" readonly="readonly" style="background-color: #eeeeee">
                           <option value="" >법인선입금</option> 
                           <option value="0" >아니요</option> 
                           <option value="1" >예</option> 
                        </select> 
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
	                  <td class="table_td_subject" width="100">운영상태</td>
                     <td class="table_td_contents">
                        <select class="select" id="isUse" name="isUse" onchange="javaScript:fnStatChange();" disabled="disabled">
                           <option value="1" selected="selected">정상</option>
                           <option value="0">종료</option>
                        </select>
                     </td>
                     <td class="table_td_subject" width="100">채권담당자</td>
                     <td class="table_td_contents" >
		                <select id="accUser" name="accUser" class="select"  disabled="disabled">
                            <option value="">전체</option>
<%
   @SuppressWarnings("unchecked")
   List<UserDto> admUserList = (List<UserDto>) request.getAttribute("admUserList");

   if(admUserList != null && admUserList.size() > 0){

      for(UserDto userDto : admUserList){
%>                              
                             <option value="<%=userDto.getUserId()%>" <%if("lovely".equals(userDto.getUserId())){ %> selected="selected" <%} %> ><%=userDto.getUserNm()%></option>
<%
      }
   }
%>                              
                     </td>
                     <td class="table_td_subject" width="100">참고사항</td>
                     <td class="table_td_contents" >
                        <input id="refereceDesc" name="refereceDesc" type="text" value="" size="20" maxlength="1000" style="width: 98%" class="disabled" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">
                        사업자등록첨부 
                     </td>
                     <td class="table_td_contents">
                        <input type="hidden" id="file_biz_reg_list" name="file_biz_reg_list" value="<%=file_biz_reg_list%>" />
                        <input type="hidden" id="attach_file_biz_reg_path" name="attach_file_biz_reg_path" value="<%=attach_file_biz_reg_path%>" />
                        <a href="javascript:fnAttachFileDownload($('#attach_file_biz_reg_path').val());"> <span id="attach_file_biz_reg_name"><%=attach_file_biz_reg_name%></span>
                        </a>
                     </td>
                     <td class="table_td_subject" width="100">
                        신용평가서첨부
                     </td>
                     <td class="table_td_contents">
                        <input type="hidden" id="file_app_sal_list" name="file_app_sal_list" value="<%=file_app_sal_list%>" />
                        <input type="hidden" id="attach_file_app_sal_path" name="attach_file_app_sal_path" value="<%=attach_file_app_sal_path%>" />
                        <a href="javascript:fnAttachFileDownload($('#attach_file_app_sal_path').val());"> <span id="attach_file_app_sal_name"><%=attach_file_app_sal_name%></span>
                        </a>
                     </td>
                     <td class="table_td_subject" width="100">
                        통장사본첨부
                     </td>
                     <td class="table_td_contents">
                        <input type="hidden" id="file_list1" name="file_list1" value="<%=file_list1%>" />
                        <input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1%>" />
                        <a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());"> <span id="attach_file_name1"><%=attach_file_name1%></span>
                        </a>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100"> 공사계약서
                     </td>
                     <td class="table_td_contents">
                        <input type="hidden" id="file_list2" name="file_list2" value="<%=file_list2%>" />
                        <input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2%>" />
                        <a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());"> <span id="attach_file_name2"><%=attach_file_name2%></span>
                        </a>
                     </td>
                     <td class="table_td_subject" width="100"> 회사소개서 
                        </a>
                     </td>
                     <td class="table_td_contents" colspan="3">
                        <input type="hidden" id="file_list3" name="file_list3" value="<%=file_list3%>" />
                        <input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3%>" />
                        <a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());"> <span id="attach_file_name3"><%=attach_file_name3%></span>
                        </a>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                </table>
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
                     <td class="stitle">사업장정보</td>
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
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">사업장명</td>
                     <td class="table_td_contents">
                        <input id="branchNm" name="branchNm" type="text" value="" size="40" maxlength="50" style="width: 98%" />
                        <input type="hidden" id="branchGrad" name="branchGrad" value="30" alt="공사등급(일반)"/>
                        <input type="hidden" id="payBillType" name="payBillType" value="1060" alt="결제조건(60일)" />
                        
                     </td>
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">권역</td>
                     <td class="table_td_contents" >
                        <select class="select" id="areaType" name="areaType"  >
                           <option value="">선택하세요</option>
<%
	@SuppressWarnings("unchecked")
    List<CodesDto> areaCode = (List<CodesDto>) request.getAttribute("areaCode");
    for (CodesDto areaCd : areaCode) {
    	if(!areaCd.getCodeVal1().equals("99")){
%>
                           <option value="<%=areaCd.getCodeVal1()%>"><%=areaCd.getCodeNm1()%></option>
<%
		}
	}
%>
                        </select>
                     </td>
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">고객유형</td>
                     <td class="table_td_contents">
		                	<select id="workId" name="workId" class="select" style="width: 120px; ">
                            	<option value="">전체</option>
<%
   @SuppressWarnings("unchecked")
   List<WorkInfoDto> workInfoList = (List<WorkInfoDto>) request.getAttribute("workInfoList");

   if(workInfoList != null && workInfoList.size() > 0){

      for(WorkInfoDto workInfoDto : workInfoList){
%>                              
                                 <option value="<%=workInfoDto.getWorkId()%>"    dir="<%=workInfoDto.getContract_cd()%>"><%=workInfoDto.getWorkNm()%></option>
<%
      }
   }
%>                              
                        	</select>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">로그인인증</td>
                     <td class="table_td_contents">
                        <select class="select" id="loginAuthType" name="loginAuthType" >
                           <option value="10">모바일인증</option>
                           <option value="20">일반</option>
                        </select>
                     </td>
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">주문인증</td>
                     <td class="table_td_contents">
                        <select class="select" id="orderAuthType" name="orderAuthType" >
                           <option value="10">공인인증</option>
                           <option value="20">일반</option>
                        </select>
                     </td>
                     <td class="table_td_subject" width="100">계약구분</td>
                     <td class="table_td_contents">
                        <select id="srcContractSpecial" name="srcContractSpecial" disabled="disabled" class="select">
                           <option value="">선택하세요</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">주문제한여부</td>
                     <td class="table_td_contents">
                     	<select id="isOrderLimit" name="isOrderLimit"  disabled="disabled" class="select">
                     		<option value="0">아니오</option>
                     		<option value="1" >제한</option>
                     	</select>
                     </td>
                     <td class="table_td_subject" width="100">선입금여부</td>
                     <td class="table_td_contents" >
                        <select class="select" id="prePay" name="prePay" style="width: 125px;" disabled="disabled">
                           <option value="0">아니요</option> 
                           <option value="1">예</option> 
                        </select> 
                     </td>
                    <td class="table_td_subject"><font color="red"><b>자재대금 결제일</b></font></td>
                    <td class="table_td_contents">
						<input id="autOrderLimitPeriod" type="text" name="autOrderLimitPeriod" value="0" style="width: 30px;" class="disabled"/> 일
						<br/><font color="#000000" style="font-size: 6px;">(세금계산서 발행일로부터)</font>
                    </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
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
                     <td class="stitle" width="80">담당자 정보</td>
                     <td align="left">
                     	<select class="select" id="userSaveFlag" name="userSaveFlag" onchange="fnUserDivDisplay(this.value);">
                     		<option value="1">담당자 입력 필수</option>
                     		<option value="0">담당자 없이 등록</option>
                     		<option value="2">담당자 선택</option>
                     	</select>
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <!-- 컨텐츠 시작 -->
               <div id="userDiv">
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="4" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">로그인ID</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="loginId" name="loginId" type="text" value="" size="40" maxlength="50" onkeydown="return fnDupCheck('login', event)" style="ime-mode: disabled; vertical-align: bottom;" />
                        <input id="userId" name="userId" type="hidden" value=""/>
                        <button id='loginIdConfirm' class="btn btn-darkgray btn-xs">중복확인</button>
                        <button id='userSearch' class="btn btn-darkgray btn-xs" style="display: none;">담당자선택</button>
                        
                     </td>
                  </tr>
                  <tr class="userInput">
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr class="userInput">
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">비밀번호</td>
                     <td class="table_td_contents">
                        <input id="pwd" name="pwd" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;" />
                     </td>
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">비밀번호 확인</td>
                     <td class="table_td_contents">
                        <input id="pwdConfirm" name="pwdConfirm" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;" />
                     </td>
                  </tr>
                  <tr class="userInput">
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr class="userInput">
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">성명</td>
                     <td class="table_td_contents">
                        <input id="userNm" name="userNm" type="text" value="" size="20" maxlength="30" />
                     </td>
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">전화번호</td>
                     <td class="table_td_contents">
                        <input id="tel" name="tel" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)" />
                     </td>
                  </tr>
                  <tr class="userInput">
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr class="userInput">
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">이동전화번호</td>
                     <td class="table_td_contents">
                        <input id="mobile" name="mobile" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)" />
                     </td>
                     <td class="table_td_subject" width="100" style="background-color:darkgray;">이메일</td>
                     <td class="table_td_contents">
                        <input id="userEmail" name="userEmail" type="text" value="" size="50" maxlength="40" style="ime-mode: disabled;" />
                        ex)admin@unpamsbank.com
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
               </table>
               </div>
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
            <td align="center">
               <button id='btnSave' class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
               <button id='closeButton' class="btn btn-default btn-sm"><i class="fa fa-times"></i> 닫기</button>
            </td>
         </tr>

      </table>
   </form>
</body>
<script type="text/javascript">
$(document).ready(function(){
	$(".disabled").prop("disabled",true);
	$(".disabled").css("background-color","#eeeeee");
	$("select[disabled=disabled]").css("background-color","#eeeeee");
	
	$("#userSaveFlag").change(function(){
		if( this.value == 2 ){ // 기존담당자 등록
				$("#userSearch").show();		
				$("#loginIdConfirm").hide();		
				$(".userInput").hide();
				$("#loginId").prop("disabled",true);
		}else{
				$("#userSearch").hide();		
				$("#loginIdConfirm").show();		
				$(".userInput").show();
				$("#loginId").prop("disabled",false);			
		}
	});
	
	$("#workId").change(function(){
		var contract_cd = $(this).find(":selected").attr("dir");
		$("#srcContractSpecial").val( contract_cd );
		var autOrderLimitPeriod = $("#srcContractSpecial").find(":selected").attr("dir");
		$("#autOrderLimitPeriod").val( autOrderLimitPeriod );
			
	});
	
});
</script>
</html>