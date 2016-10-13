<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="kr.co.bitcube.product.dto.McNewGoodRequestDto"%>

<%@ page import="java.util.List"%>

<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");				// 사용자 권한
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);	// 사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));																		//메뉴Id
	String newgoodid = ( (String)request.getAttribute("newgoodid") == null ) ? "" : (String)request.getAttribute("newgoodid") ;// 고객사상품등록요청 ID
	McNewGoodRequestDto mcNewGoodRequestDto = new McNewGoodRequestDto();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	// Object Event
	$("#btnReqNewProduct").click(function()	{	fnReqNewProduct();					});
	$('#btnProdSearch').click(function()		{	fnOpenProdSearchPopForAdmin();	});
	$('#btnExistsProduct').click(function()	{	fnExistsProductProcess();			});
	$('#btnProdManage').click(function()		{	fnProductDetail();					});
	
	// 코드값 조회
	fnInitCodeData();
	
	// Component Data Bind 
	function fnInitCodeData() {
		$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
			{codeTypeCd:"NEW_PROD_STATE", isUse:"1"},
			function(arg){
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
			var d = new Date();
			var s = leadingZeros(d.getFullYear(), 4) + '-' + leadingZeros(d.getMonth() + 1, 2) + '-' + leadingZeros(d.getDate(), 2) ;
			$('#insert_date').val(s);
			
			$("#state option").each(function () {
				if($(this).text()!='요청')	{
					$(this).remove();
				}
			});
			
			$('#btnProdSearch').hide();
			$('#btnProdManage').hide();
			
			if('<%=loginUserDto.getSvcTypeCd()%>' == 'BUY') {
				// 고객사 인경우
				$('#insert_borgid').val('<%=loginUserDto.getBorgId()%>');
				$('#insert_borgid_nm').val('<%=loginUserDto.getBorgNms()%>');
				$('#btnSeachBorg').hide();
				$('#btnExistsProduct').hide();
			} else {
				// 운영사인경우
				$('#btnSeachBorg').show();
			}
			
			$('#stand_good_name').focus();
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
			{newgoodid:'<%=newgoodid%>'},
			function(arg) {
				var detailInfo = eval('(' + arg + ')').detailInfo;
				$('#newgoodid').val(detailInfo.newgoodid);
				$('#stand_good_name').val(detailInfo.stand_good_name);
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
				$('#insert_borgid_nm').val(detailInfo.borgNms);
				
				fnInitComponentForUpd();
			}
		);
	}
	
	// 수정일때 스크립트 실행
	function fnInitComponentForUpd() {
		$('#btnSeachBorg').hide();
		$('#newgoodid').attr("readonly",true);
		//$('#stand_good_name').attr("readonly",true);
		//$('#stand_good_spec_desc').attr("readonly",true);
		//$('#state').attr("readonly",true);
		//$('#note').attr("readonly",true);
		//$('#insert_date').attr("readonly",true);
		$('#stand_good_name').attr("disabled",true);
		$('#stand_good_spec_desc').attr("disabled",true);
		$('#state').attr("disabled",true);
		$('#note').attr("disabled",true);
		$('#insert_date').attr("disabled",true);
		$('img[name*="btnAttach"]').hide();
		
		if('<%=loginUserDto.getSvcTypeCd()%>' == 'BUY') {
			// 고객사 상세
			$('#btnReqNewProduct').hide();
			$('#btnExistsProduct').hide();
			$('#btnProdSearch').hide();
			$('#btnProdManage').hide();
		} else {
			// 운영사 상세
			if($('#state').val() == '10') {
				// 요청인
				$('#btnReqNewProduct').hide();
			}
			if($('#state').val() == '20') {
				// 입찰생성
			}
			if($('#state').val() == '30') {
				// 입찰완료
			}
			if($('#state').val() == '80') {
				// 상품등록
			}
			if($('#state').val() == '90') {
				// 기상품처리
				$('#btnProdSearch').hide();
				$('#btnProdManage').hide();
				$('#btnReqNewProduct').hide();
				$('#btnExistsProduct').hide();
			}
		}
	}
	
	// 사용자 함수
	function leadingZeros(n, digits) {
		var zero = '';
		n = n.toString();
		
		if(n.length < digits) {
			for(var i = 0; i < digits - n.length; i++)
				zero += '0';
		}
		
		return zero + n;
	}
});
</script>

