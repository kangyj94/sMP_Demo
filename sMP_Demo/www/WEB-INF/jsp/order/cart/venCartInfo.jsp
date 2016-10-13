<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.order.dto.CartMasterInfoDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.UserDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%
	//그리드의 width와 Height을 정의
	@SuppressWarnings("unchecked")
    List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String vendorId = userDto.getBorgId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
    <link rel="stylesheet" type="text/css" href="/css/Global.css">
    <link rel="stylesheet" type="text/css" href="/css/Default.css">
    
    <style type="text/css">
    .jqmPop {
        display: none;
        position: fixed;
        top: 17%;
        left: 50%;
        margin-left: -400px;
        width: 0px;
        border: 0px;
        padding: 0px;
        height: 0px;
    }
    .jqmOverlay { background-color: #000; }
    * html .jqmPop {
         position: absolute;
         top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
    }
   input[type=radio] { vertical-align: middle;}
    </style>
</head>

<body class="subBg">
	<div id="divWrap">
		<!-- header -->
        <%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
		<!-- /header -->
		<hr>
		<div id="divBody">
			<div id="divSub">
                <jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />

				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea"> <li class="on">일괄 항목</li> </ul>
					<table class="InputTable">
						<colgroup>
							<col width="120px" />
							<col width="auto" />
							<col width="120px" />
							<col width="350px" />
						</colgroup>
						<tr>
							<th >구매사</th>
							<td>
								<input type="hidden" style="width:200px;" id="branchId" value=""/>
								<input type="text" style="width:200px;" id="borgName" value=""/>
								&nbsp;<a href="#;"><img id="searchBorgBtn" src="/img/contents/icon_search.gif"></a>
							</td>
							<th>주문자</th>
							<td>
								<select name="orde_userId" id="orde_userId" style="width:80px;">
									<option value="">선택</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>공사명(주문명)</th>
							<td>
								<input id="cons_iden_name" name="cons_iden_name" type="text" style="width:400px;" value="" class="InfoText" />
							</td>
							<th>인수자</th>
							<td>
								<input id="tran_user_name" name="tran_user_name" type="text" style="width:150px;" value=""  class="InfoText"/>
							</td>
						</tr>
						<tr>
							<th>비고</th>
							<td>
								<input id="orde_text_desc" name="orde_text_desc" type="text" style="width:400px;" value=""  class="InfoText"/>
							</td>
							<th>인수자 전화번호</th>
							<td>
								<input id="tran_tele_numb" name="tran_tele_numb" type="text" style="width:150px;" value=""  class="InfoText"/>
							</td>
						</tr>
						<tr>
							<th>
								<button id='btnAddDeliveryAddress' class="btn btn-darkgray btn-xs">배송지</button>
							</th>
							<td colspan="3">
								<select name="tran_deta_addr_seq" id="tran_deta_addr_seq" style="width:550px;" >
									<option value="" selected="selected">선택</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>첨부파일1</th>
							<td>
								<input type="hidden" id="firstattachseq" name="firstattachseq" value=""/>
								<input type="hidden" id="attach_file_path1" name="attach_file_path1" value=""/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
									<span id="attach_file_name1"></span>
								</a>
								<div style="float:right">
                                    <button id='btnAttach1' class="btn btn-outline btn-darkgray btn-xs">등록</button>
                                    <button id='btnAttachDel1' class="btn btn-default btn-xs" onclick="javascript:fnAttachDel('firstattachseq');" style="display:none;">삭제</button>
								</div>
							</td>
							<th>첨부파일2</th>
							<td>
								<input type="hidden" id="secondattachseq" name="secondattachseq" value=""/>
								<input type="hidden" id="attach_file_path2" name="attach_file_path2" value=""/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
									<span id="attach_file_name2"></span>
								</a>
								<div style="float:right">
                                    <button id='btnAttach2' class="btn btn-outline btn-darkgray btn-xs" style="">등록</button>
                                    <button id='btnAttachDel2' class="btn btn-default btn-xs" onclick="javascript:fnAttachDel('secondattachseq');" style="display:none;">삭제</button>
								</div>
							</td>
						</tr>
					</table>
					<ul class="Tabarea mgt_20"> <li class="on">역주문 상품</li> </ul>
					<div style="position:absolute; right:0; margin-top:-35px;">
                        <button id='btnProdSearchDiv' class="btn btn-danger btn-sm" ><i class="fa fa-search"></i> 상품조회</button>
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnAllOrder();">전체 상품 주문신청</a>
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnSelOrder();">선택 상품 주문신청</a>
					</div>
					<div class="ListTable" >
						<table id="reverseOrdProdList">
							<colgroup>
								<col width="30px" />
								<col width="530px" />
								<col width="100px" />
								<col width="100px" />
								<col width="140px" />
								<col width="100px" />
							</colgroup>
							<tr>
								<th class="br_l0"><input id="cartCheckAll" name="cartCheckAll" type="checkbox" value="" onclick="javascript:fnCheckAll();" /></th>
								<th>상품정보</th>
								<th><p>단가 주문수량</p></th>
								<th>금액</th>
								<th>납기 희망일(표준납기일)</th>
								<th>선택주문</th>
							</tr>							
						</table>
					</div>
					<div class="TotalCount">
						<table width="100%">
							<tr>
								<td align="center" class="col01">
									<p>공급가액</p>
									<p id="sumPrice"><strong class="f18">0</strong> 원</p>
								</td>
								<td align="center"><img src="/img/contents/icon_plus.png" /></td>
								<td align="center" class="col01">
									<p>부가세</p>
									<p id="taxPrice"><strong class="f18">0</strong> 원</p>
								</td>
								<td align="center"><img src="/img/contents/icon_same.png" /></td>
								<td align="center" class="col02">
									<p>최종금액</p>
									<p id="totPrice"><strong class="f18">0</strong> 원</p>
								</td>
							</tr>
						</table>
					</div>
					<div class="floatleft mgt_10">
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnSetCheckAll();">전체선택</a>
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnSelectedPdtDelete();">선택 상품 삭제</a>
					</div>
					<div class="floatright mgt_10">
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnAllOrder();">전체 상품 주문신청</a>
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnSelOrder();">선택 상품 주문신청</a>
					</div>
				</div>
				<!--컨텐츠(E)-->
			</div>
            <jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
	
	
	<!-- 상품조회 리스트 레이어 팝업 -->
	<div id="prodSearchPop" class="jqmPop">
    	<div>
		  	<div id="divPopup" style="width: 700px;">
		  		<div id="popPrSrcDrag">
			  		<h1>상품조회<a href="#;"><img id="pdSrcCloseButton1" src="/img/contents/btn_close.png"/></a></h1>
		  		</div>
		    	<div class="popcont">
		    		<table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
		    			<tr>
		    				<td align="right">
                                <button id='btnSearchProdSearchPop' class="btn btn-danger btn-xs" ><i class="fa fa-search"></i> 조회</button>
		    				</td>
		    			</tr>
		    			<tr>
		    				<td style="height: 5px"> </td>
		    			</tr>
		    		</table>
		      		<table class="InputTable">
                        <colgroup>
                            <col width="100px" />
                            <col width="auto" />
                            <col width="100px" />
                            <col width="auto" />
                        </colgroup>
                        <tr>
                            <th>상품명</th>
                            <td><input type="text" style="width:180px;" id="srcGoodName" value=""/></td>
                            <th>상품코드</th>
                            <td><input type="text" style="width:120px;" id="srcGoodIdenNumb" value=""/></td>
                        </tr>
                        <tr>
                            <th>상품구분</th>
                            <td>
                                <input type="radio" name="srcGoodType" id="srcGoodType_0" value=""  checked="checked"/> <label for="srcGoodType_0">전체</label>
                                <input type="radio" name="srcGoodType" id="srcGoodType_1" value="10"/> <label for="srcGoodType_1">일반</label>
                                <input type="radio" name="srcGoodType" id="srcGoodType_2" value="20"/> <label for="srcGoodType_2">지정</label>
                            </td>
                            <th>규격</th>
                            <td><input type="text" style="width:120px;" id="srcGoodSpec" value=""/></td>
                        </tr>
                        <tr>
                            <th>상품유형</th>
                            <td colspan="3">
                                <input type="radio" name="srcRepreGood" id="srcRepreGood_0" value="" checked="checked"/> <label for="srcRepreGood_0">전체</label>
                                <input type="radio" name="srcRepreGood" id="srcRepreGood_1" value="N"/> <label for="srcRepreGood_1">단품</label>
                                <input type="radio" name="srcRepreGood" id="srcRepreGood_2" value="Y"/> <label for="srcRepreGood_2">옵션</label>
                            </td>
                        </tr>
                    </table>
                    
                    
                    <table class="SRCTable mgt_20" id="productList">
                        <colgroup>
                            <col width="459px" />
                            <col width="165px" />
                        </colgroup>
                    </table>
                    <div class="divPageNum" id="pager"></div>
                    <div class="Ac mgt_10"> <a id='prSrcCloseButton2'  class="btn btn-default btn-xs"><i class="fa fa-close"></i> 닫기</a> </div>
                    
                    
		    	</div>
		  	</div>
	  	</div>  
  	</div>
	<!-- //상품조회 리스트 레이어 팝업 -->
  	
    <input type="hidden" style="width:200px;" id="repreGoodNumbPop" value=""/>
	<!-- 옵션조회 리스트 레이어 팝업 -->
	<div id="optionDetailPop" class="jqmPop">
    	<div>
		  	<div id="divPopup" style="width: 600px;">
		  		<div id="popDetailDrag1">
			  		<h1>옵션선택<a href="#;"><img id="optionCloseButton1Pop" src="/img/contents/btn_close.png"/></a></h1>
		  		</div>
		    	<div class="popcont">
		      		<table class="InputTable" id="commonDetailOptTablePop"></table>
		      		<div class="GridList">
						<table>
							<tr>
				            	<td>
				               		<div id="jqgrid">
				                  		<table id="pdtDetailPoplist"></table>
				               		</div>
				            	</td>
				         	</tr>		        			
		      			</table>
		      		</div>
		      		<div class="Ac mgt_10">
		      			<a id='saveOptCartButtonPop'  	class="btn btn-danger btn-xs"><i class="fa fa-save"></i>역주문 상품담기</a>
		      			<a id='optionCloseButton2Pop'  class="btn btn-default btn-xs"><i class="fa fa-close"></i>닫기</a>
		      		</div>
		    	</div>
		  	</div>
	  	</div>  
  	</div>
	<!-- //옵션조회 리스트 레이어 팝업 -->
  	
</body>

<!-- 고객사 팝업 추후 구현 -->
<%
/**------------------------------------고객사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 고객사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDivForVenOrdRequ.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){

	function fnAllPdtDelete(){
	    
	    $("tr[id^=reverseOrdProd_]").remove();
		fnCartSummary();
	}
	
	$("#searchBorgBtn").click(function(){
		var borgNm = $("#borgName").val();
		if($("#branchId").val() != ""  ) {
			if(confirm("구매사 변경을 진행하실경우 일괄 항목 및 역주문 상품리스트가 초기화 됩니다. 진행하시겠습니까?")){
				$("#borgName").val("");
				$("#branchId").val("");
				$("#orde_userId").val("");
				$(".InfoText").val("");
				fnAllPdtDelete();
				fnInitComponent();		
			} else {
				return;
			}
		}
		fnBuyborgDialog( borgNm, "fnCallBackBuyBorg");
	});
	
	$("#borgName").change(function(){
		$("#branchId").val("");
	});
	$("#borgName").keypress(function(e){
		if( e.keyCode == 13){
			$("#searchBorgBtn").click();
		}	
	});
	$("#orde_userId").change(function(){
		$(".InfoText").val("");
		fnChnageOrderUser();
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg( branchId, borgNm) {
	
	$("#branchId").val(branchId);
	$("#borgName").val(borgNm);
	fnInitComponent();
	fnGetBuyerInfo();
	fnGetBuyAddressInfo()
}
//컴퍼넌트초기화 
function fnInitComponent() {
	$("#orde_userId").children().remove().end().append('<option selected value="">선택</option>');
	$('#tran_deta_addr_seq').children().remove().end().append('<option selected value="">선택</option>');
// 	reverseOrdPdtList = [];
// 	$(".reverseOrdProd").remove();
}
// 조직에 따른 사용자 정보 조회 
function fnGetBuyerInfo() {
	$.post( //조회조건의 권역세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/getUserInfoListByBranchIdInVendorOrderRequest.sys',
		{
			borgId:$("#branchId").val()
		},
		function(arg){
			var userList = eval('(' + arg + ')').userList;
			for(var i=0;i<userList.length;i++) {
				$("#orde_userId").append("<option value='"+userList[i].userId+"'>"+userList[i].userNm+"</option>");
			}
		}
	);
}
// 배송지 정보 조회
function fnGetBuyAddressInfo() {
	$.post( //조회조건의 권역세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getDeliveryAddressByBranchId.sys',
		{
			branchId	:	$("#branchId").val(),
		},
		function(arg){
			var deliveryListInfo = eval('(' + arg + ')').deliveryListInfo;
			var seletedStr = "";
			$("#tran_deta_addr_seq").html("<option value=''>선택</option>");
			for(var i=0;i<deliveryListInfo.length;i++) {
				if( i==0){ seletedStr = "selected"}
				else{seletedStr = ""}
				$("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"' "+seletedStr+" >"+deliveryListInfo[i].shippingaddres+" ["+deliveryListInfo[i].shippingplace+"]"+"</option>");
			}
		}
	);
}

function fnChnageOrderUser(){
	if( ! $("#branchId").val() ){
		alert("사업장 정보가 없습니다.");
		return;
	}
	if( ! $("#orde_userId").val() ){
		alert("주문자 정보가 없습니다.");
		return;
	}
	
	
	$.post( 
		'/venOrder/BuyUserMstCartInfo.sys',
		{	
			branchid:$("#branchId").val(),
			userid	:$("#orde_userId").val()
		},
		function(arg){
			var userInfo = eval('(' + arg + ')').userInfo;
			
// 			$("#cons_iden_name").val(userInfo.comp_iden_name);
// 			$("#orde_text_desc").val(userInfo.orde_text_desc);
			$("#tran_user_name").val(userInfo.tran_user_name);
			$("#tran_tele_numb").val( fnSetTelformat( userInfo.tran_tele_numb ) );
		}
	);
}


</script>
<% //----------------------------------조직검색팝업 종료 ------------------------------ %>
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
$(document).ready(function(){
	$("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#firstattachseq").val(), "fnCallBackAttach1"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#secondattachseq").val(), "fnCallBackAttach2"); });
});
/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#firstattachseq").val(rtn_attach_seq);
	$("#attach_file_name1").text(rtn_attach_file_name);
	$("#attach_file_path1").val(rtn_attach_file_path);
	$("#btnAttachDel1").show();
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#secondattachseq").val(rtn_attach_seq);
	$("#attach_file_name2").text(rtn_attach_file_name);
	$("#attach_file_path2").val(rtn_attach_file_path);
	$("#btnAttachDel2").show();
}

//첨부파일 삭제
function fnAttachDel(columnName) {
	if(columnName=='firstattachseq') {
		$("#firstattachseq").val('');
		$("#attach_file_name1").text('');
		$("#attach_file_path1").val('');
		$("#btnAttachDel1").css("display","none");
	} else if(columnName=='secondattachseq') {
		$("#secondattachseq").val('');
		$("#attach_file_name2").text('');
		$("#attach_file_path2").val('');
		$("#btnAttachDel2").css("display","none");
	} 
}

/**
 * 파일다운로드
 */
function fnAttachFileDownload(attach_file_path) {
	var url = "/common/attachFileDownload.sys";
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
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>
<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () { $("#snb_vdr").show(); });
	$("#divGnb").mouseout(function () { $("#snb_vdr").hide(); });
	$("#snb_vdr").mouseover(function () { $("#snb_vdr").show(); });
	$("#snb_vdr").mouseout(function () { $("#snb_vdr").hide(); });
	
	$("#cartCheckAll").prop("checked", true);
	
	
	
	<%-- 역주문 상품 조회  --%>
	$('#prodSearchPop').jqm();	//Dialog 초기화
	$("#pdSrcCloseButton1").click(function(){
		$("#prodSearchPop").jqmHide();
		fnVenProdSearchInit();
	});
	$("#prSrcCloseButton2").click(function(){ 
		$("#prodSearchPop").jqmHide(); 
		fnVenProdSearchInit();
	});
	$('#prodSearchPop').jqm().jqDrag('#popPrSrcDrag');
	$("#btnProdSearchDiv").click(function(){   
		if(  $("#branchId").val() == ''   ){
			alert("구매사 선택 후 상품조회가 가능합니다.");
			return;
		}
        fnVenProdSearchInit();
        $("#prodSearchPop").jqmShow();
        fnProdSearch();
	});
	$("#btnSearchProdSearchPop").click(function(){fnProdSearch();});
	
	// 역주문 상품 조회 
    $("#srcGoodName").keydown(function(e) { if(e.keyCode==13) { fnProdSearch(); } });
    $("#srcGoodIdenNumb").keydown(function(e) { if(e.keyCode==13) { fnProdSearch(); } });
    $("#srcGoodSpec").keydown(function(e) { if(e.keyCode==13) { fnProdSearch(); } });

	<%-- 옵션 상품 조회  --%>
	$('#optionDetailPop').jqm();	//Dialog 초기화
	$("#optionCloseButton1Pop").click(function(){$("#optionDetailPop").jqmHide();});
	$("#optionCloseButton2Pop").click(function(){$("#optionDetailPop").jqmHide();});
	$('#optionDetailPop').jqm().jqDrag('#popDetailDrag1');
	$("#saveOptCartButtonPop").click(function(){
		var commonOptCnt = Number($("#commonOptCntPop").val());
		var commonOpt = "";
		
		for(var i = 0 ; i < commonOptCnt ; i++ ){
			var optVal = $.trim($("#commonOptPop_" + i).val());
			if(optVal == ''){
				alert("공통옵션을 선택해 주세요.");
				$("#commonOptPop_" + i).focus();
				return;
			}
			if(i == 0)	commonOpt = optVal;
			else		commonOpt += ", "+optVal;
		}
		
		var goodNumbs = new Array();			
		var ordQuans = new Array();			
		var vendorIds = new Array();			
		var chkCnt = 0;
		var id = $("#pdtDetailPoplist").getGridParam('selarrrow');
	    var ids = $("#pdtDetailPoplist").jqGrid('getDataIDs');
	    var repreGoodNumb = $("#repreGoodNumbPop").val();

	    if(repreGoodNumb == ''){
	    	return;
	    }
	    
	    for (var i = 0; i < ids.length; i++) {
	    	var check = false;
	        $.each(id, function (index, value) {
	        	if (value == ids[i])	check = true;
	        });
	        if (check) {
	        	var rowdata = $("#pdtDetailPoplist").getRowData(ids[i]);
	        	goodNumbs[chkCnt] = rowdata.GOOD_IDEN_NUMB;
	        	vendorIds[chkCnt] = rowdata.VENDORID;
	        	
	        	if($.trim($("#setQtyPop_"+ids[i]).val()) == ''){
	        		alert("["+rowdata.GOOD_SPEC+"] 상품의 수량을 입력해 주세요.");
	        		return;
	        	}
	        	ordQuans[chkCnt] = $("#setQtyPop_"+ids[i]).val();
	        	chkCnt++;
	        }
	    }
	    if(chkCnt == 0){
	    	alert("옵션 상품을 선택해 주세요.");
	    	return;
	    }
		if(!confirm("선택한 옵션 상품들을 역주문 대상 상품에 담겠습니까?")){
			return false;
		}
	    $.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/venProduct/venOrdReqSrcOptPdtList.sys',
			{	
	        	kind:"OPT",
				commonOpt:commonOpt,
				goodNumbs:goodNumbs,
	        	repreGoodNumb:repreGoodNumb,
	        	ordQuans:ordQuans,
	        	vendorIds:vendorIds
	        },
			function(arg){
	        	var resultList = eval('(' + arg + ')').list;
	        	if(resultList.length > 0){
	        		prodListObjctTemp = prodListObjct;
	        		prodListObjct = resultList;
	        		for(var i = 0; i < prodListObjct.length; i++){
                        makeReverseOrderPdtInfo(i);
	        		}
	        	}else{
	        		alert("옵션정보 담기중 오류가 발생하였습니다.");
	        	}
	        	if(resultList.length > 0){
	        		prodListObjct = prodListObjctTemp;
	        	}
                $("#optionDetailPop").jqmHide();
	        }
		);			
	    
	});
});


