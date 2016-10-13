<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	int listWidth = 560;
// 	String listWidth2 = "$(window).width()-615 + Number(gridWidthResizePlus)";
	String listWidth2 = "930";
	String listHeight = "$(window).height()-366 + Number(gridHeightResizePlus)";
	String list2Height = "$(window).height()-340 + Number(gridHeightResizePlus)";
	
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String srcCreatStartDate = CommonUtils.getCustomDay("MONTH", -1);
	String srcCreatEndDate   = CommonUtils.getCurrentDate();   
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>

<%
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp"%>
<!-- 공급사검색관련 스크립트 -->
<script type="text/javascript">
var payCondCode = "";
$(document).ready(function(){
	$("#delClientBtn").click( function() { fnDelClientNm(); });
	$("#srcButtonTarget").click( function() { fnSearchTarget(); });
	$("#srcButtonDeli").click( function() { fnSearchDeli(); });
	$("#addTargetMst").click( function() { fnAddTargetMst(); });
	$("#delTargetMst").click( function() { fnDelTargetMst(); });
	$("#adjustCreatButton").click( function() { adjustCreat(); });
	$("#adjustRemoveButton").click( function() { adjustRemove(); });
	$("#colButton1").click( function(){ jq("#list").jqGrid('columnChooser'); });
	$("#excelButton1").click(function(){ exportExcel1(); });   
	$("#colButton2").click( function(){ jq("#list2").jqGrid('columnChooser'); });
	$("#excelButton2").click(function(){ exportExcel2(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	$("#srcButton2").click(function(){ 
		var id = $("#list").jqGrid('getGridParam', "selrow" );  
		var selrowContent = jq("#list").jqGrid('getRowData',id); 
		onDetail(selrowContent.vendorId, selrowContent.buyi_sequ_numb, isOnLoad); 
	});
	$("#srcOrdeNumb").keydown(function(e){
		if(e.keyCode == 13) {
			$("#srcButton2").click();
		}
	});
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"PAYMCONDCODE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				payCondCode += codeList[i].codeVal1 + ":" + codeList[i].codeNm1 + ";";
			}
			//alert(payCondCode);
		}
	);
	$("#srcVendorsButton").click(function(){
		fnVendorDialog("", "fnCallBackVendor"); 
	});
	$("#srcVendorNm").keydown(function(e){
		if(e.keyCode == 13){
			$("#srcButton").click(); 
		}
	});
	$("#srcButton").click(function(){
		fnSearch(); 
	});
	$("#confirmButton").hide();
	$("#cancelButton").hide();
	$("#srcPurcStatus").change(function() {
		fnSearch();
// 		if($("#srcPurcStatus").val() == "10") {	//매입확정대상
// 			$("#srcCreatStartDate").val("");
// 			$("#srcCreatEndDate").val("");
// 			$("#srcCreatStartDate").attr("disabled",true);
// 			$("#srcCreatEndDate").attr("disabled",true);
// 			$("img.ui-datepicker-trigger").attr("style","display:none;");
// 		} else if($("#srcPurcStatus").val() == "20") {	//매입확정
// 			$("#srcCreatStartDate").attr("disabled",false);
// 			$("#srcCreatEndDate").attr("disabled",false);
<%-- 			$("#srcCreatStartDate").val("<%=srcCreatStartDate%>"); --%>
<%-- 			$("#srcCreatEndDate").val("<%=srcCreatEndDate%>"); --%>
// 			$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
// 		}
	});
	$("#purchaseConfirmPartCancelButton").click(function(){ purchaseConfirmPartCancel(); });
	$("#purchaseConfirmPartCancelButton").hide();
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackVendor(vendorId, vendorNm, areaType) {
   $("#srcVendorNm").val(vendorNm);
}
</script>
<% //------------------------------------------------------------------------------ %>


<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#confirmButton").click(function(){
		fnPurcConfirm();
	});
	
	$("#cancelButton").click(function(){
		fnPurcCancel();
	});