<script type="text/javascript">
function fnReqNewProduct() {
	
	var newgoodid            = $('#newgoodid').val()           ; // 고객사상품조회요청ID
	var stand_good_name      = $('#stand_good_name').val()     ; // 요청품목명
	var stand_good_spec_desc = $('#stand_good_spec_desc').val(); // 요청규격
	var note                 = $('#note').val()                ; // 요청사항
	var firstattachseq       = $('#firstattachseq').val()      ; // 첨부파일1 
	var secondattachseq      = $('#secondattachseq').val()     ; // 첨부파일2
	var thirdattachseq       = $('#thirdattachseq').val()      ; // 첨부파일3
	var state                = $('#state').val()               ; // 신규품목요청상태
	var insert_user_id       = '<%=loginUserDto.getUserId()%>' ; // 요청자
	var insert_borgid        = '<%=loginUserDto.getBorgId()%>' ; // 요청자조직
	
	// 요청 품목명
	if($.trim(stand_good_name) == "" ) {
		$('#dialogSelectRow').html('<p>요청품목명은 필수 입니다.확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow" ).dialog();
		$("#stand_good_name").focus();
		return;
	}
	
	// 요청 규격
	if($.trim(stand_good_spec_desc) == "" ) {
		$('#dialogSelectRow').html('<p>요청규격은 필수 입니다.확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow" ).dialog();
		$("#stand_good_spec_desc").focus();
		return;
	}
	
	var params; 
	params = {
			newgoodid:newgoodid
			,stand_good_name:stand_good_name
			,stand_good_spec_desc:stand_good_spec_desc
			,note:note
			,firstattachseq:firstattachseq
			,secondattachseq:secondattachseq
			,thirdattachseq:thirdattachseq
			,state:state
			,insert_user_id:insert_user_id
			,insert_borgid:insert_borgid
	};
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/product/setNewProductRequest.sys", 
		params,
		function(arg){ 
			if(fnTransResult(arg, true)) {	//성공시
				alert('성공적으로 처리 되었습니다!');
				//$('#frm').attr('action','/order/orderRequest/orderList.sys');
				$('#frm').attr('action','/product/newProductRequestList.sys');
				$('#frm').attr('Target','_self');
				$('#frm').attr('method','post');
				$('#frm').submit();
			}
		}
	);
}

// 기상품 처리 프로세스 
function fnExistsProductProcess(){
	
	if($.trim($('#good_iden_numb').val()) == "" ) {
		$('#dialogSelectRow').html('<p>기상품 처리시 상품선택은 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow" ).dialog();
		$("#good_iden_numb").focus();
		return;
	}
	
	var params; 
	params = {
			newgoodid:$('#newgoodid').val()
			,good_iden_numb:$('#good_iden_numb').val()
	};
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/product/setExistsProductProcess.sys", 
		params,
		function(arg){ 
			if(fnTransResult(arg, false)) {	//성공시
				var opener = window.dialogArguments ;
				opener.fnSearch(); 
				alert('처리하였습니다.');
				window.close();
			}
		}
	);
}

// 상품 상세 팝업 호출 
function fnProductDetail(){
	
	if($.trim($('#good_iden_numb').val()) == "" ) {
		$('#dialogSelectRow').html('<p>상품선택은 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow" ).dialog();
		$("#good_iden_numb").focus();
		return;
	}
	
	var popurl = "/product/productDetail.sys?_menuId="+<%=menuId %>+"&goodIdenNumb="+$('#good_iden_numb').val();
	var popproperty = "dialogWidth:950px;dialogHeight=700px;scroll=yes;status=no;resizable=yes;";
	window.showModalDialog(popurl,null,popproperty);
// 	window.open(popurl, 'okplazaPop', 'width=950, height=700, scroll=yes, status=no, resizable=no');
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
	}
	
	/**
	 * 첨부파일2 파일관리
	 */
	function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
		$("#secondattachseq").val(rtn_attach_seq);
		$("#attach_file_name2").text(rtn_attach_file_name);
		$("#attach_file_path2").val(rtn_attach_file_path);
	}
	
	/**
	 * 첨부파일3 파일관리
	 */
	function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
		$("#thirdattachseq").val(rtn_attach_seq);
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
		var popproperty = "dialogWidth:950px;dialogHeight=570px;scroll=yes;status=no;resizable=no;";
// 		window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=950, height=570, scrollbars=yes, status=no, resizable=no');
	}
	 
	// Call Back
	function fnProdSearchCallBack(good_Iden_Numb , good_Name , full_Cate_Name) {
		var msg = ""; 
		msg += "\n good_Iden_Numb value ["+good_Iden_Numb +"]"; 
		msg += "\n good_Name value ["+good_Name+"]";
		msg += "\n full_Cate_Name value ["+full_Cate_Name +"]";
		//alert(msg);
		$('#good_iden_numb').val(good_Iden_Numb);
		$('#good_Name').val(good_Name);
	}
	
	//btn_type2_standardOK
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>

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
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
							</td>
							<td height="29" class="ptitle">신규품목 요청 상세</td>
						</tr>
					</table>
					<!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="20" valign="top">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
							</td>
							<td class="stitle">신규품목 요청 내용</td>
							<td align="right" class="ptitle">
								<img id="btnReqNewProduct" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type1_save.gif" style="width: 50px; height: 22px; cursor: pointer;" />
								<img id="btnExistsProduct" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_standardOK.gif" style="width: 82px; height: 18px; cursor: pointer;"/>
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
							<td class="table_td_subject" width="100">고객사</td>
							<td colspan="3" class="table_td_contents">
								<input id="newgoodid" name="newgoodid" type="hidden" value="<%=newgoodid %>" />
								<input id="insert_borgid" name="insert_borgid" type="hidden" value=""/>
								<input id="insert_borgid_nm" name="insert_borgid_nm" type="text" value="" size="20" maxlength="30" style="width: 400px; width: 90%" disabled="disabled" />
								<img id="btnSeachBorg" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" alt="고객사검색" height="20" width="18" style="cursor: pointer;vertical-align: middle;" />
							</td>
							<td class="table_td_subject" width="100">요청일자</td>
							<td class="table_td_contents">
								<input id="insert_date" name="insert_date" type="text" value="" size="20" maxlength="30" disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td colspan="6" height="1" bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject">상품명</td>
							<td colspan="3" class="table_td_contents">
								<input id="stand_good_name" name="stand_good_name" type="text" value="" size="20" maxlength="30" style="width: 400px; width: 94%" />
							</td>
							<td class="table_td_subject">진행상태</td>
							<td class="table_td_contents">
								<select id="state"></select>
							</td>
						</tr>
						<tr>
							<td colspan="6" height="1" bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject">상품규격</td>
							<td colspan="3" class="table_td_contents">
								<input id="stand_good_spec_desc" name="stand_good_spec_desc" type="text" value="" size="20" maxlength="30" style="width: 400px; width: 94%" />
							</td>
							<td class="table_td_subject">기상품코드
								<img id="btnProdSearch" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; vertical-align: middle; cursor: pointer;" />
							</td>
							<td class="table_td_contents">
								<input id="good_Name" name="good_Name" type="text" value="" size="20" maxlength="30" disabled="disabled" style="width: 12px;width: 60%;" />
								<input id="good_iden_numb" name="good_iden_numb" type="hidden" value="" size="20" maxlength="30" readonly="readonly" style="width: 12px;width: 60%;" />
								<img id="btnProdManage" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Wrench.gif" style="width: 15px; height: 15px; vertical-align: middle; cursor: pointer;" />
							</td>
						</tr>
						<tr>
							<td colspan="6" height="1" bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject">요청사항</td>
							<td colspan="5" class="table_td_contents4">
								<textarea name="note" id="note" cols="45" rows="10" style="width: 500px; width:90%;height: 50px"></textarea>
							</td>
						</tr>
						<tr>
							<td colspan="6" height="1" bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" style="white-space:nowrap;width: 16%;">
								<table>
									<tr>
										<td>첨부파일1</td>
										<td>
											<a href="#">
											<img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
											</a>
										</td>
									</tr>
								</table>
							</td>
							<td class="table_td_contents" style="width: 16%;">
								<input type="hidden" id="firstattachseq" name="firstattachseq" value="<%=CommonUtils.getString(mcNewGoodRequestDto.getFirstattachseq()) %>"/>
								<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=CommonUtils.getString(mcNewGoodRequestDto.getFirstAttachPath()) %>"/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
								<span id="attach_file_name1"></span>
								</a>
