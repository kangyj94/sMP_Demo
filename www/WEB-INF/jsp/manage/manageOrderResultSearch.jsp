<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	// 날짜 세팅
	String srcOrderStartDate = CommonUtils.getCustomDay("DAY", -7);
	String srcOrderEndDate = CommonUtils.getCurrentDate();
	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : loginUserDto.getSvcTypeCd().equals("ADM") ? "-25" :"";
	
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-280 + Number(gridHeightResizePlus)"+categoryHeightMinus;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function (){
	//날짜 세팅
	$("#srcOrderStartDate").val("<%=srcOrderStartDate%>");
	$("#srcOrderEndDate").val("<%=srcOrderEndDate%>");
	
	//버튼이벤트
	$("#btnBuyBorg").click(function(){
		var borgNm = $("#srcBorgName").val();
		fnBuyborgDialog("", "", borgNm, "fnCallBackBuyBorg"); 
	});
	$('#btnSearchCategory').click(function(){fnCategoryPopOpen();});//카테고리 조회
	$('#btnEraseCategory').click(function(){$("#srcMajoCodeName").val(''); $("#srcCateId").val('');});//카테고리 지우기
	$('#srcButton').click(function(){fnSearch();});//그리드 조회
	orderResultSearchSelect();//코드값 가져오기
	productCategoryHide();
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });	
	$("#excelButton").click( function() { exportExcel(); });//엑셀출력
	$("#allExcelButton").click( function() { fnAllExcelPrintDown(); });	//일괄엑셀출력
});


//날짜 조회 및 스타일
$(function(){
	$("#srcOrderStartDate").datepicker(
		{
			showOn: "button",
			buttonImage: "/img/system/btn_icon_calendar.gif",
			buttonImageOnly: true,
			dateFormat: "yy-mm-dd"
		}
	);
	$("#srcOrderEndDate").datepicker(
		{
			showOn: "button",
			buttonImage: "/img/system/btn_icon_calendar.gif",
			buttonImageOnly: true,
			dateFormat: "yy-mm-dd"
		}
	);
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});
</script>
<%
/**------------------------------------고객사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 고객사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcGroupId = "";
	String _srcClientId = "";
	String _srcBranchId = "";
	String _srcBorgNms = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	if("BUY".equals(loginUserDto.getSvcTypeCd())) {
		_srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
		_srcGroupId = _srcBorgScopeByRoleDto.getSrcGroupId();
		_srcClientId = _srcBorgScopeByRoleDto.getSrcClientId();
		_srcBranchId = _srcBorgScopeByRoleDto.getSrcBranchId();
		_srcBorgNms = _srcBorgScopeByRoleDto.getSrcBorgNms();
		_srcBorgNms = _srcBorgNms.replaceAll("&gt;", ">");
	}
%>
	$("#srcGroupId").val("<%=_srcGroupId %>");
	$("#srcClientId").val("<%=_srcClientId %>");
	$("#srcBranchId").val("<%=_srcBranchId %>");
	$("#srcBorgName").val("<%=_srcBorgNms %>");
<%if("BUY".equals(loginUserDto.getSvcTypeCd()) || "VEN".equals(loginUserDto.getSvcTypeCd())) {    %>
	$("#srcBorgName").attr("disabled", true);
	$("#btnBuyBorg").css("display","none");
<%}%>
	$("#btnBuyBorg").click(function(){
		var borgNm = $("#srcBorgName").val();
		fnBuyborgDialog("", "", borgNm, "fnCallBackBuyBorg"); 
	});
	$("#srcBorgName").keydown(function(e){ if(e.keyCode==13) { $("#btnBuyBorg").click(); } });
	$("#srcBorgName").change(function(e){
		if($("#srcBorgName").val()=="") {
			$("#srcGroupId").val("");
			$("#srcClientId").val("");
			$("#srcBranchId").val("");
		}
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm, areaType) {
//  alert("groupId : "+groupId+", clientId : "+clientId+", branchId : "+branchId+", borgNm : "+borgNm+", areaType : "+areaType);
    $("#srcGroupId").val(groupId);
    $("#srcClientId").val(clientId);
    $("#srcBranchId").val(branchId);
    $("#srcBorgName").val(borgNm);
}
</script>
<%
   /**------------------------------------ 표준카테고리 조회 시작 ---------------------------------
    * fnSearchStandardCategoryInfo(isLastChoice,callbackString ) 을 호출하여 Div팝업을 Display ===
    * 
    * choiceCategoryLevel : 선택가능한 카테고리 레벨을 선택 한다. 
    *                        ex) "1" : 1레벨 부터 하위 래벨 선택 가능 
    *                            "2" : 2레벨 부터 하위 레벨 선택 가능 
    *                            "3" : 3레벨 부터 하위 레벨 선택 가능 
    * callbackString : 콜백 메소드 명을 기입 
    *                  파라미터 정보  (1.categoryseq ,2.카테고리명 ,3.풀카테고리명 )  
    */
