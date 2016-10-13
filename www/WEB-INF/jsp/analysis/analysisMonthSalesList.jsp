<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-485 + Number(gridHeightResizePlus)";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//현재년도 받아오기
	String getYear = CommonUtils.getCurrentDate().substring(0, 4);
	String getMonth = CommonUtils.getCurrentDate().substring(5, 7);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
	var jq = jQuery;
	$(document).ready(function(){
		
		$("#srcSummaryList").click( function() { fnDynamicForm("/analysis/analysisSummaryList.sys", "",""); });
		$("#srcMonthSalesList").click( function() { fnDynamicForm("/analysis/analysisYearSalesList.sys", "",""); });
		$("#srcTypeSalesList").click( function() { fnDynamicForm("/analysis/analysisMonthSalesList.sys", "",""); });
		$("#srcOrderSalesList").click( function() { fnDynamicForm("/analysis/analysisWorkInfoExpectationSalesList.sys", "",""); });
		$("#srcDaySalesList").click( function() { fnDynamicForm("/analysis/analysisWeekDaySalesList.sys", "",""); });		
		
		$("#srcButton").click(function(){ fnSearch(); }); //검색
		$("#excelButton").click(function(){ exportExcel(); }); //엑셀다운
		srcSalesYear(); //실적년도 셀렉트박스
		$("#srcResultYear").val("<%=getYear%>");
		$("#srcResultMonth").val("<%=getMonth%>");
		analysisYearSalesList();
	});
