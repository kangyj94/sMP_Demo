<%@page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isBuilder = false;
	boolean isClient = false;
	for(LoginRoleDto lrd: loginUserDto.getLoginRoleList()){
		if("BUY_BUILDER".equals(lrd.getRoleCd())){
			isBuilder = true;
		}
		//법인담당자
		if("BUY_CLT".equals(lrd.getRoleCd())){
			isClient = true;
		}
	}
	String height_plus = "+27";
	String srcStartDate = CommonUtils.getCustomDay("MONTH",-1);
	String srcEndDate = CommonUtils.getCurrentDate();
	
	String clientPoAmount = request.getAttribute("clientPoAmount")==null ? "0" : (String)request.getAttribute("clientPoAmount");
	String clientNoneReceiveAmount = request.getAttribute("clientNoneReceiveAmount")==null ? "0" : (String)request.getAttribute("clientNoneReceiveAmount");
	String clientReceiveAmount = request.getAttribute("clientReceiveAmount")==null ? "0" : (String)request.getAttribute("clientReceiveAmount");
	String branchPoAmount = request.getAttribute("branchPoAmount")==null ? "0" : (String)request.getAttribute("branchPoAmount");
	String branchNoneReceiveAmount = request.getAttribute("branchNoneReceiveAmount")==null ? "0" : (String)request.getAttribute("branchNoneReceiveAmount");
	String branchReceiveAmount = request.getAttribute("branchReceiveAmount")==null ? "0" : (String)request.getAttribute("branchReceiveAmount");
	
	String getDate = CommonUtils.getCurrentDate();
