<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%@ page import="java.lang.*"%>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-355 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	@SuppressWarnings("unchecked")	// 주문유형
	List<CodesDto> orderStatusCode = (List<CodesDto>)request.getAttribute("codeList");
	
	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");
	
	LoginUserDto	loginUserDto		= (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean			isVendor			= loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
	boolean			isAdm				= loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;
	// 날짜 세팅
	String			srcPurcStartDate	= CommonUtils.getCustomDay("DAY", -7);
	String			srcPurcEndDate		= CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<%
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp" %>
<!-- 공급사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcVendorName = "";
	String _srcVendorId = "";
	if("VEN".equals(loginUserDto.getSvcTypeCd())) {
		_srcVendorName = loginUserDto.getBorgNm();
		_srcVendorId = loginUserDto.getBorgId();
	}
%>
	$("#srcVendorName").val("<%=_srcVendorName%>");
	$("#srcVendorId").val("<%=_srcVendorId%>");
<%	if("VEN".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#srcVendorName").attr("disabled", true);
	$("#btnVendor").css("display","none");
<%	}	%>

	$("#btnVendor").click(function(){
		var vendorNm = $("#srcVendorName").val();
		fnVendorDialog(vendorNm, "fnCallBackVendor"); 
	});
	$("#srcVendorName").keydown(function(e){ if(e.keyCode==13) { $("#btnVendor").click(); } });
	$("#srcVendorName").change(function(e){
		if($("#srcVendorName").val()=="") {
			$("#srcVendorId").val("");
		}
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackVendor(vendorId, vendorNm, areaType) {
	$("#srcVendorId").val(vendorId);
	$("#srcVendorName").val(vendorNm);
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	
	$("#srcOrdeIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcButton").click(function(){ 
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcPurcStartDate").val($.trim($("#srcPurcStartDate").val()));
		$("#srcPurcEndDate").val($.trim($("#srcPurcEndDate").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnSearch(); 
	});
	$("#allExcelButton").click(function(){ 
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcPurcStartDate").val($.trim($("#srcPurcStartDate").val()));
		$("#srcPurcEndDate").val($.trim($("#srcPurcEndDate").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnSearchPurcResultListExcelView(); 
	});
	
	// 날짜 세팅
	$("#srcPurcStartDate").val("<%=srcPurcStartDate%>");
	$("#srcPurcEndDate").val("<%=srcPurcEndDate%>");
	
	// 날짜 조회 및 스타일
	$(function(){
		$("#srcPurcStartDate").datepicker({
			showOn: "button",
			buttonImage: "/img/system/btn_icon_calendar.gif",
			buttonImageOnly: true,
			dateFormat: "yy-mm-dd"
		});
		$("#srcPurcEndDate").datepicker({
			showOn: "button",
			buttonImage: "/img/system/btn_icon_calendar.gif",
			buttonImageOnly: true,
			dateFormat: "yy-mm-dd"
		});
		$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
	});
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/purchase/selectPurchaseResultList.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['발주일','납품요청일','배송정보입력일','인수일','고객유형','주문번호','상품명','규격','대표규격','발주차수','출하차수','인수차수','정산번호','주문명','주문유형','주문상태','고객사','공급사','주문자','인수자','인수자 전화번호','발주수량','단가','금액','취소사유','세금계산서일자','vendorId','branchId','sum_total_sale_unit_pric', 'sum_orde_requ_quan'],
		colModel:[
			{name:'clin_date',index:'clin_date', width:100,align:"center",search:false,sortable:true, editable:false },//발주일
			{name:'requ_deli_date',index:'requ_deli_date', width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'invoiceDate',index:'invoiceDate', width:90,align:"center",search:false,sortable:true, editable:false },//배송정보입력일
			{name:'rece_regi_date',index:'rece_regi_date', width:80,align:"center",search:false,sortable:true, editable:false },//인수일
			{name:'worknm',index:'worknm', width:120,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"center",search:false,sortable:true, editable:false },
			{name:'good_name',index:'good_name', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'good_spec_desc',index:'good_spec_desc', width:130,align:"left",search:false,sortable:true, editable:false },
			{name:'good_st_spec_desc',index:'good_st_spec_desc', hidden:true,align:"left",search:false,sortable:true, editable:false },
			{name:'purc_iden_numb',index:'purc_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'deli_iden_numb',index:'deli_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'rece_iden_numb',index:'rece_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'buyi_sequ_numb',index:'buyi_sequ_numb', width:60,align:"right",search:false,sortable:true, editable:false },
			{name:'cons_iden_name',index:'cons_iden_name', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_type_clas',index:'orde_type_clas', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'stat_falg',index:'stat_falg', width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'branchnm',index:'branchnm', width:120,align:"left",search:false,sortable:true, editable:false },
			{name:'vendornm',index:'vendornm', width:120,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_user_id',index:'orde_user_id', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'tran_user_name',index:'tran_user_name', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'tran_tele_numb',index:'tran_tele_numb', width:90,align:"right",search:false,sortable:true, editable:false },
			{name:'purc_requ_quan',index:'purc_requ_quan', width:50,align:"right",search:false,sortable:true, editable:false ,formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//수량
			{name:'sale_unit_pric',index:'sale_unit_pric', width:80,align:"right",search:false,sortable:true, editable:false ,formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//단가
			{name:'tot_sale_unit_pric',index:'tot_sale_unit_pric', width:90,align:"right",search:false,sortable:true, editable:false ,formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//금액
			{name:'cancel_reason',index:'cancel_reason', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'clos_buyi_date',index:'clos_buyi_date',width:100,align:'center',search:false,sortable:true, editable:false},//공급사 세금계산서 일자
			{name:'vendorid',index:'vendorid', search:false, hidden:true},
			{name:'branchId',index:'branchId', search:false, hidden:true},
			{name:'sum_total_sale_unit_pric',index:'sum_total_sale_unit_pric', hidden:true, search:false,sortable:true, editable:false},
			{name:'sum_orde_requ_quan',index:'sum_orde_requ_quan', hidden:true, search:false,sortable:true, editable:false}
		],  
		postData: {
			srcVendorId:$('#srcVendorId').val()
			,srcPurcStartDate:$('#srcPurcStartDate').val()
			,srcPurcEndDate:$('#srcPurcEndDate').val()
			,srcGoodName:$('#srcGoodName').val()
			,srcOrdeIdenNumb:$('#srcOrdeIdenNumb').val()
<%if(isAdm){%>
			,srcWorkInfoUser:$('#srcWorkInfoUser').val()
<%	}	%>
		},multiselect:false ,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		sortname: 'clin_date', sortorder: "desc", 
		height: <%=listHeight%>,width:<%=listWidth%>,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				//총건수 및 금액 합계
				if(idx == 0){
					var total_record = fnComma(Number(jq("#list").getGridParam('records')));
					var tempPric = fnComma(Number(selrowContent.sum_total_sale_unit_pric));
					var tempPric2 = fnComma(Number(selrowContent.sum_orde_requ_quan));
					tempPric = "<b>총 "+total_record+" 건의 발주 총수량 : " + tempPric2 + " , 금액 합계 : "+ tempPric+" 원 </b>";
					$("#total_sum_pric").html(tempPric);
				}
			}
		},
		afterInsertRow: function(rowid, aData){
<%if(isAdm){%>
			$("#list").setCell(rowid,'branchnm','',{color:'#0000ff'});
			$("#list").setCell(rowid,'branchnm','',{cursor: 'pointer'});
			$("#list").setCell(rowid,'vendornm','',{color:'#0000ff'});
			$("#list").setCell(rowid,'vendornm','',{cursor: 'pointer'});
<%}	%>
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {tran_tele_numb: fnSetTelformat(selrowContent.tran_tele_numb)});
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
<%if(isAdm){%>
			//구매사 상세 팝업
			if(colName != undefined &&colName['index']=="branchnm") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBranchDetailView("+_menuId+", selrowContent.branchId);")%>
			}
			//공급사 상세 팝업
			if(colName != undefined &&colName['index']=="vendornm") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.vendorid);")%>
			}
<%}%>
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch(){
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcVendorId= $("#srcVendorId").val();
	data.srcPurcStartDate= $("#srcPurcStartDate").val();
	data.srcPurcEndDate= $("#srcPurcEndDate").val();
	data.srcOrdeIdenNumb= $("#srcOrdeIdenNumb").val();
	data.srcOrdeStatFlag= $("#srcOrdeStatFlag").val();
	data.srcGoodName= $("#srcGoodName").val();
	data.srcWorkInfoUser = $("#srcWorkInfoUser").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
/** list Excel Export */
function exportExcel() {
	var colLabels = ['발주일','납품요청일','배송정보입력일','인수일','고객유형','주문번호','상품명','규격','발주차수','출하차수','인수차수','정산번호','주문명','주문유형','주문상태','고객사','공급사','주문자','인수자','인수자 전화번호','발주수량','단가','금액','취소사유','세금계산서일자'];
	var colIds = ['clin_date', 'requ_deli_date','invoiceDate', 'rece_regi_date','worknm', 'orde_iden_numb', 'good_name', 'good_spec_desc', 'purc_iden_numb', 'deli_iden_numb', 'rece_iden_numb', 'buyi_sequ_numb', 'cons_iden_name', 'orde_type_clas', 'stat_falg', 'branchnm', 'vendornm', 'orde_user_id', 'tran_user_name', 'tran_tele_numb', 'purc_requ_quan', 'sale_unit_pric', 'tot_sale_unit_pric', 'cancel_reason','clos_buyi_date'];
	var numColIds = ['purc_requ_quan','sale_unit_pric','tot_sale_unit_pric'];	
	var figureColIds = ['purc_iden_numb', 'deli_iden_numb', 'rece_iden_numb', 'buyi_sequ_numb'];
	var sheetTitle = "발주이력";	
	var excelFileName = "purchaseResultList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function fnSearchPurcResultListExcelView(){
	var colLabels = ['발주일','납품요청일','배송정보입력일','인수일','고객유형',
	                 '주문번호','상품명','규격','발주차수','출하차수',
	                 '인수차수','정산번호','주문명','주문유형','주문상태',
	                 '고객사','공급사','주문자','인수자','인수자 전화번호',
	                 '발주수량','단가','금액','취소사유','세금계산서일자'];
	var colIds = ['CLIN_DATE', 'REQU_DELI_DATE', 'INVOICEDATE', 'RECE_REGI_DATE', 'WORKNM', 
	              'ORDE_IDEN_NUMB', 'GOOD_NAME', 'GOOD_SPEC_DESC', 'PURC_IDEN_NUMB', 'DELI_IDEN_NUMB', 
	              'RECE_IDEN_NUMB', 'BUYI_SEQU_NUMB', 'CONS_IDEN_NAME', 'ORDE_TYPE_CLAS', 'STAT_FALG',
	              'BRANCHNM', 'VENDORNM', 'ORDE_USER_ID', 'TRAN_USER_NAME', 'TRAN_TELE_NUMB', 
	              'PURC_REQU_QUAN', 'SALE_UNIT_PRIC', 'TOT_SALE_UNIT_PRIC', 'CANCEL_REASON','CLOS_BUYI_DATE'];
	var numColIds = ['PURC_REQU_QUAN','SALE_UNIT_PRIC','TOT_SALE_UNIT_PRIC'];	
	var figureColIds = ['PURC_IDEN_NUMB', 'DELI_IDEN_NUMB', 'RECE_IDEN_NUMB', 'BUYI_SEQU_NUMB'];
	var sheetTitle = "발주이력";	
	var excelFileName = "purchaseResultList";	//file명
	
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcVendorId';
    fieldSearchParamArray[1] = 'srcPurcStartDate';
    fieldSearchParamArray[2] = 'srcPurcEndDate';
    fieldSearchParamArray[3] = 'srcOrdeIdenNumb';
    fieldSearchParamArray[4] = 'srcOrdeStatFlag';
    fieldSearchParamArray[5] = 'srcGoodName';
    fieldSearchParamArray[6] = 'srcWorkInfoUser';
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/purchase/purchaseResultListExcelView.sys", figureColIds);  
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//발주이력
	header = "발주이력";
	manualPath = "/img/manual/vendor/purchaseResultList.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}

//3자리수마다 콤마
function fnComma(n) {
	 n += '';
	 var reg = /(^[+-]?\d+)(\d{3})/;
	 while (reg.test(n)){
		 n = n.replace(reg, '$1' + ',' + '$2');
	 }
	 return n;
}

</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top" style="height: 29px">
					<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
					<td class='ptitle'>발주이력
					<%if(isVendor){ %>
						&nbsp;<span id="question" class="questionButton">도움말</span>
					<%} %>
					</td>
					<td align="right" class='ptitle'>
						<button id='allExcelButton' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr> 
				<tr>
					<td class="table_td_subject" width="100">공급사</td>
					<td class="table_td_contents">
						<input id="srcVendorName" name="srcVendorName" type="text" value="" size="" maxlength="50" style="width: 150px" />&nbsp;<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18"  style="vertical-align: middle; cursor: pointer;" /><input type="hidden" id="srcVendorId" name="srcVendorId" value=""/></td>
					<td width="100" class="table_td_subject">발주의뢰일자</td>
					<td class="table_td_contents">
						<input type="text" name="srcPurcStartDate" id="srcPurcStartDate" style="width: 75px;vertical-align: middle;" /> 
						~ 
						<input type="text" name="srcPurcEndDate" id="srcPurcEndDate" style="width: 75px;vertical-align: middle;" />
					</td>
					<td width="100" class="table_td_subject">주문번호</td>
					<td class="table_td_contents"><input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="" maxlength="50" style="width: 100px" /></td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">주문상태</td>
					<td class="table_td_contents">
						<select id="srcOrdeStatFlag" name="srcOrdeStatFlag" class="select">
							<option value="">전체</option>
<%
	if (orderStatusCode.size() > 0 ) {
		CodesDto cdData = null;
		for (int i = 0; i < orderStatusCode.size(); i++) {
			cdData = orderStatusCode.get(i); 
			if(Integer.parseInt(cdData.getCodeVal1()) < 40){
				continue;
			}
%>
							<option value="<%=cdData.getCodeVal1()%>"  ><%=cdData.getCodeNm1()%></option>
<% } } %>
						</select>
					</td>
					<td width="100" class="table_td_subject">상품명</td>
					<td class="table_td_contents">
						<input type="text" name="srcGoodName" id="srcGoodName" style="width: 150px;vertical-align: middle;" /> 
					</td>
<%	if(isAdm){ %>
					<td class="table_td_subject" width="100">담당자</td>
					<td class="table_td_contents" colspan="5">
						<select id="srcWorkInfoUser" name="srcWorkInfoUser" class="select">
							<option value="">전체</option>
<% 	
		if(isAdm && workInfoList != null){
			if (workInfoList.size() > 0 ) {
				SmpUsersDto sud = null;
				for (int i = 0; i < workInfoList.size(); i++) {
					sud = workInfoList.get(i); 
					String _selected = "";
					if(loginUserDto.getUserId().equals(sud.getUserId())) _selected="selected";
%>
							<option value="<%=sud.getUserId()%>" <%=_selected %>><%=sud.getUserNm()%></option>
<%				}
			}
		}
%>
						</select>
					</td>
<%	}%>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="10"></td>
	</tr>
	<tr>
		<td align="right">
			<a href="javascript:processPurcReceive();">
				<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_accept.gif" width="75" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
			</a>
			<a href="javascript:fnPurcReject();">
				<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_purcRejection.gif" width="75" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
			</a>
			<span id="total_sum_pric"></span>&nbsp;
		</td>
	</tr>
	<tr>
		<td>
			<div id="jqgrid">
				<table id="list"></table>
				<div id="pager"></div>
			</div>
		</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<%@ include file="/WEB-INF/jsp/common/svcStatChangeReasonDiv.jsp" %>
</form>
</body>
</html>