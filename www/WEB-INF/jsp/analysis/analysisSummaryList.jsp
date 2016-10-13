<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList        = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto        userInfoDto     = CommonUtils.getLoginUserDto(request);//사용자 정보
	String              listWidth       = "1500";
	String              listHeight      = "115";
	String              srcResultToYear = CommonUtils.getCustomDay("MONTH", -1).substring(0, 4);
	String              menuTitle       = "경영정보";
	boolean             isMng           = CommonUtils.isMngUser(userInfoDto); // 메니져 여부
	
	if(isMng){
		menuTitle  = "종합공급현황";
		listHeight = "30";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/jquery.jqChart.css" rel="stylesheet" type="text/css" />
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/excanvas.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqChart.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqRangeSlider.min.js" type="text/javascript"></script>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;

$(document).ready(function() {
	fnInitEvent(); // 화면내 이벤트 초기화
	fnInitCodeData(); //코드값 조회
});

$(window).bind('resize', function() {
	$("#list").setGridWidth(<%=listWidth %> );
	$('#jqChart').jqChart('update');
}).trigger('resize');

function fnInitEvent(){
	$("#srcButton").click(function(){
		fnSearch();
	});
	
	$('#srcResultToYear').keydown(function(e){
		if(e.keyCode==13){
			$('#srcButton').click();
		}
	});
	
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
	
	$("#srcDaySalesList").click(function(){
		fnDynamicForm("/analysis/analysisWeekDaySalesList.sys?_menuCd=ADM_ANAL_SUM", "","");
	});
	
	$("#excelButton").click(function(){
		exportExcel();
	});
<%
	if(isMng == false){
%>
	$('#jqChart').bind('tooltipFormat', function (e, data) {
		var str = fnToolTipFormat(e, data);
		
		return str;
	});
<%
	}
%>
}

function fnToolTipFormat(e, data){
	var result = "";
	
	result = result + "<font color='blue'>";
	result = result + 	data.x;
	result = result + "</font>";
	result = result + "<br />";
	result = result + "<font color='black'>";
	result = result + 	"<b>";
	result = result +		fnComma( data.y );
	result = result +	"</b>";
	result = result +	" 백만원";
	result = result + "</font>";
	result = result + "<br />";
	
	return result;
}

function fnInitCodeData() {
	var d           = new Date();
	var currentYear = leadingZeros(d.getFullYear(), 4);
	var i           = 0;
	var option      = null;
	
	for(i = currentYear; i > 2009; i--) {
		option = "<option value='" + i + "'>" + i + "</option>";
		
		$('#srcResultToYear').append(option);
	}
	
	fnInitComponent(); //화면 초기화
}

//화면 component 상태 초기화
function fnInitComponent() {
	$('#srcResultToYear').val('<%=srcResultToYear%>'); //실적년도
	
	initList();//그리드 초기화
}

function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisSummaryListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['구분','1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월','합계'],
		colModel:[
			{ name:'gubun',index:'gubun',width:90,align:"left",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"SALE:매출;BUYI:매입;PROF:이익금;PROR:이익율"}
			},//구분
			{ name:'m1',index:'m1',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//1월
			{ name:'m2',index:'m2',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//2월
			{ name:'m3',index:'m3',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//3월
			{ name:'m4',index:'m4',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//4월
			{ name:'m5',index:'m5',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//5월
			{ name:'m6',index:'m6',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//6월
			{ name:'m7',index:'m7',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//7월
			{ name:'m8',index:'m8',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//8월
			{ name:'m9',index:'m9',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//9월
			{ name:'m10',index:'m10',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//10월
			{ name:'m11',index:'m11',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//11월
			{ name:'m12',index:'m12',width:110,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},//12월
			{ name:'summary_tota_amou',index:'summary_tota_amou',width:110,align:"right",search:false,sortable:false,hidden:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			}//합계
		],
		postData: {
			srcResultToYear:$('#srcResultToYear').val()
		},
		rowNum:0,rownumbers:false,
		height:<%=listHeight%> ,width:<%=listWidth %>,
		sortname:'',sortorder:'',
		caption:"경영정보 (단위 : 백만원)",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			
			if(rowCnt > 0){
				var selrowContent  = jq("#list").jqGrid('getRowData',1);
				var selrowContent2 = jq("#list").jqGrid('getRowData',2);
				var selrowContent3 = jq("#list").jqGrid('getRowData',3);
				
				$('#sale').html(fnComma(selrowContent.summary_tota_amou));
<%
	if(isMng == false){
%>
				$('#buyi').html(fnComma(selrowContent2.summary_tota_amou));
				$('#prof').html(fnComma(selrowContent3.summary_tota_amou));
				
				fnInitChart();//Chart 초기화
				var row0 = $("#list").getDataIDs()[0];
				var row0Data = $("#list").jqGrid('getRowData',row0);
				var row1 = $("#list").getDataIDs()[1];
				var row1Data = $("#list").jqGrid('getRowData',row1);
				
				var add_m1 = row0Data.m1==0 ? 0 : (row0Data.m1-row1Data.m1)*100/row0Data.m1;
				var add_m2 = row0Data.m2==0 ? 0 : (row0Data.m2-row1Data.m2)*100/row0Data.m2;
				var add_m3 = row0Data.m3==0 ? 0 : (row0Data.m3-row1Data.m3)*100/row0Data.m3;
				var add_m4 = row0Data.m4==0 ? 0 : (row0Data.m4-row1Data.m4)*100/row0Data.m4;
				var add_m5 = row0Data.m5==0 ? 0 : (row0Data.m5-row1Data.m5)*100/row0Data.m5;
				var add_m6 = row0Data.m6==0 ? 0 : (row0Data.m6-row1Data.m6)*100/row0Data.m6;
				var add_m7 = row0Data.m7==0 ? 0 : (row0Data.m7-row1Data.m7)*100/row0Data.m7;
				var add_m8 = row0Data.m8==0 ? 0 : (row0Data.m8-row1Data.m8)*100/row0Data.m8;
				var add_m9 = row0Data.m9==0 ? 0 : (row0Data.m9-row1Data.m9)*100/row0Data.m9;
				var add_m10 = row0Data.m10==0 ? 0 : (row0Data.m10-row1Data.m10)*100/row0Data.m10;
				var add_m11 = row0Data.m11==0 ? 0 : (row0Data.m11-row1Data.m11)*100/row0Data.m11;
				var add_m12 = row0Data.m12==0 ? 0 : (row0Data.m12-row1Data.m12)*100/row0Data.m12;
				var newRowId = $("#list").getDataIDs().length+1;
				for(var i=1;i<13;i++) {
					$("#list").jqGrid('setColProp', 'm'+i,{formatoptions:{decimalPlaces:1}});
				}
				$("#list").addRowData(newRowId, {gubun:'PROR',m1:add_m1,m2:add_m2,m3:add_m3,m4:add_m4,m5:add_m5,m6:add_m6,m7:add_m7,m8:add_m8,m9:add_m9,m10:add_m10,m11:add_m11,m12:add_m12});
<%
	}
%>
			}
		},
		onSelectRow:function(rowid,iRow,iCol,e) {},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {},
		afterInsertRow:function(rowid, aData) {},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
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

function fnInitChart() {
	var selrowContent = jq("#list").jqGrid('getRowData',1);
	var saleM1 = Number(selrowContent.m1.replace(/,/g, ""));
	var saleM2 = Number(selrowContent.m2.replace(/,/g, ""));
	var saleM3 = Number(selrowContent.m3.replace(/,/g, ""));
	var saleM4 = Number(selrowContent.m4.replace(/,/g, ""));
	var saleM5 = Number(selrowContent.m5.replace(/,/g, ""));
	var saleM6 = Number(selrowContent.m6.replace(/,/g, ""));
	var saleM7 = Number(selrowContent.m7.replace(/,/g, ""));
	var saleM8 = Number(selrowContent.m8.replace(/,/g, ""));
	var saleM9 = Number(selrowContent.m9.replace(/,/g, ""));
	var saleM10 = Number(selrowContent.m10.replace(/,/g, ""));
	var saleM11 = Number(selrowContent.m11.replace(/,/g, ""));
	var saleM12 = Number(selrowContent.m12.replace(/,/g, ""));
	
	var selrowContent2 = jq("#list").jqGrid('getRowData',2);
	var buyiM1 = Number(selrowContent2.m1.replace(/,/g, ""));
	var buyiM2 = Number(selrowContent2.m2.replace(/,/g, ""));
	var buyiM3 = Number(selrowContent2.m3.replace(/,/g, ""));
	var buyiM4 = Number(selrowContent2.m4.replace(/,/g, ""));
	var buyiM5 = Number(selrowContent2.m5.replace(/,/g, ""));
	var buyiM6 = Number(selrowContent2.m6.replace(/,/g, ""));
	var buyiM7 = Number(selrowContent2.m7.replace(/,/g, ""));
	var buyiM8 = Number(selrowContent2.m8.replace(/,/g, ""));
	var buyiM9 = Number(selrowContent2.m9.replace(/,/g, ""));
	var buyiM10 = Number(selrowContent2.m10.replace(/,/g, ""));
	var buyiM11 = Number(selrowContent2.m11.replace(/,/g, ""));
	var buyiM12 = Number(selrowContent2.m12.replace(/,/g, ""));
	
	$('#jqChart').jqChart({
		title: { text: '' },
		animation: { duration: 1 },
		series: [
			{ type:'column',title:'매출',data: [['1월',saleM1],['2월',saleM2],['3월',saleM3],['4월',saleM4],
															['5월',saleM5],['6월',saleM6],['7월',saleM7],['8월',saleM8],
															['9월',saleM9],['10월',saleM10],['11월',saleM11],['12월',saleM12]]
			},
			{ type:'column',title:'매입',data: [['1월',buyiM1],['2월',buyiM2],['3월',buyiM3],['4월',buyiM4],
															['5월',buyiM5],['6월',buyiM6],['7월',buyiM7],['8월',buyiM8],
															['9월',buyiM9],['10월',buyiM10],['11월',buyiM11],['12월',buyiM12]]
			}
		]
	});
}

function fnSearch() {
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcResultToYear = $('#srcResultToYear').val();
	jq("#list").jqGrid("setGridParam", { "postData":data });
	jq("#list").trigger("reloadGrid");
}

//사용자 함수
function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();
	if(n.length < digits) {
		for(var i = 0; i < digits - n.length; i++)
			zero += '0';
	}
	return zero + n;
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['구분','1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];	//출력컬럼명
	var colIds = ['gubun','m1','m2','m3','m4','m5','m6','m7','m8','m9','m10','m11','m12'];	//출력컬럼ID
	var numColIds = ['m1','m2','m3','m4','m5','m6','m7','m8','m9','m10','m11','m12'];	//숫자표현ID
	var sheetTitle = "<%=menuTitle%>";	//sheet 타이틀
	var excelFileName = "analysisSummaryList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>
<body style="background-color:#ffffff;">
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<form id="frm" name="frm" method="post" onsubmit="return false;">
	<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" />
						</td>
						<td height="29" class="ptitle"><%=menuTitle %></td>
						<td align="right" class="ptitle">
<%
	if(isMng == false){
%>
							<button id='srcSummaryList'    class="btn btn-default btn-sm"><i class="fa fa-search"> 경영정보</i></button>
							<button id='srcMonthSalesList' class="btn btn-default btn-sm"><i class="fa fa-search"> 월별</i></button>
							<button id='srcTypeSalesList'  class="btn btn-default btn-sm"><i class="fa fa-search"> 자재유형별</i></button>
							<button id='srcOrderSalesList' class="btn btn-default btn-sm"><i class="fa fa-search"> 주문상태별</i></button>
							<button id='srcDaySalesList'   class="btn btn-default btn-sm"><i class="fa fa-search"> 일자별</i></button>
<%
	}
%>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height="1"></td>
		</tr>
		<tr>
			<td>
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
					<tr>
						<td colspan="6" height="1" bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="80">실적년도</td>
						<td colspan="5" class="table_td_contents">
							<select id="srcResultToYear" name="srcResultToYear" class="select"></select> 년
						</td>
					</tr>
					<tr>
						<td colspan="6" height="1" bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height="5"></td>
		</tr>
		<tr>
			<td>
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="80">&nbsp;</td>
						<td height="29" class="ptitle">매출 : <span id="sale" style="display:inline-block;color:blue;"></span> <span style="font-size: small;">백만원</span></td>
						<td width="80">&nbsp;</td>
<%
	if(isMng == false){
%>
						<td height="29" class="ptitle">매입 : <span id="buyi" style="display:inline-block;color:blue;"></span> <span style="font-size: small;">백만원</span></td>
						<td width="80">&nbsp;</td>
						<td height="29" class="ptitle">이익금 : <span id="prof" style="display:inline-block;color:red;"></span> <span style="font-size: small;">백만원</span></td>
						<td width="80">&nbsp;</td>
<%
	}
%>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" valign="top"></td>
						<td height="27px" align="right" valign="middle">
							<button id='excelButton' class="btn btn-success btn-xs"><i class="fa fa-file-excel-o"> 엑셀</i></button>
							<button id='srcButton' class="btn btn-default btn-xs"><i class="fa fa-search"> 조회</i></button>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<div id="jqgrid">
					<table id="list"></table>
				</div>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
<%
	if(isMng == false){
%>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
					<tr>
						<td width="20" valign="top">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
						</td>
						<td class="stitle">

							<table>
								<tr>
									<td>월별 매출실적</td>
									<td>&nbsp;&nbsp;&nbsp;<font color="red">*</font>(마우스 커서를 그래프 위에 올리시면 상세 내역 확인 가능합니다.)</td>
								</tr>
							</table>

						</td>
					</tr>
				</table>
<%
	}
%>
			</td>
		</tr>
		<tr>
			<td>
				<div id="jqChart" style="height:300px;"></div>
			</td>
		</tr>
		<tr>
			<td height="5"></td>
		</tr>
	</table>
</form>
</body>
</html>