%>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function(){
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/common/buyOrderAtmosphericList.sys",
		{
			srcStartDate:'<%=srcStartDate %>', srcEndDate:'<%=srcEndDate %>'
		},
		function(arg){ 
			var cartCnt = eval('(' + arg + ')').cartCnt;
			var orderReadyCnt = eval('(' + arg + ')').orderReadyCnt;
<%if(!loginUserDto.isDirectMan()){ %>
			var orderApprovalReadyCnt = eval('(' + arg + ')').orderApprovalReadyCnt;
<%}%>
			var orderReceiveCnt = eval('(' + arg + ')').orderReceiveCnt;
			var deliveryReadyCnt = eval('(' + arg + ')').deliveryReadyCnt;
			var receiveReadyCnt = eval('(' + arg + ')').receiveReadyCnt;
			var receiveCnt = eval('(' + arg + ')').receiveCnt;
			var backRequestCnt = eval('(' + arg + ')').backRequestCnt;
			var backApprovalCnt = eval('(' + arg + ')').backApprovalCnt;
			var backRejectCnt = eval('(' + arg + ')').backRejectCnt;
			$("#cartCnt").html(cartCnt);
<%if(!loginUserDto.isDirectMan()){ %>
			$("#orderApprovalReadyCnt").html(orderApprovalReadyCnt);
<%}%>
			$("#orderReadyCnt").html(orderReadyCnt);
			$("#orderReceiveCnt").html(orderReceiveCnt);
			$("#deliveryReadyCnt").html(deliveryReadyCnt);
			$("#receiveReadyCnt").html(receiveReadyCnt);
			$("#receiveCnt").html(receiveCnt);
			$("#backRequestCnt").html(backRequestCnt);
			$("#backApprovalCnt").html(backApprovalCnt);
			$("#backRejectCnt").html(backRejectCnt);
		}
	);

});
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list1").jqGrid({
		url:'/common/main/managementBranchOrderList/list.sys',
		datatype: 'json',
		mtype: 'POST',
	 	colNames:['구분', '내용', '구분2'],
		colModel:[
			{name:'FLAG',index:'FLAG', width:180,align:"center",search:false,sortable:true,editable:false},					//구분
			{name:'CONTENT',index:'CONTENT', width:220,align:"right",search:false,sortable:true,editable:false},				//내용
			{name:'FLAG2',index:'FLAG2', width:180,align:"center",search:false,sortable:true,editable:false, hidden:true}		//구분2
		],
		postData: {
			branchId:"<%=loginUserDto.getBorgId()%>"
		},
		height:180 ,width: 455, rowNum: 0,
		rownumbers: true,
		caption:"사업장 현황", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $("#list1").getGridParam('reccount');
			for(var i=0; i<rowCnt; i++){
				var rowid = $("#list1").getDataIDs()[i];
				var selrowContent = $("#list1").jqGrid('getRowData',rowid);
				if(selrowContent.FLAG2 == 'TO_DAY_ORDE_AMOU' || selrowContent.FLAG2 == 'TO_MONTH_ORDE_AMOU' || selrowContent.FLAG2 == 'TO_YEAR_ORDE_AMOU' || selrowContent.FLAG2 == 'BALACE_AMOU'){
					$("#list1").jqGrid('setRowData', rowid, {CONTENT:fnComma(selrowContent.CONTENT)});
				}
				//메뉴이동 처리
				jq("#list1").setCell(rowid,'CONTENT','',{color:'#0000ff'});
				jq("#list1").setCell(rowid,'CONTENT','',{cursor: 'pointer'});
			}
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = jq("#list1").jqGrid('getRowData',rowid);
			var cm = jq("#list1").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined && colName['index']=="CONTENT") {
				if(selrowContent.FLAG2=="TO_DAY_ORDE_AMOU"){
					menuTransfer('BUY_ORDER_RESULT', '<%=getDate%>', '<%=getDate%>','1','');//구매이력조회 - 날짜 : (당일)
				}else if(selrowContent.FLAG2=="TO_MONTH_ORDE_AMOU"){
					var startDate =	"<%=CommonUtils.getCustomDay("MONTH", -1)%>";
					startDate = startDate.substring(startDate,'8','8')+'01';
					menuTransfer('BUY_ORDER_RESULT', startDate, '<%=getDate%>','1','');//구매이력조회 - 날짜 : (당월)
				}else if(selrowContent.FLAG2=="TO_YEAR_ORDE_AMOU"){
					var startDate =	"<%=CommonUtils.getCustomDay("YEAR", -1)%>";
					menuTransfer('BUY_ORDER_RESULT', startDate, '<%=getDate%>','1','');//구매이력조회 - 날짜 : (금년)
				}else if(selrowContent.FLAG2=="BALACE_AMOU"){
					menuTransfer('BUY_BONDS_OCCURRENCE', '', '','','');//채무관리
				}else if(selrowContent.FLAG2=="NEWGOOD_REQ_CNT"){
					var startDate =	"<%=CommonUtils.getCustomDay("YEAR", -1)%>";
					menuTransfer('BUY_NEWPROD_HIST', startDate, '<%=getDate%>','1','');//상품등록요청 - 요청자:(전체), 요청일자:(최근1년)
				}else if(selrowContent.FLAG2=="MRBORG_USER_CNT"){
					menuTransfer('BUY_MY_INTER', '', '','','');//관심상품
				}else if(selrowContent.FLAG2=="SMPNEW_MATER_CNT"){
					menuTransfer('BUY_SUGGEST', '', '','','');//신규자재제안
				}
				
			}
		},
		afterInsertRow:function(rowid, aData) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list1").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
});
</script>


