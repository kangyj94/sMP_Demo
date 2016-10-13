<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList    = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto        userInfoDto = CommonUtils.getLoginUserDto(request);
	String              menuId      = CommonUtils.getRequestMenuId(request);
	String              getYear     = CommonUtils.getCurrentDate().substring(0, 4); //현재년도 받아오기
	String              getMonth    = CommonUtils.getCurrentDate().substring(5, 7);
	String              listHeight  = "$(window).height()-380 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
	String              listWidth   = "1500";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');

var month = "";
var jq    = jQuery;

$(document).ready(function(){
	fnInitEvent();  // 페이지 이벤트 초기화
	srcSalesYear(); // 실적년도 셀렉트박스
});

function fnInitEvent(){
	$("#srcSummaryList").click(function(){
		fnDynamicForm("/analysis/analysisSummaryList.sys?_menuCd=ADM_ANAL_SUM", "","");
	});
	
	$("#srcMonthSalesList").click(function(){
		fnDynamicForm("/analysis/analysisYearSalesList.sys?_menuCd=ADM_ANAL_SUM", "","");
	});
	
	$("#srcTypeSalesList").click(function(){
		fnDynamicForm("/analysis/analysisMonthSalesList.sys?_menuCd=ADM_ANAL_SUM", "","");
	});
	
	$("#srcOrderSalesList").click(function(){
		fnDynamicForm("/analysis/analysisWorkInfoExpectationSalesList.sys?_menuCd=ADM_ANAL_SUM", "","");
	});
	
	$("#srcDaySalesList").click( function(){
		fnDynamicForm("/analysis/analysisWeekDaySalesList.sys?_menuCd=ADM_ANAL_SUM", "","");
	});
	
	$("#srcButton").click(function(){
		fnSearch();
	}); //검색
	
	$("#excelButton").click(function(){
		exportExcel();
	}); //엑셀다운
}

