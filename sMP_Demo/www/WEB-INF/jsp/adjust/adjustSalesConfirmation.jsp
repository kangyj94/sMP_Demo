<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight1	= "(($(window).height()-780)) + Number(gridHeightResizePlus)";
	String listHeight2	= "(($(window).height()-695)) + Number(gridHeightResizePlus)";
// 	String listWidth	= "$(window).width()-33 + Number(gridWidthResizePlus)";
	String listWidth	= "1500";
	
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String srcCreatStartDate = CommonUtils.getCustomDay("MONTH", -1);
	String srcCreatEndDate   = CommonUtils.getCurrentDate();
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
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
	$("#srcCreatStartDate").val("<%=srcCreatStartDate%>");
	$("#srcCreatEndDate").val("<%=srcCreatEndDate%>");
	$("#colButton1").click( function(){ jq("#list").jqGrid('columnChooser'); });
	$("#excelButton1").click(function(){ exportExcel1(); });
	$("#colButton2").click( function(){ jq("#list2").jqGrid('columnChooser'); });
	$("#excelButton2").click(function(){ exportExcel2(); });
	$("#srcButton2").click(function(){ onDetail(_sale_sequ_numb, isOnLoad); });
	$("#salesConfirmPartCancelButton").click(function(){ salesConfirmPartCancel(); });
	   
	$("#srcSaleNm").keydown(function(e){
		if(e.keyCode == 13) {
			$("#srcButton").click();
		}
	});

	$("#srcOrdeNumb").keydown(function(e){
		if(e.keyCode == 13) {
			$("#srcButton2").click();
		}
	});
	
	$("#srcBranchNm").keydown(function(e){
		if(e.keyCode == '13'){
			$("#srcButton").click();
		}
	});	
	
	$("#srcButton").click(function(){
		fnSearch();
	});

	$("#confirmButton").click(function(){
		fnSalesConfirm();
	});
	
	$("#cancelButton").click(function(){
		fnSalesCancel();
	});
	
	$("#confirmButton").css("display", "none");
	$("#cancelButton").css("display", "none");
	$("#salesConfirmPartCancelButton").css("display", "none");
	$("#excelAll1").click(function(){ exportExcelToSvc1(); });
	$("#excelAll2").click(function(){ exportExcelToSvc2(); });
	$("#srcSaleStatus").change(function(){ fnSearch(); });
});