<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list2").jqGrid({
		url:'/common/main/managementReceNotAmouList/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['구분', '법인기준', '사업장 기준','구분2'],
		colModel:[
			{name:'FLAG',index:'FLAG', width:140,align:"center",search:false,sortable:true,editable:false},			//구분
			{name:'CLIENT_AMOU',index:'CLIENT_AMOU', width:130,align:"right",search:false,sortable:true,editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},	//법인기준
			{name:'BRANCH_AMOU',index:'BRANCH_AMOU', width:130,align:"right",search:false,sortable:true,editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},	//사업장기준
			{name:'FLAG2',index:'FLAG2', width:140,align:"center",search:false,sortable:true,editable:false, hidden:true}		//구분2
		],
		postData: {
			clientId:"<%=loginUserDto.getClientId()%>",
			branchId:"<%=loginUserDto.getBorgId()%>"
		},
		height:80 ,width: 455, rowNum: 0,
		rownumbers: true,
		caption:"미정산 현황", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $("#list2").getGridParam('reccount');
			for(var i=0; i<rowCnt; i++){
				var rowid = $("#list2").getDataIDs()[i];
				//메뉴이동 처리
				var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
				if(selrowContent.FLAG2 != 'RECENOT_AMOU'){
					jq("#list2").setCell(rowid,'BRANCH_AMOU','',{color:'#0000ff'});
					jq("#list2").setCell(rowid,'BRANCH_AMOU','',{cursor: 'pointer'});
				}
			}
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
			var cm = jq("#list2").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined && colName['index']=="BRANCH_AMOU") {
				if(selrowContent.FLAG2 == "PURC_AMOU"){
					//구매이력조회 - 시작 날짜 : 2014-01-01 - 
					menuTransfer('BUY_ORDER_RESULT', '2014-01-01', '<%=getDate%>','41','');
				}else if(selrowContent.FLAG2 == "RECE_AMOU"){
					menuTransfer('BUY_ORDER_RESULT', '2014-01-01', '<%=getDate%>','70','');//구매이력조회 - 시작 날짜 : 2014-01-01
				}
			}
		},
		afterInsertRow:function(rowid, aData) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list3").jqGrid({
		url:'/common/main/managementBranchSaleEbillList/list.sys',
		datatype: 'json',
		mtype: 'POST',
	 	colNames:['구분','금액','구분2'],
		colModel:[
			{name:'FLAG',index:'FLAG', width:100,align:"center",search:false,sortable:true,editable:false},			//구분
			{name:'CONTENT',index:'CONTENT', width:180,align:"right",search:false,sortable:true,editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},	//금액
			{name:'VALUE',index:'VALUE', width:100,align:"center",search:false,sortable:true,editable:false, hidden:true}			//구분2
		],
		postData: {
			branchId:"<%=loginUserDto.getBorgId()%>"
		},
		rowNum:0,
		rownumbers:true,
		height:100 ,width: 455, 
		caption:"세금계산서 내역", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $("#list3").getGridParam('reccount');
			for(var i=0; i<rowCnt; i++){
				var rowid = $("#list3").getDataIDs()[i];
// 				var selrowContent = $("#list3").jqGrid('getRowData',rowid);
// 				if(selrowContent.FLAG2 == 'TO_DAY_ORDE_AMOU' || selrowContent.FLAG2 == 'TO_MONTH_ORDE_AMOU' || selrowContent.FLAG2 == 'TO_YEAR_ORDE_AMOU' || selrowContent.FLAG2 == 'BALACE_AMOU'){
// 					$("#list1").jqGrid('setRowData', rowid, {CONTENT:fnComma(selrowContent.CONTENT)});
// 				}
				//메뉴이동 처리
				jq("#list3").setCell(rowid,'CONTENT','',{color:'#0000ff'});
				jq("#list3").setCell(rowid,'CONTENT','',{cursor: 'pointer'});
			}
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = jq("#list3").jqGrid('getRowData',rowid);
			var cm = jq("#list3").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined && colName['index']=="CONTENT") {
				var lastMonth1 = "<%=CommonUtils.getCustomDay("MONTH", -1)%>";
				var lastMonth2 = "<%=CommonUtils.getCustomDay("MONTH", -2)%>";
				var lastMonth3 = "<%=CommonUtils.getCustomDay("MONTH", -3)%>";
				var isClient = <%=isClient%>;
				if(isClient){
					if(selrowContent.VALUE==lastMonth1.substring(0,7)){
						menuTransfer('BUY_EBILL', lastMonth1, '','1','');//구매이력조회 - 날짜 : (전월)
					}else if(selrowContent.VALUE==lastMonth2.substring(0,7)){
						menuTransfer('BUY_EBILL', lastMonth2, '','1','');//구매이력조회 - 날짜 : (전전월)
					}else if(selrowContent.VALUE==lastMonth3.substring(0,7)){
						menuTransfer('BUY_EBILL', lastMonth3, '','1','');//구매이력조회 - 날짜 : (전전전월)
					}
				}else{
					alert("법인 담당자 권한만 확인이 가능합니다.");
				}
			}
		},
		afterInsertRow:function(rowid, aData) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list3").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list4").jqGrid({
		url:'/board/noticeListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['board_No','번호', '제목', '등록일'],
		colModel:[
			{name:'board_No',index:'board_No', width:50,align:"center",search:false,sortable:true,
				editable:false, key:true, editrules:{required:true}, hidden:true
			},	//번호 시퀀스
			{name:'num',index:'num', width:50,align:"center",search:false,sortable:true,editable:false},	//로우넘번호
			{name:'title',index:'title', width:270,align:"left",search:false,sortable:true,editable:false},	//제목
			{name:'regi_Date_Time',index:'regi_Date_Time', width:110,align:"center",search:false,sortable:true,editable:false}// 등록일
		],
		postData: {
			
		},
		rowNum:10, rowList:[10,30,50], pager: '#pager4',
		sortname: 'board_No', sortorder: "desc",
		height:230 ,width: 455, 
		caption:"공지사항", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $("#list4").getGridParam('reccount');
			for(var i=0; i<rowCnt; i++){
				var rowid = $("#list4").getDataIDs()[i];
				jq("#list4").setCell(rowid,'num','',{color:'#0000ff'});
				jq("#list4").setCell(rowid,'num','',{cursor: 'pointer'});
			}
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list4").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined && colName['index']=="num") {
				viewRow(rowid);
			}
		},
		afterInsertRow:function(rowid, aData) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list4").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
});
</script>


