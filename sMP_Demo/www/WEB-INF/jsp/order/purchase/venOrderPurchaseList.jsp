<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>

<%
	@SuppressWarnings("unchecked")
	List<CodesDto> orderStatusCodeList = (List<CodesDto>)request.getAttribute("orderStatusCodeList");

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	//주문접수 날짜 세팅
	String startDate = CommonUtils.getCustomDay("MONTH", -1);
	String endDate   = CommonUtils.getCurrentDate();
	String menuId    = CommonUtils.getRequestMenuId(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.popOrderReject {
	display: none;
	position: fixed;
	top: 17%;
	left: 50%;
	margin-left: -300px;
	width: 530px;
	background-color: #EEE;
	color: #333;
}
</style>

<script type="text/javascript">
$(document).ready(function() {
	$("#divGnb").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#divGnb").mouseout(function () {
		$("#snb_vdr").hide();
	});
	$("#snb_vdr").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#snb_vdr").mouseout(function () {
		$("#snb_vdr").hide();
	});
	$("#ordRejectPop").jqm();
	$('#ordRejectPop').jqm().jqDrag('#divPopupTitle'); 
	
	$("#purcStatFlag").val("40");
	$("#purcStatFlag").attr("disabled", true);
	
	
	
	<%-- 날짜 데이터 초기화--%> 	
	fnDateInit();
	<%-- 주문접수 리스트--%>
	fnOrderPurchaseList();
	
	<%-- 엔터키이벤트 --%>
	$("#orderNumber").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#startDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#endDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	
	$("#allExcelButton").click(function(){ fnAllExcelPrintDown();});
	$('#deliScheDateAllPop').jqm().jqDrag('#deliScheDateAllDrag');
});

<%-- 날짜 데이터 초기화--%> 
function fnDateInit() {
	$("#startDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#endDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#deliScheDateAll").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}

