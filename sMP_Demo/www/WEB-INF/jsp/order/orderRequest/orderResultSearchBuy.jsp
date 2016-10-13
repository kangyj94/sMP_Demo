<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
	List<CodesDto> codeList = (List<CodesDto>)request.getAttribute("codeList");
	
	String       _menuId           = CommonUtils.getRequestMenuId(request);
	String       srcOrderStartDate = CommonUtils.getCustomDay("DAY", -1);
	String       srcOrderEndDate   = CommonUtils.getCurrentDate();
	String       branchManageFlag  = CommonUtils.getString(request.getParameter("flag1"));
	String       startDate         = CommonUtils.getString(request.getParameter("startDate"));
	String       endDate           = CommonUtils.getString(request.getParameter("endDate"));
	String       srcIsBill         = request.getParameter("srcIsBill");
	LoginUserDto userDto           = CommonUtils.getLoginUserDto(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }

.ui-jqgrid .ui-jqgrid-htable th div {
    height:auto;
    overflow:hidden;
    padding-right:2px;
    padding-left:2px;
    padding-top:4px;
    padding-bottom:4px;
    position:relative;
    vertical-align:text-top;
    white-space:normal !important;
}
</style>
</head>
<body class="mainBg">
<div id="divWrap">
	<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>    
	<hr>
	<div id="divBody">
		<div id="divSub">
			<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />
			<div id="AllContainer">                    
				<ul class="Tabarea">
					<li class="on">구매이력 조회</li>
				</ul>
				<div style="position:absolute; right:0; margin-top:-30px;">
					<a href="#;"><img src="/img/contents/btn_excelDN.gif" id="allExcelButton" name="allExcelButton"/></a>
					<a href="javascript:void(0);">
						<img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/>
					</a>
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
							<input type="hidden" id="srcBranchId" name="srcBranchId"  value="<%=loginUserDto.getBorgId()%>"/>
							<input type="text" id="srcOrderNumber" name="srcOrderNumber" style="width:150px;"/>
						</td>
						<th>상품코드</th>
						<td>
							<input type="text" id="srcGoodIdenNumb" name="srcGoodIdenNumb" style="width:150px;"/>
						</td>
					</tr>
					<tr>
						<th>주문상태</th>
						<td>
							<select id="srcOrderStatusFlag" name="srcOrderStatusFlag" style="width:130px"onchange="javascript:changeOrderStatusFlag();" >
								<option value="">전체</option>
<%
	if(codeList.size() > 0 ){
		CodesDto cdData  = null;
		String   val1    = null;
		String   codeNm1 = null;
		
		for (int i = 0; i < codeList.size(); i++) {
			cdData  = codeList.get(i);
			val1    = cdData.getCodeVal1();
			codeNm1 = cdData.getCodeNm1();
			
			
			if("05".equals(val1) || "10".equals(val1) || "40".equals(val1) || "50".equals(val1) || "55".equals(val1) || "60".equals(val1) || "70".equals(val1) || "80".equals(val1) || "99".equals(val1) ){
				if(!"".equals(branchManageFlag)){ //구매사 미정산 현황 관련 케이스처리
%>
								<option value="<%=val1%>" <%=branchManageFlag.equals(val1)? "selected":"" %>><%=codeNm1%></option>
<%				}
				else{
%>
								<option value="<%=val1%>" ><%=codeNm1%></option>
<%
				}
			}
		}
	}