<%--    $("#srcCreatStartDate").val("<%=srcCreatStartDate%>"); --%>
<%--    $("#srcCreatEndDate").val("<%=srcCreatEndDate%>"); --%>
});
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list2").setGridWidth(930);
	$("#list2").setGridHeight(<%=list2Height %>);
}).trigger('resize');

</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var staticNum = 0;
var isOnLoad = false;
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustPurcConfirmListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		multiselect:true,
		colNames:['vendorId','지급조건','공급사명','매입액','부가세','합계','정산생성일','SAP전표번호','sale_sequ_numb','buyi_sequ_numb', 'payBillType', 'payBillTypeNm'],
		colModel:[
			{name:'vendorId', index:'vendorId',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'paym_cond_code',index:'paym_cond_code', width:160,align:"center",search:false,sortable:false,
				editable:false,formoptions:{rowpos:7,elmprefix:"<font color='red'>(*)</font>"},
				formatter:selectBoxFormatter 
			},//지급조건
			{name:'vendorNm', index:'vendorNm',width:115,align:"left",search:false,sortable:true, editable:false },									//공급사명
			{name:'purc_prod_amou',index:'purc_prod_amou',width:65,align:"right",search:false,sortable:true, editable:false, 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	//매입액
			{name:'purc_prod_tax',index:'purc_prod_tax',width:65,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	//부가세
			{name:'buyi_tota_amou',index:'buyi_tota_amou',width:70,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	//합계
			{name:'crea_sale_date',index:'crea_sale_date',width:70,align:"center",search:false,sortable:true, editable:false },						//정산생성일
			{name:'sap_jour_numb',index:'sap_jour_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'sale_sequ_numb',index:'sale_sequ_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'buyi_sequ_numb',index:'buyi_sequ_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'payBillType',index:'payBillType',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'payBillTypeNm',index:'payBillTypeNm',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true }
		],
		postData: {
// 			srcCreatStartDate:$("#srcCreatStartDate").val(),
// 			srcCreatEndDate:$("#srcCreatEndDate").val(),
			srcPurcStatus:$("#srcPurcStatus").val(),
			srcVendorNm:$("#srcVendorNm").val()
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,width: <%=listWidth%>,
		sortname: 'SALE_SEQU_NUMB', sortorder: 'DESC',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				var top_rowid = $("#list").getDataIDs()[0];  //첫번째 로우 아이디 구하기
				if(!isOnLoad) {
					isOnLoad = true;
				}else {
					jq("#list2").clearGridData();
				}
				jq("#list").setSelection(top_rowid);
				for(var i = 0 ; i < rowCnt ; i++){
					var rowId = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowId);
					jq("#buyi_cond_code_" + rowId).val(selrowContent.payBillType); 
					jq("#list").jqGrid('setRowData', rowId, {payBillTypeNm:$("#buyi_cond_code_" + rowId + " > option[value=" + selrowContent.payBillType + "]").text()});
				}
			} else {
				jq("#list2").clearGridData();
			}
			var purcConf = $("#srcPurcStatus").val();
			if(purcConf == "10"){
				$("#confirmButton").show();
				$("#cancelButton").hide();
				$("#purchaseConfirmPartCancelButton").hide();
			}else{
				$("#confirmButton").hide();
				$("#cancelButton").show();
				$("#purchaseConfirmPartCancelButton").show();
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);    
//       	 if(selrowContent.buyi_sequ_numb == ""){
//       	 	$("#confirmButton").show();
//       	 	$("#cancelButton").hide();
//       	 }else{
//        	 	$("#confirmButton").hide();
//       	 	$("#cancelButton").show();
//       	 }
			$("#srcOrdeNumb").val("");
			onDetail(selrowContent.vendorId, selrowContent.buyi_sequ_numb, isOnLoad);     
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
		multiselect: true,
		colNames:['주문유형','주문번호','발주차수','납품차수','인수차수','상품명','매입수량','매입단가','매입액','매입부가세', 'sale_sequ_numb', 'buyi_sequ_numb', 'vendorId', 'good_iden_numb','orde_iden_numb','orde_sequ_numb'],
		colModel:[
			{name:'orde_type_clas_nm', index:'orde_type_clas_nm',width:70,align:"center",search:false,sortable:true, editable:false },//주문유형
			{name:'order_num',index:'order_num',width:100,align:"left",search:false,sortable:true, editable:false },//주문번호
			{name:'purc_iden_numb',index:'purc_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},//발주차수
			{name:'deli_iden_numb',index:'deli_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},//납풉차수
			{name:'rece_iden_numb',index:'rece_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},//인수차수
			{name:'good_name',index:'good_name',width:140,align:"left",search:false,sortable:true, editable:false },//상품명
			{name:'sale_prod_quan',index:'sale_prod_quan',width:50,align:"right",search:false,sortable:true, editable:false, 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입수량
			{name:'purc_prod_pris',index:'purc_prod_pris',width:80,align:"right",search:false,sortable:true, editable:false, 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입단가
			{name:'purc_prod_amou',index:'purc_prod_amou',width:80,align:"right",search:false,sortable:true, editable:false, 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입액
			{name:'purc_prod_tax',index:'purc_prod_tax',width:60,align:"right",search:false,sortable:true, editable:false, 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입부가세
			{name:'sale_sequ_numb',index:'sale_sequ_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },//매출정산헤더
			{name:'buyi_sequ_numb',index:'buyi_sequ_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },//매입정산헤더
			{name:'vendorId',index:'vendorId',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },//공급사아이디
			{name:'good_iden_numb',index:'good_iden_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'orde_iden_numb',index:'orde_iden_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'orde_sequ_numb',index:'orde_sequ_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true }
		],
		postData: {srcOrdeNumb:$("#srcOrdeNumb").val()},
		rowNum:0, rownumbers: false, rowList:[30,50,100], pager: '#pager2',
		height:<%=list2Height%>,
		width: <%=listWidth2%>,
		sortname: 'A.SALE_SEQU_NUMB', sortorder: 'DESC',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $("#list2").getGridParam('reccount');
			for(var i=0;i<rowCnt;i++) {
				var rowid = $("#list2").getDataIDs()[i];
				jq("#list2").setCell(rowid,'order_num','',{color:'#0000ff'});
				jq("#list2").setCell(rowid,'order_num','',{cursor:'pointer'});
				jq("#list2").setCell(rowid,'good_name','',{color:'#0000ff'});
				jq("#list2").setCell(rowid,'good_name','',{cursor:'pointer'});
			}
			//체크박스제어
			if($("#srcPurcStatus").val() == "10"){
				for(var i=0; i<rowCnt; i++) {
					var rowId = $("#list2").getDataIDs()[i];
					$("#cb_list2").css("visibility", "hidden");
					$("#cb_list2").attr("disabled", true);
					$("#jqg_list2_"+rowId).css("visibility", "hidden");
					$("#jqg_list2_"+rowId).attr("disabled", true);
				}
			}else{
				$("#cb_list2").css("visibility", "visible");
				$("#cb_list2").attr("disabled", false);
			}
			$("#jqg_list2_"+rowCnt).css("visibility", "hidden");
			$("#jqg_list2_"+rowCnt).attr("disabled", true);
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
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
<script type="text/javascript">
function selectBoxFormatter(cellvalue, options, rowObject) {
	var codeArr = payCondCode.split(";");
	var srcPurcStatus = $("#srcPurcStatus").val();
	var disabled = "";
	if(srcPurcStatus == "20"){
		disabled = "disabled='disabled'";
	}
	var tmpStr = "<select id='buyi_cond_code_" + options.rowId + "' name='buyi_cond_code_" + options.rowid + "' class='select' title='' onchange='javaScript:onChangePaym();' "+disabled+">";
	for(var i = 0 ; i < codeArr.length-1 ; i++){
		tmpStr += "<option value='" + codeArr[i].split(":")[0] + "' >" + codeArr[i].split(":")[1] + "</option>"; 
	}
	return tmpStr + "</select>";
}

function onChangePaym(){
   	var rowId = $("#list").jqGrid('getGridParam', "selrow" );
   	jq("#list").jqGrid('setRowData', rowId, {payBillTypeNm:$("#buyi_cond_code_" + rowId + " > option[value=" + $("#buyi_cond_code_" + rowId).val() + "]").text()});
}

function fnSearch() {
   $("#list").jqGrid('setGridParam');
   var data = jq("#list").jqGrid("getGridParam", "postData");
//    data.srcCreatStartDate = $("#srcCreatStartDate").val();
//    data.srcCreatEndDate = $("#srcCreatEndDate").val();
   data.srcPurcStatus = $("#srcPurcStatus").val();
   data.srcVendorNm = $("#srcVendorNm").val();
   jq("#list").trigger("reloadGrid");  
}

function onDetail(vendorId, buyi_sequ_numb , isOnLoad){
	if(isOnLoad){
		$("#list2").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustPurcConfirmDetailListJQGrid.sys'});
		var data = jq("#list2").jqGrid("getGridParam", "postData");
		data.vendorId = vendorId;
		data.srcPurcStatus = $("#srcPurcStatus").val();
		data.buyi_sequ_numb = buyi_sequ_numb;
		data.srcOrdeNumb = $("#srcOrdeNumb").val();
		jq("#list2").trigger("reloadGrid"); 
	}
}

function fnPurcConfirm(){
	var vendorIdArr      = Array();
	var sale_sequ_numb_Arr  = Array();
	var buyi_requ_amou_Arr  = Array();
	var buyi_requ_vtax_Arr  = Array();
	var paym_cond_code_Arr  = Array();
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
			vendorIdArr[count]        =  selrowContent.vendorId;
			sale_sequ_numb_Arr[count] =  selrowContent.sale_sequ_numb;
			buyi_requ_amou_Arr[count] =  selrowContent.purc_prod_amou;
			buyi_requ_vtax_Arr[count] =  selrowContent.purc_prod_tax;
			paym_cond_code_Arr[count] =  selrowContent.payBillType;        
			count++;
		}
	}
	if(count == 0){
		alert("매입확정할 데이터를 선택해주세요.");
		return;
	}
	if(!confirm("매입확정 하시겠습니까?")) return;
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/savePurcConfirm.sys", 
		{  
			oper:"add", 
			vendorIdArr:vendorIdArr,
			sale_sequ_numb_Arr:sale_sequ_numb_Arr,
			buyi_requ_amou_Arr:buyi_requ_amou_Arr,
			buyi_requ_vtax_Arr:buyi_requ_vtax_Arr,
			paym_cond_code_Arr:paym_cond_code_Arr
		},       
		function(arg){
			fnAjaxTransResult(arg)
			fnSearch();
		}
	);
}

function fnPurcCancel(){
   if(!confirm("매입확정취소를 하시겠습니까?")) return;
   
   var vendorIdArr      = Array();
   var sale_sequ_numb_Arr  = Array();
   var buyi_requ_amou_Arr  = Array();
   var buyi_requ_vtax_Arr  = Array();
   var paym_cond_code_Arr  = Array();
   var buyi_sequ_numb_Arr  = Array();

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

         vendorIdArr[count]        =  selrowContent.vendorId;
         sale_sequ_numb_Arr[count] =  selrowContent.sale_sequ_numb;
         buyi_requ_amou_Arr[count] =  selrowContent.purc_prod_amou;
         buyi_requ_vtax_Arr[count] =  selrowContent.purc_prod_tax;
         paym_cond_code_Arr[count] =  selrowContent.payBillType;
         buyi_sequ_numb_Arr[count] =  selrowContent.buyi_sequ_numb;
         
         count++;
      }
   }
   if(count == 0){
      alert("매입확정취소할 데이터를 선택해주세요.");
         return;     
   }

	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/savePurcConfirm.sys", 
		{
			oper:"mod", 
			vendorIdArr:vendorIdArr,
			sale_sequ_numb_Arr:sale_sequ_numb_Arr,
			buyi_requ_amou_Arr:buyi_requ_amou_Arr,
			buyi_requ_vtax_Arr:buyi_requ_vtax_Arr,
			paym_cond_code_Arr:paym_cond_code_Arr,
			buyi_sequ_numb_Arr:buyi_sequ_numb_Arr
		},
		function(arg){ 
			fnAjaxTransResult(arg);
			fnSearch();
		}
	);
}

function exportExcel1() {
	var colLabels = ['지급조건','공급사명','매입액','부가세','합계','정산생성일'];	//출력컬럼명
	var colIds = ['payBillTypeNm','vendorNm','purc_prod_amou','purc_prod_tax','buyi_tota_amou','crea_sale_date'];	//출력컬럼ID
	var numColIds = ['purc_prod_amou','purc_prod_tax','buyi_tota_amou'];	//숫자표현ID
	var sheetTitle = "매입목록";	//sheet 타이틀
	var excelFileName = "PurcharseConfirmMaster";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function exportExcel2() {
	var colLabels = ['주문유형','주문번호','발주차수','납품차수','상품명','매입수량','매입단가','매입액','매입부가세'];	//출력컬럼명
	var colIds = ['orde_type_clas_nm','order_num','purc_iden_numb', 'deli_iden_numb','good_name','sale_prod_quan','purc_prod_pris','purc_prod_amou','purc_prod_tax'];	//출력컬럼ID
	var numColIds = ['sale_prod_quan','purc_prod_pris','purc_prod_amou','purc_prod_tax'];	//숫자표현ID
	var sheetTitle = "매입상세목록";	//sheet 타이틀
	var excelFileName = "PurcharseConfirmDetail";	//file명
	
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['지급조건','공급사명','매입액','부가세','합계','정산생성일'];	//출력컬럼명
	var colIds = ['payBillTypeNm','vendorNm','purc_prod_amou','purc_prod_tax','buyi_tota_amou','crea_sale_date'];	//출력컬럼ID
	var numColIds = ['purc_prod_amou','purc_prod_tax','buyi_tota_amou'];	//숫자표현ID
	var sheetTitle = "매입목록";	//sheet 타이틀
	var excelFileName = "PurcharseConfirmMaster";	//file명
	
	var actionUrl = "/adjust/adjustPurcConfirmListExcel.sys";
	var fieldSearchParamArray = new Array();
// 	fieldSearchParamArray[0] = 'srcCreatStartDate';
// 	fieldSearchParamArray[1] = 'srcCreatEndDate';
	fieldSearchParamArray[0] = 'srcPurcStatus';
	fieldSearchParamArray[1] = 'srcVendorNm';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}


//매입부분취소
function purchaseConfirmPartCancel(){
	//매입상태가 매입확정일 경우만 실행
	if(!confirm("매입부분취소를 하시겠습니까?")) return;
	if($("#srcPurcStatus").val() == "20"){
		var rowId = $("#list2").getGridParam('selarrrow');
		var ids = $("#list2").jqGrid('getDataIDs');
		var count = 0;
		var ordeIdenNumbArray = Array();
		var ordeSequNumbArray = Array();
		var purcIdenNumbArray = Array();
		var deliIdenNumbArray = Array();
		var receIdenNumbArray = Array();
		var buyiSequNumb = "";

		for (var i = 0; i < ids.length; i++) {
			var check = false;
			$.each(rowId, function (index, value) {
				if (value == ids[i]){
					check = true;
				}
			});
			if(check){
				var selrowContent = $("#list2").getRowData(ids[i]);
				if(selrowContent.orde_iden_numb != "" && selrowContent.orde_iden_numb != null){
					ordeIdenNumbArray[count] = selrowContent.orde_iden_numb;
					ordeSequNumbArray[count] = selrowContent.orde_sequ_numb;
					purcIdenNumbArray[count] = selrowContent.purc_iden_numb;
					deliIdenNumbArray[count] = selrowContent.deli_iden_numb;
					receIdenNumbArray[count] = selrowContent.rece_iden_numb;
					buyiSequNumb = selrowContent.buyi_sequ_numb;
					count++;
				}
			}
		}
		if(count == 0){
			alert("매입 부분 취소 할 데이터를 \n선택 해주세요");
			return;
		}
		$.post(
			"/adjust/purchaseConfirmPartCancel.sys",
			{
				ordeIdenNumbArray:ordeIdenNumbArray,
				ordeSequNumbArray:ordeSequNumbArray,
				purcIdenNumbArray:purcIdenNumbArray,
				deliIdenNumbArray:deliIdenNumbArray,
				receIdenNumbArray:receIdenNumbArray,
				buyiSequNumb:buyiSequNumb
			},
			function(arg){
				fnAjaxTransResult(arg);
				fnSearch();
			}
		);
	}
}

</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="25" class="ptitle">매입확정</td>
					<td align="right" class="ptitle">
						<span class="ptitle"> 
							<button id="srcButton" name="srcButton" class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
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
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">매입상태</td>
					<td class="table_td_contents">
						<select id="srcPurcStatus" name="srcPurcStatus" class="select">
							<option value="10">매입확정대상</option>
							<option value="20">매입확정</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">공급사명</td>
					<td class="table_td_contents" colspan="3">
						<input id="srcVendorNm" name="srcVendorNm" type="text" value="" size="20" maxlength="30" />
							<a href="#">
								<img id="srcVendorsButton" name="srcVendorsButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; border: 0px; vertical-align: middle;" align="middle" class="icon_search" />
							</a>
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
	<tr><td height="5"></td></tr>
	<tr>
		<td>
			<!-- 그리드 분할-->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<col width="560" />
				<col width="10"/>
				<col width="auto" />
				<tr>
					<td>
						<!-- 타이틀 시작 -->
						<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="20" valign="top">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
								</td>
								<td class="stitle">매입목록</td>
								<td align="right" class="stitle">
									<button id="confirmButton" name="confirmButton" class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>
										매입확정
									</button>
									<button id="cancelButton" name="cancelButton"  class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>
										매입확정취소
									</button>
									<button id='excelAll' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
										<i class="fa fa-file-excel-o"></i> 엑셀
									</button>
								</td>
							</tr>
							<tr><td height="1"></td></tr>
						</table>
						<!-- 타이틀 끝 -->
						<div id="jqgrid">
							<table id="list"></table>
							<div id="pager"></div>
						</div>
					</td>
					<td>&nbsp;</td>
					<td>
						<!-- 타이틀 시작 -->
						<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="20" valign="top">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
								</td>
								<td class="stitle">매입상세목록
								</td>
								<td align="right">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px; vertical-align: top;" class="bullet_stitle" />
									주문번호
									<input type="text" name="srcOrdeNumb" id="srcOrdeNumb" style="vertical-align: middle; width: 250px;"/>
									<button id="srcButton2" name="srcButton2" class="btn btn-default btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
										<i class="fa fa-search"></i>조회
									</button>
									<button id="purchaseConfirmPartCancelButton" name="purchaseConfirmPartCancelButton"  class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>
										매입확정부분취소
									</button>
									<button id='excelButton2' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
										<i class="fa fa-file-excel-o"></i> 엑셀
									</button>
								</td>
							</tr>
						</table>
						<!-- 타이틀 시작 -->
						<div id="jqgrid">
							<table id="list2"></table>
						</div>
					</td>
				</tr>
			</table>
			<!-- 그리드 분할-->
		</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<!-------------------------------- Dialog Div Start -------------------------------->
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>