%>
<%@ include file="/WEB-INF/jsp/common/product/standardCategoryInfo.jsp"%>
<script type="text/javascript">
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
   	$('#srcCateId').val(categortId); 
   	$('#srcMajoCodeName').val(categortFullName); 
}

/*
 * 엑셀 출력
 */
function exportExcel() {
	var colLabels;
	var colIds;
	if($(":input:radio[name=isDispCate]:checked").val()=="1") {
		colLabels =['주문일자',			'납품요청일',		'사업유형',		'고객유형',	'주문번호',			'대분류',		'중분류',		'소분류',		'상품구분',			'상품명',		'규격',				'단위',				'주문명',			'주문유형',			'주문상태',			'고객사',	'고객사 사업자등록번호','권역',				'수량',		'판매단가',			'판매금액',				'발주일',	'출하일',			'배송정보입력일',	'인수일',			'매출세금 계산서일','매입세금 계산서일','자동인수 여부','상품 실적년도'];
		colIds = [	'regi_date_time', 	'requ_deli_date', 	'codeNmTop'	,	'worknm',	'orde_iden_numb',	'cate_name1',	'cate_name2',	'cate_name3',	'good_clas_code',	'good_name',	'good_spec_desc',	'orde_clas_code',	'cons_iden_name',	'orde_type_name',	'stat_flag_name',	'branchnm',	'bchBusinessNum',		'deli_area_name',	'quantity',	'orde_requ_pric',	'total_orde_requ_pric',	'clin_date','deli_degr_date',	'invoiceDate',		'rece_regi_date',	'clos_sale_date',	'clos_buyi_date',	'auto_receive',	'good_reg_year'];
	}else{
		colLabels =['주문일자',		'납품요청일',		'사업유형',	'고객유형',	'주문번호', 		'상품구분',			'상품명',	'규격',				'단위',				'주문명',			'주문유형',			'주문상태',			'고객사',	'고객사사업자등록번호',	'권역',				'수량',		'판매단가',			'판매금액',				'발주일',	'출하일',			'배송정보입력일',	'인수일',			'매출세금계산서일',	'매입세금계산서일',	'자동인수여부','상품 실적년도'];
		colIds = ['regi_date_time', 'requ_deli_date', 	'codeNmTop','worknm',	'orde_iden_numb', 	'good_clas_code',	'good_name','good_spec_desc',	'orde_clas_code',	'cons_iden_name',	'orde_type_name',	'stat_flag_name',	'branchnm',	'bchBusinessNum',		'deli_area_name',	'quantity',	'orde_requ_pric',	'total_orde_requ_pric',	'clin_date','deli_degr_date',	'invoiceDate',		'rece_regi_date',	'clos_sale_date',	'clos_buyi_date',	'auto_receive','good_reg_year'];
	}
	var numColIds = ['quantity','orde_requ_pric','total_orde_requ_pric'];   //숫자표현ID
	var figureColIds = ['bchBusinessNum'];
	var sheetTitle = "실적조회";    //sheet 타이틀
	var excelFileName = "OrderResultSearch";    //file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);    //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}


/** 일괄 엑셀 다운로드 function*/
function fnAllExcelPrintDown(){
	var colLabels;
	var colIds;
	if($(":input:radio[name=isDispCate]:checked").val()=="1") {
		colLabels =['주문일자',			'납품요청일',		'사업유형',		'고객유형',	'주문번호',			'대분류',		'중분류',		'소분류',		'상품구분',			'상품명',		'규격',				'단위',				'주문명',			'주문유형',			'주문상태',			'고객사',	'고객사 사업자등록번호','권역',				'수량',		'판매단가',			'판매금액',				'발주일',	'출하일',			'배송정보입력일',	'인수일',			'매출세금 계산서일','매입세금 계산서일','자동인수 여부','상품 실적년도'];
		colIds = [	'REGI_DATE_TIME', 	'REQU_DELI_DATE', 	'CODENMTOP'	,	'WORKNM',	'ORDE_IDEN_NUMB',	'CATE_NAME1',	'CATE_NAME2',	'CATE_NAME3',	'GOOD_CLAS_CODE',	'GOOD_NAME',	'GOOD_SPEC_DESC',	'ORDE_CLAS_CODE',	'CONS_IDEN_NAME',	'ORDE_TYPE_NAME',	'STAT_FLAG_NAME',	'BRANCHNM',	'BCHBUSINESSNUM',		'DELI_AREA_NAME',	'QUANTITY',	'ORDE_REQU_PRIC',	'TOTAL_ORDE_REQU_PRIC',	'CLIN_DATE','DELI_DEGR_DATE',	'INVOICEDATE',		'RECE_REGI_DATE',	'CLOS_SALE_DATE',	'CLOS_BUYI_DATE',	'AUTO_RECEIVE',	'GOOD_REG_YEAR'];
	} else {
		colLabels =['주문일자',		'납품요청일',		'사업유형',	'고객유형',	'주문번호', 		'상품구분',			'상품명',	'규격',				'단위',				'주문명',			'주문유형',			'주문상태',			'고객사',	'고객사사업자등록번호',	'권역',				'수량',		'판매단가',			'판매금액',				'발주일',	'출하일',			'배송정보입력일',	'인수일',			'매출세금계산서일',	'매입세금계산서일',	'자동인수여부','상품 실적년도'];
		colIds = ['REGI_DATE_TIME', 'REQU_DELI_DATE', 	'CODENMTOP','WORKNM',	'ORDE_IDEN_NUMB', 	'GOOD_CLAS_CODE',	'GOOD_NAME','GOOD_SPEC_DESC',	'ORDE_CLAS_CODE',	'CONS_IDEN_NAME',	'ORDE_TYPE_NAME',	'STAT_FLAG_NAME',	'BRANCHNM',	'BCHBUSINESSNUM',		'DELI_AREA_NAME',	'QUANTITY',	'ORDE_REQU_PRIC',	'TOTAL_ORDE_REQU_PRIC',	'CLIN_DATE','DELI_DEGR_DATE',	'INVOICEDATE',		'RECE_REGI_DATE',	'CLOS_SALE_DATE',	'CLOS_BUYI_DATE',	'AUTO_RECEIVE','GOOD_REG_YEAR'];
	}
	var numColIds = ['quantity','orde_requ_pric','total_orde_requ_pric'];   //숫자표현ID
	var figureColIds = ['GOOD_IDEN_NUMB', 'PURC_IDEN_NUMB', 'DELI_IDEN_NUMB', 'RECE_IDEN_NUMB', 'BCHBUSINESSNUM', 'VENBUSINESSNUM'];
	var sheetTitle = "실적조회";
	var excelFileName = "OrderResultSearchAll";   
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcOrderNumber';		//주문번호
	fieldSearchParamArray[1] = 'srcGroupId';			//구매사 그룹
	fieldSearchParamArray[2] = 'srcClientId';			//구매사 법인
	fieldSearchParamArray[3] = 'srcBranchId';			//구매사 사업장
	fieldSearchParamArray[4] = 'srcGoodsId';			//상품코드
	fieldSearchParamArray[5] = 'srcGoodsName';			//상품명
	fieldSearchParamArray[6] = 'srcGoodClasCode';		//상품구분
	fieldSearchParamArray[7] = 'srcOrderStatusFlag';	//주문상태
	fieldSearchParamArray[8] = 'srcOrderDateFlag';		//날짜별검색조건
	fieldSearchParamArray[9] = 'srcOrderStartDate';		//날짜
	fieldSearchParamArray[10] = 'srcOrderEndDate';		//날짜
	fieldSearchParamArray[11] = 'srcGoodRegYear';		//상품실적년도
	fieldSearchParamArray[12] = 'srcWorkInfoTop';		//사업유형
	fieldSearchParamArray[13] = 'srcWorkNm';			//고객유형
	fieldSearchParamArray[14] = 'srcCateId';			//상품카테고리
	var tmpExcelUrl = "/order/orderRequest/orderResultSearchExcel.sys?isDispCate=0";
	if($(":input:radio[name=isDispCate]:checked").val()=="1") {
		tmpExcelUrl = "/order/orderRequest/orderResultSearchExcel.sys?isDispCate=1";
	}
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,tmpExcelUrl, figureColIds);  
}
</script>


