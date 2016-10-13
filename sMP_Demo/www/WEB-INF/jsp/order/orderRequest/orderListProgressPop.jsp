<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%
    String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
    //그리드의 width와 Height을 정의
//     String listHeight = "$(window).height()-150 + Number(gridHeightResizePlus)";
    String listHeight = "210";

    LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
    @SuppressWarnings("unchecked")  //화면권한가져오기(필수)
    List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
    String srcOrdeIdenNumb = (String)request.getAttribute("orde_iden_numb");
    
    boolean spUser = false;
    List<LoginRoleDto> loginRoleList= (List<LoginRoleDto>)loginUserDto.getLoginRoleList();
    for(LoginRoleDto lrd : loginRoleList){
        if(lrd.getRoleCd().equals("ADM_SPECIAL")){
            spUser = true;
        }
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
    $("#excelButton").click(function(){ exportExcel(); });
});

//리사이징
$(window).load( function() { 
    $("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(1500);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
    jq("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderProgressPopListJQGrid.sys', 
        datatype: 'json',
        mtype: 'POST',
        colNames:['주문일자', '납품요청일','주문번호', '주문유형',  '주문상태','고객사',  '상품명','규격','공급사', '공급사 전화번호','주문자', '상품코드','판매단가', '수량', '판매금액', '매입단가', '매입금액', '긴급여부','disp_good_id','good_st_spec_desc','vendorid'],
        colModel:[
            {name:'regi_date_time',index:'regi_date_time', width:90,align:"center",search:false,sortable:true, editable:false, editable:false,sorttype:"date", editable:false,formatter:"date"},//주문일자
            {name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},
            {name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"left",search:false,sortable:true, editable:false},//주문번호
            {name:'orde_type_clas',index:'orde_type_clas', width:50,align:"center",search:false,sortable:true, editable:false },//주문유형
            {name:'order_status_flag',index:'order_status_flag', width:65,align:"left",search:false,sortable:true, editable:false },//주문상태
            {name:'orde_client_name',index:'orde_client_name', width:120,align:"left",search:false,sortable:true, editable:false },//고객사
            {name:'good_iden_name',index:'good_iden_name', width:120,align:"left",search:false,sortable:true, editable:false },//상품명
            {name:'good_spec_desc',index:'good_spec_desc', width:140,align:"left",search:false,sortable:true, editable:false },//상품규격
            {name:'vendor_name',index:'vendor_name', width:120,align:"left",search:false,sortable:true, editable:false},//공급사
            {name:'phonenum',index:'phonenum', width:90,align:"right",search:false,sortable:true, editable:false},//공급사
            {name:'orde_user_name',index:'orde_user_name', width:50,align:"left",search:false,sortable:true, editable:false},//주문자
            {name:'good_iden_numb',index:'good_iden_numb', hidden:true},//상품코드
            {name:'sell_price',index:'sell_price', width:70,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매단가
            {name:'orde_requ_quan',index:'orde_requ_quan', width:50,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//수량
            {name:'total_sell_price',index:'total_sell_price', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매금액
            {name:'sale_unit_pric',index:'sale_unit_pric', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입단가
            {name:'total_sale_price',index:'total_sale_price', width:80,align:"right",search:false,sortable:true, editable:false,sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입금액
            {name:'emer_orde_clas',index:'emer_orde_clas', width:50,align:"center",search:false,sortable:true, editable:false, hidden:true },//긴급여부
            {name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false },
            {name:'good_st_spec_desc',index:'good_st_spec_desc',hidden:true },//표준규격
            {name:'vendorid',index:'vendorid', hidden:true, search:false,sortable:true, editable:false }
        ],
        postData: {
            orde_iden_numb:"<%=srcOrdeIdenNumb%>"
        },
        sortname: 'orde_iden_numb', sortorder: "asc",
        rowNum:0, rownumbers: false,
        height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
//         caption:"주문조회", 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {
            var prodStSpcNm = new Array();	// 품목 표준 규격 설정
<% 	for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
			prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
<%	} 	%>
			var prodSpcNm = new Array();	// 품목 규격 property 추출
<%	for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
			prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
<% }	%>
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
// 				jq("#list").restoreRow(rowid);
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
						else prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
					}
				}
				prodStSpec += prodSpec;
				jQuery('#list').jqGrid('setRowData',rowid,{good_spec_desc:prodStSpec});
			}
        },
        afterInsertRow: function(rowid, aData){
<%if(!spUser){%>
            jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
            jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
            jq("#list").setCell(rowid,'good_iden_name','',{color:'#0000ff'});
            jq("#list").setCell(rowid,'good_iden_name','',{cursor: 'pointer'});  
<%}%>
        },
        onCellSelect: function(rowid, iCol, cellcontent, target){
            var cm = jq("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
<%if(!spUser){%>
            if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
<%}%>
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
            if(colName != undefined &&colName['index']=="good_iden_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(!spUser){%>
            if(colName != undefined &&colName['index']=="good_iden_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%} %>
        },
        onSelectRow: function (rowid, iRow, iCol, e) { },
        ondblClickRow: function (rowid, iRow, iCol, e) { },
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",records: "records",repeatitems: false,cell: "cell"}
    }); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/* 엑셀 출력 */
function exportExcel() {
    var colLabels = ['주문일자', '납품요청일','주문번호', '주문유형',  '주문상태','고객사',  '상품명','공급사', '공급사 전화번호','주문자', '상품코드','판매단가', '수량', '판매금액', '매입단가', '매입금액'];    
    var colIds = ['regi_date_time' ,'requ_deli_date' ,'orde_iden_numb' ,'orde_type_clas' ,'order_status_flag' ,'orde_client_name' ,'good_iden_name' ,'vendor_name' ,'phonenum' ,'orde_user_name' ,'good_iden_numb' ,'sell_price' ,'orde_requ_quan' ,'total_sell_price' ,'sale_unit_pric' ,'total_sale_price'];
    var numColIds = ['sell_price','orde_requ_quan','total_sell_price','sale_unit_pric','total_sale_price'];  //숫자표현ID
    var sheetTitle = "주문진척도";   //sheet 타이틀
    var excelFileName = "OrderProgress";    //file명
    fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");    //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
    
}
/**
 * 견적서 출력 (2013-02-06 by Kave)
 */
function fnEstimateSheet(){
    
    var rowCnt = jq("#list").getGridParam('reccount');
    if(rowCnt == 0) {
        alert("출력할 내용이 없습니다.");
        return;
    }

    var borgNm      = '<%=loginUserDto.getBorgNm()%>';
    var orderNm     = '';
    var skCeoNm     = '<%=Constances.EBILL_COCEO%>';
    var skAddr      = '<%=Constances.EBILL_COADDR%>';
    var skTel       = '<%=Constances.EBILL_TEL%>';
    var skFax       = '<%=Constances.EBILL_FAX%>';
    var payBillType = '';
    
    <%
    String prodSpec = "";
    for(int i = 0 ; i < Constances.PROD_GOOD_SPEC.length ; i++){
        if(i == 0)  prodSpec = Constances.PROD_GOOD_SPEC[i];
        else        prodSpec += "‡" + Constances.PROD_GOOD_SPEC[i];
    }
    
    
    String prodStSpec = "";
    for(int i = 0 ; i < Constances.PROD_GOOD_ST_SPEC.length ; i++){
        if(i == 0)  prodStSpec = Constances.PROD_GOOD_ST_SPEC[i];
        else        prodStSpec += "‡" + Constances.PROD_GOOD_ST_SPEC[i];
    }                
    %>
    var prodSpec    = '<%=prodSpec%>';
    var prodStSpec  = '<%=prodStSpec%>';
    
    var orderIdenNumb = '<%=srcOrdeIdenNumb%>';
    
    var oReport = GetfnParamSet(); // 필수
    oReport.rptname = "estimateSheet"; // reb 파일이름
    
    oReport.param("borgNm").value       = borgNm;
    oReport.param("orderNm").value      = orderNm;
    oReport.param("payBillType").value  = payBillType;
    oReport.param("skCeoNm").value      = skCeoNm;
    oReport.param("skAddr").value       = skAddr;
    oReport.param("skTel").value        = skTel;
    oReport.param("skFax").value        = skFax;
    oReport.param("prodSpec").value         = prodSpec;
    oReport.param("prodStSpec").value       = prodStSpec;
    oReport.param("orderIdenNumb").value    = orderIdenNumb;

    oReport.title = "견적서"; // 제목 세팅
    oReport.open();
}

function fnMaterialReceiveListPrint() {
	var orderIdenNumb = '<%=srcOrdeIdenNumb%>';
	var oReport = GetfnParamSet(); // 필수
    oReport.rptname = "materialReceiveList"; // reb 파일이름
    oReport.param("ordeIdenNumb").value  = orderIdenNumb;
    oReport.title = "지입자재 인수검사서"; // 제목 세팅
    oReport.open();
}

</script>

<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>

</head>
<body>
<form id="frm" name="frm" onsubmit="return false;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <!-- 타이틀 시작 -->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top">
                            <td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
                            <td height="29" class='ptitle'>주문상품조회</td>
                        </tr>
                    </table> 
                    <!-- 타이틀 끝 -->
                </td>
            </tr>
            <tr>
               <td colspan="6" class="table_top_line"></td>
            </tr>
            <tr style="height: 25px">
                <td align="right" >
<%--                     <a href="javascript:fnEstimateSheet();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_estimate_sheet_print.jpg" style='border:0;vertical-align:middle;height:22px;'/> </a> --%>
					<a href="javascript:fnMaterialReceiveListPrint();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_materailReceiveList.gif" style='border:0;vertical-align:middle;height:22px;'/> </a>
                    <a href="javascript:fnEstimateSheet();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_order_print2.jpg" style='border:0;vertical-align:middle;height:22px;'/> </a>
<%--                     <a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0' /></a> --%>
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