<%-- 주문접수 엑셀일괄다운--%>
function fnAllExcelPrintDown(){
	
	var colLabels = ['주문일', '납품요청일', '주문유형', '주문번호', '구매사', 
						'주문자명',  '상품명', '규격', '주문수량', '단가', 
						'납품예정일', '주문총액',  '기타요청사항', '인수자', '인수자연락처', '인수자주소', '기타요청사항', '추가구성정보'];
		var colIds = ['REGI_DATE_TIME', 'REQU_DELI_DATE', 'ORDE_TYPE_NM', 'ORDE_NUMB', 'BRANCHNM',
						'ORDE_USER_NM',  'GOOD_NAME', 'GOOD_SPEC', 'PURC_REQU_QUAN', 'SALE_UNIT_PRIC', 
						'REQU_DELI_DATE',  'TOTA_ORDE_PRIC', 'ADDE_TEXT_DESC','TRAN_USER_NAME','TRAN_TELE_NUMB','TRAN_DATA_ADDR','ADDE_TEXT_DESC','ADD_PROD'];	//출력컬럼ID
		var numColIds = ['PURC_REQU_QUAN', 'SALE_UNIT_PRIC', 'TOTA_ORDE_PRIC'];	//숫자표현ID
		var sheetTitle = "주문접수 정보조회";	//sheet 타이틀
		var excelFileName = "orderPurchaseList";	//file 명
	
		var fieldSearchParamArray = new Array();     //파라메타 변수ID
		fieldSearchParamArray[0] = 'startDate';
		fieldSearchParamArray[1] = 'endDate';
		fieldSearchParamArray[2] = 'purcStatFlag';
		fieldSearchParamArray[3] = 'orderNumber';
		
		fnExportExcelToSvc( "" , colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/venOrder/orderPurchaseExcelList.sys");
}

function fnOrderPurchaseListCallbackList(list, records){
	var listLength = 0;
	var i          = 0;
	var str        = "";
	var listInfo   = null;
	
	if(records > 0){
		listLength = list.length;
		
		for(i = 0; i < listLength; i++){
			listInfo = list[i];
			
			var ordeIdenNumb     = listInfo.ORDE_IDEN_NUMB;
			var ordeSequNumb     = listInfo.ORDE_SEQU_NUMB;
			var purcIdenNumb     = listInfo.PURC_IDEN_NUMB;
			var addRepreSequNumb = listInfo.ADD_REPRE_SEQU_NUMB; 
			var mstAddRepreSequNumb = listInfo.MST_ADD_REPRE_SEQU_NUMB; 
			var regiDateTime     = listInfo.REGI_DATE_TIME;
			var requDeliDate     = listInfo.REQU_DELI_DATE;
			var ordeTypeNm       = listInfo.ORDE_TYPE_NM;
			var branchNm         = listInfo.BRANCHNM;
			var ordeUserNm       = listInfo.ORDE_USER_NM;
			var goodIdenNumb     = listInfo.GOOD_IDEN_NUMB;
			var goodName         = listInfo.GOOD_NAME;
			var goodSpec         = listInfo.GOOD_SPEC;
			var purcRequQuan     = listInfo.PURC_REQU_QUAN;
			var saleUnitPric     = listInfo.SALE_UNIT_PRIC;
			var totaOrdePric     = listInfo.TOTA_ORDE_PRIC;
			var deliScheDate     = listInfo.DELI_SCHE_DATE;
			var addeTextDesc     = listInfo.ADDE_TEXT_DESC;
			var addProdPrefix    = listInfo.ADD_PROD_PREFIX;
			var addProdVendorNmd = listInfo.ADD_PROD_VENDORNMD;
			
			purcRequQuan = fnComma(purcRequQuan);
			saleUnitPric = fnComma(saleUnitPric);
			totaOrdePric = fnComma(totaOrdePric);

			str +=	"<tr id='orderPurchase_" + i + "' class='orderPurchase'>";
			str +=		"<td align='center' class='br_l0'>";
			str +=			"<input type='hidden'   id='ordeIdenNumb_" + i + "'        name='ordeIdenNumb_'        value='" + ordeIdenNumb + "'>";
			str +=			"<input type='hidden'   id='ordeSequNumb_" + i + "'        name='ordeSequNumb_'        value='" + ordeSequNumb + "'>";
			str +=			"<input type='hidden'   id='purcIdenNumb_" + i + "'        name='purcIdenNumb_'        value='" + purcIdenNumb + "'>";
			str +=			"<input type='hidden'   id='add_repre_sequ_numb_" + i + "' name='add_repre_sequ_numb_' value='" + addRepreSequNumb + "'>";
			str +=			"<input type='hidden'   id='mstAddRepreSequNumb_" + i + "' name='mstAddRepreSequNumb_' value='" + mstAddRepreSequNumb + "'>";
			str +=			"<input type='checkbox' id='ordPurcChk_" + i + "''         name='ordPurcChk'           class='ordPurcChk' onclick='javascript:fnOrdPurcChk();'/>";
			str +=		"</td>";
			str +=		"<td align='center'>";
			str +=			"<p>";
			str +=				"<span class='col02' style='font-weight:800;' >";
			str +=					regiDateTime;
			str +=				"</span>";
			str +=			"</p>";
			str +=			"(<span class='col02' >";
			str +=				requDeliDate ;
			str +=			"</span>)";
			str +=		"</td>";
			str +=		"<td align='center'>";
			str +=			ordeTypeNm;
			
			if(addRepreSequNumb != "0"){
				str +=		"<br/>";
				str +=		"<button class='btn btn-darkgray btn-xs' onclick='javascript:fnVenProductDetail(\"" + i + "\");' <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>";
				str +=			"추가";
				str +=		"</button>";
			}
			if(mstAddRepreSequNumb != "0"){
				str +=		"<br/>";
				str +=		"<button class='btn btn-darkgray btn-xs' onclick='javascript:fnVenMstProductDetail(\"" + i + "\");' <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>";
				str +=			"추가";
				str +=		"</button>";
			}
			
			str +=		"</td>";
			str +=		"<td>";
			str +=			"<p>";
			str +=				"<a href=\"javascript:fnOrderDetailView('" + ordeIdenNumb + "-" + ordeSequNumb + "', '', '')\">";
			str +=					ordeIdenNumb + "-" + ordeSequNumb;
			str +=				"</a>";
			str +=				"<BR/>";
			str +=				branchNm;
			str +=			"</p>";
			str +=		"</td>";
			str +=		"<td align='center'>";
			str +=			ordeUserNm;
			str +=		"</td>";
			str +=		"<td>";
			str +=			"<p>";
			str +=				"<a href='javascript:fnPdtSimpleDetailPop(\"" + goodIdenNumb + "\");'>";
			str +=					goodName;
			str +=				"</a>";
			str +=			"</p>";
			str +=			"<div class='f11'>";
			str +=				"<p>";
			str +=					"<strong>";
			str +=						"규격";
			str +=					"</strong>";
			str +=					" : " + goodSpec;
			str +=				"</p>";
			str +=			"</div>";
			str +=		"</td>";
			str +=		"<td align='right'>";
			str +=			"<span style='font-weight:800;'>";
			str +=				purcRequQuan;
			str +=			"</span>";
			str +=			"<br/>";
			str +=			"(" + saleUnitPric + ")";
			str +=		"</td>";
			str +=		"<td align='right'  style='background-color: #f9f1ee'>";
			str +=			"<input type=\"text\" id=\"deliScheDate" + i + "\" style=\"width:80px;color:red;font-weight:800;\" value=\"" + deliScheDate + "\" />";
			str +=			"<script type=\"text/javascript\">";
			str +=				"$(\"#deliScheDate" + i + "\").datepicker({";
			str +=					"showOn: \"button\",";
			str +=					"buttonImage: \"/img/contents/btn_calenda.gif\",";
			str +=					"buttonImageOnly: true,";
			str +=					"dateFormat: \"yy-mm-dd\"";
			str +=				"});";
			str +=			"<\/script>";
			str +=		"</td>";
			str +=		"<td align='right'>";
			str +=			totaOrdePric;
			str +=		"</td>";
			str +=		"<td>";
			str +=			addeTextDesc;
			
			if(addProdPrefix != ""){
				str +=		"<br/>";
				str +=		"<font color='red'>";
				str +=			"<b>";
				str +=				addProdPrefix + addProdVendorNmd;
				str +=			"</b>";
				str +=		"</font>";
			}
			
			str +=		"</td>";
			str +=	"</tr>";
		}
	}
	else{
		str +=	"<tr id='orderPurchase_0' class='orderPurchase'>";
		str +=		"<td colspan='10' align='center' class='br_l0'>";
		str +=			"Data가 존재 하지 않습니다.";
		str +=		"</td>";
		str +=	"</tr>";
	}
	
	$("#orderPurchaseTable").append(str);
}

function fnOrderPurchaseListCallbackPage(currPage, total, records){
	var pageGrp   = null;
	var startPage = 0;
	var endPage   = 0;
	
	if(records > 0){
		pageGrp   = fnPagerInfo(currPage, total, 5);
		startPage = pageGrp.startPage;
		endPage   = pageGrp.endPage;
		
		fnPager(startPage, endPage, currPage, total, "fnOrderPurchaseList");
	}
}

function fnOrderPurchaseListCallback(arg){
	var list	 = arg.list;
	var currPage = arg.page;
	var total	 = arg.total;
	var records	 = arg.records;
	
	fnOrderPurchaseListCallbackList(list, records);
	fnOrderPurchaseListCallbackPage(currPage, total, records);
	$.unblockUI();
}

<%-- 주문접수 리스트--%>
function fnOrderPurchaseList(page){
	var startDate	 = $("#startDate").val();
	var endDate		 = $("#endDate").val();
	var purcStatFlag = $("#purcStatFlag").val();
	var orderNumber	 = $("#orderNumber").val();
	
	$.blockUI();
	$(".orderPurchase").remove();
	$("#pager").empty();
	
	$.post(
		"/venOrder/orderPurchaseList.sys",
		{
			startDate    : startDate,
			endDate      : endDate,
			purcStatFlag : purcStatFlag,
			orderNumber  : orderNumber,
			page         : page,
			rows         : 10
		},
		function(arg){
			fnOrderPurchaseListCallback(arg);
		},
		"json"
	);
}



<%-- 전체 체크 이벤트 --%>
function fnOrdPurcAllChk(){
	var ordPurcAllChk = $("#ordPurcAllChk").prop("checked");
	if(ordPurcAllChk == true){
		$("input[name=ordPurcChk]").prop("checked", true);
	}else{
		$("input[name=ordPurcChk]").prop("checked", false);
	}
	
}

<%-- 체크 이벤트 --%>
function fnOrdPurcChk(){
	var ordPurcChk = $("input[name=ordPurcChk]:checkbox:checked").length;
	if(ordPurcChk == 0){
		$("#ordPurcAllChk").prop("checked", false);
	}
}

<%-- 주문접수 --%>
function fnOrdPurcReceive(){
	var ordPurcChkCnt = $("input[name=ordPurcChk]:checkbox:checked").length; //체크된 갯수
	
	if(ordPurcChkCnt == 0){//체크된 갯수가 0이면 경고창
		alert("주문접수 하실 로우를 체크해 주세요.");
	
		return;
	}
	
	confirmMessage("주문접수를 진행하시겠습니까?", fnOrdPurcReceiveCallback); // confirm 호출
}

function fnOrdPurcReceiveCallback(){
	var ordeIdenNumb_Array	= new Array();	//주문번호
	var ordeSequNumb_Array	= new Array();	//주문차수
	var purcIdenNumb_Array	= new Array();	//발주차수
	var deliScheDate_Array  = new Array();  // 납품예정일
	var ordPurcChkLength    = $("input[name=ordPurcChk]").length;
	var i                   = 0;
	var ordPurcChk          = null;
	var ordeIdenNumb        = null;
	var ordeSequNumb        = null;
	var purcIdenNumb        = null;
	var deliScheDate        = null;
	
	var orde_iden_numb_array	= new Array();	
	var purc_iden_numb_array	= new Array();	
	$.blockUI();
	
	var purcChkCnt = 0;
	for(i = 0; i < ordPurcChkLength; i++){
		ordPurcChk = $("#ordPurcChk_"+i).prop("checked");
		
		if(ordPurcChk){
			ordeIdenNumb = $("#ordeIdenNumb_" + i).val();
			ordeSequNumb = $("#ordeSequNumb_" + i).val();
			purcIdenNumb = $("#purcIdenNumb_" + i).val();
			deliScheDate = $("#deliScheDate" + i).val();
			
			ordeIdenNumb_Array[purcChkCnt] = ordeIdenNumb;
			ordeSequNumb_Array[purcChkCnt] = ordeSequNumb;
			purcIdenNumb_Array[purcChkCnt] = purcIdenNumb;
			deliScheDate_Array[purcChkCnt] = deliScheDate;
			
			orde_iden_numb_array[purcChkCnt] = $("#ordeIdenNumb_" + i).val() +"-"+ $("#ordeSequNumb_" + i).val();
			purc_iden_numb_array[purcChkCnt] = $("#purcIdenNumb_" + i).val();
// 			alert("orde_iden_numb_array[i] : "+orde_iden_numb_array[purcChkCnt]+"\npurc_iden_numb_array[i] : "+purc_iden_numb_array[purcChkCnt]);
            purcChkCnt++;
		}
	}
	
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
        {
            orde_iden_numb_array:orde_iden_numb_array,
            purc_iden_numb_array:purc_iden_numb_array,
            orde_stat_flag:'40' 
        },
        function(arg){ 
			if($.parseJSON(arg).customResponse.success){
                $.post(
                    "/venOrder/ordPurcReceive.sys",
                    {
                        ordeIdenNumb_Array : ordeIdenNumb_Array,
                        ordeSequNumb_Array : ordeSequNumb_Array,
                        purcIdenNumb_Array : purcIdenNumb_Array,
                        deliScheDate_Array : deliScheDate_Array
                    },
                    function(arg2){
                        var customResponse = arg2.customResponse;
                        if(customResponse.success == false){
                            alert(customResponse.message);
                        }
                        else{
                            alert("처리 되었습니다.");
                            location.reload(true);
                        }
                        $.unblockUI();
                    },
                    "json"
                );
            } else {
                alert("처리중 오류가 발생했습니다.");
                $.unblockUI();
                location.reload(true);
            }
        }
    );
}

