<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="java.util.List"%>

<%
	String strTitle = "";
	String insert_borgid = "";
	String insert_borgid_nm = "";
	String insert_user_id = "";
	
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");// 사용자 권한
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);// 사용자 정보
	insert_borgid = loginUserDto.getBorgId();
	insert_borgid_nm = loginUserDto.getBorgNms();
	insert_borgid_nm = insert_borgid_nm.replaceAll("&gt;", ">");
	insert_user_id = loginUserDto.getUserId();
	
	//메뉴Id
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
    
	String newgoodid = ( (String)request.getAttribute("newgoodid") == null ) ? "" : (String)request.getAttribute("newgoodid") ;// 고객사상품등록요청 ID
	if("".equals(newgoodid)) {
		strTitle = "고객사상품등록/제안요청";
	} else {
		strTitle = "고객사상품등록/제안요청 정보";
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<head>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	// Object Event
	$('#btnExistsProduct').click(function() { fnExistsProductProcess(); });
	$('#btnCreateBid').click(function() { fnCreateBidProcess(); });
	$('#btnProdSearch').click(function() {	fnOpenProdSearchPopForAdmin(); });
	$('#good_iden_numb').click(function() {	fnProductDetail(); });
	$("#btnAddNewProduct").click(function() {	fnReqProduct("add"); });
	$("#btnModNewProduct").click(function() {	fnReqProduct("mod"); });
	$("#btnDelNewProduct").click(function() {	fnReqProduct("del"); });
	$('#btnCommonClose').click(function() { fnThisPageClose(); });
	$('#btnReset').click(function() { fnReset(); });
	$('#btnProductCancel').click(function() { newProductCancel(); });
	
	// 코드값 조회
	fnInitCodeData();
	
	// Component Data Bind 
	function fnInitCodeData() {
		$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
			{ codeTypeCd:"NEW_PROD_STATE", isUse:"1" },
			function(arg) {
				var codeList = eval('(' + arg + ')').codeList;
				for(var i=0;i<codeList.length;i++) {
					$("#state").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
				}
				
				// 화면 초기화
				fnInitComponent();
			}
		);
	}
	
	// 화면 component 상태 초기화
	function fnInitComponent() {
		if('<%=newgoodid%>' == '') {
			// 등록일 경우
			if('<%=loginUserDto.getSvcTypeCd()%>' == 'BUY') {
				// 고객사 인경우
				$('#insert_borgid').val('<%=insert_borgid%>');
				$('#insert_borgid_nm').val('<%=insert_borgid_nm%>');
				var d = new Date();
				var s = leadingZeros(d.getFullYear(), 4) + '-' + leadingZeros(d.getMonth() + 1, 2) + '-' + leadingZeros(d.getDate(), 2) ;
				$('#insert_date').val(s);
				$("#state option").each(function () {
					if($(this).text()!='요청')	{
						$(this).remove();
					}
				});
				
				$('#btnExistsProduct').hide();
				$('#btnCreateBid').hide();
				$('#btnProdSearch').hide();
				$('#btnProdSearch').hide();
				$('img[name*="btnAttachDel"]').hide();
				$('#btnModNewProduct').hide();
				$('#btnDelNewProduct').hide();
				$('#btnClose').hide();
				$('#stand_good_name').focus();
				
				$('#btnCommonClose').hide();
				
				
			} else {
				// 운영사인경우
			}
		} else {
			// 수정일 경우
			fnGetDetailData();
		}
	}
	
	// Detail Data Init
	function fnGetDetailData() {
		// 상태값 조회
		$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/newProductRequestDetailDataInit.sys',
			{ newgoodid:'<%=newgoodid%>' },
			function(arg) {
				var detailInfo = eval('(' + arg + ')').detailInfo;
				$('#insert_borgid_nm').val(fnReplaceAll(detailInfo.borgNms,"&gt;",">"));
				$('#insert_borgid').val(detailInfo.insert_borgid);
				$('#newgoodid').val(detailInfo.newgoodid);
				$('#stand_good_name').val(detailInfo.stand_good_name);
				$('input:radio[name=request_type]:input[value='+detailInfo.request_type+']').attr("checked", true);
				$('#stand_good_spec_desc').val(detailInfo.stand_good_spec_desc);
				$('#state').val(detailInfo.state);
				$('#note').val(detailInfo.note);
				$('#insert_date').val(detailInfo.insert_date);
				$('#firstattachseq').val(detailInfo.firstattachseq);
				$('#attach_file_path1').val(detailInfo.firstAttachPath);
				$('#attach_file_name1').html(detailInfo.firstAttachName);
				$('#secondattachseq').val(detailInfo.secondattachseq);
				$('#attach_file_path2').val(detailInfo.secondAttachPath);
				$('#attach_file_name2').html(detailInfo.secondAttachName);
				$('#thirdattachseq').val(detailInfo.thirdattachseq);
				$('#attach_file_path3').val(detailInfo.thirdAttachPath);
				$('#attach_file_name3').html(detailInfo.thirdAttachName);
				$('#good_Name').val(detailInfo.good_name);
				$('#good_iden_numb').html(detailInfo.good_iden_numb);
				if($('#good_iden_numb').html() != "") { $('#good_iden_numb').css("display","inline"); }
				
				fnInitComponentForUpd();
			}
		);
	}
	
	// 수정일때 스크립트 실행
	function fnInitComponentForUpd() {
	    
		if('<%=loginUserDto.getSvcTypeCd()%>' == 'BUY') {
			// 고객사 상세
			if($('#state').val() == '10') {
				// 요청
				var d = new Date();
				var s = leadingZeros(d.getFullYear(), 4) + '-' + leadingZeros(d.getMonth() + 1, 2) + '-' + leadingZeros(d.getDate(), 2) ;
				$('#insert_date').val(s);
				if($('#firstattachseq').val() == "") { $('#btnAttachDel1').hide(); }
				if($('#secondattachseq').val() == "") { $('#btnAttachDel2').hide(); }
				if($('#thirdattachseq').val() == "") { $('#btnAttachDel3').hide(); }
				
				if('<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' == 'display:inline ;') {
					$('#btnModNewProduct').show();
					$('#btnDelNewProduct').show();
				}
				
			} else if($('#state').val() == '80' || // 상품등록
						 $('#state').val() == '90') { // 기상품처리
				$('#stand_good_name').attr("disabled",true);
				$('#stand_good_name').attr("class","input_text_none");
				$(':radio[name="request_type"]').attr('disabled', 'disabled');
				$('#stand_good_spec_desc').attr("disabled",true);
				$('#stand_good_spec_desc').attr("class","input_text_none");
				$('#note').attr("disabled",true);
				$('#note').attr("class","input_text_none");
				$('img[name*="btnAttach"]').hide();
				$('#btnModNewProduct').hide();
				$('#btnDelNewProduct').hide();
			}else {
				$('#stand_good_name').attr("disabled",true);
				$('#stand_good_name').attr("class","input_text_none");
				$(':radio[name="request_type"]').attr('disabled', 'disabled');
				$('#stand_good_spec_desc').attr("disabled",true);
				$('#stand_good_spec_desc').attr("class","input_text_none");
				$('#note').attr("disabled",true);
				$('#note').attr("class","input_text_none");
				$('img[name*="btnAttach"]').hide();
				$('#btnModNewProduct').hide();
				$('#btnDelNewProduct').hide();
			}
			
			$('#btnExistsProduct').hide();
			$('#btnCreateBid').hide();
			$('#btnProdSearch').hide();
			$('#btnAddNewProduct').hide();
			$('#btnReset').hide();
		} else {
			// 운영사 상세
			if($('#state').val() == '10') {//요청
				$('#btnExistsProduct').show();
				$('#btnCreateBid').hide();
				$('#btnProdSearch').show();
			} else if($('#state').val() == '80' ||  $('#state').val() == '90') {//상품등록,기상품처리
				$('#btnExistsProduct').hide();
				$('#btnCreateBid').hide();
				$('#btnProdSearch').hide();
				$('#btnProductCancel').hide();
			} else if ($('#state').val() == '40') {//입찰완료_유찰
				$('#btnExistsProduct').show();
				$('#btnCreateBid').hide();
				$('#btnProdSearch').show();
			} else if($('#state').val() == '91'){	//상품반려 일떄
				$('#btnExistsProduct').hide();
				$('#btnCreateBid').hide();
				$('#btnProdSearch').hide();
				$('#btnProductCancel').hide();
			}else {
				$('#btnExistsProduct').hide();
				$('#btnCreateBid').hide();
				$('#btnProdSearch').hide();
			}
			
			$('#stand_good_name').attr("disabled",true);
			$('#stand_good_name').attr("class","input_text_none");
			$(':radio[name="request_type"]').attr('disabled', 'disabled');
			$('#stand_good_spec_desc').attr("disabled",true);
			$('#stand_good_spec_desc').attr("class","input_text_none");
			$('#note').attr("disabled",true);
			$('#note').attr("class","input_text_none");
			$('img[name*="btnAttach"]').hide();
			$('#btnAddNewProduct').hide();
			$('#btnModNewProduct').hide();
			$('#btnDelNewProduct').hide();
			$('#btnReset').hide();
		}
	}
});
</script>