function fnVenProdSearchInit(){
	$("#srcGoodName").val("");
	$("#srcGoodIdenNumb").val("");
	$("#"+$("input[name=srcGoodType]")[0].id).attr("checked","checked");
	$("#srcGoodSpec").val("");
	$("#"+$("input[name=srcRepreGood]")[0].id).attr("checked","checked");
	
	$("#pager").append("");	
    var length = $(".pdtData").length;
    if(length > 0){
        for(var i=0; i<length; i++){
            $("#pdtData_"+i).remove();
        }
    }
    $("#pager").empty();
}

var prodListObjct = null;
var prodListObjctTemp = null;
function fnProdSearch(page){
	$.blockUI();
	var srcGoodName = $("#srcGoodName").val();
	var srcGoodIdenNumb = $("#srcGoodIdenNumb").val();
	var srcGoodType = $(':radio[name="srcGoodType"]:checked').val();
	var srcGoodSpec = $("#srcGoodSpec").val();
	var srcRepreGood = $(':radio[name="srcRepreGood"]:checked').val();
	var srcBranchId = $("#branchId").val();
// 	alert( "srcGoodName : "+srcGoodName +"\nsrcGoodIdenNumb : "+srcGoodIdenNumb +"\nsrcGoodType ; "+srcGoodType +"\nsrcGoodSpec : "+srcGoodSpec +"\nsrcRepreGood : "+srcRepreGood);
	
	var page		= page;
	var rows		= 4;
	$.post(
		"/venProduct/venOrdReqSrcPdtList.sys",
		{
			srcGoodName:srcGoodName,
			srcGoodIdenNumb:srcGoodIdenNumb,
			srcGoodType:srcGoodType,
			srcGoodSpec:srcGoodSpec,
			srcRepreGood:srcRepreGood,
			srcBranchId :srcBranchId ,
			
			page:page,
			rows:rows
		},
		function(arg){
            var length = $(".pdtData").length;
            if(length > 0){
                for(var i=0; i<length; i++){
                    $("#pdtData_"+i).remove();
                }
            }
            $("#pager").empty();
			var list		= arg.list;
			var currPage	= arg.page;
			var rows		= arg.rows;
			var total		= arg.total;
			var records		= arg.records;
			var pageGrp		= Math.ceil(currPage/5);
			var startPage	= (pageGrp-1)*5+1;
			var endPage		= (pageGrp-1)*5+5;
			if(Number(endPage) > Number(total)){
				endPage = total;
			}
			if(records > 0){
				<%-- 조회 결과 리스트를 variable 세팅 --%>
				prodListObjct = list;
				for(var i=0; i<list.length; i++){
					var info = list[i].info[0];
					var str = "";
                    str += "<tr class='pdtData' id='pdtData_"+i+"'>                                                                           ";
                    str += "    <td>                                                                                                                     ";
                    str += "        <dl>                                                                                                                 ";
                    str += "            <dt>                                                                                                             ";
                    str += "                <img src=\"/upload/image/"+info.IMG_PATH+"\"  onerror=\"this.src = '/img/layout/img_null.jpg'\" width=\"100px;\" height=\"100px;\" />                                                ";
                    str += "            </dt>                                                                                                            ";
                    str += "            <dd>                                                                                                             ";
                    str += "                <p class=\"bold\">"+list[i].GOOD_NAME+"</p>                                      ";
                    str += "                <ul>                                                                                                         ";
                    str += "                    <li>규격 : <strong>"+list[i].GOOD_SPEC+"</strong></li>                                      ";
                    str += "                    <li>상품코드 : <strong>"+list[i].GOOD_IDEN_NUMB+"</strong></li>                                            ";
                    str += "                    <li>제조원 : <strong>"+info.MAKE_COMP_NAME+"</strong></li>                                                 ";
                    str += "                    <li>표준납기일 : <strong>"+info.DELI_MINI_DAY+"일</strong></li>                                                    ";
                    str += "                </ul>                                                                                                        ";
                    str += "                <p class=\"bold\">"+fnComma(info.SALE_UNIT_PRIC)+" 원</p>                                                                     ";
                    str += "            </dd>                                                                                                            ";
                    str += "        </dl>                                                                                                                ";
                    str += "        <div class=\"label\">    ";
                    if(list[i].REPRE_GOOD == 'Y') {
                    	
                    str += "        	<span class=\"option\" style=\"cursor: text;\">옵션</span>                                                                                                                ";
                    
                    }
                    if(list[i].GOOD_TYPE == '20') {
                    	
                    str += "        	<span class=\"appoint\"  style=\"cursor: text;\">지정</span>                                                                                                                ";
                    
                    }
                    str += "        </div>                                                                                                                ";
                    str += "    </td>                                                                                                                    ";
                    str += "    <td class=\"count\">                                                                                               ";
                    str += "        <ul>                                                                                                                 ";
                    str += "            <li>재고 : <span><strong class=\"f16\">"+info.GOOD_INVENTORY_CNT+"</strong> 개</span></li>                           ";
                    if(list[i].REPRE_GOOD != 'Y') {

                    str += "            <li>수량 : <span> <input name=\"input\" type=\"text\" style=\"width:50px;\" id=\"pdtOrdRequQuan_"+i+"\" value=\""+info.DELI_MINI_QUAN+"\" onkeydown=\"return onlyNumber(event)\" /> 개</span></li>                             ";
                    
                    }
                    str += "            <li class=\"mgt_15\"><a href=\"#\" onclick=\"javascript:reverseOrdPdt('"+i+"')\"><img src=\"/img/contents/btn_reoder.gif\" /></a></li>                               ";
                    str += "        </ul>                                                                                                                ";
                    str += "    </td>                                                                                                                    ";
                    str += "</tr>                                                                                                                        ";
					$("#productList").append(str);
				}
				fnPager(startPage, endPage, currPage, total, 'fnProdSearch');	//페이져 호출 함수

			}else{
                str += " <tr class='pdtData' id='pdtData_0'>                                                                                                                                            ";
                str += "   <td class='br_l0' colspan='8' align='center' >조회된 결과가 없습니다.</td>                                                                                                                                          ";
                str += " </tr>                                                                                                                                                         ";
                $("#productList").append(str);
			}
			$.unblockUI();
		},
		"json"
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

function reverseOrdPdt(index){
    var pdtMstData = prodListObjct[index];
	if(pdtMstData.REPRE_GOOD !="Y"){
		if(!confirm("["+pdtMstData.GOOD_NAME+"] 상품을 역주문 대상 상품에 담겠습니까?")){
			return false;
		}
	}
	makeReverseOrderPdtInfo(index);
}
function makeReverseOrderPdtInfo(index){
	var cartPdtCnt = $("[name=cartChk]").length;
	if(prodListObjct[index] != null){
        var pdtMstData = prodListObjct[index];
		for(var exIndex = 0; exIndex < cartPdtCnt; exIndex++){
			if($.trim(pdtMstData.GOOD_IDEN_NUMB) == $.trim( $("#goodIdenNumb_"+exIndex).val())){
				alert("["+pdtMstData.GOOD_NAME+"] 상품 ["+pdtMstData.GOOD_SPEC+"] 규격은 이미 역주문 대상 상품에 추가되어있습니다.");
				return false;
			}
		}
		if(pdtMstData.REPRE_GOOD =="Y"){
			<%-- 대표 옵션 상품일 경우 옵션 선택 레이어 팝업 생성. --%>
            $("#pdtDetailPoplist").jqGrid('setGridParam', {url:'/product/getOptionPdtList/list.sys'});
            var data = $("#pdtDetailPoplist").jqGrid("getGridParam", "postData");
            data.goodIdenNumb  	= pdtMstData.GOOD_IDEN_NUMB;
            data.vendorId 		= "<%=vendorId%>";
            $("#pdtDetailPoplist").trigger("reloadGrid");  	
            $("#optionDetailPop").jqmShow();
            $.post(
                '<%=Constances.SYSTEM_CONTEXT_PATH %>/buyProduct/getProductOption.sys',
                {	
                    goodIdenNumb:pdtMstData.GOOD_IDEN_NUMB,
                    vendorId:"<%=vendorId%>"
                },
                function(arg){
                    var resultMap = eval('(' + arg + ')').resultMap;
                    var optList = resultMap.commonOptList;
                    var commonOptHtml = "";
                    var optCnt = 0;

                    if(optList.length > 0 && $.trim(optList[0].OPTION_NAME) != ''){
                        commonOptHtml+="<colgroup>";
                        commonOptHtml+="	<col width='100px'/>";
                        commonOptHtml+="	<col width='auto'/>";
                        commonOptHtml+="	<col width='100px'/>";
                        commonOptHtml+="	<col width='auto'/>";
                        commonOptHtml+="</colgroup>";
                        for(var i = 0 ; i < optList.length ; i++){
                            if($.trim(optList[i].OPTION_NAME) != ''){
                                var optValues = $.trim(optList[i].OPTION_VALUE).split(";");
                                commonOptHtml+="<tr>";
                                commonOptHtml+="	<th>" + $.trim(optList[i].OPTION_NAME) + "</th>";
                                commonOptHtml+="	<td>";
                                commonOptHtml+="		<select name='commonOptPop_"+optCnt+"' id='commonOptPop_"+optCnt+"' style='width:200px;''>";
                                commonOptHtml+="			<option value=''>선택</option>";
                                for(var j = 0 ; j < optValues.length ; j++){
                                    commonOptHtml+="		<option value='"+optValues[j]+"'>"+optValues[j]+"</option>";
                                }
                                commonOptHtml+="		</select>";
                                commonOptHtml+="	</td>";
                                commonOptHtml+="</tr>";
                                optCnt++;
                            }
                        }
                        commonOptHtml+="		<tr style='display:none;'>";
                        commonOptHtml+="			<td>";
                        commonOptHtml+="				<input type='text' id='commonOptCntPop' name='commonOptCntPop' value='"+optCnt+"'/>";
                        commonOptHtml+="			</td>";
                        commonOptHtml+="		</tr>";
                    }
                    $("#repreGoodNumbPop").val(pdtMstData.GOOD_IDEN_NUMB);
                    $("#commonDetailOptTablePop").html(commonOptHtml);
                    $("#optionDetailPop").jqmShow();
                }
            );	
		}else{
			var cnt = $("[name=cartChk]").length;
	        var pdtInfo = pdtMstData.info[0];
	        var htmlStr = "";
	 		htmlStr += "<tr class=\"reverseOrdProd\" id=\"reverseOrdProd_"+cnt+"\">";
	 		htmlStr += "	<td align=\"center\" class=\"br_l0\">";
	 		htmlStr += "		<input id=\"cartChk_"+cnt+"\" name=\"cartChk\" type=\"checkbox\" value=\""+cnt+"\" class=\"cartCheck\" onclick=\"javascript:fnCartCheck();\">";
	 		htmlStr += "	</td>";
	 		htmlStr += "	<td> <div class=\"label\" >";
	        if(pdtMstData.REPRE_GOOD == 'Y' || pdtMstData.REPRE_GOOD == "P") {
	        	
	 		htmlStr += "		<span class=\"option\" style=\"cursor: text;\">옵션</span>";
	 		
	        }
	        if(pdtMstData.GOOD_TYPE == '20') {
	        	
	 		htmlStr += "		<span class=\"appoint\" style=\"cursor: text;\">지정</span>";
	 		
	        }
	 		htmlStr += "		</div> <dl>                                                                                                                                       ";
	        htmlStr += "			<dt><img src=\"/upload/image/"+pdtInfo.IMG_PATH+"\" onerror=\"this.src = '/img/layout/img_null.jpg'\" width=\"100px;\" height=\"100px;\"></dt>";
	 		htmlStr += "			<dd>";
	 		htmlStr += "					<p> ";
	 		htmlStr += pdtMstData.GOOD_NAME
	 		htmlStr += "					</p>                                                                                                                                                                                                                                                                                                  ";
	 		htmlStr += "				<ul>                                                                                                                                                                                                                                                                                                      ";
	 		var caseGoodIdenNumb = pdtInfo.GOOD_IDEN_NUMB;
	 		if(pdtInfo.REPRE_GOOD_IDEN_NUMB != null && pdtInfo.REPRE_GOOD_IDEN_NUMB != ""){
	 			caseGoodIdenNumb = pdtInfo.REPRE_GOOD_IDEN_NUMB;
	 		}
	 		htmlStr += "					<li>상품코드&nbsp;&nbsp; : <strong>"+caseGoodIdenNumb+"</strong></li>                                                                                                                                                                                                                                             ";
	 		htmlStr += "					<li>규격&nbsp;&nbsp;&nbsp;&nbsp; : <strong>"+pdtMstData.GOOD_SPEC+"</strong></li>                                                                                                                                                                                                                                             ";
	 		htmlStr += "				</ul>                                                                                                                                                                                                                                                                                                     ";
	 		htmlStr += "			</dd>                                                                                                                                                                                                                                                                                                         ";
	 		htmlStr += "		</dl>                                                                                                                                                                                                                                                                                                             ";
	 		htmlStr += "	</td>                                                                                                                                                                                                                                                                                                                 ";
	 		htmlStr += "	<td class=\"count\">                                                                                                                                                                                                                                                                                                    ";
	 		htmlStr += "		<p>"+fnComma(pdtInfo.SALE_UNIT_PRIC)+"</p>                                                                                                                                                                                                                                                                                                        ";
            if(pdtMstData.REPRE_GOOD == "P"){

	 		htmlStr += "		<p><input id=\"ordQuan_"+cnt+"\" name=\"ordQuan_"+cnt+"\" type=\"text\" style=\"width:50px; text-align: right;\" value=\""+  pdtMstData.OPT_ORD_QUAN +"\" onkeydown=\"return onlyNumber(event)\" maxlength=\"9\" onkeyup=\"javascript:fnSetOrdQuan('"+cnt+"');\"></p>";
	 		
            }else{
            	
	 		htmlStr += "		<p><input id=\"ordQuan_"+cnt+"\" name=\"ordQuan_"+cnt+"\" type=\"text\" style=\"width:50px; text-align: right;\" value=\""+Number($("#pdtOrdRequQuan_"+index).val())+"\" onkeydown=\"return onlyNumber(event)\" maxlength=\"9\" onkeyup=\"javascript:fnSetOrdQuan('"+cnt+"');\"></p>";
	 		
            }
	 		htmlStr += "		<input id=\"sellPrice_"+cnt+"\" name=\"sellPrice_"+cnt+"\" type=\"hidden\" value=\""+Math.round(pdtInfo.SELL_PRICE)+"\"/>";
	 		htmlStr += "		<input id=\"saleUnitPrice_"+cnt+"\" name=\"saleUnitPrice_"+cnt+"\" type=\"hidden\" value=\""+pdtInfo.SALE_UNIT_PRIC+"\"/>";
	 		var tempSaleUnitPric = 0;
            if(pdtMstData.REPRE_GOOD == "P"){

	        tempSaleUnitPric = Number(pdtMstData.OPT_ORD_QUAN)*Number(pdtInfo.SALE_UNIT_PRIC);
	        
            }else{
            	
	        tempSaleUnitPric = Number($("#pdtOrdRequQuan_"+index).val())*Number(pdtInfo.SALE_UNIT_PRIC);
	        
            }
	 		htmlStr += "		<input id=\"ordPrice_"+cnt+"\" name=\"ordPrice_"+cnt+"\" type=\"hidden\" value=\""+tempSaleUnitPric+"\"/>";
	 		htmlStr += "		<input id=\"goodIdenNumb_"+cnt+"\" name=\"goodIdenNumb_"+cnt+"\" type=\"hidden\" value=\""+pdtMstData.GOOD_IDEN_NUMB+"\"/>";
	 		htmlStr += "		<input id=\"goodName_"+cnt+"\" name=\"goodName_"+cnt+"\" type=\"hidden\" value=\""+pdtMstData.GOOD_NAME+"\"/>";
	 		var repreGoodIdenNumbTemp = pdtMstData.REPRE_GOOD_IDEN_NUMB;
			if( typeof pdtMstData.REPRE_GOOD_IDEN_NUMB == "undefined"){repreGoodIdenNumbTemp = "";}
	 		htmlStr += "		<input id=\"repreGoodNumb_"+cnt+"\" name=\"repreGoodNumb_"+cnt+"\" type=\"hidden\" value=\""+repreGoodIdenNumbTemp+"\"/>";
	 		htmlStr += "		<input id=\"goodSpec_"+cnt+"\" name=\"goodSpec_"+cnt+"\" type=\"hidden\" value=\""+pdtMstData.GOOD_SPEC+"\"/>";
	 		htmlStr += "	</td>";
	 		htmlStr += "	<td class=\"count\" id=\"ordPriceTxt_"+cnt+"\">                                                                                                                                                                                                                                                                                 ";
	 		htmlStr += fnComma(tempSaleUnitPric);
	 		htmlStr += "	</td>                                                                                                                                                                                                                                                                                                                 ";
	 		htmlStr += "	<td align=\"center\">                                                                                                                                                                                                                                                                                                 ";
			htmlStr += "		<p><input id=\"exDatePicker_"+cnt+"\" name=\"exDatePicker_"+cnt+"\" type=\"text\" style=\"width:70px;\" readonly=\"readonly\" value=\""+pdtMstData.DELI_DATE+"\"/></p>";  
	 		htmlStr += "		<p>("+pdtMstData.DELI_DATE+", "+pdtMstData.DELI_MINI_DAY+"일)</p>                                                                                                                                                                                                                                                                                           ";
	 		htmlStr += "	</td>                      ";
	 		htmlStr += "	<td align=\"center\"> ";
	 		htmlStr += "		<button id=\"orderButton\" class=\"btn btn-danger btn-sm\" style=\"\" onclick=\"javascript:fnOneOrder('"+cnt+"');\">주문</button>";
	 		htmlStr += "	</td>";
	 		htmlStr += "</tr>  ";
			$("#reverseOrdProdList").append(htmlStr);
			$("#exDatePicker_"+cnt).datepicker( {
				showOn: "button",
				buttonImage: "/img/contents/btn_calenda.gif",
				buttonImageOnly: true,
				dateFormat: "yy-mm-dd",
				minDate:0
			});
			$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); 
			$("#cartChk_"+cnt).prop("checked", true);
        	fnCartSummary();
		}
	}else{
		alert("상품정보를 확인하여 주십시오.");
		return false;
	}
}

function fnSetOrdQuan(idx){
	var ordQuan  = Number($("#ordQuan_"+idx).val() == '' ? 0 : $("#ordQuan_"+idx).val());
	var sellPric = Math.round(Number($("#saleUnitPrice_"+idx).val()));
	var ordPric  = ordQuan * sellPric;
	$("#ordPrice_"+idx).val(ordPric);
	$("#ordPriceTxt_"+idx).html(fnComma(ordPric));
	fnCartSummary();
}

function fnSetCheckAll(){
	if($('#cartCheckAll').prop('checked')){
		$('#cartCheckAll').prop('checked', false);
	}else{
		$('#cartCheckAll').prop('checked', true);
	}
	fnCheckAll();
}

function fnCheckAll(){
	if($("#cartCheckAll").prop("checked")){
		$(".cartCheck").prop("checked", true);
	}else{
		$(".cartCheck").prop("checked", false);
	}
	fnCartSummary();
}

function fnCartCheck(){
	fnCartSummary();
}

function fnCartSummary(){
	var ordPric = 0;
	var ordQuan = 0;
	var cartSize = $("[name=cartChk]").length; 
	for(var i = 0; i < cartSize; i++){
		var isCheck = false;
		if($("#cartChk_" + i).prop("checked") != undefined){
			isCheck = $("#cartChk_" + i).prop("checked");
		}else{
			isCheck = $("#cartChk_" + (i-1)).prop("checked");
		}
		if(isCheck){
            ordQuan  = Number($("#ordQuan_"+i).val() == '' ? 0 : $("#ordQuan_"+i).val());
			ordPric += Number($("#saleUnitPrice_"+i).val()) * ordQuan;
		}
	}
	
	$("#sumPrice").html("<strong class='f18'>"+fnComma(Math.round(ordPric))+"</strong> 원");
	$("#taxPrice").html("<strong class='f18'>"+fnComma(Math.round((Math.round(ordPric))*0.1))+"</strong> 원");
	$("#totPrice").html("<strong class='f18'>"+fnComma((Math.round(ordPric)) + Math.round((Math.round(ordPric))*0.1))+"</strong> 원");
	
}

function fnSelectedPdtDelete(){
    if(!confirm("선택 상품을 삭제하시겠습니까?")){return false;}
	var rowCnt = $("[name=cartChk]").length;
    if(rowCnt>0) {
    	var delTargetArr = [];
        for(var i=0; i<rowCnt; i++) {
            if( $("#"+$("[name=cartChk]")[i].id).is(':checked') == true){
				delTargetArr[delTargetArr.length] = $("#"+$("[name=cartChk]")[i].id).val();
            }
        }
        if(delTargetArr.length > 0){
            for(var i =0; i < delTargetArr.length; i++){
            	$("#reverseOrdProd_"+delTargetArr[i]).remove();
            }
        }
    }
	fnCartSummary();
}
</script>

<script type="text/javascript">
//옵션 그리드
$("#pdtDetailPoplist").jqGrid({
	url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
	multiselect:true,
	datatype: "json",
	mtype:'POST',
	colNames:['GOOD_IDEN_NUMB','VENDORID','규격', '단가', '재고', '수량'],
	colModel:[
		{name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB',width:200,align:"left",search:false,sortable:true,editable:false, hidden:true },//상품ID
		{name:'VENDORID',index:'VENDORID',width:200,align:"left",search:false,sortable:true,editable:false, hidden:true },//공급사ID
		{name:'GOOD_SPEC',index:'GOOD_SPEC',width:200,align:"left",search:false,sortable:true,editable:false },//규격
		{name:'SALE_UNIT_PRIC',index:'SALE_UNIT_PRIC',width:120,align:"right",search:false,sortable:false,
			editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
		},//단가			
		{name:'GOOD_INVENTORY_CNT',index:'GOOD_INVENTORY_CNT',width:80,align:"right",search:false,sortable:false,
			editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
		},//수량	
		{name:'SET_QTY', index:'SET_QTY',width:85,align:"center",search:false,sortable:false,editable:false }//수량
	],
	postData: {},
	rowNum:0,rownumbers:false,rowList:[30,50,100,500],
	height:250,width:550,
	sortname:'good_Name',sortorder:'Desc',
	viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
	loadComplete:function() {
		FnUpdatePagerIcons(this);
		var rowCnt = $("#pdtDetailPoplist").getGridParam('reccount');
		if(rowCnt>0) {
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#pdtDetailPoplist").getDataIDs()[i];
				var selrowContent = $("#pdtDetailPoplist").jqGrid('getRowData',rowid);
				var descStr  = "<input type='text' id='setQtyPop_"+rowid+"' name='setQtyPop_"+rowid+"' size='6' maxlength=9 onkeydown='return onlyNumberPop(event)' style='text-align:right;' value=''/>";
				$("#pdtDetailPoplist").jqGrid('setRowData', rowid, {SET_QTY:descStr});
			}
		} 
	},
	ondblClickRow:function(rowid,iRow,iCol,e) {},
	onCellSelect:function(rowid,iCol,cellcontent,target) {},
	afterInsertRow: function(rowid, aData){},
	loadError:function(xhr,st,str) { $("#pdtDetailPoplist").html(xhr.responseText); },
	jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
});

function onlyNumberPop(event) {
	var key = window.event ? event.keyCode : event.which;
	if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
	|| key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
	|| key  == 8  || key  == 46 || key  == 9) // del, back space, Tab
	) {
		return true;
	}else {
		$("#ordQuanPop").focusout();
		$("#ordQuanPop").val("");
	    return false;
	}    
};
</script>
<script type="text/javascript">
function fnAllOrder(){
	$("#cartCheckAll").prop("checked", true);
	fnCheckAll();
	
	var tmpBranchId = $.trim($("#branchId").val());
	var tmpOrdeUserId = $.trim($("#orde_userId").val());
	var tmpTranUserName = $.trim($("#tran_user_name").val());
	var tmpTranTeleNumb = $.trim($("#tran_tele_numb").val());
	var tmpTranDetaAddrSeq = $.trim($("#tran_deta_addr_seq").val());
	if(tmpBranchId == ""){
		alert("구매사를 선택해 주십시오.");
		return false;
	}
	if(tmpOrdeUserId == ""){
		alert("주문자를 선택해 주십시오.");
		return false;
	}
	if(tmpTranUserName == ""){
		alert("인수자를 선택해 주십시오.");
		return false;
	}
	if(tmpTranTeleNumb == ""){
		alert("인수자 전화번호를 선택해 주십시오.");
		return false;
	}
	if(tmpTranDetaAddrSeq == ""){
		alert("배송지 주소를 선택해 주십시오.");
		return false;
	}
	var rtnMsg = "";
	for(var idx = 0; idx < $("[name=cartChk]").length; idx++){
		var isCheck = false;
		if($("#cartChk_" + idx).prop("checked") != undefined){
			isCheck = $("#cartChk_" + idx).prop("checked");
		}else{
			isCheck = $("#cartChk_" + (idx-1)).prop("checked");
		}
		if(isCheck){
			if(Number($.trim($("#ordQuan_" + idx).val())) < 1){
                rtnMsg = $.trim($("#goodName_" + idx).val())+" 상품의 주문수량을 확인해주십시오.";
			}
		}
	}
	if(rtnMsg != ""){
		alert(rtnMsg);
		return false;
	}
	
	
	
	
	
	var rowCnt = $("input[name=cartChk]:checkbox:checked").length;
	if(rowCnt ==0){
		alert("주문 할 상품을 선택해 주십시오.");
		return false;
	}
	if(!confirm("전체 상품을 주문하시겠습니까?"))return;
	fnOrder();
}

