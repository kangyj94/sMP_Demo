<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="java.util.List"%>
<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-330 + Number(gridHeightResizePlus)";
	String listHeight2 = "($(window).height()-460 + Number(gridHeightResizePlus))/2";
//  	String listWidth = "$(window).width()-50 + Number(gridWidthResizePlus)";
 	String listWidth = "970";
	
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#productHistoryStartDate").val('<%=CommonUtils.getCustomDay("DAY", -1)%>');
	$("#productHistoryEndDate").val('<%=CommonUtils.getCustomDay("DAY", 0)%>');
	$("#srcButton").click(function(){ fnSearch(); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#allExcelButton").click(function(){ exportExcelToSvc(); });
	productMcgoodSearchList();
	mcgoodHistList();
	mcgoodVendorHistList();
});

//리사이징
$(window).bind('resize', function() { 
	$("#list1").setGridHeight(<%=listHeight %>);
	$("#list2").setGridHeight(<%=listHeight2 %>);
    $("#list2").setGridWidth(<%=listWidth %>);
	$("#list3").setGridHeight(<%=listHeight2 %>);
    $("#list3").setGridWidth(<%=listWidth %>);
}).trigger('resize');  
</script>
<script type="text/javascript">
function productMcgoodSearchList() {
	jq("#list1").jqGrid({
		url:'/product/selectProductMcgoodSearchList/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['유형','상품코드','상품명','규격','이미지','smallImgPath'],
		colModel:[
            {name:'cate_Id',width:40,align:'center'},//유형
			{name:'good_Iden_Numb',index:'good_Iden_Numb', width:75, align:"center",search:false},//상품코드
			{name:'good_Name',index:'good_Name', width:135,search:false},//상품명
			{name:'good_Spec_Desc',index:'good_Spec_Desc', width:140,search:false},//상품규격
			{name:'goodImg',index:'goodImg', width:37, align:"center",search:false},//이미지
			{name:'small_Img_Path',index:'small_Img_Path', width:80, align:"center",search:false, hidden:true}//이미지경로
		],
		postData: {
			goodIdenNumb:$("#goodIdenNumb").val(),
			goodName:$("#goodName").val(),
			productHistoryStartDate:$("#productHistoryStartDate").val(),
			productHistoryEndDate:$("#productHistoryEndDate").val()
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager1',
		height: <%=listHeight%>,width: 500,
		sortname: '', sortorder: "",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list1").getGridParam('reccount');
			
			if(rowCnt>0) {
				var top_rowid = $("#list1").getDataIDs()[0];
                $(this).setSelection(top_rowid);
				
				//상품규격, 이미지 세팅
				for(var i=0; i<rowCnt; i++){
					var rowId = $("#list1").getDataIDs()[i];
					var selrowContent = jq("#list1").jqGrid('getRowData',rowId);
					var imgTag = "";
					if($.trim(selrowContent.small_Img_Path) != ''){
						imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_Img_Path+"' style='width:35px;height:35px;' />";
					}else{
						imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />";
					}
					jq('#list1').jqGrid('setRowData',rowId,{goodImg:imgTag});
				}
 			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContents = jq("#list1").jqGrid('getRowData',rowid);
			fnSearch2(selrowContents.good_Iden_Numb);
			fnSearch3(selrowContents.good_Iden_Numb);
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list1").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		rownumbers:true
	})
    .jqGrid("setLabel", "rn", "순번");
}

var staticNum = 0;
function mcgoodHistList(goodIdenNumb) {
	jq("#list2").jqGrid({
		url:'/product/selectMcgoodHistList/list.sys',
		datatype: 'local',
		mtype: 'POST',
		colNames:['수정일시','상품명','상품카테고리','실적년월','신규사업','상품규격','과세구분','담당자','주문단위','상품구분','공급사노출','물량배분','재고관리','SKTS이미지관리','추가구성','변경자명'],
		colModel:[
            {name:'INSERT_DATE',width:140,align:'center',sortable:false},
            {name:'GOOD_NAME',width:160,sortable:false},
            {name:'CATE_NM',width:160,sortable:false},
            {name:'GOOD_REG_YEAR',width:50,align:'center',sortable:false},
            {name:'NEW_BUSI',width:50,align:'center',sortable:false},
            {name:'GOOD_SPEC',width:120,sortable:false},
            {name:'VTAX_CLAS_CODE',width:60,align:'center',sortable:false},
            {name:'PRODUCT_MANAGER',width:60,align:'center',sortable:false},
            {name:'ORDER_UNIT',width:60,align:'center',sortable:false},
            {name:'GOOD_TYPE',width:60,align:'center',sortable:false},
            {name:'VENDOR_EXPOSE',width:50,align:'center',sortable:false},
            {name:'ISDISTRIBUTE',width:60,align:'center',sortable:false},
            {name:'STOCK_MNGT',width:50,align:'center',sortable:false},
            {name:'SKTS_IMG',width:50,align:'center',sortable:false},
            {name:'ADD_GOOD',width:50,align:'center',sortable:false},
            {name:'INSERT_USER_NM',width:50,align:'center',sortable:false}
		],
		postData: {
			productHistoryStartDate:$("#productHistoryStartDate").val(),
			productHistoryEndDate:$("#productHistoryEndDate").val(),
			goodIdenNumb:goodIdenNumb
		},
		rowNum:10, rownumbers: false, rowList:[10,30,100], pager: '#pager2',
		height: <%=listHeight2%>, width: <%=listWidth%>,
		sortname: "A.INSERT_DATE", sortorder: "DESC",
		caption:"기본상품변경정보",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list2").getGridParam('reccount');
			if(rowCnt>0) {
                var top_rowid = $("#list2").getDataIDs()[0];
                var selrowContent = jq("#list2").jqGrid('getRowData',top_rowid);
				jq("#list2").jqGrid('setRowData', top_rowid, {INSERT_DATE:"현재 ("+selrowContent.INSERT_DATE+")"});
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		rownumbers:true
	})
    .jqGrid("setLabel", "rn", "순번");
}

function mcgoodVendorHistList(goodIdenNumb) {
	jq("#list3").jqGrid({
		url:'/product/selectMcgoodVendorHistList/list.sys',
		datatype: 'local',
		mtype: 'POST',
        colNames:['수정일시','공급사','진열순서','판매가','매입가','최소주문수량','재고','납품소요일','물량배분율','제조사'],
        colModel:[
            {name:'REGIST_DATE',width:140,align:'center',sortable:false},
            {name:'VENDORNM',width:160,sortable:false},
            {name:'VENDOR_PRIORITY',width:50,align:'center',sortable:false},
            {name:'SELL_PRICE',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매가
            {name:'SALE_UNIT_PRIC',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입가
            {name:'DELI_MINI_QUAN',width:65,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//최소주문수량
            {name:'GOOD_INVENTORY_CNT',width:40,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//재고량
            {name:'DELI_MINI_DAY',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//납품소요일
            {name:'DISTRI_RATE',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//물량배분율
            {name:'MAKE_COMP_NAME',width:80,sortable:false}
		],
		postData: {
			registStartDate:$("#productHistoryStartDate").val(),
			registEndDate:$("#productHistoryEndDate").val(),
			goodIdenNumb:goodIdenNumb
		},
		rowNum:10, rownumbers: false, rowList:[10,30,100], pager: '#pager3',
		height: <%=listHeight2%>, width: <%=listWidth%>,
		sortname: "A.REGIST_DATE", sortorder: "DESC",
		caption:"공급사별 변경정보",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list3").getGridParam('reccount');
            if(rowCnt>0) {
                var top_rowid = $("#list3").getDataIDs()[0];
                var selrowContent = jq("#list3").jqGrid('getRowData',top_rowid);
                jq("#list3").jqGrid('setRowData', top_rowid, {REGIST_DATE:"현재 ("+selrowContent.REGIST_DATE+")"});
            }
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list3").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		rownumbers:true
	})
    .jqGrid("setLabel", "rn", "순번");
}

//검색펑션
function fnSearch() {
	var data = jq("#list1").jqGrid("getGridParam", "postData");
	data.division = $("#division").val();
	data.goodIdenNumb = $("#goodIdenNumb").val();
	data.goodName = $("#goodName").val();
	data.productHistoryStartDate = $("#productHistoryStartDate").val();
	data.productHistoryEndDate = $("#productHistoryEndDate").val();
	jq("#list1").jqGrid("setGridParam", { "postData":data});
	jq("#list1").trigger("reloadGrid");
}

function fnSearch2(goodIdenNumb) {
	var data2 = jq("#list2").jqGrid("getGridParam", "postData");
	data2.goodIdenNumb = goodIdenNumb;
	data2.productHistoryStartDate = $("#productHistoryStartDate").val();
	data2.productHistoryEndDate = $("#productHistoryEndDate").val();
	jq("#list2").jqGrid("setGridParam", {datatype:'json', "postData":data2});
	jq("#list2").trigger("reloadGrid");
}

function fnSearch3(goodIdenNumb){
	var data3 = jq("#list3").jqGrid("getGridParam", "postData");
	data3.goodIdenNumb = goodIdenNumb;
	data3.registStartDate = $("#productHistoryStartDate").val();
	data3.registEndDate = $("#productHistoryEndDate").val();
	jq("#list3").jqGrid("setGridParam", {datatype:'json', "postData":data3});
	jq("#list3").trigger("reloadGrid");
}

//엑셀 출력
function exportExcel() {
	var colLabels = ['고객사','사업자등록번호','법인명','사업장명','특별계약','사용자ID','사용자명','계약 VER','변경 계약일'];//출력컬럼명
	var colIds = ['contractClassify','businessNum','borgNm','branchNm','contractSpecial','userId','userNm','contractVersion','contractDate'];	//출력컬럼ID
	var numColIds = ['businessNum'];	//숫자표현ID
	var sheetTitle = "물품공급계약서 서명내역";	//sheet 타이틀
	var excelFileName = "systemContarctList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['고객사','사업자등록번호','법인명','사업장명','특별계약','사용자ID','사용자명','계약 VER','변경 계약일'];//출력컬럼명
	var colIds = ['contractClassify','businessNum','borgNm','branchNm','contractSpecial','userId','userNm','contractVersion','contractDate'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//숫자표현ID
	var sheetTitle = "물품공급계약서 서명내역";	//sheet 타이틀
	var excelFileName = "systemAllContarctList";	//file명
	
	var actionUrl = "/system/systemContractListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcContractVersion';

	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}


$(function(){
	$("#productHistoryStartDate").datepicker(
		{
			showOn: "button",
			buttonImage: "/img/system/btn_icon_calendar.gif",
			buttonImageOnly: true,
			dateFormat: "yy-mm-dd"
		}
	);
// 	$("#productHistoryEndDate").datepicker(
// 		{
// 			showOn: "button",
// 			buttonImage: "/img/system/btn_icon_calendar.gif",
// 			buttonImageOnly: true,
// 			dateFormat: "yy-mm-dd"
// 		}
// 	);
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});


</script>
<title>Insert title here</title>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
	<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!--타이틀 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td height="29" class='ptitle'>상품 변경이력</td>
						<td align="right" class="ptitle" >
                            <button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
						</td>
					</tr>
				</table>
				<!--타이틀 끝 -->
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
						<td class="table_td_subject" width="100">상품코드</td>
						<td class="table_td_contents">
							<input type="text" id="goodIdenNumb" name="goodIdenNumb" value=""/>
						</td>
						<td class="table_td_subject" width="100">상품명</td>
						<td class="table_td_contents">
							<input type="text" id="goodName" name="goodName" value=""/>
						</td>
						<td class="table_td_subject" width="100">수정기간</td>
						<td class="table_td_contents">
							<input type="text" name="productHistoryStartDate" id="productHistoryStartDate" style="width: 75px; vertical-align: middle;" />
							~
							<input type="text" name="productHistoryEndDate" id="productHistoryEndDate" style="width: 75px; vertical-align: middle;" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" height="1" bgcolor="eaeaea"></td>
					</tr>
<!-- 					<tr> -->
<!-- 						<td class="table_td_subject" width="100">구분</td> -->
<!-- 						<td class="table_td_contents"> -->
<!-- 							<select id="division" name="division" class="select"> -->
<!-- 								<option value="">전체</option> -->
<!-- 								<option value="1">신규</option> -->
<!-- 								<option value="2">종료</option> -->
<!-- 								<option value="3">변경</option> -->
<!-- 							</select> -->
<!-- 						</td> -->
<!-- 						<td class="table_td_subject" width="100">변경자명</td> -->
<!-- 						<td class="table_td_contents"> -->
<!-- 							<select class="select"> -->
<!-- 							</select> -->
<!-- 						</td> -->
<!-- 						<td class="table_td_subject" width="100">공급사</td> -->
<!-- 						<td class="table_td_contents"> -->
							
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td valign="top" width="500" rowspan="5">
							<!-- 상품조회 시작 -->
							<div id="jqgrid">
								<table id="list1"></table>
								<div id="pager1"></div>
							</div>
							<!-- 상품조회 끝 -->
						</td>
						<td rowspan="5">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						<!-- 기본상품변경정보 시작 -->
						<td valign="top">
							<div id="jqgrid">
								<table id="list2"></table>
								<div id="pager2"></div>
							</div>
						</td>
						<!-- 기본상품변경정보 끝 -->
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<!-- 공급사별정보 시작 -->
					<tr>
						<td valign="top">
							<div id="jqgrid">
								<table id="list3"></table>
								<div id="pager3"></div>
							</div>
						</td>
					
					</tr>
					<!-- 공급사별정보 끝 -->
				</table>
			</td>
		</tr>
	</table>
</body>
</html>