<script type="text/javascript">
//기상품 처리 프로세스
function fnExistsProductProcess() {
	
	if($.trim($('#good_iden_numb').html()) == "" ) {
		$('#dialogSelectRow').html('</br>기상품 처리시 상품선택은 필수 입니다.</br>확인후 이용하시기 바랍니다.');
		$("#dialogSelectRow" ).dialog();
		$("#good_iden_numb").focus();
		return;
	}
	
	var params; 
	params = {
			newgoodid:$('#newgoodid').val()
			,good_iden_numb:$('#good_iden_numb').html()
			,insert_user_id:'<%=insert_user_id%>'
	};
	
	if(!confirm("기상품처리를 하시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/product/setExistsProductProcess.sys", 
		params,
		function(arg){ 
			if(fnTransResult(arg, true)) {	//성공시
				var opener = window.dialogArguments;

				$('#btnExistsProduct').hide();
				$('#btnCreateBid').hide();
				$('#btnProdSearch').hide();
				$('#btnProductCancel').hide();
				window.opener.fnSearch(); 
// 				window.close();
			}
		}
	);
}

//입찰생성 프로세스
function fnCreateBidProcess() {
	var tempName = dialogArguments;
	var newgoodid = $('#newgoodid').val();
	tempName.fnCreateBidProcess(newgoodid);
// 	window.opener.fnCreateBidProcess(newgoodid);
	self.close();
}

//상품 상세 팝업 호출 
function fnProductDetail() {
	var good_iden_numb = $('#good_iden_numb').html();
	if($.trim($('#good_iden_numb').html()) == "" ) {
		$('#dialogSelectRow').html('</br>상품선택은 필수 입니다.</br>확인후 이용하시기 바랍니다.');
		$("#dialogSelectRow" ).dialog();
		$("#good_iden_numb").focus();
		return;
	}
	fnProductDetailView('<%=menuId %>',good_iden_numb,'','','');
}

function fnReqProduct(oper) {
	
	var newgoodid            = $('#newgoodid').val()                         ; // 고객사상품조회요청ID
	var stand_good_name      = $('#stand_good_name').val()                   ; // 요청품목명
	var request_type         = $(':radio[name="request_type"]:checked').val(); // 요청타입
	var stand_good_spec_desc = $('#stand_good_spec_desc').val()              ; // 요청규격
	var note                 = $('#note').val()                              ; // 요청사항
	var firstattachseq       = $('#firstattachseq').val()                    ; // 첨부파일1 
	var secondattachseq      = $('#secondattachseq').val()                   ; // 첨부파일2
	var thirdattachseq       = $('#thirdattachseq').val()                    ; // 첨부파일3
	var state                = $('#state').val()                             ; // 고객사상품등록요청상태
	var insert_user_id       = '<%=insert_user_id%>'                         ; // 요청자
	var insert_borgid        = '<%=insert_borgid%>'                          ; // 요청자조직
	
	// 요청 품목명
	if($.trim(stand_good_name) == "" ) {
		$('#dialogSelectRow').html('</br>상품명은 필수 입니다.</br>확인후 이용하시기 바랍니다.');
		$("#dialogSelectRow" ).dialog();
		$("#stand_good_name").focus();
		return;
	}
	
	// 요청 규격
	if($.trim(stand_good_spec_desc) == "" ) {
		$('#dialogSelectRow').html('</br>상품규격은 필수 입니다.</br>확인후 이용하시기 바랍니다.');
		$("#dialogSelectRow" ).dialog();
		$("#stand_good_spec_desc").focus();
		return;
	}
	
	// 요청 사항
	if($.trim(note) == "" ) {
		$('#dialogSelectRow').html('</br>요청사항은 필수 입니다.</br>확인후 이용하시기 바랍니다.');
		$("#dialogSelectRow" ).dialog();
		$("#note").focus();
		return;
	}
	
	var params; 
	params = {
			oper:oper
			,newgoodid:newgoodid
			,stand_good_name:stand_good_name
			,request_type:request_type
			,stand_good_spec_desc:stand_good_spec_desc
			,note:note
			,firstattachseq:firstattachseq
			,secondattachseq:secondattachseq
			,thirdattachseq:thirdattachseq
			,state:state
			,insert_user_id:insert_user_id
			,insert_borgid:insert_borgid
	};
	
	var requestType = "";
	if(request_type == "0") { requestType = "고객사상품등록"; }
	else { requestType = "고객사상품제안"; }
	
	var msg = "";
	if(oper == 'add') { //등록
		msg = "입력한 "+requestType+" 요청을 등록하시겠습니까?";
	} else if(oper == 'mod') { //수정
		msg = "입력한 "+requestType+" 요청을 수정하시겠습니까?";
	} else if(oper == 'del') { //삭제
		msg = "선택한 "+requestType+" 요청을 삭제하시겠습니까?";
	}
	
	if(!confirm(msg)) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/product/setNewProductRequest.sys", 
		params,
		function(arg){ 
			if(fnTransResult(arg, false)) {	//성공시
				if(oper == "add") {
					alert("등록 하였습니다.");
					fnReset();
				} else {
					var msg = "";
					if(oper == "mod") { msg = "수정 하였습니다."; }
					else if(oper == "del") { msg = "삭제 하였습니다."; }
					alert(msg);
// 					var opener = window.dialogArguments;
// 					opener.fnSearch();
					window.opener.fnSearch();
					window.close();
				}
			}
		}
	);
}

