<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<style type="text/css">
input[type=radio] {vertical-align: middle;}
</style>
</head>
<body class="subBg">
<div id="divWrap">
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
	<hr>
	<div id="divBody">
		<div id="divSub">
			<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
<%
	String srcInsertStartDate = CommonUtils.getCustomDay("DAY", -7);    // 날짜 세팅
	String srcInsertEndDate = CommonUtils.getCurrentDate();
%>
			<div id="AllContainer">                    
				<ul class="Tabarea">
					<li class="on">재고관리</li>
				</ul>
				<div style="position:absolute; right:0; margin-top:-30px;">
					<img src="/img/contents/btn_excelDN.gif" id="xlsButton" style="cursor:pointer"/>
					<a href="#" onclick="fnSetList(1);">
						<img src="/img/contents/btn_tablesearch.gif" />
					</a>
				</div>
				<form id="frmS">
					<input name="srcVendorId" type="hidden" value="${sessionScope.sessionUserInfoDto.borgId}" />
					<input name="srcStockMngt" type="hidden" value="Y" />
					
					<table class="InputTable">
						<colgroup>
							<col width="120px" />
							<col width="auto" />
							<col width="100px" />
							<col width="230px" />
							<col width="120px" />
							<col width="230px" />
						</colgroup>
						<tr>
							<th>상품명</th>
							<td>
								<input name="srcGoodName" id="srcGoodName" type="text" style="width:150px;" />
							</td>
							<th>상품코드</th>
							<td>
								<input name="srcGoodIdenNumb" id="srcGoodIdenNumb" type="text" style="width:150px;" />
							</td>
							<th>상품구분</th>
							<td>
								<label><input type="radio" name="srcGoodType" value="" checked /> 전체</label>
								<label><input type="radio" name="srcGoodType" value="10"/> 일반</label>
								<label><input type="radio" name="srcGoodType" value="20"/> 지정</label>
							</td>
						</tr>
						<tr>
							<th>규격</th>
							<td>
								<input name="srcGoodSpecDesc" id="srcGoodSpecDesc" type="text" style="width:150px;" />
							</td>
							<th>상품유형</th>
							<td>
								<label><input type="radio" name="srcRepreGood" value="" checked/> 전체</label>
								<label><input type="radio" name="srcRepreGood" value="N"/> 단품</label>
								<label><input type="radio" name="srcRepreGood" value="Y"/> 옵션</label>
							</td>
							<th>정상여부</th>
							<td>
								<label><input type="radio" name="srcIsUse" value=""/> 전체</label>
								<label><input type="radio" name="srcIsUse" value="1" checked/> 정상</label>
								<label><input type="radio" name="srcIsUse" value="0"/> 종료</label>
							</td>
						</tr>
					</table>
				</form>
				<div id="stockTotalDiv" class="mgt_20" style="margin-bottom: -43px;"></div>
				<div class="Ar mgt_20">
					<button id="btnStockAll" type="button" class="btn btn btn-darkgray btn-xs"><i class="fa fa-check-square-o"></i> 재고수량일괄처리</button>
				</div>
				<div class="ListTable mgt_5">
					<table id="list">
						<colgroup>
							<col width="90px" />
							<col width="60px" />
							<col width="60px" />
							<col width="auto" />
							<col width="100px" />
							<col width="100px" />
							<col width="100px" />
							<col width="100px" />
							<col width="70px" />
							<col width="110px" />
						</colgroup>
						<tr>
							<th class="br_l0">상품코드</th>
							<th>
								<p>구분</p>
							</th>
							<th>
								<p>유형</p>
							</th>
							<th>상품명</th>
							<th>규격</th>
							<th>
								<p>단가</p>
							</th>
							<th>재고량</th>
							<th>재고금액</th>
							<th>표준납기일</th>
							<th>담당자</th>
						</tr>
					</table>
				</div>
				<div id="pager" class="divPageNum"></div>     
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
	</div>
	<hr>
</div>
<style type="text/css">
.jqmWindow {
    display: none;
    position: absolute;
    top: 20%;
    left: 50%;
    width: 850px;
    background-color: #EEE;
    color: #333;
    z-index: 1003;
}
.jqmOverlay { background-color: #000; }
</style>
<div class="jqmWindow" id="productPop"></div>
<script type="text/javascript">
$(document).ready(function() {
	$("#divGnb").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#divGnb").mouseout(function () {
		$("#snb_vdr").hide();
	});
	$("#snb_vdr").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#snb_vdr").mouseout(function () {
		$("#snb_vdr").hide();
	});
	
	$.ajaxSetup({
		cache: false
	});
	
    $('#frmS input').keypress(function (e) {
    	if( e.keyCode == 13 ){
    		fnSetList(1);
    	}
    });
    
    $('#xlsButton').click(function (e) {
    	stockAllExcel();
    });
    
    $('#productPop').jqm();
    
    $('#btnStockAll').click(function () {
        $('#productPop').html('')
        .load('/menu/product/product/popStockAll.sys?good_iden_numb='+$('#good_iden_numb').val())
        .jqmShow(); 
    });
    
    fnSetList(1);
});

