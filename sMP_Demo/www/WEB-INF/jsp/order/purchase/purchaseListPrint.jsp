<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-310 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	// 주문유형
	List<CodesDto> orderTypeCode = (List<CodesDto>)request.getAttribute("orderTypeCode");
	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
	boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
	boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;
	// 날짜 세팅
	String srcPurcStartDate = CommonUtils.getCustomDay("DAY", -7);
	String srcPurcEndDate = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<%
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp" %>
<!-- 공급사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcVendorName = "";
	String _srcVendorId = "";
	if("VEN".equals(loginUserDto.getSvcTypeCd())) {
		_srcVendorName = loginUserDto.getBorgNm();
		_srcVendorId = loginUserDto.getBorgId();
	}
%>
	$("#srcVendorName").val("<%=_srcVendorName%>");
	$("#srcVendorId").val("<%=_srcVendorId%>");
<%	if("VEN".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#srcVendorName").attr("disabled", true);
	$("#btnVendor").css("display","none");
<%	}	%>

	$("#btnVendor").click(function(){
		var vendorNm = $("#srcVendorName").val();
		fnVendorDialog(vendorNm, "fnCallBackVendor"); 
	});
	$("#srcVendorName").keydown(function(e){ if(e.keyCode==13) { $("#btnVendor").click(); } });
	$("#srcVendorName").change(function(e){
		if($("#srcVendorName").val()=="") {
			$("#srcVendorId").val("");
		}
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackVendor(vendorId, vendorNm, areaType) {
	$("#srcVendorId").val(vendorId);
	$("#srcVendorName").val(vendorNm);
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	
	$("#srcOrdeIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcButton").click(function(){ 
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcPurcStartDate").val($.trim($("#srcPurcStartDate").val()));
		$("#srcPurcEndDate").val($.trim($("#srcPurcEndDate").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		fnSearch(); 
	});
	$("#allExcelButton").click(function(){ 
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcPurcStartDate").val($.trim($("#srcPurcStartDate").val()));
		$("#srcPurcEndDate").val($.trim($("#srcPurcEndDate").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		fnSearchPurcExcelView(); 
	});
	
	// 날짜 세팅
	$("#srcPurcStartDate").val("<%=srcPurcStartDate%>");
	$("#srcPurcEndDate").val("<%=srcPurcEndDate%>");
	
   // 날짜 조회 및 스타일
   $(function(){
   	$("#srcPurcStartDate").datepicker(
          	{
   	   		showOn: "button",
   	   		buttonImage: "/img/system/btn_icon_calendar.gif",
   	   		buttonImageOnly: true,
   	   		dateFormat: "yy-mm-dd"
          	}
   	);
   	$("#srcPurcEndDate").datepicker(
          	{
          		showOn: "button",
          		buttonImage: "/img/system/btn_icon_calendar.gif",
          		buttonImageOnly: true,
          		dateFormat: "yy-mm-dd"
          	}
   	);
   	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
   });
   
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/purchase/purchasePrintListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:[ '고객유형','주문번호','발주접수일', '공급사명','주문자명','주문일자', '납품요청일','주문유형','배송처주소','출력','vendorid'],
		colModel:[
			{name:'worknm',index:'worknm', width:200,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_iden_numb',index:'orde_iden_numb', width:90,align:"center",search:false,sortable:true, editable:false },
			{name:'purc_rece_date',index:'purc_rece_date', width:110,align:"center",search:false,sortable:true, editable:false },
			{name:'vendornm',index:'vendornm', width:200,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_user_name',index:'orde_user_name', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'regi_date_time',index:'regi_date_time', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'orde_type_clas',index:'orde_type_clas', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'tran_data_addr',index:'tran_data_addr', width:520,align:"left",search:false,sortable:true, editable:false },
			{name:'purc_print',index:'purc_print', width:50,align:"center",search:false,sortable:true, editable:false },
			{name:'vendorid',index:'vendorid',search:false,sortable:true, editable:false,hidden:true}
		],  
		postData: {
			srcVendorId:$('#srcVendorId').val()
			,srcPurcStartDate:$('#srcPurcStartDate').val()
			,srcPurcEndDate:$('#srcPurcEndDate').val()
			,srcOrdeIdenNumb:$('#srcOrdeIdenNumb').val()
		},multiselect:false ,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		sortname: 'purc_rece_date', sortorder: "desc", 
		height: <%=listHeight%>,width:<%=listWidth%>, 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				var inputBtn = "<input style='width:90%;' type='button' value='출력' onclick=\"fnPurcPrint('"+rowid+"');\" />"; 
				jq('#list').jqGrid('setRowData',rowid,{purc_print:inputBtn});
			}
		},
		afterInsertRow: function(rowid, aData){ 
<%if(isAdm){%>
			jq("#list").setCell(rowid,'vendornm','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'vendornm','',{cursor: 'pointer'});
<%}%>
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){ 
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
<%if(isAdm){%>
			if(colName != undefined &&colName['index']=="vendornm") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.vendorid);")%>
			}
<%}%>
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch(){
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcVendorId= $("#srcVendorId").val();
	data.srcPurcStartDate= $("#srcPurcStartDate").val();
	data.srcPurcEndDate= $("#srcPurcEndDate").val();
	data.srcOrdeIdenNumb= $("#srcOrdeIdenNumb").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
/** list Excel Export */
function exportExcel() {
	var colLabels = ['주문번호','발주접수일', '공급사명','주문자명','주문일자', '납품요청일','주문유형','배송처주소'];
	var colIds = ['orde_iden_numb','purc_rece_date','vendornm','orde_user_name','regi_date_time','requ_deli_date','orde_type_clas','tran_data_addr'];
	var numColIds = [''];	
	var sheetTitle = "발주접수";	
	var excelFileName = "purchasePrintList";	
    fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");    
}
function fnSearchPurcExcelView(){
	var colLabels = ['주문번호','발주접수일', '공급사명','주문자명','주문일자', '납품요청일','주문유형','배송처주소'];
	var colIds = ['ORDE_IDEN_NUMB','PURC_RECE_DATE','VENDORNM','ORDE_USER_NAME','REGI_DATE_TIME','REQU_DELI_DATE','ORDE_TYPE_CLAS','TRAN_DATA_ADDR'];
	var numColIds = [''];	
	var sheetTitle = "발주접수";	
	var excelFileName = "purchasePrintList";	
	
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcVendorId';
    fieldSearchParamArray[1] = 'srcPurcStartDate';
    fieldSearchParamArray[2] = 'srcPurcEndDate';
    fieldSearchParamArray[3] = 'srcOrdeIdenNumb';
    
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/purchase/purchasePrintListExcelView.sys");  
}
</script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script type="text/javascript">
function fnPurcPrint(str){

    var selrowContent = jq("#list").jqGrid('getRowData',str);
    var orde_num = selrowContent.orde_iden_numb;
    var vendorid = selrowContent.vendorid;
    orde_num = orde_num.substring(0,13);
	var oReport = GetfnParamSet(); // 필수
<%if(loginUserDto.getBorgId().equals("VEN0189153")){ // 그레이트 테크%>
	oReport.rptname = "purcPrintNoPric"; // reb 파일이름
<%}else{%>
	oReport.rptname = "purcPrint"; // reb 파일이름
<%}%>
	oReport.param("orde_iden_numb").value = orde_num; // 매개변수 세팅
	
	oReport.param("vendorid").value 	 	 = vendorid;
	oReport.title = "발주확인출력"; // 제목 세팅
	oReport.open();
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//발주서 출력
	header = "발주서 출력";
	manualPath = "/img/manual/vendor/purchaseListPrint.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top" style="height: 29px">
					<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
					<td class='ptitle'>발주서 출력
					<%if(isVendor){ %>
						&nbsp;<span id="question" class="questionButton">도움말</span>
					<%} %>
					</td>
					<td align="right" class='ptitle'>
						<button id='allExcelButton' class="btn btn-success btn-sm" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class="fa fa-file-excel-o"></i> 엑셀</button>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
							<i class="fa fa-search"></i> 조회
						</button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr> 
				<tr>
					<td class="table_td_subject" width="100">공급사</td>
					<td class="table_td_contents">
						<input id="srcVendorName" name="srcVendorName" type="text" value="" size="" maxlength="50" style="width: 150px" />&nbsp;<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18"  style="vertical-align: middle; cursor: pointer;" /><input type="hidden" id="srcVendorId" name="srcVendorId" value=""/></td>
					<td width="100" class="table_td_subject">발주접수일자</td>
					<td class="table_td_contents">
						<input type="text" name="srcPurcStartDate" id="srcPurcStartDate" style="width: 75px;vertical-align: middle;" /> 
						~ 
						<input type="text" name="srcPurcEndDate" id="srcPurcEndDate" style="width: 75px;vertical-align: middle;" />
					</td>
					<td width="100" class="table_td_subject">주문번호</td>
					<td class="table_td_contents"><input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="" maxlength="50" style="width: 100px" /></td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
			</table>
		</td>
		</tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td>
			<div id="jqgrid">
				<table id="list"></table>
				<div id="pager"></div>
			</div>
		</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>