function fnSelOrder(){
	var tmpBranchId = $.trim($("#branchId").val());
	var tmpOrdeUserId = $.trim($("#orde_userId").val());
	var tmpTranUserName = $.trim($("#tran_user_name").val());
	var tmpTranTeleNumb = $.trim($("#tran_tele_numb").val());
	var tmpTranDetaAddrSeq = $.trim($("#tran_deta_addr_seq").val());
	if(tmpBranchId == ""){
		alert("구매사를 선택해 주십시오.");
		return false;
	}
	if(tmpOrdeUserId == ""){
		alert("주문자를 선택해 주십시오.");
		return false;
	}
	if(tmpTranUserName == ""){
		alert("인수자를 선택해 주십시오.");
		return false;
	}
	if(tmpTranTeleNumb == ""){
		alert("인수자 전화번호를 선택해 주십시오.");
		return false;
	}
	if(tmpTranDetaAddrSeq == ""){
		alert("배송지 주소를 선택해 주십시오.");
		return false;
	}
	var chkCnt  = 0;
	var rtnMsg = "";
	for(var idx = 0; idx < $("[name=cartChk]").length; idx++){
		var isCheck = false;
		if($("#cartChk_" + idx).prop("checked") != undefined){
			isCheck = $("#cartChk_" + idx).prop("checked");
		}else{
			isCheck = $("#cartChk_" + (idx-1)).prop("checked");
		}
		if(isCheck){
			if(Number($.trim($("#ordQuan_" + idx).val())) < 1){
                rtnMsg = $.trim($("#goodName_" + idx).val())+" 상품의 주문수량을 확인해주십시오.";
			}
		}
	}
	if(rtnMsg != ""){
		alert(rtnMsg);
		return false;
	}
	var rowCnt = $("input[name=cartChk]:checkbox:checked").length;
	if(rowCnt ==0){
		alert("주문 할 상품을 선택해 주십시오.");
		return false;
	}
	if(!confirm("선택하신 상품을 주문하시겠습니까?"))return;
	fnOrder();
}