<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list5").jqGrid({
		url:'/common/main/managementBranchProductTop10List/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['상품명', '상품규격', '상품규격2', '금액(원)'],
		colModel:[
			{name:'GOOD_NAME',index:'GOOD_NAME', width:150,align:"center",search:false,sortable:true,editable:false},	//상품명
			{name:'GOOD_SPEC_DESC',index:'GOOD_SPEC_DESC', width:150,align:"center",search:false,sortable:true,editable:false},	//상품규격1
			{name:'GOOD_ST_SPEC_DESC',index:'GOOD_ST_SPEC_DESC', width:90,align:"left",search:false,sortable:true,editable:false, hidden:true},	//상품규격2
			{name:'SALE_PROD_AMOU',index:'SALE_PROD_AMOU', width:100,align:"right",search:false,sortable:false, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			}//금액(원)
		],
		postData: {
			branchId:"<%=loginUserDto.getBorgId()%>"
		},
		height:230 ,width: 455, rowNum: 0,
		rownumbers: true,
		caption:"매입상품 TOP10", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			// 품목 표준 규격 설정
			var prodStSpcNm = new Array();
			<% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
				prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
			<% } %>
			// 품목 규격 설정 
			var prodSpcNm = new Array();
			<% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
				prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
			<% }%>
			var rowCnt = $("#list5").getGridParam('reccount');
			if(rowCnt > 0){
				for(var idx=0; idx<rowCnt; idx++){
					var rowid = $("#list5").getDataIDs()[idx];
					var selrowContent = $("#list5").jqGrid('getRowData',rowid);
					// 규격 화면 로드
					var argStArray = selrowContent.GOOD_ST_SPEC_DESC.split("‡");
					var argArray = selrowContent.GOOD_SPEC_DESC.split("‡");
					var prodStSpec = "";
					var prodSpec = "";
					for(var stIdx = 0 ; stIdx < prodStSpcNm.length ; stIdx ++ ) {
						if(argStArray[stIdx] > ' ') {
							prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
						}
					}
					if(prodStSpec.length > 0) {
						prodStSpec = prodStSpec.substring(0,prodStSpec.length-3);
						prodStSpec = "<font color='red'>["+ prodStSpec + "]</font>";
					}
					for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
						if(argArray[jIdx] > ' ') {
							if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
							else           prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
						}
					}
					prodStSpec += prodSpec;
					jQuery('#list5').jqGrid('setRowData',rowid,{GOOD_SPEC_DESC:prodStSpec});
				}
			}
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		afterInsertRow:function(rowid, aData) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list5").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
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
</script>

