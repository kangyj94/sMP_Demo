<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
    //그리드의 width와 Height을 정의
    String listHeight = "$(window).height()-370 + Number(gridHeightResizePlus)";

    @SuppressWarnings("unchecked")
    //화면권한가져오기(필수)
    List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
    // 날짜 세팅
    String srcStartDate = "2009-01-01";
    String srcEndDate = CommonUtils.getCurrentDate();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css" media="screen">
    th.ui-th-column div{
        white-space:normal !important;
        height:auto !important;
    }
</style>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0" bgcolor="white">
    <tr>
        <td bgcolor="#FFFFFF">
            <!-- 타이틀 -->
            <table width="1500px"  border="0" cellspacing="0" cellpadding="0">
                <tr valign="top">
                    <td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
                    <td class='ptitle'>재고상품</td> 
                    <td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
                        <button id='xlsButton' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
                        <button id='srcButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
                    </td>
                </tr>
            </table>
            <form id="frmSearch">
            <!-- Search Context -->
            <table width="1500px" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td colspan="6" class="table_top_line"></td>
                </tr>
                <tr>
                    <td colspan="6" height="1" bgcolor="eaeaea"></td>
                </tr>
                <tr>
                    <td class="table_td_subject">카테고리</td>
                    <td colspan="3" class="table_td_contents">
                        <input id="srcMajoCodeName" name="srcMajoCodeName" type="text" value="" size="20" maxlength="30" style="width: 400px;background-color: #eaeaea;" disabled="disabled"/> 
                        <input id="srcCateId" name="srcCateId" type="hidden" value="" readonly="readonly" />
                        <a href="#">
                            <img id="btnSearchCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
                        </a>
                        <a href="#">
                            <img id="btnEraseCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_clear.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
                        </a>
                    </td>
                    <td class="table_td_subject">공급사</td>
                    <td class="table_td_contents">
                        <input id="srcVendorName" name="srcVendorName" type="text" value="" size="" maxlength="50" /> <input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
                        <a href="#">
                            <img id="btnVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; border: 0;" align="middle" class="icon_search" <%=CommonUtils.getDisplayRoleButton(roleList,"COMM_SAVE")%>" />
                        </a>
                    </td>
                </tr>
                <tr>
                    <td colspan="6" height="1" bgcolor="eaeaea"></td>
                </tr>
                <tr>
                    <td class="table_td_subject" width="100">상품코드</td>
                    <td class="table_td_contents">
                        <input id="srcGoodIdenNumb" name="srcGoodIdenNumb" type="text" value="" size="" maxlength="50" />
                    </td>
                    <td class="table_td_subject" width="100">상품명</td>
                    <td class="table_td_contents">
                        <input id="srcGoodName" name="srcGoodName" type="text" value="" size="" maxlength="50" />
                    </td>
                    <td class="table_td_subject">규격</td>
                    <td class="table_td_contents">
                        <input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" value="" size="" maxlength="50" />
                    </td>
                </tr>
                <tr>
                    <td colspan="6" class="table_top_line"></td>
                </tr>
                <tr><td height="10"></td></tr>
            </table>
            </form>
            <div id="stockTotalDiv"></div>
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <col width="450" />
                <col />
                <col width="100%"/>
                <tr>
                    <td valign="top">
                        <div id="jqgrid">
                            <table id="list"></table>
                            <div id="pager"></div>
                        </div>
                    </td>
                </tr>
            </table>
            <div id="dialog" title="Feature not supported" style="display:none;">
                <p>That feature is not supported.</p>
            </div>
            
        </td>
    </tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
    <p>처리할 데이터를 선택 하십시오!</p>
</div>
<style type="text/css">
.jqmWindow {
    display: none;
    position: absolute;
    top: 5%;
    left: 3%;
    width: 850px;
    background-color: #EEE;
    color: #333;
    z-index: 1003;
}
.jqmOverlay { background-color: #000; }
</style>
<div class="jqmWindow" id="productPop"></div>
<%@ include file="/WEB-INF/jsp/common/product/standardCategoryInfo.jsp"%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
    $.ajaxSetup ({
        cache: false
    });
    
    $('#productPop').jqm();
    
    fnInitEvent();
    fnGridInit();
});

function fnInitEvent(){
	$('#btnSearchCategory').click(function(){
		fnCategoryPopOpen();
	});
	
    $("#srcMajoCodeName").keydown(function(e){
    	if(e.keyCode == 13){
    		$("#btnSearchCategory").click();
    	}
    });
    
    $('#btnEraseCategory').click(function(){
    	$("#srcMajoCodeName").val('');
    	$("#srcCateId").val('');
    });
    
    $("#btnVendor").click(function(){
    	fnVendorSearchOpenPop();
    });
    
    $("#srcVendorName").keydown(function(e){
    	if(e.keyCode == 13){
    		$("#btnVendor").click();
    	}
    });
    
    $("#srcVendorName").change(function(e){
    	$("#srcVendorName").val("");
    	$("#srcVendorId").val("");
    });
    
    $('#srcButton').click(function (e) {
        fnSearch();
    });
    
    $('#xlsButton').click(function (e) {
    	fnXlsButtonOnClick();
    });
}

