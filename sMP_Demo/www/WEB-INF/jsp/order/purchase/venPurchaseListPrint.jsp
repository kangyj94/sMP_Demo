<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%
	LoginUserDto lud = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	//발주서 날짜 세팅
	String startDate	= CommonUtils.getCustomDay("DAY", -7);
	String endDate		= CommonUtils.getCurrentDate();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
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
	$("#divPopup").jqm();
	
	
	<%-- 날짜 데이터 초기화--%> 	
	fnDateInit();
	
	<%-- 발주서 리스트--%>
	fnPurchaseListPrint();
	
	<%-- 엔터키이벤트 --%>
	$("#orderNumber, #srcBranchNm").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#startDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#endDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
});

<%-- 날짜 데이터 초기화--%> 
function fnDateInit() {
	$("#startDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#endDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}

<%-- 발주서 리스트--%>
function fnPurchaseListPrint(page){
	$.blockUI();
	$("#pager").empty();
	$(".purchasePrint").remove();
	
	var page			= page;
	var rows			= 10;
	var startDate		= $("#startDate").val();
	var endDate			= $("#endDate").val();
	var orderNumber		= $("#orderNumber").val();
	var srcBranchNm		= $("#srcBranchNm").val();
	$.post(
		"/venOrder/purchaseListPrint.sys",
		{
			startDate:startDate,
			endDate:endDate,
			orderNumber:orderNumber,
			srcBranchNm:srcBranchNm,
			page:page,
			rows:rows
		},
		function(arg){
			var list		= arg.list;
			var currPage	= arg.page;
			var rows		= arg.rows;
			var total		= arg.total;
			var records		= arg.records;
			var pageGrp		= Math.ceil(currPage/5);
			var startPage	= (pageGrp-1)*5+1;
			var endPage		= (pageGrp-1)*5+5;
			if(Number(endPage) > Number(total)){
				endPage = total;
			}
			if(records > 0){
				for(var i=0; i<list.length; i++){
					var str = "";
					str += "<tr id='purchasePrint_"+i+ "' class='purchasePrint'>";
					str += "<td class='br_l0'>"+list[i].WORKNM+"</td>";				//고객유형
					str += "<td align='center'>"+list[i].ORDE_IDEN_NUMB+"</td>";	//주문번호
					str += "<td>"+list[i].BRANCHNM+"</td>";			//구매사
					str += "<td align='center'>"+list[i].ORDE_USER_NAME+"</td>";	//주문자명
					str += "<td align='center'>"+list[i].REGI_DATE_TIME+"<br/>("+list[i].PURC_RECE_DATE+")</td>";	//주문일자
					str += "<td align='center'>"+list[i].ORDE_TYPE_CLAS+"</td>";	//주문유형
					str += "<td>"+list[i].TRAN_DATA_ADDR+"</td>";					//배송지주소
					var color = "black";
					if(list[i].IS_PURC_PRINT_BTN == "Y"){
						color = "#cccccc";
					}
					str += "<td align='center' >";
					str += "<button id='popOrdPurcBtn' class='btn btn-default btn-xs' onclick='fnPurcPrint(\""+list[i].ORDE_IDEN_NUMB+"\",\""+list[i].VENDORID+"\", \""+i+"\");'><font color='"+color+"' id='purcPrintBtn_"+i+"' >출력</font></button>";
					str += "</td>";
					str += "</tr>";
					$("#purchasePrintTable").append(str);
				}
				//페이징
				fnPager(startPage, endPage, currPage, total, 'fnPurchaseListPrint');	//페이져 호출 함수
				
			}else{
				$("#purchasePrintTable").append("<tr id='purchasePrint_0' class='purchasePrint'><td colspan='10' align='center' class='br_l0'>Data가 존재 하지 않습니다.</td></tr>");
			}
			$.unblockUI();
		},
		"json"
	);
}

<%-- 검색 --%>
function fnSearch(){
	fnPurchaseListPrint(1);
}

<%-- 발주서 출력 --%>
function fnPurcPrint(ordeIdenNumb, vendorId, index){
	var ordeIdenNumb	= ordeIdenNumb;
	var vendorid		= vendorId;
	$.post(
		"/venOrder/venPurcPrintBtn.sys",
		{
			ordeIdenNumb:ordeIdenNumb
			,vendorid:vendorid
		},
		function(arg){
			if($.parseJSON(arg).customResponse.success){
				$("#purcPrintBtn_"+index).css("color", "#cccccc");
				
                ordeIdenNumb		= ordeIdenNumb.substring(0,13);
                var oReport			= GetfnParamSet(); // 필수
                oReport.rptname = "purcPrint"; // reb 파일이름
                oReport.param("orde_iden_numb").value	= ordeIdenNumb; // 매개변수 세팅
                oReport.param("vendorid").value 		= vendorid;
                oReport.title = "발주확인출력"; // 제목 세팅
                oReport.open();
			}else{
				alert("처리중 오류가 발생하였습니다.");
			}
		}
	);
	
	
}
</script>
</head>

<body class="subBg">
<div id="divWrap">
	<!--header-->
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
	<!--//header-->
	<hr>
		<div id="divBody">
			<div id="divSub">
				<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">발주서</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-30px;">
						<a href="#" onclick="fnSearch();"><img src="/img/contents/btn_tablesearch.gif" /></a>
					</div>
					<table class="InputTable">
						<colgroup>
							<col width="100px" />
							<col width="auto" />
							<col width="100px" />
							<col width="auto" />
							<col width="100px" />
							<col width="auto" />
						</colgroup>
						<tr>
							<th>주문번호</th>
							<td><input type="text" id="orderNumber"name="orderNumber" style="width:200px;"/></td>
							<th>발주접수일</th>
							<td>
								<input type="text" id="startDate" name="startDate" style="width:80px;" value="<%=startDate%>"/>
								~
								<input type="text" id="endDate" name="endDate" style="width:80px;" value="<%=endDate%>"/>
							</td>
							<th>구매사명</th>
							<td><input type="text" id="srcBranchNm"name="srcBranchNm" style="width:200px;"/></td>
						</tr>
					</table>
					<div class="Ar mgt_20">
						* 발주서 출력 이후에는 회색으로 변경됩니다.
						<div class="ListTable mgt_5">
							<table id="purchasePrintTable">
								<colgroup>
									<col width="100px" />
									<col width="120px" />
									<col width="100px" />
									<col width="60px" />
									<col width="140px" />
									<col width="60px" />
									<col width="auto" />
									<col width="50px" />
								</colgroup>
								<tr>
									<th class="br_l0">고객유형</th>
									<th>주문번호</th>
									<th>구매사명</th>
									<th>주문자명</th>
									<th>주문일<br/>(발주접수일)</th>
									<th>주문유형</th>
									<th>배송지주소</th>
									<th>출력</th>
								</tr>
							</table>
						</div>
						<div id="pager" class="divPageNum" >
						</div>
					</div>
				</div>
			<!--컨텐츠(E)-->
			</div>
		</div>
	<hr>
</div>
</body>
</html>