<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'/order/orderRequest/orderResultSearchJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['주문일자','납품요청일','사업유형','고객유형','주문번호','대분류','중분류','소분류','상품구분','상품코드','상품명','규격','단위',
					'주문명','주문유형', '주문상태', '고객사','고객사사업자등록번호','권역', '수량','판매단가', '판매금액','disp_good_id','고객유형 담당자',
					'발주일','출하일','배송정보입력일','인수일','매출세금계산서일','매입세금계산서일','자동인수여부','상품 실적년도','카테고리 진열명',
					'sum_total_sale_unit_pric','sum_quantity','good_st_spec_desc'],
		colModel:[
			{name:'regi_date_time',index:'regi_date_time', width:70,align:"center",search:false,sortable:true, editable:false, editable:false,sorttype:"date", editable:false,formatter:"date"},//주문일자
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},//납품요청일
			{name:'codeNmTop',index:'codeNmTop', width:60,align:"center",search:false,sortable:true, editable:false},//사업유형
			{name:'worknm',index:'worknm', width:100,align:"center",search:false,sortable:true, editable:false},//고객유형
			{name:'orde_iden_numb',index:'orde_iden_numb', width:120,align:"left",search:false,sortable:true, editable:false},//주문번호
			{name:'cate_name1',index:'cate_name1', width:100,align:"left",search:false,sortable:true, editable:false},//카테고리 대
			{name:'cate_name2',index:'cate_name2', width:100,align:"left",search:false,sortable:true, editable:false},//카테고리 중
			{name:'cate_name3',index:'cate_name3', width:100,align:"left",search:false,sortable:true, editable:false},//카테고리 소
			{name:'good_clas_code',index:'good_clas_code', width:50,align:"center",search:false,sortable:true, editable:false},//상품구분
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false},//상품코드
			{name:'good_name',index:'good_name', width:150,align:"left",search:false,sortable:true, editable:false},//상품명
			{name:'good_spec_desc',index:'good_spec_desc', width:100,align:"left",search:false,sortable:true, editable:false},//상품규격
			{name:'orde_clas_code',index:'orde_clas_code', width:50,align:"center",search:false,sortable:true, editable:false},//단위
			{name:'cons_iden_name',index:'cons_iden_name', width:200,align:"left",search:false,sortable:true, editable:false },//주문명
			{name:'orde_type_name',index:'orde_type_name', width:60,align:"center",search:false,sortable:true, editable:false },//주문유형
			{name:'stat_flag_name',index:'stat_flag_name', width:70,align:"center",search:false,sortable:true, editable:false },//주문상태
			{name:'branchnm',index:'branchnm', width:120,align:"left",search:false,sortable:true, editable:false },//고객사
			{name:'bchBusinessNum',index:'bchBusinessNum', width:120,align:"center",search:false,sortable:true, editable:false },//고객사사업자등록번호
			{name:'deli_area_name',index:'deli_area_name', width:60,align:"center",search:false,sortable:true, editable:false },//권역
			{name:'quantity',index:'quantity', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//수량
			{name:'orde_requ_pric',index:'orde_requ_pric', width:100,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매단가
			{name:'total_orde_requ_pric',index:'total_orde_requ_pric', width:70,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매금액
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false},//disp_good_id
			{name:'workusernm',index:'workusernm', width:100,align:"left",search:false,sortable:true, editable:false,hidden:true},//고객유형담당자
			{name:'clin_date',index:'clin_date', width:70,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},//발주일
			{name:'deli_degr_date',index:'deli_degr_date', width:70,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},//출하일
			{name:'invoiceDate',index:'invoiceDate', width:100,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},//배송정보입력일
			{name:'rece_regi_date',index:'rece_regi_date', width:90,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},//인수일
			{name:'clos_sale_date',index:'clos_sale_date', width:110,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},//매출세금계산서일
			{name:'clos_buyi_date',index:'clos_buyi_date', width:110,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},//매입세금계산서일
			{name:'auto_receive',index:'auto_receive', width:90,align:"center",search:false,sortable:true, editable:false},//자동인수 여부
			{name:'good_reg_year',index:'good_reg_year', width:100,align:"center",search:false,sortable:true, editable:false},//상품실적년도
			{name:'full_cate_name',index:'full_cate_name', width:250,align:"left",search:false,sortable:true, editable:false ,hidden:true},//풀카테고리명
			{name:'sum_total_sale_unit_pric',index:'sum_total_sale_unit_pric', hidden:true,search:false,sortable:true, editable:false},
			{name:'sum_quantity',index:'sum_quantity', hidden:true,search:false,sortable:true, editable:false},
			{name:'good_st_spec_desc',index:'good_st_spec_desc',search:false,sortable:false,editable:false,hidden:true }//표준규격
		],
		postData: {
			srcOrderStartDate:$('#srcOrderStartDate').val(),	//시작날짜
			srcOrderEndDate:$('#srcOrderEndDate').val(),		//마지막 날짜
			isDispCate:'0'										//카테고리 디스플레이 여부
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname: 'regi_date_time', sortorder: "desc",
		caption:"실적조회", 
		viewrecords:true, 
		emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, 
		loadComplete: function() { 
			// 품목 표준 규격 설정
			var prodStSpcNm = new Array();
<%			for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {		%>
				prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
<%			}																			%>
			// 품목 규격 property 추출
			var prodSpcNm = new Array();
<%			for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {			%>
				prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
<%			}																			%>
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt==0){
				var tempPric = "";
				$("#total_sum_pric").html(tempPric);
			}
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				jq("#list").restoreRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				if(idx == 0){
					var total_record = fnComma(Number(jq("#list").getGridParam('records')));
					var tempPric = fnComma(Number(selrowContent.sum_total_sale_unit_pric));
					var tempPric2 = fnComma(Number(selrowContent.sum_quantity));
					tempPric = "<b>총 "+total_record+" 건의 수량합계 : " + tempPric2 + " , 금액 합계 : "+ tempPric+" 원 </b>";
					$("#total_sum_pric").html(tempPric);
				}
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
			if($(":input:radio[name=isDispCate]:checked").val()=="1") {
				$("#list").showCol("cate_name1");
				$("#list").showCol("cate_name2");
				$("#list").showCol("cate_name3");
			}else {
				$("#list").hideCol("cate_name1");
				$("#list").hideCol("cate_name2");
				$("#list").hideCol("cate_name3");
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		afterInsertRow: function(rowid, aData){},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){alert("에러가 발생하였습니다.");},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});


