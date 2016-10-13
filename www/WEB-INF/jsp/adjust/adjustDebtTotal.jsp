<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
   String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
   //그리드의 width와 Height을 정의
   String listHeight = "$(window).height()-328 + Number(gridHeightResizePlus)";
//    String listWidth = "$(window).width()-50 + Number(gridWidthResizePlus)";
   String listWidth = "1500";

   @SuppressWarnings("unchecked")
   //화면권한가져오기(필수)
   List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!--------------------------- Modal Dialog Start --------------------------->
<!--------------------------- Modal Dialog End --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcButton").click(function(){fnSearch();});
	$("#colButton").click( function(){ jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });	
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	$("#srcVendorNm").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
   	$("#srcBusinessNum").keydown(function(e){
   		if(e.keyCode == '13'){
   			fnSearch();
   		}
   	});
});

$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustDebtTotalListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['vendorId','최종등록일','매입처','사업자등록번호','사업자','총채무','지급금액','잔액','평균지급기일','채무현황'],
		colModel:[
			{name:'vendorId', index:'vendorId',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },//vendorId
			{name:'creat_date', index:'creat_date',width:100,align:"center",search:false,sortable:true, editable:false, },//최종등록일
			{name:'vendorNm', index:'vendorNm',width:402,align:"left",search:false,sortable:true, editable:false },//매입처
			{name:'businessNum', index:'businessNum',width:120,align:"center",search:false,sortable:true, editable:false },//사업자등록번호
			{name:'pressentNm',index:'pressentNm',width:80,align:"center",search:false,sortable:true, editable:false },//사업자
			{name:'buyi_tota_amou',index:'buyi_tota_amou',width:150,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//총채무
			{name:'rece_pay_amou',index:'rece_pay_amou',width:150,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//지급금액
			{name:'balance_amou',index:'balance_amou',width:150,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//잔액
			{name:'avg_day',index:'avg_day',width:80,align:"center",search:false,sortable:true, editable:false , hidden:true,
				sorttype:'number',formatter:'number',formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 2, prefix:"" }},//평균지급기일
			{name:'debtInfo',index:'debtInfo',width:260,align:"center",search:false,sortable:false, editable:false }//채무현황
		],
		postData: {
			srcVendorNm:$("#srcVendorNm").val(),
			srcBusinessNum:$("#srcBusinessNum").val(),
			selectType:"list"
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,500,1000], pager: '#pager',
		height: <%=listHeight%>,width: <%=listWidth%>,
		sortname: 'clos_buyi_date', sortorder: 'desc',
		caption:"", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					var descStr	= "<button onClick=\"javaScript:onVendorView('"+selrowContent.vendorId+"')\" id='vendorView' class='btn btn-primary btn-xs' style='padding-top: 0px;padding-bottom: 0px;border-radius: 5px;' ><i class='fa fa-search'></i> 업체별</button>";
					descStr		+= "&nbsp;";
					descStr		+= "<button onClick=\"javaScript:onDebtView('"+selrowContent.vendorId+"')\" id='debtView' class='btn btn-primary btn-xs' style='padding-top: 0px;padding-bottom: 0px;border-radius: 5px;' ><i class='fa fa-search'></i> 채무별</button>";
						
					jq("#list").jqGrid('setRowData', rowid, {debtInfo:descStr});
				}
			}  			
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		rownumbers:true
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

function exportExcel() {
	var colLabels = ['최종등록일','매입처','사업자등록번호','사업자','총채무','지급금액','잔액','평균지급기일'];	//출력컬럼명
	var colIds = ['creat_date','vendorNm','businessNum','pressentNm','buyi_tota_amou','rece_pay_amou','balance_amou','avg_day'];	//출력컬럼ID
	var numColIds = ['buyi_tota_amou','rece_pay_amou','balance_amou','avg_day'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "총 채무현황";	//sheet 타이틀
	var excelFileName = "DebtTotalList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['최종등록일','매입처','사업자등록번호','사업자','총채무','지급금액','잔액','평균지급기일'];	//출력컬럼명
	var colIds = ['creat_date','vendorNm','businessNum','pressentNm','buyi_tota_amou','rece_pay_amou','balance_amou','avg_day'];	//출력컬럼ID
	var numColIds = ['buyi_tota_amou','rece_pay_amou','balance_amou','avg_day'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "총 채무현황";	//sheet 타이틀
	var excelFileName = "allDebtTotalList";	//file명
	
	var actionUrl = "/adjust/adjustDebtTotalListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcVendorNm';
	fieldSearchParamArray[1] = 'srcBusinessNum';
	fieldSearchParamArray[2] = 'selectType';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl, figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function fnSearch(){
	jq("#list").jqGrid("setGridParam");
   	var data = jq("#list").jqGrid("getGridParam", "postData");
   	data.srcVendorNm    = $("#srcVendorNm").val();
   	data.srcBusinessNum = $("#srcBusinessNum").val();
   	jq("#list").trigger("reloadGrid");  	
}

//업체별 상세
function onVendorView(vendorId){
	if( vendorId != "" ){
		var popurl = "/adjust/adjustDebtCompany.sys?vendorId=" + vendorId + "&_menuId=<%=_menuId%>";
		var popproperty = "dialogWidth:1100px;dialogHeight=680px;scroll=yes;status=no;resizable=no;";
		//window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=1100, height=680, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }      	
}

//채무별 상세
function onDebtView(vendorId){
	if( vendorId != "" ){
		var popurl = "/adjust/adjustDebtOccurrence.sys?vendorId=" + vendorId + "&_menuId=<%=_menuId%>";
		var popproperty = "dialogWidth:1180px;dialogHeight=800px;scroll=yes;status=no;resizable=no;";
		//window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=1180, height=630, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;">
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">채무관리</td>
					<td align="right" class="ptitle">
						<button id='excelAll' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' class='btn btn-primary btn-sm' >
							<i class='fa fa-search'></i>&nbsp;일괄 Excel 출력하기
						</button>
						<button id='srcButton' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' class='btn btn-primary btn-sm' >
							<i class='fa fa-search'></i>&nbsp;조회
						</button>
					</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="4" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">공급사명</td>
					<td class="table_td_contents" width="500">
						<input id="srcVendorNm" name="srcVendorNm" type="text" value="" size="70" maxlength="50" />
					</td>
					<td class="table_td_subject" width="100" align="left">사업자등록번호</td>
					<td class="table_td_contents">
						<input id="srcBusinessNum" name="srcBusinessNum" type="text" value="" size="70" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td height="20px"></td>
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
<!-------------------------------- Dialog Div Start -------------------------------->
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>