<script type="text/javascript">
//공급사 매뉴얼 관련
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	//공급사홈
	var header = "Home";
	manualPath = "/img/manual/branch/branchManagement.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
<script type="text/javascript">
function staffPage(){
	location.href="/system/systemDefault.sys?managementFlag=1";
}

//메뉴이동시 사용 펑션
function menuTransfer(menuCd, startDate, endDate, flag1, flag2){
	$.post(
		"/system/menuTransfer.sys",
		{
			menuCd:menuCd
		},
		function(arg){
			var result = eval('('+arg+')');
			var menuInfo = result.menuInfo;
			var menuTransForm = $("#menuTransForm");
			with(menuTransForm) {
				find("input[name=startDate]").val(startDate);
				find("input[name=endDate]").val(endDate);
				find("input[name=flag1]").val(flag1);
				find("input[name=flag2]").val(flag2);
				//운영사의 경우 신규자재 제안에 관련되 권한이 없어서 aspectController에서 메뉴 리스트 만들때 에러발생
				if(menuCd != "ADM_SUGGEST" && menuCd != "BUY_SUGGEST"){
					find("input[name=_menuId]").val(menuInfo.MENUID);
				}
				attr("action", menuInfo.FWDPATH);
				submit();
			}
		}
	);
}

function viewRow(rowid) {
	if(rowid != null ){
		var selrowContent = jq("#list4").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/board/noticeDetail.sys?board_No=" + selrowContent.board_No;
		window.open(popurl, 'okplazaPop', 'width=720, height=500, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
</script>

<script type="text/javascript">
function fnCartCnt(){
	document.frm.action = "/order/cart/cartMstInfo.sys?_menuId=13102";
	document.frm.submit();
}

function fnOrderApprovalReadyCnt(){
	document.frm.action = "/order/orderRequest/orderList.sys?_menuId=13080&srcOrderStatusFlag=05&srcStartDate=<%=srcStartDate%>";
 	document.frm.submit();
}

function fnOrderReadyCnt(){
	document.frm.action = "/order/orderRequest/orderList.sys?_menuId=13080&srcOrderStatusFlag=10&srcStartDate=<%=srcStartDate%>";
 	document.frm.submit();
}

function fnOrderReceiveCnt(){
	document.frm.action = "/order/orderRequest/orderList.sys?_menuId=13080&srcOrderStatusFlag=40&srcStartDate=<%=srcStartDate%>";
	document.frm.submit();
}

function fnDeliveryReadyCnt(){
	document.frm.action = "/order/orderRequest/orderList.sys?_menuId=13080&srcOrderStatusFlag=50&srcStartDate=<%=srcStartDate%>";
	document.frm.submit();
}

function fnReceiveReadyCnt(){
	document.frm.action = "/order/orderRequest/orderList.sys?_menuId=13080&srcOrderStatusFlag=60&srcStartDate=<%=srcStartDate%>";
	document.frm.submit();
}

function fnReceiveCnt(){
	document.frm.action = "/order/orderRequest/orderList.sys?_menuId=13080&srcOrderStatusFlag=70&srcStartDate=<%=srcStartDate%>";
	document.frm.submit();
}

function fnBackRequestCnt(){
	document.frm.action = "/order/returnOrder/returnOrderList.sys?_menuId=13194&srcReturnStatFlag=0&srcStartDate=<%=srcStartDate%>";
	document.frm.submit();
}

function fnBackApprovalCnt(){
	document.frm.action = "/order/returnOrder/returnOrderList.sys?_menuId=13194&srcReturnStatFlag=1&srcStartDate=<%=srcStartDate%>";
	document.frm.submit();
}

function fnBackRejectCnt(){
	document.frm.action = "/order/returnOrder/returnOrderList.sys?_menuId=13194&srcReturnStatFlag=9&srcStartDate=<%=srcStartDate%>";
	document.frm.submit();
}
</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
<form id="frm" name="frm" method="post">
<table border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td valign="top" colspan="5">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>Home
						&nbsp;<span id="question" class="questionButton">도움말</span>
						&nbsp;&nbsp;&nbsp;<img src=/img/homepage/cursor.jpg style="vertical-align: bottom; width: 17px;"/>
						<font style="font-size:15px; font-weight:bold; letter-spacing:-1px; color:#7A7A7A; padding-top:1px; padding:1px 0 0 1px;">경영정보 항목에 대한 정의 및 기준 참고</font>
					</td>
					<td class="ptitle" align="right" valign="top">
						<a>
							<b>경영정보</b>
						</a>
						<b>/</b>
						<a href="javascript:staffPage();">
							<b>운영정보</b>
						</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<!-- 타이틀 -->
			<table width="212" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_01.gif" width="212" height="12"/></td>
				</tr>
				<tr>
					<td width="17" valign="top" style="background-image:url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_02_bg.gif');">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_02.gif" width="17" height="159"/></td>
					<td width="178" bgcolor="f6f6f6">
						<table width="178" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_left_title_bak1.jpg" width="148" height="44"/></td>
							</tr>
							<tr>
								<td height="20" align="center" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_05.gif" class="date">
									<%=srcStartDate %> ~ <%=srcEndDate %>
								</td>
							</tr>
							<tr>
								<td height="4"></td>
							</tr>
							<tr>
								<td height="30">
									<table width="178px" border="0" cellspacing="0" cellpadding="0" style="height: 28px">
										<tr>
											<td width="17"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle3.gif" width="11" height="12"/></td>
											<td width="78" class="bold">장바구니</td>
											<td width="36" align="right">
												<a href="#" onclick="fnCartCnt();" class="top"><span id="cartCnt">0</span></a> 건
											</td>
											<td width="17">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
<%if(!loginUserDto.isDirectMan()){  %>
							<tr>
								<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_07.gif" width="178" height="3"/></td>
							</tr>
							<tr>
								<td height="24">
									<table width="178px" border="0" cellspacing="0" cellpadding="0" style="height: 28px">
										<tr>
											<td width="17"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle3.gif" width="11" height="12"/></td>
											<td width="78" class="bold">승인대기</td>
											<td width="36" align="right">
												<a href="#" onclick="fnOrderApprovalReadyCnt();" class="top"><span id="orderApprovalReadyCnt">0</span></a> 건
											</td>
											<td width="17">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
<%} %>
							<tr>
								<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_07.gif" width="178" height="3"/></td>
							</tr>
							<tr>
								<td height="24">
									<table width="178px" border="0" cellspacing="0" cellpadding="0" style="height: 28px">
										<tr>
											<td width="17"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle3.gif" width="11" height="12"/></td>
											<td width="78" class="bold">발주대기</td>
											<td width="36" align="right">
												<a href="#" onclick="fnOrderReadyCnt();" class="top"><span id="orderReadyCnt">0</span></a> 건
											</td>
											<td width="17">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_07.gif" width="178" height="3"/>
								</td>
							</tr>
							<tr>
								<td height="24">
									<table width="178px" border="0" cellspacing="0" cellpadding="0" style="height: 28px">
										<tr>
											<td width="17"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle3.gif" width="11" height="12"/></td>
											<td width="78" class="bold">발주접수대기</td>
											<td width="36" align="right">
												<a href="#" onclick="fnOrderReceiveCnt();" class="top"><span id="orderReceiveCnt">0</span></a> 건
											</td>
											<td width="17">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_07.gif" width="178" height="3"/>
								</td>
							</tr>
							<tr>
								<td height="24">
									<table width="178px" border="0" cellspacing="0" cellpadding="0" style="height: 28px">
										<tr>
											<td width="17"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle3.gif" width="11" height="12"/></td>
											<td width="78" class="bold">출하대기</td>
											<td width="36" align="right">
												<a href="#" onclick="fnDeliveryReadyCnt();" class="top"><span id="deliveryReadyCnt">0</span></a> 건
											</td>
											<td width="17">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_07.gif" width="178" height="3"/>
								</td>
							</tr>
							<tr>
								<td height="24">
									<table width="178px" border="0" cellspacing="0" cellpadding="0" style="height: 35px">
										<tr>
											<td width="17"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle3.gif" width="11" height="12"/></td>
											<td width="78" class="bold">배송중/<br/>인수대기<br/></td>
											<td width="36" align="right">
												<a href="#" onclick="fnReceiveReadyCnt();" class="top"><span id="receiveReadyCnt">0</span></a> 건
											</td>
											<td width="17">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_07.gif" width="178" height="3"/>
								</td>
							</tr>
							<tr>
								<td height="24">
									<table width="178px" border="0" cellspacing="0" cellpadding="0" style="height: 28px">
										<tr>
											<td width="17"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle3.gif" width="11" height="12"/></td>
											<td width="78" class="bold">인수완료</td>
											<td width="36" align="right">
												<a href="#" onclick="fnReceiveCnt();" class="top"><span id="receiveCnt">0</span></a> 건
											</td>
											<td width="17">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_07.gif" width="178" height="3"/>
								</td>
							</tr>
							<tr>
								<td height="24">
									<table width="178px" border="0" cellspacing="0" cellpadding="0" style="height: 28px">
										<tr>
											<td width="17"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle3.gif" width="11" height="12"/></td>
											<td width="78" class="bold">반품</td>
											<td width="36" align="right"></td>
											<td width="17">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td height="70" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_06.gif">
									<table width="178" border="0" cellspacing="0" cellpadding="0" style="height: 20px">
										<tr>
											<td width="17">&nbsp;</td>
											<td>반품요청</td>
											<td align="right">
<%if(!isBuilder){%>												
												<a href="#" onclick="fnBackRequestCnt();" class="top"><span id="backRequestCnt">0</span></a> 건
<%}else{%>
													<span id="backRequestCnt">0</span> 건
<%}%>
											</td>
											<td width="17">&nbsp;</td>
										</tr>
										</table>
										<table width="178" border="0" cellspacing="0" cellpadding="0" style="height: 20px">
											<tr>
												<td width="17">&nbsp;</td>
												<td>반품완료</td>
												<td align="right">
<%if(!isBuilder){%>												
													<a href="#" onclick="fnBackApprovalCnt();" class="top"><span id="backApprovalCnt">0</span></a> 건
<%}else{%>
													<span id="backApprovalCnt">0</span> 건
<%}%>
												</td>
												<td width="17">&nbsp;</td>
											</tr>
										</table>
										<table width="178" border="0" cellspacing="0" cellpadding="0" style="height: 20px">
											<tr>
												<td width="17">&nbsp;</td>
												<td>반품거부</td>
												<td align="right">
<%if(!isBuilder){%>												
													<a href="#" onclick="fnBackRejectCnt();" class="top"><span id="backRejectCnt">0</span></a> 건
<%}else{%>
													<span id="backRejectCnt">0</span> 건
<%}%>
												</td>
												<td width="17">&nbsp;</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
						<td width="17" valign="top" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_03_bg.gif"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_03.gif" width="17" height="<%if(!loginUserDto.isDirectMan()){ out.print("394");}else{out.print("361");}%>"/></td>
					</tr>
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_04.gif" width="212" height="17"/></td>
					</tr>
				</table>
			</td>	
			<td width="10" valign="top">&nbsp;</td>
			<td valign="top" >
				<table width="489" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_08.gif" width="489" height="12"/></td>
					</tr>
					<tr>
						<td width="14" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_09.gif')"></td>
						<td width="460">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr valign="top">
									<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle1.gif" width="14" height="15"/></td>
									<td height="29" class='ptitle' style="vertical-align: top;">사업장 현황</td>
								</tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="jqgrid">
											<table id="list1"></table>
										</div>
									</td>
								</tr>
							</table>
						</td>
						<td width="15" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_10.gif')"></td>
					</tr>
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_11.gif" width="489" height="20"/></td>
					</tr>
				</table>
				<table>
				<tr>
					<td height="7" ></td>
				</tr>
				</table>	
				<table width="489" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_08.gif" width="489" height="12"/></td>
					</tr>
					<tr>
						<td width="14" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_09.gif')"></td>
						<td width="460">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr valign="top">
									<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle1.gif" width="14" height="15"/></td>
									<td height="29" class='ptitle' style="vertical-align: top;">미정산 현황</td>
									<td style="font-size:11px; font-weight:bold; letter-spacing:-1px; color:#7A7A7A; padding-top:1px; padding:1px 0 0 1px;" align="right">
										<font color="red">* </font>발주금액 = 인수완료+미인수금액
									</td>
								</tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="jqgrid">
											<table id="list2"></table>
										</div>
									</td>
								</tr>
							</table>
						</td>
						<td width="15" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_10.gif');"></td>
					</tr>
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_11.gif" width="489" height="20"/></td>
					</tr>
				</table>
				<table>
				<tr>
					<td height="7" ></td>
				</tr>
				</table>	
				<table width="489" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_08.gif" width="489" height="12"/></td>
					</tr>
					<tr>
						<td width="14" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_09.gif')"></td>
						<td width="460">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr valign="top">
									<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle1.gif" width="14" height="15"/></td>
									<td height="29" class='ptitle' style="vertical-align: top;">세금계산서 내역</td>
									<td style="font-size:11px; font-weight:bold; letter-spacing:-1px; color:#7A7A7A; padding-top:1px; padding:1px 0 0 1px;"align="right">
										<font color="red">* </font>사업장 기준, VAT포함
									</td>
								</tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="jqgrid">
											<table id="list3"></table>
										</div>
									</td>
								</tr>
							</table>
						</td>
						<td width="15" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_10.gif');"></td>
					</tr>
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_11.gif" width="489" height="20"/></td>
					</tr>
				</table>
			</td>
			<td width="10">&nbsp;</td>
			<td valign="top" >
				<table width="489" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_08.gif" width="489" height="12"/></td>
					</tr>
					<tr>
						<td width="14" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_09.gif')"></td>
						<td width="460">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr valign="top">
									<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle1.gif" width="14" height="15"/></td>
									<td height="29" class='ptitle' style="vertical-align: top;">공지사항</td>
								</tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="jqgrid">
											<table id="list4"></table>
											<div id="pager4"></div>
										</div>
									</td>
								</tr>
							</table>
						</td>
						<td width="15" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_10.gif')"></td>
					</tr>
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_11.gif" width="489" height="20"/></td>
					</tr>
				</table>
				<table>
				<tr>
					<td height="7" ></td>
				</tr>
				</table>	
				<table width="489" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_08.gif" width="489" height="12"/></td>
					</tr>
					<tr>
						<td width="14" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_09.gif')"></td>
						<td width="460">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr valign="top">
									<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_ptitle1.gif" width="14" height="15"/></td>
									<td height="29" class='ptitle' style="vertical-align: top;">매입상품 TOP10</td>
									<td style="font-size:11px; font-weight:bold; letter-spacing:-1px; color:#7A7A7A; padding-top:1px; padding:1px 0 0 1px;" align="right">
										<font color="red">* </font>전월 1개월 기준 (세금 계산서 발행)
									</td>
								</tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="jqgrid">
											<table id="list5"></table>
										</div>
									</td>
								</tr>
							</table>
						</td>
						<td width="15" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_10.gif');"></td>
					</tr>
					<tr>
						<td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/mroMain_tbl_img_11.gif" width="489" height="20"/></td>
					</tr>
				</table>			
			</td>
		</tr>
	</table>
</form>
<form id="menuTransForm" name="menuTransForm" action="" target="self" method="post">
	<input type="hidden" id="_menuId" name="_menuId" value=""/>
	<input type="hidden" id="startDate" name="startDate" value=""/>
	<input type="hidden" id="endDate" name="endDate" value=""/>
	<input type="hidden" id="flag1" name="flag1" value=""/>
	<input type="hidden" id="flag2" name="flag2" value=""/>
</form>
<!-- 설문조사 팝업 처리 시작 -->
<div id="pollPop"></div>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script type="text/javascript">
$(function() {
    $.ajaxSetup ({
        cache: false
    });
    $('#pollPop').load('/board/poll/popup.sys');
});
</script>
<!-- 설문조사 팝업 처리 끝 -->
</body>
</html>