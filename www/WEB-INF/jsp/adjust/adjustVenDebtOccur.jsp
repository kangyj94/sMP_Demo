<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.adjust.dto.AdjustDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	String _menuId = request.getParameter("_menuId")==null ? "" : (String)request.getParameter("_menuId");
	if("".equals(_menuId)) _menuId = request.getAttribute("_menuId")==null ? "" : (String)request.getAttribute("_menuId");

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");

	LoginUserDto loginUserDetail = (LoginUserDto)request.getSession().getAttribute(Constances.SESSION_NAME);

	int EndYear   = 2009;
	int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
	int yearCnt = StartYear - EndYear + 1;
	String[] srcYearArr = new String[yearCnt];
	for(int i = 0 ; i < yearCnt ; i++){
		srcYearArr[i] = (StartYear - i) + "";
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
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




<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>


<body class="subBg">
  <div id="divWrap">
  	<!-- header -->
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
  	<!-- /header -->
    <hr>
		<div id="divBody">
        	<div id="divSub">
            	<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
            	<!--카테고리(S)-->
			
<form id="ebillPopFrm" name="ebillPopFrm" onsubmit="return false;">
	<input id="pubCode" name="pubCode" type="hidden"/>
	<input id="docType" name="docType" type="hidden" value="T"/>
	<input id="userType" name="userType" type="hidden" value="S"/>
</form>
				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">발생채권별 현황</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-30px;"><a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a></div>
					<table class="InputTable">
						<colgroup>
							<col width="100px" />
							<col width="450px" />
							<col width="100px" />
							<col width="auto" />
						</colgroup>
						<tr>
							<th>조회기간</th>
							<td>
								<select id="srcClosStartYear" name="srcClosStartYear" class="select" style="width: 70px;">
<%
   for (int i = 0; i < srcYearArr.length; i++) {
%>
									<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", -12).split("-")[0].equals(srcYearArr[i]) ? "selected" : ""%>><%=srcYearArr[i]%></option>
<%
	}
%>
								</select> 년 
								<select id="srcClosStartMonth" name="srcClosStartMonth" class="select" style="width: 50px;">
<%
	for (int i = 0; i < 12; i++) {
%>
									<option value='<%=i + 1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=i + 1%></option>
<%
	}
%>
								</select> 월 ~ 
								<select id="srcClosEndYear" name="srcClosEndYear" class="select" style="width: 70px;">
<%
	for (int i = 0; i < srcYearArr.length; i++) {
%>
									<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : ""%>><%=srcYearArr[i]%></option>
<%
	}
%>
								</select> 년 
								<select id="srcClosEndMonth" name="srcClosEndMonth" class="select" style="width: 50px;">
<%
	for (int i = 0; i < 12; i++) {
%>
									<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
<%
	}
%>
								</select> 월
							</td>
							<th>잔액여부</th>
							<td>
								<select id="srcPayStat" name="srcPayStat" class="select">
									<option value="">전체</option>
									<option value="10">있음</option>
									<option value="20">없음</option>
								</select>
							</td>
						</tr>
					</table>
				
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td bgcolor="#FFFFFF">
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr style="height: 5px;"><td></td></tr>
									<tr>
										<td>
											<div id="jqgrid">
												<table id="list"></table>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table> 
					<div style="height:10px;"></div>
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
</body>

<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcButton").click(function(){fnSearch();});
});

</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">

jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/venAdjust/adjustVenDebtCompanyListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['vendorId','buyi_sequ_numb','전표번호','계산서일자','총채권','지급완료일자','지급액','잔액','거래명세서','buyi_sequ_numb'],
		colModel:[
			{name:'vendorId', index:'vendorId',width:120,align:"center",search:false,sortable:true, editable:false ,hidden:true},
			{name:'buyi_sequ_numb', index:'buyi_sequ_numb',width:130,align:"center",search:false,sortable:true, editable:false ,hidden:true},
			{name:'sap_jour_numb', index:'sap_jour_numb',width:130,align:"center",search:false,sortable:true, editable:false, hidden:true },//전표번호
			{name:'clos_buyi_date', index:'clos_buyi_date',width:140,align:"center",search:false,sortable:true, editable:false },//계산서일자
			{name:'buyi_tota_amou', index:'buyi_tota_amou',width:140,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//총채무
			{name:'buyi_pay_date',index:'buyi_pay_date',width:140,align:"center",search:false,sortable:true, editable:false, hidden:true },//지금완료일자
			{name:'rece_pay_amou',index:'rece_pay_amou',width:140,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//금액
			{name:'none_paym_amou',index:'none_paym_amou',width:140,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//잔액
			{name:'ePay',index:'ePay', width:80,align:"center",search:false,sortable:false,editable:false},
			{name:'buyi_sequ_numb',index:'buyi_sequ_numb',hidden:true}
		],
		postData: {
			vendorId:'<%=loginUserDetail.getSmpVendorsDto().getVendorId()%>',
			srcPayStat:$("#srcPayStat").val(),       
			srcClosStartYear:$("#srcClosStartYear").val(), 
			srcClosStartMonth:$("#srcClosStartMonth").val(), 
			srcClosEndYear:$("#srcClosEndYear").val(),   
			srcClosEndMonth:$("#srcClosEndMonth").val()   
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], 
		height:425, autowidth: true,
		sortname: 'clos_buyi_date', sortorder: 'desc', 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var sum_buyi_tota_amou = 0;
			var sum_rece_pay_amou = 0;
			var sum_none_paym_amou = 0;
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					sum_buyi_tota_amou += parseInt(selrowContent.buyi_tota_amou);
					sum_rece_pay_amou += parseInt(selrowContent.rece_pay_amou);
					sum_none_paym_amou += parseInt(selrowContent.none_paym_amou);  
					
					var ePayStr   = "<a href='#'><img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick=\"javaScript:fnEPay('"+rowid+"')\"/></a>";
					jq("#list").jqGrid('setRowData', rowid, {ePay:ePayStr});
				}
			}	
			var userData = jq("#list").jqGrid("getGridParam","userData");
			userData.clos_buyi_date = "합계";
			userData.buyi_tota_amou = fnComma(sum_buyi_tota_amou);
			userData.buyi_tota_amou = fnComma(sum_buyi_tota_amou);
			userData.rece_pay_amou = fnComma(sum_rece_pay_amou);
			userData.none_paym_amou = fnComma(sum_none_paym_amou);
			jq("#list").jqGrid("footerData","set",userData,false);   
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt > 0) {
				var id = $("#list").jqGrid('getGridParam', "selrow" );
				var selrowContent = jq("#list").jqGrid('getRowData',id);
				$("#sel_buyi_sequ_numb").val(selrowContent.buyi_sequ_numb);
				$("#sel_buyi_tota_amou").val(selrowContent.buyi_tota_amou);
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",records: "records",repeatitems: false,cell: "cell", userdata:"userdata" },
		rownumbers:true,
		footerrow: true,
		userDataOnFooter: true
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
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

function fnSearch(){
	jq("#list").jqGrid("setGridParam");
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcPayStat      = $("#srcPayStat").val();
	data.srcClosStartYear   = $("#srcClosStartYear").val(); 
	data.srcClosStartMonth  = $("#srcClosStartMonth").val();
	data.srcClosEndYear     = $("#srcClosEndYear").val();
	data.srcClosEndMonth    = $("#srcClosEndMonth").val();
	data.vendorId        = '<%=loginUserDetail.getSmpVendorsDto().getVendorId()%>'; 
	jq("#list").trigger("reloadGrid");     	
}

function fnEPay(rowid){
	
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
	var skCoNm      = '<%=Constances.EBILL_CONAME%>';
	var skBizNo		= '<%=Constances.EBILL_COREGNO%>';
	var skCeoNm 	= '<%=Constances.EBILL_COCEO%>';
	var skAddr  	= '<%=Constances.EBILL_COADDR%>';
	var skBizType	= '<%=Constances.EBILL_COBIZTYPE%>';
	var skBizSub	= '<%=Constances.EBILL_COBIZSUB%>';
	var buyiSequNumb= selrowContent.buyi_sequ_numb;
	
	<%
		String prodSpec = "";
		for(int i = 0 ; i < Constances.PROD_GOOD_SPEC.length ; i++){
			if(i == 0) 	prodSpec = Constances.PROD_GOOD_SPEC[i];
			else		prodSpec += "‡" + Constances.PROD_GOOD_SPEC[i];
		}
        
        String prodStSpec = "";
        for(int i = 0 ; i < Constances.PROD_GOOD_ST_SPEC.length ; i++){
            if(i == 0)  prodStSpec = Constances.PROD_GOOD_ST_SPEC[i];
            else        prodStSpec += "‡" + Constances.PROD_GOOD_ST_SPEC[i];
        }                
	%>
	
	var prodSpec	= '<%=prodSpec%>';
	var prodStSpec	= '<%=prodStSpec%>';
	var oReport = GetfnParamSet(); // 필수
	oReport.rptname = "VenParticulars"; // reb 파일이름
	
	oReport.param("skCoNm").value 		= skCoNm;
	oReport.param("skBizNo").value 		= skBizNo;
	oReport.param("skCeoNm").value 		= skCeoNm;
	oReport.param("skAddr").value 		= skAddr;
	oReport.param("skBizType").value 	= skBizType;
	oReport.param("skBizSub").value 	= skBizSub;

	oReport.param("buyiSequNumb").value = buyiSequNumb;
	oReport.param("prodSpec").value 	= prodSpec;
	oReport.param("prodStSpec").value 	 	 = prodStSpec;
	
	oReport.title = "거래명세서"; // 제목 세팅
	oReport.open();		
}

</script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
</html>