<%-- 주문거부 팝업 open--%>
function fnRejectPopupOpen(){
	$("#chanReasDesc").val("");
	var ordPurcChkCnt		= $("input[name=ordPurcChk]:checkbox:checked").length;
	if(ordPurcChkCnt == 0){//체크된 갯수가 0이면 경고창
		alert("주문거부 하실 로우를 체크해 주세요.");
		return;
	}
	$("#ordRejectPop").jqmShow();
}

<%-- 주문거부 --%>
function fnOrdPurcReceiveReject(){
	var ordPurcChkCnt		= $("input[name=ordPurcChk]:checkbox:checked").length; //체크된 갯수
	
	if(ordPurcChkCnt == 0){//체크된 갯수가 0이면 경고창
		alert("주문거부 하실 로우를 체크해 주세요.");
		return;
	}
	
	confirmMessage("선택된 로우를 주문거부 하시겠습니까?", fnOrdPurcReceiveRejectCallback);
}

function fnOrdPurcReceiveRejectCallback(){
	var ordeIdenNumb_Array	= new Array();	//주문번호
	var ordeSequNumb_Array	= new Array();	//주문차수
	var purcIdenNumb_Array	= new Array();	//발주차수
	var chanReasDesc_Array	= new Array();	//주문거부
	var chanReasDesc = $("#chanReasDesc").val();
	
	$.blockUI();
	var purcChkCnt	= 0;
	var ordPurcChkLength = $("input[name=ordPurcChk]").length;
	for(var i=0; i<ordPurcChkLength; i++){
		var ordPurcChk = $("#ordPurcChk_"+i).prop("checked");
		if(ordPurcChk){
			var ordeIdenNumb = $("#ordeIdenNumb_"+i).val()
			var ordeSequNumb = $("#ordeSequNumb_"+i).val()
			var purcIdenNumb = $("#purcIdenNumb_"+i).val()
			ordeIdenNumb_Array[purcChkCnt] = ordeIdenNumb;
			ordeSequNumb_Array[purcChkCnt] = ordeSequNumb;
			purcIdenNumb_Array[purcChkCnt] = purcIdenNumb;
			chanReasDesc_Array[purcChkCnt] = chanReasDesc;
            purcChkCnt++;
		}
	}
	$("#ordRejectPop").jqmHide();
	$.post(
		"/venOrder/ordPurcReceiveReject.sys",
		{
			ordeIdenNumb_Array:ordeIdenNumb_Array,
			ordeSequNumb_Array:ordeSequNumb_Array,
			purcIdenNumb_Array:purcIdenNumb_Array,
			chanReasDesc_Array:chanReasDesc_Array
		},
		function(arg){
			var customResponse = arg.customResponse;
			if(customResponse.success == false){
            	var errs = customResponse.message;
				var msg = "";
				for(var i=0 ; i < errs.length; i++){
					msg += errs[i];
				}
				alert(msg);
			}else{
				alert("처리 되었습니다.");
				location.reload(true);
			}
			$.unblockUI();
		},
		"json"
	);
}

