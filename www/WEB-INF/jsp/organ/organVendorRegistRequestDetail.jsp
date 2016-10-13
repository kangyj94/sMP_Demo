<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpVendorsDto"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "50";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	String userRoleCd 	= CommonUtils.getString((String)request.getAttribute("userRoleCd"));
	String vendorId = (String)request.getAttribute("vendorId");
	
	SmpVendorsDto detailDto =  (SmpVendorsDto)request.getAttribute("detailInfo");
	SmpUsersDto   userDto   =  (SmpUsersDto)request.getAttribute("userInfo");	
	
	String sharpMail = detailDto.getSharp_mail()== null ? "":detailDto.getSharp_mail();
	String classify = detailDto.getClassify() == null ? "":detailDto.getClassify();//구분
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String confirmorId = detailDto.getConfirmorId() == null ? userInfoDto.getUserNm() : detailDto.getConfirmorId();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->

<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#roleAddButton").click(function(){
		fnJqmAddRole();
	});		
	
	$("#roleDelButton").click(function(){
		fnRoleDel();
	});		

	$("#btnApp").click(function(){
		fnApply("20");
	});		

	$("#btnReqApp").click(function(){
		fnApply("30");
	});		
	
	$("#btnConfirm").click(function(){
		fnApply("40");
	});
	
	$("#btnReqDefer").click(function(){
		fnApply("09");
	});
	
	$("#btnReqSave").click(function(){
		fnApply("00");
	});
	
	$("#btnReqSave").click(function(){
		fnApplySave();
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
	
	$("#postAddrNum").attr("disabled","true");
	$("#addres").attr("disabled","true");
	
	$("#saveButton").click(function(){
		updateReqSmpvendors();
	});	
	
	
	$("#closeButton").click(function(){
		window.close();
	});
	
});

//리사이징
// $(window).bind('resize', function() { 
//     $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
// }).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/getDefaultBorgRole.sys?borgId=<%=vendorId%>',  
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
		height: <%=listHeight%>,autowidth: true,
		sortname: 'a.roleId', sortorder: "asc", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
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
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};
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
	fnJqmAddRoleListInit("VEN","fnAddRoleCallBack");
}
function fnAddRoleCallBack(roleId, roleCd, roleNm, isDefault, borgScopeCd, roleDesc) {
	var rowCnt = $("#list").getGridParam('reccount');
	for(var i=0;i<rowCnt;i++) {
		var rowid = $("#list").getDataIDs()[i];
		var selrowContent = $("#list").jqGrid('getRowData',rowid);
		if(roleId == selrowContent.roleId) { alert("이미 등록된 권한입니다."); return; }
	}
	$.post(	//권한등록
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveUserRoles.sys',
		{ oper:'add', roleId:roleId, borgId:'<%=vendorId %>' , userId:'<%=userDto.getUserId() %>' , isDefault:isDefault, borgScopeCd:borgScopeCd },
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if (result.success == false) {
				var errors = "";
				for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
				alert(errors);
			} else {
				$("#list").trigger("reloadGrid");	
			}
		}
	);
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
		{ oper:'del', userId:selrowContent.userId, roleId:selrowContent.roleId, borgId:selrowContent.borgId},
		function(arg){
			if(fnAjaxTransResult(arg)) {
				jq("#list").trigger("reloadGrid");	
			}
		}
	);
}

</script>
<%//----------------------------------권한팝업 사용방법 끝----------------------------------------%>

<script type="text/javascript">

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
	var phoneNum =$.trim( $("#phoneNum").val());
	var eMail =$.trim( $("#eMail").val());
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
	var userNm     = $.trim($("#userNm").val());    
	var tel        = $.trim($("#tel").val());       
	var mobile     = $.trim($("#mobile").val());    
	var userEmail  = $.trim($("#userEmail").val()); 
	var refereceDesc = $.trim($("#refereceDesc").val());
	var sharpMail = $.trim($("#sharpMail").val());
	var classify = $.trim($("#classify").val());
	
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
	