function fnXlsButtonOnClick(){
	var colLabels = ['상품코드','구분','유형','상품명','규격','공급사','판매가','매입가','재고량','물량배분','표준납기일','등록일','담당자'];   //출력컬럼명
    var colIds = ['GOOD_IDEN_NUMB','GOOD_TYPE_NM','REPRE_GOOD_NM','GOOD_NAME','GOOD_SPEC','VENDORNM','SELL_PRICE','SALE_UNIT_PRIC','GOOD_INVENTORY_CNT','ISDISTRIBUTENM','DELI_MINI_DAY','INSERT_DATE','PRODUCT_MANAGER'];   //출력컬럼ID
    var numColIds = ['SELL_PRICE','SALE_UNIT_PRIC','GOOD_INVENTORY_CNT','DELI_MINI_DAY'];  //숫자표현ID
    var sheetTitle = "재고상품"; //sheet 타이틀
    var excelFileName = "stockProductList";  //file명
    
    var fieldSearchParamArray = new Array();     //파라메타 변수ID
	fieldSearchParamArray[0] = 'srcCateId';
	fieldSearchParamArray[1] = 'srcVendorName';
	fieldSearchParamArray[2] = 'srcVendorId';
	fieldSearchParamArray[3] = 'srcGoodIdenNumb';
	fieldSearchParamArray[4] = 'srcGoodName';
	fieldSearchParamArray[5] = 'srcGoodSpecDesc';
    
    fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/product/productListExcelAdm.sys");
}

//그리드 초기화
function fnGridInit() {
    $("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectProductList.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:[
			'상품코드',	'구분',				'유형',		'상품명',	'규격',
			'공급사',	'판매가',			'매입가',	'재고량',	'재고금액',
			'물량배분',	'표준<br/>납기일',	'등록일',	'담당자',	'',
			''
		],
        colModel:[
            {name:'GOOD_IDEN_NUMB',     width:80, align:'center'},//상품코드
            {name:'GOOD_TYPE_NM',       width:40, align:'center'},//구분
            {name:'REPRE_GOOD_NM',      width:40, align:'center'},//유형
            {name:'GOOD_NAME',          width:250},//상품명
            {name:'GOOD_SPEC',          width:250},//규격
            
            {name:'VENDORNM',           width:120},//공급사
            {name:'SELL_PRICE',         width:60, align:'right', sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//판매가
            {name:'SALE_UNIT_PRIC',     width:60, align:'right', sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//매입가
            {name:'GOOD_INVENTORY_CNT', width:40, align:'right', sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//재고량
            {name:'STOCK_PRICE',        width:80, align:'right', sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//재고금액
            
            {name:'ISDISTRIBUTENM',     width:50, align:'center'},//물량배분
            {name:'DELI_MINI_DAY',      width:60, align:'right', sorttype:'integer', formatter:'integer', formatoptions:{decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:""}},//표준 납기일
            {name:'INSERT_DATE',        width:70, align:'center'},//등록일
            {name:'PRODUCT_MANAGER',    width:130},//담당자
            {name:'VENDORID',           hidden:true},//VENDORID
            
            {name:'REPRE_GOOD',         hidden:true}//VENDORID
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager',
        height:<%=listHeight%>,autowidth:true,
        sortname: 'GOOD_IDEN_NUMB', sortorder: 'desc', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell", userdata:"userdata"},
        afterInsertRow: function(rowid, aData) {
            $(this).setCell(rowid,'GOOD_NAME','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
            if (aData.REPRE_GOOD == 'N') {
                $(this).setCell(rowid,'GOOD_INVENTORY_CNT','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
            }
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
            var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="GOOD_NAME") {
                var url = '/product/popProductAdm.sys?good_iden_numb=' + selrowContent.GOOD_IDEN_NUMB + '&vendorid=' + selrowContent.VENDORID;
                window.open(url, 'okplazaPop', 'width=917, height=800, scrollbars=yes, status=no, resizable=no');
            }
            if(selrowContent.REPRE_GOOD == 'N'&&colName != undefined &&colName['name']=="GOOD_INVENTORY_CNT") {
            	$('#productPop').css({'width':'600px','top':'20%','left':'20%'}).html('')
                .load('/menu/product/product/popStockChangeHist.sys?good_iden_numb='+selrowContent.GOOD_IDEN_NUMB+'&vendorid='+selrowContent.VENDORID)
                .jqmShow();
            }
        },
        loadComplete: function() {
        	var userdata = jQuery("#list").getGridParam('userData');
        	//alert(userdata.stockTotal);
        	$("#stockTotalDiv").html("총 재고금액 : " + userdata.stockTotal + "원");
        }
    })
    .jqGrid("setLabel", "rn", "순번");
}
// Resizing
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(1500);
}).trigger('resize');
// 조회 등록/수정/삭제 후에도 처리하기에 꼭 펑션으로 사용함. 
function fnSearch() {
    $("#list")
    .jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()})
    .trigger("reloadGrid");
}
/**
 * 카테고리 팝업 호출  
 */
function fnCategoryPopOpen(){
     fnSearchStandardCategoryInfo("1", "fnCallBackStandardCategoryChoice"); 
}
/**
 * 카테고리 선택 콜백   
 */
function fnCallBackStandardCategoryChoice(categortId , categortName , categortFullName) {
    var msg = ""; 
    $('#srcCateId').val(categortId); 
    $('#srcMajoCodeName').val(categortFullName); 
}  

/**
 * 공급사 검색 
 */
function fnVendorSearchOpenPop(){
    var vendorNm = $("#srcVendorName").val();   
    fnVendorDialog(vendorNm, "fnCallBackVendor");
}
/**
 * 공급사 선택 콜백 
 */
function fnCallBackVendor(vendorId, vendorNm, areaType){
    $("#srcVendorId").val(vendorId);
    $("#srcVendorName").val(vendorNm);
}
</script>
</body>
</html>