</script>

<script type="text/javascript">

//3자리수마다 콤마
function fnComma(n) {
	 n += '';
	 var reg = /(^[+-]?\d+)(\d{3})/;
	 while (reg.test(n)){
		 n = n.replace(reg, '$1' + ',' + '$2');
	 }
	 return n;
}

//코드값 가져오기
function orderResultSearchSelect(){
	//주문상태
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"RESULTORDERSTATUS",
			isUse:"1"
		},
		function(arg){
			var list = eval('('+arg+')').list;
			for(var i=0; i<list.length; i++){
				$("#srcOrderStatusFlag").append("<option value='"+list[i].codeVal1+"'>"+list[i].codeNm1+"</option>");
				
			}
		}
	);
	//상품구분
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"ORDERGOODSTYPE",
			isUse:"1"
		},
		function(arg){
			var list = eval('('+arg+')').list;
			for(var i=0; i<list.length; i++){
				$("#srcGoodClasCode").append("<option value='"+list[i].codeVal1+"'>"+list[i].codeNm1+"</option>");
			}
		}
	);
	//사업유형
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"SMPWORKINFO_CODE_TOP",
			isUse:"1"
		},
		function(arg){
			var list = eval('('+arg+')').list;
			for(var i=0; i<list.length; i++){
				$("#srcWorkInfoTop").append("<option value='"+list[i].codeVal1+"'>"+list[i].codeNm1+"</option>");
			}
		}
	);
	//고객유형
	$.post(
		"/common/etc/selectWorkInfoList/list.sys",
		{
			isSktsManage:"1"
		},
		function(arg){
			var list = eval('('+arg+')').list;
			for(var i=0; i<list.length; i++){
				$("#srcWorkNm").append("<option value='"+list[i].workId+"'>"+list[i].workNm+"</option>");
			}
		}
	);
}

