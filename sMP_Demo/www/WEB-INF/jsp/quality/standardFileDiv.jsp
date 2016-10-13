<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmBondsMonthWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 720px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmBondsMonthWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
	// Dialog Button Event
	$('#bondsMonthDetailPop').jqm();	//Dialog 초기화
	$("#bondsMonthCloseButton, .jqmClose").click(function(){	//Dialog 닫기
		$("#bondsMonthDetailPop").jqmHide();
		fnBondsCallback = "";
	});
	$('#bondsMonthDetailPop').jqm().jqDrag('#bondsMonthDialogHandle'); 
	
	$("#allExcelButton").on("click",function(){
		var colLabels = ['업체명','계산서일자','만기일','회수일','채권','회수채권']
		var colIds =['BRANCHNM','CLOS_SALE_DATE','EXPIRATION_DATE','SALE_PAY_DATE','SALE_TOTA_AMOU','PAY_AMOU'];
		var numColIds = ['SALE_TOTA_AMOU','PAY_AMOU'];
		var sheetTitle = "당월회수채권";
		var excelFileName = "AdjustBondMonthList";
		var fieldSearchParamArray = new Array();
		fieldSearchParamArray[0] = 'stdyyyymm';
		fnExportExcelToSvc($("#bondsMonthDetail"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray,"/adjust/bondsMonthDetailJQGridExcel.sys");
	});
});

var fnBondsCallback = "";
function fnBondsMonthDetailDiv(stdYear, stdMonth) {
	$("#stdyyyymm").val(stdYear + '' + stdMonth);
	$("#bondsMonthDetailPop").jqmShow();
	bondsMonthDialogDivInit();
}
</script>


<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var bondsMonthDivInitCnt = 0;
function bondsMonthDialogDivInit() {
	
	if(bondsMonthDivInitCnt > 0){
		jq("#bondsMonthDetail").jqGrid("setGridParam", {"page":1, "rows":10});
		var data = jq("#bondsMonthDetail").jqGrid("getGridParam", "postData");
		data.stdyyyymm =$("#stdyyyymm").val();
		jq("#bondsMonthDetail").jqGrid("setGridParam", { "postData":data });
		jq("#bondsMonthDetail").trigger("reloadGrid");
	}
	
	jq("#bondsMonthDetail").jqGrid({
		datatype: 'json', 
		mtype: 'POST',
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/bondsMonthDetailJQGrid.sys',
		colNames:['업체명','계산서일자','만기일','회수일','채권','회수채권'],
		colModel:[
			{name:'BRANCHNM',index:'BRANCHNM', width:200,align:"left",sortable:true,editable:false},
			{name:'CLOS_SALE_DATE',index:'CLOS_SALE_DATE', width:80,align:"center",search:false,sortable:true,editable:false},
			{name:'EXPIRATION_DATE',index:'EXPIRATION_DATE', width:80,align:"center",search:false,sortable:true,editable:false},
			{name:'SALE_PAY_DATE',index:'EXPIRATION_DATE', width:80,align:"center",search:false,sortable:true,editable:false},
			{name:'SALE_TOTA_AMOU',index:'SALE_TOTA_AMOU',width:80,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'PAY_AMOU',index:'PAY_AMOU',width:80,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }}
		],
		postData: {
			stdyyyymm:$("#stdyyyymm").val()
		},
		rowNum:500, rownumbers: true, rowList:[10,20,30,50,100,500,1000], pager: '#bondsMonthDetailDivPager',
		height:250, width:680, 
		sortname: 'BRANCHNM', sortorder: "asc",
// 		caption:'당월 회수 채권 상세', 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { bondsMonthDivInitCnt++; },
		afterInsertRow: function(rowid, aData){},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#bondsMonthDetail").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}

</script>
</head>
<body>
<div class="jqmBondsMonthWindow" id="bondsMonthDetailPop">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<input type="hidden" id="stdyyyymm" name="stdyyyymm"/>
			</td>
			<td>
				<div id="bondsMonthDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>당월회수채권</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose"  >
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							<!-- 조회조건 -->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="right" height="30" valign="top">
										<button id='allExcelButton' class="btn btn-success btn-xs"><i class="fa fa-file-excel-o"></i> 엑셀</button>
									</td>
								</tr>
								<tr>
									<td>
										<div id="jqgrid">
											<table id="bondsMonthDetail"></table>
											<div id="bondsMonthDetailDivPager"></div>
										</div>
									</td>
								</tr>
								<tr>
									<td height='8'></td>
								</tr>
							</table>
							
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id="bondsMonthCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
