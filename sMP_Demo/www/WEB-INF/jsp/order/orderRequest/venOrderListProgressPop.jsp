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
	String listHeight = "$(window).height()-150 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
    String srcOrdeIdenNumb = (String)request.getAttribute("orde_iden_numb");
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>


<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#srcOrdeIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcButton").click(function(){ 
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		fnSearch(); 
	});
});
//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
    $("#list").setGridWidth(1500);
}).trigger('resize');  
</script>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/purchase/purchaseResultListJQGridForPop.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['발주일','납품요청일','고객유형','주문번호','상품명','규격','대표규격','발주차수','출하차수','인수차수','정산번호','주문명','주문유형','주문상태','고객사','공급사','주문자','인수자','인수자 전화번호','발주수량','단가','금액','취소사유'],
		colModel:[
			{name:'clin_date',index:'clin_date', width:100,align:"center",search:false,sortable:true, editable:false },
            {name:'requ_deli_date',index:'requ_deli_date', width:80,align:"center",search:false,sortable:true, editable:false },
            {name:'worknm',index:'worknm', width:120,align:"left",search:false,sortable:true, editable:false },
            {name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"center",search:false,sortable:true, editable:false },
            {name:'good_name',index:'good_name', width:150,align:"left",search:false,sortable:true, editable:false },
            {name:'good_spec_desc',index:'good_spec_desc', width:130,align:"left",search:false,sortable:true, editable:false },
            {name:'good_st_spec_desc',index:'good_st_spec_desc', hidden:true,align:"left",search:false,sortable:true, editable:false },
            {name:'purc_iden_numb',index:'purc_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false },
            {name:'deli_iden_numb',index:'deli_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false },
            {name:'rece_iden_numb',index:'rece_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false },
            {name:'buyi_sequ_numb',index:'buyi_sequ_numb', width:60,align:"right",search:false,sortable:true, editable:false },
            {name:'cons_iden_name',index:'cons_iden_name', width:150,align:"left",search:false,sortable:true, editable:false },
            {name:'orde_type_clas',index:'orde_type_clas', width:70,align:"center",search:false,sortable:true, editable:false },
            {name:'stat_falg',index:'stat_falg', width:80,align:"center",search:false,sortable:true, editable:false },
            {name:'branchnm',index:'branchnm', width:120,align:"left",search:false,sortable:true, editable:false },
            {name:'vendornm',index:'vendornm', width:120,align:"left",search:false,sortable:true, editable:false },
            {name:'orde_user_id',index:'orde_user_id', width:60,align:"left",search:false,sortable:true, editable:false },
            {name:'tran_user_name',index:'tran_user_name', width:60,align:"left",search:false,sortable:true, editable:false },
            {name:'tran_tele_numb',index:'tran_tele_numb', width:90,align:"right",search:false,sortable:true, editable:false },
            {name:'purc_requ_quan',index:'purc_requ_quan', width:50,align:"right",search:false,sortable:true, editable:false ,formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
            {name:'sale_unit_pric',index:'sale_unit_pric', width:80,align:"right",search:false,sortable:true, editable:false ,formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
            {name:'tot_sale_unit_pric',index:'tot_sale_unit_pric', width:90,align:"right",search:false,sortable:true, editable:false ,formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
            {name:'cancel_reason',index:'cancel_reason', width:150,align:"left",search:false,sortable:true, editable:false }
		],  
		postData: {
			srcOrdeIdenNumb:"<%=srcOrdeIdenNumb%>"
<%if(isVendor){%>			
			,srcVendorId:"<%=loginUserDto.getBorgId()%>"
<%}%>
		},multiselect:false ,
        rowNum:0, rownumbers: false,
		sortname: 'clin_date', sortorder: "desc", 
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
// 		caption:"발주이력", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
            // 품목 표준 규격 설정
            var prodStSpcNm = new Array();
            <% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
                prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
            <% } %>
            // 품목 규격 property 추출
            var prodSpcNm = new Array();
            <% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
                prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
            <% }                                                                       %>
            var rowCnt = jq("#list").getGridParam('reccount');
            for(var idx=0; idx<rowCnt; idx++) {
                var rowid = $("#list").getDataIDs()[idx];
                jq("#list").restoreRow(rowid);
                var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                // 규격 화면 로드
                var argStArray = selrowContent.good_st_spec_desc.split("‡");
                var argArray = selrowContent.good_spec_desc.split("‡");
                var prodStSpec = "";
                var prodSpec = "";
                for(var stIdx = 0 ; stIdx < prodSpcNm.length ; stIdx ++ ) {
                    if(argStArray[stIdx] > ' ') {
                        prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
                    }
                }
                if(prodStSpec.length > 0) {
                    prodStSpec = prodStSpec.substring(0,prodStSpec.length-3);
                    prodStSpec = "<font color='red'>["+ prodStSpec + "]</font>";
                }
                for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
                    if($.trim(argArray[jIdx]) > ' ') {
                         if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
                         else           prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
                    }
                }
                prodStSpec += prodSpec;
                jQuery('#list').jqGrid('setRowData',rowid,{good_spec_desc:prodStSpec});
            }
		},
        afterInsertRow: function(rowid, aData){ },
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){ },
		loadError : function(xhr, st, str){ alert("에러가 발생하였습니다."); },
		jsonReader : {root: "list",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>
<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch(){
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcVendorId= "<%=srcOrdeIdenNumb%>";
<%if(isVendor){%>
	data.srcVendorId= "<%=loginUserDto.getBorgId()%>";
<%}%>
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
/** list Excel Export */
function exportExcel() {
	var colLabels = ['발주일','납품요청일','고객유형','주문번호','상품명','규격','발주차수','출하차수','인수차수','정산번호','주문명','주문유형','주문상태','고객사','공급사','주문자','인수자','인수자 전화번호','발주수량','단가','금액','취소사유'];
	var colIds = ['clin_date', 'requ_deli_date', 'worknm', 'orde_iden_numb', 'good_name', 'good_spec_desc', 'purc_iden_numb', 'deli_iden_numb', 'rece_iden_numb', 'buyi_sequ_numb', 'cons_iden_name', 'orde_type_clas', 'stat_falg', 'branchnm', 'vendornm', 'orde_user_id', 'tran_user_name', 'tran_tele_numb', 'purc_requ_quan', 'sale_unit_pric', 'tot_sale_unit_pric', 'cancel_reason'];
	var numColIds = ['purc_requ_quan','sale_unit_pric','tot_sale_unit_pric'];	
	var sheetTitle = "발주이력";	
	var excelFileName = "purchaseResultPrintList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>
<body>
<form id="frm" name="frm" onsubmit="return false;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top" style="height: 29px">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td class='ptitle'>발주이력</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr> 
					</table>
				</td>
	 		</tr>
            <tr><td height="10"></td></tr>
			<tr>
				<td align="right" style="padding-bottom:5px">
					<button id="excelButton" class="btn btn-primary btn-xs" style="display:inline;"><i class="fa fa-file-excel-o"></i> 엑셀</button>
				</td>
			</tr>
			<tr>
				<td>
					<div id="jqgrid">
						<table id="list"></table>
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