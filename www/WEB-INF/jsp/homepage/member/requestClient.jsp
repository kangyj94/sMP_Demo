<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-215 + Number(gridHeightResizePlus)";

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
	
	String userDn 		= request.getParameter("setUserDn");
	String businessNum 	= request.getParameter("setBusinessNum");
	
	String basicContractVersion = request.getParameter("basicContractVersion");
	String basicContractClassify = request.getParameter("basicContractClassify");
	
	String individualContractVersion = request.getParameter("individualContractVersion");
	String individualContractClassify = request.getParameter("individualContractClassify");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<title>OK Plaza에 오신것을 환영합니다.</title>
<link href="<%=Constances.SYSTEM_JSCSS_URL%>/css/homepage_style.css" rel="stylesheet" type="text/css" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/ui-lightness/jquery-ui-1.8.16.custom.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/ui-lightness/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />

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
	$("#bullet01").attr("src","/img/homepage/bullet_stitle_red.gif");
	$("#popup_titlebar_bullet1").attr("src","/img/homepage/red_titlebar_bullet.gif");
	$("#popup_titlebar_mid1").css("background-image",'url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_mid.gif)');
	$("#popup_titlebar_left1").attr("src","/img/homepage/red_titlebar_left.gif");
	$("#popup_titlebar_right1").attr("src","/img/homepage/red_titlebar_right.gif");
	$("#attachImportButton").attr("src","/img/homepage/popup_btn_fileReg.gif");
	$("#attachCloseButton").attr("src","/img/homepage/popup_btn_cancel.gif");
	
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
	
	$("#popup_titlebar_bullet2").attr("src","/img/homepage/red_titlebar_bullet.gif");
	$("#popup_titlebar_mid2").css("background-image",'url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_mid.gif)');
	$("#popup_titlebar_left2").attr("src","/img/homepage/red_titlebar_left.gif");
	$("#popup_titlebar_right2").attr("src","/img/homepage/red_titlebar_right.gif");
	$("#srcPostButtonDiv2").attr("src","/img/homepage/popup_btn_search.gif");
 	$("#btnDeliveryRegDiv").attr("src","/img/homepage/popup_btn_reg.gif");
 	$("#btnDeliveryCloseDiv").attr("src","/img/homepage/popup_btn_cancel.gif");
	
	$("#regButton").click(function(){
		$("#popup_titlebar_bullet").attr("src","/img/homepage/red_titlebar_bullet.gif");
		$("#popup_titlebar_mid").css("background-image",'url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_mid.gif)');
		$("#popup_titlebar_left").attr("src","/img/homepage/red_titlebar_left.gif");
		$("#popup_titlebar_right").attr("src","/img/homepage/red_titlebar_right.gif");
		$("#srcPostButtonDiv").attr("src","/img/homepage/popup_btn_search.gif");
		$("#postSelectButton").attr("src","/img/homepage/popup_btn_select.gif");
		$("#postCloseButton").attr("src","/img/homepage/popup_btn_cancel.gif");
		
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
var jq = jQuery;
$(document).ready(function(){
	$.post(	
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"MEMBERGRADE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#branchGrad").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			$.post(	
				'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
				{codeTypeCd:"DELI_AREA_CODE", isUse:"1"},
				function(arg){
					var codeList = eval('(' + arg + ')').codeList;
					for(var i=0;i<codeList.length;i++) {
						if(codeList[i].codeVal1 != "99"){
							$("#areaType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
						}
					}
				}
			);
			$.post(	
				'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
				{codeTypeCd:"BANKCD", isUse:"1"},
				function(arg){
					var codeList = eval('(' + arg + ')').codeList;
					for(var i=0;i<codeList.length;i++) {
						$("#bankCd").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
					}
					initList();	//그리드 초기화
				}
			);
		}
	);
	
	$("#closeButton").click( function() { fnClose(); });
	$("#btnSave").click( function() { fnSave(); });
// 	$("#regButton").click( function() { addRow(); });
	$("#delButton").click( function() { delRow(); });
	$("#clientCdConfirm").click( function() { fnClientCdConfirm(); });
	$("#loginIdConfirm").click( function() { fnLoginIdConfirm(); });
    
	$("#postAddrNum").attr("disabled","true");
	$("#addres").attr("disabled","true");
	
<%
	if(Constances.COMMON_ISREAL_SERVER){
%>
	$("#businessNum1").attr("disabled","true");
	$("#businessNum2").attr("disabled","true");
	$("#businessNum3").attr("disabled","true");
<%		
	}else{
%>
	$("#businessNum1").removeClass("input_text_none");
	$("#businessNum2").removeClass("input_text_none");
	$("#businessNum3").removeClass("input_text_none");
<%		
	}
%>	
	
 });
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
function initList() {
	jq("#list").jqGrid({
		url:'/system/getBlank.sys',
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
}
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
		 var bankCd = $.trim($("#bankCd").val());
		 var recipient = $.trim($("#recipient").val());
		 var accountNum = $.trim($("#accountNum").val());
		 var loginId    = $.trim($("#loginId").val());   
		 var pwd        = $.trim($("#pwd").val());       
		 var pwdConfirm = $.trim($("#pwdConfirm").val());
		 var userNm     = $.trim($("#userNm").val());    
		 var tel        = $.trim($("#tel").val());       
		 var mobile     = $.trim($("#mobile").val());    
		 var userEmail  = $.trim($("#userEmail").val()); 
		 var sharpMail  = $.trim($("#sharpMail").val()); 
		 
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
		//var isValidation = true;
		if(isValidation){
			if(!confirm("법인을 가입신청 진행하시겠습니까?")) return;
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
			
			var contractVersionArray = new Array();
			var contractClassifyArray = new Array();
			
			var basicContractVersion = "<%=basicContractVersion%>";
			var basicContractClassify = "<%=basicContractClassify%>";
			
			var individualContractVersion = "<%=individualContractVersion%>";
			var individualContractClassify = "<%=individualContractClassify%>";
			contractVersionArray = [basicContractVersion, individualContractVersion];
			contractClassifyArray = [basicContractClassify, individualContractClassify];
			
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
					shippingPhoneNumArr:shippingPhoneNumArr,
					userDn:'<%=userDn%>',
					sharpMail:$("#sharpMail").val(),
					contractVersionArray:contractVersionArray,
					contractClassifyArray:contractClassifyArray
				},			
				
				function(arg){ 
					var result = eval('(' + arg + ')').customResponse;
					//if (result.success == true) {
						alert("가입신청이 정상적으로 완료되었습니다.\nOKplaza 담당자 최종 승인 후 본 서비스를 \n이용 하실 수 있습니다.")
						$(location).attr('href', '<%=Constances.SYSTEM_CONTEXT_PATH%>/index.jsp');
					//}
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
					<td width="800" valign="top">
					<!-- 메인 컨텐츠 내용 시작-->
						<table width="800px" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_06.gif" width="800" height="63"/></td>
							</tr>
							<tr>
								<td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/membership_st_02_02.jpg" width="300" height="38"/></td>
								<td width="500" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt;<span class="orange"> 고객사 등록요청</span></td>
							</tr>
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="800" height="19"/></td>
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
															<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/bullet_stitle_red.gif" width="5" height="5" class="bullet_stitle" />
														</td>
														<td class="stitle">회원사 일반정보</td>
													</tr>
												</table>
												<!-- 타이틀 끝 -->
											</td>
										</tr>
									</table>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td>
												<!-- 컨텐츠 시작 -->
												<table width="100%"  border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td colspan="4" class="table_top_line_red"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red" width="100">법인<br>(개인사업자)</td>
														<td class="table_td_contents">
															<input id="clientNm" name="clientNm" type="text" value="" size="40" maxlength="50"/>
														</td>
														<td class="table_td_subject9_red" width="100">사업자코드</td>
														<td class="table_td_contents" >
															<input id="clientCd" name="clientCd" type="text" value="" size="4" maxlength="3" onkeydown="return fnDupCheck('client', event)" style="ime-mode: disabled;text-transform:uppercase;" />
															<a href="#">
																<img id="clientCdConfirm" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_check.gif" width="75" height="18" style="border: 0px;vertical-align: middle;"/>
																&nbsp;
																<font color="red">*</font> 상호명 (대문자 3자리)
															</a>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red">사업자등록번호</td>
														<td class="table_td_contents">
															<input id="businessNum1" name="businessNum1" type="text" value="<%= businessNum != null && !"".equals(businessNum.trim())? businessNum.substring(0,3) : "" %>" size="3" maxlength="3" onkeydown="return onlyNumber(event)" class="input_text_none"/>-
															<input id="businessNum2" name="businessNum2" type="text" value="<%= businessNum != null && !"".equals(businessNum.trim())? businessNum.substring(3,5) : ""  %>" size="2" maxlength="2" onkeydown="return onlyNumber(event)" class="input_text_none"/>-
															<input id="businessNum3" name="businessNum3" type="text" value="<%= businessNum != null && !"".equals(businessNum.trim())? businessNum.substring(5) : ""  %>" size="5" maxlength="5" onkeydown="return onlyNumber(event)" class="input_text_none"/>
														</td>
														<td class="table_td_subject_red">법인등록번호</td>
														<td class="table_td_contents">
															<input id="registNum1" name="registNum1" type="text" value="" size="6" maxlength="6" onkeydown="return onlyNumber(event)"/>-
															<input id="registNum2" name="registNum2" type="text" value="" size="7" maxlength="7" onkeydown="return onlyNumber(event)"/>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red">업종</td>
														<td class="table_td_contents">
															<input id="branchBustType" name="branchBustType" type="text" value="" size="30" maxlength="30"/>
														</td>
														<td class="table_td_subject9_red">업태</td>
														<td class="table_td_contents" >
															<input id="branchBustClas" name="branchBustClas" type="text" value="" size="30" maxlength="30"/>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red" >대표자</td>
														<td class="table_td_contents" >
															<input id="pressentNm" name="pressentNm" type="text" value="" size="15" maxlength="30" />
														</td>
														<td class="table_td_subject9_red" >대표전화</td>
														<td class="table_td_contents">
															<input id="phoneNum" name="phoneNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red" >대표 이메일</td>
														<td class="table_td_contents" >
															<input id="eMail" name="eMail" type=text value="" size="20" maxlength="30" style="ime-mode: disabled;"/> ex)admin@unpams.com
														</td>
														<td class="table_td_subject_red" >홈페이지</td>
														<td class="table_td_contents">
															<input id="homePage" name="homePage" type="text" value="" size="20" maxlength="30" style="width:98%; ime-mode: disabled;"/>
														</td>
													</tr>
													<tr>
														<td class="table_td_subject9_red" width="100">
															<table>
																<tr>
																	<td>대표 샵(#)메일</td>
																</tr>
																<tr>
																	<td>
																		<input type="button" value="회원가입하기" style=cursor:pointer; onclick="window.open('https://www.docusharp.com/member/join.jsp')"></input>
																	</td>
																</tr>
															</table>
														</td>
														<td colspan="3" class="table_td_contents">
                                                        	#메일 회원 가입시 <font color="red">&quot;수신전용&quot;으로 가입</font>해 주셔야만 <font color="red">무상 이용</font>이 가능합니다.
                                                            <input type="button" onclick="window.open('/upload/sample/sharp_mail_guide.pdf')" value="가입절차 안내서"/><br/>
															<input id="sharpMail" name="sharpMail" type="text" value="" size="20" maxlength="30" /> ex)법인사업자 : 대표#unpamsbank.법인, 개인사업자 : 대표#unpamsbank.사업
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red" >주소</td>
														<td colspan="3" class="table_td_contents">
															<input id="postAddrNum" name="postAddrNum" type="text" value="" size="7" maxlength="7" onkeydown="return onlyNumber(event)" class="input_text_none"/>
															<a href="#">
																<img id="btnPost" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search' style="border: 0px;vertical-align: middle;"/>
															</a>
															<input id="addres" name="addres" type="text" value="" size="40" maxlength="50" class="input_text_none"/>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject_red" >상세주소</td>
														<td colspan="3" class="table_td_contents">
															<input id="addresDesc" name="addresDesc" type="text" value="" size="50" maxlength="30"/>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject_red" >팩스번호</td>
														<td class="table_td_contents">
															<input id="faxNum" name="faxNum" type="text" value="" size="13" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
														</td>
														<td></td>
														<td></td>
<!-- 														<td class="table_td_subject_red">참고사항</td> -->
<!-- 														<td class="table_td_contents"> -->
<!-- 															<input id="refereceDesc" name="refereceDesc" type="text" value="" size="30" maxlength="30"/> -->
<!-- 														</td> -->
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red" >사업자등록첨부<br/>
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
														<td class="table_td_subject_red" >신용평가서첨부<br/>
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
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject_red" >통장사본첨부<br/>
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
														<td class="table_td_subject_red">공사계약서<br/>(Home 고객센터 계약서 포함)<br/>
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
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject_red">회사소개서<br/>
															<a href="#">
																<img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
															</a>							
														</td>
														<td class="table_td_contents" colspan="3">
															<table>
																<tr>
																	<td width="200">
																		<input type="hidden" id="file_list3" name="file_list3" value="<%=file_list3 %>"/>
																		<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
																		<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
																			<span id="attach_file_name3"><%=attach_file_name3 %></span>
																		</a>
																	</td>
																	<td>
																		<font color="red">*</font>&nbsp;연혁, 매출액, 주요 공사실적, 공사면허 보유 등
																	</td>
																</tr>
															</table>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red">권역</td>
														<td class="table_td_contents">
															<select class="select" id="areaType" name="areaType">
																<option value="">선택하세요</option>
															</select>
														</td>
														<td class="table_td_subject9_red" >공사등급</td>
														<td class="table_td_contents">
															<select class="select" id="branchGrad" name="branchGrad">
																<option value="">선택하세요</option>
															</select>
														</td>
													</tr>
													<tr>
														<td colspan="4" class="table_top_line_red"></td>
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
															<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/bullet_stitle_red.gif" width="5" height="5" class="bullet_stitle" />
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
														<td colspan="4" class="table_top_line_red"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red" width="110">결제조건</td>
														<td class="table_td_contents">
															<select class="select" id="payBillType" name="payBillType" disabled="disabled">
																<option value="1030">현금</option>
															</select>
															<input id="payBillDay" name="payBillDay" type="text" value="30" size="20" maxlength="30" style="width:20px" disabled="disabled" />일
														</td>
														<td class="table_td_subject9_red" width="100">회계담당자명</td>
														<td class="table_td_contents">
															<input id="accountManagerNm" name="accountManagerNm" type="text" value="" size="20" maxlength="30"/>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red">회계담당자 연락처</td>
														<td class="table_td_contents">
															<input id="accountTelNum" name="accountTelNum" type="text" value="" size="25" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
														</td>
														<td class="table_td_subject9_red">은행코드</td>
														<td class="table_td_contents">
															<select class="select" id="bankCd" name="bankCd">
																<option value="">선택하세요</option>
															</select>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red">예금주명</td>
														<td class="table_td_contents">
															<input id="recipient" name="recipient" type="text" value="" size="20" maxlength="30"/>
														</td>
														<td class="table_td_subject9_red">계좌번호</td>
														<td class="table_td_contents">
															<input id="accountNum" name="accountNum" type="text" value="" size="25" maxlength="20" onkeydown="return onlyNumber(event)"/> (-없이)
														</td>
													</tr>
													<tr>
														<td colspan="4" class="table_top_line_red"></td>
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
														<td width="20" valign="top" ><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/bullet_stitle_red.gif" width="5" height="5" class="bullet_stitle" /></td>
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
														<td colspan="4" class="table_top_line_red"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red" width="100">로그인ID</td>
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
														<td class="table_td_subject9_red" width="100">비밀번호</td>
														<td class="table_td_contents">
															<input id="pwd" name="pwd" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;"/>
														</td>
														<td class="table_td_subject9_red" width="100">비밀번호 확인</td>
														<td class="table_td_contents">
															<input id="pwdConfirm" name="pwdConfirm" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;"/>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red" width="100">성명</td>
														<td class="table_td_contents">
															<input id="userNm" name="userNm" type="text" value="" size="20" maxlength="30"/>
														</td>
														<td class="table_td_subject9_red" width="100">전화번호</td>
														<td class="table_td_contents">
															<input id="tel" name="tel" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumber(event)"/>
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td class="table_td_subject9_red" width="100">이동전화번호</td>
														<td class="table_td_contents">
															<input id="mobile" name="mobile" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumber(event)"/>
														</td>
														<td class="table_td_subject9_red" width="100">이메일</td>
														<td class="table_td_contents">
															<input id="userEmail" name="userEmail" type="text" value="" size="25" maxlength="30"  style="ime-mode: disabled;"/> ex)admin@unpamsbank.com
														</td>
													</tr>
													<tr>
														<td colspan="4" height='1' bgcolor="eaeaea"></td>
													</tr>
													<tr>
														<td colspan="4" class="table_top_line_red"></td>
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
												<img id="btnSave" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_request.gif" height="23" style="border: 0px;vertical-align: middle;"/>
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