<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	//현재년도 받아오기
	String getYear = CommonUtils.getCurrentDate().substring(0, 4);
	String getMonth = CommonUtils.getCurrentDate().substring(5, 7);
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-380 + Number(gridHeightResizePlus)";
	String listWidth = "1500";
%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css">
.table_top_line_new {background-color:#1D8ABE; height:1px}

</style>
<body>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />

<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table style="width: 1500px; border: 0px;">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>당월 매출현황</td>
					<td align="right" class="ptitle">
						<a id='srcSummaryList' class="btn btn-default btn-sm"><i class="fa fa-search"> 경영정보</i></a>
						<a id='srcMonthSalesList' class="btn btn-default btn-sm"><i class="fa fa-search"> 월별</i></a>
						<a id='srcTypeSalesList' class="btn btn-default btn-sm"><i class="fa fa-search"> 자재유형별</i></a>
						<a id='srcOrderSalesList' class="btn btn-default btn-sm"><i class="fa fa-search"> 주문상태별</i></a>
						<a id='srcDaySalesList' class="btn btn-default btn-sm"><i class="fa fa-search"> 일자별</i></a>
					</td>
				</tr>
			</table>
			
			<!-- Search Context -->
			<table style="width: 100%;border: 0px;">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="180">
						<select name="srcDateFlag" id="srcDateFlag">
							<option value="1">인수일자 기준</option>
							<option value="">세금계산서일자 기준</option>
						</select>
					</td>
					<td class="table_td_contents" width="150">
						<select name="srcResultYear" id="srcResultYear"></select>년&nbsp;&nbsp;
						<select name="srcResultMonth" id="srcResultMonth"></select>월
					</td>
					<td class="table_td_contents" colspan="4">
						<a href="#">
<!-- 							<a id='srcButton' class="btn btn-default btn-xs"><i class="fa fa-search"> 조회</i></a> -->
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='8'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top" width="610" height="18" align="right">
			<a href="#">
				<a id='srcButton' class='btn btn-default btn-xs' ><i class="fa fa-search"></i> 조회</a>
				<a id='excelButton' class='btn btn-default btn-xs' ><i class="fa fa-search"></i> 엑셀</a>
			</a>
		</td>
	</tr>
	<tr>
		<td height="5px" ></td>
	</tr>
	<tr>
		<td>
			<table id="list"></table>
		</td>
	</tr>
</table>

</body>
<script type="text/javascript">
jQuery(function($) {
	var prevCellVal1 = { cellId: undefined, value: undefined };
	$("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisMonthSalesListJQGrid.sys',
		datatype: 'local',
		mtype: 'POST',
		colNames:['상품유형','사업유형','매출액','매출이익','매출이익률','매출액','매출이익','매출이익률'],
		colModel:[
			{ name:'codeNmTop', index:'codeNmTop', width:120, align:'left', search:false, sortable:false,editable:false,
				cellattr: function (rowId, val, rawObject, cm, rdata){
					var result;
					if (prevCellVal1.value == val) {
						result = ' style="display: none" rowspanid="' + prevCellVal1.cellId + '"';
					}else {
						var cellId = this.id + '_row_' + rowId + '_' + cm.name;
						result = ' rowspan="1" id="' + cellId + '"';
						prevCellVal1 = { cellId: cellId, value: val };
					}
					return result;
				}
			},//구분1
			{ name:'codeNmMid', index:'codeNmMid', width:130, align:'left', search:false, sortable:false, editable:false
			},//구분2
			{ name:'spot_month',index:'spot_month',width:130,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//당월 매출액
			{ name:'spot_profit',index:'spot_profit',width:130,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//당월 매출이익
			{ name:'spot_profitrate', index:'spot_profitrate', width:70, align:'right', search:false, sortable:true, editable:false
			},//당월 매출이익률
			{ name:'total_month',index:'total_month',width:130,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//연누계 매출액
			{ name:'total_profit',index:'total_profit',width:130,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//연누계 매출이익
			{ name:'total_profitrate', index:'total_profitrate', width:70, align:'right', search:false, sortable:true, editable:false
			}//연누계 매출이익률
		],
		postData:{
			srcDateFlag:$("#srcDateFlag").val(),
			srcResultYear:$("#srcResultYear").val(),
			srcResultMonth:$("#srcResultMonth").val()
		},
		rowNum:0, rownumbers: false,
		height: 650, width:1500,
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
			var month = $("#list").getGridParam('userData');
			$(".monthSales_month").html(month.srcResultMonth);
		},
		cellattr: function(rowId, val, rawObject, cm, rdata) {
		},
		onSelectRow: function(rowid, iRow, iCol, e) {},
		ondblClickRow: function(rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target) {},
		userDataOnFooter:true,
		afterInsertRow: function(rowid, aData){
			var colModel = $("#list").jqGrid("getGridParam","colModel");
			if(aData.codeNmMid == "소계"){
				for(var i=0;i<colModel.length;i++) {
					$("#list").setCell(rowid,colModel[i].name,'',{background:'#e4e4e4'});
				}
			}
			if(aData.codeNmTop == "합계"){
				for(var i=0;i<colModel.length;i++) {
					$("#list").setCell(rowid,colModel[i].name,'',{background:'#cacaca'});
				}
			}
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader: {root: "list", repeatitems: false, cell: "cell", userdata:"userdata"}
	});
	$("#list").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
		groupHeaders:[
			{startColumnName: 'codeNmTop', numberOfColumns: 2, titleText: '구 분'},
			{startColumnName: 'spot_month', numberOfColumns: 3, titleText: '당 월'},
			{startColumnName: 'total_month', numberOfColumns: 3, titleText: '연 누계'}
		]
	});
});
</script>

<script type="text/javascript">
$(document).ready(function() {
	
	$("#srcSummaryList").click( function() { fnDynamicForm("/analysis/analysisSummaryList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
	$("#srcMonthSalesList").click( function() { fnDynamicForm("/analysis/analysisYearSalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
	$("#srcTypeSalesList").click( function() { fnDynamicForm("/analysis/analysisMonthSalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
	$("#srcOrderSalesList").click( function() { fnDynamicForm("/analysis/analysisWorkInfoExpectationSalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
	$("#srcDaySalesList").click( function() { fnDynamicForm("/analysis/analysisWeekDaySalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });	
	
	var getYear = <%=getYear%>;
	for(var i=getYear; i>=2010;i--){
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
	$("#srcButton").on("click",function(){ fnSearch(); });
	$("#excelButton").on("click",function(){ 
		var colLabels = ['상품유형','사업유형','당월 매출액','당월 매출이익','당월 매출이익률','연누계 매출액','연누계 매출이익','연누계 매출이익률'];	//출력컬럼명
		var colIds = ['codeNmTop','codeNmMid','spot_month','spot_profit','spot_profitrate','total_month','total_profit','total_profitrate'];	//출력컬럼ID
		var numColIds = ['spot_month','spot_profit','total_month','total_profit'];	//숫자표현ID
		var figureColIds = [];
		var month = $("#list").getGridParam('userData');
		var sheetTitle = month.srcResultMonth+"월 매출현황";	//sheet 타이틀
		var excelFileName = "analysisMontnSalesList";	//file명
		fnExportExcel($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
	});
	
	$("#srcButton").click();
});

function fnSearch() {
	var data = $("#list").jqGrid("getGridParam", "postData");
	data.srcDateFlag = $("#srcDateFlag").val();
	data.srcResultYear = $("#srcResultYear").val();
	data.srcResultMonth = $("#srcResultMonth").val();
	$("#list").jqGrid("setGridParam", { "postData": data });
	$("#list").setGridParam({datatype:'json'});
	$("#list").trigger("reloadGrid");
}


$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>
</html>