/**
 * 해당 Page 닫기
 */
function fnThisPageClose() {
	this.close();
// 	if(typeof(window.dialogArguments) == 'object') {
// 		top.close();
// 	}
};

//입력 초기화
function fnReset() {
	var d = new Date();
	var s = leadingZeros(d.getFullYear(), 4) + '-' + leadingZeros(d.getMonth() + 1, 2) + '-' + leadingZeros(d.getDate(), 2) ;
	$('#insert_date').val(s);
	$('#stand_good_name').val('');
	$('input:radio[name=request_type]:input[value=0]').attr("checked", true);
	$('#stand_good_spec_desc').val('');
	$('#note').val('');
	$('#firstattachseq').val('');
	$('#attach_file_path1').val('');
	$('#attach_file_name1').html('');
	$('#btnAttachDel1').hide();
	$('#secondattachseq').val('');
	$('#attach_file_path2').val('');
	$('#attach_file_name2').html('');
	$('#btnAttachDel2').hide();
	$('#thirdattachseq').val('');
	$('#attach_file_path3').val('');
	$('#attach_file_name3').html('');
	$('#btnAttachDel3').hide();
}

//사용자 함수
function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();
	
	if(n.length < digits) {
		for(var i = 0; i < digits - n.length; i++)
			zero += '0';
	}
	
	return zero + n;
}

