<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@page import="java.util.List"%>

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
<title>OK Plaza에 오신것을 환영합니다.</title>
<%-- <link href="<%=Constances.SYSTEM_JSCSS_URL%>/css/homepage_style.css" rel="stylesheet" type="text/css" /> --%>
<script type="text/javascript">
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
</script>
<script type="text/javascript">
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
</script>

<%
/**------------------------------------사용방법---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
*/
%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnBizRegAttach").click(function(){ fnUploadDialog("사업자등록첨부", $("#file_biz_reg_list").val(), "fnCallBackAttachBizReq"); });
	$("#btnAppSalAttach").click(function(){ fnUploadDialog("신용평가서첨부", $("#file_app_sal_list").val(), "fnCallBackAttachAppSal"); });
	$("#btnAttach1").click(function(){ fnUploadDialog("기타첨부1", $("#file_list1").val(), "fnCallBackAttach1"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("기타첨부2", $("#file_list2").val(), "fnCallBackAttach2"); });
	$("#btnAttach3").click(function(){ fnUploadDialog("기타첨부3", $("#file_list3").val(), "fnCallBackAttach3"); });
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
<% //------------------------------------------------------------------------------ %>

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
});
/**
 * 우편번호팝업검색후 선택한 값 세팅
 */
function fnCallBackDeliveryAddressSet(shippingPlace, shippingPhoneNum, shippingPost, shippingAddress, shippingAddressDesc) {
	addRow(shippingPlace, shippingPhoneNum, shippingPost+" "+shippingAddress+" "+shippingAddressDesc);
}
</script>
<% //------------------------------------------------------------------------------ %>