<%-- 조회 --%>
function fnSearch(){
	fnOrderPurchaseList(1);
}

<%-- 팝업 닫기 --%>
function fnPopClose(){
	$("#ordRejectPop").jqmHide();
}

function fnVenProductDetail(i){
    var ordeIdenNumb = $("#ordeIdenNumb_"+i).val()
    var ordeSequNumb = $("#add_repre_sequ_numb_"+i).val()
	fnProductDetailPop(ordeIdenNumb, ordeSequNumb);
}
function fnVenMstProductDetail(i){
    var ordeIdenNumb = $("#ordeIdenNumb_"+i).val()
    var ordeSequNumb = $("#mstAddRepreSequNumb_"+i).val()
	fnProductDetailPop(ordeIdenNumb, ordeSequNumb);
}

function fnDeliScheDateChange(){
	var ordPurcChkCnt    = $("input[name=ordPurcChk]:checkbox:checked").length; //체크된 갯수
	var ordPurcChkLength = $("input[name=ordPurcChk]").length;
	var ordPurcChk       = false;
	var deliScheDateAll  = $("#deliScheDateAll").val();
	
	if(ordPurcChkCnt == 0){//체크된 갯수가 0이면 경고창
		alert("주문접수 하실 로우를 체크해 주세요.");
	
		return;
	}
	
	for(i = 0; i < ordPurcChkLength; i++){
		ordPurcChk = $("#ordPurcChk_"+i).prop("checked");
		
		if(ordPurcChk){
			$("#deliScheDate" + i).val(deliScheDateAll);
		}
	}
	
	$('#deliScheDateAllPop').jqmHide();
}
</script>