function fnReplaceAll(temp, org, rep) {
	return temp.split(org).join(rep);
}

function fnReLoadDataGrid() {
	// 비어있는 함수
}
</script>


<%
/**------------------------------------첨부파일 사용방법 시작---------------------------------
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
	$(document).ready(function() {
		$("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#firstattachseq").val(), "fnCallBackAttach1"); });
		$("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#secondattachseq").val(), "fnCallBackAttach2"); });
		$("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#thirdattachseq").val(), "fnCallBackAttach3"); });
	});
	
	/**
	 * 첨부파일1 파일관리
	 */
	function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
		$("#firstattachseq").val(rtn_attach_seq);
		$("#attach_file_name1").text(rtn_attach_file_name);
		$("#attach_file_path1").val(rtn_attach_file_path);
		$('#btnAttachDel1').show();
	}
	
	/**
	 * 첨부파일2 파일관리
	 */
	function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
		$("#secondattachseq").val(rtn_attach_seq);
		$("#attach_file_name2").text(rtn_attach_file_name);
		$("#attach_file_path2").val(rtn_attach_file_path);
		$('#btnAttachDel2').show();
	}
	
	/**
	 * 첨부파일3 파일관리
	 */
	function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
		$("#thirdattachseq").val(rtn_attach_seq);
		$("#attach_file_name3").text(rtn_attach_file_name);
		$("#attach_file_path3").val(rtn_attach_file_path);
		$('#btnAttachDel3').show();
	}
	
	/**
	 * 파일다운로드
	 */
	function fnAttachFileDownload(attach_file_path) {
		var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
		var data = "attachFilePath="+attach_file_path;
		$.download(url,data,'post');
	}
	jQuery.download = function(url, data, method) {
		// url과 data를 입력받음
		if( url && data ) {
			// data 는 string 또는 array/object 를 파라미터로 받는다.
			data = typeof data == 'string' ? data : jQuery.param(data);
			// 파라미터를 form의 input으로 만든다.
			var inputs = '';
			jQuery.each(data.split('&'), function() {
				var pair = new Array();
				pair = this.split('=');
				inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />';
			});
			// request를 보낸다.
			jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
			.appendTo('body').submit().remove();
		};
	};
	
	/**
	 * 파일삭제
	 */
	function fnAttachDel(columnName) {
		if(!confirm("첨부파일을 삭제하시겠습니까?")) return;
		if(columnName=='firstattachseq') {
			$("#firstattachseq").val('');
			$("#attach_file_name1").text('');
			$("#attach_file_path1").val('');
			$("#btnAttachDel1").hide();
		} else if(columnName=='secondattachseq') {
			$("#secondattachseq").val('');
			$("#attach_file_name2").text('');
			$("#attach_file_path2").val('');
			$("#btnAttachDel2").hide();
		} else if(columnName=='thirdattachseq') {
			$("#thirdattachseq").val('');
			$("#attach_file_name3").text('');
			$("#attach_file_path3").val('');
			$("#btnAttachDel3").hide();
		}
	}
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>

