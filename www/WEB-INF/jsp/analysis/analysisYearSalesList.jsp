<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-380 + Number(gridHeightResizePlus)";
	String listWidth = "1500";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//현재년도 받아오기
	String getYear = CommonUtils.getCurrentDate().substring(0, 4);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
	var jq = jQuery;
	$(document).ready(function(){
		
		$("#srcSummaryList").click( function() { fnDynamicForm("/analysis/analysisSummaryList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
		$("#srcMonthSalesList").click( function() { fnDynamicForm("/analysis/analysisYearSalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
		$("#srcTypeSalesList").click( function() { fnDynamicForm("/analysis/analysisMonthSalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
		$("#srcOrderSalesList").click( function() { fnDynamicForm("/analysis/analysisWorkInfoExpectationSalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });
		$("#srcDaySalesList").click( function() { fnDynamicForm("/analysis/analysisWeekDaySalesList.sys?_menuCd=ADM_ANAL_SUM", "",""); });	
		
		$("#srcButton").click(function(){ fnSearch(); }); //검색
		$("#excelButton").click(function(){ exportExcel(); }); //엑셀다운
		srcSalesYear();//실적년도 셀렉트박스
		analysisYearSalesList();
	});
	$(window).bind('resize', function() {
		$("#list").setGridHeight(<%=listHeight %>);
		$("#list").setGridWidth(<%=listWidth %>);
	}).trigger('resize');
</script>
<script type="text/javascript">
	function analysisYearSalesList() {
		var prevCellVal1 = { cellId: undefined, value: undefined };
		var prevCellVal2 = { cellId: undefined, value: undefined };
		jq("#list").jqGrid({
			url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisYearSalesListJQGrid.sys',
			datatype:'json',
			mtype:'POST',
			colNames:['공사구분','자재유형','고객유형','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','합계','신규매출합계','매출이익','매출이익률(%)','workId'],
			colModel:[
				{ name:'codeNmTop', index:'codeNmTop', width:80, align:'center', search:false, editable:false ,//frozen:true
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
				},//공사구분
				{ name:'codeNmMid', index:'codeNmMid', width:80, align:'center', search:false, editable:false,//frozen:true
					cellattr: function (rowId, val, rawObject, cm, rdata){
						var result;
						if (prevCellVal2.value == val) {
							result = ' style="display: none" rowspanid="' + prevCellVal2.cellId + '"';
						}else {
							var cellId = this.id + '_row_' + rowId + '_' + cm.name;
							result = ' rowspan="1" id="' + cellId + '"';
							prevCellVal2 = { cellId: cellId, value: val };
						}
						return result;
					}	
				},//자재유형
				{
					name:'worknm', index:'worknm', width:135, align:'left', search:false, editable:false//,frozen:true
				},//고객유형
				{ name:'msummary_tota_amou',index:'summary_tota_amou',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//합계
				{ name:'nsummary_tota_amou',index:'summary_tota_amou',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 합계
				{ name:'tota_profit',index:'tota_profit',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 합계
				{ name:'tota_profitrate',index:'tota_profitrate',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 합계
				{ name:'m1',index:'m1',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//1월
				{ name:'n1',index:'n1',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 1월
				{ name:'profit1',index:'profit1',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 1월
				{ name:'profitRate1',index:'profitRate1',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 1월
				{ name:'m2',index:'m2',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//2월
				{ name:'n2',index:'n2',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 2월
				{ name:'profit2',index:'profit2',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 2월
				{ name:'profitRate2',index:'profitRate2',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 2월
				{ name:'m3',index:'m3',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//3월
				{ name:'n3',index:'n3',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 3월
				{ name:'profit3',index:'profit3',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 3월
				{ name:'profitRate3',index:'profitRate3',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 3월
				{ name:'m4',index:'m4',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//4월
				{ name:'n4',index:'n4',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 4월
				{ name:'profit4',index:'profit4',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 4월
				{ name:'profitRate4',index:'profitRate4',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 4월
				{ name:'m5',index:'m5',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//5월
				{ name:'n5',index:'n5',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 5월
				{ name:'profit5',index:'profit5',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 5월
				{ name:'profitRate5',index:'profitRate5',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 5월
				{ name:'m6',index:'m6',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//6월
				{ name:'n6',index:'n6',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 6월
				{ name:'profit6',index:'profit6',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 6월
				{ name:'profitRate6',index:'profitRate6',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 6월
				{ name:'m7',index:'m7',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//7월
				{ name:'n7',index:'n7',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 7월
				{ name:'profit7',index:'profit7',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 7월
				{ name:'profitRate7',index:'profitRate7',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 7월
				{ name:'m8',index:'m8',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//8월
				{ name:'n8',index:'n8',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 8월
				{ name:'profit8',index:'profit8',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 8월
				{ name:'profitRate8',index:'profitRate8',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 8월
				{ name:'m9',index:'m9',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//9월
				{ name:'n9',index:'n9',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 9월
				{ name:'profit9',index:'profit9',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 9월
				{ name:'profitRate9',index:'profitRate9',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 9월
				{ name:'m10',index:'m10',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//10월
				{ name:'n10',index:'n10',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 10월
				{ name:'profit10',index:'profit10',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 3월
				{ name:'profitRate10',index:'profitRate10',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 10월
				{ name:'m11',index:'m11',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//11월
				{ name:'n11',index:'n11',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 11월
				{ name:'profit11',index:'profit11',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 11월
				{ name:'profitRate11',index:'profitRate11',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 11월
				{ name:'m12',index:'m12',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//12월
				{ name:'n12',index:'n12',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규실적 12월
				{ name:'profit12',index:'profit12',width:100,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//매출이익 12월
				{ name:'profitRate12',index:'profitRate12',width:100,align:"right",search:false, sortable:false, editable:false,sorttype:'integer'},//매출이익률 12월
				{
					name:'workid', index:'workid', width:135, align:'left', search:false, editable:false, hidden:true
				}//고객유형아이디
			],
			postData:{
				srcResultYear:$("#srcResultYear").val()
			},
			rowNum:0, rownumbers: false, 
			height: <%=listHeight%>, width: 1500,
// 			sortname: '', sortorder: '',
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
				fnTotalAmountSum();
			},
			cellattr: function(rowId, val, rawObject, cm, rdata) {
				var result;
				var cellId = this.id + '_row_' + rawObject[3] + grid.getGridParam('page');
				if (prevCellVal.cellId == cellId) {
					result = ' style="display: none"';
				}else {
					result = ' rowspan="' + rawObject[6] + '"';
					prevCellVal = { cellId: cellId, value: rawObject[3] };
				}
				return result;
			},
			onSelectRow: function(rowid, iRow, iCol, e) {},
			ondblClickRow: function(rowid, iRow, iCol, e) {},
			onCellSelect: function(rowid, iCol, cellcontent, target) {},
			footerrow:true,userDataOnFooter:true,
			afterInsertRow: function(rowid, aData){},
			loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
			jsonReader: {root: "list", page: "page", total: "total", records: "records", repeatitems: false, cell: "cell"}
		});
		jq("#list").jqGrid('setGroupHeaders', {
			useColSpanStyle: false,
				groupHeaders:[
// 					{startColumnName: 'codeNmTop', numberOfColumns: 3, titleText: ''},
					{startColumnName: 'm1', numberOfColumns: 4, titleText: '1월'},
					{startColumnName: 'm2', numberOfColumns: 4, titleText: '2월'},
					{startColumnName: 'm3', numberOfColumns: 4, titleText: '3월'},
					{startColumnName: 'm4', numberOfColumns: 4, titleText: '4월'},
					{startColumnName: 'm5', numberOfColumns: 4, titleText: '5월'},
					{startColumnName: 'm6', numberOfColumns: 4, titleText: '6월'},
					{startColumnName: 'm7', numberOfColumns: 4, titleText: '7월'},
					{startColumnName: 'm8', numberOfColumns: 4, titleText: '8월'},
					{startColumnName: 'm9', numberOfColumns: 4, titleText: '9월'},
					{startColumnName: 'm10', numberOfColumns: 4, titleText: '10월'},
					{startColumnName: 'm11', numberOfColumns: 4, titleText: '11월'},
					{startColumnName: 'm12', numberOfColumns: 4, titleText: '12월'},
					{startColumnName: 'msummary_tota_amou', numberOfColumns: 4, titleText: '누계'}
				]
		});
		
		//그리드틀고정
// 		$("#list").jqGrid('setFrozenColumns');
	}
</script>
<script type="text/javascript">
	//실적년도 셀렉트박스
	function srcSalesYear() {
		var getYear = "<%=getYear%>";
		for(var i=getYear; i>=2014;i--){
			$("#srcResultYear").append("<option value='"+i+"'>"+i+"</option>");
		}
		$("#srcResultYear").val(getYear);
	}
	
	//검색 펑션
	function fnSearch() {
		var data = jq("#list").jqGrid("getGridParam", "postData");
		data.srcResultYear = $("#srcResultYear").val();
		jq("#list").jqGrid("setGridParam", { "postData": data });
		jq("#list").trigger("reloadGrid");
	}
	
	//엑셀다운
	function exportExcel() {
	var colLabels = [
						'공사구분','자제유형','고객유형','매출합계','신규 매출 합계','매출합계 이익','매출합계 이익률',
						'1월 매출','1월 신규매출','1월 매출이익','1월 매출이익률','2월 매출','2월 신규매출','2월 매출이익','2월 매출이익률',
						'3월 매출','3월 신규매출','3월 매출이익','3월 매출이익률','4월 매출','4월 신규매출','4월 매출이익','4월 매출이익률','5월 매출','5월 신규매출','5월 매출이익','5월 매출이익률',
						'6월 매출','6월 신규매출','6월 매출이익','6월 매출이익률','7월 매출','7월 신규매출','7월 매출이익','7월 매출이익률','8월 매출','8월 신규매출','8월 매출이익','8월 매출이익률',
						'9월 매출','9월 신규매출','9월 매출이익','9월 매출이익률','10월 매출','10월 신규매출','10월 매출이익','10월 매출이익률','11월 매출','11월 신규매출','11월 매출이익','11월 매출이익률',
						'12월 매출','12월 신규매출','12월 매출이익','12월 매출이익률'
					];	//출력컬럼명
	var colIds = [
					'codeNmTop','codeNmMid','worknm','msummary_tota_amou','nsummary_tota_amou','tota_profit','tota_profitrate',
					'm1','n1','profit1','profitRate1','m2','n2','profit2','profitRate2','m3','n3','profit3','profitRate3','m4','n4','profit4','profitRate4',
					'm5','n5','profit5','profitRate5','m6','n6','profit6','profitRate6','m7','n7','profit7','profitRate7','m8','n8','profit8','profitRate8','m9','n9','profit9','profitRate9',
					'm10','n10','profit10','profitRate10','m11','n11','profit11','profitRate11','m12','n12','profit12','profitRate12'
				];	//출력컬럼ID
	var numColIds = ['m1','n1','profit1','m2','n2','profit2','m3','n3','profit3','m4','n4','profit4','m5','n5','profit5','m6','n6','profit6','m7','n7','profit7','m8','n8','profit8','m9','n9','profit9','m10','n10','profit10','m11','n11','profit11','m12','n12','profit12','msummary_tota_amou','nsummary_tota_amou'];	//숫자표현ID
	var figureColIds = [];
	var sheetTitle = "연 매출현황";	//sheet 타이틀
	var excelFileName = "analysisYearSalesList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
	function fnTotalAmountSum() {
		var rowCnt = jq("#list").getGridParam('reccount');
		var SumTotalamount = [];
		if(rowCnt>0) {
			for(var j=1; j<40; j++) {
				var sum = 0 ;
				var mm = "";
				switch (j) {
					case 1: mm = "m1";
						break;
					case 2: mm = "n1";
						break;
					case 3: mm = "profit1";
						break;
					case 4: mm = "m2";
						break;
					case 5: mm = "n2";
						break;
					case 6: mm = "profit2";
						break;
					case 7: mm = "m3";
						break;
					case 8: mm = "n3";
						break;
					case 9: mm = "profit3";
						break;
					case 10: mm = "m4";
						break;
					case 11: mm = "n4";
						break;
					case 12: mm = "profit4";
						break;
					case 13: mm = "m5";
						break;
					case 14: mm = "n5";
						break;
					case 15: mm = "profit5";
						break;
					case 16: mm = "m6";
						break;
					case 17: mm = "n6";
						break;
					case 18: mm = "profit6";
						break;
					case 19: mm = "m7";
						break;
					case 20: mm = "n7";
						break;
					case 21: mm = "profit7";
						break;
					case 22: mm = "m8";
						break;
					case 23: mm = "n8";
						break;
					case 24: mm = "profit8";
						break;
					case 25: mm = "m9";
						break;
					case 26: mm = "n9";
						break;
					case 27: mm = "profit9";
						break;
					case 28: mm = "m10";
						break;
					case 29: mm = "n10";
						break;
					case 30: mm = "profit10";
						break;
					case 31: mm = "m11";
						break;
					case 32: mm = "n11";
						break;
					case 33: mm = "profit11";
						break;
					case 34: mm = "m12";
						break;
					case 35: mm = "n12";
						break;
					case 36: mm = "profit12";
						break;
					case 37: mm = "msummary_tota_amou";
						break;
					case 38: mm = "nsummary_tota_amou";
						break;
					case 39: mm = "tota_profit";
						break;
				}
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					if(selrowContent.workid != 99999){
						sum += Number(jq("#list").jqGrid('getRowData',rowid)[mm]);
					}
				}
				SumTotalamount.push(sum);
			}
			//합계의 매출이익률
			//1월
			var profitrate1 = SumTotalamount[2]/SumTotalamount[0] *100;
			profitrate1 = (profitrate1>0) ? profitrate1.toFixed(1)+"%" : "0%";
			//2월
			var profitrate2 = SumTotalamount[5]/SumTotalamount[3] *100;
			profitrate2 = (profitrate2>0) ? profitrate2.toFixed(1)+"%" : "0%";
			//3월
			var profitrate3 = SumTotalamount[8]/SumTotalamount[6] *100;
			profitrate3 = (profitrate3>0) ? profitrate3.toFixed(1)+"%" : "0%";
			//4월
			var profitrate4 = SumTotalamount[11]/SumTotalamount[9] *100;
			profitrate4 = (profitrate4>0) ? profitrate4.toFixed(1)+"%" : "0%";
			//5월
			var profitrate5 = SumTotalamount[14]/SumTotalamount[12] *100;
			profitrate5 = (profitrate5>0) ? profitrate5.toFixed(1)+"%" : "0%";
			//6월
			var profitrate6 = SumTotalamount[17]/SumTotalamount[15] *100;
			profitrate6 = (profitrate6>0) ? profitrate6.toFixed(1)+"%" : "0%";
			//7월
			var profitrate7 = SumTotalamount[20]/SumTotalamount[18] *100;
			profitrate7 = (profitrate7>0) ? profitrate7.toFixed(1)+"%" : "0%";
			//8월
			var profitrate8 = SumTotalamount[23]/SumTotalamount[21] *100;
			profitrate8 = (profitrate8>0) ? profitrate8.toFixed(1)+"%" : "0%";
			//9월
			var profitrate9 = SumTotalamount[26]/SumTotalamount[24] *100;
			profitrate9 = (profitrate9>0) ? profitrate9.toFixed(1)+"%" : "0%";
			//10월
			var profitrate10 = SumTotalamount[29]/SumTotalamount[27] *100;
			profitrate10 = (profitrate10>0) ? profitrate10.toFixed(1)+"%" : "0%";
			//11월
			var profitrate11 = SumTotalamount[32]/SumTotalamount[30] *100;
			profitrate11 = (profitrate11>0) ? profitrate11.toFixed(1)+"%" : "0%";
			//12월
			var profitrate12 = SumTotalamount[35]/SumTotalamount[33] *100;
			profitrate12 = (profitrate12>0) ? profitrate12.toFixed(1)+"%" : "0%";
			//누계
			var tota_profitrate = SumTotalamount[38]/SumTotalamount[36] *100;
			tota_profitrate = (tota_profitrate>0) ? tota_profitrate.toFixed(1)+"%" : "0%";
			jq("#list").jqGrid("footerData","set",{ codeNmTop:'합 계'
																,m1:fnComma(SumTotalamount[0]),n1:fnComma(SumTotalamount[1])
																,profit1:fnComma(SumTotalamount[2]),profitRate1:profitrate1
																,m2:fnComma(SumTotalamount[3]),n2:fnComma(SumTotalamount[4])
																,profit2:fnComma(SumTotalamount[5]),profitRate2:profitrate2
																,m3:fnComma(SumTotalamount[6]),n3:fnComma(SumTotalamount[7])
																,profit3:fnComma(SumTotalamount[8]),profitRate3:profitrate3
																,m4:fnComma(SumTotalamount[9]),n4:fnComma(SumTotalamount[10])
																,profit4:fnComma(SumTotalamount[11]),profitRate4:profitrate4
																,m5:fnComma(SumTotalamount[12]),n5:fnComma(SumTotalamount[13])
																,profit5:fnComma(SumTotalamount[14]),profitRate5:profitrate5
																,m6:fnComma(SumTotalamount[15]),n6:fnComma(SumTotalamount[16])
																,profit6:fnComma(SumTotalamount[17]),profitRate6:profitrate6
																,m7:fnComma(SumTotalamount[18]),n7:fnComma(SumTotalamount[19])
																,profit7:fnComma(SumTotalamount[20]),profitRate7:profitrate7
																,m8:fnComma(SumTotalamount[21]),n8:fnComma(SumTotalamount[22])
																,profit8:fnComma(SumTotalamount[23]),profitRate8:profitrate8
																,m9:fnComma(SumTotalamount[24]),n9:fnComma(SumTotalamount[25])
																,profit9:fnComma(SumTotalamount[26]),profitRate9:profitrate9
																,m10:fnComma(SumTotalamount[27]),n10:fnComma(SumTotalamount[28])
																,profit10:fnComma(SumTotalamount[29]),profitRate10:profitrate10
																,m11:fnComma(SumTotalamount[30]),n11:fnComma(SumTotalamount[31])
																,profit11:fnComma(SumTotalamount[32]),profitRate11:profitrate11
																,m12:fnComma(SumTotalamount[33]),n12:fnComma(SumTotalamount[34])
																,profit12:fnComma(SumTotalamount[35]),profitRate12:profitrate12
																,msummary_tota_amou:fnComma(SumTotalamount[36]),nsummary_tota_amou:fnComma(SumTotalamount[37])
																,tota_profit:fnComma(SumTotalamount[38]),tota_profitrate:tota_profitrate
													},false);
		} else {
			fnClearTotalAmountSum();
		}
	}
	
	function fnClearTotalAmountSum() {
		jq("#list").jqGrid("footerData","set",{ codeNmTop:'합계',m1:'0',n1:'0',profit1:'0',profitRate1:'0'
																,m2:'0',n2:'0',profit2:'0',profitRate2:'0'
																,m3:'0',n3:'0',profit3:'0',profitRate3:'0'
																,m4:'0',n4:'0',profit4:'0',profitRate4:'0'
																,m5:'0',n5:'0',profit5:'0',profitRate5:'0'
																,m6:'0',n6:'0',profit6:'0',profitRate6:'0'
																,m7:'0',n7:'0',profit7:'0',profitRate7:'0'
																,m8:'0',n8:'0',profit8:'0',profitRate8:'0'
																,m9:'0',n9:'0',profit9:'0',profitRate9:'0'
																,m10:'0',n10:'0',profit10:'0',profitRate10:'0'
																,m11:'0',n11:'0',profit11:'0',profitRate11:'0'
																,m12:'0',n12:'0',profit12:'0',profitRate10:'0'
																,msummary_tota_amou:'0',nsummary_tota_amou:'0',tota_profit:'0',tota_profitrate:'0'
												},false);
	}
	
	function fnComma(n) {
		n += '';
		var reg = /(^[+-]?\d+)(\d{3})/;
		while (reg.test(n)) {
			n = n.replace(reg, '$1' + ',' + '$2');
		}
		return n;
	}
	
	//소계의 매출이익률
		//소계의 매출이익률(매출이익/매출)
	function fnSubTotalProfitRate(){
		var rowCnt = jq("#list").getGridParam('reccount');
		if(rowCnt>0){
			for(var i=0; i<rowCnt; i++){
				var rowid = $("#list").getDataIDs()[i];
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				if(selrowContent.workid == 99999){
					//1월 매출이익률
					var profitrate1 = selrowContent.profit1/selrowContent.m1 * 100;
					profitrate1 = profitrate1.toFixed(1)+"%";
					//2월 매출이익률
					var profitrate2 = selrowContent.profit2/selrowContent.m2 * 100;
					profitrate2 = profitrate2.toFixed(1)+"%";
					//3월 매출이익률
					var profitrate3 = selrowContent.profit3/selrowContent.m3 * 100;
					profitrate3 = profitrate3.toFixed(1)+"%";
					//4월 매출이익률
					var profitrate4 = selrowContent.profit4/selrowContent.m4 * 100;
					profitrate4 = profitrate4.toFixed(1)+"%";
					//5월 매출이익률
					var profitrate5 = selrowContent.profit5/selrowContent.m5 * 100;
					profitrate5 = profitrate5.toFixed(1)+"%";
					//6월 매출이익률
					var profitrate6 = selrowContent.profit6/selrowContent.m6 * 100;
					profitrate6 = profitrate6.toFixed(1)+"%";
					//7월 매출이익률
					var profitrate7 = selrowContent.profit7/selrowContent.m7 * 100;
					profitrate7 = profitrate7.toFixed(1)+"%";
					//8월 매출이익률
					var profitrate8 = selrowContent.profit8/selrowContent.m8 * 100;
					profitrate8 = profitrate8.toFixed(1)+"%";
					//9월 매출이익률
					var profitrate9 = selrowContent.profit9/selrowContent.m9 * 100;
					profitrate9 = profitrate9.toFixed(1)+"%";
					//10월 매출이익률
					var profitrate10 = selrowContent.profit10/selrowContent.m10 * 100;
					profitrate10 = profitrate10.toFixed(1)+"%";
					//11월 매출이익률
					var profitrate11 = selrowContent.profit11/selrowContent.m11 * 100;
					profitrate11 = profitrate11.toFixed(1)+"%";
					//12월 매출이익률
					var profitrate12 = selrowContent.profit12/selrowContent.m12 * 100;
					profitrate12 = profitrate12.toFixed(1)+"%";
					$('#list').jqGrid('setRowData', rowid,{
															profitrate1:profitrate1,
															profitrate2:profitrate2,
															profitrate3:profitrate3,
															profitrate4:profitrate4,
															profitrate5:profitrate5,
															profitrate6:profitrate6,
															profitrate7:profitrate7,
															profitrate8:profitrate8,
															profitrate9:profitrate9,
															profitrate10:profitrate10,
															profitrate11:profitrate11,
															profitrate12:profitrate12
															});
				}
			}
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
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
					<td height="29" class="ptitle">연 매출현황</td>
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
					<td class="table_td_subject" width="90">실적년도</td>
					<td class="table_td_contents" width="250" colspan="5">
						<select id="srcResultYear" name="srcResultYear" class="select"></select>년
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
		<td height="20px" align="right" valign="bottom">
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