//날짜 조회 및 스타일
$(function(){
	$("#srcCreatStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcCreatEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});

$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight1%>);
	$("#list").setGridWidth(<%=listWidth %>);
	
	$("#list2").setGridHeight(<%=listHeight2%>);
	$("#list2").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var isOnLoad = false;
var _sale_sequ_numb = "";
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustSalesConfirmListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		multiselect:true,
		colNames:['정산번호','정산생성일','정산명','세금계산서구매사','매출금액','부가세','합계','정산상태', '매입확정여부','거래내역서','확정일자','SAP전표번호', 'sale_status_code', 'buyi_conf_cnt'],
		colModel:[
			{name:'sale_sequ_numb',index:'sale_sequ_numb',width:60,align:"center",search:false,sortable:true, editable:false },//정산번호
			{name:'crea_sale_date', index:'crea_sale_date',width:100,align:"center",search:false,sortable:true, editable:false },//정산생성일
			{name:'sale_sequ_name',index:'sale_sequ_name',width:240,align:"left",search:false,sortable:true, editable:false },//정산명
			{name:'clientNm',index:'clientNm',width:240,align:"left",search:false,sortable:true, editable:false },//세금계산서구매사
			{name:'sale_requ_amou',index:'sale_requ_amou',width:80,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매출금액
			{name:'sale_requ_vtax',index:'sale_requ_vtax',width:80,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//부가세
			{name:'sale_tota_amou',index:'sale_tota_amou',width:80,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//합계
			{name:'sale_status_name',index:'sale_status_name',width:80,align:"center",search:false,sortable:true, editable:false },//정산상태
			{name:'buyi_status_name',index:'buyi_status_name',width:80,align:"center",search:false,sortable:true, editable:false },//매입확정여부
			{name:'ePay',index:'ePay', width:80,align:"center",search:false,sortable:false,editable:false},
			{name:'sale_conf_date',index:'sale_conf_date',width:100,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'sap_jour_numb',index:'sap_jour_numb',width:120,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'sale_status_code',index:'sale_status_code',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'buyi_conf_cnt',index:'buyi_conf_cnt',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true }
		],
		postData: {
			srcCreatStartDate:$("#srcCreatStartDate").val(),
			srcCreatEndDate:$("#srcCreatEndDate").val(),
			srcSaleStatus:$("#srcSaleStatus").val(),
			srcSaleNm:$("#srcSaleNm").val(),
			srcBranchNm:$("#srcBranchNm").val(),
			srcAccUser:$("#srcAccUser").val()
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,500], pager: '#pager',
		height: <%=listHeight1%>,width: <%=listWidth%>,
		sortname: 'SALE_SEQU_NUMB', sortorder: "DESC",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				var top_rowid = $("#list").getDataIDs()[0];	//첫번째 로우 아이디 구하기
				if(!isOnLoad) {
					isOnLoad = true;
				}else {
					jq("#list2").clearGridData();
				}
				jq("#list").setSelection(top_rowid);
				
				for(var i = 0; i < rowCnt ; i++){
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					var ePayStr   = "<input id='ePay_"+rowid+"' type='button' value='거래내역서' onclick=\"javaScript:fnPay('"+rowid+"');\"/>";
					jq("#list").jqGrid('setRowData', rowid, {ePay:ePayStr});
					
					if(parseInt(selrowContent.buyi_conf_cnt) > 0)
						jq("#list").jqGrid('setRowData', rowid, {buyi_status_name:"Y"});
					else	
						jq("#list").jqGrid('setRowData', rowid, {buyi_status_name:"N"});
					
				}
				
			} else {
				jq("#list2").clearGridData();
			}
			
			var statusCode = $("#srcSaleStatus").val();
			if(statusCode == "10"){
				$("#confirmButton").css("display", "");
				$("#cancelButton").css("display", "none");
				$("#salesConfirmPartCancelButton").css("display", "none");
			}else if(statusCode == "20"){
				$("#confirmButton").css("display", "none");
				$("#cancelButton").css("display", "");
				$("#salesConfirmPartCancelButton").css("display", "");
				$("#salesButtonTd").css("width", "560");
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var id = $("#list").jqGrid('getGridParam', "selrow" );
			var selrowContent = jq("#list").jqGrid('getRowData',id);
			var statusCode = selrowContent.sale_status_code;
			var sapNum	   = selrowContent.sap_jour_numb;
//        	 	if(statusCode == "10" && sapNum == ""){
//           	   	$("#confirmButton").css("display", "");
//           	  	$("#cancelButton").css("display", "none");
//        	 	}else if(statusCode == "20" && sapNum == ""){
//        	 		$("#confirmButton").css("display", "none");
//           	   	$("#cancelButton").css("display", "");
//        	 	}else{
//        	 		$("#confirmButton").css("display", "none");
//        	 		$("#cancelButton").css("display", "none");
//        	 	}
			_sale_sequ_numb = selrowContent.sale_sequ_numb;
			$("#srcSaleSequNumb").val(_sale_sequ_numb);
			$("#srcOrdeNumb").val("");
			onDetail(_sale_sequ_numb, isOnLoad);
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
		datatype: 'json',
		mtype: 'POST',
		multiselect:true,
		colNames:['공급사명', '주문구매사명','주문유형','주문번호','발주차수','납품차수','인수차수','상품명','주문수량','매출수량','매출단가','매출금액','매입확정상태', 'vendorId', 'good_iden_numb', 'buyi_sequ_numb', '주문번호', ' 주문차수'],
		colModel:[
			{name:'vendorNm',index:'vendorNm',width:180,align:"left",search:false,sortable:true, editable:false },//공급사명
			{name:'branchNm',index:'branchNm',width:180,align:"left",search:false,sortable:true, editable:false },//주문구매사명
			{name:'orde_type_clas_nm', index:'orde_type_clas_nm',width:80,align:"center",search:false,sortable:true, editable:false },//주문유형
			{name:'order_num',index:'order_num',width:120,align:"left",search:false,sortable:true, editable:false },//주문번호
			{name:'purc_iden_numb',index:'purc_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},//발주차수 
			{name:'deli_iden_numb',index:'deli_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},//납품차수            
			{name:'rece_iden_numb',index:'rece_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},//인수차수
			{name:'good_name',index:'good_name',width:150,align:"left",search:false,sortable:true, editable:false },//상품명
			{name:'orde_requ_quan',index:'orde_requ_quan',width:60,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//주문수량
			{name:'sale_prod_quan',index:'sale_prod_quan',width:60,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매출수량
			{name:'sale_prod_pris',index:'sale_prod_pris',width:90,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매출단가
			{name:'sale_prod_amou',index:'sale_prod_amou',width:90,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매출금액
			{name:'buyi_stat_yn',index:'buyi_stat_yn',width:100,align:"center",search:false,sortable:true, editable:false,}, //매입확정상태
			{name:'vendorId',index:'vendorId',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'good_iden_numb',index:'good_iden_numb',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'buyi_sequ_numb',index:'buyi_sequ_numb',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'orde_iden_numb',index:'orde_iden_numb',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true },//주문번호
			{name:'orde_sequ_numb',index:'orde_sequ_numb',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true }//주문차수
		],
		postData: {srcOrdeNumb:$("#srcOrdeNumb").val()},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager2',
		height: <%=listHeight2%>, width: <%=listWidth%>,
		sortname: 'ORDE_REGI_DATE', sortorder: "DESC",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $("#list2").getGridParam('reccount');
			for(var i=0;i<rowCnt;i++) {
				var rowid = $("#list2").getDataIDs()[i];
				var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
				if(i != rowCnt-1) {
					if(selrowContent.buyi_sequ_numb != ''){
						jq("#list2").jqGrid('setRowData', rowid, {buyi_stat_yn:'Y'}); 				
					}else{ 
						jq("#list2").jqGrid('setRowData', rowid, {buyi_stat_yn:'N'});
					}
				}
				jq("#list2").setCell(rowid,'order_num','',{color:'#0000ff'});
				jq("#list2").setCell(rowid,'order_num','',{cursor:'pointer'});  
				jq("#list2").setCell(rowid,'good_name','',{color:'#0000ff'});
				jq("#list2").setCell(rowid,'good_name','',{cursor:'pointer'});
			}
			var rowId = $("#list2").jqGrid('getDataIDs');
			for(var i=0; i<rowId.length; i++){
				var dataType = $("#list2").getRowData(rowId[i]);
				if(dataType['buyi_stat_yn'] == 'Y'){
					var unCheckBox = $('#jqg_list2_'+rowId[i]);
					unCheckBox.attr("disabled", true);//체크박스 비활성화
					unCheckBox.css("visibility", "hidden");//체크박스 모습감추기
				}
				if(i==(rowId.length-1)) {
					var unCheckBox = $('#jqg_list2_'+rowId[i]);
					unCheckBox.attr("disabled", true);//체크박스 비활성화
					unCheckBox.css("visibility", "hidden");//체크박스 모습감추기
				}
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var dataType = $("#list2").getRowData(rowid);
			if(dataType['buyi_stat_yn'] == 'Y' || dataType['buyi_stat_yn']=='') {
				$("#list2").setSelection(rowid, false);
			}
		},
		onSelectAll: function(aRowids,status) {
			if(status) {
				var rowCnt = $("#list2").getGridParam('reccount');
				for(var i=0;i<rowCnt;i++) {
					var rowid = $("#list2").getDataIDs()[i];
					var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
					if(selrowContent.buyi_stat_yn=='Y' || selrowContent.buyi_stat_yn=='') {
						$("#list2").setSelection(rowid, false);
					}
				}
				var cbs = $('#cb_list2').attr("checked",true);
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = $("#list2").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
			if(colName['index'] == "order_num"){
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, '" +_menuId+ "', selrowContent.purc_iden_numb);")%>
			}
			if(colName['index'] == "good_name"){
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView('"+_menuId+"',selrowContent.good_iden_numb, selrowContent.vendorId);")%>
			}
		},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script type="text/javascript">
function fnPay(rowid){
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
	var skCoNm      = '<%=Constances.EBILL_CONAME%>';
	var skBizNo		= '<%=Constances.EBILL_COREGNO%>';
	var skCeoNm 	= '<%=Constances.EBILL_COCEO%>';
	var skAddr  	= '<%=Constances.EBILL_COADDR%>';
	var skBizType	= '<%=Constances.EBILL_COBIZTYPE%>';
	var skBizSub	= '<%=Constances.EBILL_COBIZSUB%>';
	var saleSequNumb= selrowContent.sale_sequ_numb; 	

	var oReport = GetfnParamSet(); // 필수
	oReport.rptname = "SalesConfParticulars"; // reb 파일이름
	
	oReport.param("skCoNm").value 		= skCoNm;
	oReport.param("skBizNo").value 		= skBizNo;
	oReport.param("skCeoNm").value 		= skCeoNm;
	oReport.param("skAddr").value 		= skAddr;
	oReport.param("skBizType").value 	= skBizType;
	oReport.param("skBizSub").value 	= skBizSub;

	oReport.param("saleSequNumb").value = saleSequNumb;
	
	
	oReport.title = "거래명세서(매출 확정 확인용)"; // 제목 세팅
	oReport.open();			
}

function fnSearch() {
	$("#list").jqGrid('setGridParam');
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcCreatStartDate = $("#srcCreatStartDate").val();
	data.srcCreatEndDate = $("#srcCreatEndDate").val();
	data.srcSaleStatus = $("#srcSaleStatus").val();
	data.srcSaleNm = $("#srcSaleNm").val();
	data.srcBranchNm = $("#srcBranchNm").val();
	data.srcAccUser = $("#srcAccUser").val();
	jq("#list").trigger("reloadGrid");
	
}

function onDetail(obj, isOnLoad){
	if(isOnLoad){
		$("#list2").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustSalesConfirmDetailListJQGrid.sys'});
		var data = jq("#list2").jqGrid("getGridParam", "postData");
		data.sale_sequ_numb = obj;
		data.srcOrdeNumb = $('#srcOrdeNumb').val();
		jq("#list2").trigger("reloadGrid");	
	}
}

function fnSalesConfirm(){
	var sale_sequ_numb_Arr  = Array();
	var id = $("#list").getGridParam('selarrrow');
	var ids = $("#list").jqGrid('getDataIDs');
	var count = 0;
	for (var i = 0; i < ids.length; i++) {
		var check = false;
		$.each(id, function (index, value) {
			if (value == ids[i])
			check = true;
		});
		if (check) {
			var selrowContent = $("#list").getRowData(ids[i]);
			sale_sequ_numb_Arr[count] =  selrowContent.sale_sequ_numb;
			count++;
		}
	}
	if(count == 0){
		alert("매출확정할 데이터를 선택해주세요.");
		return;
	}
	if(!confirm("선택한 데이터를 매출확정 하시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/saveAdjustConfirm.sys", 
		{
			oper:"add", 
			sale_sequ_numb_Arr:sale_sequ_numb_Arr,
		},
		function(arg){ 
			fnAjaxTransResult(arg);
			fnSearch();
		}
	);
}


//매출확정부분취소
function salesConfirmPartCancel(){
	var orde_iden_numb_Arr = Array();//주문번호
	var orde_sequ_numb_Arr = Array();//주문차수
	var purc_iden_numb_Arr = Array();//발주차수
	var deli_iden_numb_Arr = Array();//출하차수
	var rece_iden_numb_Arr = Array();//인수차수
	
	var id = $("#list").jqGrid('getGridParam', "selrow" );
	var selrow = jq("#list").jqGrid('getRowData',id);
	var sale_sequ_numb = selrow.sale_sequ_numb; //매출id
	if(sale_sequ_numb==null || sale_sequ_numb=="" || sale_sequ_numb==undefined) {
		alert("매출정보를 선택해 주십시오!");
		return;
	}
	
	var listId = $("#list2").getGridParam('selarrrow');
	var listIds = $("#list2").jqGrid('getDataIDs');
	var listCount = 0;
	for (var i = 0; i < listIds.length; i++) {
   		var check = false;
		$.each(listId, function (index, value) {
			if (value == listIds[i])
			check = true;
   		});
		if (check) {
			var selrowContent = $("#list2").getRowData(listIds[i]);
			orde_iden_numb_Arr[listCount] = selrowContent.orde_iden_numb;
			orde_sequ_numb_Arr[listCount] = selrowContent.orde_sequ_numb;
			purc_iden_numb_Arr[listCount] = selrowContent.purc_iden_numb;
			deli_iden_numb_Arr[listCount] = selrowContent.deli_iden_numb;
			rece_iden_numb_Arr[listCount] = selrowContent.rece_iden_numb;
			listCount++;
		}
	}
	if(listCount==0) {
		alert("매출확정 부분취소 정보를 선택해 주십시오!");
		return;
	}
	if(listCount == (listIds.length-1)) {
		alert("선택하신 매출확정 전체를 취소하시려면 상단의 매출확정취소버튼을 이용하십시오!");
		return;
	}
	if(!confirm("선택하신 매출확정정보를 부분취소 하시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/salesConfirmPartCancel.sys", 
		{
			orde_iden_numb_Arr:orde_iden_numb_Arr,
			orde_sequ_numb_Arr:orde_sequ_numb_Arr,
			purc_iden_numb_Arr:purc_iden_numb_Arr,
			deli_iden_numb_Arr:deli_iden_numb_Arr,
			rece_iden_numb_Arr:rece_iden_numb_Arr,
			sale_sequ_numb:sale_sequ_numb
		},
		function(arg) {
			fnAjaxTransResult(arg);
			fnSearch();
		}
	);
}

function fnSalesCancel(){
	var sale_sequ_numb_Arr  = Array();

	var id = $("#list").getGridParam('selarrrow');
	var ids = $("#list").jqGrid('getDataIDs');
	var count = 0;
	var chkcnt = 0;
	var rtnMsg = "";
	for (var i = 0; i < ids.length; i++) {
   		var check = false;   		
   			$.each(id, function (index, value) {
      		if (value == ids[i])
         		check = true;
      		});

		if (check) {
			var selrowContent = $("#list").getRowData(ids[i]);
			if(parseInt(selrowContent.buyi_conf_cnt) == 0){			
				sale_sequ_numb_Arr[count] =  selrowContent.sale_sequ_numb;
				count++;
			}else{
				rtnMsg += "[정산번호 : "+selrowContent.sale_sequ_numb+"]\n";
			}
			chkcnt++;
		}
	}
	
	if(chkcnt == 0){
		alert("매출확정취소할 데이터를 선택해주세요.");
      	return;     
	}
	
	if("" != rtnMsg){
		if(count == 0){
			rtnMsg += "\n는 매입확정 상태임으로 매출확정 취소를 할 수 없습니다.";
			alert(rtnMsg);
			return;
		}
		rtnMsg += "\n는 매입확정 상태임으로 매출확정 취소를 할 수 없습니다.\n해당 데이터를 제외하고 매출확정취소 하시겠습니까?";
	}else{
		rtnMsg = "선택한 데이터를 매출확정취소 하시겠습니까?";
	}	

	if(!confirm(rtnMsg)) return;
	
	$.post(
   		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/saveAdjustConfirm.sys", 
     	{  
        	oper:"mod", 
        	sale_sequ_numb_Arr:sale_sequ_numb_Arr,
     	},       
     	function(arg){ 
     		fnAjaxTransResult(arg);
     		fnSearch();
// 	     	if(fnAjaxTransResult(arg)) {  //성공시
// 	        	fnSearch();
// 	        }
		}
	);  	
}

function exportExcel1() {
	var colLabels = ['정산번호','정산생성일','정산명','세금계산서구매사','매출금액','부가세','합계','정산상태'];	//출력컬럼명
	var colIds = ['sale_sequ_numb','crea_sale_date','sale_sequ_name','clientNm','sale_requ_amou','sale_requ_vtax','sale_tota_amou','sale_status_name'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//숫자표현ID
	var sheetTitle = "매출목록";	//sheet 타이틀
	var excelFileName = "SalesConfirmMaster";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcel2() {
	var colLabels = ['공급사명','주문구매사명','주문유형','주문번호','발주차수','납품차수','상품명','주문수량','매출수량','매출단가','매출금액','매출확정상태'];	//출력컬럼명
	var colIds = ['vendorNm','branchNm','orde_type_clas_nm','order_num','purc_iden_numb', 'deli_iden_numb','good_name','orde_requ_quan','sale_prod_quan','sale_prod_pris','sale_prod_amou','buyi_stat_yn'];	//출력컬럼ID
	var numColIds = ['orde_requ_quan','sale_prod_quan','sale_prod_pris','sale_prod_amou'];	//숫자표현ID
	var sheetTitle = "매출상세목록";	//sheet 타이틀
	var excelFileName = "SalesConfirmDetail";	//file명
	
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function exportExcelToSvc1() {
	var colLabels = ['정산번호','정산생성일','정산명','세금계산서구매사','매출금액','부가세','합계','정산상태'];	//출력컬럼명
	var colIds = ['sale_sequ_numb','crea_sale_date','sale_sequ_name','clientNm','sale_requ_amou','sale_requ_vtax','sale_tota_amou','sale_status_name'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//숫자표현ID
	var sheetTitle = "매출목록";	//sheet 타이틀
	var excelFileName = "SalesConfirmMaster";	//file명
	
	var actionUrl = "/adjust/adjustSalesConfirmListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcCreatStartDate';
	fieldSearchParamArray[1] = 'srcCreatEndDate';
	fieldSearchParamArray[2] = 'srcSaleStatus';
	fieldSearchParamArray[3] = 'srcSaleNm';
	fieldSearchParamArray[4] = 'srcBranchNm';
	fieldSearchParamArray[5] = 'srcAccUser';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function exportExcelToSvc2() {
	var colLabels = ['공급사명','주문구매사명','주문유형','주문번호','발주차수','납품차수','상품명','주문수량','매출수량','매출단가','매출금액'];	//출력컬럼명
	var colIds = ['vendorNm','branchNm','orde_type_clas_nm','order_num','purc_iden_numb', 'deli_iden_numb','good_name','orde_requ_quan','sale_prod_quan','sale_prod_pris','sale_prod_amou'];	//출력컬럼ID
	var numColIds = ['orde_requ_quan','sale_prod_quan','sale_prod_pris','sale_prod_amou'];	//숫자표현ID
	var sheetTitle = "매출상세목록";	//sheet 타이틀
	var excelFileName = "SalesConfirmDetail";	//file명
	
	var actionUrl = "/adjust/adjustSalesConfirmDetailListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcOrdeNumb';
	fieldSearchParamArray[1] = 'srcSaleSequNumb';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//매출확정부분취소
// function salesConfirmPartCancel(){
// 	var orde_iden_numb_Arr = Array();//주문번호
// 	var orde_sequ_numb_Arr = Array();//주문차수
// 	var purc_iden_numb_Arr = Array();//발주차수
// 	var deli_iden_numb_Arr = Array();//출하차수
// 	var buyi_stat_yn_Arr = Array();//매입확정상태
// 	var sale_sequ_numb = "";
// 	var id = $("#list").jqGrid('getGridParam', "selrow" );
// 	var selrow = jq("#list").jqGrid('getRowData',id);
// 	sale_sequ_numb = selrow.sale_sequ_numb;
// 	var ids = $("#list2").getGridParam("selarrrow");
// 	var chkCnt = 0;
	
// 	for(var idx=0; idx<ids.length; idx++){
// 		var selrowContent = $("#list2").getRowData(ids[idx]);
// 		orde_iden_numb_Arr[idx] = selrowContent.orde_iden_numb;
// 		orde_sequ_numb_Arr[idx] = selrowContent.orde_sequ_numb;
// 		purc_iden_numb_Arr[idx] = selrowContent.purc_iden_numb;
// 		deli_iden_numb_Arr[idx] = selrowContent.deli_iden_numb;
// 		buyi_stat_yn_Arr[idx] 	= selrowContent.buyi_stat_yn;
// 		chkCnt++;
// 	}
	
// 	if(chkCnt == 0){
// 		alert("매출확정 부분취소할 데이터를 선택 주세요");
// 	}else if(chkCnt > 0){
// 		$.post(
<%-- 		   		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/salesConfirmPartCancel.sys",  --%>
// 		     	{  
// 		        	orde_iden_numb_Arr:orde_iden_numb_Arr,
// 		        	orde_sequ_numb_Arr:orde_sequ_numb_Arr,
// 		        	purc_iden_numb_Arr:purc_iden_numb_Arr,
// 		        	deli_iden_numb_Arr:deli_iden_numb_Arr,
// 		        	buyi_stat_yn_Arr:buyi_stat_yn_Arr,
// 		        	sale_sequ_numb:sale_sequ_numb
// 		     	},       
// 		     	function(arg){ 
// 			     	if(fnAjaxTransResult(arg)) {
// 			        	fnSearch();
// 			        }
// 				}
// 			); 
// 	}
// }
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
					<td height="25" class="ptitle">매출확정</td>
					<td align="right" class="ptitle">
						<span class="ptitle">
							<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
								<i class="fa fa-search"></i> 조회
							</button>
						</span>
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
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">정산생성일자</td>
					<td class="table_td_contents">
						<input type="text" name="srcCreatStartDate" id="srcCreatStartDate" style="width: 75px;vertical-align: middle;" /> 
						~ 
						<input type="text" name="srcCreatEndDate" id="srcCreatEndDate" style="width: 75px;vertical-align: middle;" />
					</td>
<%	if("ADM".equals(userInfoDto.getSvcTypeCd())){	%>                     
 					<td class="table_td_subject" width="100">고객유형운영자</td>
					<td class="table_td_contents">
						<select id="srcAccUser" name="srcAccUser" class="select" style="width: 120px;">
							<option value="">전체</option>
<%
		@SuppressWarnings("unchecked")
		List<SmpUsersDto> admUserList = (List<SmpUsersDto>) request.getAttribute("admUserList");
		if(admUserList != null && admUserList.size() > 0){
			for(SmpUsersDto userDto : admUserList){
%>
							<option value="<%=userDto.getUserId()%>" <%=userDto.getUserId().equals(userInfoDto.getUserId()) ? "selected" : "" %>><%=userDto.getUserNm()%></option>
<%
			}
		}
%>
						</select>	
					</td>
<%	}%>
					<td class="table_td_subject" width="100">세금계산서구매사</td>
					<td class="table_td_contents">
						<input id="srcBranchNm" name="srcBranchNm" type="text" value="" size="20" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">정산상태</td>
					<td class="table_td_contents">
						<select id="srcSaleStatus" name="srcSaleStatus" class="select" >
							<option value="10">정산생성</option>
							<option value="20">매출확정</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">정산명</td>
					<td class="table_td_contents">
						<input id="srcSaleNm" name="srcSaleNm" type="text" value="" size="20" maxlength="30" />
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
		<td height="5"></td>
	</tr>
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="20" valign="top">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
					</td>
					<td class="stitle">매출목록</td>
					<td align="right" class="stitle">
						<button id='confirmButton' class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>
							매출확정
						</button>
						<button id='cancelButton' class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>
							매출확정취소
						</button>
						<button id='excelAll1' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
								<i class="fa fa-file-excel-o"></i> 엑셀
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
			<div id="jqgrid">
				<table id="list"></table>
				<div id="pager"></div>
			</div>
		</td>
	</tr>
	<tr>
		<td height="5"></td>
	</tr>
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="20" valign="top">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
					</td>
					<td class="stitle">매출상세목록</td>
					<td width="20" valign="top">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
					</td>
					<td class="stitle" width="65" >주문번호</td>
					<td align="right" class="stitle" width="440" id="salesButtonTd">
						<input type="hidden" name="srcSaleSequNumb" id="srcSaleSequNumb" style="width:60%;vertical-align: middle;" />
						<input type="text" name="srcOrdeNumb" id="srcOrdeNumb" style="width:220px;vertical-align: middle;" />
						<button id="srcButton2" name="srcButton2"  class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
							조회
						</button>
						<button id="salesConfirmPartCancelButton"  class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>
							매출확정부분취소
						</button>
						<button id='excelAll2' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
								<i class="fa fa-file-excel-o"></i> 엑셀
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
			<div id="jqgrid">
				<table id="list2"></table>
				<div id="pager2"></div>
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