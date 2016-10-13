<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<head>
<%
	String menuId = CommonUtils.getRequestMenuId(request);
%>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<script>
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
});
</script>
</head>
<body class="subBg">
<div id="divWrap">
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
    <hr>
	<div id="divBody">
		<div id="divSub">
			<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
			<div id="AllContainer">                    
				<ul class="Tabarea">
					<li class="on">상품관리</li>
				</ul>
				<div style="position:absolute; right:0; margin-top:-30px;">
					<img src="/img/contents/btn_excelDN.gif" id="xlsButton" style="cursor:pointer"/>
					<a href="#" onclick="fnSetList(1);">
						<img src="/img/contents/btn_tablesearch.gif" />
					</a>
				</div>
				<form id="frmS" onsubmit="return false;">
					<input id="srcVendorId" name="srcVendorId" type="hidden" value="${sessionScope.sessionUserInfoDto.borgId}" />
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
								<label><input type="radio" name="srcGoodType" value="" checked style="vertical-align: middle;"/> 전체</label>
								<label><input type="radio" name="srcGoodType" value="10" style="vertical-align: middle;"/> 일반</label>
								<label><input type="radio" name="srcGoodType" value="20" style="vertical-align: middle;"/> 지정</label>
							</td>
						</tr>
						<tr>
							<th>규격</th>
							<td>
								<input name="srcGoodSpec"  id="srcGoodSpec" type="text" style="width:150px;" />
							</td>
							<th>상품유형</th>
							<td>
								<label><input type="radio" name="srcRepreGood" value="" checked style="vertical-align: middle;"/> 전체</label>
								<label><input type="radio" name="srcRepreGood" value="N" style="vertical-align: middle;"/> 단품</label>
								<label><input type="radio" name="srcRepreGood" value="Y" style="vertical-align: middle;"/> 옵션</label>
							</td>
							<th>정상여부</th>
							<td>
								<label><input type="radio" name="srcIsUse" value="" style="vertical-align: middle;"/> 전체</label>
								<label><input type="radio" name="srcIsUse" value="1" checked style="vertical-align: middle;"/> 정상</label>
								<label><input type="radio" name="srcIsUse" value="0" style="vertical-align: middle;"/> 종료</label>
							</td>
						</tr>
					</table>
				</form>
				<div class="mgt_20">
					<button onclick="fnNewGoodReg();" type="button" class="btn btn btn-darkgray btn-xs"><i class="fa fa-plus"></i> 신규상품등록요청</button>
					<button onclick="fnNewGoodList();" type="button" class="btn btn btn-darkgray btn-xs"><i class="fa fa-list"></i> 신규상품등록요청내역</button>
					<input id="orderString" name="orderString" type="hidden" value="" />
					<span style="position:absolute; right:0; display:block; margin-top:-22px;">
						<span>&#8226;<a href="javascript:setOrderBy('ASCII_ORDER');">가나다순</a></span>
						<span>&#8226;<a href="javascript:setOrderBy('ORDER_CNT');">누적판매순</a></span>
						<span>&#8226;<a href="javascript:setOrderBy('INSERT_DATE');">최신등록순</a></span>	
					</span>
				</div>
				<div class="ListTable mgt_5">
					<table id="list">
						<colgroup>
							<col width="110px" />
							<col width="80px" />
							<col width="80px" />
							<col width="auto" />
							<col width="100px" />
							<col width="80px" />
							<col width="80px" />
							<col width="120px" />
						</colgroup>
						<tr>
							<th class="br_l0">상품코드</th>
							<th><p>구분</p></th>
							<th><p>유형</p></th>
							<th> 주문 상품 정보</th>
							<th><p>단가</p></th>
							<th>재고량</th>
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
<div class="jqmWindow" id="productPop"></div>
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
<script type="text/javascript">
$(function() {
	$.ajaxSetup ({cache: false});
	$('#frmS input').keypress(function (e) {
		if( e.keyCode == 13){
			fnSetList(1);
		}
	});
	$('#xlsButton').click(function (e) {
		var colLabels = ['상품코드','구분','유형','상품명','규격','단가','재고량','표준 납기일','담당자'];   //출력컬럼명
		var colIds = ['GOOD_IDEN_NUMB','GOOD_TYPE_NM','REPRE_GOOD_NM','GOOD_NAME','GOOD_SPEC','SALE_UNIT_PRIC','GOOD_INVENTORY_CNT','DELI_MINI_DAY','PRODUCT_MANAGER'];   //출력컬럼ID
		var numColIds = ['SALE_UNIT_PRIC','GOOD_INVENTORY_CNT','DELI_MINI_DAY'];  //숫자표현ID
		var sheetTitle = "상품조회"; //sheet 타이틀
		var excelFileName = "productList";  //file명/product/selectProductList/list.sys
		var orderString = $("#orderString").val();
		if($.trim(orderString) == ''){
			orderString = 'AA.ASCII_ORDER ASC, AA.GOOD_NAME ASC';
			$("#orderString").val(orderString);
		}
		var fieldSearchParamArray = new Array();     //파라메타 변수ID
		fieldSearchParamArray[0] = 'srcGoodName';
		fieldSearchParamArray[1] = 'srcGoodIdenNumb';
		fieldSearchParamArray[2] = 'srcGoodType';
		fieldSearchParamArray[3] = 'srcGoodSpec';
		fieldSearchParamArray[4] = 'srcRepreGood';
		fieldSearchParamArray[5] = 'srcIsUse';
		fieldSearchParamArray[6] = 'srcVendorId';
		fieldSearchParamArray[7] = 'orderString';
		fnExportExcelToSvc(null, colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/product/productListExcelVen.sys");
	});
	fnSetList(1);
	$('#productPop').jqm();
});
</script>
<script type="text/javascript">
<%-- 신규상품 리스트--%>
var listDetail;
function fnSetList(page){
	$.blockUI();
	$(".trData").remove();
	$("#pager").empty();
	listDetail = "";
	var page        = page;
	var rows        = 10;
	var orderString	= $("#orderString").val();
	if($.trim(orderString) == ''){
		orderString = 'AA.ASCII_ORDER ASC, AA.GOOD_NAME ASC';
	}
	$.post("/product/selectProductListForVen/list.sys", $('#frmS').serialize()+'&page='+page+'&rows='+rows+'&orderString='+orderString,
		function(arg){
			var result = arg.custResponse;
			var list		= "";
			var currPage	= "";
			var rows		= "";
			var total		= "";
			var records		= "";
			var pageGrp		= "";
			var startPage	= "";
			if( result.success == false){
				records = 0;
			}else{
				list		= arg.list;
				listDetail	= arg.list;
				currPage	= arg.page;
				rows		= arg.rows;
				total		= arg.total;
				records		= arg.records;
				pageGrp		= Math.ceil(currPage/5);
				startPage	= (pageGrp-1)*5+1;
				endPage		= (pageGrp-1)*5+5;
				if(Number(endPage) > Number(total)){
					endPage = total;
				}
			}	
			
			var str = "";
			var data = "";
			if(records > 0){
				for(var i=0; i<list.length; i++){
					data = list[i]; 
					str +=	'<tr class="trData">';
					str +=		'<td align="center" class="br_l0">'+ fnNullToSpace( data.GOOD_IDEN_NUMB )+'</td>';
					str +=		'<td align="center">'+ fnNullToSpace( data.GOOD_TYPE_NM )+'</td>';
					str += 		'<td align="center">'+ fnNullToSpace( data.REPRE_GOOD_NM )+'</td>';
					str += 		'<td>';
					str += 			'<dl>';
					str += 				'<dt>';
					str += 					'<input id="ORIGINAL_IMG_PATH_'+i+'" name="ORIGINAL_IMG_PATH" value="'+data.ORIGINAL_IMG_PATH+'" type="hidden"/>';
					str += 					'<a href="javascript:funPopBigImage('+i+');">';
					str += 						'<img id="ORIGINAL_IMG_'+i+'" src="<%=Constances.SYSTEM_IMAGE_PATH%>/'+data.LARGE_IMG_PATH+'" onerror="this.src=\'/img/system/imageResize/prod_img_100.gif\'"  style="width:100px;height:100px"/>';
					str += 					'</a>';
					str += 				'</dt>';
					str += 				'<dd>';
					str +=					'<p class="f12">';
					str +=						'<a href="javascript:fnPdtSimpleDetailPop(\''+data.GOOD_IDEN_NUMB+'\');">';
					str +=							fnNullToSpace( data.GOOD_NAME );
					str +=						'</a>';
					str +=					'</p>';
					str +=					'<div class="f11">';
					str += 						'<p>';
					str +=							'<strong>규격</strong> : ' + fnNullToSpace( data.GOOD_SPEC );
					str +=						'</p>';
					str += 						'<p>';
					str +=							'<strong>제조사</strong> : ' + data.MAKE_COMP_NAME;
					str +=						'</p>';
					str += 						'<p>';
					str +=							'<strong>최소주문수량</strong> : ' + data.DELI_MINI_QUAN;
					str +=						'</p>';
					str +=					'</div>';
					str +=				'</dd>';
					str +=			'</dl>';
					str +=		'</td>';
					str += 		'<td align="right">';
					
					if(typeof data.SALE_UNIT_PRIC == 'undefined'){
						str += 		' ';
					}
					else{
						str += 		fnComma(data.SALE_UNIT_PRIC) + '원';
					}
					
					str += 		'</td>';
					str +=		'<td align="right">';
					
					if(typeof data.GOOD_INVENTORY_CNT == 'undefined'){
						str += 		' ';
					}
					else{
						str += 		fnComma( data.GOOD_INVENTORY_CNT );
					}
					
					str +=		'</td>';
					str +=		'<td align="right">'+ fnComma( data.DELI_MINI_DAY )+'</td>';
					str += 		'<td align="center">'+ fnNullToSpace( data.PRODUCT_MANAGER.replace("(","<br/>("))+'</td>';
					str += '</tr>';
				}
				
				$("#list").append(str);
				
				fnPager(startPage, endPage, currPage, total, 'fnSetList');	//페이져 호출 함수
			} else {
				str = "";
				str += " <tr class='trData' id='trData_0'>";
				str += "   <td class='br_l0' colspan='8' align='center' >조회된 결과가 없습니다.</td>";
				str += " </tr>";
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


function fnNewGoodReg() {
	var url = '/product/popProductVenReg.sys';
	var win = window.open(url, 'venPop', 'width=917, height=850, scrollbars=auto, status=no, resizable=no');
	win.focus();
}
function fnNewGoodList() {
	var url = '/menu/product/product/productRequestRegistListVen.sys?_menuId=<%=menuId%>';
	var win = window.open(url, 'venListPop', 'width=917, height=650, scrollbars=auto, status=no, resizable=yes');
	win.focus();
}

function funPopBigImage(i){
	if($('#ORIGINAL_IMG_PATH_'+i).val() == '') {
		alert('이미지가 존재하지 않습니다.');
		
		return;
	}
	
	var originalImgOffset    = $('#ORIGINAL_IMG_' + i).offset();
	var originalImgOffsetTop = originalImgOffset.top;
	
	$('#productPop').css({'width':'500px','top': originalImgOffsetTop +'px','left':'20%'}).html('')
	.load('/menu/product/product/popBigImage.sys?bigImage='+$('#ORIGINAL_IMG_PATH_'+i).val())
	.jqmShow(); 
}
function setOrderBy(order){
	var orderString = '';
	if(order == 'ASCII_ORDER'){
		orderString = 'AA.ASCII_ORDER ASC, AA.GOOD_NAME ASC';
	}else if(order == 'ORDER_CNT'){
		orderString = 'AA.ORDER_CNT DESC';
	}else{
		orderString = 'AA.INSERT_DATE DESC';
	}
	$("#orderString").val(orderString);
	fnSetList(1);
}
</script>
</body>
</html>