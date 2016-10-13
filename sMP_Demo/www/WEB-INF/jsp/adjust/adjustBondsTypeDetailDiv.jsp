<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmVendorWindow {
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
* html .jqmVendorWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
	// Dialog Button Event
	$('#bondsDetailPop').jqm();	//Dialog 초기화
	$("#bondsCloseButton, .jqmClose").click(function(){	//Dialog 닫기
		$("#bondsDetailPop").jqmHide();
		fnBondsCallback = "";
	});
	$('#bondsDetailPop').jqm().jqDrag('#vendorDialogHandle'); 
 
	$("#allExcelButton2").on("click",function(){
		var colLabels = ['업체명','계산서일자','만기일','채권','회수채권','미회수채권']
		var colIds =['BRANCHNM','CLOS_SALE_DATE','EXPIRATION_DATE','SALE_TOTA_AMOU','AMOU','NOT_AMOU'];
		var numColIds = ['SALE_TOTA_AMOU','AMOU','NOT_AMOU'];
		var sheetTitle = "채권유형별상세";
		var excelFileName = "AdjustBondTypeList";
		var fieldSearchParamArray = new Array();
		fieldSearchParamArray[0] = 'stdyyyymm';
		fieldSearchParamArray[1] = 'bondsType';
		fieldSearchParamArray[2] = 'contType';
		fnExportExcelToSvc($("#bondsTypeDetail"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray,"/adjust/bondsTypeDetailJQGridExcel.sys");
	});
});

var fnBondsCallback = "";
function fnBondsTypeDetail(stdYear, stdMonth, bondsType, contType) {
	$("#stdyyyymm").val(stdYear + '' + stdMonth);
	$("#bondsType").val(bondsType);
	$("#contType").val(contType);
	$("#bondsDetailPop").jqmShow();
	bondsDialogDivInit();
}
</script>


<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var bondsDivInitCnt = 0;
function bondsDialogDivInit() {
	
	if(bondsDivInitCnt > 0){
		jq("#bondsTypeDetail").jqGrid("setGridParam", {"page":1, "rows":10});
		var data = jq("#bondsTypeDetail").jqGrid("getGridParam", "postData");
		data.stdyyyymm =$("#stdyyyymm").val();
		data.bondsType =$("#bondsType").val();
		data.contType  =$("#contType").val();
		
		jq("#bondsTypeDetail").jqGrid("setGridParam", { "postData":data });
		jq("#bondsTypeDetail").trigger("reloadGrid");
	}
	
	
	jq("#bondsTypeDetail").jqGrid({
		datatype: 'json', 
		mtype: 'POST',
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/bondsTypeDetailJQGrid.sys',
		colNames:['업체명','계산서일자','만기일','채권','회수채권','미회수채권'],
		colModel:[
			{name:'BRANCHNM',index:'BRANCHNM', width:200,align:"left",sortable:true,editable:false},
			{name:'CLOS_SALE_DATE',index:'CLOS_SALE_DATE', width:80,align:"center",search:false,sortable:true,editable:false},
			{name:'EXPIRATION_DATE',index:'EXPIRATION_DATE', width:80,align:"center",search:false,sortable:true,editable:false},
			{name:'SALE_TOTA_AMOU',index:'SALE_TOTA_AMOU',width:80,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'AMOU',index:'AMOU',width:80,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'NOT_AMOU',index:'NOT_AMOU',width:80,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }}
		],
		postData: {
			stdyyyymm:$("#stdyyyymm").val(),
			bondsType:$("#bondsType").val(),
			contType:$("#contType").val()
		},
		rowNum:500, rownumbers: true, rowList:[10,20,30,50,100,500,1000], pager: '#bondsTypeDetailDivPager',
		height:250, width:680, 
		sortname: 'BRANCHNM', sortorder: "asc",
// 		caption:'채권유형별 상세', 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { bondsDivInitCnt++; },
		afterInsertRow: function(rowid, aData){},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#bondsTypeDetail").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}

</script>
</head>
<body>
<div class="jqmVendorWindow" id="bondsDetailPop">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<input type="hidden" id="stdyyyymm" name="stdyyyymm"/>
				<input type="hidden" id="bondsType" name="bondsType"/>
				<input type="hidden" id="contType" 	name="contType"/>
			</td>
			<td>
				<div id="vendorDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>채권유형별 상세</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose" >
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
										<button id='allExcelButton2' class="btn btn-success btn-xs"><i class="fa fa-file-excel-o"></i> 엑셀</button>
									</td>
								</tr>
								<tr>
									<td>
										<div id="jqgrid">
											<table id="bondsTypeDetail"></table>
											<div id="bondsTypeDetailDivPager"></div>
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
										<button id="bondsCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
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