<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
//상품카테고리 검색
function productCategoryShow(){
		$("#productCategoryInfoTr").show();
}

//상품카테고리 삭제
function productCategoryHide(){
	$("#productCategoryInfoTr").hide();
	$("#srcMajoCodeName").val('');
	$("#srcCateId").val('');
}

//조회
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcOrderNumber = $("#srcOrderNumber").val();
	data.srcGroupId = $("#srcGroupId").val();								//고객사 그룹 아이디
	data.srcClientId = $("#srcClientId").val();								//고객사 법인 아이디
	data.srcBranchId = $("#srcBranchId").val();								//고객사 사업장 아이디
	data.srcGoodsName = $("#srcGoodsName").val();							//상품명
	data.srcGoodsId = $("#srcGoodsId").val();								//상품코드
	data.srcOrderStatusFlag = $("#srcOrderStatusFlag").val();				//주문상태
	data.srcWorkInfoTop = $("#srcWorkInfoTop").val();						//사업유형
	data.srcOrderDateFlag = $("#srcOrderDateFlag").val();					//날짜별 검색 조건
	data.srcOrderStartDate = $("#srcOrderStartDate").val();					//날짜검색 start
	data.srcOrderEndDate = $("#srcOrderEndDate").val();						//날짜검색 end
	data.isDispCate = $(":input:radio[name=isDispCate]:checked").val();		//카테고리 디스플레이 유무 
	if($(":input:radio[name=isDispCate]:checked").val()=="1") {
		$("#list").showCol("cate_name1");
		$("#list").showCol("cate_name2");
		$("#list").showCol("cate_name3");
	} else {
		$("#list").hideCol("cate_name1");
		$("#list").hideCol("cate_name2");
		$("#list").hideCol("cate_name3");
	}
	data.srcWorkNm = $("#srcWorkNm").val();									//고객유형
	data.srcCateId = $("#srcCateId").val();									//카테고리 검색ID
	data.srcGoodClasCode = $("#srcGoodClasCode").val();						//상품구분
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { manageManual(); });	//메뉴얼호출
});