// 	 if(registNum1 == "" || registNum2 == ""){
// 		 $("#dialog").html("<font size='2'>법인 등록번호를 입력해주세요.</font>");
// 		 $("#dialog").dialog({
// 			 title: 'Success',modal: true,
// 			 buttons: {"Ok": function(){$(this).dialog("close");} }
// 		 });			 
// 		 return false;
// 	 }
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
		$("#dialog").html("<font size='2'>회계담당자 연락처를 입력해주세요..</font>");
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
	if(refereceDesc == ""){
		$("#dialog").html("<font size='2'>종합의견을 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
		return false;
	}
	var roleCnt = $("#list").getGridParam('reccount');
	if(roleCnt == 0) {
		$("#dialog").html("<font size='2'>1개 이상의 권한을 설정해주세요.</font>");
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
// 	var isValidation = fnIsValidation(); 
	var confirmMsg = null;	
	
	if("00" == registerCd)		  confirmMsg = "해당법인을 저장 하시겠습니까?";
	if("09" == registerCd)     	  confirmMsg = "해당법인을 처리보류 하시겠습니까?";
	if("20" == registerCd)     	  confirmMsg = "해당공급사를 승인요청 하시겠습니까?";
	else if("30" == registerCd)   confirmMsg = "해당공급사를 1차 승인 하시겠습니까?";
	else if("40" == registerCd)   confirmMsg = "해당공급사를 최종 승인 하시겠습니까?";
	
	if("00" == registerCd || "09" == registerCd){
		if(!confirm(confirmMsg)) return;
		
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/updateVendorReq.sys", 
			{
				file_biz_reg_list:$("#file_biz_reg_list").val(),
				file_app_sal_list:$("#file_app_sal_list").val(),
				file_list1:$("#file_list1").val(),
				file_list2:$("#file_list2").val(),
				file_list3:$("#file_list3").val(),
				
				vendorId:'<%=vendorId%>',
				vendorCd:$("#vendorCd").val(),
				vendorNm:$("#vendorNm").val(),
				businessNum1:$("#businessNum1").val(),
				businessNum2:$("#businessNum2").val(),
				businessNum3:$("#businessNum3").val(),
				registNum1:$("#registNum1").val(),
				registNum2:$("#registNum2").val(),
				vendorBusiType:$("#vendorBusiType").val(),
				vendorBusiClas:$("#vendorBusiClas").val(),
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
				loginAuthType:'20',
				userId:$("#userId").val(),
				registerCd:registerCd,
				sharpMail:$("#sharpMail").val(),
				classify:$("#classify").val()
			},			
			function(arg){ 
				if(fnAjaxTransResult(arg)) {	//성공시
// 					var opener = window.dialogArguments;
					window.opener.fnVendorSearch();
					window.close();
				}
			}
		);
	}
	else if(fnIsValidation()){
		if(!confirm(confirmMsg)) return;
		if("40" == registerCd){
			$.post(
					"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/reqBorgAppMessage.sys",
					{},
					function(arg){
						if(fnAjaxTransResult(arg)) {  //성공시
// 							window.opener.fnVendorSearch();
							window.opener.fnDeleteRow('<%=vendorId%>');
							setTimeout(function(){ window.close(); }, 1000);
							$.post(
								"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/updateVendorReq.sys", 
								{
									file_biz_reg_list:$("#file_biz_reg_list").val(),
									file_app_sal_list:$("#file_app_sal_list").val(),
									file_list1:$("#file_list1").val(),
									file_list2:$("#file_list2").val(),
									file_list3:$("#file_list3").val(),
									
									vendorId:'<%=vendorId%>',
									vendorCd:$("#vendorCd").val(),
									vendorNm:$("#vendorNm").val(),
									businessNum1:$("#businessNum1").val(),
									businessNum2:$("#businessNum2").val(),
									businessNum3:$("#businessNum3").val(),
									registNum1:$("#registNum1").val(),
									registNum2:$("#registNum2").val(),
									vendorBusiType:$("#vendorBusiType").val(),
									vendorBusiClas:$("#vendorBusiClas").val(),
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
									loginAuthType:'20',
									userId:$("#userId").val(),
									registerCd:registerCd,
									sharpMail:$("#sharpMail").val(),
									classify:$("#classify").val()
								},			
								function(arg){
								}
							);
						}
					}
				);
		}else{
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/updateVendorReq.sys", 
				{
					file_biz_reg_list:$("#file_biz_reg_list").val(),
					file_app_sal_list:$("#file_app_sal_list").val(),
					file_list1:$("#file_list1").val(),
					file_list2:$("#file_list2").val(),
					file_list3:$("#file_list3").val(),
					
					vendorId:'<%=vendorId%>',
					vendorCd:$("#vendorCd").val(),
					vendorNm:$("#vendorNm").val(),
					businessNum1:$("#businessNum1").val(),
					businessNum2:$("#businessNum2").val(),
					businessNum3:$("#businessNum3").val(),
					registNum1:$("#registNum1").val(),
					registNum2:$("#registNum2").val(),
					vendorBusiType:$("#vendorBusiType").val(),
					vendorBusiClas:$("#vendorBusiClas").val(),
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
					loginAuthType:'20',
					userId:$("#userId").val(),
					registerCd:registerCd,
					sharpMail:$("#sharpMail").val(),
					classify:$("#classify").val()
				},			
				function(arg){ 
					if(fnAjaxTransResult(arg)) {	//성공시
	// 					var opener = window.dialogArguments;
						window.opener.fnVendorSearch();
						window.close();
					}
				}
			);
		}
	}
}