</head>

<body class="subBg">
<div id="divWrap">
	<!--header-->
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
	<!--//header-->
	<hr>
		<div id="divBody">
			<div id="divSub">
				<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">주문접수 정보조회</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-30px;">
						<a href="#;"><img src="/img/contents/btn_excelDN.gif" id="allExcelButton" name="allExcelButton"/></a>
						<a href="#;" onclick="fnSearch();"><img src="/img/contents/btn_tablesearch.gif" /></a>
					</div>
					<table class="InputTable">
						<colgroup>
							<col width="120px" />
							<col width="auto" />
							<col width="120px" />
							<col width="auto" />
						</colgroup>
						<tr>
							<th>주문번호</th>
							<td>
								<input type="text" id="orderNumber" name="orderNumber" style="width:200px;"/>
							</td>
							<th>주문일</th>
							<td>
								<input type="text" id="startDate" style="width:80px;" value="<%=startDate%>"/>
								~
								<input type="text" id="endDate" style="width:80px;" value="<%=endDate%>"/>
							</td>
						</tr>
						<tr>
							<th>주문상태</th>
							<td colspan="3">
								<select id="purcStatFlag" name="purcStatFlag" style="width:120px;">
									<option value="">전체</option>
<%	for(int i=0; i<orderStatusCodeList.size(); i++){%>
									<option value="<%=orderStatusCodeList.get(i).getCodeVal1()%>"><%=orderStatusCodeList.get(i).getCodeNm1()%></option>
<%	}%>
								</select>
							</td>
						</tr>
					</table>
					<div class="Ar mgt_20">
						<button class='btn btn-darkgray btn-xs' onclick="javascript:$('#deliScheDateAllPop').jqmShow();"><i class="fa fa-calendar"></i> 납품예정일 변경</button>
						<button id='ordPurcBtn' class='btn btn-darkgray btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' onclick="fnOrdPurcReceive()"><i class="fa fa-check"></i> 주문접수</button>
						<button id='ordPurcRejectBtn' class='btn btn-darkgray btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' onclick="fnRejectPopupOpen()"><i class="fa fa-times"></i> 주문거부</button>
					</div>
					<div class="ListTable mgt_5">
						<table id="orderPurchaseTable">
							<colgroup>
								<col width="20px" />
								<col width="100px" />
								<col width="55px" />
								<col width="150px" />
								<col width="60px" />
								<col width="200px" />
								<col width="100px" />
								<col width="125px" />
								<col width="90px" />
								<col width="150px" />
							</colgroup>
							<tr>
								<th class="br_l0">
									<input type="checkbox" id="ordPurcAllChk" name="ordPurcAllChk" onclick="fnOrdPurcAllChk();"/>
									<label for="checkbox"></label>
								</th>
								<th>
									<p>주문일</p>
									<p>(납품요청일)</p>
								</th>
								<th>주문유형</th>
								<th>주문번호/구매사</th>
								<th>주문자명</th>
								<th>상품정보</th>
								<th>
									<p>주문수량</p>
									<p>(단가)</p>
								</th>
								<th>납품예정일</th>
								<th>주문총액</th>
								<th>기타요청사항</th>
							</tr>
						</table>
					</div>
					<div class="divPageNum" id="pager">
					</div>
				<!--컨텐츠(E)-->
				</div>
				<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
			</div>
		</div>
	<hr>
