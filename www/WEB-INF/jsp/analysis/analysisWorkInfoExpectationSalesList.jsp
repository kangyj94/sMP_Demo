<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList    = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto        userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String              menuId      = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	//현재년도 받아오기
	String getYear  = CommonUtils.getCurrentDate().substring(0, 4);
	String getMonth = CommonUtils.getCurrentDate().substring(5, 7);
	
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-350 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
.ui-jqgrid .ui-jqgrid-htable th div {
	white-space:normal !important; height:auto !important; padding:2px;
}
</style>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">

$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');

var jq = jQuery;

$(document).ready(function(){
	$("#srcButton").click(function(){ fnSearch(); }); //검색

	$("#srcSummaryList").click( function() { fnDynamicForm("/analysis/analysisSummaryList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
	$("#srcMonthSalesList").click( function() { fnDynamicForm("/analysis/analysisYearSalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
	$("#srcTypeSalesList").click( function() { fnDynamicForm("/analysis/analysisMonthSalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
	$("#srcOrderSalesList").click( function() { fnDynamicForm("/analysis/analysisWorkInfoExpectationSalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
	$("#srcDaySalesList").click( function() { fnDynamicForm("/analysis/analysisWeekDaySalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });	

	$("#excelButton").click(function(){ exportExcel(); }); //엑셀다운
	$("#srcResultYear").val("<%=getYear%>");
	$("#srcResultMonth").val("<%=getMonth%>");
//  	srcSalesYear();//실적년도 셀렉트박스  select box hidden 처리 
});

jq(function() { 
	var prevCellVal1 = { cellId: undefined, value: undefined };
	var prevCellVal2 = { cellId: undefined, value: undefined };
	
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisWorkInfoExpectationSalesListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:[
			'공사자재',	'고객유형',	'총계',		'주문요청',	'주문의뢰',
			'주문접수',	'배송',		'인수완료',	'반품완료'
		],
		colModel:[
			{name:'codeNmMid', index:'codeNmMid', width:120, align:'left', search:false, sortable:false, editable:false,
				cellattr: function (rowId, val, rawObject, cm, rdata){
					var result;
					
					if (prevCellVal2.value == val) {
						result = ' style="display: none" rowspanid="' + prevCellVal2.cellId + '"';
					}
					else {
						var cellId = this.id + '_row_' + rowId + '_' + cm.name;
						
						result = ' rowspan="1" id="' + cellId + '"';
						prevCellVal2 = { cellId: cellId, value: val };
					}
					
					return result;
				}	
			},//자재유형
			{ name:'worknm', index:'worknm', width:250, align:'left', search:false, sortable:false, editable:false},//고객유형
			{ name:'summary_tota_amou', index:'summary_tota_amou', width:150, align:'right', search:false, sortable:false, editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//총계
			{ name:'order_request', index:'order_request', width:150, align:'right', search:false, sortable:false, editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//주문요청
			{ name:'purchase_request', index:'purchase_request', width:150, align:'right', search:false, sortable:false, editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//승인요청
			
			{ name:'purchase_order', index:'purchase_order', width:150, align:'right', search:false, sortable:false, editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//주문접수
			{ name:'consignment', index:'consignment', width:150, align:'right', search:false, sortable:false, editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//배송
			{ name:'receive_list', index:'receive_list', width:150, align:'right', search:false, sortable:false, editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },//인수완료
			{ name:'receive_return', index:'receive_return', width:150, align:'right', search:false, sortable:false, editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }}//반품완료
		],
		postData:{
			srcResultYear:$("#srcResultYear").val(),
			srcResultMonth:$("#srcResultMonth").val()
		},
		rowNum:0, rownumbers: false, 
		height: <%=listHeight %>, width: 1500,
		sortname: '', sortorder: '',
		caption:"",
		viewrecords:true, emptyrecords: 'Empty Records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function(rowid) {
			var grid = this;
			
			$('td[rowspan="1"]', grid).each(function () {
				var spans = $('td[rowspanid="' + this.id + '"]', grid).length + 1;
				
				if (spans > 1) {
					$(this).attr('rowspan', spans);
				}
			});

			fnTotalAmountSum(); //총계 누계 합 펑션
				
			var month = $("#list").getGridParam('userData'); //월 파라미터받아오기
			
			$(".monthWorkInfo_month").html(month.srcResultMonth);
		},
		cellattr: function(rowId, val, rawObject, cm, rdata) {},
		onSelectRow: function(rowid, iRow, iCol, e) {},
		ondblClickRow: function(rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target) {},
		afterInsertRow: function(rowid, aData){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader: {root: "list", repeatitems: false, cell: "cell",userdata:"userdata"}
	});
});

//년월일 셀렉트박스
function srcSalesYear() {
	var getYear = "<%=getYear%>";
	
	for(var i=getYear; i>=2010;i--){
		$("#srcResultYear").append("<option value='"+i+"'>"+i+"</option>");
	}
	
	for(var j=1; j<13;j++){
		var strMonth = "";
		
		if(j<10){
			strMonth = "0"+j; 
		}
		else{
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
	var colLabels = [
		'공사자재',	'고객유형',	'총계',		'주문요청',	'주문의뢰',
		'주문접수',	'배송',		'인수완료',	'반품완료'
	];	//출력컬럼명
	var colIds = [
		'codeNmMid',      'worknm',      'summary_tota_amou', 'order_request', 'purchase_request',
		'purchase_order', 'consignment', 'receive_list',      'receive_return'
	];
	var numColIds = [
		'summary_tota_amou', 'order_request', 'purchase_request', 'purchase_order', 'consignment',
		'receive_list',      'receive_return'
	];	//숫자표현ID
	var figureColIds = [];
	var month = $("#list").getGridParam('userData');
	var sheetTitle = "고객유형별 예상실적";	//sheet 타이틀
	var excelFileName = "analysisWorkInfoList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function fnTotalAmountSum() {
	var rowCnt = jq("#list").getGridParam('reccount');
	var SumTotalamount = [];
	
	if(rowCnt>0) {
		for(var j=1; j<8; j++) {
			var sum = 0 ;
			var mm = "";
			
			switch (j) {
				case 1: mm = "summary_tota_amou"; break;
				case 2: mm = "order_request";     break;
				case 3: mm = "purchase_request";  break;
				case 4: mm = "purchase_order";    break;
				case 5: mm = "consignment";       break;
				case 6: mm = "receive_list";      break;
				case 7: mm = "receive_return";    break;
			}
				
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				
				sum += Number(jq("#list").jqGrid('getRowData',rowid)[mm]);
			}
			
			SumTotalamount.push(sum);
		}
		
		var rowCnt = jq("#list").getGridParam('reccount');
		
		if(rowCnt > 0){
			jq("#list").addRowData(rowCnt + 1,{
				codeNmMid         : "총계",
				worknm            : "",
				summary_tota_amou : SumTotalamount[0],
				order_request     : SumTotalamount[1],
				purchase_request  : SumTotalamount[2],
				purchase_order    : SumTotalamount[3],
				consignment       : SumTotalamount[4],
				receive_list      : SumTotalamount[5],
				receive_return    : SumTotalamount[6]
			});
		}
		
		var rowCnt = jq("#list").getGridParam('reccount');
		
		if(rowCnt > 0){
			jq("#list").addRowData(rowCnt + 1,{
				codeNmMid         : "누계",
				worknm            : "",
				summary_tota_amou : SumTotalamount[0],
				order_request     : SumTotalamount[1],
				purchase_request  : SumTotalamount[1] + SumTotalamount[2],
				purchase_order    : SumTotalamount[1] + SumTotalamount[2] + SumTotalamount[3],
				consignment       : SumTotalamount[1] + SumTotalamount[2] + SumTotalamount[3] + SumTotalamount[4],
				receive_list      : SumTotalamount[1] + SumTotalamount[2] + SumTotalamount[3] + SumTotalamount[4] + SumTotalamount[5],
				receive_return    : SumTotalamount[1] + SumTotalamount[2] + SumTotalamount[3] + SumTotalamount[4] + SumTotalamount[5] + SumTotalamount[6]
			});
		}
	}
	else {
		fnClearTotalAmountSum();
	}
}

function fnClearTotalAmountSum() {
	//jq("#list").jqGrid("footerData","set",{ codeNmTop:'합계',last_month:'0',new_last_month:'0',spot_month:'0',new_spot_month:'0',total_month:'0',new_total_month:'0'},false);
}
	
function fnComma(n) {
	n += '';
	
	var reg = /(^[+-]?\d+)(\d{3})/;
	
	while (reg.test(n)) {
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	
	return n;
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
					<td height="29" class="ptitle">고객유형별 월 예상실적</td>
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
						<%=getYear%>년 <%=getMonth%>월
						<input type="hidden" id="srcResultYear" name="srcResultYear" value="<%=getYear%>"/> 
						<input type="hidden" id="srcResultMonth" name="srcResultMonth" value="<%=getMonth%>"/> 
						 
<!--  						<select id="srcResultYear" name="srcResultYear" class="select"  style="display: none;"></select>년 -->
<!--  						<select id="srcResultMonth" name="srcResultMonth" class="select"  style="display: none;"></select>월  -->
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