function fnOneOrder(idx){
	$("#cartCheckAll").prop("checked", false);
	fnCheckAll();
	$("#cartChk_"+idx).prop("checked", true);
	fnCartSummary();	
	
	var tmpBranchId = $.trim($("#branchId").val());
	var tmpOrdeUserId = $.trim($("#orde_userId").val());
	var tmpTranUserName = $.trim($("#tran_user_name").val());
	var tmpTranTeleNumb = $.trim($("#tran_tele_numb").val());
	var tmpTranDetaAddrSeq = $.trim($("#tran_deta_addr_seq").val());
	if(tmpBranchId == ""){
		alert("구매사를 선택해 주십시오.");
		return false;
	}
	if(tmpOrdeUserId == ""){
		alert("주문자를 선택해 주십시오.");
		return false;
	}
	if(tmpTranUserName == ""){
		alert("인수자를 선택해 주십시오.");
		return false;
	}
	if(tmpTranTeleNumb == ""){
		alert("인수자 전화번호를 선택해 주십시오.");
		return false;
	}
	if(tmpTranDetaAddrSeq == ""){
		alert("배송지 주소를 선택해 주십시오.");
		return false;
	}
	var rowCnt = $("input[name=cartChk]:checkbox:checked").length;
	if(rowCnt ==0){
		alert("주문 할 상품을 선택해 주십시오.");
		return false;
	}
	var chkCnt  = 0;
	var rtnMsg = "";
    if(Number($.trim($("#ordQuan_" + idx).val())) < 1){
        rtnMsg = $.trim($("#goodName_" + idx).val())+" 상품의 주문수량을 확인해주십시오.";
    }
	if(rtnMsg != ""){
		alert(rtnMsg);
		return false;
	}
	
	if(!confirm("해당 상품을 주문하시겠습니까?"))return;
	fnOrder();
}