function fnCancel() {
	
	var userRoleCd = '<%=userRoleCd%>';
	var registerCd = '<%=detailDto.getRegisterCd()%>';
	var confirmMsg = null;
	   
	if("10" == registerCd)     	  confirmMsg = "해당공급사요청 데이터가 모두 삭제됩니다. \n계속 진행하시겠습니까?";
	else if("20" == registerCd)   confirmMsg = "해당공급사요청이 '등록요청' 상태로 되돌아갑니다. \n계속 진행하시겠습니까?";
	else if("30" == registerCd)   confirmMsg = "해당공급사요청이 '승인요청' 상태로 되돌아갑니다. \n계속 진행하시겠습니까?";
	
	if(!confirm(confirmMsg)) return;
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/cancelVendorReq.sys", 
		{
			vendorId:'<%=vendorId%>',
			vendorCd:$("#vendorCd").val(),
			userRoleCd:userRoleCd,
			userId:$("#userId").val(),
			registerCd:registerCd
		},			
		
		function(arg){ 
			if(fnAjaxTransResult(arg)) {	//성공시
//            		var opener = window.dialogArguments;
           		window.opener.fnVendorSearch();
           		window.close();
			}
		}
	);		
}
</script>

<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	$("#btnBizRegAttach").click(function(){ fnUploadDialog("사업자등록첨부", $("#file_biz_reg_list").val(), "fnCallBackAttachBizReq"); });
	$("#btnAppSalAttach").click(function(){ fnUploadDialog("신용평가서첨부", $("#file_app_sal_list").val(), "fnCallBackAttachAppSal"); });
	$("#btnAttach1").click(function(){ fnUploadDialog("통장사본첨부", $("#file_list1").val(), "fnCallBackAttach1"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("기타첨부1", $("#file_list2").val(), "fnCallBackAttach2"); });
	$("#btnAttach3").click(function(){ fnUploadDialog("회사소개서", $("#file_list3").val(), "fnCallBackAttach3"); });
	$("#btnAttach4").click(function(){ fnUploadDialog("기타첨부2", $("#file_list4").val(), "fnCallBackAttach4"); });
	$("#saveButton").click(function(){ updateReqSmpBranchs(); });
	selectReqVendorClassify();//공급사 구분

	//전화번호 형식으로 변경
	$("#phoneNum").val( fnSetTelformat( $("#phoneNum").val() ) );
	$("#faxNum").val( fnSetTelformat( $("#faxNum").val() ) );
	$("#accountTelNum").val( fnSetTelformat( $("#accountTelNum").val() ) );
	$("#tel").val( fnSetTelformat( $("#tel").val() ) );
	$("#mobile").val( fnSetTelformat( $("#mobile").val() ) );
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
 * 회사소개서 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#file_list3").val(rtn_attach_seq);
   $("#attach_file_name3").text(rtn_attach_file_name);
   $("#attach_file_path3").val(rtn_attach_file_path);
}