<%
/**------------------------------------운영사 상품검색 팝업 --------------------------------- 789 
* fnOpenProdSearchPopForAdmin()을 호출하여 Div팝업을 Display ===
*/
%>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
	/**
	 * 
	 */
	function fnOpenProdSearchPopForAdmin() {
		var popurl = "/product/initProdSearchForAdm.sys?_menuId="+<%=menuId %>+"&isMultiSel=0";
		var popproperty = "dialogWidth:1030px;dialogHeight=540px;scroll=yes;status=no;resizable=no;";
// 		window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaSearch', 'width=1030, height=540, scrollbars=yes, status=no, resizable=no');
	}
	 
	// Call Back
	function fnProdSearchCallBack(good_Iden_Numb , good_Name , full_Cate_Name) {
		var msg = ""; 
		msg += "\n good_Iden_Numb value ["+good_Iden_Numb +"]"; 
		msg += "\n good_Name value ["+good_Name+"]";
		msg += "\n full_Cate_Name value ["+full_Cate_Name +"]";
		//alert(msg);
		$('#good_iden_numb').html(good_Iden_Numb);
		$('#good_Name').val(good_Name);
	}
	
	//btn_type2_standardOK
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>

<script type="text/javascript">
function newProductCancel() {
	var newGoodId = $('#newgoodid').val();
	var userId = "<%=loginUserDto.getUserId()%>";
	if(!confirm("요청 상품을 반려 하시겠습니까?")) return;
	$.post(
		"/product/newProductBid/newProductCancel/save.sys",
		{
			newGoodId:newGoodId,
			userId:userId,
			state:"91",
			oper:"edit"
		},
		function(arg){
			fnAjaxTransResult(arg);
			opener.fnSearch();
			window.close();
		}
		
	);
	
}

</script>


<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });	//메뉴얼호출
});