function manageManual(){
	var header = "";
	var manualPath = "";
	//실적조회
	header = "실적조회";
	manualPath = "/img/manual/manage/manageOrderResultManual.JPG";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>

</head>
<body>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>실적조회
						&nbsp;<span id="question" class="questionButton">도움말</span>
					</td>
					<td align="right" class='ptitle'>
						<img id="allExcelButton" src="/img/system/btn_type3_orderResultExcel.gif" width="130" height="22" style="cursor:pointer;"/>
						<img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22" style="cursor:pointer;"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="8" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">주문번호</td>
					<td class="table_td_contents">
						<input id="srcOrderNumber" name="srcOrderNumber" type="text" value="" size="" maxlength="50" style="width: 150px" /> 
					</td>
					<td width="100" class="table_td_subject">고객사</td>
					<td class="table_td_contents">
						<input id="srcBorgName" name="srcBorgName" type="text" value="" size="40" maxlength="30" />
						<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
						<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
						<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
						<a href="#">
							<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
						</a>
					</td>
					<td width="100" class="table_td_subject">카테고리 Display</td>
					<td class="table_td_contents">
						<input name="isDispCate" id="yesDispCate" type="radio" value="1" style="border: 0px;" onclick="productCategoryShow();"/> 예
						<input name="isDispCate" id="noDispCate" type="radio" value="0" checked="checked" style="border: 0px;" onclick="productCategoryHide();"/> 아니오
					</td>
				</tr>
				<tr>
					<td colspan="8" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">상품코드</td>
					<td class="table_td_contents">
						<input id="srcGoodsId" name="srcGoodsId" type="text" value="" size="15" maxlength="15" style="width: 150px" />
					</td>
					<td width="100" class="table_td_subject">상품명</td>
					<td class="table_td_contents">
						<input id="srcGoodsName" name="srcGoodsName" type="text" value="" size="" maxlength="50" style="width: 150px" />
					</td>
					<td width="100" class="table_td_subject">상품구분</td>
					<td class="table_td_contents">
						<select id="srcGoodClasCode">
							<option value="">전체</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="8" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
				<td class="table_td_subject" width="100">주문상태</td>
					<td class="table_td_contents">
						<select id="srcOrderStatusFlag" name="srcOrderStatusFlag" class="select" onchange="javascript:changeOrderStatusFlag();">
							<option value="">전체</option>
						</select>
					</td>
					<td class="table_td_subject">
						<select id="srcOrderDateFlag" name="srcOrderDateFlag" class="select">
						<option value="">주문일</option>
						<option value="1">발주일</option>
						<option value="2">출하일</option>
						<option value="3">배송정보 입력일</option>
						<option value="4">인수일</option>
						<option value="5">정산생성일</option>
						<option value="9">매출 세금계산서일</option>
						<option value="8">매입 세금계산서일</option>
						</select>
					</td>
					<td class="table_td_contents">
						<input type="text" name="srcOrderStartDate" id="srcOrderStartDate" style="width: 75px;vertical-align: middle;" /> 
						~ 
						<input type="text" name="srcOrderEndDate" id="srcOrderEndDate" style="width: 75px;vertical-align: middle;" />
					</td>
					<td class="table_td_subject" width="100">사업유형</td>
					<td class="table_td_contents">
						<select id="srcWorkInfoTop" name="srcWorkInfoTop" class="select">
							<option value="">전체</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">고객유형</td>
					<td class="table_td_contents"> 
						<select id="srcWorkNm" name="srcWorkNm" style="width: 120px" class="select" >
							<option value="">전체</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="8" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr id="productCategoryInfoTr">
					<td class="table_td_subject" width="100">상품 카테고리</td>
					<td class="table_td_contents" colspan="5">
						<input id="srcMajoCodeName" name="srcMajoCodeName" type="text" value="" size="20" maxlength="30" style="width: 400px;background-color: #eaeaea;" disabled="disabled"/>
						<input id="srcCateId" name="srcCateId" type="hidden" value="" readonly="readonly" />
						<a href="#">
							<img id="btnSearchCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
						</a>
						<a href="#">
							<img id="btnEraseCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_clear.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="8" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td colspan="8" class="table_top_line"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="10" align="left"></td></tr>
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right">
						<span id="total_sum_pric"></span>&nbsp;
						<a href="#">
							<img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> 
						</a>
						<a href="#">
							<img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> 
						</a>
					</td>
				</tr>
			</table>
		</td>
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
</body>
</html>