/**
 * 회사소개서 파일관리
 */
function fnCallBackAttach4(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list4").val(rtn_attach_seq);
	$("#attach_file_name4").text(rtn_attach_file_name);
	$("#attach_file_path4").val(rtn_attach_file_path);
}

</script>
<script type="text/javascript">

//구분항목
function selectReqVendorClassify(){
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"REQVENDOR_CLASSIFY",//신규자재 코드와 같이 사용
			isUse:"1"
		},
		function(arg){
			var reqVendorClassify = eval('('+arg+')').list;
			for(var i=0; i<reqVendorClassify.length; i++){
				$("#classify").append("<option value='"+reqVendorClassify[i].codeVal1+"'>"+reqVendorClassify[i].codeNm1+"</option>");
			}
			var classify = "<%=classify%>";
			if(classify != ""){
				$("#classify").val(classify);
			}
		}
	);
}

//공급사정보 수정
function updateReqSmpvendors(){
	if(!confirm("수정한 내용을 저장하시겠습니까?")) return;
	$.post(
		"/organ/updateReqSmpVendors.sys", 
		{
			vendorId:'<%=vendorId%>',
			file_biz_reg_list:$("#file_biz_reg_list").val(),
			file_app_sal_list:$("#file_app_sal_list").val(),
			file_list1:$("#file_list1").val(),
			file_list2:$("#file_list2").val(),
			file_list3:$("#file_list3").val(),
			file_list4:$("#file_list4").val()
		},
		function(arg){ 
			if(fnAjaxTransResult(arg)) {  //성공시
			}
		}
	);
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
					<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
					<td height="29" class='ptitle'>공급사등록요청</td>
				</tr>
			</table> <!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
				<tr>
					<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
					<td class="stitle">공급사 일반정보</td>
				</tr>
			</table> <!-- 타이틀 끝 -->
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
					<td class="table_td_subject9" width="100">공급사명</td>
					<td colspan="5" class="table_td_contents">
						<input id="vendorNm" name="vendorNm" type="text" value="<%=detailDto.getVendorNm() %>" size="40" maxlength="50" />
						<input id="vendorCd" name="vendorCd" type="hidden" value="<%=detailDto.getVendorCd() %>" size="40" maxlength="50" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
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
									<button class="btn btn-primary btn-xs" onClick="window.open('https://www.hometax.go.kr/websquare/websquare.wq?w2xPath=/ui/pp/index_pp.xml&tmIdx=01&tm2lIdx=0108000000&tm3lIdx=0108010000')">
										국세청조회
									</button>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">
						<input id="businessNum1" name="businessNum1" type="text" value="<%=detailDto.getBusinessNum().substring(0, 3) %>" size="3" maxlength="3" onkeydown="return onlyNumber(event)"/> - 
						<input id="businessNum2" name="businessNum2" type="text" value="<%=detailDto.getBusinessNum().substring(3, 5) %>" size="2" maxlength="2" onkeydown="return onlyNumber(event)"/> - 
						<input id="businessNum3" name="businessNum3" type="text" value="<%=detailDto.getBusinessNum().substring(5) %>" size="5" maxlength="5" onkeydown="return onlyNumber(event)"/>
					</td>
					<td class="table_td_subject" width="100">법인등록번호</td>
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
						<input id="registNum2" name="registNum2" type="text" value="<%=registNum2 %>" size="7" maxlength="7" onkeydown="return onlyNumber(event)"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">업종</td>
					<td class="table_td_contents">
						<input id="vendorBusiType" name="vendorBusiType" type="text" value="<%=detailDto.getVendorBusiType() %>" size="20" maxlength="30" style="width: 98%" />
					</td>
					<td class="table_td_subject9" width="100">업태</td>
					<td class="table_td_contents">
						<input id="vendorBusiClas" name="vendorBusiClas" type="text" value="<%=detailDto.getVendorBusiClas() %>" size="20" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">대표자명</td>
					<td class="table_td_contents">
						<input id="pressentNm" name="pressentNm" type="text" value="<%=detailDto.getPressentNm() %>" size="20" maxlength="30" style="width: 98%" />
					</td>
					<td class="table_td_subject9" width="100">대표전화번호</td>
					<td class="table_td_contents">
						<input id="phoneNum" name="phoneNum" type="text" value="<%=detailDto.getPhoneNum() %>" size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">회사이메일</td>
					<td class="table_td_contents">
						<input id="eMail" name="eMail" type="text" value="<%=detailDto.getE_mail() %>" size="20" maxlength="30" /></td>
					<td class="table_td_subject" width="100">주요상품</td>
					<td class="table_td_contents">
						<input id="homePage" name="homePage" type="text" value="<%=detailDto.getHomePage() %>" size="20" maxlength="30" style="width: 98%" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">
						<table>
							<tr>
								<td>회사샵메일</td>
							</tr>
							<tr>
								<td>
									<button class="btn btn-primary btn-xs" onclick="window.open('https://www.docusharp.com/member/join.jsp')">
										회원가입하기
									</button>
								</td>
							</tr>
						</table>
					</td>
					<td colspan="3" class="table_td_contents">
						<input id="sharpMail" name="sharpMail" type="text" value="<%=sharpMail %>" size="20" maxlength="30" style="ime-mode: disabled;"/></td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">주소</td>
					<td colspan="3" class="table_td_contents">
						<input id="postAddrNum" name="postAddrNum" type="text" value="<%=detailDto.getPostAddrNum() %>" size="10" maxlength="10" readonly="readonly"/>
						<a href="#">
							<img id="btnPost" name="btnPost" src="/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search' style="border: 0px;vertical-align: middle;"/> 
						</a> 
						<input id="addres" name="addres" type="text" value="<%=detailDto.getAddres() %>" size="20" maxlength="30" style="width: 50%" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">상세주소</td>
					<td class="table_td_contents">
						<input id="addresDesc" name="addresDesc" type="text" value="<%=detailDto.getAddresDesc() %>" size="20" maxlength="30" style="width: 98%" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">팩스번호</td>
					<td class="table_td_contents">
						<input id="faxNum" name="faxNum" type="text" value="<%=detailDto.getFaxNum() %>" size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
					</td>
					<td class="table_td_subject9">구분</td>
					<td class="table_td_contents">
						<select id="classify" name="classify" class="select">
							<option value="">선택</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">
						<table>
							<tr>
								<td>사업자등록첨부</td>
							</tr>
							<tr>
								<td>
	<%if(userRoleCd.equals("MRO_ADMIN002") || userRoleCd.equals("ADM_B2B_MAN")){%>
									<a href="#">
										<img id="btnBizRegAttach" name="btnBizRegAttach" src="/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
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
					<td class="table_td_subject" width="100">
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
	<%}%>
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
					<td class="table_td_subject" width="100">
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
	<%} %>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list1" name="file_list1" value="<%=detailDto.getEtcFirstAttachSeq() %>"/>
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=detailDto.getEtcFirstAttachPath() %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
						<span id="attach_file_name1"><%=detailDto.getEtcFirstAttachNm() == null || detailDto.getEtcFirstAttachNm().equals("") ? "" : detailDto.getEtcFirstAttachNm() %></span>
						</a>							
					</td>
					<td class="table_td_subject" width="100">
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
						<input type="hidden" id="file_list3" name="file_list3" value="<%=detailDto.getEtcThirdAttachSeq() %>"/>
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=detailDto.getEtcThirdAttachPath() %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
						<span id="attach_file_name3"><%=detailDto.getEtcThirdAttachNm() == null || detailDto.getEtcThirdAttachNm().equals("") ? "" : detailDto.getEtcThirdAttachNm()%></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">
						<table>
							<tr>
								<td>기타첨부1</td>
							</tr>
							<tr>
								<td>
	<%if(userRoleCd.equals("MRO_ADMIN002") || userRoleCd.equals("ADM_B2B_MAN")){%>
									<a href="#">
										<img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
									</a>
	<%} %>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list2" name="file_list2" value="<%=detailDto.getEtcSecondAttachSeq() %>"/>
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=detailDto.getEtcSecondAttachPath() %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
						<span id="attach_file_name2"><%=detailDto.getEtcSecondAttachNm() == null || detailDto.getEtcSecondAttachNm().equals("") ? "" : detailDto.getEtcSecondAttachNm() %></span>
						</a>	
					</td>
					<td class="table_td_subject" width="100">
						<table>
							<tr>
								<td>기타첨부2</td>
							</tr>
							<tr>
								<td>
	<%if(userRoleCd.equals("MRO_ADMIN002") || userRoleCd.equals("ADM_B2B_MAN")){%>
									<a href="#">
										<img id="btnAttach4" name="btnAttach4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
									</a>
	<%} %>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list4" name="file_list4" value="<%=detailDto.getEtcFourthAttachSeq() %>"/>
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=detailDto.getEtcFourthAttachPath() %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path4').val());">
						<span id="attach_file_name4"><%=detailDto.getEtcFourthAttachNm() == null || detailDto.getEtcFourthAttachNm().equals("") ? "" : detailDto.getEtcFourthAttachNm()%></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
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
					<option value="<%=areaCd.getCodeVal1()%>" <%=areaCd.getCodeVal1().equals(detailDto.getAreaType()) ? "selected" : "" %> ><%=areaCd.getCodeNm1() %></option>