function fnOrder(){
	$.blockUI();
	var ord_quans 			= new Array();
	var vendorids 			= new Array();
	var good_iden_numbs		= new Array();
	var orde_requ_prics		= new Array();
	var sale_unit_prices	= new Array();
	var requ_deli_dates		= new Array();
	var good_names			= new Array();
	var good_specs			= new Array();
	var add_good_numbs		= new Array();
	var repre_good_numbs	= new Array();

	var cons_iden_name  = $("#cons_iden_name").val();                    // 공사명
	var orde_type_clas  = "40";                                          // 주문유형
	var orde_tele_numb  = $("#orde_tele_numb").val();                    // 주문자 전화번호
	var orde_user_id    = $("#orde_userId").val();                      // 주문자 ID
	var tran_data_addr  = $("#tran_deta_addr_seq").val();                // 배송지주소
	var tran_user_name  = $("#tran_user_name").val();                    // 인수자
	var tran_tele_numb  = $("#tran_tele_numb").val();                    // 인수자 전화번호
	var adde_text_desc  = $("#orde_text_desc").val();                    // 비고
	var mana_user_id  	= $("#mana_user_id").val();                      // 감독명 
	var attach_file_1   = $("#firstattachseq").val();                    // 첨부파일1
	var attach_file_2   = $("#secondattachseq").val();                   // 첨부파일2
	var attach_file_3   = $("#thirdattachseq").val();                    // 첨부파일3	
	
	var chkCnt  = 0;
	var cartSize = $("[name=cartChk]").length; 
	for(var idx = 0; idx < cartSize; idx++){
		var isCheck = false;
		if($("#cartChk_" + idx).prop("checked") != undefined){
			isCheck = $("#cartChk_" + idx).prop("checked");
		}else{
			isCheck = $("#cartChk_" + (idx-1)).prop("checked");
		}
		if(isCheck){
			ord_quans[chkCnt] 	 	= $.trim($("#ordQuan_" + idx).val()); 
			vendorids[chkCnt] 	 	= "<%=vendorId%>";
			good_iden_numbs[chkCnt] = $.trim($("#goodIdenNumb_" + idx).val());
			orde_requ_prics[chkCnt]	= $.trim($("#sellPrice_" + idx).val());
			sale_unit_prices[chkCnt]= $.trim($("#saleUnitPrice_" + idx).val());
			requ_deli_dates[chkCnt]	= $.trim($("#exDatePicker_" + idx).val());
			good_names[chkCnt]		= $.trim($("#goodName_" + idx).val());
			good_specs[chkCnt]		= $.trim($("#goodSpec_" + idx).val());
			add_good_numbs[chkCnt]	= $.trim($("#addGoodNumb_" + idx).val());
			repre_good_numbs[chkCnt]= $.trim($("#repreGoodNumb_" + idx).val());
			chkCnt++;
		}
	}
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/venOrder/setOrderCartInfo.sys',
		{
			ord_quans 			:ord_quans,
			vendorids 			:vendorids,
			branchid:$.trim($("#branchId").val()),
			good_iden_numbs		:good_iden_numbs,	
			orde_requ_prics		:orde_requ_prics,	
			sale_unit_prices	:sale_unit_prices,	
			requ_deli_dates		:requ_deli_dates,	
			good_names			:good_names,		
			good_specs			:good_specs,		
			add_good_numbs		:add_good_numbs,	
			repre_good_numbs	:repre_good_numbs,
			cons_iden_name  	:cons_iden_name, 
			orde_type_clas  	:orde_type_clas, 
			orde_tele_numb  	:orde_tele_numb, 
			orde_user_id    	:orde_user_id, 
			tran_data_addr  	:tran_data_addr, 
			tran_user_name  	:tran_user_name, 
			tran_tele_numb  	:tran_tele_numb, 
			adde_text_desc  	:adde_text_desc, 
			mana_user_id  		:mana_user_id, 
			attach_file_1   	:attach_file_1, 
			attach_file_2   	:attach_file_2, 
			attach_file_3   	:attach_file_3   
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if(result.success){
				alert("주문이 완료되었습니다.");
				fnDynamicForm("<%=Constances.SYSTEM_CONTEXT_PATH %>/venOrder/venOrderRequest.sys", "","");				
			}else{
				alert(result.message);
			}
			$.unblockUI();
		}
	);	
}
</script>