</script>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'/analysis/analysisWeekDaySalesListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:[
			'일자',		'요일',		'주문실적',	'출하실적',	'인수실적',
			'매출이익',	'자동인수',	'수동인수',	'자동인수',	'수동인수',
			'입금액',		'입금비중(%)',	'해당 월',		'현금',		'어음',
			'상계'
		],
		colModel:[
			{name:'src_day',               index:'src_day',               width:30,  align:'center', search:false, sortable:false, editable:false},//일자
			{name:'week_day',              index:'week_day',              width:50,  align:'center', search:false, sortable:false, editable:false},//요일
			{name:'order_amount',          index:'order_amount',          width:100, align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//주문실적
			{name:'invoice_amount',        index:'invoice_amount',        width:100, align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//출하실적
			{name:'receive_amount',        index:'receive_amount',        width:100, align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//인수실적
			
			{name:'profit_amount',         index:'profit_amount',         width:100, align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//매출이익
			{name:'auto_receive_amount',   index:'auto_receive_amount',   width:100, align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//자동인수
			{name:'menu_receive_amount',   index:'menu_receive_amount',   width:100, align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//수동인수
			{name:'auto_sale_amount',      index:'auto_sale_amount',      width:80,  align:"right",  search:false, sortable:false, editable:false},//자동인수 비중
			{name:'menu_sale_amount',      index:'menu_sale_amount',      width:80,  align:"right",  search:false, sortable:false, editable:false},//수동인수 비중
			
			{name:'rece_pay_amou',         index:'rece_pay_amou',         width:100, align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//입금액
			{name:'rece_pay_amou_percent', index:'rece_pay_amou_percent', width:80,  align:"right",  search:false, sortable:false, editable:false},//입금비중
			{name:'src_month',             index:'src_month',             hidden:true},			//해당 월
			{name:'rece_pay_amou_cash',    index:'rece_pay_amou_cash',    width:100, align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//현금
			{name:'rece_pay_amou_bill',    index:'rece_pay_amou_billl',   width:100, align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//어음
			
			{name:'rece_pay_amou_setoff',  index:'rece_pay_amou_setoff',  width:100, align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}}//상계
		],
		postData:{
			srcResultYear:$("#srcResultYear").val(),
			srcResultMonth:$("#srcResultMonth").val()
		},
		rowNum:0, rownumbers: false,
		height: 650, width: 1500,
		caption:"",
		viewrecords:true, emptyrecords: 'Empty Records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function(rowid) {
			var rowid = $("#list").getDataIDs()[0];
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			month = selrowContent.src_month;
			$(".week_month").html(month);
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i = 0; i < rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					jq("#list").jqGrid('setRowData', rowid, {auto_sale_amount:selrowContent.auto_sale_amount+" %"});
					jq("#list").jqGrid('setRowData', rowid, {menu_sale_amount:selrowContent.menu_sale_amount+" %"});
				}
			}
			weekDaySum();
		},
		cellattr: function(rowId, val, rawObject, cm, rdata) {},
		onSelectRow: function(rowid, iRow, iCol, e) {},
		ondblClickRow: function(rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target) {},
		afterInsertRow: function(rowid, aData){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader: {root: "list", repeatitems: false, cell: "cell"}
	});
	jq("#list").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
			groupHeaders:[
				{startColumnName: 'week_day', numberOfColumns: 5, titleText: '<span class="week_month"></span>월 실적현황'},
				{startColumnName: 'auto_receive_amount', numberOfColumns: 2, titleText: '<span class="week_month"></span>월 인수 실적'},
				{startColumnName: 'auto_sale_amount', numberOfColumns: 2, titleText: '<span class="week_month"></span>월 인수 비중(%)'},
				{startColumnName: 'rece_pay_amou', numberOfColumns: 6, titleText: '<span class="week_month"></span>월 입금 내역'}
			]
	});

});
</script>
<script type="text/javascript">
	//실적년도 셀렉트박스
	function srcSalesYear() {
		var getYear = "<%=getYear%>";
		for(var i=getYear; i>=2014;i--){
			$("#srcResultYear").append("<option value='"+i+"'>"+i+"</option>");
		}
		for(var j=1; j<13;j++){
			var strMonth = "";
			if(j<10){
				strMonth = "0"+j; 
			}else{
				strMonth = j; 
			}
			$("#srcResultMonth").append("<option value='"+strMonth+"'>"+strMonth+"</option>");
		}
		$("#srcResultYear").val(getYear);
		$("#srcResultMonth").val('<%=getMonth%>');
	}
	
	//검색 펑션
	function fnSearch() {
		var data = jq("#list").jqGrid("getGridParam", "postData");
		data.srcResultYear = $("#srcResultYear").val();
		data.srcResultMonth = $("#srcResultMonth").val();
		jq("#list").jqGrid("setGridParam", { "postData": data });
		jq("#list").trigger("reloadGrid");
	}
	
	//엑셀다운
	function exportExcel() {
	var rowid = $("#list").getDataIDs()[0];
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	var month = selrowContent.src_month;
	var colLabels = ['일자','요일','주문 실적','출하 실적','인수 실적','매출 이익','자동 인수','수동 인수','자동인수 비중','수동인수 비중','입금액','입금비중'];	//출력컬럼명
	var colIds = ['src_day','week_day','order_amount','invoice_amount','receive_amount','profit_amount','auto_receive_amount','menu_receive_amount','auto_sale_amount','menu_sale_amount','rece_pay_amou','rece_pay_amou_percent'];	//출력컬럼ID
	var numColIds = ['order_amount','invoice_amount','receive_amount','profit_amount','auto_receive_amount','menu_receive_amount'];	//숫자표현ID
	var sheetTitle = month+"월 주문,출하,인수 실적";	//sheet 타이틀
	var excelFileName = "analysisWeekDaySales";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
	}