<%	
}						
%>											
						</select>
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
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
				<tr>
					<td width="20" valign="top">
						<img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
					</td>
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
						<input id="payBillDay" name="payBillDay" type="hidden" value="<%=detailDto.getPayBillDay() %>" size="20" maxlength="2" style="width: 20px" /> 
<!-- 								일 -->
					</td>
					<td class="table_td_subject9" width="100">회계담당자명</td>
					<td class="table_td_contents">
						<input id="accountManagerNm" name="accountManagerNm" type="text" value="<%=detailDto.getAccountManageNm() %>" size="20" maxlength="30" style="width: 98%" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="110">회계담당자 연락처</td>
					<td class="table_td_contents">
						<input id="accountTelNum" name="accountTelNum" type="text" value="<%=detailDto.getAccountTelNum() %>" size="15" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
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
						<input id="recipient" name="recipient" type="text" value="<%=detailDto.getRecipient() %>" size="20" maxlength="30" style="width: 98%" />
					</td>
					<td class="table_td_subject9" width="100">계좌번호</td>
					<td class="table_td_contents">
						<input id="accountNum" name="accountNum" type="text" value="<%=detailDto.getAccountNum() %>" size="15" maxlength="20" onkeydown="return onlyNumber(event)"/> (-없이)
					</td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
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
					<td width="20" valign="top">
						<img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
					</td>
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
					<td class="table_td_subject9" width="110">로그인ID</td>
					<td colspan="3" class="table_td_contents">
						<input id="userId" name="userId" type="hidden" value="<%=userDto.getUserId() %>" size="40" maxlength="50" readonly="readonly"/>
						<input id="loginId" name="loginId" type="text" value="<%=userDto.getLoginId() %>" size="40" maxlength="50" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="110">성명</td>
					<td class="table_td_contents" width="270">
						<input id="userNm" name="userNm" type="text" value="<%=userDto.getUserNm() %>" size="20" maxlength="30" readonly="readonly"/>
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
					<td class="table_td_subject9" width="110">이동전화번호</td>
					<td class="table_td_contents">
						<input id="mobile" name="mobile" type="text" value="<%=userDto.getMobile() %>" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
					</td>
					<td class="table_td_subject9" width="100">이메일</td>
					<td class="table_td_contents">
						<input id="userEmail" name="userEmail" type="text" value="<%=userDto.geteMail() %>" size="20" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="#CFCFCF"></td>
				</tr>
				<tr>
					<td class="table_td_subject9">권한정보</td>
					<td colspan="3" class="table_td_contents4">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="50" valign="top" align="right">
									<a href="#">
										<img id="roleAddButton" name="roleAddButton" src="/img/system/btn_icon_plus.gif" width="20" height="18" style="border: 0px;vertical-align: middle;"/> 
									</a>
									<a href="#">
										<img id="roleDelButton" name="roleDelButton" src="/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px;vertical-align: middle;"/>
									</a>
								</td>
							</tr>
							<tr>
								<td height="50" valign="top">
									<div id="jqgrid">
										<table id="list"></table>
									</div>
								</td>
							</tr>
						</table>
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
						<input id="refereceDesc" name="refereceDesc" type="text" value="<%=detailDto.getRefereceDesc() %>" size="20" maxlength="300" style="width: 98%" />
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
<%	if (!"40".equals(detailDto.getRegisterCd())) {
		if ("10".equals(detailDto.getRegisterCd())) {
%>
					<button id='btnApp' class="btn btn-danger btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_CONFIRM")%>">
						<i class="fa fa-floppy-o"></i> 저장 후 승인요청
					</button>
					<button id='btnReqDefer' class="btn btn-warning btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_CONFIRM")%>">
						<i class="fa fa-ban"></i> 처리보류
					</button>
					<button id='btnReqSave' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_CONFIRM")%>">
						<i class="fa fa-floppy-o"></i> 저장
					</button>
					<button id='btnCancelApp' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_CONFIRM")%>">
						<i class="fa fa-remove"></i> 등록삭제
					</button>
<%		} else if ("20".equals(detailDto.getRegisterCd())) {%>
					<button id='btnReqApp' class="btn btn-danger btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP_REQ")%>">
						<i class="fa fa-floppy-o"></i> 승인
					</button>
					<button id='btnCancel' class="btn btn-danger btn-sm"
						style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP_REQ")%>">
						<i class="fa fa-remove"></i> 거부
					</button> 
<%		} else if ("30".equals(detailDto.getRegisterCd())) {%>
					<button id='btnConfirm' class="btn btn-danger btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>">
						<i class="fa fa-floppy-o"></i> 승인
					</button> 
<%		}else if ("09".equals(detailDto.getRegisterCd())) {%>
					<button id='btnApp' class="btn btn-danger btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_CONFIRM")%>">
						<i class="fa fa-floppy-o"></i> 저장 후 승인요청
					</button>
					<button id='btnCancelApp' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_CONFIRM")%>">
						<i class="fa fa-remove"></i> 등록삭제
					</button> 
<%		}
	}%>
			<button class="btn btn-default btn-sm" onclick="javaScript:window.close();"><i class="fa fa-remove"></i> 닫기</button>
		</td>
	</tr>
</table>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</form>
</body>
</html>