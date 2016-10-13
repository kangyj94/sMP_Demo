<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>

<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
    boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
    boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;

	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-248 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");

	// 날짜 세팅
	String srcOrderStartDate = CommonUtils.getCustomDay("DAY", -14);
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
	$("#srcOrdeIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });

	$("#allExcelButton").click(function(){ 
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		fnSearchExcelView(); 
	});
	$("#srcButton").click(function(){ 
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		fnSearch(); 
	});
	
	// 날짜 세팅
	$("#srcOrderStartDate").val("<%=srcOrderStartDate%>");
	$("#srcOrderEndDate").val("<%=srcOrderEndDate%>");
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
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/returnOrderRegistJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['주문일자', '납품요청일', '인수일자','주문번호','발주차수','출하차수','배송유형','송장번호','상품명', '규격','good_st_spec_desc','주문수량','입고수량', 'sum_return_request_quan', 'disp_good_id', 'good_iden_numb', 'vendorId', 'deli_type_clas_code'],
		colModel:[
			{name:'regi_date_time',index:'regi_date_time', width:70,align:"center",search:false,sortable:true, editable:false },	//주문유형
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false },	//주문유형
			{name:'purc_proc_date',index:'purc_proc_date', width:70,align:"center",search:false,sortable:true, editable:false },	//주문유형
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"left",search:false,sortable:true, editable:false },	//주문번호
			{name:'purc_iden_numb',index:'purc_iden_numb', width:50,align:"center",search:false,sortable:true, editable:false },	//발주차수
			{name:'deli_iden_numb',index:'deli_iden_numb', width:50,align:"center",search:false,sortable:true, editable:false },	//출하차수
			{name:'deli_type_clas',index:'deli_type_clas', width:50,align:"center",search:false,sortable:true, editable:false },	//배송유형
			{name:'deli_invo_iden',index:'deli_invo_iden', width:70,align:"left",search:false,sortable:true, editable:false },	//송장번호
			{name:'good_name',index:'good_name', width:150,align:"left",search:false,sortable:true, editable:false },	//상품명
			{name:'good_spec_desc',index:'good_spec_desc', hidden:false,search:false,sortable:true, editable:false },	
			{name:'good_st_spec_desc',index:'good_st_spec_desc', hidden:true,search:false,sortable:true, editable:false },	
			{name:'orde_requ_quan',index:'orde_requ_quan', width:50,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },	//주문수량
			{name:'rece_prod_quan',index:'rece_prod_quan', width:50,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },	// 인수수량
			{name:'sum_return_request_quan',index:'sum_return_request_quan', search:false,sortable:false, editable:false, hidden:true },
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false },
			{name:'vendorId',index:'vendorId', hidden:true, search:false,sortable:true, editable:false },
			{name:'deli_type_clas_code',index:'deli_type_clas_code', hidden:true, search:false,sortable:true, editable:false }
		],
		postData: {
			srcOrderStartDate:$('#srcOrderStartDate').val(),
			srcOrderEndDate:$('#srcOrderEndDate').val(),
			srcCenFlag:"true"
		},multiselect: false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname: 'requ_deli_date', sortorder: "desc",
		caption:"수탁입고내역", 
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
        afterInsertRow: function(rowid, aData){
     		jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
     		jq("#list").setCell(rowid,'good_name','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'good_name','',{cursor: 'pointer'});  
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
            if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){            	
         		jq("#list").setCell(rowid,'deli_invo_iden','',{color:'#0000ff'});
         		jq("#list").setCell(rowid,'deli_invo_iden','',{cursor: 'pointer'});  
            }
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.disp_good_id);")%> }
<%}else if(isVendor){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isAdm){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%} %>
			if(colName != undefined &&colName['index']=="deli_invo_iden") { 
				if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){					
					fnSearchDeliPopup(selrowContent.deli_type_clas_code, selrowContent.deli_invo_iden);
				}
			}
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
	data.srcOrdeIdenNumb = $("#srcOrdeIdenNumb").val();
	data.srcOrderStartDate = $("#srcOrderStartDate").val();
	data.srcOrderEndDate = $("#srcOrderEndDate").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['주문일자', '납품요청일', '인수일자','주문번호','발주차수','출하차수','배송유형','송장번호','상품명', '규격','주문수량','입고수량'];
	var colIds = ['regi_date_time', 'requ_deli_date', 'purc_proc_date', 'orde_iden_numb', 'purc_iden_numb', 'deli_iden_numb', 'deli_type_clas', 'deli_invo_iden', 'good_name', 'good_spec_desc', 'orde_requ_quan', 'rece_prod_quan'];
	var numColIds = ['deli_invo_iden','orde_requ_quan','rece_prod_quan'];	//숫자표현ID
	var sheetTitle = "인수내역";	//sheet 타이틀
	var excelFileName = "returnOrderRegist";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function fnSearchExcelView(){
	var colLabels = ['주문일자', '납품요청일', '인수일자','주문번호','발주차수','출하차수','배송유형','송장번호','상품명', '규격','주문수량','입고수량'];
	var colIds = ['REGI_DATE_TIME', 'REQU_DELI_DATE', 'PURC_PROC_DATE', 'ORDE_IDEN_NUMB', 'PURC_IDEN_NUMB', 'DELI_IDEN_NUMB', 'DELI_TYPE_CLAS', 'DELI_INVO_IDEN', 'GOOD_NAME', 'GOOD_SPEC_DESC', 'ORDE_REQU_QUAN', 'RECE_PROD_QUAN'];
	var numColIds = ['DELI_INVO_IDEN','ORDE_REQU_QUAN','RECE_PROD_QUAN'];	//숫자표현id
	var sheetTitle = "물류센터 인수내역";	//sheet 타이틀
	var excelFileName = "cenReturnOrderRegist";	//file명
	
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcOrdeIdenNumb';
    fieldSearchParamArray[1] = 'srcOrderStartDate';
    fieldSearchParamArray[2] = 'srcOrderEndDate';
    fieldSearchParamArray[3] = 'srcCenFlag';
   
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/returnOrder/returnOrderRegistExcelView.sys");  
}
//택배사 조회
function fnSearchDeliPopup(deli_type_clas_code, deli_invo_iden){
	var deliWebAddr = "";
	var order_deli_type_code = deli_type_clas_code;
	var paramString = "";
	var chkCnt = 0;
    $.post( 
        '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/delivery/getDeliVendor.sys',
        {deli_type_clas:order_deli_type_code},
        function(arg){
            var codeList= eval('(' + arg + ')').codeList;
            for(var i=0;i<codeList.length;i++) {
            	if(codeList[i].codeVal1 == order_deli_type_code){
            		deliWebAddr = codeList[i].codeVal2;
            		if(order_deli_type_code == "DAESIN"){
            			paramString += "?billno1="+deli_invo_iden.substring(0, 4)+"&billno2="+deli_invo_iden.substring(4, 7)+"&billno3="+deli_invo_iden.substring(7, 13);
            		}else if(order_deli_type_code == "HANIPS"){
            			paramString += "&hawb_no="+deli_invo_iden;
            		}else if(order_deli_type_code == "DHL"){
            			paramString += "&slipno="+deli_invo_iden;
            		}else{
            			paramString = deli_invo_iden;
            		}
            		deliWebAddr += paramString;
                	var scrSizeHeight = 0;
                	scrSizeHeight = screen.height;
                	window.open(deliWebAddr,'택배사조회', 'width=700, height='+scrSizeHeight+"resizable=yes,menubar=no,status=no,scrollbars=yes");
                	chkCnt++;
            	}
            }   
            if(chkCnt == 0){
            	alert("일치하는 택배사가 없습니다.");
            }
        }
	);
}
</script>
</head>
<body>
<form id="frm" name="frm">
<input type="hidden" id="srcCenFlag" name="srcCenFlag" value="true"/>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td height="29" class='ptitle'>수탁입고내역</td>
						<td align="right" class='ptitle'>
                            <img id="allExcelButton" src="/img/system/btn_type3_orderResultExcel.gif" width="130" height="22" style="cursor:pointer;vertical-align:middle;'"/>
							<img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22"  style='border: 0;cursor: pointer;vertical-align:middle;'/>
						</td>
					</tr>
				</table> <!-- 타이틀 끝 -->
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
						<td class="table_td_subject">주문번호</td>
						<td class="table_td_contents"><input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="20" maxlength="30" /></td>
						<td class="table_td_subject">상품명</td>
						<td class="table_td_contents"><input id="srcGoodsNm" name="srcOrdeIdenNumb" type="text" value="" size="20" maxlength="30" /></td>
						<td class="table_td_subject">주문번호</td>
						<td class="table_td_contents"><input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="20" maxlength="30" /></td>
                    </tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject">인수일</td>
						<td class="table_td_contents" colspan="5">
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
				<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
				<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
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
	<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
		<p>처리할 데이터를 선택 하십시오!</p>
	</div>
</form>
</body>
</html>