%>
							</select>
						</td>
							<th>
								<select id="srcOrderDateFlag" name="srcOrderDateFlag" style="width: 105px;">
									<option value="">주문일</option>
									<option value="1">발주일</option>
									<option value="2">배송일</option>
									<option value="4" <%=("0".equals(srcIsBill))?"selected":"" %>>인수일</option>
									<option value="9">세금계산서일</option>
								</select>
							</th>
							<td>
								<input id="srcOrderStartDate" name="srcOrderStartDate"type="text" style="width:80px;" value=""/>
								~<input id="srcOrderEndDate" name="srcOrderEndDate" type="text" style="width:80px;" value=""/>
							</td>
						</tr>
						<tr>
                            <th>계산서발행</th>
                            <td colspan="3">
                                <select  id="srcIsBill" name="srcIsBill" style="width:100px">
                                    <option value="">전체</option>
                                    <option value="1">발행</option>
                                    <option value="0" <%=("41".equals(branchManageFlag) || "70".equals(branchManageFlag) || "0".equals(srcIsBill))?"selected":"" %>>미발행</option>
                                </select>
                            </td>
						</tr>
					</table>
					<div class="mgt_5" align="right">
						<span  class="mgt_5">
							<button id='setButton' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 개인별 항목 설정</button>
						</span>
					</div>
					<div class="mgt_5">
						<div id="jqgrid">
							<table id="list"></table>
							<div id="pager"></div>
						</div>
					</div>
					<div style="height:10px;"></div>
				</div>
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>
</body>
<%@ include file="/WEB-INF/jsp/product/product/buyProductDetailPop.jsp" %>
<script type="text/javascript">
var jq = $;

$(document).ready(function() {
	fnInitEvent();
	fnInitDatepicker();
	fnInitGrid();
});

function fnInitDatepicker(){
	$("#allExcelButton").click(function(){ 
// 		$("#srcOrderNumber").val($.trim($("#srcOrderNumber").val()));
// 		$("#srcIsBill").val($.trim($("#srcGoodsId").val()));
// 		$("#srcOrderStatusFlag").val($.trim($("#srcGoodsName").val()));
// 		$("#srcOrderDateFlag").val($.trim($("#srcVendorName").val()));
// 		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
// 		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		fnAllExcelPrintDown();
	});
	
	$("#srcOrderStartDate").datepicker({
		showOn          : "button",
		buttonImage     : "/img/contents/btn_calenda.gif",
		buttonImageOnly : true,
		dateFormat      : "yy-mm-dd"
	});
	
	$("#srcOrderEndDate").datepicker({
		showOn          : "button",
		buttonImage     : "/img/contents/btn_calenda.gif",
		buttonImageOnly : true,
		dateFormat      : "yy-mm-dd"
	});
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
	
	// 날짜 세팅
<%
	if("".equals(branchManageFlag) == false){
%>
	$("#srcOrderStartDate").val("<%=startDate%>");
	$("#srcOrderEndDate").val("<%=endDate%>");
<%
	}
	else{
%>
	$("#srcOrderStartDate").val("<%=srcOrderStartDate%>");
	$("#srcOrderEndDate").val("<%=srcOrderEndDate%>");	
<%
	}
%>	
}