var listDetail;
var page;
function fnSetList(p){
    $.blockUI();
    $(".trData").remove();
    $("#pager").empty();
    listDetail = "";
    if (p) {
        page = p;
    }
    var rows        = 10;
    
    $.post("/product/selectProductListForVen.sys", $('#frmS').serialize()+'&page='+page+'&rows='+rows,
        function(arg){
	    	var list       = "";     
	    	var currPage   = ""; 
	    	var rows       = ""; 
	    	var total      = ""; 
	    	var records	   = ""; 
	    	var pageGrp	   = ""; 
	    	var startPage  = ""; 
	    	var endPage	   = "";
	    	var stockTotal = "";
	    	var result     = arg.custResponse;
	    	var str        = "";
            var data       = "";
    		
    		if( result.success == false ){
    			records = 0;
    		}
    		else{
	            list        = arg.list;
	            listDetail  = arg.list;
	            currPage    = arg.page;
	            rows        = arg.rows;
	            total       = arg.total;
	            records     = arg.records;
	            stockTotal  = arg.stockTotal;
	            pageGrp     = Math.ceil(currPage/5);
	            startPage   = (pageGrp-1)*5+1;
	            endPage     = (pageGrp-1)*5+5;
	            
	            if(Number(endPage) > Number(total)){
	                endPage = total;
	            }    			
    		}
    	    
            if(records > 0){
                for(var i=0; i<list.length; i++){
                    data = list[i]; 
                    str +='<tr class="trData">';
					str += '    <td class="br_l0" align="center"><p>'+fnNullToSpace( data.GOOD_IDEN_NUMB )+'</p>';
                    str += '    <td align="center">'+fnNullToSpace( data.GOOD_TYPE_NM )+'</td>';
                    str += '    <td align="center">'+fnNullToSpace( data.REPRE_GOOD_NM )+'</td>';
                    str += '    <td><a href="javascript:fnPdtSimpleDetailPop(\''+data.GOOD_IDEN_NUMB+'\');">'+fnNullToSpace( data.GOOD_NAME )+'</a></td>';
                    str += '    <td>'+fnNullToSpace( data.GOOD_SPEC )+'</td>';
                    str += '    <td align="right">'+(typeof data.SALE_UNIT_PRIC == 'undefined' ? ' ':(fnComma(data.SALE_UNIT_PRIC)+'원'))+'</td>';
                    if (data.REPRE_GOOD == 'N') {
                        str += '    <td align="right"><a href="#" onclick="fnStock('+i+');">'+ (typeof data.GOOD_INVENTORY_CNT == 'undefined' ? '0':(fnComma(data.GOOD_INVENTORY_CNT))) +'</a></td>';
                    } else {
                        str += '    <td align="right">'+ (typeof data.GOOD_INVENTORY_CNT == 'undefined' ? '0':(fnComma(data.GOOD_INVENTORY_CNT)))  +'</td>';
                    }
                    str += '    <td align="right">' + fnComma( data.STOCK_PRICE ) + '</td>';
                    str += '    <td align="center">'+fnNullToSpace( data.DELI_MINI_DAY )+'</td>';
                    str += '    <td align="center">'+fnNullToSpace( data.PRODUCT_MANAGER.replace("(","<br/>("))+'</td>';
                    str += '</tr>';
                }
                $("#list").append(str);
                $("#stockTotalDiv").html("총 재고금액 : " + stockTotal + "원");
                fnPager(startPage, endPage, currPage, total, 'fnSetList');	//페이져 호출 함수

            } else {
                str += " <tr class='trData' id='trData_0'>                                                                                                                                            ";
                str += "   <td class='br_l0' colspan='9' align='center' >조회된 결과가 없습니다.</td>                                                                                                                                           ";
                str += " </tr>                                                                                                                                                         ";
                $("#list").append(str);
            }
            $.unblockUI();
        },
        "json"
    );
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
function fnNullToSpace( data ){
    if( !data ){
        data = "" ;
    }
    return data;
}

function fnStock(i) {
	$('#productPop').css({'width':'600px','top':'10%','left':'20%'}).html('')
	.load('/menu/product/product/popStockChangeHist.sys?good_iden_numb='+listDetail[i].GOOD_IDEN_NUMB+'&vendorid=${sessionScope.sessionUserInfoDto.borgId}')
	.jqmShow();
}
function stockAllExcel() {
        var colLabels = ['상품코드','구분','유형','상품명','규격','단가','재고량','재고증감','변경사유','표준 납기일','담당자'];   //출력컬럼명
        var colIds = ['GOOD_IDEN_NUMB','GOOD_TYPE_NM','REPRE_GOOD_NM','GOOD_NAME','GOOD_SPEC','SALE_UNIT_PRIC','GOOD_INVENTORY_CNT','CHGSTOCK','CHG_REASON','DELI_MINI_DAY','PRODUCT_MANAGER'];   //출력컬럼ID
        var numColIds = ['SALE_UNIT_PRIC','GOOD_INVENTORY_CNT','DELI_MINI_DAY'];  //숫자표현ID
        var sheetTitle = "재고상품조회"; //sheet 타이틀
        var excelFileName = "stockProductList";  //file명/product/selectProductList/list.sys
        var fieldSearchParamArray = new Array();     //파라메타 변수ID
        fieldSearchParamArray[0] = 'srcGoodName';
        fieldSearchParamArray[1] = 'srcGoodIdenNumb';
        fieldSearchParamArray[2] = 'srcGoodType';
        fieldSearchParamArray[3] = 'srcGoodSpec';
        fieldSearchParamArray[4] = 'srcRepreGood';
        fieldSearchParamArray[5] = 'srcIsUse';
        fieldSearchParamArray[5] = 'srcVendorId';
        fnExportExcelToSvc(null, colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/product/productListExcelVen.sys");
}
</script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
</body>
</html>