</div>

<div id="ordRejectPop" class="jqmPop" style="font_size: 12px; display: none;">
	<div>
		<div id="divPopup"  style="width:400px;">
            <h1 id="divPopupTitle">주문거부
                <a href="#" onclick="fnPopClose();"><img src="/img/contents/btn_close.png"/></a>
            </h1>
            <div class="popcont">
                <table class="InputTable">
                    <colgroup>
                        <col width="100px" />
                        <col width="auto" />
                    </colgroup>
                    <tr>
                        <th>사유</th>
                            <td><textarea id="chanReasDesc" cols="" rows="" style="width:98%; height: 100px;"></textarea></td>
                    </tr>
                </table>
                <div class="Ac mgt_10">
                    <button id='popOrdPurcBtn' class='btn btn-darkgray btn-sm' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' onclick="fnOrdPurcReceiveReject()">주문거부</button>
                    <button id='popOrdPurcRejectBtn' class='btn btn-default btn-sm' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' onclick="fnPopClose();">닫기</button>
                </div>
            </div>
        </div>
	</div>
</div>
<div id="deliScheDateAllPop" class="jqmPop" style="font_size: 12px; display: none;">
	<div>
		<div id="divPopup"  style="width:400px;">
			<div id="deliScheDateAllDrag">
				<h1>납품예정일 변경<a href="javascript:void(0);"><img onclick="javascript:$('#deliScheDateAllPop').jqmHide();"src="/img/contents/btn_close.png"></a></h1>
			</div>		  		
			<div class="popcont">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2" class="table_top_line"></td>
					</tr>
					<tr>
						<td>변경하고자 하는 납품예정일을 선택하여 주십시오.</td>
					</tr>
					<tr>
						<td colspan="2" height="20">&nbsp;</td>
					</tr>
					<tr>
						<td>
							<input type="text" id="deliScheDateAll" style="width:80px;" value="<%=endDate%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="2" height="20">&nbsp;</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<button id='conFirmPopConfirm' class="btn btn-primary btn-xs" onclick="javascript:fnDeliScheDateChange();">확인</button>
							<button id='conFirmPopCancle' class="btn btn-primary btn-xs" onclick="javascript:$('#deliScheDateAllPop').jqmHide();">취소</button>
						</td>
					</tr>
				</table>
			</div>
		</div>    	
	</div>
</div>
<%@ include file="/WEB-INF/jsp/product/product/venProductDetailPop.jsp" %>
</body>
</html>