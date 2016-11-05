<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList      = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")    
	List<CodesDto>      codeList      = (List<CodesDto>)request.getAttribute("codeList");
	@SuppressWarnings("unchecked")    
	List<SmpUsersDto>   workInfoList  = (List<SmpUsersDto>)request.getAttribute("workInfoList");
	LoginUserDto        loginUserDto  = CommonUtils.getLoginUserDto(request);
	String              _menuId       = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String              listHeight    = "$(window).height()-480 + Number(gridHeightResizePlus)";
	String              listWidth     = "1500";
	List<LoginRoleDto>  loginRoleList = null;
	boolean             spUser        = false;
	boolean             ubinsMan      = false;
	boolean             isMng         = CommonUtils.isMngUser(loginUserDto);
	
	loginRoleList = (List<LoginRoleDto>)loginUserDto.getLoginRoleList();
	
	for(LoginRoleDto lrd : loginRoleList){
		if(lrd.getRoleCd().equals("ADM_SPECIAL")){
			spUser = true;
		}
		
		if(lrd.getRoleCd().equals("UBINS_MAN")){ //유빈스권한 세팅
			ubinsMan = true;
		}
	}
	
	String getYear = CommonUtils.getCurrentDate().substring(0, 4);
	
	String menuTitle = "실적조회";
	if (loginUserDto.isSKBMng() == true || loginUserDto.isSKTMng() ==true) { menuTitle = "상세실적조회";} 
	String skMngFlag = loginUserDto.getSkMngFlag();
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
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
	$("#srcGroupId").val("");
	$("#srcClientId").val("");
	$("#srcBranchId").val("");
	$("#srcBorgName").val("");

	$("#btnBuyBorg").click(function(){
		var borgNm = $("#srcBorgName").val();
		
		fnBuyborgDialog("", "", borgNm, "fnCallBackBuyBorg"); 
	});
	
	$("#srcBorgName").keydown(function(e){
		if(e.keyCode == 13){
			$("#btnBuyBorg").click();
		}
	});
	
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
	$("#srcGroupId").val(groupId);
	$("#srcClientId").val(clientId);
	$("#srcBranchId").val(branchId);
	$("#srcBorgName").val(borgNm);
}
</script>
<% //------------------------------------------------------------------------------ %>

<%
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	$("#btnVendor").click(function(){
		var vendorNm = $("#srcVendorName").val();
		
		fnVendorDialog(vendorNm, "fnCallBackVendor"); 
	});
	
	$("#srcVendorName").keydown(function(e){
		if(e.keyCode == 13){
			$("#btnVendor").click();
		}
	});
	
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

<script type="text/javascript">
var jq = jQuery;

$(document).ready(function() {
	fnInitEvent();
	fnInitDatePicker(); // 날짜 세팅
	fnInitGrid();
	goodRegYear(); //상품실적년도 셀렉트박스
	orderRequestCodeList(); //실적조회에서 사용할 코드리스트
	fnGetWorkInfoList();
	selectProductManager(); //상품담당자
});

function fnInitEvent(){
	$("#srcOrderNumber").keydown(function(e){
		if(e.keyCode == 13){
			$("#srcButton").click();
		}
	});
	
	$("#srcGoodsName, #srcConsIdenName").keydown(function(e){
		if(e.keyCode == 13){
			$("#srcButton").click();
		}
	});
	
	$("#srcGoodsId").keydown(function(e){
		if(e.keyCode == 13){
			$("#srcButton").click();
		}
	});
	
	$("#srcButton").click(function(){ 
		fnSearch(); 
	});
	
	$("#allExcelButton").click(function(){
		fnAllExcelPrintDown();
	});
	
	$("#srcWorkNm").change(function(){ //고객유형여부
		workInfoValidation();
	});
	
	$('#setButton').click(function () {
    	$("#list").jqGrid('columnChooser', {
            done: function (perm) {
                fnSaveColumn("#list"); // 1. 저장할 그리드의 아이디를 넣어줌. 
            }
        });
    });
	
	
	<%-- 카테고리 조회 관련 추가 --%>
    $('#btnSearchCategory').click(function()    {   fnCategoryPopOpen();});
    $('#btnEraseCategory').click(function()     {   $("#srcMajoCodeName").val(''); $("#srcCateId").val('');});
}

function fnInitDatePicker(){
	$("#srcOrderStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd",
	});
	
	$("#srcOrderEndDate").datepicker({
			showOn: "button",
			buttonImage: "/img/system/btn_icon_calendar.gif",
			buttonImageOnly: true,
			dateFormat: "yy-mm-dd",
	});
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
	
	$("#srcOrderStartDate").val("<%=CommonUtils.getCustomDay("DAY", -1)%>");
	$("#srcOrderEndDate").val("<%=CommonUtils.getCurrentDate()%>");
}