<!--버튼 이벤트 스크립트-->
<script type="text/javascript">
$(document).ready(function(){
	$("#closeButton").click( function() { fnClose(); });
	$("#btnSave").click( function() { fnSave(); });
// 	$("#regButton").click( function() { addRow(); });
	$("#delButton").click( function() { delRow(); });
	$("#clientCdConfirm").click( function() { fnClientCdConfirm(); });
	$("#loginIdConfirm").click( function() { fnLoginIdConfirm(); });
    
	$("#postAddrNum").attr("disabled","true");
	$("#addres").attr("disabled","true");
 });
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
jq(function() {
	jq("#list").jqGrid({
		url:'',
		datatype: 'json',
		mtype: 'POST',
		colNames:['배송지명','배송지 전화번호','배송지 주소'],
		colModel:[
			{name:'shipping_place',index:'shipping_place', width:200,align:"left",search:false,sortable:false,
				editable:false, key:true, editrules:{required:true}
			},	//배송지명 
			{name:'shipping_phonenum',index:'shipping_phonenum', width:100,align:"center",search:false,sortable:false,
				editable:false
			},	//배송지 전화번호
			{name:'shipping_addres',index:'shipping_addres', width:600,align:"left",search:false,sortable:false,
				editable:false
			}	//배송지 주소
		],
		rowNum:5, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: 80,autowidth: true,
		sortname: '', sortorder: '',
		caption:"배송처 정보",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},	
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트-->
<script type="text/javascript">
	function fnClose(){
	// 	window.dialogArguments.fnReloadGrid();
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
		 //var bankCd = $.trim($("#bankCd").val());
		 //var recipient = $.trim($("#recipient").val());
		 //var accountNum = $.trim($("#accountNum").val());
		 
		 var loginId    = $.trim($("#loginId").val());   
		 var pwd        = $.trim($("#pwd").val());       
		 var pwdConfirm = $.trim($("#pwdConfirm").val());
		 var userNm     = $.trim($("#userNm").val());    
		 var tel        = $.trim($("#tel").val());       
		 var mobile     = $.trim($("#mobile").val());    
		 var userEmail  = $.trim($("#userEmail").val()); 
		 
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
		 
// 		 if(registNum1 == "" || registNum2 == ""){
// 	 		 $("#dialog").html("<font size='2'>법인 등록번호를 입력해주세요.</font>");
// 			 $("#dialog").dialog({
// 				 title: 'Success',modal: true,
// 				 buttons: {"Ok": function(){$(this).dialog("close");} }
// 			 });			 
// 			 return false;
// 		 }	 
		 
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
		 
		 if(payBillType == "" || payBillDay == ""){
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
		 /*
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
		 */
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
		//var isValidation = true;
		if(!confirm("법인을 가입신청 진행하시겠습니까?")) return;
		if(isValidation){
			var shippingPlaceArr 	= Array();
			var shippingAddresArr 	= Array();
			var shippingPhoneNumArr = Array();
			var rowCnt	 			= jq("#list").getGridParam('reccount');
			
			for(var i = 0 ; i < rowCnt ; i++){
				var rowid = $("#list").getDataIDs()[i];	
				var selrowContent 	= jq("#list").jqGrid('getRowData',rowid);
				
				shippingPlaceArr[i]    =  selrowContent.shipping_place;
				shippingAddresArr[i]   =  selrowContent.shipping_addres;
				shippingPhoneNumArr[i] =  selrowContent.shipping_phonenum;
			}
			
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveBranchPop.sys", 
				{
					clientNm:$("#clientNm").val(),
					clientCd:$("#clientCd").val(),
					branchid:$("#branchid").val(),
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
					file_biz_reg_list:$("#file_biz_reg_list").val(),
					file_app_sal_list:$("#file_app_sal_list").val(),
					file_list1:$("#file_list1").val(),
					file_list2:$("#file_list2").val(),
					file_list3:$("#file_list3").val(),
					areaType:$("#areaType").val(),
					branchGrad:$("#branchGrad").val(),
					payBillType:$("#payBillType").val(),
					payBillDay:$("#payBillDay").val(),
					accountManagerNm:$("#accountManagerNm").val(),
					accountTelNum:$("#accountTelNum").val(),
					bankCd:$("#bankCd").val(),
					recipient:$("#recipient").val(),
					accountNum:$("#accountNum").val(),
					loginId:$("#loginId").val(),
					pwd:$("#pwd").val(),
					userNm:$("#userNm").val(),
					tel:$("#tel").val(),
					mobile:$("#mobile").val(),
					userEmail:$("#userEmail").val(),
					shippingPlaceArr:shippingPlaceArr,
					shippingAddresArr:shippingAddresArr,
					shippingPhoneNumArr:shippingPhoneNumArr
				},			
				
				function(arg){ 
					if(fnAjaxTransResult(arg)) {	//성공시
						//var opener = window.dialogArguments;
						//opener.fnSearch();
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
</script>
</head>
<script type="text/javascript" src="utils.js"></script>
<body>
<table width="977px" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" height="101px">
		<!-- 상단메뉴 레이아웃 시작 --><%@include file="/WEB-INF/jsp/homepage/inc/top.jsp"%><!-- 상단메뉴 레이아웃 끝 --></td>
	</tr>
	<tr>
		<td align="center">&nbsp;</td>
	</tr>
	<tr>
		<td align="center"><!-- 메인 컨텐츠 시작-->
			<table width="977" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="186" valign="top" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_left_menu_bg.gif)">
						<!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_06.jsp"%><!-- 좌측메뉴 끝-->
					</td>
					<td width="34" valign="top">&nbsp;</td>
					<td width="757" valign="top">
					<!-- 메인 컨텐츠 내용 시작-->
						<table width="757px" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_06.gif" width="757" height="63"/></td>
							</tr>
							<tr>
								<td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/membership_st_02.gif" width="300" height="38"/></td>
								<td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt;<span class="orange"> 회원정보수정</span></td>
							</tr>
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
							</tr>
				
							<tr>
								<td colspan="2"  align="left">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
									
										<tr>
											<td>
												<!-- 타이틀 시작 -->
												<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
													<tr>
														<td width="20" valign="top" >
															<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
														</td>
														<td class="stitle">회원사 일반정보</td>
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
														<td class="table_td_subject9" width="100">법인명</td>
														<td colspan="3" class="table_td_contents">
															<input id="clientNm" name="clientNm" type="text" value="" size="40" maxlength="50"/>
														</td>
														<td class="table_td_subject9" width="100">법인코드</td>
														<td class="table_td_contents">
															<input id="clientCd" name="clientCd" type="text" value="" size="20" maxlength="3" onkeydown="return fnDupCheck('client', event)" style="ime-mode: disabled;text-transform:uppercase;" />
															<a href="#">
																<img id="clientCdConfirm" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_check.gif" width="75" height="18" style="border: 0px;vertical-align: middle;"/>
															</a>
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
															<input id="branchBustType" name="branchBustType" type="text" value="" size="20" maxlength="30" style="width:98%"/>
														</td>
													</tr>
													<tr>
														<td colspan="6" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9" width="100">업태</td>
														<td class="table_td_contents">
															<input id="branchBustClas" name="branchBustClas" type="text" value="" size="20" maxlength="30"/>
														</td>
														<td class="table_td_subject9" width="100">대표자명</td>
														<td class="table_td_contents">
															<input id="pressentNm" name="pressentNm" type="text" value="" size="20" maxlength="30" style="width:98%"/>
														</td>
														<td class="table_td_subject9" width="100">대표전화번호</td>
														<td class="table_td_contents">
															<input id="phoneNum" name="phoneNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
														</td>
													</tr>
													<tr>
														<td colspan="6" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9" width="100">회사이메일</td>
														<td colspan="3" class="table_td_contents">
															<input id="eMail" name="eMail" type=text value="" size="20" maxlength="30" style="ime-mode: disabled;"/> ex)admin@unpamsbank.com
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
															<input id="postAddrNum" name="postAddrNum" type="text" value="" size="7" maxlength="7" onkeydown="return onlyNumber(event)" class="input_text_none"/>
															<a href="#">
																<img id="btnPost" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search' style="border: 0px;vertical-align: middle;"/>
															</a>
															<input id="addres" name="addres" type="text" value="" size="56" maxlength="50" class="input_text_none"/>
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
														<td class="table_td_contents"><input id="faxNum" name="faxNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/></td>
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
															<a href="javascript:fnAttachFileDownload($('#attach_file_biz_reg_path').val());">
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
															<a href="javascript:fnAttachFileDownload($('#attach_file_app_sal_path').val());">
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
														<td class="table_td_subject" width="100">기타첨부1
															<a href="#">
																<img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
															</a>					
														</td>
														<td class="table_td_contents">
															<input type="hidden" id="file_list1" name="file_list1" value="<%=file_list1 %>"/>
															<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
															<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
															<span id="attach_file_name1"><%=attach_file_name1 %></span>
															</a>					
														</td>
														<td class="table_td_subject" width="100">기타첨부2
															<a href="#">
															<img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
															</a>					
														</td>
														<td class="table_td_contents">
															<input type="hidden" id="file_list2" name="file_list2" value="<%=file_list2 %>"/>
															<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2 %>"/>
															<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
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
														<td class="table_td_subject" width="100">기타첨부3
															<a href="#">
																<img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
															</a>							
														</td>
														<td colspan="5" class="table_td_contents">
															<input type="hidden" id="file_list3" name="file_list3" value="<%=file_list3 %>"/>
															<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
															<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
															<span id="attach_file_name3"><%=attach_file_name3 %></span>
															</a>	
														</td>
													</tr>
													<tr>
														<td colspan="6" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9" width="100">권역</td>
														<td class="table_td_contents">
															<select class="select" id="areaType" name="areaType">
																<option>선택하세요</option>
									
									
														
															</select>
														</td>
														<td class="table_td_subject9" width="100">회원사등급</td>
														<td colspan="3" class="table_td_contents">
															<select class="select" id="branchGrad" name="branchGrad">
																<option>선택하세요</option>
									
									
															
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
									
									
									
															
															</select>
															<input id="payBillDay" name="payBillDay" type="text" value="30" size="20" maxlength="30" style="width:20px" disabled="disabled" />일
														</td>
														<td class="table_td_subject9" width="100">회계담당자명</td>
														<td class="table_td_contents">
															<input id="accountManagerNm" name="accountManagerNm" type="text" value="" size="20" maxlength="30" style="width:98%"/>
														</td>
														<td class="table_td_subject9" width="100">회계이동전화</td>
														<td class="table_td_contents">
															<input id="accountTelNum" name="accountTelNum" type="text" value="" size="25" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
														</td>
													</tr>
													<tr>
														<td colspan="6" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject" width="100">은행코드</td>
														<td class="table_td_contents">
															<select class="select" id="bankCd" name="bankCd">
																<option>선택하세요</option>
									
									
															
															</select>
														</td>
														<td class="table_td_subject" width="100">예금주명</td>
														<td class="table_td_contents">
															<input id="recipient" name="recipient" type="text" value="" size="20" maxlength="30" style="width:98%"/>
														</td>
														<td class="table_td_subject" width="100">계좌번호</td>
														<td class="table_td_contents">
															<input id="accountNum" name="accountNum" type="text" value="" size="25" maxlength="20" onkeydown="return onlyNumberForSum(event)"/>
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
														<td class="stitle">배송처 정보</td>
														<td width="50" class="stitle">
															<a href="#">
																<img id="regButton" name="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_plus.gif" width="20" height="18" style="border: 0px;vertical-align: middle;"/> 
															</a>
															<a href="#">
																<img id="delButton" name="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px;vertical-align: middle;"/>
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
															<input id="loginId" name="loginId" type="text" value="" size="40" maxlength="50" onkeydown="return fnDupCheck('login', event)" style="ime-mode: disabled;"/>
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
														<td class="table_td_subject9" width="100">성명</td>
														<td class="table_td_contents">
															<input id="userNm" name="userNm" type="text" value="" size="20" maxlength="30"/>
														</td>
														<td class="table_td_subject9" width="100">전화번호</td>
														<td class="table_td_contents">
															<input id="tel" name="tel" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumber(event)"/>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9" width="100">이동전화번호</td>
														<td class="table_td_contents">
															<input id="mobile" name="mobile" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumber(event)"/>
														</td>
														<td class="table_td_subject9" width="100">이메일</td>
														<td class="table_td_contents">
															<input id="userEmail" name="userEmail" type="text" value="" size="25" maxlength="30"  style="ime-mode: disabled;"/> ex)admin@unpamsbank.com
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
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
												<img id="btnSave" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_request.gif" width="85" height="23" style="border: 0px;vertical-align: middle;"/>
												</a>
<!-- 												<a href="#"> -->
<%-- 												<img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style="border: 0px;vertical-align: middle;"/> --%>
<!-- 												</a> -->
											</td>
										</tr>	
									
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2"></td>
							</tr>
						</table>
						<!-- 메인 컨텐츠 내용 끝-->
					</td>
				</tr>
			</table>
			<!-- 메인 컨텐츠 끝-->
		</td>
	</tr>
	<tr>
		<td align="center">&nbsp;</td>
	</tr>
	<tr>
		<td height="78" align="center"><!-- 푸터 시작--><%@include file="/WEB-INF/jsp/homepage/inc/footer.jsp"%><!-- 푸터 끝--></td>
	</tr>
</table>
</body>
</html>