function branchManual(){
	var header = "";
	var manualPath = "";
	//신규상품/상품제안요청
	header = "신규상품/상품제안요청";
	manualPath = "/img/manual/branch/newProductRequestDetail.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>

</head>
<body>
<form id="frm" name="frm">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" />
					</td>
					<td height="29" class="ptitle"><%=strTitle%></td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="20" valign="top">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" />
					</td>
					<td class="stitle">고객사상품등록/제안요청 정보</td>
					<td align="right" class="ptitle">
						<button id="btnProductCancel" type="button" class="btn btn-primary btn-xs isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>"><i class="fa fa-hand-stop-o"></i>반려</button>
						<button id="btnExistsProduct" type="button" class="btn btn-primary btn-xs isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>"><i class="fa fa-check"></i>기품목처리</button>
						<button id="btnCreateBid" type="button" class="btn btn-primary btn-xs isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>;"><i class="fa fa-copy"></i>입찰생성</button>
					</td>
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
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9">고객사</td>
					<td colspan="3" class="table_td_contents">
						<input id="insert_borgid_nm" name="insert_borgid_nm" type="text" value="" size="20" maxlength="30" style="width:94%;" disabled="disabled" class="input_text_none" />
						<input id="newgoodid" name="newgoodid" type="hidden" value="<%=newgoodid %>" />
						<input id="insert_borgid" name="insert_borgid" type="hidden" value="" />
					</td>
					<td class="table_td_subject9">요청일자</td>
					<td class="table_td_contents">
						<input id="insert_date" name="insert_date" type="text" value="" size="20" maxlength="30" disabled="disabled" class="input_text_none" />
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9" width="100">상품명</td>
					<td class="table_td_contents">
						<input id="stand_good_name" name="stand_good_name" type="text" value="" size="20" maxlength="100" style="width:94%;" />
					</td>
					<td class="table_td_subject" width="100">요청타입</td>
					<td class="table_td_contents">
						<input name="request_type" style="border:0px;vertical-align:middle;" type="radio" value="0" checked="checked" />신규상품
						<input name="request_type" style="border:0px;vertical-align:middle;" type="radio" value="1" />상품옵션
					</td>
					<td class="table_td_subject9" width="100">진행상태</td>
					<td class="table_td_contents">
						<select id="state" name="state" disabled="disabled" class="select_none"></select>
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject9">상품규격</td>
					<td colspan="3" class="table_td_contents">
						<input id="stand_good_spec_desc" name="stand_good_spec_desc" type="text" value="" size="20" maxlength="100" style="width:94%;" />
					</td>
					<td class="table_td_subject">기상품코드
						<img id="btnProdSearch" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;vertical-align:middle;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>" />
					</td>
					<td class="table_td_contents">
						<a id="good_iden_numb" style="display:inline-block;width:130px;" href="#;"></a>
						<input id="good_Name" name="good_Name" type="hidden" value="" size="20" maxlength="100" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject10">요청사항</td>
					<td colspan="5" class="table_td_contents4">
						<textarea name="note" id="note" cols="45" rows="10" style="width:100%;height:200px;"></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" style="white-space:nowrap;">
						<table>
							<tr>
								<td>첨부파일1</td>
								<td>
									<a href="#">
									<img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border:0px" />
									</a>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents" style="width:16%;">
						<input type="hidden" id="firstattachseq" name="firstattachseq" value="" />
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="" />
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
						<span id="attach_file_name1"></span>
						</a>
						<a href="javascript:fnAttachDel('firstattachseq');">
						<img id="btnAttachDel1" name="btnAttachDel1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border:0px;vertical-align:bottom;" />
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" style="white-space:nowrap;">
						<table>
							<tr>
								<td>첨부파일2</td>
								<td>
									<a href="#">
									<img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border:0px" />
									</a>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents" style="width:16%">
						<input type="hidden" id="secondattachseq" name="secondattachseq" value="" />
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="" />
						<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
						<span id="attach_file_name2"></span>
						</a>
						<a href="javascript:fnAttachDel('secondattachseq');">
						<img id="btnAttachDel2" name="btnAttachDel2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border:0px;vertical-align:bottom;" />
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" style="white-space:nowrap;">
						<table>
							<tr>
								<td>첨부파일3</td>
								<td>
									<a href="#">
									<img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border:0px" />
									</a>
								</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents" style="width:16%">
						<input type="hidden" id="thirdattachseq" name="thirdattachseq" value="" />
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value=""/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
						<span id="attach_file_name3"></span>
						</a>
						<a href="javascript:fnAttachDel('thirdattachseq');">
						<img id="btnAttachDel3" name="btnAttachDel3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border:0px;vertical-align:bottom;" />
						</a>
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
		<td align="center">
			<button id="btnAddNewProduct" type="button" class="btn btn-primary btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-save"></i>저장</button>
			<button id="btnModNewProduct" type="button" class="btn btn-primary btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-save"></i>수정</button>
			<button id="btnDelNewProduct" type="button" class="btn btn-primary btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-eraser"></i>삭제</button>
			<button id="btnReset" type="button" class="btn btn-primary btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-repeat"></i>초기화</button>
			<button id="btnCommonClose" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
		</td>
	</tr>
</table>
<!-------------------------------- Dialog Div Start -------------------------------->
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p></p>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>