//리사이징
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  

function fnInitGrid(){
	var colModel = fnLoadColumn('#list', false);

	
	$("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderResultSearchJQGridAdm.sys', 
		datatype: 'local',
		mtype: 'POST',
		colNames:[
			'주문일자',			'납품요청일',				'사업유형',				'고객유형',			'주문번호',
			'대분류',			'중분류',				'소분류',				'상품구분',			'상품코드','상품명',
			'규격',				'단위',					'상품담당자',				'발주차수',			'발주수량',
			'출하차수',			'출하수량',				'인수차수',				'인수수량',			'주문명',
			'주문상태',			'배송형태',				'구매사',				'구매사사업자등록번호','공급사',			'공급사사업자등록번호',
			'주문자',			'인수자',				'인수자 전화번호',		'수량',				'판매단가',
			'판매금액',			<%if(isMng == false){%>'매입단가', 				'매입금액',<%}%>		'disp_good_id',		'vendorid',
// 			'good_iden_numb',	
			'good_st_spec_desc','고객유형 담당자',		'발주일',				'출하일',
			'인수일',			'정산생성일',				'매출세금계산서일',		'매입세금계산서일', 	'자동인수여부',
			'상품 실적년도',		'법인ID',				'사업장ID',				'공급사ID'					
			, 'sum_1' ,'sum_2'
		],
        colModel:[
			{name:'regiDateTime',      index:'regiDateTime',      width:70,  align:"center", search:false, sortable:false, editable:false},//주문일자
			{name:'regiDeliDate',      index:'regiDeliDate',      width:70,  align:"center", search:false, sortable:false, editable:false},//납품요청일
			{name:'codeNmTop',         index:'codeNmTop',         width:60,  align:"center", search:false, sortable:false, editable:false},//사업유형
			{name:'workNm',            index:'workNm',            width:100, align:"left",   search:false, sortable:false, editable:false},//고객유형
			{name:'ordeIdenNumb',      index:'ordeIdenNumb',      width:120, align:"center", search:false, sortable:false, editable:false},//주문번호
			
			{name:'cateName1',         index:'cateName1',         width:100, align:"left",   search:false, sortable:false, editable:false},//카테고리 대
			{name:'cateName2',         index:'cateName2',         width:100, align:"left",   search:false, sortable:false, editable:false},//카테고리 중
			{name:'cateName3',         index:'cateName3',         width:100, align:"left",   search:false, sortable:false, editable:false},//카테고리 소
			{name:'goodClasCode',      index:'goodClasCode',      width:50,  align:"center", search:false, sortable:false, editable:false},//상품구분
			{name:'goodIdenNumb',      index:'good_iden_numb',    width:80,  align:"center", search:false, sortable:false, editable:false},//상품코드
			{name:'goodName',          index:'goodName',          width:150, align:"left",   search:false, sortable:false, editable:false},//상품명
			
			{name:'goodSepcDesc',      index:'goodSepcDesc',      width:120, align:"left",   search:false, sortable:false, editable:false},//상품규격
			{name:'ordeClasCode',      index:'ordeClasCode',      width:50,  align:"center", search:false, sortable:false, editable:false},//단위
			{name:'productManager',    index:'productManager',    width:80,  align:"center", search:false, sortable:false, editable:false},//상품담당자
			{name:'purcIdenNumb',      index:'purcIdenNumb',      width:60,  align:"center", search:false, sortable:false, editable:false},//납품차수
			{name:'purcIdenQuan',      index:'purcIdenQuan',      width:60,  align:"right",  search:false, sortable:false, editable:false,
				sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},
				
			{name:'deliIdenNumb',      index:'deliIdenNumb',      width:60,  align:"center", search:false, sortable:false, editable:false},
			{name:'deliIdenQuan',      index:'deliIdenQuan',      width:60,  align:"right",  search:false, sortable:false, editable:false,
				sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},
			{name:'receIdenNumb',      index:'receIdenNumb',      width:60,  align:"center", search:false, sortable:false, editable:false},
			{name:'receIdenQuan',      index:'receIdenQuan',      width:60,  align:"right",  search:false, sortable:false, editable:false,
				sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},
			{name:'consIdenName',      index:'consIdenName',      width:200, align:"left",   search:false, sortable:false, editable:false},//주문명
			
			{name:'statFlagName',      index:'statFlagName',      width:70,  align:"center", search:false, sortable:false, editable:false},//주문상태
			{name:'deliTypeClas',      index:'deliTypeClas',      width:70,  align:"center", search:false, sortable:false, editable:false},//배송형태
			
			
			{name:'branchNm',          index:'branchNm',          width:120, align:"left",   search:false, sortable:false, editable:false},//고객사
			{name:'bchBusinessNum',    index:'bchBusinessNum',    width:120, align:"center", search:false, sortable:false, editable:false, hidden:true },//구매사사업자등록번호
			{name:'vendorNm',          index:'vendorNm',          width:120, align:"left",   search:false, sortable:false, editable:false},//공급사
			{name:'venBusinessNum',    index:'venBusinessNum',    width:120, align:"center", search:false, sortable:false, editable:false,hidden:true},//공급사사업자등록번호
			
			{name:'userNm',            index:'userNm',            width:70,  align:"center",   search:false, sortable:false, editable:false},//주문자
			{name:'tranUserName',      index:'tranUserName',      width:70,  align:"center",   search:false, sortable:false, editable:false},//인수자
			{name:'tranTeleNumb',      index:'tranTeleNumb',      width:90,  align:"right",  search:false, sortable:false, editable:false,hidden:true},//인수자 전화번호
			{name:'quantity',          index:'quantity',          width:50,  align:"right",  search:false, sortable:false, editable:false,
				sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//수량
			{name:'ordeRequPrice',     index:'ordeRequPrice',     width:100, align:"right",  search:false, sortable:false, editable:false,
				sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//판매단가
			
			{name:'totalOrdeRequPric', index:'totalOrdeRequPric', width:70,  align:"right",  search:false, sortable:false, editable:false,
				sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//판매금액
<%
	if(isMng == false){
%>
           	{name:'saleUnitPric',      index:'saleUnitPric',      width:70,  align:"right",  search:false, sortable:false, editable:false,
				sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
           	},//매입단가
			{name:'totalOrdeUnitPric', index:'totalOrdeUnitPric', width:80,  align:"right",  search:false, sortable:false, editable:false,
				sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매출금액
<%
	}
%>
			{name:'dispGoodId',        index:'dispGoodId',        hidden:true, hidedlg:true},
			{name:'vendorId',          index:'vendorId',          hidden:true, hidedlg:true},
			
// 			{name:'goodIdenNumb',      index:'good_iden_numb',    hidden:true, hidedlg:true},
			{name:'goodStSepcDesc',    index:'goodStSepcDesc',    hidden:true, hidedlg:true},//표준규격
			{name:'workUserNm',        index:'workUserNm',        width:90, align:"center",   search:false, sortable:false, editable:false},//고객유형담당자
			{name:'clinDate',          index:'clinDate',          width:80,  align:"center", search:false, sortable:false, editable:false},//발주일
			{name:'deliDegrDate',      index:'deliDegrDate',      width:80,  align:"center", search:false, sortable:false, editable:false},//출하일
			
			{name:'receRegiDate',      index:'receRegiDate',      width:80,  align:"center", search:false, sortable:false, editable:false},//인수일
			{name:'creaSaleDate',      index:'creaSaleDate',      width:80,  align:"center", search:false, sortable:false, editable:false},//정산생성일
			{name:'closSaleDate',      index:'closSaleDate',      width:90,  align:"center", search:false, sortable:false, editable:false},//매출세금계산서일
			{name:'closBuyiDate',      index:'closBuyiDate',      width:90,  align:"center", search:false, sortable:false, editable:false},//매입세금계산서일
			
			{name:'autoReceive',       index:'autoReceive',       width:70,  align:"center", search:false, sortable:false, editable:false},
			{name:'goodregYear',       index:'goodregYear',       width:80,  align:"center", search:false, sortable:false, editable:false},//상품실적년도
			{name:'clientId',          index:'clientId',          hidden:true, hidedlg:true},//법인ID
			{name:'branchId',          index:'branchId',          hidden:true, hidedlg:true},//사업장ID
			{name:'vendorId',          index:'vendorId',          hidden:true, hidedlg:true}//공급사ID
			
			,{name:'sum_total_sale_unit_pric',index:'sum_total_sale_unit_pric', hidden:true,search:false,sortable:true, editable:false,hidedlg:true},
			{name:'sum_quantity',index:'sum_quantity', hidden:true,search:false,sortable:true, editable:false,hidedlg:true}  
		],
		postData: {
			srcOrderNumber     : $("#srcOrderNumber").val(), // 주문번호
			srcGroupId         : $("#srcGroupId").val(),
			srcClientId        : $("#srcClientId").val(),
			srcBranchId        : $("#srcBranchId").val(),
			srcVendorId        : $("#srcVendorId").val(), // 공급업체
			srcGoodsName       : $("#srcGoodsName").val(), // 상품명
			srcGoodsId         : $("#srcGoodsId").val(), // 상품코드
			srcOrderStatusFlag : $("#srcOrderStatusFlag").val(), // 주문상태
			srcGoodRegYear     : $("#srcGoodRegYear").val(), // 상품실적년도
			srcWorkInfoTop     : $("#srcWorkInfoTop").val(), // 사업유형	
			srcOrderDateFlag   : $("#srcOrderDateFlag").val(), // 날짜 조회 조건
			srcOrderStartDate  : $("#srcOrderStartDate").val(), // 날짜 검색 시작일
			srcOrderEndDate    : $("#srcOrderEndDate").val(), // 날짜 검색 종료일
			srcWorkInfoUser    : $("#srcWorkInfoUser").val(), // 공사 담당자
			srcWorkNm          : $("#srcWorkNm").val(), // 고객유형
			srcGoodClasCode    : $("#srcGoodClasCode").val(),//상품구분
			srcProductManager  : $("#srcProductManager").val(),//상품담당자
			srcIsClosSaleDate  : $("#srcIsClosSaleDate").val(),//매출계산서 발행
			srcCateId  		   : $("#srcCateId").val(),//카테고리
			srcPrepay  		   : $("#srcPrepay").val(),//선입금여부
			srcIsSktManage     : $("#srcIsSktManage").val(),//SKT관리여부
			srcConsIdenName      : $("#srcConsIdenName").val()//주문명
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		sortname: 'regi_date_time', sortorder: "desc",
		viewrecords:true, 
		emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, 
		loadComplete: function() {
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
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		afterInsertRow: function(rowid, aData){
<%
	if(isMng == false){
%>
			fnListOnAfterInsertRow(rowid, aData);
<%
	}
%>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
<%
	if(isMng == false){
%>
			fnListOnCellSelect(rowid, iCol, cellcontent, target);
<%
	}
%>
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}

function fnListOnCellSelect(rowid, iCol, cellcontent, target){
	var cm            = $("#list").jqGrid("getGridParam", "colModel");
	var colName       = cm[iCol];
	var selrowContent = $("#list").jqGrid('getRowData', rowid);
	var purcIdenNumb  = selrowContent.purcIdenNumb;
	var clientid      = selrowContent.clientId;
	var branchid      = selrowContent.branchId;
	var vendorid      = selrowContent.vendorId;
	var goodIdenNumb  = selrowContent.goodIdenNumb;
	var colNameInex   = null;
<%
	if(!spUser){
%>
	if(colName != undefined){
		colNameInex = colName['index'];
		
		if(colNameInex == "ordeIdenNumb"){
			if(purcIdenNumb == ""){
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ", "fnOrderDetailView(cellcontent, "+_menuId+");")%> 
			}
			else{
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ", "fnOrderDetailView(cellcontent, "+_menuId+", purcIdenNumb);")%>
			}
		}
		else if(colNameInex == "branchNm"){
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ", "branchDetailView(clientid, branchid);")%>
		}
		else if(colNameInex == "vendorNm"){
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ", "vendorDetailView(vendorid);")%>
		}
		else if(colNameInex == "goodName"){
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ", "fnProductDetailView("+_menuId+", goodIdenNumb, vendorid);")%>
		}
	}
<%			
	}
%>
}

function fnListOnAfterInsertRow(rowid, aData){
	var selrowContent = $("#list").jqGrid('getRowData',rowid);
<%
	if(!spUser){
%>
	$("#list").setCell(rowid, 'ordeIdenNumb', '', {color  : '#0000ff'});
	$("#list").setCell(rowid, 'ordeIdenNumb', '', {cursor : 'pointer'});  
	$("#list").setCell(rowid, 'goodName',     '', {color  : '#0000ff'});
	$("#list").setCell(rowid, 'goodName',     '', {cursor : 'pointer'});
	$("#list").setCell(rowid, 'branchNm',     '', {color  : '#0000ff'});
	$("#list").setCell(rowid, 'branchNm',     '', {cursor : 'pointer'});
	$("#list").setCell(rowid, 'vendorNm',     '', {color  : '#0000ff'});
	$("#list").setCell(rowid, 'vendorNm',     '', {cursor : 'pointer'});
<%
	}
%>
	$("#list").jqGrid('setRowData', rowid, {tranTeleNumb : fnSetTelformat(selrowContent.tranTeleNumb)});
}

/*
 * 리스트ㅓ 
 */
function fnSearch() {
	var data = $("#list").jqGrid("getGridParam", "postData");
	
	data.srcOrderNumber     = $("#srcOrderNumber").val(); // 주문번호
	data.srcGroupId         = $("#srcGroupId").val();
	data.srcClientId        = $("#srcClientId").val();
	data.srcBranchId        = $("#srcBranchId").val();
	data.srcVendorId        = $("#srcVendorId").val(); // 공급업체
	data.srcGoodsName       = $("#srcGoodsName").val(); // 상품명
	data.srcGoodsId         = $("#srcGoodsId").val(); // 상품코드
	data.srcOrderStatusFlag = $("#srcOrderStatusFlag").val(); // 주문상태
	data.srcGoodRegYear     = $("#srcGoodRegYear").val(); // 상품실적년도
	data.srcWorkInfoTop     = $("#srcWorkInfoTop").val(); // 사업유형	
	data.srcOrderDateFlag   = $("#srcOrderDateFlag").val(); // 날짜 조회 조건
	data.srcOrderStartDate  = $("#srcOrderStartDate").val(); // 날짜 검색 시작일
	data.srcOrderEndDate    = $("#srcOrderEndDate").val(); // 날짜 검색 종료일
	data.srcWorkInfoUser    = $("#srcWorkInfoUser").val(); // 공사 담당자
	data.srcWorkNm          = $("#srcWorkNm").val(); // 고객유형
	data.srcGoodClasCode    = $("#srcGoodClasCode").val();//상품구분
	data.srcProductManager  = $("#srcProductManager").val();//상품담당자
	data.srcIsClosSaleDate  = $("#srcIsClosSaleDate").val();//매출계산서 발행
	data.srcCateId  		= $("#srcCateId").val();//카테고리
	data.srcPrepay  		= $("#srcPrepay").val();//선입금여부
	data.srcIsSktManage  	= $("#srcIsSktManage").val();//SKT관리여부 
	data.srcConsIdenName  	= $("#srcConsIdenName").val();//주문명
	
	$("#list").jqGrid("setGridParam", {"page":1 , "datatype":"json"});
	$("#list").jqGrid("setGridParam", { "postData": data });
	$("#list").trigger("reloadGrid");
}

/** 일괄 엑셀 다운로드 function*/
function fnAllExcelPrintDown(){
	var colLabels =[
		'주문일자',		'납품요청일',		'사업유형',			'고객유형',			'주문번호',
		'대분류',		'중분류',			'소분류',			'상품구분',			'상품코드',			'상품명',
		'규격',			'총중량',			'실중량',			'재질',				'타입',				'단위',				'상품담당자',			
		'발주차수',		'발주수량',			'출하차수',			'출하수량',			'인수차수',			'인수수량',			'주문명',
		'주문상태',		'배송형태',			'송장번호/연락처',	'비고',				'구매사',			'권역',				'구매사 사업자번호',	
		'공급사',		'공급사 사업자번호','주문자',			'인수자',			'수량',				'판매단가',
		'판매금액',		<%if(isMng == false){%>'매입단가', 			'매입금액',<%}%>		'고객유형 담당자',	'발주일',
		'출하일',		'배송정보입력일',	'인수일',		'정산생성일',	'정산월',		'매출세금계산서일',	'매입세금계산서일',	
		'자동인수여부',	'상품 실적년도'
	];
	
	var colIds = [
		'regiDateTime',		'regiDeliDate',		'codeNmTop',		'workNm',			'ordeIdenNumb',
		'cateName1',		'cateName2',		'cateName3',		'goodClasCode',		'goodIdenNumb',			'goodName',
		'goodSepcDesc',		'specWeightSum',	'specWeightReal',	'specMaterial',		'specType',				'ordeClasCode',		'productManager',	
		'purcIdenNumb',		'purcIdenQuan',		'deliIdenNumb',		'deliIdenQuan',		'receIdenNumb',			'receIdenQuan',		'consIdenName',
		'statFlagName',		'deliTypeClas'		,'deliInvoIden'	,	'deliDesc',			'branchNm',				'areaTypeNm',		'bchBusinessNum',
		'vendorNm',			'venBusinessNum',	'userNm',			'tranUserName',		'quantity',				'ordeRequPrice',
		'totalOrdeRequPric',<%if(isMng == false){%>'saleUnitPric',	'totalOrdeUnitPric',<%}%>	'workUserNm',	'clinDate',
		'deliDegrDate',		'receRegiDate', 'receRegiDate',	'creaSaleDate', 'creaSaleMonth','closSaleDate',	'closBuyiDate',
		'autoReceive',		'goodregYear'
	];
	
	var numColIds             = ["quantity", "ordeRequPrice", "saleUnitPric", "receIdenQuan", "deliIdenQuan",
	                                   "purcIdenQuan", "totalOrdeRequPric", "totalOrdeUnitPric"];
	var figureColIds          = [];
	var sheetTitle            = "실적조회";
	var excelFileName         = "OrderResultSearchAll";
	var fieldSearchParamArray = new Array();
	
	fieldSearchParamArray[0]  = 'srcOrderNumber';
	fieldSearchParamArray[1]  = 'srcGroupId';
	fieldSearchParamArray[2]  = 'srcClientId';
	fieldSearchParamArray[3]  = 'srcBranchId';
	fieldSearchParamArray[4]  = 'srcVendorId';
	fieldSearchParamArray[5]  = 'srcGoodsName';
	fieldSearchParamArray[6]  = 'srcGoodsId';
	fieldSearchParamArray[7]  = 'srcOrderStatusFlag';
	fieldSearchParamArray[8]  = 'srcGoodRegYear';
	fieldSearchParamArray[9]  = 'srcWorkInfoTop';
	fieldSearchParamArray[10] = 'srcOrderDateFlag';
	fieldSearchParamArray[11] = 'srcOrderStartDate';
	fieldSearchParamArray[12] = 'srcOrderEndDate';
	fieldSearchParamArray[13] = 'srcWorkInfoUser';
	fieldSearchParamArray[14] = 'srcWorkNm';
	fieldSearchParamArray[15] = 'srcGoodClasCode';
	fieldSearchParamArray[16] = 'srcProductManager';
	fieldSearchParamArray[17] = 'srcIsClosSaleDate';
	fieldSearchParamArray[18] = 'srcCateId';
	fieldSearchParamArray[19] = 'srcPrepay';
	fieldSearchParamArray[20] = 'srcIsSktManage';
	fieldSearchParamArray[21] = 'srcConsIdenName';
	
	var tmpExcelUrl = "/order/orderRequest/orderResultSearchJQGridAdmExcel.sys";
	
	fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray,tmpExcelUrl);
}

// 담당자와 매칭되는 고객유형을 가져온다.
function fnGetWorkInfoList() {
	$.post( 
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/getWorkInfoList.sys',
		{
			userId:$("#srcWorkInfoUser").val()
		},
		function(arg){
			var workInfoList = eval('(' + arg + ')').workInfoList;
			$("#srcWorkNm").html("");
			$("#srcWorkNm").append("<option value=''>전체</option>");
			for(var i=0;i<workInfoList.length;i++) {
				$("#srcWorkNm").append("<option value='"+workInfoList[i].WORKID+"'  >"+workInfoList[i].WORKNM+"</option>");
			}
		}
	);
}

/**
 * 상품실적년도 셀렉트 박스
 */
function goodRegYear() {
	var getYear = "<%=getYear%>";
	for(var i=getYear; i>=2010;i--){
		$("#srcGoodRegYear").append("<option value='"+i+"'>"+i+"</option>");
	}
}

/**
 * 사업유형셀렉트박스
 */
function orderRequestCodeList() {
	$.post(
		'/order/orderRequest/orderRequestCodeList.sys',
		function(arg){
			var workInfoTopList = eval('(' + arg + ')').codeList;
			
			for(var i=0; i<workInfoTopList.length; i++){
				$("#srcWorkInfoTop").append("<option value='"+workInfoTopList[i].codeVal1+"'>"+workInfoTopList[i].codeNm1+"</option>");
			}
			
			var coodClasCodeList = eval('(' + arg + ')').coodClasCodeList;
			
			for(var i=0; i<coodClasCodeList.length; i++){
				$("#srcGoodClasCode").append("<option value='"+coodClasCodeList[i].codeVal1+"'>"+coodClasCodeList[i].codeNm1+"</option>");
			}
			
			$("#srcWorkInfoTop").val('<%=skMngFlag%>');
			if( '<%=skMngFlag%>' ==1 || '<%=skMngFlag%>' ==2){
				$("#srcWorkInfoTop").attr("disabled","disabled");
			}
		}
	);
}

function selectProductManager() {
	//상품담당자 셀렉트박스
	//B2B권한
	$.post(
		"/product/selectProductManager/list.sys",
		{},
		function(arg){
			var productManagetList = eval('('+arg+')').list;
			for(var i=0; i<productManagetList.length; i++){
				$("#srcProductManager").append("<option value='"+productManagetList[i].USERID+"'>"+productManagetList[i].USERNM+"</option>");
			}
		}
	);
}

//구매사 디테일 팝업
function branchDetailView(clientid, branchid){
	var param = "branchId=" + branchid;
	
	param = param + "&clientId=" + clientid;
	param = param + "&_menuId=<%=_menuId %>";
	
	window.open("", 'organBranchDetail', 'width=920, height=800, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/organ/organBranchDetail.sys", param, 'organBranchDetail');
}

//공급사 디테일 팝업
function vendorDetailView(vendorid){
	var param = "vendorId=" + vendorid;
	
	param = param + "&_menuId=<%=_menuId%>";
	
	window.open('', 'organVendorDetail', 'width=920, height=670, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/organ/organVendorDetail.sys", param, 'organVendorDetail');
}

//고객유형이 없을 경우 마지막날짜 비교하여 1년전 날짜 입력
function workInfoValidation(){
	var workNm = $("#srcWorkNm").val();//고객유형
	
	if(workNm == ""){
		var orderEndDate = new Date($("#srcOrderEndDate").val());
		var endDate      = orderEndDate.getDate();
		
		orderEndDate.setDate(endDate -365);
		
		var year  = orderEndDate.getFullYear();
		var month = orderEndDate.getMonth()+1;
		var day   = orderEndDate.getDate();
		
		if(month < 10){
			month = "0"+month;
		}
		
		if(day < 10){
			day = "0"+day;
		}
		
		var getDate = year+"-"+month+"-"+day;
		
		$("#srcOrderStartDate").val(getDate);
	}
}

function fnCategoryPopOpen(){
     fnSearchStandardCategoryInfo("1", "fnCallBackStandardCategoryChoice"); 
}
function fnCallBackStandardCategoryChoice(categortId , categortName , categortFullName) {
    var msg = ""; 
    $('#srcCateId').val(categortId); 
    $('#srcMajoCodeName').val(categortFullName); 
}  
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
<form id="frm" name="frm" onsubmit="return false;">
<table width="1500px" style="margin-left: 00px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'><%=menuTitle %> </td>
					<td align="right" class='ptitle'>
						<button id='allExcelButton' class="btn btn-success btn-sm" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
							<i class="fa fa-file-excel-o"></i> 엑셀
						</button>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
							<i class="fa fa-search"></i> 조회
						</button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="1"></td>
	</tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="8" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">주문번호</td>
					<td class="table_td_contents">
						<input id="srcOrderNumber" name="srcOrderNumber" type="text" value="" size="" maxlength="50" style="width: 150px" /> 
					</td>
					<td width="100" class="table_td_subject">구매사</td>
					<td class="table_td_contents">
						<input id="srcBorgName" name="srcBorgName" type="text" value="" size="40" maxlength="30" />
						<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
						<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
						<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
						<a href="#">
							<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
						</a>
					</td>
					<td class="table_td_subject">상품명</td>
					<td class="table_td_contents">
						<input id="srcGoodsName" name="srcGoodsName" type="text" value="" size="" maxlength="50" style="width: 100px" />
					</td>
				</tr>
				<tr>
					<td colspan="8" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">공급업체</td>
					<td class="table_td_contents">
						<input id="srcVendorName" name="srcVendorName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
						<input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
						<a href="#">
							<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
						</a>
					</td>
					<td class="table_td_subject">상품코드</td>
					<td class="table_td_contents">
						<input id="srcGoodsId" name="srcGoodsId" type="text" value="" size="15" maxlength="15" />
					</td>
					<td class="table_td_subject" width="100">상품구분</td>
					<td class="table_td_contents">
						<select id="srcGoodClasCode" name="srcGoodClasCode" class="select">
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
						<select id="srcOrderStatusFlag" name="srcOrderStatusFlag" class="select" >
							<option value="">전체</option>
<%
	if(codeList != null){
		CodesDto cdData       = null;
		String   codeVal1     = null;
		String   codeNm1      = null;
		int      i            = 0;
		int      codeListSize = codeList.size();
		
		for (i = 0; i < codeListSize; i++) {
			cdData   = codeList.get(i);
			codeVal1 = cdData.getCodeVal1();
			codeNm1  = cdData.getCodeNm1();
			
			if(
				"05".equals(codeVal1) ||
				"10".equals(codeVal1) ||
				"40".equals(codeVal1) ||
				"50".equals(codeVal1) ||
				"55".equals(codeVal1) ||
				"60".equals(codeVal1) ||
				"70".equals(codeVal1) ||
				"80".equals(codeVal1)
			){
%>
				<option value="<%=codeVal1 %>" ><%=codeNm1 %></option>
<% 			} 
		} 
	}
%>
						</select>
					</td>
					<td class="table_td_subject" style="vertical-align: middle; padding-top: 0px;">
						<select id="srcOrderDateFlag" name="srcOrderDateFlag" class="select">
							<option value="">주문일</option>
							<option value="5">인수일</option>
							<option value="9">매출 세금계산서일</option>
							<option value="8">매입 세금계산서일</option>
						</select>
					</td>
					<td class="table_td_contents">
						<input type="text" name="srcOrderStartDate" id="srcOrderStartDate" style="width: 75px;vertical-align: middle;" />~ 
						<input type="text" name="srcOrderEndDate" id="srcOrderEndDate" style="width: 75px;vertical-align: middle;" />
					</td>
					<td width="100" class="table_td_subject">상품담당자</td>
					<td class="table_td_contents">
						<select id="srcProductManager" name="srcProductManager" class="select">
							<option value="">전체</option>
						</select>
					</td>
					
				</tr>
				<tr>
					<td colspan="8" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">공사담당자</td>
					<td class="table_td_contents" >
						<select id="srcWorkInfoUser" name="srcWorkInfoUser" class="select" onchange="javascript:fnGetWorkInfoList();">
							<option value="">전체</option>
<%		
	if(workInfoList != null){
		if(workInfoList.size() > 0 ){
			SmpUsersDto sud = null;
			
			for (int i = 0; i < workInfoList.size(); i++) {
				sud = workInfoList.get(i); 
				String _selected = "";
				
				if(loginUserDto.getUserId().equals(sud.getUserId())){
					_selected="selected";
				}
%>
							<option value="<%=sud.getUserId()%>" <%=_selected %>><%=sud.getUserNm()%></option>
<%				
				}
			} 
%>
						</select>
					</td>
					<td class="table_td_subject" width="100">고객유형</td>
					<td class="table_td_contents"> 
						<select id="srcWorkNm" name="srcWorkNm" style="width: 120px" class="select" >
							<option value="">전체</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">사업유형</td>
					<td class="table_td_contents">
						<select id="srcWorkInfoTop" name="srcWorkInfoTop" class="select">
							<option value="">전체</option>
						</select>
					</td>
				</tr>
<%	
	}
%>
				<tr>
					<td colspan="8" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">상품 실적년도</td>
					<td class="table_td_contents">
						<select id="srcGoodRegYear" name="srcGoodRegYear" class="select">
							<option value="">전체</option>
						</select>
					</td>
                    <td class="table_td_subject">카테고리</td>
                    <td class="table_td_contents">
                        <input id="srcMajoCodeName" name="srcMajoCodeName" type="text" value="" size="20" maxlength="30" style="width: 400px;background-color: #eaeaea;" disabled="disabled"/> 
                        <input id="srcCateId" name="srcCateId" type="hidden" value="" readonly="readonly" />
                        <a href="#">
                            <img id="btnSearchCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
                        </a>
                        <a href="#">
                            <img id="btnEraseCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_clear.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
                        </a>
                    </td>
					<td class="table_td_subject" width="100">매출계산서 발행</td>
					<td class="table_td_contents" >
						<select id="srcIsClosSaleDate" name="srcIsClosSaleDate" class="select">
							<option value="">전체</option>
							<option value="Y">발행</option>
							<option value="N">미발행</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="8" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">선입금여부</td>
					<td class="table_td_contents">
						<select id="srcPrepay" name="srcPrepay" class="select">
							<option value="" selected="selected">전체</option>
							<option value="1">예</option>
							<option value="0">아니오</option>
						</select>
					</td>				
					<td class="table_td_subject" width="100">운영관리 여부</td>
					<td class="table_td_contents">
						<select id=srcIsSktManage name="srcIsSktManage" class="select">
							<option value="1" selected="selected">예</option>
							<option value="0">아니오</option>
						</select>
					</td>				
					<td class="table_td_subject" width="100">주문명</td>
					<td class="table_td_contents">
						<input id="srcConsIdenName" name="srcConsIdenName" type="text" value="" size="" maxlength="50" style="width: 100px" />
					</td>				
				</tr>
				<tr>
					<td colspan="8" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr><td height="10" align="left"></td></tr>
	<tr>
        <td align="right" valign="bottom">
            <span id="total_sum_pric"></span>&nbsp;
<%--             <button id='setButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 개인별 항목 설정</button> --%>
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
</table>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>데이터를 선택 하십시오.</p>
</div>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp"%>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/typehead.js" type="text/javascript"></script>
</form>
<%@ include file="/WEB-INF/jsp/common/product/standardCategoryInfo.jsp"%>
</body>
</html>