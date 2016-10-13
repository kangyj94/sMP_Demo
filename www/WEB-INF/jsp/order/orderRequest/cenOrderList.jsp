<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="java.util.List"%>

<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isCen = (Boolean)request.getAttribute("isCen") == null ? false : true;

	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-245 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<CodesDto> codeList = (List<CodesDto>)request.getAttribute("codeList");
	
	// 날짜 세팅
	String srcOrderStartDate = CommonUtils.getCustomDay("DAY", -7);
	String srcOrderEndDate = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcOrderNumber").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcGoodsName").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
    $("#allExcelButton").click(function(){ 
		$("#srcOrderNumber").val($.trim($("#srcOrderNumber").val()));
		$("#srcGoodsName").val($.trim($("#srcGoodsName").val()));
		$("#srcOrderStatusFlag").val($.trim($("#srcOrderStatusFlag").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
    	fnAllExcelPrintDown();
    });
	$("#srcButton").click(function(){ 
		$("#srcOrderNumber").val($.trim($("#srcOrderNumber").val()));
		$("#srcGoodsName").val($.trim($("#srcGoodsName").val()));
		$("#srcOrderStatusFlag").val($.trim($("#srcOrderStatusFlag").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		fnSearch(); 
	});
	
	// 날짜 세팅
	$("#srcOrderStartDate").val("<%=srcOrderStartDate%>");
	$("#srcOrderEndDate").val("<%=srcOrderEndDate%>");
});

// 날짜 조회 및 스타일
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

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['주문번호', '주문일자', '주문상태', '상품명','규격','good_spec_temp','판매단가', '수량', '판매금액', '납품요청일', 'disp_good_id', 'good_iden_numb', 'vendorid'],
		colModel:[
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"left",search:false,sortable:true, editable:false,key:true},//주문번호
			{name:'regi_date_time',index:'regi_date_time', width:90,align:"center",search:false,sortable:true, editable:false, editable:false,sorttype:"date", editable:false,formatter:"date"},//주문일자
			{name:'order_status_flag',index:'order_status_flag', width:150,align:"left",search:false,sortable:true, editable:false },//주문상태
			{name:'good_iden_name',index:'good_iden_name', width:160,align:"left",search:false,sortable:true, editable:false },//상품명
            {name:'good_spec_desc',index:'good_spec_desc', width:140,align:"left",search:false,sortable:true, editable:false },//상품규격
            {name:'good_st_spec_desc',index:'good_st_spec_desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true },//표준규격
			{name:'sell_price',index:'sell_price', width:90,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매단가
			{name:'orde_requ_quan',index:'orde_requ_quan', width:90,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//수량
			{name:'total_sell_price',index:'total_sell_price', width:90,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매금액
			{name:'requ_deli_date',index:'requ_deli_date', width:90,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false },
			{name:'vendorid',index:'vendorid', hidden:true, search:false,sortable:true, editable:false}
		],
		postData: {
			srcGroupId:$("#srcGroupId").val(),
			srcClientId:$("#srcClientId").val(),
			srcBranchId:$("#srcBranchId").val(),
			srcOrderUserId:$("#srcOrderUserId").val(),
			srcOrderStartDate:$('#srcOrderStartDate').val(),
			srcOrderEndDate:$('#srcOrderEndDate').val()
<%if(isCen){ %>
			,srcIsCen:"수탁발주"
<%} %>			
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname: 'regi_date_time', sortorder: "desc",
		caption:"주문조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	
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
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
			if(colName != undefined &&colName['index']=="good_iden_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.disp_good_id);")%> }
<%}else{%>
			if(colName != undefined &&colName['index']=="good_iden_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%} %>
		},
        afterInsertRow: function(rowid, aData){
     		jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
     		jq("#list").setCell(rowid,'good_iden_name','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'good_iden_name','',{cursor: 'pointer'});  
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/*
 * 리스트 조회
 */
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcOrderNumber = $("#srcOrderNumber").val();
	data.srcGoodsName = $("#srcGoodsName").val();
	data.srcOrderStatusFlag = $("#srcOrderStatusFlag").val();
	data.srcOrderStartDate = $("#srcOrderStartDate").val();
	data.srcOrderEndDate = $("#srcOrderEndDate").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/*
 * 엑셀 출력
 */
function exportExcel() {
	var colLabels = ['주문번호', '주문일자', '주문상태', '상품명','규격','판매단가', '수량', '판매금액', '납품요청일'];
	var colIds = ['orde_iden_numb', 'regi_date_time', 'order_status_flag', 'good_iden_name', 'good_spec_desc', 'sell_price', 'orde_requ_quan', 'total_sell_price', 'requ_deli_date' ];
	var numColIds = ['sell_price','orde_requ_quan','total_sell_price','sale_unit_pric','total_sale_price'];	//숫자표현ID
	var sheetTitle = "수탁발주 주문조회";	//sheet 타이틀
	var excelFileName = "cenOrderList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function fnAllExcelPrintDown(){
	var colLabels = ['주문번호', '주문일자', '주문상태', '상품명','규격','판매단가', '수량', '판매금액', '납품요청일'];
	var colIds = ['ORDE_IDEN_NUMB', 'REGI_DATE_TIME', 'ORDER_STATUS_FLAG', 'GOOD_IDEN_NAME', 'GOOD_SPEC_DESC', 'SELL_PRICE', 'ORDE_REQU_QUAN', 'TOTAL_SELL_PRICE', 'REQU_DELI_DATE' ];
	var numColIds = ['SELL_PRICE','ORDE_REQU_QUAN','TOTAL_SELL_PRICE','SALE_UNIT_PRIC','TOTAL_SALE_PRICE'];	//숫자표현id
	var sheetTitle = "수탁발주 주문조회";	//sheet 타이틀
	var excelFileName = "cenOrderList";	//file명
	
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcOrderNumber';
    fieldSearchParamArray[1] = 'srcGoodsName';
    fieldSearchParamArray[2] = 'srcOrderStatusFlag';
    fieldSearchParamArray[3] = 'srcOrderStartDate';
    fieldSearchParamArray[4] = 'srcOrderEndDate';
    fieldSearchParamArray[5] = 'srcIsCen';
    
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/orderRequest/orderListExcel.sys");  
}

// 상태 변경시 자동 조회
function changeOrderStatusFlag(){
	$("#srcButton").click();
}
</script>
</head>
<body>
   <form id="frm" name="frm">
   <input type="hidden" id="srcIsCen" name="srcIsCen" value="수탁발주"/>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
                     </td>
                     <td height="29" class='ptitle'>수탁발주 주문내역</td>
                     <td align="right" class='ptitle'>
                        <img id="allExcelButton" src="/img/system/btn_type3_orderResultExcel.gif" width="130" height="22" style="cursor:pointer;"/>
                        <img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22" />
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <!-- 컨텐츠 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">주문번호</td>
                     <td class="table_td_contents">
                        <input id="srcOrderNumber" name="srcOrderNumber" type="text" value="" size="" maxlength="50" style="width: 100px" />
                     </td>
                     <td class="table_td_subject" width="100">주문상태</td>
                     <td class="table_td_contents">
                        <select id="srcOrderStatusFlag" name="srcOrderStatusFlag" class="select" onchange="javascript:changeOrderStatusFlag();" >
                           <option value="">전체</option>
<% 	
	if (codeList.size() > 0 ) {
		CodesDto cdData = null;
		for (int i = 0; i < codeList.size(); i++) {
			cdData = codeList.get(i); 
%>
                           <option value="<%=cdData.getCodeNm1()%>"><%=cdData.getCodeNm1()%></option>
<% } }else{%>
                           <option value="주문요청" selected="selected">주문요청</option>
<% }%>
                        </select>
                     </td>
                     <td class="table_td_subject" width="100">상품명</td>
                     <td class="table_td_contents">
                        <input id="srcGoodsName" name="srcGoodsName" type="text" value="" size="" maxlength="50" style="width: 100px" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">주문일</td>
                     <td class="table_td_contents">
                        <input type="text" name="srcOrderStartDate" id="srcOrderStartDate" style="width: 75px;vertical-align: middle;" /> 
                        ~ 
                        <input type="text" name="srcOrderEndDate" id="srcOrderEndDate" style="width: 75px;vertical-align: middle;" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
               </table>
               <!-- 컨텐츠 끝 -->
            </td>
         </tr>
         <tr><td height="10"></td></tr>
         <tr>
            <td align="right">
               <a href="#"> <img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> </a>
               <a href="#"> <img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> </a>
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
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>데이터를 선택 하십시오.</p>
      </div>
   </form>
</body>
</html>