</script>
<script type="text/javascript">
	function analysisYearSalesList() {
		var prevCellVal1 = { cellId: undefined, value: undefined };
		var prevCellVal2 = { cellId: undefined, value: undefined };
		jq("#list").jqGrid({
			url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisMonthSalesListJQGrid.sys',
			datatype:'json',
			mtype:'POST',
			colNames:['공사구분','자재유형','고객유형','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','매출','신규매출','매출이익','매출이익률(%)','workid'],
			colModel:[
				{ name:'codeNmTop', index:'codeNmTop', width:80, align:'center', search:false, sortable:true,editable:false,
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
				{ name:'codeNmMid', index:'codeNmMid', width:80, align:'center', search:false, sortable:true, editable:false,
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
				{ name:'worknm', index:'worknm', width:135, align:'left', search:false, sortable:true, editable:false},//고객유형
				{ name:'last_month',index:'new_last_month',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//전월 실적
				{ name:'new_last_month',index:'last_month',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규 전월 실적
				{ name:'last_profit',index:'last_profit',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규 전월 매출이익
				{ name:'last_profitrate', index:'last_profitrate', width:100, align:'right', search:false, sortable:true, editable:false},//신규 전월 매출이익률
				{ name:'spot_month',index:'new_spot_month',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//당월 실적
				{ name:'new_spot_month',index:'spot_month',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규 당월 실적
				{ name:'spot_profit',index:'spot_profit',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규 당월 매출이익
				{ name:'spot_profitrate', index:'spot_profitrate', width:100, align:'right', search:false, sortable:true, editable:false},//신규 당월 매출이익률
				{ name:'total_month',index:'total_month',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//연 누계
				{ name:'new_total_month',index:'total_month',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//신규 연 누계
				{ name:'total_profit',index:'total_profit',width:120,align:"right",search:false,sortable:false
					,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
				},//누계 매출이익
				{ name:'total_profitrate', index:'total_profitrate', width:100, align:'right', search:false, sortable:true, editable:false},//신규 당월 매출이익률
				{ name:'workid', index:'workid', width:100, align:'right', search:false, sortable:true, editable:false, hidden:true}
			],
			postData:{
				srcResultYear:$("#srcResultYear").val(),
				srcResultMonth:$("#srcResultMonth").val()
			},
			rowNum:0, rownumbers: false, rowList:[50,100,200], pager:'#pager',
			height: true, autowidth: true,
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
				fnTotalAmountSum();//합계
				fnSubTotalProfitRate();//소계의 매출이익률
				var month = $("#list").getGridParam('userData');
				$(".monthSales_month").html(month.srcResultMonth);
			},
			cellattr: function(rowId, val, rawObject, cm, rdata) {
			},
			onSelectRow: function(rowid, iRow, iCol, e) {},
			ondblClickRow: function(rowid, iRow, iCol, e) {},
			onCellSelect: function(rowid, iCol, cellcontent, target) {},
			footerrow:true,userDataOnFooter:true,
			afterInsertRow: function(rowid, aData){},
			loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
			jsonReader: {root: "list", repeatitems: false, cell: "cell", userdata:"userdata"}
		});
		jq("#list").jqGrid('setGroupHeaders', {
			useColSpanStyle: true,
				groupHeaders:[
					{startColumnName: 'last_month', numberOfColumns: 4, titleText: '전월 누계'},
					{startColumnName: 'spot_month', numberOfColumns: 4, titleText: '당 월'},
					{startColumnName: 'total_month', numberOfColumns: 4, titleText: '연 누계'}
				]
		});
	}
</script>
<script type="text/javascript">
	//실적년도 셀렉트박스
	function srcSalesYear() {
		var getYear = "<%=getYear%>";
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
	var colLabels = ['공사구분','자제유형','고객유형','전월 누계','전월 신규','전월매출이익','전월매출이익률','당월 누계','당월 신규','당월매출이익','당월매출이익률','연 누계','연 신규','연누계매출이익','연누계매출이익률'];	//출력컬럼명
	var colIds = ['codeNmTop','codeNmMid','worknm','last_month','new_last_month','last_profit','last_profitrate','spot_month','new_spot_month','spot_profit','spot_profitrate','total_month','new_total_month','last_profit','last_profitrate','total_profit','total_profitrate',];	//출력컬럼ID
	var numColIds = ['last_month','new_last_month','last_profit','spot_month','new_spot_month','spot_profit','total_month','new_total_month','total_profit'];	//숫자표현ID
	var figureColIds = [];
	var month = $("#list").getGridParam('userData');
	var sheetTitle = month.srcResultMonth+"월 매출현황";	//sheet 타이틀
	var excelFileName = "analysisMontnSalesList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
	}
	//합계
	function fnTotalAmountSum() {
		var rowCnt = jq("#list").getGridParam('reccount');
		var SumTotalamount = [];
		if(rowCnt>0) {
			for(var j=1; j<10; j++) {
				var sum = 0 ;
				var mm = "";
				switch (j) {
					case 1: mm = "last_month";
						break;
					case 2: mm = "new_last_month";
						break;
					case 3: mm = "last_profit";
						break;
					case 4: mm = "spot_month";
						break;
					case 5: mm = "new_spot_month";
						break;
					case 6: mm = "spot_profit";
						break;
					case 7: mm = "total_month";
						break;
					case 8: mm = "new_total_month";
						break;
					case 9: mm = "total_profit";
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
			//합계 매출이익률
			//전월
			var last_profitrate = SumTotalamount[2]/SumTotalamount[0] *100;
			last_profitrate = last_profitrate.toFixed(1)+"%";
			//당월
			var spot_profitrate = SumTotalamount[5]/SumTotalamount[3] *100;
			spot_profitrate = spot_profitrate.toFixed(1)+"%";
			//합계
			var total_profitrate = SumTotalamount[8]/SumTotalamount[6] *100;
			total_profitrate = total_profitrate.toFixed(1)+"%";
			jq("#list").jqGrid("footerData","set",{ codeNmTop:'합 계'
																,last_month:fnComma(SumTotalamount[0]),new_last_month:fnComma(SumTotalamount[1]),last_profit:fnComma(SumTotalamount[2]),last_profitrate:last_profitrate
																,spot_month:fnComma(SumTotalamount[3]),new_spot_month:fnComma(SumTotalamount[4]),spot_profit:fnComma(SumTotalamount[5]),spot_profitrate:spot_profitrate
																,total_month:fnComma(SumTotalamount[6]),new_total_month:fnComma(SumTotalamount[7]),total_profit:fnComma(SumTotalamount[8]),total_profitrate:total_profitrate
													},false);
		} else {
			fnClearTotalAmountSum();
		}
	}
	function fnClearTotalAmountSum() {
		jq("#list").jqGrid("footerData","set",{ codeNmTop:'합계',last_month:'0',new_last_month:'0',last_profit:'0',spot_month:'0',new_spot_month:'0',spot_profit:'0',total_month:'0',new_total_month:'0',total_profit:'0'},false);
	}
	
	function fnComma(n) {
		n += '';
		var reg = /(^[+-]?\d+)(\d{3})/;
		while (reg.test(n)) {
			n = n.replace(reg, '$1' + ',' + '$2');
		}
		return n;
	}
	
	//소계의 매출이익률(매출이익/매출)
	function fnSubTotalProfitRate(){
		var rowCnt = jq("#list").getGridParam('reccount');
		if(rowCnt>0){
			for(var i=0; i<rowCnt; i++){
				var rowid = $("#list").getDataIDs()[i];
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				if(selrowContent.workid == 99999){
					//전월 매출이익률
					var last_profitrate = selrowContent.last_profit/selrowContent.last_month * 100;
					last_profitrate = last_profitrate.toFixed(1);
					last_profitrate = last_profitrate == "NaN" ? 0:last_profitrate;
					//당월 매출이익률
					var spot_profitrate = selrowContent.spot_profit/selrowContent.spot_month * 100;
					spot_profitrate = spot_profitrate.toFixed(1);
					spot_profitrate = spot_profitrate == "NaN" ? 0:spot_profitrate;
					//연누계 매출이익률
					var total_profitrate = selrowContent.total_profit/selrowContent.total_month * 100;
					total_profitrate = total_profitrate.toFixed(1);
					total_profitrate = total_profitrate == "NaN" ? 0:total_profitrate;
					$('#list').jqGrid('setRowData', rowid, {
															last_profitrate:last_profitrate+"%",
															spot_profitrate:spot_profitrate+"%",
															total_profitrate:total_profitrate+"%",
															});
				}
			}
		}
	}

</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
					<td height="29" class="ptitle">월 매출현황</td>
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
					<td class="table_td_subject" width="90">월 매출현황</td>
					<td class="table_td_contents" width="250" colspan="5">
						<select id="srcResultYear" name="srcResultYear" class="select" ></select>년
						<select id="srcResultMonth" name="srcResultMonth" class="select"></select>월
<!-- 						<input type="text" id="srcResultYear" name="srcResultYear" readonly="readonly" size="7" value="">년 -->
<!-- 						<input type="text" id="srcResultMonth" name="srcResultMonth" readonly="readonly" size="5" value="">월 -->
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
		<td>
			<table id="list"></table>
		</td>
	</tr>
</table>
</form>

</body>
</html>