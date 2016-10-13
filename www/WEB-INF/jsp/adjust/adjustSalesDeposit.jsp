<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="java.util.List"%>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto>   roleList               = (List<ActivitiesDto>) request.getAttribute("useActivityList"); //화면권한가져오기(필수)
	LoginUserDto          loginUserDto           = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String                _menuId                = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String                listHeight             = "$(window).height()-388 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
	String                listWidth              = "1500";
	String                _srcGroupId            = "";
	String                _srcClientId           = "";
	String                _srcBranchId           = "";
	String                _srcBorgNms            = "";
	String                svcTypeCd              = loginUserDto.getSvcTypeCd();
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	
	if("BUY".equals(svcTypeCd)) {
		_srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
		_srcGroupId            = _srcBorgScopeByRoleDto.getSrcGroupId();
		_srcClientId           = _srcBorgScopeByRoleDto.getSrcClientId();
		_srcBranchId           = _srcBorgScopeByRoleDto.getSrcBranchId();
		_srcBorgNms            = _srcBorgScopeByRoleDto.getSrcBorgNms();
		_srcBorgNms            = _srcBorgNms.replaceAll("&gt;", ">");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style>
.ui-jqgrid .ui-jqgrid-htable th div {
	white-space:normal !important; height:auto !important; padding:2px;
}
</style>
<%
/**------------------------------------고객사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 고객사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#srcGroupId").val("<%=_srcGroupId %>");
	$("#srcClientId").val("<%=_srcClientId %>");
	$("#srcBranchId").val("<%=_srcBranchId %>");
	$("#srcBorgName").val("<%=_srcBorgNms %>");
<%
	if("BUY".equals(svcTypeCd) || "VEN".equals(svcTypeCd)) {
%>
	$("#srcBorgName").attr("disabled", true);
	$("#btnBuyBorg").css("display","none");
<%
	}
%>
	$("#btnBuyBorg").click(function(){
		var borgNm = $("#srcBorgName").val();
		fnBuyborgDialog("", "", borgNm, "fnCallBackBuyBorg"); 
	});
	
	$("#srcBorgName").keydown(function(e){
		if(e.keyCode == 13) {
			$("#btnBuyBorg").click();
		}
	});
	
	$("#srcBorgName").change(function(e){
		if($("#srcBorgName").val()=="") {
			$("#srcGroupId").val("");
			$("#srcClientId").val("");
			$("#srcBranchId").val("");
		}
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm, areaType) {
	$("#srcGroupId").val(groupId);
	$("#srcClientId").val(clientId);
	$("#srcBranchId").val(branchId);
	$("#srcBorgName").val(borgNm);
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;

$(document).ready(function() {
	fnInitDatePicker();
	fnInitJqGrid();
	fnInitEvent();
});

$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight%>);
	$("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');

function fnInitEvent(){
	$("#srcButton").click( function(){
		fnSearch();
	});
	
	$("#excelButton").click(function(){
		exportExcel();
	});
	
	$("#excelHistButton").click(function(){
		exportExceltoSvc();
	});
	
	$("#depositConfirmButton").click(function(){
		fnDepositConfirm();
	});
}

function fnInitDatePicker(){
	$("#srcSalesTransStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	$("#srcSalesTransEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
	$("#srcSalesTransStartDate").val('<%=CommonUtils.getCustomDay("MONTH", -1)%>');	//계산서일자
	$("#srcSalesTransEndDate").val('<%=CommonUtils.getCustomDay("DAY", 0)%>');		//계산서일자
	
	$("#srcStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	$("#srcEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
	$("#srcStartDate").val('<%=CommonUtils.getCustomDay("MONTH", -1)%>');	//입금일자
	$("#srcEndDate").val('<%=CommonUtils.getCustomDay("DAY", 0)%>');		//입금일자
}

//<!-- 그리드 초기화 스크립트 -->
function fnInitJqGrid() {
	$("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustSalesTransmissionJQGrid20.sys',
		datatype: 'local',
		mtype: 'POST',
		colNames:[
			'sale_sequ_numb',		'계산서발행일',		'정산명',				'고객사명<br/>(사업자등록번호)',	'매출액<br/>(VAT)',
			'총액',					'입금액',			'미회수금액',				'분리입금',						'전송상태',
			'전표번호<br/>기표일',	'회수여부',			'전표번호<br/>기표일',	'내용',							'noneCollAmou',
			'totSaleRequAmou',		'totSaleTotaAmou',	'totRecePayAmou',		'totRemainAmou',                '매출확정일자',
			'반제완료일자'
		],
		colModel:[
			{name:'saleSequNumb',    index:'saleSequNumb',    hidden:true},
			{name:'closSaleDate',    index:'closSaleDate',    width:80,  align:"center", search:false, sortable:true, editable:false},	// 계산서발행일
			{name:'saleSequName',    index:'saleSequName',    width:160, align:"left",   search:false, sortable:true, editable:false},	// 정산명
			{name:'branchNm',        index:'branchNm',        width:120, align:"left",   search:false, sortable:true, editable:false},	// 고객사명(사업자등록번호)
			{name:'saleRequAmou',    index:'saleRequAmou',    width:80,  align:"right",  search:false, sortable:true, editable:false},	// 매출액(VAT)
			
			{name:'saleTotaAmou',    index:'saleTotaAmou',    width:80,  align:"right",  search:false, sortable:true, editable:false},	// 총액
			{name:'recePayAmou',     index:'recePayAmou',     width:80,  align:"right",  search:false, sortable:true, editable:false},	// 입금액
	 		{name:'remainAmou',      index:'remainAmou',      width:80,  align:"right",  search:false, sortable:true, editable:false},	// 미회수금액
	 		{name:'receSequYn',      index:'receSequYn',      width:80,  align:"center", search:false, sortable:true, editable:false},	// 분리입금
	 		{name:'sapJourYn',       index:'sapJourYn',       width:80,  align:"center", search:false, sortable:true, editable:false},	// 전송상태
	 		
	 		{name:'sapJourNumb',     index:'sapJourNumb',     width:80,  align:"center", search:false, sortable:true, editable:false},	// 전표번호기표일
	 		{name:'payYn',           index:'payYn',           width:80,  align:"center", search:false, sortable:true, editable:false},	// 회수여부
	 		{name:'payAmouNumb',     index:'payAmouNumb',     width:80,  align:"center", search:false, sortable:true, editable:false},	// 전표번호기표일
			{name:'desc',            index:'desc',            width:80,  align:"center", search:false, sortable:true, editable:false},    // 내용
	 		{name:'noneCollAmou',    index:'noneCollAmou',    hidden:true}, // noneCollAmou
	 		
	 		{name:'totSaleRequAmou', index:'totSaleRequAmou', hidden:true}, // totSaleRequAmou
	 		{name:'totSaleTotaAmou', index:'totSaleTotaAmou', hidden:true}, // totSaleTotaAmou
	 		{name:'totRecePayAmou',  index:'totRecePayAmou',  hidden:true}, // totRecePayAmou
	 		{name:'totRemainAmou',   index:'totRemainAmou',   hidden:true}, // totRemainAmou
	 		{name:'saleConfDate',    index:'saleConfDate',    hidden:true}, // 매출확정일자
	 		
	 		{name:'salePayDate',     index:'salePayDate',     hidden:true}  // 반제완료일자
		],
		postData: {
			srcTransStatus         : "20",
			srcSalesName           : $("#srcSalesName").val(),
			srcIsCollect           : $.trim($("#srcIsCollect").val()),
			srcSalesTransStartDate : $("#srcSalesTransStartDate").val(),
			srcSalesTransEndDate   : $("#srcSalesTransEndDate").val(),
			srcClientNm            : $("#srcClientNm").val(),
			srcBusinessNum         : $("#srcBusinessNum").val(),
			receSaleStatus         : $("#receSaleStatus").val()
		},
		rowNum:-1,
		height: <%=listHeight%>,width: <%=listWidth %>,
		sortname: 'clos_sale_date', sortorder: 'desc', 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
		loadComplete: function() {
			fnListOnload();
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			<%=CommonUtils.isDisplayRole(roleList, "COMM_SAVE","fnOnDetail(selrowContent.saleSequNumb)")%>
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
	
	$("#list").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
		groupHeaders:[
			{startColumnName: 'sapJourYn', numberOfColumns: 2, titleText: '매출기표'},
			{startColumnName: 'payYn',     numberOfColumns: 2, titleText: '반제기표'}
		]
	});
};

function fnListOnloadDesc(){
	var dataIds         = $("#list").getDataIDs();
	var rowCnt          = dataIds.length;
	var i               = 0;
	var rowid           = null;
	var selrowContent   = null;
	var descStr         = null;
	var saleSequNumb    = null;
	
	for(i = 0 ; i < rowCnt ; i++){
		rowid         = dataIds[i];
		selrowContent = $("#list").jqGrid('getRowData', rowid);
		saleSequNumb  = selrowContent.saleSequNumb;
		descStr       = "<button id='detailView' name='detailView' class='btn btn-primary btn-xs' onClick='javaScript:fnOnDesc(" + saleSequNumb + ")'>상세보기</button>";
		
		$("#list").jqGrid('setRowData', rowid, {desc:descStr});
	}
}

function fnListOnloadTot(){
	var dataIds         = $("#list").getDataIDs();
	var rowCnt          = dataIds.length;
	var rowid           = dataIds[0];
	var selrowContent 	= $("#list").jqGrid('getRowData', rowid);
	var totSaleRequAmou = selrowContent.totSaleRequAmou; 
	var totSaleTotaAmou = selrowContent.totSaleTotaAmou;
	var totRecePayAmou  = selrowContent.totRecePayAmou;
	var totRemainAmou   = selrowContent.totRemainAmou;
	var lastIndex       = rowCnt + 1;
	
	$("#list").addRowData(
		lastIndex,
		{
			saleSequName : "",
			branchNm     : "합계",
			saleRequAmou : totSaleRequAmou,
			saleTotaAmou : totSaleTotaAmou,
			recePayAmou  : totRecePayAmou,
			remainAmou   : totRemainAmou
		}
	);
	
	$("#list").jqGrid('setCell', lastIndex, 'branchNm',     '', {color:'black',weightfont:'bold'}); 
	$("#list").jqGrid('setCell', lastIndex, 'saleRequAmou', '', {color:'black',weightfont:'bold'}); 
	$("#list").jqGrid('setCell', lastIndex, 'saleTotaAmou', '', {color:'black',weightfont:'bold'}); 
	$("#list").jqGrid('setCell', lastIndex, 'recePayAmou',  '', {color:'black',weightfont:'bold'});            		
	$("#list").jqGrid('setCell', lastIndex, 'remainAmou',   '', {color:'black',weightfont:'bold'});
}

function fnListOnload(){
	var dataIds = $("#list").getDataIDs();
	var rowCnt  = dataIds.length;
	
	if(rowCnt > 0) {
		fnListOnloadDesc();
		fnListOnloadTot();
	}
}

function fnSearch(){
	$("#list").jqGrid("setGridParam");
	
	var data = $("#list").jqGrid("getGridParam", "postData");
	
	data.srcSalesName           = $("#srcSalesName").val();
	data.srcIsCollect           = $.trim($("#srcIsCollect").val());
	data.srcSalesTransStartDate = $("#srcSalesTransStartDate").val();
	data.srcSalesTransEndDate   = $("#srcSalesTransEndDate").val();
	data.srcGroupId             = $("#srcGroupId").val();
	data.srcClientId            = $("#srcClientId").val();
	data.srcBranchId            = $("#srcBranchId").val();
	data.srcBusinessNum         = $("#srcBusinessNum").val();
	data.receSaleStatus         = $("#receSaleStatus").val();
	
	$("#list").jqGrid("setGridParam", {"postData": data});
	$("#list").jqGrid("setGridParam", {datatype:"json"}).trigger("reloadGrid");
}

function fnOnDetail(obj) {
	if(obj != ""){
		var popurl = "/adjust/adjustSalesDepositDetailPop.sys?sale_sequ_numb=" + obj + "&_menuId=<%=_menuId%>";
		
		window.open(popurl, 'adjustSalesDepositDetail', 'width=780, height=300, scrollbars=yes, status=no, resizable=no');
	}
	else{ 
		$("#dialogSelectRow").dialog(); 
	}
}

function fnOnDesc(obj) {
	if(obj != ""){
		var popurl = "/adjust/adjustSalesDepositDescPop.sys?sale_sequ_numb=" + obj + "&_menuId=<%=_menuId%>";
		
		window.open(popurl, 'adjustSalesDepositDesc', 'width=570, height=310, scrollbars=yes, status=no, resizable=no');
	}
	else{
		$("#dialogSelectRow").dialog();
	}
}

function exportExcel() {
	var colLabels = [
		'계산서발행일',	'정산명',	'고객사명',	'매출액',	'총액',
		'입금액',		'미회수금액',	'분리입금',	'전송상태',	'전표번호',
		'회수여부',		'전표번호',	'매출확정',	'반제일자'
	]; //출력컬럼명
	var colIds = [
		'closSaleDate', 'saleSequName', 'branchNm',     'saleRequAmou', 'saleTotaAmou',
		'recePayAmou',  'remainAmou',   'receSequYn',   'sapJourYn',    'sapJourNumb',
		'payYn',        'payAmouNumb',  'saleConfDate', 'salePayDate'
	];  //출력컬럼ID
	var numColIds = [];  //숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "매출입금처리"; //sheet 타이틀
	var excelFileName = "SalesDeposit"; //file명
	
	fnExportExcel($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExceltoSvc() {
	var dateCalc = $("#dateCalc").val();
	
	if(dateCalc == "payDate"){//입금일자의 
		var colLabels = ['전표번호','세금계산서고객사','고객유형','채권담당자','사업자등록번호','총채권','입금금액','계산서일자','입금일']; //출력컬럼명
		var colIds = ['SAP_JOUR_NUMB','BRANCHNM','WORKNM','accManageUserId','BUSINESSNUM','SALE_TOTA_AMOU','RECE_PAY_AMOU','CLOS_SALE_DATE','ALRAM_DATE'];  //출력컬럼ID
		var numColIds = ['SALE_TOTA_AMOU','RECE_PAY_AMOU'];  //숫자표현ID
		var actionUrl = "/adjust/adjustSalesTransmissionPayDateListForExcel.sys";
		var sheetTitle = "매출입금처리(입금일자)"; //sheet 타이틀
	}
	else{
		var colLabels = ['전표번호','세금계산서고객사','고객유형','채권담당자','사업자등록번호','총채권','입금금액','미회수금액','계산서일자','입금일']; //출력컬럼명
		var colIds = ['SAP_JOUR_NUMB','BRANCHNM','WORKNM','accManageUserId','BUSINESSNUM','SALE_TOTA_AMOU','RECE_PAY_AMOU','NONE_COLL_AMOU','CLOS_SALE_DATE','ALRAM_DATE'];  //출력컬럼ID
		var numColIds = ['SALE_TOTA_AMOU','RECE_PAY_AMOU','NONE_COLL_AMOU'];  //숫자표현ID
		var actionUrl = "/adjust/adjustSalesTransmissionListForExcel.sys";
		var sheetTitle = "매출입금처리(계산서일자)"; //sheet 타이틀
	}
	
	var figureColIds = ['BUSINESSNUM'];
	var excelFileName = "SalesDepositHistory"; //file명

	
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcSalesName';
	fieldSearchParamArray[1] = 'srcTransStatus';
	fieldSearchParamArray[2] = 'srcStartDate';
	fieldSearchParamArray[3] = 'srcEndDate';
	fieldSearchParamArray[4] = 'srcClientNm';
	fieldSearchParamArray[5] = 'srcBusinessNum';
	fieldSearchParamArray[6] = 'srcIsCollect';
	fieldSearchParamArray[7] = 'dateCalc';

	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray, actionUrl, figureColIds);  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function fnDepositConfirm(){
	var rowCnt          = $("#list").getGridParam('reccount');
	var saleSequNumbArr = new Array();
	var closSaleDateArr = new Array();
	var recePayAmouArr  = new Array();
	var noneCollAmouArr = new Array();
	var sapJourNumbArr  = new Array();
	var chkCnt          = 0;
	var i               = 0;
	var rowid           = null;
	var dataIds         = $("#list").getDataIDs();
	var selrowContent   = null;
	var payAmouNumb     = null;
   
	for(i = 0 ; i < rowCnt ; i++){
		rowid         = dataIds[i];   
		selrowContent = $("#list").jqGrid('getRowData', rowid);
		payAmouNumb   = selrowContent.payAmouNumb;
      
		if(payAmouNumb == ""){
			saleSequNumbArr[chkCnt] = selrowContent.saleSequNumb;
			closSaleDateArr[chkCnt] = selrowContent.closSaleDate;
			recePayAmouArr[chkCnt]  = selrowContent.recePayAmou;
			noneCollAmouArr[chkCnt] = selrowContent.noneCollAmou;
			sapJourNumbArr[chkCnt]  = selrowContent.sapJourNumb;
		
			chkCnt++;
		}
	}  
   
	if(chkCnt == 0){
		$("#dialog").html("<font size='2'>처리할 데이터가 없습니다.</font>");
		$("#dialog").dialog({
			title: 'Fail',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
      
		return;
	}
   
	if(confirm("입금을 확인하시겠습니까?") == false){
		return;
	}
   
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/salesDepositConfirm.sys", 
		{
			sale_sequ_numb_Arr : saleSequNumbArr,
			clos_sale_date_Arr : closSaleDateArr,
			rece_pay_amou_Arr  : recePayAmouArr,
			none_coll_amou_Arr : noneCollAmouArr,
			sap_jour_numb_Arr  : sapJourNumbArr
		},       
		function(arg){
			fnAjaxTransResult(arg);
			fnSearch();
		}
	);       
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;">
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="25" class="ptitle">매출입금처리</td>
					<td align="right" class="ptitle">
						<button id="srcButton" name="srcButton" class="btn btn-default btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
							<i class="fa fa-search"></i> 조회
						</button>
					</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">정산명</td>
					<td class="table_td_contents">
						<input id="srcSalesName" name="srcSalesName" type="text" value="" size="20" maxlength="30" />
					</td>
					<td class="table_td_subject" width="100">회수여부</td>
					<td class="table_td_contents">
						<select id="srcIsCollect" name="srcIsCollect" class="select">
							<option value="">선택하세요</option>
							<option value="10">미회수</option>
							<option value="20">회수</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">
						계산서일자
					</td>
					<td class="table_td_contents">
						<input type="text" name="srcSalesTransStartDate" id="srcSalesTransStartDate" style="width: 75px; vertical-align: middle;" />
						~
						<input type="text" name="srcSalesTransEndDate" id="srcSalesTransEndDate" style="width: 75px; vertical-align: middle;" />
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">고객사</td>
					<td class="table_td_contents">
						<input id="srcBorgName" name="srcBorgName" type="text" value="" size="40" maxlength="30" />
						<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
						<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
						<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
							<a href="#">
								<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
							</a>
					</td>
					<td class="table_td_subject">사업자등록번호</td>
					<td class="table_td_contents">
						<input id="srcBusinessNum" name="srcBusinessNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumber(event)"/> (-없이)
					</td>
					<td class="table_td_subject">분리입금</td>
					<td class="table_td_contents">
						<select id="receSaleStatus" name="receSaleStatus">
							<option value="">전체</option>
							<option value="10">예</option>
							<option value="20">아니오</option>
						</select>
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
	<tr><td height="5"></td></tr>
	<tr>
		<td>
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left" valign="bottom">
						<font color="red">*</font> 더블클릭하면 수동으로 입금정보을 입력하실 수 있습니다.
					</td>
					<td align="right">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;"/>
						상세반제내역 기준 : 
						<select id="dateCalc" name="dateCalc" class="select">
							<option value="transDate">계산서일자</option>
							<option value="payDate">입금일자</option>
						</select>
						<input type="text" name="srcStartDate" id="srcStartDate" style="width: 75px; vertical-align: middle;" />
						~
						<input type="text" name="srcEndDate" id="srcEndDate" style="width: 75px; vertical-align: middle;" />
						<button id="depositConfirmButton" name="depositConfirmButton" class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>
							입금즉시확인 
						</button>
						<button id='excelHistButton' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
							<i class="fa fa-file-excel-o"></i>상세반제내역 엑셀
						</button>
						<button id='excelButton' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
							<i class="fa fa-file-excel-o"></i> 엑셀
						</button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<div id="jqgrid">
				<table id="list"></table>
			</div>
		</td>
	</tr>
</table>
<!-------------------------------- Dialog Div Start -------------------------------->
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>      
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>