function fnInitEvent(){
	$("#divGnb").mouseover(function(){
		$("#snb").show();
	});
	
	$("#divGnb").mouseout(function(){
		$("#snb").hide();
	});
	
	$("#snb").mouseover(function(){
		$("#snb").show();
	});
	
	$("#snb").mouseout(function(){
		$("#snb").hide();
	});
	
	$("#srcOrderNumber").keydown(function(e){
		if( e.keyCode == 13 ) $("#srcButton").click(); 
	});
	$("#srcGoodIdenNumb").keydown(function(e){
		if( e.keyCode == 13 ) $("#srcButton").click(); 
	});
	
	$("#srcButton").click(function(){ 
		$("#srcOrderNumber").val($.trim($("#srcOrderNumber").val()));
		$("#srcOrderStatusFlag").val($.trim($("#srcOrderStatusFlag").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		
		fnSearch(); 
	});
	
	$('#setButton').click(function () {
		$("#list").jqGrid('columnChooser', {
			done: function (perm) {
				fnSaveColumn("#list");
				// 1. 저장할 그리드의 아이디를 넣어줌. 
			}
		});
	});
}

/*
 * 리스트 조회
 */
function fnSearch() {
	$("#list").jqGrid("setGridParam", {"page":1});
	
	var data = $("#list").jqGrid("getGridParam", "postData");
	
	data.srcOrderNumber     = $("#srcOrderNumber").val();
	data.srcOrderStatusFlag = $("#srcOrderStatusFlag").val();
	data.srcOrderDateFlag   = $("#srcOrderDateFlag").val();
	data.srcOrderStartDate  = $("#srcOrderStartDate").val();
	data.srcOrderEndDate    = $("#srcOrderEndDate").val();
	data.srcGoodIdenNumb    = $("#srcGoodIdenNumb").val();
	data.srcIsBill          = $("#srcIsBill").val();
	
	$("#list").jqGrid("setGridParam", { "postData": data });
	$("#list").trigger("reloadGrid");
}


//상태 변경시 자동 조회
function changeOrderStatusFlag(){
	$("#srcButton").click();
}


function fnAllExcelPrintDown(){
	var colLabels = [
			'주문일자',					'주문유형',				'주문상태',		'주문번호',				'상품명',
			'규격',						'총중량',				'실중량',		'상품코드',				'단위',			'판매단가',				'수량',					'판매금액', 
			'공급사',					'인수일',				'세금계산서일',	'매입세금계산서일',		'납품요청일',
			'고객유형',					'발주차수',				'발주수량',		'출하차수',				'출하수량',
			'인수차수',					'인수수량',				'매출확정자',	'매입확정자',			'공사명',
			'구매사',					'구매사사업자등록번호',	'권역',			'공급사사업자등록번호',	'주문자',
			'인수자',					'인수자전화번호',		
			'고객유형 담당자',			'발주일',				'출하일',
			'배송정보입력일',			'자동인수여부',			'상품 실적년도',		'카테고리 진열명',		'법인ID',
			'사업장ID',					'공급사ID', '비고'
	];
    var colIds = [
        'REGI_DATE_TIME', 'ORDE_TYPE_CLAS', 'STAT_FLAG_NAME', 'ORDE_IDEN_NUMB', 'GOOD_NAME',
        'GOOD_SPEC', 'SPEC_WEIGHT_SUM', 'SPEC_WEIGHT_REAL', 'GOOD_IDEN_NUMB', 'ORDE_CLAS_CODE', 'ORDE_REQU_PRICE', 'QUANTITY', 'TOTAL_ORDE_REQU_PRIC',
        'VENDORNM', 'RECE_REGI_DATE', 'CLOS_SALE_DATE', 'CLOS_BUYI_DATE', 'REQU_DELI_DATE',
        'WORKNM', 'PURC_IDEN_NUMB', 'PURC_IDEN_QUAN', 'DELI_IDEN_NUMB', 'DELI_IDEN_QUAN',
        'RECE_IDEN_NUMB', 'RECE_IDEN_QUAN', 'SALE_SEQU_NUMB', 'BUYI_SEQU_NUMB', 'CONS_IDEN_NAME',
        'BRANCHNM', 'BCHBUSINESSNUM', 'DELI_AREA_NAME', 'VENBUSINESSNUM', 'USERNM',
        'TRAN_USER_NAME', 'TRAN_TELE_NUMB',  
         'WORKUSERNM', 'CLIN_DATE', 'DELI_DEGR_DATE',
        'INVOICEDATE', 'AUTO_RECEIVE', 'GOOD_REG_YEAR', 'FULL_CATE_NAME', 'CLIENTID',
        'BRANCHID', 'VENDORID', 'DELI_DESC'
    ];
	var numColIds = ['ORDE_REQU_PRICE','QUANTITY','TOTAL_ORDE_REQU_PRIC','PURC_IDEN_QUAN','DELI_IDEN_QUAN','RECE_IDEN_QUAN'];	
	var sheetTitle = "구매이력조회";	//sheet 타이틀
	var excelFileName = "OrderResultSearchBuy";	//file명
    
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcOrderNumber';
    fieldSearchParamArray[1] = 'srcOrderStatusFlag';
    fieldSearchParamArray[2] = 'srcOrderDateFlag';
    fieldSearchParamArray[3] = 'srcOrderStartDate';
    fieldSearchParamArray[4] = 'srcOrderEndDate';
    fieldSearchParamArray[5] = 'srcIsBill';
    fieldSearchParamArray[6] = 'srcBranchId';
    fieldSearchParamArray[7] = 'srcGoodIdenNumb';
    
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray,"/order/orderRequest/selectOrderResultBuyList/excel.sys");  
}


function fnInitGrid() {
	var colModel = fnLoadColumn('#list', true);
	
	$("#list").jqGrid({
		url      : '/buyOrder/orderResultSearchBuyJQGrid.sys', 
		datatype : 'json',
		mtype    : 'POST',
		colNames : [
			'주문일자',					'주문<br/>유형',		'주문<br/>상태',		'주문번호',				'상품명',
			'규격',						'상품코드',				'단위',					'판매단가',				'수량',					'판매금액', 
			'공급사',					'인수일',				'세금<br/>계산서일',	'매입세금<br/>계산서일','납품<br/>요청일',
			'고객유형',					'발주차수',				'발주수량',				'출하차수',				'출하수량',
			'인수차수',					'인수수량',				'매출확정자',			'매입확정자',			'공사명',
			'구매사',					'구매사사업자등록번호',	'권역',					'공급사사업자등록번호',	'주문자',
			'인수자',					'인수자<br/>전화번호',	'disp_good_id',			'vendorid',				//'good_iden_numb',
			'sum_total_sale_unit_pric',	'sum_quantity',			'고객유형 담당자',		'발주일',				'출하일',
			'배송정보입력일',			'자동인수여부',			'상품 실적년도',		'카테고리 진열명',		'법인ID',
			'사업장ID',					'공급사ID',				'is_add_good'
		],
		colModel : colModel ? colModel : [
			{name:'REGI_DATE_TIME',           index:'REGI_DATE_TIME',           width:80,	sortable:false,     align:"center", formatter:"date"},//주문일자
			{name:'ORDE_TYPE_CLAS',           index:'ORDE_TYPE_CLAS',           width:40,	sortable:false,     align:"center"},//주문유형
			{name:'STAT_FLAG_NAME',           index:'STAT_FLAG_NAME',           width:60,	sortable:false,     align:"center"},//주문상태
			{name:'ORDE_IDEN_NUMB',           index:'ORDE_IDEN_NUMB',           width:125,	sortable:false,    align:"left"},//주문번호
			{name:'GOOD_NAME',                index:'GOOD_NAME',                width:200,	sortable:false,    align:"left"},//상품명
			
			{name:'GOOD_SPEC',                index:'GOOD_SPEC',                width:120,	sortable:false,    align:"left"},//상품규격
			{name:'GOOD_IDEN_NUMB',           index:'GOOD_IDEN_NUMB',           width:80,	sortable:false,    align:"left"},//상품코드
			{name:'ORDE_CLAS_CODE',           index:'ORDE_CLAS_CODE',           width:45,	sortable:false,     align:"center"},//단위
			{name:'ORDE_REQU_PRICE',          index:'ORDE_REQU_PRICE',          width:100,	sortable:false,    align:"right",  sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매단가
			{name:'QUANTITY',                 index:'QUANTITY',                 width:40,	sortable:false,     align:"right",  sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//수량
			{name:'TOTAL_ORDE_REQU_PRIC',     index:'TOTAL_ORDE_REQU_PRIC',     width:70,	sortable:false,     align:"right",  sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매금액
				
			{name:'VENDORNM',                 index:'VENDORNM',                 width:120,	sortable:false,    align:"left"},//공급사
			{name:'RECE_REGI_DATE',           index:'RECE_REGI_DATE',           width:80,	sortable:false,     align:"center", sorttype:"date",    formatter:"date"},//인수일
			{name:'CLOS_SALE_DATE',           index:'CLOS_SALE_DATE',           width:80,	sortable:false,     align:"center", sorttype:"date",    formatter:"date"},//매출세금계산서일
			{name:'CLOS_BUYI_DATE',           index:'CLOS_BUYI_DATE',           width:80,	sortable:false,     align:"center", sorttype:"date",    formatter:"date", hidden:true},//매입세금계산서일
			{name:'REQU_DELI_DATE',           INDEX:'REQU_DELI_DATE',           width:80,	sortable:false,     align:"center", sorttype:"date",    formatter:"date"},//납품요청일
			
			{name:'WORKNM',                   index:'WORKNM',                   width:100,	sortable:false,    align:"left"},//고객유형
			{name:'PURC_IDEN_NUMB',           index:'PURC_IDEN_NUMB',           width:60,	sortable:false,     align:"center"},//납품차수
			{name:'PURC_IDEN_QUAN',           index:'PURC_IDEN_QUAN',           width:60,	sortable:false,     align:"right",  sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'DELI_IDEN_NUMB',           index:'DELI_IDEN_NUMB',           width:60,	sortable:false,     align:"center"},
			{name:'DELI_IDEN_QUAN',           index:'DELI_IDEN_QUAN',           width:60,	sortable:false,     align:"right",  sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"", defaultValue: '' }},
			
			{name:'RECE_IDEN_NUMB',           index:'RECE_IDEN_NUMB',           width:60,	sortable:false,     align:"center"},
			{name:'RECE_IDEN_QUAN',           index:'RECE_IDEN_QUAN',           width:60,	sortable:false,     align:"right",  sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" ,defaultValue: ''}},
			{name:'SALE_SEQU_NUMB',           index:'SALE_SEQU_NUMB',           width:70,	sortable:false,     align:"center", hidden:true},//매출 id
			{name:'BUYI_SEQU_NUMB',           index:'BUYI_SEQU_NUMB',           width:70,	sortable:false,     align:"center", hidden:true},//매입 id
			{name:'CONS_IDEN_NAME',           index:'CONS_IDEN_NAME',           width:200,	sortable:false,    align:"left"},//공사명
			
			{name:'BRANCHNM',                 index:'BRANCHNM',                 width:120,	sortable:false,    align:"left" },//고객사
			{name:'BCHBUSINESSNUM',           index:'BCHBUSINESSNUM',           width:120,	sortable:false,    align:"center", hidden:true},//고객사사업자등록번호
			{name:'DELI_AREA_NAME',           index:'DELI_AREA_NAME',           width:60,	sortable:false,     align:"center", hidden:true},//권역
			{name:'VENBUSINESSNUM',           index:'VENBUSINESSNUM',           width:120,	sortable:false,    align:"center", hidden:true},//공급사사업자등록번호
			{name:'USERNM',                   index:'USERNM',                   width:70,	sortable:false,     align:"left"},//주문자
			
			{name:'TRAN_USER_NAME',           index:'TRAN_USER_NAME',           width:70,	sortable:false,     align:"left"},//인수자
			{name:'TRAN_TELE_NUMB',           index:'TRAN_TELE_NUMB',           width:100,	sortable:false,    align:"right", hidden:true},//인수자 전화번호
			{name:'DISP_GOOD_ID',             index:'DISP_GOOD_ID',             hidden:true,  hidedlg:true},
			{name:'VENDORID',                 index:'VENDORID',                 hidden:true,  hidedlg:true},
// 			{name:'GOOD_IDEN_NUMB',           index:'GOOD_IDEN_NUMB',           hidden:true,  hidedlg:true},
			
			{name:'SUM_TOTAL_SALE_UNIT_PRIC', index:'SUM_TOTAL_SALE_UNIT_PRIC', hidden:true,  hidedlg:true},
			{name:'SUM_QUANTITY',             index:'SUM_QUANTITY',             search:false, sortable:false, hidden:true, hidedlg:true},
			{name:'WORKUSERNM',               index:'WORKUSERNM',               width:100,	sortable:false,    align:"left"},//주문자
			{name:'CLIN_DATE',                index:'CLIN_DATE',                width:80,	sortable:false,     align:"center", sorttype:"date", formatter:"date"},//발주일
			{name:'DELI_DEGR_DATE',           index:'DELI_DEGR_DATE',           width:80,	sortable:false,     align:"center", sorttype:"date", formatter:"date"},//출하일
			
			{name:'INVOICEDATE',              index:'INVOICEDATE',              width:100,	sortable:false,    align:"center", sorttype:"date", formatter:"date"},//송장저장일
			{name:'AUTO_RECEIVE',             index:'AUTO_RECEIVE',             width:90,	sortable:false,     align:"center"},
			{name:'GOOD_REG_YEAR',            index:'GOOD_REG_YEAR',            width:100,	sortable:false,    align:"center", hidden:true},//상품실적년도
			{name:'FULL_CATE_NAME',           index:'FULL_CATE_NAME',           width:250,	sortable:false,    align:"left",   hidden:true},//풀카테고리명
			{name:'CLIENTID',                 index:'CLIENTID',                 width:250,	sortable:false,    align:"left",   hidden:true, hidedlg:true },//법인ID
			
			{name:'BRANCHID',                 index:'BRANCHID',                 width:250,	sortable:false,    align:"left",   hidden:true, hidedlg:true },//사업장ID
			{name:'VENDORID',                 index:'VENDORID',                 width:250,	sortable:false,    align:"left",   hidden:true, hidedlg:true },//공급사ID
			{name:'IS_ADD_GOOD',              index:'IS_ADD_GOOD',              hidden:true,  hidedlg:true }
		],
		postData: {
			srcOrderNumber     : $("#srcOrderNumber").val(),
			srcOrderStatusFlag : $("#srcOrderStatusFlag").val(),
			srcOrderDateFlag   : $("#srcOrderDateFlag").val(),
			srcOrderStartDate  : $("#srcOrderStartDate").val(),
			srcOrderEndDate    : $("#srcOrderEndDate").val(),
			srcIsBill          : $("#srcIsBill").val()
		},
		rowNum:15, rownumbers: true, rowList:[15,30,50,100], pager: '#pager',
		height: "425",autowidth: true,
		sortname: 'regi_date_time', sortorder: "desc",
		viewrecords:true, 
		emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, 
		loadComplete: function(){},
		onSelectRow: function(rowid, iRow, iCol, e){},
		ondblClickRow: function(rowid, iRow, iCol, e){},
		afterInsertRow: function(rowid, aData){
			fnGridAfterInsertRow(rowid, aData);
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			fnGridOnCellSelect(rowid, iCol, cellcontent, target);
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}

function fnGridOnCellSelect(rowid, iCol, cellcontent, target){
	var cm            = $("#list").jqGrid("getGridParam", "colModel");
	var colName       = cm[iCol];
	var selrowContent = $("#list").jqGrid('getRowData', rowid);

	if(colName != undefined && colName['index']=="ORDE_IDEN_NUMB") { 
		if(selrowContent.purc_iden_numb == ""){
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> 
		}else{
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+",selrowContent.PURC_IDEN_NUMB);")%>
		}
	}
	
	if(colName != undefined &&colName['index']=="GOOD_NAME") {
		<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailPop(selrowContent.GOOD_IDEN_NUMB, selrowContent.VENDORID);")%>
	}	
}

function fnGridAfterInsertRow(rowid, aData){
	var selrowContent = $("#list").jqGrid('getRowData',rowid);

	$("#list").setCell(rowid, 'ORDE_IDEN_NUMB','',{color:'#0000ff', cursor: 'pointer'});
	$("#list").setCell(rowid, 'GOOD_NAME','',{color:'#0000ff', cursor: 'pointer'});

	if(selrowContent.STAT_FLAG_NAME=='주문요청' && selrowContent.IS_ADD_GOOD==0) {
		$("#list").jqGrid('setRowData', rowid, {vendornm:'SK텔레시스'});
	}

	$("#list").jqGrid('setRowData', rowid, {TRAN_TELE_NUMB: fnSetTelformat(selrowContent.TRAN_TELE_NUMB)});
}
</script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/typehead.js" type="text/javascript"></script>
</html>