<%	if(!"".equals(CommonUtils.getString(mcNewGoodRequestDto.getFirstattachseq()))) {	%>
								<a href="javascript:fnAttachDel('<%=CommonUtils.getString(mcNewGoodRequestDto.getFirstattachseq()) %>','firstattachseq');">
								<img id="btnAttachDel1" name="btnAttachDel1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border: 0px;vertical-align: bottom;" />
								</a>
<%	} %>
							</td>
							<td class="table_td_subject" style="white-space:nowrap;width: 16%">
								<table>
									<tr>
										<td>첨부파일2</td>
										<td>
											<a href="#">
											<img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
											</a>
										</td>
									</tr>
								</table>
							</td>
							<td class="table_td_contents">
								<input type="hidden" id="secondattachseq" name="secondattachseq" value="<%=CommonUtils.getString(mcNewGoodRequestDto.getSecondattachseq()) %>"/>
								<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=CommonUtils.getString(mcNewGoodRequestDto.getSecondAttachPath()) %>"/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
								<span id="attach_file_name2"><%=CommonUtils.getString(mcNewGoodRequestDto.getSecondAttachName()) %></span>
								</a>
<%	if(!"".equals(CommonUtils.getString(mcNewGoodRequestDto.getSecondattachseq()))) { %>
								<a href="javascript:fnAttachDel('<%=CommonUtils.getString(mcNewGoodRequestDto.getSecondattachseq()) %>','secondattachseq');">
								<img id="btnAttachDel2" name="btnAttachDel2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border: 0px;vertical-align: bottom;" />
								</a>
<%	} %>
							</td>
							<td class="table_td_subject" style="white-space:nowrap ;width: 16%;">
								<table>
									<tr>
										<td>첨부파일3</td>
										<td>
											<a href="#">
											<img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
											</a>
										</td>
									</tr>
								</table>
							</td>
							<td class="table_td_contents" style="width: 16%">
								<input type="hidden" id="thirdattachseq" name="thirdattachseq" value="<%=CommonUtils.getString(mcNewGoodRequestDto.getThirdattachseq()) %>"/>
								<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=CommonUtils.getString(mcNewGoodRequestDto.getThirdAttachPath()) %>"/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
								<span id="attach_file_name3"><%=CommonUtils.getString(mcNewGoodRequestDto.getThirdAttachName()) %></span>
								</a>
<%	if(!"".equals(CommonUtils.getString(mcNewGoodRequestDto.getThirdattachseq()))) {	%>
								<a href="javascript:fnAttachDel('<%=CommonUtils.getString(mcNewGoodRequestDto.getThirdattachseq()) %>','thirdattachseq');">
								<img id="btnAttachDel3" name="btnAttachDel3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border: 0px;vertical-align: bottom;" />
								</a>
<%	} %>
							</td>
						</tr>
						<tr>
							<td colspan="6" height="1" bgcolor="eaeaea"></td>
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