//일자별 합계
function weekDaySum(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0){
		var totalOrderAmount = 0;//주문실적
		var totalInvoiceAmount = 0;//출하실적
		var totalReceiveAmount = 0;//인수실적
		var totalAutoReceiveAmount = 0;//자동인수실적
		var totalMenuReceiveAmonut = 0;//수동인수실적
		var totalRecePayAmonut = 0;//입금액
		var auto_sale_amount = 0;//자동인수
		var menu_sale_amount = 0;//수동인수
		var flag = false;//입금비중 상태값
		var totalRecePayAmouPercent = 0.00;
		var rece_pay_amou_cash = 0;//현금입금
		var rece_pay_amou_bill = 0;//어음입금
		var rece_pay_amou_setoff = 0;//상계입금
		
		
		//금액합계
		for(var i=0; i<rowCnt;i++){
			var rowId = jq("#list").getDataIDs()[i];
			var selowContent = jq("#list").jqGrid('getRowData', rowId);
			totalOrderAmount += parseInt(selowContent.order_amount);//주문
			totalInvoiceAmount += parseInt(selowContent.invoice_amount);//출하
			totalReceiveAmount += parseInt(selowContent.receive_amount);//인수
			totalAutoReceiveAmount += parseInt(selowContent.auto_receive_amount);//자동인수
			totalMenuReceiveAmonut += parseInt(selowContent.menu_receive_amount);//수동인수
			totalRecePayAmonut += parseInt(selowContent.rece_pay_amou);//입금액
			rece_pay_amou_cash += parseInt(selowContent.rece_pay_amou_cash);//자동인수
			rece_pay_amou_bill += parseInt(selowContent.rece_pay_amou_bill);//수동인수
			rece_pay_amou_setoff += parseInt(selowContent.rece_pay_amou_setoff);//입금액
		}
		
		//입금비중
		for(var i=0; i<rowCnt; i++){
			var rowId = jq("#list").getDataIDs()[i];
			var selowContent = jq("#list").jqGrid('getRowData', rowId);
			var recePayAmouPercent = 0;
			recePayAmouPercent = parseInt(selowContent.rece_pay_amou)/parseInt(totalRecePayAmonut) * 100;
			if(isNaN(recePayAmouPercent)){
				recePayAmouPercent = 0;
			}
			jq("#list").jqGrid('setRowData', rowId, {rece_pay_amou_percent:''+recePayAmouPercent.toFixed(1)+' %'});
			//입금비중 퍼센트 합계
			if(recePayAmouPercent > 0){
				flag = true;
				totalRecePayAmouPercent = 100;
			}
		}
		auto_sale_amount = totalAutoReceiveAmount/(totalAutoReceiveAmount+totalMenuReceiveAmonut) * 100;//합계 자동인수
		menu_sale_amount = totalMenuReceiveAmonut/(totalAutoReceiveAmount+totalMenuReceiveAmonut) * 100;//합계 수동인수
		if(isNaN(auto_sale_amount)){
			auto_sale_amount = 0;
		}
		if(isNaN(menu_sale_amount)){
			menu_sale_amount = 0;
		}
		//합계ROW추가
		jq("#list").addRowData(rowCnt + 1,{
			src_day:'합계',
			week_day:'',
			order_amount:totalOrderAmount,
			invoice_amount:totalInvoiceAmount,
			receive_amount:totalReceiveAmount,
			auto_receive_amount:totalAutoReceiveAmount,
			menu_receive_amount:totalMenuReceiveAmonut,
			auto_sale_amount:''+auto_sale_amount.toFixed(2)+' %',
			menu_sale_amount:''+menu_sale_amount.toFixed(2)+' %',
			rece_pay_amou:totalRecePayAmonut,
			rece_pay_amou_percent:''+totalRecePayAmouPercent.toFixed(2)+' %',
			rece_pay_amou_cash:rece_pay_amou_cash,
			rece_pay_amou_bill:rece_pay_amou_bill,
			rece_pay_amou_setoff:rece_pay_amou_setoff
		});
	}
	
}
	
</script>

</head>
<body>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<form id="frm" name="frm" method="post">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
					<td height="29" class="ptitle">일자별 주문/출하/인수/입금 실적</td>
					<td align="right" class="ptitle">
						<a id='srcSummaryList' class="btn btn-default btn-sm"><i class="fa fa-search"> 경영정보</i></a>
						<a id='srcMonthSalesList' class="btn btn-default btn-sm"><i class="fa fa-search"> 월별</i></a>
						<a id='srcTypeSalesList' class="btn btn-default btn-sm"><i class="fa fa-search"> 자재유형별</i></a>
						<a id='srcOrderSalesList' class="btn btn-default btn-sm"><i class="fa fa-search"> 주문상태별</i></a>
						<a id='srcDaySalesList' class="btn btn-default btn-sm"><i class="fa fa-search"> 일자별</i></a>
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
					<td class="table_td_subject" width="90">실적년월</td>
					<td class="table_td_contents" width="250" colspan="5">
						<select id="srcResultYear" name="srcResultYear" class="select"></select>년
						<select id="srcResultMonth" name="srcResultMonth" class="select"></select>월
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
	<tr>
		<td valign="top" width="610" height="18" align="right">
			<a id='srcButton' class='btn btn-default btn-xs' ><i class="fa fa-search"></i> 조회</a>
			<a id='excelButton' class='btn btn-default btn-xs' ><i class="fa fa-search"></i> 엑셀</a>
		</td>
	</tr>
	<tr>
		<td height="5px"></td>
	</tr>	
	<tr>
		<td>
			<table id="list"></table>
		</td>
	</tr>
</table>
</form>
</body>
</html>