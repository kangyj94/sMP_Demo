<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "(($(window).height()-590) ) + Number(gridHeightResizePlus)";
// 	String listWidth = "$(window).width()-50 + Number(gridWidthResizePlus)";
	String listWidth = "1500";
	
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String srcStartYear = "2015";
	String srcYear = CommonUtils.getCurrentDate().substring(0, 4);

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	$("#srcYear").change( function() { fnSearch1(); });
	$("#srcButton2").click( function() { fnSearch2(); });
	$('#srcVendorNm').keydown(function(e){ if(e.keyCode==13) { $('#srcButton2').click(); }});
	$("#excelButton1").click( function() { exportExcel1(); });
	$("#excelButton2").click( function() { exportExcel2(); });
	
	//코드값 조회
	fnInitCodeData();
});

//Component Data Bind
function fnInitCodeData() {
	for(var i=<%=srcStartYear%>; i<=<%=srcYear%> ;i++) {
		var strYear = i;
		$('#srcYear').append("<option value='"+strYear+"'>"+strYear+"</option>");
	}
	
	$('#srcYear').val('<%=srcYear%>');
}




$(window).bind('resize', function() {
	$("#list2").setGridHeight(<%=listHeight %>);
	$("#list1").setGridWidth(<%=listWidth%>);
	$("#list2").setGridWidth(<%=listWidth%>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">

var prevCellVal1 = { cellId: undefined, value: undefined };
$(function() {
	$("#list1").jqGrid({
		url:'/board/selectSmileEvalList/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['평가대상SVCCD','평가자SVCCD','평가대상SVCNM','평가자SVCNM','전주','금주','1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		colModel:[
			{name:'TARGET_SVCTYPECD',index:'TARGET_SVCTYPECD',hidden:true},//구분cd
			{name:'SVCTYPECD',index:'SVCTYPECD',hidden:true},//구분cd2
			{ name:'TARGET_SVCTYPECDNM', index:'TARGET_SVCTYPECDNM', width:100, align:'center', search:false, sortable:true,
				cellattr: function (rowId, val, rawObject, cm, rdata){
					var result;
					
					if( rawObject.TARGET_SVCTYPECD == 'VEN'){ 
						result = ' colspan=2';
					}else if (prevCellVal1.value == rawObject.TARGET_SVCTYPECD) {
						result = ' style="display: none" rowspanid="' + prevCellVal1.cellId + '"';
					}else  {
						var cellId = this.id + '_row_' + rowId + '_' + cm.name;
						result = ' rowspan="1" id="' + cellId + '"';
						prevCellVal1 = { cellId: cellId, value: rawObject.TARGET_SVCTYPECD };
					}
					
					return result;
				}
			},//공사구분
			{name:'SVCTYPECDNM',index:'SVCTYPECDNM',width:100,align:"center",editable:false,
				cellattr: function (rowId, val, rawObject, cm, rdata){
					var result;
					
					if(rawObject.TARGET_SVCTYPECD == 'VEN' ){ 
						result = " style='display:none;'";
					}
					return result;
				}
			},//구분
			{name:'LAST_EVAL',index:'LAST_EVAL',width:90,align:"right",editable:false },//전주
			{name:'THIS_EVAL',index:'THIS_EVAL',width:90,align:"right",editable:false },//금주
			{name:'M1',index:'M1',width:85,align:"right",editable:false },
			{name:'M2',index:'M2',width:85,align:"right",editable:false },
			{name:'M3',index:'M3',width:85,align:"right",editable:false },
			{name:'M4',index:'M4',width:85,align:"right",editable:false },
			{name:'M5',index:'M5',width:85,align:"right",editable:false },
			{name:'M6',index:'M6',width:85,align:"right",editable:false },
			{name:'M7',index:'M7',width:85,align:"right",editable:false },
			{name:'M8',index:'M8',width:85,align:"right",editable:false },
			{name:'M9',index:'M9',width:85,align:"right",editable:false },
			{name:'M10',index:'M10',width:85,align:"right",editable:false },
			{name:'M11',index:'M11',width:85,align:"right",editable:false },
			{name:'M12',index:'M12',width:85,align:"right",editable:false }
		],
		postData: { srcYear : $("#srcYear").val()},
		height: 80,width: <%=listWidth%>,
		sortname: '', sortorder: "", rowSpan:true, rowSpanCol:['temp'],
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		afterInsertRow: function(rowid, aData) {
			
			if( aData.TARGET_SVCTYPECD != 'ADM' ){
				$(this).setCell(rowid,'TARGET_SVCTYPECDNM','',{color:'#0000ff',cursor:'pointer'});
			}
			$(this).setCell(rowid,'SVCTYPECDNM','',{color:'#0000ff',cursor:'pointer'});
		},
		loadComplete: function(rowid) {
			var grid = this;
			$('td[rowspan="1"]', grid).each(function () {
				var spans = $('td[rowspanid="' + this.id + '"]', grid).length + 1;
				if (spans > 1) {
					$(this).attr('rowspan', spans);
				}
			});
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = $("#list1").jqGrid('getRowData',rowid);
			var cm = $("#list1").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['name']=="TARGET_SVCTYPECDNM" ) {
				if( selrowContent.TARGET_SVCTYPECD != 'ADM' ){
					$("#borgGubun").html("(공급사 지수)");
					fnSearch2( selrowContent.TARGET_SVCTYPECD , selrowContent.SVCTYPECD );
				}
			}
			if(colName != undefined &&colName['name']=="SVCTYPECDNM" ) {
				$("#borgGubun").html("(SKT지수TS - "+ selrowContent.SVCTYPECDNM +")");
				fnSearch2( selrowContent.TARGET_SVCTYPECD , selrowContent.SVCTYPECD  );
			}
			
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});

	$("#list1").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
			groupHeaders:[
				{startColumnName: 'M1', numberOfColumns: 12, titleText: '월간단위'},
				{startColumnName: 'LAST_EVAL', numberOfColumns: 2, titleText: '주간단위'}
				
			]
	});

	$("#list1").jqGrid("setLabel", "TARGET_SVCTYPECDNM", "구분", "", {
		style: "width: 120px;",
		colspan: "2"
	});
	$("#list1").jqGrid("setLabel", "SVCTYPECDNM", "", "", {style: "display: none"});
	
	
	$("#list2").jqGrid({
		url:'/board/selectSmileEvalDetileList/list.sys',
		datatype: 'local',
		mtype: 'POST',
		colNames:['업체명','전주','금주','1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		colModel:[
			{name:'BORGNM',index:'BORGNM',width:186,align:"center",editable:false },//업체명
			{name:'LAST_EVAL',index:'LAST_EVAL',width:100,align:"right",editable:false },//전주
			{name:'THIS_EVAL',index:'THIS_EVAL',width:100,align:"right",editable:false },//금주
			{name:'M1',index:'M1',width:85,align:"right",editable:false },
			{name:'M2',index:'M2',width:85,align:"right",editable:false },
			{name:'M3',index:'M3',width:85,align:"right",editable:false },
			{name:'M4',index:'M4',width:85,align:"right",editable:false },
			{name:'M5',index:'M5',width:85,align:"right",editable:false },
			{name:'M6',index:'M6',width:85,align:"right",editable:false },
			{name:'M7',index:'M7',width:85,align:"right",editable:false },
			{name:'M8',index:'M8',width:85,align:"right",editable:false },
			{name:'M9',index:'M9',width:85,align:"right",editable:false },
			{name:'M10',index:'M10',width:85,align:"right",editable:false },
			{name:'M11',index:'M11',width:85,align:"right",editable:false },
			{name:'M12',index:'M12',width:85,align:"right",editable:false }
		],
		postData: {},
		rowNum:30, rownumbers: false,
		height: <%=listHeight%>,width: <%=listWidth%>,
		sortname: '', sortorder: "", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
	$("#list2").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
			groupHeaders:[
				{startColumnName: 'M1', numberOfColumns: 12, titleText: '월간단위'},
				{startColumnName: 'LAST_EVAL', numberOfColumns: 2, titleText: '주간단위'}
				
			]
	});
	
});


function fnSearch1(){
	prevCellVal1 = { cellId: undefined, value: undefined };
	$("#list1").jqGrid("setGridParam");
	var data = $("#list1").jqGrid("getGridParam", "postData");
	data.srcYear = $("#srcYear").val();
	
	$("#list1")
		.jqGrid("setGridParam", {'postData':data})
		.trigger("reloadGrid");
}

function fnSearch2( targetSvcCd , evalSvcCd ){
	
	$("#list2").jqGrid("setGridParam");
	var data = $("#list2").jqGrid("getGridParam", "postData");
	data.srcYear = $("#srcYear").val();
	data.srcBorgNm = $("#srcVendorNm").val();
	
	if(  targetSvcCd  && evalSvcCd ){
		data.targetSvcCd = targetSvcCd ;;
		data.evalSvcCd = evalSvcCd ;
	}
	
	$("#list2")
		.jqGrid("setGridParam", {'postData':data, 'datatype':'json'})
		.trigger("reloadGrid");
}



/**
 * list Excel Export
 */
function exportExcel1() {
	var colLabels = ['평가대상SVCNM','평가자SVCNM','전주','금주','1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
	var colIds = ['TARGET_SVCTYPECDNM','SVCTYPECDNM','LAST_EVAL','THIS_EVAL','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var figureColIds = [];
	var sheetTitle = "스마일 통계";	//sheet 타이틀
	var excelFileName = "SmileEvalList";	//file명
	
	fnExportExcel($("#list1"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}


/**
 * list Excel Export
 */
function exportExcel2() {
	var colLabels =['업체명','전주','금주','1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
	var colIds = ['BORGNM','LAST_EVAL','THIS_EVAL','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var figureColIds = [];
	var sheetTitle = "스마일통계 상세";	//sheet 타이틀
	var excelFileName = "SmileEvalDetailList";//file명
	
	fnExportExcel($("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}



</script>


</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
	<form id="frm" name="frm" method="post" onsubmit="return false;"> 
	<input id ="create_borgid" name="create_borgid" type="hidden" />
	<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
						</td>
						<td height="25" class="ptitle">스마일 통계</td>
						<td align="right" valign="bottom" class="ptitle">
							<button id='excelButton1' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
						</td>
					</tr>
					<tr><td style="height: 1px;" colspan="3"></td></tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="80">조회년도</td>
						<td colspan="5" class="table_td_contents">
							<select id="srcYear" name="srcYear" class="select"></select> 년
						</td>
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
			<td>
				<!-- 타이틀 시작 -->
				<table width="1500px" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" valign="top">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
						</td>
						<td class="stitle">고객사 항목</td>
					</tr>
					<tr><td style="height: 5px;" colspan="3"></td></tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		
		<tr>
			<td>
				<div id="jqgrid">
					<table id="list1"></table>
				</div>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="1500px" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" valign="middle">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
						</td>
						<td class="stitle" >상세내용 <span id="borgGubun"></span></td>
						<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
							<button id='excelButton2' class="btn btn-success btn-sm" ><i class="fa fa-file-excel-o"></i> 엑셀</button>
							<button id='srcButton2' class="btn btn-default btn-sm" ><i class="fa fa-search"></i>조회</button>
						</td>
					</tr>
					<tr><td style="height: 1px;" colspan="3"></td></tr>
					</tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
				<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="80">업체명</td>
						<td colspan="5" class="table_td_contents">
							<input type="text" id="srcVendorNm" name="srcVendorNm"></input>
						</td>
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
			<td>
				<div id="jqgrid">
					<table id="list2"></table>
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