<%
/**------------------------------------배송지관리팝업 사용방법---------------------------------
* fnDeliveryAddressManageDialog(groupId, clientId, branchId, callbackString) 을 호출하여 Div팝업을 Display ===
* groupId : 고객사 그룹Id
* clientId : 고객사 법인Id
* branchId : 고객사 사업장Id
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 2개(우편번호, 주소) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/deliveryAddressManageDiv.jsp" %>
<!-- 배송지관리팝업 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
    $("#btnAddDeliveryAddress").click(function(){
    	var branchId = $("#branchId").val();
    	if( ! branchId ){
    		alert("구매사를 선택 후 이용하시기 바랍니다.");
    		return;
    	}
        fnDeliveryAddressManageDialog("","",branchId,"fnCallBackDeliveryAddressManage"); 
    });
    
});

/**
 * 배송지관리팝업검색 후 선택한 값 세팅
 */
function fnCallBackDeliveryAddressManage(deliId) {
	if(deliId != undefined){
		fnSelectBoxAddressInfo(deliId);
	}else{
		fnGetBuyAddressInfo(deliId);
	}
}
function fnSelectBoxAddressInfo(deliId) {
    $("#tran_deta_addr_seq").val(deliId);
}
</script>
<% //------------------------------------------------------------------------------ %>
</html> 